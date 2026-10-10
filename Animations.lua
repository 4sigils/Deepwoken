return {
    -- Parry animations
    ["118154222392812"] = {
        type = "parry",
        t = {0.7, 1.5}
    }, -- Double Slash

    ["86527092652774"] = 0.6, -- Single Diagonal Slash

    ["134600514326413"] = {
        type = "parry",
        t = {0.7, 1.2}
    }, -- Stomp into Slash

    -- Dodge animations
    -- Unparryable: Q normally, F with "Parry Unparryables" enabled
    ["124963391435150"] = {
        type = "dodge",
        t = {0.5, 1.0}
    }, -- Red Double Slash

    -- Crouch example
    -- This is intentionally disabled because it uses the same
    -- animation ID as the dodge above.
    -- ["124963391435150"] = {
    --     type = "crouch",
    --     t = 0.3
    -- },

    -- Hybrid / sequence
    -- Jump + parry in one animation
    ["112423929319383"] = {
        {type = "jump",  t = 0.4},
        {type = "parry", t = 0.9},
        {type = "parry", t = 1.1},
        {type = "jump",  t = 1.5},
    }, -- Jump Stomps with Slashes

    -- Flurry Combo
    ["76782656543761"] = {
        {type = "parry", t = 0.3},
        {type = "dodge", t = 0.5},
        {type = "parry", t = 0.6},
        {type = "parry", t = 0.8},
    },  
}
