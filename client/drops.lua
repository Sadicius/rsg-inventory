holdingDrop = false
local bagObject = nil
-- local bagObjectRight = nil
local heldDrop = nil
CurrentDrop = nil

-- Functions

function GetDrops()
    RSGCore.Functions.TriggerCallback('rsg-inventory:server:GetCurrentDrops', function(drops)
        if not drops then return end
        for k, v in pairs(drops) do
            local bag = NetworkGetEntityFromNetworkId(v.entityId)
            if DoesEntityExist(bag) then
                local targetOptions = {
                    {
                        name = 'inventory_main_openDrop',
                        icon = 'fa-solid fa-eye',
                        targeticon = 'fa-solid fa-eye',
                        label = Lang:t('menu.o_bag'),
                        onSelect = function()
                            TriggerServerEvent('rsg-inventory:server:openDrop', k)
                            CurrentDrop = k
                        end,
                        canInteract = function(_, distance)
                            return distance < 3.0
                        end
                    }
                }
                exports.ox_target:addLocalEntity(bag, targetOptions)
            end
        end
    end)
end

-- Events

RegisterNetEvent('rsg-inventory:client:removeDropTarget', function(dropId)
    while not NetworkDoesNetworkIdExist(dropId) do Wait(10) end
    local bag = NetworkGetEntityFromNetworkId(dropId)
    while not DoesEntityExist(bag) do Wait(10) end
    exports.ox_target:removeLocalEntity(bag)
end)

RegisterNetEvent('rsg-inventory:client:setupDropTarget', function(dropId)
    while not NetworkDoesNetworkIdExist(dropId) do Wait(10) end
    local bag = NetworkGetEntityFromNetworkId(dropId)
    while not DoesEntityExist(bag) do Wait(10) end
    local newDropId = 'drop-' .. dropId
    exports.ox_target:addLocalEntity(bag, {
        options = {
            {
                icon = 'fas fa-backpack',
                label = Lang:t('menu.o_bag'),
                onSelect = function()
                    TriggerServerEvent('rsg-inventory:server:openDrop', newDropId)
                    CurrentDrop = newDropId
                end,
            },
            {
                icon = 'fas fa-hand-pointer',
                label = 'Pick up bag',
                onSelect = function()
                    local weapon = GetPedCurrentHeldWeapon(PlayerPedId())
                    if weapon ~= `WEAPON_UNARMED` then
                        return lib.notify({ title = 'Error', description = 'You can not be holding a Gun and a Bag!', type = 'error', duration = 5500 })
                    end
                    if holdingDrop then -- and bagObject and bagObjectRight 
                        return lib.notify({ title = 'Error', description = 'Your already holding a bag, Go Drop it!', type = 'error', duration = 5500 })
                    end
                    Citizen.InvokeNative(0x524B54361229154F, PlayerPedId(), GetHashKey("RANSACK_FALLBACK_PICKUP_CROUCH"), 0, 1, GetHashKey("RANSACK_PICKUP_H_0m0_FALLBACK_CROUCH"), -1.0, 0)
                    Wait(1000)
                    local boneIndex = nil
                    -- local attachToLeft = false

                    -- if Config.HandSelect == 'left' then -- not bagObject
                        boneIndex = GetEntityBoneIndexByName(PlayerPedId(), Config.ItemDropObjectBoneLeft)
                        -- attachToLeft = true
                    -- elseif Config.HandSelect == 'right' then
                    --     boneIndex = GetEntityBoneIndexByName(PlayerPedId(), Config.ItemDropObjectBoneRight)
                    -- end

                    AttachEntityToEntity(
                        bag,
                        PlayerPedId(),
                        boneIndex,
                        Config.ItemDropObjectOffsetLeft[1].x, --  or Config.ItemDropObjectOffsetRight[1].x,
                        Config.ItemDropObjectOffsetLeft[1].y, --  or Config.ItemDropObjectOffsetRight[1].y,
                        Config.ItemDropObjectOffsetLeft[1].z, --  or Config.ItemDropObjectOffsetRight[1].z,
                        Config.ItemDropObjectOffsetLeft[2].x, --  or Config.ItemDropObjectOffsetRight[2].x,
                        Config.ItemDropObjectOffsetLeft[2].y, --  or Config.ItemDropObjectOffsetRight[2].y,
                        Config.ItemDropObjectOffsetLeft[2].z, --  or Config.ItemDropObjectOffsetRight[2].z,
                        true, true, false, true, 1, true
                    )
                    -- Actualiza el estado de la bolsa adjunta
                    -- if attachToLeft then
                        bagObject = bag
                        -- attachToLeft = true
                    -- else
                    --     bagObjectRight = bag
                    -- end

                    holdingDrop = true
                    heldDrop = newDropId
                    exports['rsg-core']:DrawText('Press [G] to drop the bag')
                end,
            }
        },
        distance = 2.5,
    })
end)

