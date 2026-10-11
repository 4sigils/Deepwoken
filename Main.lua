local IGNORE_URL = "https://raw.githubusercontent.com/4sigils/Deepwoken/refs/heads/main/IgnoredAnimations.lua"
local DATA_URL   = "https://raw.githubusercontent.com/4sigils/Deepwoken/refs/heads/main/Animations.lua"

local LOGO_URL = "https://cdn.discordapp.com/attachments/1402876855840804895/1558405775167201400/noFilter_1.png?ex=6acb51fa&is=6aca007a&hm=8ff9153ff0a850fa34512fbe989660978c0583fa43b6a417caac6a61de7189fd&"
-- Embedded 4x4 black PNG (no download, no 1920x1080 texture to decode and draw every frame)
local BG_IMG   = "\137\080\078\071\013\010\026\010\000\000\000\013\073\072\068\082\000\000\000\004\000\000\000\004\008\006\000\000\000\169\241\158\126\000\000\000\079\073\068\065\084\120\001\001\068\000\187\255\000\000\000\000\255\000\000\000\255\000\000\000\255\000\000\000\255\000\000\000\000\255\000\000\000\255\000\000\000\255\000\000\000\255\000\000\000\000\255\000\000\000\255\000\000\000\255\000\000\000\255\000\000\000\000\255\000\000\000\255\000\000\000\255\000\000\000\255\006\090\015\241\170\028\251\110\000\000\000\000\073\069\078\068\174\066\096\130"

local KEY_PARRY  = 0x46 -- F
local KEY_DODGE  = 0x51 -- Q
local KEY_JUMP   = 0x20 -- Space
local KEY_CROUCH = 0xA2 -- Left Ctrl

-- All animation timings in the data file are tuned for roughly this ping (ms).
local BASE_PING = 60

local SCAN_INTERVAL = 0.018
local HIST_SLOTS = 10

-- NEXA UI LOADER
local NEXA_SOURCE = "https://raw.githubusercontent.com/OgTen/Nexa-UI/refs/heads/main/nexa-ui.lua"

local function isNexaLibrary(value)
    return type(value) == "table"
        and type(value.CreateWindow) == "function"
        and type(value.AddTab) == "function"
        and type(value.Notify) == "function"
end

