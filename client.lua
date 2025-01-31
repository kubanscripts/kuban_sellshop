---@param shop table The shop configuration containing ped and item data.
local function setupShops()
    for _, shop in ipairs(Config.sellShops) do
        lib.requestModel(shop.ped.model)
        local ped = CreatePed(4, shop.ped.model, shop.ped.location.xyz, shop.ped.location.w, false, true)
        FreezeEntityPosition(ped, shop.ped.freeze)
        SetBlockingOfNonTemporaryEvents(ped, shop.ped.blockEvents)
        SetEntityAsMissionEntity(ped, true, true)
        SetEntityInvincible(ped, true)
        SetPedCanRagdoll(ped, false)
        SetPedDiesWhenInjured(ped, false)
        SetPedCombatAttributes(ped, 46, true)
        SetPedFleeAttributes(ped, 0, false)
        TaskSetBlockingOfNonTemporaryEvents(ped, true)

        exports.ox_target:addLocalEntity(ped, {
            {
                name = shop.name,
                label = shop.label,
                icon = shop.icon,
                distance = 2.5,
                onSelect = function()
                    openSellMenu(shop)
                end,
            },
        })

        if shop.blip and shop.blip.enabled then
            local blip = AddBlipForCoord(shop.ped.location.x, shop.ped.location.y, shop.ped.location.z)
            SetBlipSprite(blip, shop.blip.sprite or 52)
            SetBlipScale(blip, shop.blip.scale or 0.8)
            SetBlipColour(blip, shop.blip.color or 5)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentSubstringPlayerName(shop.blip.label or "Shop")
            EndTextCommandSetBlipName(blip)
        end
    end
end


---@param shop table The shop configuration containing items to sell.
function openSellMenu(shop)
    local playerItems = exports.ox_inventory:Search('slots') or {}
    local menu = {}
    for _, item in ipairs(shop.items) do
        table.insert(menu, {
            title = item.label,
            description = ("Sell for $%d each"):format(item.price),
            onSelect = function()
                processSell(item, shop)
            end,
        })
    end
    lib.registerContext({
        id = shop.name .. "_menu",
        title = shop.label,
        options = menu,
    })
    lib.showContext(shop.name .. "_menu")
end
function processSell(item, shop)
    local requiredItem = item.requiredItem
    local playerItems = exports.ox_inventory:Search('count', requiredItem)

    if not playerItems or playerItems < 1 then
        lib.notify({ type = "error", description = "You do not have the required items to sell this!" })
        return
    end

    local dialog = lib.inputDialog("Sell Items", {
        { type = "number", label = ("Enter quantity (max %d)"):format(playerItems), min = 1, max = playerItems },
    })

    if not dialog or not dialog[1] then
        lib.notify({ type = "error", description = "No quantity entered!" })
        return
    end

    local sellQuantity = tonumber(dialog[1])

    if not sellQuantity or sellQuantity < 1 or sellQuantity > playerItems then
        lib.notify({ type = "error", description = "Invalid quantity entered!" })
        return
    end

    if lib.alertDialog({ header = "Confirm Sale", content = ("Sell %d %s for $%d?"):format(sellQuantity, item.label, sellQuantity * item.price), centered = true, cancel = true }) then
        local playerPed = PlayerPedId()
        local targetPed = GetClosestPed(shop.ped.location.xyz, 2.5)
        FreezeEntityPosition(playerPed, true)
        FreezeEntityPosition(targetPed, true)
        lib.requestAnimDict(shop.animation.dict)
        lib.requestAnimDict(shop.animation.pedDict)
        TaskPlayAnim(playerPed, shop.animation.dict, shop.animation.clip, 8.0, -8.0, -1, 0, 0, false, false, false)
        TaskPlayAnim(targetPed, shop.animation.pedDict, shop.animation.pedClip, 8.0, -8.0, -1, 0, 0, false, false, false)

        lib.progressBar({
            duration = shop.duration,
            label = "Processing sale...",
            disableMovement = true,
            canCancel = false,
        })

        ClearPedTasks(playerPed)
        ClearPedTasks(targetPed)
        FreezeEntityPosition(playerPed, false)
        FreezeEntityPosition(targetPed, true)
        SetEntityInvincible(targetPed, true)
        SetPedCanRagdoll(targetPed, false)
        SetPedDiesWhenInjured(targetPed, false)
        SetPedCombatAttributes(targetPed, 46, true)
        SetPedFleeAttributes(targetPed, 0, false)
        TaskSetBlockingOfNonTemporaryEvents(targetPed, true)

        TriggerServerEvent("kuban_sellshop:sellItem", requiredItem, sellQuantity, item.price, shop.name)
    end
end


---@param coords vector3 The coordinates to find the closest ped.
---@param radius number The search radius around the coordinates.
---@return ped The closest ped entity found.
function GetClosestPed(coords, radius)
    local ped, closestDist = nil, radius
    local handle, entity = FindFirstPed()
    local success

    repeat
        local pedCoords = GetEntityCoords(entity)
        local dist = #(coords - pedCoords)

        if dist < closestDist and not IsPedAPlayer(entity) then
            ped, closestDist = entity, dist
        end

        success, entity = FindNextPed(handle)
    until not success

    EndFindPed(handle)
    return ped
end

CreateThread(setupShops)