-- NUI Callbacks

RegisterNUICallback('DropItem', function(item, cb)
    RSGCore.Functions.TriggerCallback('rsg-inventory:server:createDrop', function(dropId)
        if dropId then
            Citizen.InvokeNative(0x524B54361229154F, PlayerPedId(), GetHashKey("RANSACK_FALLBACK_PICKUP_CROUCH"), 0, 1, GetHashKey("RANSACK_PICKUP_H_0m0_FALLBACK_CROUCH"), -1.0, 0)
            while not NetworkDoesNetworkIdExist(dropId) do Wait(10) end
            local bag = NetworkGetEntityFromNetworkId(dropId)
            SetModelAsNoLongerNeeded(bag)
			local coords = GetEntityCoords(PlayerPedId())
			local forward = GetEntityForwardVector(PlayerPedId())
			local x, y, z = table.unpack(coords + forward * 0.57)
			SetEntityCoords(bag, x, y, z - 0.9, false, false, false, false)
			SetEntityRotation(bag, 0.0, 0.0, 0.0, 2)
			PlaceObjectOnGroundProperly(bag)
            FreezeEntityPosition(bag, true)
            local newDropId = 'drop-' .. dropId
            cb(newDropId)
        else
            cb(false)
        end
    end, item)
end)

-- Thread
CreateThread(function()
    while true do
        if holdingDrop then
            -- if IsControlJustPressed(0, 0xB2F377E8) then -- F
                -- Citizen.InvokeNative(0x524B54361229154F, PlayerPedId(), GetHashKey("RANSACK_FALLBACK_PICKUP_CROUCH"), 0, 1, GetHashKey("RANSACK_PICKUP_H_0m0_FALLBACK_CROUCH"), -1.0, 0)
				-- Wait(1000)
                -- if bagObjectRight then
                --     DetachEntity(bagObjectRight, true, true)
                --     local coords = GetEntityCoords(PlayerPedId())
                --     local forward = GetEntityForwardVector(PlayerPedId())
                --     local x, y, z = table.unpack(coords + forward * 0.57)
                --     SetEntityCoords(bagObjectRight, x, y, z - 0.9, false, false, false, false)
                --     SetEntityRotation(bagObjectRight, 0.0, 0.0, 0.0, 2)
                --     PlaceObjectOnGroundProperly(bagObjectRight)
                --     FreezeEntityPosition(bagObjectRight, true)
                --     exports['rsg-core']:HideText()
                --     TriggerServerEvent('rsg-inventory:server:updateDrop', heldDrop, coords)
                --     holdingDrop = false
                --     bagObject = nil
                --     heldDrop = nil
                -- end
            -- end
            if IsControlJustPressed(0, 0x760A9C6F) then
                Citizen.InvokeNative(0x524B54361229154F, PlayerPedId(), GetHashKey("RANSACK_FALLBACK_PICKUP_CROUCH"), 0, 1, GetHashKey("RANSACK_PICKUP_H_0m0_FALLBACK_CROUCH"), -1.0, 0)
				Wait(1000)
                DetachEntity(bagObject, true, true)
                local coords = GetEntityCoords(PlayerPedId())
                local forward = GetEntityForwardVector(PlayerPedId())
                local x, y, z = table.unpack(coords + forward * 0.57)
                SetEntityCoords(bagObject, x, y, z - 0.9, false, false, false, false)
                SetEntityRotation(bagObject, 0.0, 0.0, 0.0, 2)
                PlaceObjectOnGroundProperly(bagObject)
                FreezeEntityPosition(bagObject, true)
                exports['rsg-core']:HideText()
                TriggerServerEvent('rsg-inventory:server:updateDrop', heldDrop, coords)
                holdingDrop = false
                bagObject = nil
                heldDrop = nil
            end
        end
        Wait(0)
    end
end)