local function findExportedNexa()
    local env = type(getgenv) == "function" and getgenv() or nil
    local candidates = {}
    if env then
        candidates[#candidates + 1] = env.Nexa
        candidates[#candidates + 1] = env.UI
        candidates[#candidates + 1] = env.DrawingUI
    end
    candidates[#candidates + 1] = rawget(_G, "Nexa")
    candidates[#candidates + 1] = rawget(_G, "UI")
    candidates[#candidates + 1] = rawget(_G, "DrawingUI")
    if type(shared) == "table" then
        candidates[#candidates + 1] = shared.Nexa
        candidates[#candidates + 1] = shared.UI
        candidates[#candidates + 1] = shared.DrawingUI
    end
    for _, candidate in ipairs(candidates) do
        if isNexaLibrary(candidate) then return candidate end
    end
    return nil
end

local function getNexa()
    local old = findExportedNexa()
    if old then pcall(function() old:Destroy() end) end

    if type(loadstring) ~= "function" then
        error("[Deepwoken] This environment does not provide loadstring.")
    end

    local okHttp, source = pcall(function() return game:HttpGet(NEXA_SOURCE) end)
    if not okHttp then error("[Deepwoken] Failed to download Nexa: " .. tostring(source)) end
    if type(source) ~= "string" or #source < 100 then
        error("[Deepwoken] Nexa download returned invalid/empty source.")
    end

    local islandPatch = [[local function DrawTitleBar(title, subtitle)
    local th = State.Theme]]
    local islandReplacement = [[local function DrawTitleBar(title, subtitle)
    if not State.Open then
        if State.ProfileAvatar and State.ProfileAvatar.Image then
            pcall(function() State.ProfileAvatar.Image.Visible = false end)
        end
        for _, action in ipairs(State.Island and State.Island.Actions or {}) do
            if action._IslandImage then
                pcall(function() action._IslandImage.Visible = false end)
            end
        end
        State.ProfileAvatarRect = nil
        return
    end
    local th = State.Theme]]
    if string.find(source, islandPatch, 1, true) then
        source = string.gsub(source, islandPatch, function()
            return islandReplacement
        end, 1)
    else
        warn("[Deepwoken] Nexa island visibility patch point not found; floating UI may remain visible.")
    end

    -- Notifications were drawn with the window's fade alpha, which is 0 while the menu is closed:
    -- the box and text vanished and only the (image) logo stayed visible. Draw them at full alpha.
    local patchedSource, notifPatches = string.gsub(source, "\n([ \t]*)DrawNotifications%(%)", function(indent)
        return "\n" .. indent .. "do local __pa = FrameAlpha FrameAlpha = 1 DrawNotifications() FrameAlpha = __pa end"
    end)
    if notifPatches > 0 then
        source = patchedSource
    else
        warn("[Deepwoken] Nexa notification patch point not found; notifications may only show the logo while the menu is closed.")
    end

    local chunk, compileError = loadstring(source)
    if not chunk then error("[Deepwoken] Nexa failed to compile: " .. tostring(compileError)) end

    local okRun, returned = pcall(chunk)
    if not okRun then error("[Deepwoken] Nexa failed while executing: " .. tostring(returned)) end

    if isNexaLibrary(returned) then return returned end
    local exported = findExportedNexa()
    if exported then return exported end

    error("[Deepwoken] Nexa executed, but no compatible Library API was exported.")
end

local Nexa = getNexa()

local Controls = {}
local ConfigDirty = false -- set whenever a registered control changes; the autosave loop only writes when this is true
local function Reg(flag, ctrl)
    Controls[flag] = ctrl
    ctrl:OnChanged(function() ConfigDirty = true end)
    return ctrl
end
local function Get(flag)
    local c = Controls[flag]
    if c then return c:GetValue() end
    return nil
end

-- MEMORY / OFFSETS
local offsets = game:GetService("HttpService"):JSONDecode(game:HttpGet("https://offsets.imtheo.lol/Offsets.json")).Offsets
local KnownOffsets = {
    AnimationId      = offsets.Misc.AnimationId,
    ClassDescriptor  = offsets.Instance.ClassDescriptor,
    ClassName        = offsets.Instance.ClassName,
    TimePosition     = offsets.AnimationTrack.TimePosition or 0xD8,
    ActiveAnimations = offsets.Animator.ActiveAnimations,
    NodeNext         = 0x10,
}
local OFF_ANIM = offsets.AnimationTrack.Animation

local function ReadPointer(addr)
    local ok, v = pcall(memory_read, "uintptr_t", addr)
    if ok and v and v > 4096 then return v end
    return nil
end

local function ReadString(addr)
    if not addr or addr <= 4096 then return nil end
    local ok, s = pcall(memory_read, "string", addr)
    return ok and s or nil
end

local function GetClassName(addr)
    if not addr or addr <= 4096 then return "Invalid" end
    local desc = ReadPointer(addr + KnownOffsets.ClassDescriptor)
    if not desc then return "Error" end
    return ReadString(ReadPointer(desc + KnownOffsets.ClassName)) or "Unknown"
end

local function CleanId(id)
    return id and tostring(id):match("%d+")
end

-- ENEMIES
local Players = game:GetService("Players")

local function CleanName(name)
    return (tostring(name):gsub("^%.", ""))
end

local AnimCache, AnimCacheN = {}, 0
local AnimatorCache, AnimatorCacheN = {}, 0

local function GetAnimatorAddr(model)
    local key = model.Address
    local addr = AnimatorCache[key]
    if addr then return addr end

    local hum = model:FindFirstChild("Humanoid")
    local animator = hum and hum:FindFirstChild("Animator")
    if not animator then return nil end

    if AnimatorCacheN > 300 then AnimatorCache, AnimatorCacheN = {}, 0 end
    addr = animator.Address
    AnimatorCache[key] = addr
    AnimatorCacheN = AnimatorCacheN + 1
    return addr
end

local function GuildAttr(m) return m:GetAttribute("Guild") end
local function GetGuild(model)
    local ok, g = pcall(GuildAttr, model)
    if ok and type(g) == "string" and g ~= "" then return g end
    return nil
end

local Enemies, NextRefresh = {}, 0
local EnemyCache = {}
local LocalHRP = nil

local function BuildEntry(model)
    local hrp = model:FindFirstChild("HumanoidRootPart")
    local animator = hrp and GetAnimatorAddr(model)
    if not animator then return nil end
    local name = CleanName(model.Name)
    return {
        model = model,
        name = name,
        lname = string.lower(name),
        key = tostring(model.Address),
        hrp = hrp,
        animator = animator,
        isPlayer = Players:FindFirstChild(name) ~= nil,
        skipUntil = 0,
        guildAt = 0,
    }
end

local function RefreshEnemies(now)
    local list, nextCache = {}, {}
    local lp = Players.LocalPlayer
    LocalHRP = lp and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") or nil

    local live = workspace:FindFirstChild("Live")
    if not live then Enemies, EnemyCache = list, nextCache return end

    local myName = lp and lp.Name
    for _, model in ipairs(live:GetChildren()) do
        local addr = model.Address
        local cached = EnemyCache[addr]
        if cached and cached.dead and now < cached.retryAt then
            nextCache[addr] = cached
        else
            local entry = (cached and not cached.dead and not cached.stale) and cached or BuildEntry(model)
            if entry then
                nextCache[addr] = entry
                -- guilds rarely change, so only re-read them every few seconds
                if entry.isPlayer and now >= entry.guildAt then
                    entry.guildAt = now + 5
                    local plr = Players:FindFirstChild(entry.name)
                    entry.guild = plr and GetGuild(plr) or nil
                end
                if entry.name ~= myName then list[#list + 1] = entry end
            else
                nextCache[addr] = {dead = true, retryAt = now + 3}
            end
        end
    end
    Enemies, EnemyCache = list, nextCache
end

local function DistFn(a, b) return (a.Position - b.Position).Magnitude end
local function Dist(enemy)
    if not LocalHRP then return math.huge end
    local ok, d = pcall(DistFn, LocalHRP, enemy.hrp)
    return ok and d or math.huge
end

local function DistanceToModel(model)
    local lp   = Players.LocalPlayer
    local mine = lp and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
    local theirs = model and model:FindFirstChild("HumanoidRootPart")
    if not mine or not theirs then return math.huge end
    return (mine.Position - theirs.Position).Magnitude
end

local function GetPlayingAnims(enemy)
    local out = {}
    local addr = enemy.animator or GetAnimatorAddr(enemy.model)
    if not addr then return out end

    local listHead = ReadPointer(addr + KnownOffsets.ActiveAnimations)
    if not listHead then
        AnimatorCache[enemy.model.Address] = nil
        enemy.stale = true
        return out
    end

    local node, count = ReadPointer(listHead), 0
    while node and node ~= listHead and count < 50 do
        count = count + 1
        local track = ReadPointer(node + KnownOffsets.NodeNext)
        local anim = track and ReadPointer(track + OFF_ANIM)
        if anim then
            local id = AnimCache[anim]
            if id == nil then
                id = false
                if GetClassName(anim) == "Animation" then
                    id = CleanId(ReadString(ReadPointer(anim + KnownOffsets.AnimationId))) or false
                end
                if AnimCacheN > 800 then AnimCache, AnimCacheN = {}, 0 end
                AnimCache[anim] = id
                AnimCacheN = AnimCacheN + 1
            end
            if id then
                local ok, t = pcall(memory_read, "float", track + KnownOffsets.TimePosition)
                local good = ok and type(t) == "number" and t == t and t >= 0 and t < 30
                out[#out + 1] = {id = id, elapsed = good and t or 0, track = track}
            end
        end
        node = ReadPointer(node)
    end
    return out
end

local function IsAnimAlive(model, id)
    if not model or not id then return false end
    for _, anim in ipairs(GetPlayingAnims({model = model})) do
        if anim.id == id then return true end
    end
    return false
end

local Releases = {}
local function PressKey(vk, holdSeconds)
    local ok = pcall(keypress, vk)
    if not ok then
        print("[Deepwoken] keypress() failed - your executor may name it differently")
        return
    end
    Releases[#Releases + 1] = {at = os.clock() + (holdSeconds or 0.05), vk = vk}
end

local function HttpGet(url)
    local attempts = {
        function() return game:HttpGet(url) end,
        function()
            local req = request or http_request or (syn and syn.request)
            local res = req and req({Url = url, Method = "GET"})
            return res and res.Body
        end,
    }
    for _, try in ipairs(attempts) do
        local ok, body = pcall(try)
        -- GitHub returns the literal text "404: Not Found" for bad URLs; don't treat that as data
        if ok and type(body) == "string" and #body > 0 and not body:match("^%s*404:") then
            return body
        end
    end
    return nil
end

-- PING
-- Matcha provides its own global GetPingValue(). Grab it here, BEFORE the local GetPingValue below is
-- declared, otherwise the local shadows it and the native function is never called.
local NativeGetPingValue = GetPingValue
if type(NativeGetPingValue) ~= "function" and type(getgenv) == "function" then
    local ok, fn = pcall(function() return getgenv().GetPingValue end)
    if ok and type(fn) == "function" then NativeGetPingValue = fn end
end
if type(NativeGetPingValue) ~= "function" then NativeGetPingValue = nil end

local PingMethod = "none"
local PingError = nil

local function ValidPing(v)
    return type(v) == "number" and v == v and v > 0 and v < 10000
end

-- tried in order until one returns a usable number (executors differ in what they expose)
local PING_METHODS = {
    { "native GetPingValue", function()
        if not NativeGetPingValue then error("no native GetPingValue global") end
        return NativeGetPingValue()
    end },
    { "Data Ping", function()
        return game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()
    end },
    { "Data Ping (string)", function()
        local s = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString()
        return tonumber(tostring(s):match("[%d%.]+"))
    end },
    { "PerformanceStats.Ping", function()
        return game:GetService("Stats").PerformanceStats.Ping:GetValue()
    end },
    -- Matcha-style access: FindFirstChild + property read instead of method calls
    { "FindFirstChild .Value", function()
        local stats = game:GetService("Stats")
        local net = stats:FindFirstChild("Network")
        local sItem = net and net:FindFirstChild("ServerStatsItem")
        local item = sItem and sItem:FindFirstChild("Data Ping")
        return item and item.Value
    end },
    { "FindFirstChild GetValue", function()
        local stats = game:GetService("Stats")
        local net = stats:FindFirstChild("Network")
        local sItem = net and net:FindFirstChild("ServerStatsItem")
        local item = sItem and sItem:FindFirstChild("Data Ping")
        return item and item:GetValue()
    end },
    { "PerformanceStats .Value", function()
        local item = game:GetService("Stats").PerformanceStats:FindFirstChild("Ping")
        return item and item.Value
    end },
    { "GetNetworkPing", function()
        return Players.LocalPlayer:GetNetworkPing() * 1000
    end },
}

local function GetPingMs()
    local errs = {}
    for _, method in ipairs(PING_METHODS) do
        local ok, v = pcall(method[2])
        if ok and ValidPing(v) then
            PingMethod, PingError = method[1], nil
            return v
        end
        errs[#errs + 1] = method[1] .. ": " .. tostring(ok and ("returned " .. tostring(v)) or v)
    end
    PingMethod, PingError = "none", table.concat(errs, "\n[Deepwoken]   ")
    return nil
end

local function GetPingValue()
    return GetPingMs()
end

local function PingToComp(ping)
    local comp = math.floor(ping - BASE_PING + 0.5)
    return math.max(-BASE_PING, math.min(300, comp))
end

-- AUTO PING COMP (same idea as the Auto Green script: live ping, smoothed with a 0.25 factor,
-- compensate the one-way trip = ping / 2, and no compensation at all under 25 ms)
local AutoPing = { smoothing = 0.25, min = 25, max = 300, smooth = nil, at = 0, comp = 0 }

local function UpdateAutoPing(now)
    if now - AutoPing.at < 0.2 then return end
    local raw = GetPingMs()
    if not raw then return end

    if AutoPing.smooth == nil or now - AutoPing.at > 1.5 then
        AutoPing.smooth = raw -- first sample or a long gap: start fresh
    else
        AutoPing.smooth = AutoPing.smooth + (raw - AutoPing.smooth) * AutoPing.smoothing
    end
    AutoPing.at = now

    if AutoPing.smooth < AutoPing.min then
        AutoPing.comp = 0
    else
        AutoPing.comp = math.min(AutoPing.smooth / 2, AutoPing.max)
    end
end

-- ms to fire earlier: automatic when "Auto Ping Comp" is on, otherwise the Ping Comp slider
local function GetPingComp()
    local auto = Controls.sb_t_autoping
    if auto and auto.Value then
        UpdateAutoPing(os.clock())
        return AutoPing.comp
    end
    return Get("sb_t_ping") or 0
end

-- STATE
local AnimDB      = {}
local Active      = {}
local Queue       = {}
local Status      = {loaded = 0, ignored = 0, tracked = 0, last = "none", lastDist = 0, loopMs = 0, scanMs = 0, ping = 0}

local function Log(msg) print("[Deepwoken] " .. tostring(msg)) end

-- ANIMATION DATA
-- Entry formats: number | { t1, t2 } | { type = "parry", t = {..}, unparryable = true } | { { type = "jump", t = 0.4 }, ... }
-- types: parry, dodge (dodge-only, always Q), unparryable (Q, or F with "Parry Unparryables"), jump, crouch

local function ParseLua(src)
    local pos, len = 1, #src
    local parseValue

    local function skip()
        while pos <= len do
            local _, ws = src:find("^%s+", pos)
            if ws then pos = ws + 1 end
            if src:sub(pos, pos + 1) == "--" then
                local lvl = src:match("^%-%-%[(=*)%[", pos)
                if lvl then
                    local _, e = src:find("]" .. lvl .. "]", pos, true)
                    pos = e and e + 1 or len + 1
                else
                    local nl = src:find("\n", pos, true)
                    pos = nl and nl + 1 or len + 1
                end
            elseif not ws then
                break
            end
        end
    end

    local function parseTable()
        pos = pos + 1
        local t, n = {}, 0
        while pos <= len do
            skip()
            local c = src:sub(pos, pos)
            if c == "}" then pos = pos + 1 break end
            if c == "" then break end

            if c == "[" then
                pos = pos + 1
                local k = parseValue()
                skip(); pos = pos + 1
                skip(); pos = pos + 1
                t[k] = parseValue()
            else
                local name = src:match("^([%a_][%w_]*)%s*=", pos)
                if name then
                    pos = pos + #name
                    skip(); pos = pos + 1
                    t[name] = parseValue()
                else
                    n = n + 1
                    t[n] = parseValue()
                end
            end

            skip()
            local sep = src:sub(pos, pos)
            if sep == "," or sep == ";" then pos = pos + 1 end
        end
        return t
    end

    parseValue = function()
        skip()
        local c = src:sub(pos, pos)
        if c == "{" then return parseTable() end
        if c == '"' or c == "'" then
            local e = src:find(c, pos + 1, true) or len
            local s = src:sub(pos + 1, e - 1)
            pos = e + 1
            return s
        end
        local num = src:match("^-?[%d%.]+", pos)
        if num then pos = pos + #num return tonumber(num) end
        local word = src:match("^[%a_][%w_]*", pos)
        if word then
            pos = pos + #word
            if word == "true" then return true end
            if word == "false" then return false end
            return nil
        end
        pos = pos + 1
        return nil
    end

    skip()
    if src:match("^return", pos) then pos = pos + 6 end
    return parseValue()
end

local function Normalize(v)
    local actions = {}
    local function add(kind, t, unparryable)
        if type(t) == "table" then
            for _, x in ipairs(t) do add(kind, x, unparryable) end
        elseif type(t) == "number" then
            local k = string.lower(tostring(kind))
            if unparryable and k ~= "dodge" then k = "unparryable" end
            actions[#actions + 1] = {kind = k, t = t}
        end
    end

    if type(v) == "number" then
        add("parry", v)
    elseif type(v) == "table" then
        if v.type or v.t then
            add(v.type or "parry", v.t, v.unparryable)
        else
            for _, item in ipairs(v) do
                if type(item) == "number" then
                    add("parry", item)
                elseif type(item) == "table" then
                    add(item.type or "parry", item.t, item.unparryable)
                end
            end
        end
    end
    return #actions > 0 and actions or nil
end

local function LoadData()
    AnimDB = {}
    Status.loaded = 0

    local src = HttpGet(DATA_URL)
    if not src then
        Log("Failed to download anim data from " .. DATA_URL)
        return
    end

    local data
    if type(loadstring) == "function" then
        local fn = loadstring(src)
        if fn then
            local ok, res = pcall(fn)
            if ok and type(res) == "table" then data = res end
        end
    end
    if not data then
        local ok, res = pcall(ParseLua, src)
        if ok and type(res) == "table" then data = res end
    end
    if not data then
        Log("Could not read anim data. First 80 chars: " .. src:sub(1, 80))
        return
    end

    local n = 0
    for id, value in pairs(data) do
        local actions = Normalize(value)
        if actions then
            local clean = CleanId(id) or tostring(id)
            AnimDB[clean] = {name = clean, actions = actions}
            n = n + 1
        end
    end
    Status.loaded = n
    Log("Loaded " .. n .. " animations")
end

-- IGNORED ANIMS
local IgnoredIds = {}

local function LoadIgnored()
    IgnoredIds = {}

    local src = HttpGet(IGNORE_URL)
    if not src then
        Log("Failed to download ignore list from " .. IGNORE_URL)
        return
    end

    for line in src:gmatch("[^\r\n]+") do
        line = line:gsub("%-%-.*$", "")
        for id in line:gmatch("%d+") do IgnoredIds[id] = true end
    end

    local n = 0
    for _ in pairs(IgnoredIds) do n = n + 1 end
    Status.ignored = n
    Log("Ignoring " .. n .. " animations")
end

-- WINDOW
Nexa:CreateWindow({
    Title = "Deepwoken",
    Subtitle = "Tungity Tungity Sahurity",
    GameName = "Tungity Tungity Sahurity",
    Width = 860,
    Height = 610,
    Theme = "Obsidian",
    Background = "none",
    Opacity = 100,
    MenuKey = "p",
    Logo = LOGO_URL,
    BackgroundImage = BG_IMG,
    Splash = { Image = LOGO_URL },
    ShowLogo = LOGO_URL ~= nil,
    ShowGameName = true,
    IslandExpanded = true,
})

-- UI performance defaults (turn back on via the island icons / Settings tab if you want them)
do
    local S = Nexa.State
    S.Settings.KeybindOverlay = false
    S.Settings.PerformanceOverlay = false

    local settingsTab = Nexa:GetTab("Settings")
    if settingsTab then
        for _, row in ipairs(settingsTab.Rows or {}) do
            for _, ctrl in ipairs(row.Rows or {}) do
                if ctrl.Title == "Border animation" and ctrl.SetValue then ctrl:SetValue(false) end
            end
        end
    end
end

local mainTab       = Nexa:AddTab({ Title = "Auto Parry", Icon = "shield", Select = true })
local automationTab = Nexa:AddTab({ Title = "Automation", Icon = "zap" })
local visualsTab    = Nexa:AddTab({ Title = "Visuals", Icon = "eye" })
local miscTab       = Nexa:AddTab({ Title = "Misc", Icon = "layers" })
local trackerTab    = Nexa:AddTab({ Title = "Tracker", Icon = "crosshair" })
local whitelistTab  = Nexa:AddTab({ Title = "Whitelists", Icon = "users" })
local debugTab      = Nexa:AddTab({ Title = "Debug", Icon = "search" })

-- FRIEND EXCLUSIONS
local HttpService = game:GetService("HttpService")
local FRIENDS_FILE = "Deepwoken_ExcludedFriends.json"
local IgnoredFriends = {}

local function LoadIgnoredFriends()
    if type(readfile) ~= "function" or type(isfile) ~= "function" then return end
    local ok, raw = pcall(function()
        if isfile(FRIENDS_FILE) then return readfile(FRIENDS_FILE) end
    end)
    if not ok or type(raw) ~= "string" or raw == "" then return end
    local good, decoded = pcall(function() return HttpService:JSONDecode(raw) end)
    if good and type(decoded) == "table" then
        IgnoredFriends = {}
        for _, name in ipairs(decoded) do
            if type(name) == "string" then IgnoredFriends[name] = true end
        end
    end
end

local function SaveIgnoredFriends()
    if type(writefile) ~= "function" then
        Nexa:Notify({ Title = "Friends", Content = "This executor does not support saving files.", Type = "warning", Duration = 3 })
        return
    end
    local names = {}
    for name in pairs(IgnoredFriends) do names[#names + 1] = name end
    table.sort(names)
    local ok = pcall(function() writefile(FRIENDS_FILE, HttpService:JSONEncode(names)) end)
    Nexa:Notify({ Title = "Friends", Content = ok and ("Saved " .. #names .. " excluded name(s).") or "Could not save friend list.", Type = ok and "success" or "error", Duration = 3 })
end

LoadIgnoredFriends()

-- lower-cased lookup; enemies carry a pre-lowered name (lname) so the scan never allocates strings
local FriendsLower = {}
local function RebuildFriendsLower()
    FriendsLower = {}
    for name in pairs(IgnoredFriends) do FriendsLower[string.lower(name)] = true end
end
RebuildFriendsLower()

local GUILDS_FILE = "Deepwoken_ExcludedGuilds.json"
local IgnoredGuilds = {}

local function LoadIgnoredGuilds()
    if type(readfile) ~= "function" or type(isfile) ~= "function" then return end
    local ok, raw = pcall(function()
        if isfile(GUILDS_FILE) then return readfile(GUILDS_FILE) end
    end)
    if not ok or type(raw) ~= "string" or raw == "" then return end
    local good, decoded = pcall(function() return HttpService:JSONDecode(raw) end)
    if good and type(decoded) == "table" then
        IgnoredGuilds = {}
        for _, name in ipairs(decoded) do
            if type(name) == "string" then IgnoredGuilds[name] = true end
        end
    end
end

local function SaveIgnoredGuilds()
    if type(writefile) ~= "function" then return end
    local names = {}
    for name in pairs(IgnoredGuilds) do names[#names + 1] = name end
    table.sort(names)
    pcall(function() writefile(GUILDS_FILE, HttpService:JSONEncode(names)) end)
end

LoadIgnoredGuilds()

-- WHITELISTS TAB: FRIENDS
local friendsSec = whitelistTab:AddSection("Friends", "Selected players will never be tracked by auto-parry.", { Column = "left" })
local friendsDropdown
local function GetPlayerNames()
    local found, names = {}, {}
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= Players.LocalPlayer then
            found[player.Name] = true
        end
    end
    for name in pairs(IgnoredFriends) do found[name] = true end
    for name in pairs(found) do names[#names + 1] = name end
    table.sort(names, function(a, b) return string.lower(a) < string.lower(b) end)
    return names
end
local function GetIgnoredFriendNames()
    local names = {}
    for name in pairs(IgnoredFriends) do names[#names + 1] = name end
    table.sort(names)
    return names
end
local function RefreshFriendDropdown()
    local options = GetPlayerNames()
    if #options == 0 then options = {"No other players"} end
    if friendsDropdown then
        friendsDropdown.Options = options
        friendsDropdown._listScroll = 0
        friendsDropdown._listScrollTo = 0
        local selected = {}
        for _, name in ipairs(GetIgnoredFriendNames()) do
            for _, option in ipairs(options) do
                if option == name then selected[#selected + 1] = name end
            end
        end
        pcall(function() friendsDropdown:SetValue(selected, true) end)
    end
end
friendsDropdown = friendsSec:AddDropdown({
    Title = "Excluded players",
    Description = "Multi-select names to ignore.",
    Options = (#GetPlayerNames() > 0 and GetPlayerNames() or {"No other players"}),
    Default = GetIgnoredFriendNames(),
    Multi = true,
    VisibleRows = 8,
    ConfigKey = "deepwoken.friends.excluded",
    Callback = function(value)
        if type(value) ~= "table" then return end
        IgnoredFriends = {}
        for _, name in ipairs(value) do
            if type(name) == "string" and name ~= "No other players" then
                IgnoredFriends[name] = true
            end
        end
        RebuildFriendsLower()
        SaveIgnoredFriends()
    end,
})
friendsSec:AddButton({
    Title = "",
    ButtonText = "Refresh player list",
    Expand = true,
    Callback = RefreshFriendDropdown,
})
friendsSec:AddButton({
    Title = "",
    ButtonText = "Save exclusions",
    Expand = true,
    Callback = SaveIgnoredFriends,
})

-- WHITELISTS TAB: GUILDS
local guildSec = whitelistTab:AddSection("Guild", "Members of selected guilds will never be tracked by auto-parry.", { Column = "right" })
local guildDropdown
local yourGuildStatus = guildSec:AddStatus({ Title = "Your guild", Default = "-", Tone = "muted" })

local function GetGuildNames()
    local found, names = {}, {}
    for _, player in ipairs(Players:GetPlayers()) do
        local g = GetGuild(player)
        if g then found[g] = true end
    end
    for name in pairs(IgnoredGuilds) do found[name] = true end
    for name in pairs(found) do names[#names + 1] = name end
    table.sort(names, function(a, b) return string.lower(a) < string.lower(b) end)
    return names
end

local function RefreshGuildDropdown()
    local options = GetGuildNames()
    if #options == 0 then options = {"No guilds found"} end

    local lp = Players.LocalPlayer
    local myGuild = lp and GetGuild(lp)
    pcall(function() yourGuildStatus:SetValue(myGuild or "-", myGuild and "accent" or "muted") end)

    if guildDropdown then
        guildDropdown.Options = options
        guildDropdown._listScroll = 0
        guildDropdown._listScrollTo = 0
        local selected = {}
        for _, option in ipairs(options) do
            if IgnoredGuilds[option] then selected[#selected + 1] = option end
        end
        pcall(function() guildDropdown:SetValue(selected, true) end)
    end
end

do
    local initial = GetGuildNames()
    local defaults = {}
    for name in pairs(IgnoredGuilds) do defaults[#defaults + 1] = name end
    guildDropdown = guildSec:AddDropdown({
        Title = "Whitelisted guilds",
        Description = "Multi-select guilds to ignore.",
        Options = (#initial > 0 and initial or {"No guilds found"}),
        Default = defaults,
        Multi = true,
        VisibleRows = 8,
        ConfigKey = "deepwoken.guild.excluded",
        Callback = function(value)
            if type(value) ~= "table" then return end
            IgnoredGuilds = {}
            for _, name in ipairs(value) do
                if type(name) == "string" and name ~= "No guilds found" then
                    IgnoredGuilds[name] = true
                end
            end
            SaveIgnoredGuilds()
        end,
    })
end
guildSec:AddButton({
    Title = "",
    ButtonText = "Scan guilds",
    Variant = "primary",
    Expand = true,
    Callback = RefreshGuildDropdown,
})
RefreshGuildDropdown()

-- AUTO PARRY TAB
local parrySec = mainTab:AddSection("Auto Parry", "Targets and feint handling.", { Column = "left" })

local enabledToggle = Reg("sb_parry_on", parrySec:AddToggle({
    Title = "Enabled",
    Default = false,
    ConfigKey = "deepwoken.parry.enabled",
}))
enabledToggle:AddKeybind({
    Title = "Enable bind",
    Default = "none",
    Mode = "Toggle",
    ConfigKey = "deepwoken.parry.enabled.bind",
    OnPressed = function() enabledToggle:SetValue(not enabledToggle:GetValue()) end,
})
Reg("sb_parry_players", parrySec:AddToggle({
    Title = "Auto Parry Players",
    Default = true,
    ConfigKey = "deepwoken.parry.players",
}))
Reg("sb_parry_npcs", parrySec:AddToggle({
    Title = "Auto Parry NPCs",
    Default = true,
    ConfigKey = "deepwoken.parry.npcs",
}))
Reg("sb_parry_unparryables", parrySec:AddToggle({
    Title = "Parry Unparryables",
    Tooltip = "Unparryable actions press F (parry) instead of Q (for armor that allows it). Dodge-only actions always press Q.",
    Default = false,
    ConfigKey = "deepwoken.parry.unparryables",
}))
Reg("sb_parry_chance", parrySec:AddSlider({
    Title = "Parry Chance",
    Min = 1, Max = 100, Step = 1, Default = 100, Suffix = "%",
    ConfigKey = "deepwoken.parry.chance",
}))
Reg("sb_range", parrySec:AddSlider({
    Title = "Range",
    Tooltip = "Only react to animations from enemies within this many studs",
    Min = 5, Max = 100, Step = 1, Default = 20, Suffix = " studs",
    ConfigKey = "deepwoken.parry.range",
}))
Reg("sb_t_uncrouch", parrySec:AddSlider({
    Title = "Uncrouch Timing",
    Tooltip = "Crouch is a toggle: how long after crouching it presses the key again to stand up",
    Min = 0, Max = 2000, Step = 10, Default = 500, Suffix = "ms",
    ConfigKey = "deepwoken.timing.uncrouch",
}))
Reg("sb_t_rollcancel", parrySec:AddSlider({
    Title = "Roll Cancel Timing",
    Tooltip = "How long after a dodge (Q) it waits before right-clicking to roll cancel. 0 = off",
    Min = 0, Max = 1000, Step = 5, Default = 0, Suffix = "ms",
    ConfigKey = "deepwoken.timing.rollCancel",
}))

local feintSec = mainTab:AddSection("Feints", "Handling for canceled swings.", { Column = "right" })
Reg("sb_parry_feint_chance", feintSec:AddSlider({
    Title = "Parry Feint Chance",
    Tooltip = "Chance to still act when a swing gets canceled early (a feint)",
    Min = 0, Max = 100, Step = 1, Default = 0, Suffix = "%",
    ConfigKey = "deepwoken.parry.feintChance",
}))
Reg("sb_parry_feint_grace", feintSec:AddSlider({
    Title = "Feint Grace",
    Tooltip = "How long after the normal moment to keep watching for a late feint before committing",
    Min = 0, Max = 300, Step = 5, Default = 100, Suffix = "ms",
    ConfigKey = "deepwoken.parry.feintGrace",
}))

-- PING COMP (own section)
local pingSec = mainTab:AddSection("Ping Compensation", "Fires actions earlier to cover your latency.", { Column = "right" })
do
    local autoPingToggle = Reg("sb_t_autoping", pingSec:AddToggle({
        Title = "Auto Ping Comp",
        Tooltip = "On: uses your live (smoothed) ping and fires the one-way trip (ping / 2) earlier, nothing under 25 ms. Off: uses the Ping Comp slider.",
        Default = true,
        ConfigKey = "deepwoken.timing.autoPing",
    }))
    local pingSlider = Reg("sb_t_ping", pingSec:AddSlider({
        Title = "Ping Comp",
        Tooltip = "Used when Auto Ping Comp is off: fires actions this many ms earlier. Timings are tuned for ~60 ping; auto-set from your ping on inject.",
        Min = -BASE_PING, Max = 300, Step = 1, Default = 0, Suffix = "ms",
        ConfigKey = "deepwoken.timing.ping",
    }))
    pingSlider:SetEnabled(not autoPingToggle.Value)
    autoPingToggle:OnChanged(function(v) pingSlider:SetEnabled(not v) end)
end

-- AUTOMATION TAB
local generalSec = automationTab:AddSection("General", "Quality-of-life automation.", { Column = "left" })
Reg("auto_ritual", generalSec:AddToggle({
    Title = "Auto Ritual",
    Tooltip = "Automatically types the ritual key sequence when the spell GUI opens",
    Default = false,
    ConfigKey = "deepwoken.automation.ritual",
}))
Reg("auto_ragdoll_cancel", generalSec:AddToggle({
    Title = "Auto Ragdoll Cancel",
    Tooltip = "Right-clicks every 0.5s while you are ragdolled until it clears",
    Default = false,
    ConfigKey = "deepwoken.automation.ragdollCancel",
}))

-- VISUALS TAB

-- MISC TAB
local miscGeneralSec = miscTab:AddSection("General", "Miscellaneous tweaks.", { Column = "left" })
Reg("remove_winds", miscGeneralSec:AddToggle({
    Title = "Remove Winds",
    Tooltip = "Moves the SuperWall parts in Layer2Floor1 far below the map. Puts them back when turned off.",
    Default = false,
    ConfigKey = "deepwoken.misc.removeWinds",
}))
Reg("no_fog", miscGeneralSec:AddToggle({
    Title = "No Fog",
    Tooltip = "Sets Density to 0 on every Atmosphere. Restores the original values when turned off.",
    Default = false,
    ConfigKey = "deepwoken.visuals.noFog",
}))
Reg("no_legacy_fog", miscGeneralSec:AddToggle({
    Title = "No Lighting Fog",
    Tooltip = "Pushes Lighting.FogEnd far away (older-style fog some areas use).",
    Default = false,
    ConfigKey = "deepwoken.visuals.noLegacyFog",
}))
Reg("fps_boost", miscGeneralSec:AddToggle({
    Title = "FPS Boost",
    Tooltip = "Removes the sea and water parts for more FPS. One-way: it can't be undone until you rejoin. Not saved to the auto config.",
    Default = false,
}))

-- CONFIG AUTOSAVE / AUTOLOAD
do
    local CONFIG_FILE = "Deepwoken_Config.json"
    local SKIP = { sb_t_ping = true, print_parries = true, fps_boost = true }

    if type(readfile) == "function" and type(isfile) == "function" then
        local ok, raw = pcall(function()
            if isfile(CONFIG_FILE) then return readfile(CONFIG_FILE) end
        end)
        if ok and type(raw) == "string" and raw ~= "" then
            local good, saved = pcall(function() return HttpService:JSONDecode(raw) end)
            if good and type(saved) == "table" then
                for flag, ctrl in pairs(Controls) do
                    if not SKIP[flag] and saved[flag] ~= nil then
                        pcall(function() ctrl:SetValue(saved[flag]) end)
                    end
                end
            end
        end
    end

    if type(writefile) == "function" then
        -- event driven: nothing is polled or compared, we only write when a control actually changed
        task.spawn(function()
            ConfigDirty = false
            while Nexa:IsAlive() do
                task.wait(1)
                if ConfigDirty then
                    ConfigDirty = false
                    local snap = {}
                    for flag, ctrl in pairs(Controls) do
                        if not SKIP[flag] then
                            local v = ctrl.Value
                            if type(v) == "boolean" or type(v) == "number" or type(v) == "string" then
                                snap[flag] = v
                            end
                        end
                    end
                    pcall(function() writefile(CONFIG_FILE, HttpService:JSONEncode(snap)) end)
                end
            end
        end)
    end
end

-- TRACKER TAB
local Tracked = {}
local TrackedCount = 0
local Hist, HistDirty = {}, true
local HIST_MAX = 50
local NpcMap = {}
local FallbackMap = {}

local function GetTargetFromPath(path)
    local function walk(p)
        local current = workspace
        for part in string.gmatch(p, "[^/]+") do
            current = current:FindFirstChild(part)
            if not current then return nil end
        end
        return current
    end
    return walk(path) or walk("Live/" .. path)
end

local function FindLiveByName(name)
    local live = workspace:FindFirstChild("Live")
    if not live then return nil end
    for _, model in ipairs(live:GetChildren()) do
        if CleanName(model.Name) == name then return model end
    end
    return nil
end

local function FindOwnModel()
    local lp = Players.LocalPlayer
    if not lp then return nil end
    local ch = lp.Character
    if ch then return ch end
    local ok, list = pcall(function() return workspace:GetDescendants() end)
    if ok and type(list) == "table" then
        for _, v in ipairs(list) do
            if v.Name == lp.Name and v:FindFirstChild("Humanoid") then return v end
        end
    end
    return nil
end

-- Now Playing list
local playingSec = trackerTab:AddSection("Now Playing", "Animations seen on tracked targets (ignored ones hidden).", { Column = "left" })
local emptyLabel = playingSec:AddLabel({ Title = "Nothing yet", Description = "Pick a target and press Start Tracking." })
local histLabels = {}
for i = 1, HIST_SLOTS do
    local l = playingSec:AddLabel({ Title = "", Description = "" })
    l:SetVisible(false)
    histLabels[i] = l
end

local function RefreshHistLabels()
    HistDirty = false
    emptyLabel:SetVisible(#Hist == 0)
    for i = 1, HIST_SLOTS do
        local l, e = histLabels[i], Hist[i]
        if e then
            l:SetTitle("rbxassetid://" .. e.id)
            l:SetDescription(string.format("%s  x%d  %s", e.target, e.count, AnimDB[e.id] and "(in data)" or "(new)"))
            l:SetVisible(true)
        else
            l:SetVisible(false)
        end
    end
end

local function AddHistory(id, targetName)
    for i, e in ipairs(Hist) do
        if e.id == id then
            e.count = e.count + 1
            e.target = targetName
            table.remove(Hist, i)
            table.insert(Hist, 1, e)
            HistDirty = true
            return
        end
    end
    table.insert(Hist, 1, {id = id, count = 1, target = targetName})
    if #Hist > HIST_MAX then table.remove(Hist) end
    HistDirty = true
end

-- Target selection
local trackSec = trackerTab:AddSection("Track Target", "Who to watch.", { Column = "right" })

local function SetOptions(dd, names)
    if #names == 0 then names = {"None"} end
    local keep = dd.Value
    dd.Options = names
    dd._listScroll = 0
    dd._listScrollTo = 0
    local pick = names[1]
    for _, n in ipairs(names) do if n == keep then pick = n break end end
    dd:SetValue(pick, true)
end

local targetType, playerDD, npcDD, pathBox, fallbackDD, folderStatus

local function RefreshLists()
    local names = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= Players.LocalPlayer and not IgnoredFriends[p.Name] then
            names[#names + 1] = p.Name
        end
    end
    table.sort(names, function(a, b) return string.lower(a) < string.lower(b) end)
    SetOptions(playerDD, names)

    NpcMap = {}
    local npcNames = {}
    local live = workspace:FindFirstChild("Live")
    if live then
        for _, model in ipairs(live:GetChildren()) do
            local n = model.Name
            if not Players:FindFirstChild(CleanName(n)) and model:FindFirstChild("Humanoid") then
                local disp, c = n, 1
                while NpcMap[disp] do c = c + 1 disp = n .. " (" .. c .. ")" end
                NpcMap[disp] = model
                npcNames[#npcNames + 1] = disp
            end
        end
    end
    table.sort(npcNames, function(a, b) return string.lower(a) < string.lower(b) end)
    SetOptions(npcDD, npcNames)

    FallbackMap = {}
    local fbNames = {}
    local own = FindOwnModel()
    local folder = own and own.Parent
    if folder then
        for _, model in ipairs(folder:GetChildren()) do
            if model:FindFirstChild("Humanoid") then
                local n = CleanName(model.Name)
                local disp, c = n, 1
                while FallbackMap[disp] do c = c + 1 disp = n .. " (" .. c .. ")" end
                FallbackMap[disp] = model
                fbNames[#fbNames + 1] = disp
            end
        end
    end
    table.sort(fbNames, function(a, b) return string.lower(a) < string.lower(b) end)
    SetOptions(fallbackDD, fbNames)
    pcall(function() folderStatus:SetValue(folder and tostring(folder.Name) or "-", folder and "accent" or "muted") end)
end

local function UpdateTargetVisibility(kind)
    playerDD:SetVisible(kind == "Player")
    npcDD:SetVisible(kind == "NPC")
    fallbackDD:SetVisible(kind == "Fallback")
    pcall(function() folderStatus:SetVisible(kind == "Fallback") end)
    if pathBox then pathBox:SetVisible(kind == "NPC") end
end

targetType = trackSec:AddDropdown({
    Title = "Target Type",
    Options = { "LocalPlayer", "Player", "NPC", "Fallback" },
    Default = "LocalPlayer",
    ConfigKey = "deepwoken.tracker.type",
    Callback = function(v)
        UpdateTargetVisibility(v)
        if v ~= "LocalPlayer" then RefreshLists() end
    end,
})
playerDD = trackSec:AddDropdown({ Title = "Player List", Options = { "None" }, Default = "None", VisibleRows = 8 })
npcDD    = trackSec:AddDropdown({ Title = "NPC List", Options = { "None" }, Default = "None", VisibleRows = 8 })
fallbackDD = trackSec:AddDropdown({ Title = "Fallback List", Options = { "None" }, Default = "None", VisibleRows = 8 })
folderStatus = trackSec:AddStatus({ Title = "Folder", Default = "-", Tone = "muted" })
pathBox  = trackSec.AddTextbox and trackSec:AddTextbox({
    Title = "NPC Path",
    Placeholder = "Live/NpcName (optional)",
    Default = "",
})
UpdateTargetVisibility("LocalPlayer")

local trackingStatus = trackSec:AddStatus({ Title = "Tracking", Default = "None", Tone = "muted" })

local function UpdateTrackingStatus()
    if TrackedCount == 0 then
        trackingStatus:SetValue("None", "muted")
    else
        trackingStatus:SetValue(TrackedCount .. " target" .. (TrackedCount > 1 and "s" or ""), "success")
    end
end

local function ResolveTarget()
    local kind = targetType:GetValue()
    if kind == "LocalPlayer" then
        local lp = Players.LocalPlayer
        return FindLiveByName(lp.Name), lp.Name
    elseif kind == "Player" then
        local n = playerDD:GetValue()
        if IgnoredFriends[n] then return nil, n .. " (excluded)" end
        return FindLiveByName(n), n
    elseif kind == "Fallback" then
        local disp = fallbackDD:GetValue()
        return FallbackMap[disp], disp
    end

    local path = pathBox and tostring(pathBox:GetValue() or "") or ""
    if path ~= "" then
        local model = GetTargetFromPath(path)
        return model, path:match("([^/]+)$") or path
    end
    local disp = npcDD:GetValue()
    return NpcMap[disp], disp
end

local function StartTracking()
    if targetType:GetValue() ~= "LocalPlayer" then RefreshLists() end
    local model, label = ResolveTarget()
    if not model then
        Nexa:Notify({ Title = "Tracker", Content = "Target not found: " .. tostring(label), Type = "warning", Duration = 3 })
        return
    end
    local addr = model.Address
    if not Tracked[addr] then
        Tracked[addr] = { model = model, animator = GetAnimatorAddr(model), name = label, seen = {} }
        TrackedCount = TrackedCount + 1
    end
    UpdateTrackingStatus()
    Nexa:Notify({ Title = "Tracker", Content = "Tracking " .. tostring(label), Type = "success", Duration = 2 })
end

local function StopTracking()
    Tracked, TrackedCount = {}, 0
    UpdateTrackingStatus()
end

trackSec:AddButton({ Title = "", ButtonText = "Start Tracking", Variant = "primary", Expand = true, Callback = StartTracking })
trackSec:AddButton({ Title = "", ButtonText = "Stop All Tracking", Variant = "danger", Expand = true, Callback = StopTracking })

local ctrlSec = trackerTab:AddSection("Controls", "Tracker history controls.", { Column = "left" })
ctrlSec:AddButton({
    Title = "",
    ButtonText = "Refresh / Clear labels",
    Expand = true,
    Callback = function()
        Hist, HistDirty = {}, true
        for _, t in pairs(Tracked) do t.seen = {} end
        if targetType:GetValue() ~= "LocalPlayer" then RefreshLists() end
    end,
})

RefreshLists()

local TRACKER_INTERVAL = 0.05
local nextTrackerAt = 0
local function GetParent(m) return m.Parent end

local function TrackerStep()
    if TrackedCount == 0 then return end

    for addr, tgt in pairs(Tracked) do
        local okP, parent = pcall(GetParent, tgt.model)
        if not okP or not parent then
            Tracked[addr] = nil
            TrackedCount = TrackedCount - 1
            UpdateTrackingStatus()
        else
            if tgt.stale or not tgt.animator then
                tgt.animator = GetAnimatorAddr(tgt.model)
                tgt.stale = false
            end

            local seenNow = {}
            for _, anim in ipairs(GetPlayingAnims(tgt)) do
                seenNow[anim.track] = true
                if not tgt.seen[anim.track] then
                    tgt.seen[anim.track] = true
                    if not IgnoredIds[anim.id] then
                        AddHistory(anim.id, tgt.name)
                        Log(string.format("Track: %s | rbxassetid://%s | %.2fs in | %s",
                            tgt.name, anim.id, anim.elapsed or 0, AnimDB[anim.id] and "in data" or "new"))
                    end
                end
            end
            for k in pairs(tgt.seen) do
                if not seenNow[k] then tgt.seen[k] = nil end
            end
        end
    end
end

-- DEBUG TAB
local actionSec = debugTab:AddSection("Actions", "Reload data from GitHub.", { Column = "left" })
actionSec:AddButton({ Title = "Reload Anim Data", ButtonText = "Reload", Callback = function() LoadData() end })
actionSec:AddButton({ Title = "Reload Ignored Anims", ButtonText = "Reload", Callback = function() LoadIgnored() end })
actionSec:AddButton({
    Title = "Print Anim Table",
    ButtonText = "Print",
    Tooltip = "Prints every animation loaded from GitHub (id and its actions) to the console",
    Callback = function()
        local ids = {}
        for id in pairs(AnimDB) do ids[#ids + 1] = id end
        table.sort(ids, function(a, b)
            local na, nb = tonumber(a), tonumber(b)
            if na and nb then return na < nb end
            return tostring(a) < tostring(b)
        end)

        print(string.format("[Deepwoken] ===== Animation table (%d entries) from %s =====", #ids, DATA_URL))
        for _, id in ipairs(ids) do
            local parts = {}
            for _, action in ipairs(AnimDB[id].actions) do
                parts[#parts + 1] = string.format("%s@%.3f", action.kind, action.t)
            end
            print(string.format("[Deepwoken] rbxassetid://%s = %s", id, table.concat(parts, ", ")))
        end
        print("[Deepwoken] ===== end of animation table =====")

        Nexa:Notify({ Title = "Anim Table", Content = "Printed " .. #ids .. " animations to the console.", Type = "success", Duration = 3 })
    end,
})

local statSec = debugTab:AddSection("Status", "Live script info.", { Column = "right" })
local stLoaded  = statSec:AddStatus({ Title = "Loaded anims",  Default = "0", Tone = "accent" })
local stIgnored = statSec:AddStatus({ Title = "Ignored anims", Default = "0", Tone = "muted" })
local stTrack   = statSec:AddStatus({ Title = "Tracking",      Default = "0", Tone = "success" })
local stLast    = statSec:AddStatus({ Title = "Last",          Default = "none", Tone = "muted" })
local stDist    = statSec:AddStatus({ Title = "Distance",      Default = "0.0", Tone = "muted" })
local stLoop    = statSec:AddStatus({ Title = "Loop / Scan",   Default = "0 / 0 ms", Tone = "muted" })
local stPing    = statSec:AddStatus({ Title = "Ping / Comp",   Default = "-", Tone = "muted" })
local stAtmos   = statSec:AddStatus({ Title = "Atmospheres",   Default = "0", Tone = "muted" })

local function ApplyPing(samples, silent)
    samples = samples or 1
    local sum, n = 0, 0
    for i = 1, samples do
        local p = GetPingValue()
        if p then sum = sum + p n = n + 1 end
        if i < samples then task.wait(0.25) end
    end

    if n == 0 then
        if not silent then
            Nexa:Notify({ Title = "Ping", Content = "Could not read your ping.", Type = "warning", Duration = 3 })
        end
        return nil
    end

    local ping = sum / n
    local comp = PingToComp(ping)
    Status.ping = ping
    Status.comp = comp

    local ctrl = Controls.sb_t_ping
    if ctrl then pcall(function() ctrl:SetValue(comp) end) end

    Log(string.format("Ping %.0f ms -> Ping Comp %d ms", ping, comp))
    Nexa:Notify({
        Title = "Ping",
        Content = string.format("%.0f ms - Ping Comp set to %d ms", ping, comp),
        Type = "success",
        Duration = 3,
    })
    return ping
end

actionSec:AddButton({
    Title = "Print Ping",
    ButtonText = "Print Ping",
    Callback = function()
        local myPing = GetPingValue()
        if not myPing then
            Log("Ping read failed. Every method tried:\n[Deepwoken]   " .. tostring(PingError))
            Nexa:Notify({ Title = "Ping", Content = "Could not read your ping (see console).", Type = "warning", Duration = 4 })
            return
        end

        local comp = GetPingComp()
        Log(string.format("Ping: %.0f ms | Comp: %.0f ms | via %s", myPing, comp, PingMethod))
        Nexa:Notify({
            Title = "Ping",
            Content = string.format("%.0f ms (comp %.0f ms) via %s", myPing, comp, PingMethod),
            Type = "success",
            Duration = 3,
        })
    end,
})

Reg("print_parries", actionSec:AddToggle({
    Title = "Print Parries",
    Tooltip = "Prints every action the auto-parry fires (kind, key, enemy, animation id)",
    Default = false,
}))

local lastStatusUpdate = 0
local function UpdateStatusUI(now)
    if now - lastStatusUpdate < 0.25 then return end
    lastStatusUpdate = now

    if HistDirty then RefreshHistLabels() end

    -- the status badges are only on screen in the Debug tab, so don't touch them otherwise
    if Nexa.State.Tabs[Nexa.State.ActiveIndex] ~= debugTab then return end

    stLoaded:SetValue(tostring(Status.loaded))
    stIgnored:SetValue(tostring(Status.ignored))
    stTrack:SetValue(tostring(Status.tracked))
    stLast:SetValue(tostring(Status.last))
    stDist:SetValue(string.format("%.1f", Status.lastDist))
    stLoop:SetValue(string.format("%.0f / %.0f ms", Status.loopMs, Status.scanMs))
    local livePing = GetPingValue()
    if livePing then
        Status.ping = livePing
        if Controls.sb_t_autoping.Value then
            UpdateAutoPing(now)
            stPing:SetValue(string.format("%.0f / %.0f ms (auto)", AutoPing.smooth or livePing, AutoPing.comp), "accent")
        else
            stPing:SetValue(string.format("%.0f / %d ms", livePing, Controls.sb_t_ping.Value or 0), "accent")
        end
    else
        stPing:SetValue("unavailable", "muted")
    end
    stAtmos:SetValue(tostring(Status.atmos or 0))
end

-- LOGIC
local cOn      = Controls.sb_parry_on
local cPlayers = Controls.sb_parry_players
local cNpcs    = Controls.sb_parry_npcs
local cRange   = Controls.sb_range
local cChance  = Controls.sb_parry_chance
local cUnparry = Controls.sb_parry_unparryables

local function RightClick()
    if type(mouse2click) == "function" then
        pcall(mouse2click)
    elseif type(mouse2press) == "function" and type(mouse2release) == "function" then
        pcall(mouse2press)
        task.wait(0.03)
        pcall(mouse2release)
    end
end

local function ActionKey(kind, hold)
    if kind == "jump" then
        return KEY_JUMP, hold
    elseif kind == "crouch" then
        return KEY_CROUCH, hold
    elseif kind == "dodge" then
        return KEY_DODGE, hold
    elseif kind == "unparryable" then
        if cUnparry.Value then return KEY_PARRY, hold end
        return KEY_DODGE, hold
    end
    return KEY_PARRY, hold
end

local function KeyName(vk)
    return vk == KEY_PARRY and "F" or vk == KEY_DODGE and "Q" or vk == KEY_JUMP and "Space" or "Ctrl"
end

-- report(stage, configuredMs) is optional: the Test buttons use it to show every step of the sequence
local function Perform(kind, hold, tag, model, id, report)
    local vk, h = ActionKey(kind, hold)
    PressKey(vk, h)
    if report then report("Pressed " .. KeyName(vk) .. " (" .. kind .. ")", 0) end

    -- crouch is a toggle: press it again to stand back up
    if kind == "crouch" then
        local uncrouch = (Get("sb_t_uncrouch") or 500) / 1000
        task.spawn(function()
            task.wait(uncrouch)
            if Nexa:IsAlive() then
                PressKey(KEY_CROUCH, 0.05)
            else
                pcall(keypress, KEY_CROUCH)
                task.wait(0.05)
                pcall(keyrelease, KEY_CROUCH)
            end
            if report then report("Uncrouch (Ctrl again)", uncrouch * 1000) end
        end)
    end

    -- roll cancel: right click a set time after a dodge (Q) goes out
    if vk == KEY_DODGE then
        local rollCancel = Get("sb_t_rollcancel") or 0
        if rollCancel > 0 then
            task.spawn(function()
                task.wait(rollCancel / 1000)
                if Nexa:IsAlive() then RightClick() end
                if report then report("Roll cancel (right click)", rollCancel) end
            end)
        elseif report then
            report("Roll cancel is off (Roll Cancel Timing is 0)", 0)
        end
    end

    if Get("print_parries") then
        local okN, nm = pcall(function() return model.Name end)
        Log(string.format("%s%s -> %s | %s | rbxassetid://%s",
            kind, tag, KeyName(vk),
            okN and CleanName(nm) or "?", tostring(id)))
    end
end

do
    -- Test buttons wait 3 seconds (click back into the game), then run the FULL sequence through the
    -- same Perform path as real actions: crouch -> uncrouch, dodge -> roll cancel. Every step is
    -- reported with the delay you set and the delay actually measured.
    local testBusy = false

    local function TestAction(title, kind)
        actionSec:AddButton({
            Title = title,
            ButtonText = "Run in 3s",
            Callback = function()
                if testBusy then return end
                testBusy = true
                Nexa:Notify({ Title = title, Content = "Fires in 3 seconds", Type = "info", Duration = 3 })
                task.wait(3)

                if Nexa:IsAlive() then
                    local t0 = os.clock()
                    Perform(kind, 0.05, " (test)", { Name = "Test" }, "test", function(stage, configuredMs)
                        local actual = (os.clock() - t0) * 1000
                        local msg = configuredMs > 0
                            and string.format("%s - set %.0fms, measured %.0fms", stage, configuredMs, actual)
                            or stage
                        Log("Test: " .. msg)
                        Nexa:Notify({ Title = title, Content = msg, Type = "info", Duration = 3 })
                    end)

                    -- stay locked until the whole sequence has finished
                    local tail = math.max(Get("sb_t_uncrouch") or 0, Get("sb_t_rollcancel") or 0)
                    task.wait(0.4 + tail / 1000)
                end
                testBusy = false
            end,
        })
    end
    TestAction("Test Crouch", "crouch")
    TestAction("Test Dodge", "dodge")
    TestAction("Test Unparryable", "unparryable")
end

local function Schedule(startTime, info, akey, model, id)
    local delay = 0
    local ping  = GetPingComp()
    local hold  = 0.05
    local grace = (Get("sb_parry_feint_grace") or 0) / 1000
    local now   = os.clock()

    for _, action in ipairs(info.actions) do
        local base = startTime + action.t
        if base >= now - 0.1 then
            local at = base + ((delay - ping) / 1000)
            Queue[#Queue + 1] = {
                at         = at,
                hold       = hold,
                kind       = action.kind,
                owner      = akey,
                model      = model,
                id         = id,
                graceUntil = at + grace,
            }
        end
    end
end

local function FireDue()
    if #Queue == 0 then return end
    local t = os.clock()
    for i = #Queue, 1, -1 do
        local q = Queue[i]
        if t >= q.at then
            local feinted = not IsAnimAlive(q.model, q.id)
            local fire, tag = false, ""

            if feinted then
                if math.random(1, 100) <= (Get("sb_parry_feint_chance") or 0) then
                    fire, tag = true, " (feint)"
                end
            elseif t >= q.graceUntil then
                fire = true
            end

            if fire then Perform(q.kind, q.hold, tag, q.model, q.id) end

            if feinted or t >= q.graceUntil then
                table.remove(Queue, i)
            end
        end
    end
end

local function ScanStep(now)
    local scanStart = os.clock()

    if now >= NextRefresh then
        RefreshEnemies(now)
        NextRefresh = now + 0.5
    end

    local doPlayers, doNpcs = cPlayers.Value, cNpcs.Value
    local range = cRange.Value or 20
    local nearRange = range * 1.5
    local seenNow, tracked = {}, 0

    for _, enemy in ipairs(Enemies) do
        if ((enemy.isPlayer and doPlayers) or (not enemy.isPlayer and doNpcs))
           and not (enemy.isPlayer and FriendsLower[enemy.lname])
           and not (enemy.guild and IgnoredGuilds[enemy.guild])
           and now >= enemy.skipUntil then

            local dist = Dist(enemy)
            if dist > nearRange then
                enemy.skipUntil = now + 0.3
            else
                for _, anim in ipairs(GetPlayingAnims(enemy)) do
                    local id   = anim.id
                    local info = AnimDB[id]
                    if info then
                        local akey = enemy.key .. "|" .. id
                        tracked = tracked + 1
                        seenNow[akey] = true

                        if not Active[akey] then
                            Status.last, Status.lastDist = info.name or id, dist

                            if dist <= range and math.random(1, 100) <= (cChance.Value or 100) then
                                local start = os.clock() - (anim.elapsed or 0)
                                Active[akey] = start
                                Schedule(start, info, akey, enemy.model, id)
                            else
                                Active[akey] = now
                            end
                        end
                    end
                end
            end
        end
    end

    for k in pairs(Active) do
        if not seenNow[k] then Active[k] = nil end
    end
    Status.tracked = tracked
    Status.scanMs = Status.scanMs * 0.8 + (os.clock() - scanStart) * 1000 * 0.2
end

-- AUTOMATION LOGIC

-- Auto Ritual
-- Wrapped in do...end so its locals don't count against the script's top-level local limit.
do
    local RITUAL_START_DELAY = 0.3
    local RITUAL_GAP = 0.12
    local RITUAL_HOLD = 0.05

    -- Which ritual number each key is bound to (swap the numbers if the game rejects the inputs)
    local KEY_TO_INDEX = { Z = 1, X = 2, C = 3, V = 4 }
    local KEYCODES = { Z = 0x5A, X = 0x58, C = 0x43, V = 0x56 }

    local ritualRemote
    local function getRitualRemote()
        if ritualRemote then return ritualRemote end
        local rs = game:GetService("ReplicatedStorage")
        local requests = rs:FindFirstChild("Requests")
        local mantras = requests and requests:FindFirstChild("Mantras")
        ritualRemote = mantras and mantras:FindFirstChild("RitualSpellInput") or nil
        return ritualRemote
    end

    local function getSymbols()
        local lp = Players.LocalPlayer
        local gui = lp and lp:FindFirstChild("PlayerGui")
        local spellGui = gui and gui:FindFirstChild("SpellGui")
        local spellFrame = spellGui and spellGui:FindFirstChild("SpellFrame")
        return spellFrame and spellFrame:FindFirstChild("Symbols") or nil
    end

    local function frameX(frame)
        local ok, x = pcall(function() return frame.Position.X.Offset end)
        if ok and type(x) == "number" then return x end
        return nil
    end

    local function readRitual(symbols)
        local frames = {}
        for _, frame in ipairs(symbols:GetChildren()) do
            if frame:FindFirstChild("TextLabel") then frames[#frames + 1] = frame end
        end

        local idParts = { tostring(#frames) }
        for _, f in ipairs(frames) do idParts[#idParts + 1] = tostring(f.Address or "") end
        local ritualId = table.concat(idParts, ",")

        local xs, allX, seen = {}, #frames > 1, {}
        for _, f in ipairs(frames) do
            local x = frameX(f)
            xs[f] = x
            if x == nil or seen[x] then allX = false end
            if x ~= nil then seen[x] = true end
        end
        if allX then table.sort(frames, function(a, b) return xs[a] < xs[b] end) end

        local seq = {}
        for _, frame in ipairs(frames) do
            local label = frame:FindFirstChild("TextLabel")
            local text = string.upper(tostring(label.Text))
            if KEY_TO_INDEX[text] then seq[#seq + 1] = text end
        end
        return seq, ritualId, #frames
    end

    local remoteBroken = false
    local function sendRitualInput(letter)
        if not remoteBroken then
            local r = getRitualRemote()
            if r then
                local ok = pcall(function() r:FireServer(KEY_TO_INDEX[letter]) end)
                if ok then return end
            end
            remoteBroken = true
        end
        pcall(keypress, KEYCODES[letter])
        task.wait(RITUAL_HOLD)
        pcall(keyrelease, KEYCODES[letter])
    end

    local function RitualStep(lastId)
        local symbols = getSymbols()
        if not symbols then return nil end

        local seq, id, count = readRitual(symbols)
        if count == 0 then return nil end
        if id == lastId or #seq == 0 then return lastId end

        task.wait(RITUAL_START_DELAY)
        if not Get("auto_ritual") then return id end

        local seq2, id2 = readRitual(symbols)
        if #seq2 == 0 then return id end

        for i, letter in ipairs(seq2) do
            if not Nexa:IsAlive() or not Get("auto_ritual") then break end

            local sym = getSymbols()
            if not sym then break end
            if i > 1 then
                local _, curId = readRitual(sym)
                if curId ~= id2 then return nil end
            end

            sendRitualInput(letter)
            task.wait(RITUAL_GAP)
        end
        return id2
    end

    local cRitual = Controls.auto_ritual
    task.spawn(function()
        local lastId = nil
        while Nexa:IsAlive() do
            if cRitual.Value then
                task.wait(0.1)
                local ok, res = pcall(RitualStep, lastId)
                if ok then
                    lastId = res
                else
                    warn("[Deepwoken] ritual error: " .. tostring(res))
                end
            else
                lastId = nil
                task.wait(0.25) -- idle: no need to poll fast
            end
        end
    end)
end

-- Auto Ragdoll Cancel
local function IsRagdolled()
    local lp = Players.LocalPlayer
    if not lp then return false end
    local live = workspace:FindFirstChild("Live")
    if not live then return false end

    local model = live:FindFirstChild(lp.Name) or FindLiveByName(lp.Name)
    if not model then return false end

    local torso = model:FindFirstChild("Torso") or model:FindFirstChild("UpperTorso")
    if not torso then return false end

    return torso:FindFirstChild("RagdollAttach") ~= nil
end

task.spawn(function()
    local lastClick = 0
    local cRag = Controls.auto_ragdoll_cancel
    while Nexa:IsAlive() do
        if cRag.Value then
            task.wait(0.05)
            local ok, ragdolled = pcall(IsRagdolled)
            if ok and ragdolled then
                local now = os.clock()
                if now - lastClick >= 0.5 then
                    lastClick = now
                    RightClick()
                end
            else
                lastClick = 0
            end
        else
            task.wait(0.25) -- idle
        end
    end
end)

-- STARTUP
LoadData()
LoadIgnored()
RefreshHistLabels()

Nexa:Notify({
    Title = "Deepwoken",
    Content = "Loaded " .. Status.loaded .. " animations. Press P to toggle the menu.",
    Type = "success",
    Duration = 5,
})

-- VISUALS LOGIC: NO FOG
local ATMOS_DENSITY_OFF = 0xE8
local ATMOS_PROPS = {}
pcall(function()
    local a = offsets.Atmosphere
    if type(a) == "table" and type(a.Density) == "number" then ATMOS_DENSITY_OFF = a.Density end
    ATMOS_PROPS[#ATMOS_PROPS + 1] = { name = "Density", off = ATMOS_DENSITY_OFF }
end)
if #ATMOS_PROPS == 0 then ATMOS_PROPS[1] = { name = "Density", off = ATMOS_DENSITY_OFF } end

local function PropOn(name)
    return Get("no_fog") and true or false
end

local FOG_END_OFF
pcall(function()
    local l = offsets.Lighting
    if type(l) == "table" and type(l.FogEnd) == "number" then FOG_END_OFF = l.FogEnd end
end)
local FogEndOriginal

local AtmosOriginal = {}
local AtmosFast, AtmosDeep = {}, {}
local nextFastScan, nextDeepScan = 0, 0

local function ParentOf(i) return i.Parent end
local function AddressOf(i) return i.Address end
local function ClassOf(i) return i.ClassName end
local function DescendantsOf(i) return i:GetDescendants() end
local function ChildrenOf(i) return i:GetChildren() end

local function CollectAtmospheres(root, deep, out, seen)
    if not root then return end
    local ok, list = pcall(deep and DescendantsOf or ChildrenOf, root)
    if not ok or type(list) ~= "table" then return end
    for _, inst in ipairs(list) do
        local okC, cls = pcall(ClassOf, inst)
        if okC and cls == "Atmosphere" then
            local okA, addr = pcall(AddressOf, inst)
            if okA and addr and not seen[addr] then
                seen[addr] = true
                out[#out + 1] = inst
            end
        end
    end
end

local function FixAtmosphere(inst)
    local okP, parent = pcall(ParentOf, inst)
    if not okP or not parent then return false end
    local okA, addr = pcall(AddressOf, inst)
    if not okA or not addr then return false end
    for _, prop in ipairs(ATMOS_PROPS) do
      if PropOn(prop.name) then
        local target = addr + prop.off
        local ok, cur = pcall(memory_read, "float", target)
        if ok and type(cur) == "number" and cur ~= 0 then
            local saved = AtmosOriginal[inst]
            if not saved then saved = {} AtmosOriginal[inst] = saved end
            if saved[prop.name] == nil then saved[prop.name] = cur end
            pcall(memory_write, "float", target, 0)
        end
      end
    end
    return true
end

local LightingAddr
local function ClearLegacyFog()
    if not LightingAddr then
        local ok, addr = pcall(function() return game:GetService("Lighting").Address end)
        if not ok or not addr then return end
        LightingAddr = addr
    end
    local target = LightingAddr + FOG_END_OFF
    local ok2, cur = pcall(memory_read, "float", target)
    if ok2 and type(cur) == "number" and cur > 0 and cur < 100000 then
        if FogEndOriginal == nil then FogEndOriginal = cur end
        pcall(memory_write, "float", target, 100000)
    end
end

local function SampleFog()
    if not FOG_END_OFF then
        Nexa:Notify({ Title = "Fog", Content = "No FogEnd offset in the offsets list.", Type = "error", Duration = 3 })
        return
    end
    local toggleOn = Get("no_legacy_fog") and true or false
    local okA, addr = pcall(function() return game:GetService("Lighting").Address end)
    if not okA or not addr then return end

    local startOff
    pcall(function()
        if type(offsets.Lighting.FogStart) == "number" then startOff = offsets.Lighting.FogStart end
    end)

    local frames, changes, lastEnd, below = 0, 0, nil, 0
    local minEnd, maxEnd = math.huge, -math.huge
    local firstEnd, lastSeenEnd, startVal
    local t0 = os.clock()
    while os.clock() - t0 < 4 and Nexa:IsAlive() do
        task.wait()
        local ok, cur = pcall(memory_read, "float", addr + FOG_END_OFF)
        if ok and type(cur) == "number" then
            frames = frames + 1
            if firstEnd == nil then firstEnd = cur end
            if lastEnd ~= nil and math.abs(cur - lastEnd) > 0.01 then changes = changes + 1 end
            if cur < 100000 then below = below + 1 end
            lastEnd, lastSeenEnd = cur, cur
            if cur < minEnd then minEnd = cur end
            if cur > maxEnd then maxEnd = cur end
        end
    end
    if startOff then
        local ok, v = pcall(memory_read, "float", addr + startOff)
        if ok then startVal = v end
    end

    local msg = string.format("[toggle %s] FogEnd: %d reads, changed %d times, below100k %d. first %.0f, last %.0f, min %.0f, max %.0f%s",
        toggleOn and "ON" or "OFF", frames, changes, below, firstEnd or 0, lastSeenEnd or 0,
        minEnd == math.huge and 0 or minEnd, maxEnd == -math.huge and 0 or maxEnd,
        startVal and string.format(", FogStart %.0f", startVal) or "")
    print("[Deepwoken] " .. msg)
    Nexa:Notify({ Title = "Fog sample", Content = msg, Type = "success", Duration = 8 })
end

actionSec:AddButton({
    Title = "Sample Fog",
    ButtonText = "Sample Fog (4s)",
    Callback = function() task.spawn(SampleFog) end,
})

actionSec:AddButton({
    Title = "",
    ButtonText = "Unload Script",
    Variant = "danger",
    Expand = true,
    Callback = function()
        task.spawn(function()
            pcall(function() Nexa:Destroy() end)
            pcall(function()
                local env = type(getgenv) == "function" and getgenv() or nil
                for _, k in ipairs({ "Nexa", "UI", "DrawingUI" }) do
                    if env and env[k] == Nexa then env[k] = nil end
                    if rawget(_G, k) == Nexa then _G[k] = nil end
                    if type(shared) == "table" and shared[k] == Nexa then shared[k] = nil end
                end
            end)
        end)
    end,
})

local function RestoreLegacyFog()
    if FogEndOriginal and LightingAddr and FOG_END_OFF then
        pcall(memory_write, "float", LightingAddr + FOG_END_OFF, FogEndOriginal)
    end
    FogEndOriginal = nil
end

local function ApplyNoFog(now)
    if now >= nextFastScan then
        nextFastScan = now + 0.5
        local out, seen = {}, {}
        CollectAtmospheres(game:GetService("Lighting"), true, out, seen)
        CollectAtmospheres(workspace.CurrentCamera, true, out, seen)
        AtmosFast = out
    end

    local count = 0
    for _, inst in ipairs(AtmosFast) do
        if FixAtmosphere(inst) then count = count + 1 end
    end
    for _, inst in ipairs(AtmosDeep) do
        if FixAtmosphere(inst) then count = count + 1 end
    end
    Status.atmos = count
end

local function RestoreAtmosphere(onlyInactive)
    for inst, saved in pairs(AtmosOriginal) do
        pcall(function()
            local alive = inst.Parent ~= nil
            local addr = alive and inst.Address
            for _, prop in ipairs(ATMOS_PROPS) do
                local original = saved[prop.name]
                if original ~= nil and (not onlyInactive or not PropOn(prop.name)) then
                    if alive then memory_write("float", addr + prop.off, original) end
                    saved[prop.name] = nil
                end
            end
        end)
    end
    if onlyInactive then return end
    AtmosOriginal = {}
    AtmosFast, AtmosDeep = {}, {}
    nextFastScan, nextDeepScan = 0, 0
end

task.spawn(function()
    local wasOn, lastState = false, ""
    local cFog = Controls.no_fog
    while Nexa:IsAlive() do
        local fog = cFog.Value and true or false
        local state = fog and "1" or "0"
        if fog then
            if state ~= lastState then pcall(RestoreAtmosphere, true) end
            pcall(ApplyNoFog, os.clock())
            task.wait()
        else
            if wasOn then pcall(RestoreAtmosphere) end
            task.wait(0.25) -- idle: only check the toggle a few times a second
        end
        wasOn, lastState = fog, state
    end
end)

task.spawn(function()
    local wasOn = false
    local cLegacy = Controls.no_legacy_fog
    while Nexa:IsAlive() do
        if FOG_END_OFF and cLegacy.Value then
            ClearLegacyFog()
            wasOn = true
            task.wait()
        else
            if wasOn then
                RestoreLegacyFog()
                wasOn = false
            end
            task.wait(0.25)
        end
    end
    RestoreLegacyFog()
end)

-- MISC LOGIC: REMOVE WINDS
do
    local WindWalls = {}   -- part -> original CFrame
    local WindList = {}    -- cached SuperWall parts (the big descendants scan only runs every few seconds)
    local nextWindScan = 0

    local function MoveWall(v)
        if v.Position.Y > -5000 then
            if WindWalls[v] == nil then WindWalls[v] = v.CFrame end
            v.CFrame = v.CFrame + Vector3.new(0, -10000, 0)
        end
    end

    local function MoveWindWalls(now)
        if now >= nextWindScan then
            nextWindScan = now + 5
            WindList = {}
            local floor = workspace:FindFirstChild("Layer2Floor1")
            if floor then
                local ok, list = pcall(function() return floor:GetDescendants() end)
                if ok and type(list) == "table" then
                    for _, v in ipairs(list) do
                        if v.Name == "SuperWall" then WindList[#WindList + 1] = v end
                    end
                end
            end
        end
        for _, v in ipairs(WindList) do pcall(MoveWall, v) end
    end

    local function RestoreWinds()
        for part, cf in pairs(WindWalls) do
            pcall(function() part.CFrame = cf end)
        end
        WindWalls = {}
        WindList = {}
        nextWindScan = 0
    end

    Nexa:OnDestroy(function() pcall(RestoreWinds) end)

    task.spawn(function()
        local wasOn = false
        local cWinds = Controls.remove_winds
        while Nexa:IsAlive() do
            local on = cWinds.Value and true or false
            if on then
                pcall(MoveWindWalls, os.clock())
                task.wait(0.5)
            else
                if wasOn then pcall(RestoreWinds) end
                task.wait(0.5)
            end
            wasOn = on
        end
    end)
end

-- MISC LOGIC: FPS BOOST
-- Removes the sea / water parts. One-shot when the toggle is switched on; the water tags are then
-- kept clear while the toggle stays on. Every step is pcall'd on its own so one missing object
-- (e.g. SeaAttach already gone) doesn't stop the rest.
do
    local function Step(name, fn)
        local ok, err = pcall(fn)
        if not ok then Log("FPS Boost: " .. name .. " failed: " .. tostring(err)) end
        return ok
    end

    local function GraphicsMode()
        local rs = game:GetService("ReplicatedStorage")
        for _, inst in ipairs({ Players.LocalPlayer, rs, workspace }) do
            local ok, v = pcall(function() return inst:GetAttribute("GraphicsMode") end)
            if ok and v then return v end
        end
        return nil
    end

    local function ClearWaterTags()
        local cs = game:GetService("CollectionService")
        for _, part in ipairs(cs:GetTagged("WaterPart")) do
            cs:RemoveTag(part, "WaterPart")
        end
    end

    local function RunBoost()
        local lp = Players.LocalPlayer
        local rs = game:GetService("ReplicatedStorage")
        local scripts = lp.PlayerScripts
        local seaClient, actor

        Step("SeaClient", function()
            seaClient = scripts:FindFirstChild("SeaClient")
                or game:GetService("StarterPlayer").StarterPlayerScripts.SeaClient:Clone()
        end)
        Step("Actor", function()
            actor = Instance.new("Actor")
            actor.Parent = scripts
        end)
        Step("SeaAttach", function() workspace.Terrain.SeaAttach:Destroy() end)

        if GraphicsMode() == "low" then
            Step("SkinnedSea (assets)", function()
                local mesh = rs.Assets.SeaMesh
                mesh.SkinnedSea:Destroy()
                local far = mesh.FarSea:Clone()
                far.Parent = mesh
                far.Name = "SkinnedSea"
            end)
            Step("disable SeaClient", function() seaClient.Disabled = true end)
        end

        Step("SkinnedSea (workspace)", function() workspace.SkinnedSea:Destroy() end)

        -- re-parent SeaClient under the Actor and bounce it so it restarts without the sea
        task.wait(0.15)
        Step("parent SeaClient", function() seaClient.Parent = actor end)
        task.wait(0.15)
        Step("enable", function() seaClient.Disabled = false end)
        task.wait(0.15)
        Step("disable", function() seaClient.Disabled = true end)
        task.wait(0.15)
        Step("enable", function() seaClient.Disabled = false end)

        Step("water tags", ClearWaterTags)
        Log("FPS Boost applied")
        Nexa:Notify({ Title = "FPS Boost", Content = "Sea and water removed.", Type = "success", Duration = 3 })
    end

    task.spawn(function()
        local cBoost = Controls.fps_boost
        local was = false
        local lastTags = 0
        while Nexa:IsAlive() do
            local on = cBoost.Value and true or false
            if on and not was then
                task.spawn(RunBoost)
            end
            -- stand-in for the original "tag added" signal: keep removing new WaterPart tags
            if on and os.clock() - lastTags >= 1 then
                lastTags = os.clock()
                pcall(ClearWaterTags)
            end
            was = on
            task.wait(on and 0.5 or 0.5)
        end
    end)
end

task.spawn(function()
    task.wait(1)
    ApplyPing(6, true)
end)

Nexa:OnDestroy(function()
    pcall(RestoreAtmosphere)
    pcall(RestoreLegacyFog)
    for _, r in ipairs(Releases) do pcall(keyrelease, r.vk) end
    Releases = {}
    Queue, Active, Tracked, TrackedCount = {}, {}, {}, 0
end)

task.spawn(function()
    local lastLoop, lastScan, lastErr = os.clock(), 0, nil

    while Nexa:IsAlive() do
        local now = os.clock()
        -- nothing to scan, track or release: sleep longer instead of spinning every frame
        local idle = not cOn.Value and TrackedCount == 0 and #Releases == 0
        if not idle then
            Status.loopMs = Status.loopMs * 0.8 + (now - lastLoop) * 1000 * 0.2
        end
        lastLoop = now

        if #Releases > 0 then
            for i = #Releases, 1, -1 do
                if now >= Releases[i].at then
                    pcall(keyrelease, Releases[i].vk)
                    table.remove(Releases, i)
                end
            end
        end

        if cOn.Value then
            if Controls.sb_t_autoping.Value then UpdateAutoPing(now) end
            if now - lastScan >= SCAN_INTERVAL then
                lastScan = now
                local ok, err = pcall(ScanStep, now)
                if not ok and err ~= lastErr then lastErr = err warn("[Deepwoken] scan error: " .. tostring(err)) end
            end
            if #Queue > 0 then
                local ok, err = pcall(FireDue)
                if not ok and err ~= lastErr then lastErr = err warn("[Deepwoken] fire error: " .. tostring(err)) end
            end
        else
            if #Queue > 0 then Queue = {} end
            if next(Active) ~= nil then Active = {} end
        end

        if TrackedCount > 0 and now >= nextTrackerAt then
            nextTrackerAt = now + TRACKER_INTERVAL
            local ok, err = pcall(TrackerStep)
            if not ok and err ~= lastErr then lastErr = err warn("[Deepwoken] tracker error: " .. tostring(err)) end
        end

        pcall(UpdateStatusUI, now)
        if idle then task.wait(0.1) else task.wait() end
    end

    for _, r in ipairs(Releases) do pcall(keyrelease, r.vk) end
end)

return Nexa
