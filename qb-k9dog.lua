-- qb-k9dog.lua made by Xanakin_ for the Immense Roleplay Community
QBCore = exports['qb-core']:GetCoreObject()

-- Configuration
Config = {}
Config.K9Models = {
    ['shepherd'] = {
        model = 'a_c_shepherd',
        staminaMultiplier = 1.49,
        biteDamage = 50,
        tackleDamage = 30,
        sniffRadius = 10.0,
        healthLossInWater = true,
    },
    ['rottweiler'] = {
        model = 'a_c_rottweiler',
        staminaMultiplier = 1.25,
        biteDamage = 60,
        tackleDamage = 35,
        sniffRadius = 8.0,
        healthLossInWater = true,
    },
    ['retriever'] = {
        model = 'a_c_retriever',
        staminaMultiplier = 1.35,
        biteDamage = 45,
        tackleDamage = 25,
        sniffRadius = 12.0,
        healthLossInWater = false,
    },
    -- Add more K9 models with different stats as needed
}

-- Drugs Configuration
Config.DrugsList = {
    cantSmell = {
        'coke', 'bluedream_seed', 'banana_kush_joint', 'banana_kush_seed', 'purple_haze_seed',
        'reg_weed_bud', 'banana_kush_bud'
    },
    canSmell = {
        'strawberry_weed_joint', 'bluedream_weed_joint', 'banana_kush_weed_joint', 'purple_haze_joint'
    }
}

-- Keybinds (Change keys here)
Config.KeyBindSearchInventory = 'G'
Config.KeyBindDogBite = 'H'
Config.KeyBindDogTackle = 'J'
Config.KeyBindDogSniff = 'K'

local selectedK9 = nil

-- Utility Function to Play Animation
function PlayEmote(ped, animDict, animName, duration)
    RequestAnimDict(animDict)
    while not HasAnimDictLoaded(animDict) do
        Wait(0)
    end
    TaskPlayAnim(ped, animDict, animName, 8.0, 8.0, duration, 1, 0, false, false, false)
end

-- K9 Selection Menu
RegisterCommand('k9', function(source, args, rawCommand)
    local src = source
    local ped = GetPlayerPed(src)

    -- Menu logic
    TriggerEvent('qb-k9dog:openMenu')
end, false)

RegisterNetEvent('qb-k9dog:openMenu')
AddEventHandler('qb-k9dog:openMenu', function()
    local menuOptions = {}

    for k9Name, k9Data in pairs(Config.K9Models) do
        table.insert(menuOptions, {
            title = k9Name:gsub("^%l", string.upper), -- Capitalize first letter
            description = string.format("Bite Damage: %d, Tackle Damage: %d, Sniff Radius: %.1f, Health Loss in Water: %s", k9Data.biteDamage, k9Data.tackleDamage, k9Data.sniffRadius, k9Data.healthLossInWater and 'Yes' or 'No'),
            event = 'qb-k9dog:selectK9',
            args = k9Name
        })
    end

    exports['qb-menu']:openMenu(menuOptions)
end)

RegisterNetEvent('qb-k9dog:selectK9')
AddEventHandler('qb-k9dog:selectK9', function(k9Name)
    local src = source
    local ped = GetPlayerPed(src)
    selectedK9 = Config.K9Models[k9Name]

    if selectedK9 then
        -- Change the player's model to the selected K9 model
        RequestModel(selectedK9.model)
        while not HasModelLoaded(selectedK9.model) do
            Wait(0)
        end
        SetPlayerModel(src, selectedK9.model)
        SetModelAsNoLongerNeeded(selectedK9.model)

        -- Apply K9 stats
        SetRunSprintMultiplierForPlayer(src, selectedK9.staminaMultiplier)
        -- Reset health and ensure proper model setup
        SetEntityHealth(ped, 200)
    end
end)

-- Inventory Search with Emote
RegisterCommand('k9searchInventory', function(source, args, rawCommand)
    local src = source
    local ped = GetPlayerPed(src)
    local coords = GetEntityCoords(ped)
    local nearbyPlayers = QBCore.Functions.GetPlayersFromCoords(coords, 2.0)

    for _, playerId in ipairs(nearbyPlayers) do
        local targetPed = GetPlayerPed(playerId)
        if targetPed ~= ped then
            -- Play search emote on both the dog and the target
            PlayEmote(ped, 'creatures@rottweiler@melee@streamed_taunts@', 'taunt_01', 2000)
            PlayEmote(targetPed, 'random@mugging3', 'handsup_standing_base', 2000)

            TriggerServerEvent('qb-k9dog:searchInventory', playerId)
        end
    end
end, false)

