return {-- ✅ / ❌
    -- Shogun
    ["118154222392812"] = { -- Green Double Slash✅
        type = "parry",
        t = {0.65, 1.45}
    },

    ["86527092652774"] = 0.6, -- Single Diagonal Slash✅

    ["86527092652774"] = 0.6, -- Upsweep

    ["134600514326413"] = { -- Stomp into Slash
        type = "parry",
        t = {0.7, 2.0}
    },

    -- Dodge animations
    -- Unparryable: Q normally, F with "Parry Unparryables" enabled
    ["124963391435150"] = { -- Red Double Slash
        type = "dodge",
        t = {0.9, 1.7}
    },

    ["129588531110694"] = { -- Crouch Low Slash
        type = "crouch",
        t = 0.5
    },

    ["112423929319383"] = { -- Jump Stomps + Slashes✅
        {type = "jump",  t = 0.4},
        {type = "parry", t = 1.2},
        {type = "parry", t = 1.8},
        {type = "jump",  t = 2.3},
    },

    ["76782656543761"] = { -- Flurry
        {type = "parry", t = 0.45},
        {type = "dodge", t = 1.2},
        {type = "parry", t = 2.15},
        {type = "parry", t = 2.5},
    },

    ["87084893315096"] = { -- Ultimate
        {type = "parry", t = 0.5},
        {type = "parry", t = 0.9},
        {type = "dodge", t = 1.45},
        {type = "dodge", t = 1.9},
        {type = "parry", t = 2.7},
        {type = "parry", t = 3.1},
        {type = "parry", t = 3.65},
        {type = "parry", t = 4.1},
    },
}
