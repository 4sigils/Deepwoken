local base = "https://raw.githubusercontent.com/4sigils/Deepwoken/refs/heads/main/animations/"

local files = {
    "Attunements/Flame.lua",
    "Weapons/Light.lua",
    "Weapons/Medium.lua",
    "Weapons/Heavy.lua",
    "VowOfIron.lua",
}

local merged = {}

for _, path in ipairs(files) do
    local ok, data = pcall(function()
        return loadstring(game:HttpGet(base .. path))()
    end)

    if ok and type(data) == "table" then
        for id, timing in pairs(data) do
            merged[id] = timing
        end
    else
        warn("Failed to load: " .. path)
    end
end

return merged