RegisterNetEvent('qb-k9dog:searchInventory')
AddEventHandler('qb-k9dog:searchInventory', function(playerId)
    local Player = QBCore.Functions.GetPlayer(playerId)
    if Player then
        local items = Player.Functions.GetItems()
        -- Display items to the dog
        for _, item in ipairs(items) do
            print('Found item:', item.name)
        end
    end
end)

-- Bite Action with Emote
RegisterCommand('k9dogBite', function(source, args, rawCommand)
    local src = source
    local ped = GetPlayerPed(src)
    local coords = GetEntityCoords(ped)
    local nearbyPlayers = QBCore.Functions.GetPlayersFromCoords(coords, 2.0)

    if selectedK9 then
        for _, playerId in ipairs(nearbyPlayers) do
            local targetPed = GetPlayerPed(playerId)
            if targetPed ~= ped then
                -- Play bite emote on both the dog and the target
                PlayEmote(ped, 'creatures@rottweiler@melee@streamed_taunts@', 'taunt_01', 2000)
                PlayEmote(targetPed, 'missprologueig_2', 'end_loop_michael', 2000)

                ApplyDamageToPed(targetPed, selectedK9.biteDamage, false)
            end
        end
    end
end, false)

-- Tackle Action with Emote
RegisterCommand('k9dogTackle', function(source, args, rawCommand)
    local src = source
    local ped = GetPlayerPed(src)
    local coords = GetEntityCoords(ped)
    local nearbyPlayers = QBCore.Functions.GetPlayersFromCoords(coords, 2.0)

    if selectedK9 then
        for _, playerId in ipairs(nearbyPlayers) do
            local targetPed = GetPlayerPed(playerId)
            if targetPed ~= ped then
                -- Play tackle emote on both the dog and the target
                PlayEmote(ped, 'creatures@rottweiler@melee@', 'dog_takedown_reverse', 2000)
                SetPedToRagdoll(targetPed, 5000, 5000, 0, true, true, false)
                ApplyDamageToPed(targetPed, selectedK9.tackleDamage, false)
            end
        end
    end
end, false)

-- Health Loss in Water
CreateThread(function()
    while true do
        local ped = GetPlayerPed(-1)
        if IsEntityInWater(ped) then
            if selectedK9 and selectedK9.healthLossInWater then
                SetEntityHealth(ped, 0)
            end
        end
        Wait(1000)
    end
end)

-- Sniff Out Drugs with Emote
RegisterCommand('k9dogSniff', function(source, args, rawCommand)
    local src = source
    local ped = GetPlayerPed(src)
    local coords = GetEntityCoords(ped)
    local nearbyPlayers = QBCore.Functions.GetPlayersFromCoords(coords, selectedK9 and selectedK9.sniffRadius or 10.0)

    if selectedK9 then
        for _, playerId in ipairs(nearbyPlayers) do
            local targetPed = GetPlayerPed(playerId)
            if targetPed ~= ped then
                -- Play sniff emote on the dog
                PlayEmote(ped, 'creatures@rottweiler@indication@', 'indicate_high', 2000)

                TriggerServerEvent('qb-k9dog:sniffPlayer', playerId)
            end
        end
    end
end, false)

RegisterNetEvent('qb-k9dog:sniffPlayer')
AddEventHandler('qb-k9dog:sniffPlayer', function(playerId)
    local Player = QBCore.Functions.GetPlayer(playerId)
    if Player then
        local items = Player.Functions.GetItems()
        for _, item in ipairs(items) do
            local itemName = item.name:lower()
            if itemName then
                if table.contains(Config.DrugsList.canSmell, itemName) then
                    print('Dog found a drug:', item.name)
                    -- Trigger an alert or any other action here
                elseif table.contains(Config.DrugsList.cantSmell, itemName) then
                    print('Dog cannot detect this item:', item.name)
                end
            end
        end
    end
end)

-- Keybinds
RegisterKeyMapping('k9searchInventory', 'K9 Search Inventory', 'keyboard', Config.KeyBindSearchInventory)
RegisterKeyMapping('k9dogBite', 'K9 Bite', 'keyboard', Config.KeyBindDogBite)
RegisterKeyMapping('k9dogTackle', 'K9 Tackle', 'keyboard', Config.KeyBindDogTackle)
RegisterKeyMapping('k9dogSniff', 'K9 Sniff', 'keyboard', Config.KeyBindDogSniff)
