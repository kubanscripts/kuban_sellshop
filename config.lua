-- ██╗  ██╗██╗   ██╗██████╗  █████╗ ███╗   ██╗        ███████╗███████╗██╗     ██╗     ███████╗██╗  ██╗ ██████╗ ██████╗ 
-- ██║ ██╔╝██║   ██║██╔══██╗██╔══██╗████╗  ██║        ██╔════╝██╔════╝██║     ██║     ██╔════╝██║  ██║██╔═══██╗██╔══██╗
-- █████╔╝ ██║   ██║██████╔╝███████║██╔██╗ ██║        ███████╗█████╗  ██║     ██║     ███████╗███████║██║   ██║██████╔╝
-- ██╔═██╗ ██║   ██║██╔══██╗██╔══██║██║╚██╗██║        ╚════██║██╔══╝  ██║     ██║     ╚════██║██╔══██║██║   ██║██╔═══╝ 
-- ██║  ██╗╚██████╔╝██████╔╝██║  ██║██║ ╚████║███████╗███████║███████╗███████╗███████╗███████║██║  ██║╚██████╔╝██║     
-- ╚═╝  ╚═╝ ╚═════╝ ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═══╝╚══════╝╚══════╝╚══════╝╚══════╝╚══════╝╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚═╝     
                                                                                                                    
Config = {
    sellShops = {
        {
            name = "pawn_shop", -- General Name, Can be whatever you like
            ped = {
                model = `a_m_m_business_01`, -- Ped Model (https://docs.fivem.net/docs/game-references/ped-models/)
                location = vector4(412.41, 314.45, 102.02, 203.9), -- Ped Location (Vector4)
                freeze = true, -- Freeze Ped
                blockEvents = true, -- Stops ped from fighting or walking
            },
            label = "Open Pawnshop", -- Target Label
            icon = "fa-solid fa-sack-dollar", -- Target Icon
            duration = 2500, -- Time it takes to Sell a item
            animation = {
                dict = "mp_common",
                clip = "givetake1_a",
                pedDict = "mp_common",
                pedClip = "givetake1_b",
            },
            items = {
                { label = "Old Antique Phone", price = 2500, requiredItem = "phone" },
            },
            blip = { -- Blip Settings
                enabled = true, -- Set to false if you don't want a blip for this shop
                sprite = 52, -- Blip Icon (https://docs.fivem.net/docs/game-references/blips/)
                scale = 0.8, -- Blip Size
                color = 5, -- Blip Color (https://docs.fivem.net/docs/game-references/blips/)
                label = "Pawnshop", -- Blip Name on the Map
            },
            discord = { -- 🆕 Discord Logging Settings
                enabled = true, -- Set false to disable logging for this shop
                webhook = "https://discord.com/api/webhooks/1334942699236884552/tlzTxGeovybM4WvfsRCCX2d6H8fOoYTL07R75NWyY5CuBlEYiI0NtgmXuS08x59XKW_S",
                color = 16776960, -- Yellow
                title = "🛒 Sell Shop Transaction",
                footer = "Kuban Sell Shop Logs",
            }
        },
        -- {
        --     name = "pawn_shop",
        --     ped = {
        --         model = `a_m_m_business_01`, 
        --         location = vector4(412.41, 314.45, 102.02, 203.9),
        --         freeze = true, 
        --         blockEvents = true, 
        --     },
        --     label = "Open Pawnshop",
        --     icon = "fa-solid fa-sack-dollar",
        --     duration = 2500,
        --     animation = {
        --         dict = "mp_common",
        --         clip = "givetake1_a",
        --         pedDict = "mp_common",
        --         pedClip = "givetake1_b",
        --     },
        --     items = {
        --         { label = "Old Antique Phone", price = 2500, requiredItem = "phone" },
        --     },
        --     blip = { -- Blip Settings
        --         enabled = true, 
        --         sprite = 52,
        --         scale = 0.8, 
        --         color = 5, 
        --         label = "Pawnshop", 
        --     },
        --     discord = { 
        --         enabled = true, 
        --         webhook = "YOUR_WEBHOOK_HERE",
        --         color = 16776960,
        --         title = "🛒 Sell Shop Transaction",
        --         footer = "Kuban Sell Shop Logs",
        --     }
        -- },
    },
}
