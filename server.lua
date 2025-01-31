RegisterNetEvent("kuban_sellshop:sellItem", function(requiredItem, quantity, pricePerItem, shopName)
    local src = source
    local totalAmount = quantity * pricePerItem
    local playerName = GetPlayerName(src)
    local playerId = src
    local timestamp = os.date("%Y-%m-%d %H:%M:%S")

    local shopConfig = nil
    for _, shop in ipairs(Config.sellShops) do
        if shop.name == shopName then
            shopConfig = shop
            break
        end
    end

    if not shopConfig then return end 
    local success = exports.ox_inventory:RemoveItem(src, requiredItem, quantity)

    if not success then
        TriggerClientEvent("ox_lib:notify", src, { type = "error", description = "Failed to remove items!" })
        return
    end
    exports.ox_inventory:AddItem(src, "money", totalAmount)
    TriggerClientEvent("ox_lib:notify", src, { type = "success", description = ("You sold %d %s for $%d!"):format(quantity, requiredItem, totalAmount) })
    if shopConfig.discord and shopConfig.discord.enabled then
        sendToDiscord({
            webhook = shopConfig.discord.webhook,
            title = shopConfig.discord.title,
            description = ("**Player:** `%s` (ID: `%d`)\n**Shop:** `%s`\n**Item Sold:** `%s` `x%d`\n**Total Earned:** `$%d`\n**Time:** %s"):format(playerName, playerId, shopName, requiredItem, quantity, totalAmount, timestamp),
            color = shopConfig.discord.color,
            footer = shopConfig.discord.footer
        })
    end
end)

---@param logData table
function sendToDiscord(logData)
    if not logData.webhook or logData.webhook == "" then return end 

    local embedData = {
        {
            ["title"] = logData.title or "🛒 Sell Shop Transaction",
            ["description"] = logData.description or "No description provided",
            ["color"] = logData.color or 16711680, 
            ["footer"] = { ["text"] = logData.footer .. " - " .. os.date("%Y-%m-%d %H:%M:%S") }
        }
    }

    PerformHttpRequest(logData.webhook, function(statusCode, response, headers) end, "POST", json.encode({ username = "KubanScripts", embeds = embedData }), { ["Content-Type"] = "application/json" })
end
