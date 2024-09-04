--Pig Race with leaderboard and weekly reward By: Xanakin_

-- VORP API Initialization
local VorpCore = {}
TriggerEvent("getCore", function(core)
    VorpCore = core
end)

-- Leaderboard Storage
local leaderboard = {}

-- Reward Item
local rewardItem = "goldbar"  -- Specify the item to be rewarded

-- NPC Location
local npcLocation = vector3(-815.59, -1277.13, 43.68)  -- Outside Blackwater Saloon

-- Register NPC
Citizen.CreateThread(function()
    local model = GetHashKey("CS_TomDickens")  -- Change to your preferred NPC model
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(1)
    end

    local npc = CreatePed(model, npcLocation, 0.0, true, true)
    FreezeEntityPosition(npc, true)
    SetEntityInvincible(npc, true)
    SetBlockingOfNonTemporaryEvents(npc, true)

    -- Interaction Event
    exports.vorp:addLocalEntity(npc, 'Pig Race', function()
        TriggerEvent('vorp:displayMenu')
    end)
end)

-- Display Menu
RegisterNetEvent('vorp:displayMenu')
AddEventHandler('vorp:displayMenu', function()
    local elements = {
        { label = "Join Pig Carry Race", value = 'join_race' },
        { label = "View Leaderboard", value = 'view_leaderboard' }
    }

    VorpCore.UI.Menu.Open('default', GetCurrentResourceName(), 'race_menu', {
        title = "Pig Carry Race",
        align = 'top-left',
        elements = elements
    }, function(data, menu)
        if data.current.value == 'join_race' then
            menu.close()
            TriggerEvent('vorp:startRace')
        elseif data.current.value == 'view_leaderboard' then
            menu.close()
            TriggerEvent('vorp:viewLeaderboard')
        end
    end, function(data, menu)
        menu.close()
    end)
end)

-- Start Race
RegisterNetEvent('vorp:startRace')
AddEventHandler('vorp:startRace', function()
    local player = PlayerPedId()
    local pigModel = GetHashKey("a_c_pig")

    RequestModel(pigModel)
    while not HasModelLoaded(pigModel) do
        Wait(1)
    end

    local pig = CreatePed(pigModel, npcLocation + vector3(1.0, 0.0, 0.0), 0.0, true, true)
    TaskStartScenarioInPlace(player, "PROP_HUMAN_BUM_BIN", 0, true)

    -- Wait for pickup
    Citizen.Wait(2000)
    ClearPedTasksImmediately(player)
    AttachEntityToEntity(pig, player, GetPedBoneIndex(player, 57005), 0.3, 0.0, 0.0, 0.0, 0.0, 0.0, true, true, false, true, 1, true)

    -- Start Timer
    local startTime = GetGameTimer()

    -- Monitor Race Progress
    Citizen.CreateThread(function()
        while true do
            local playerPos = GetEntityCoords(player)

            -- Check if the player has reached Saint Denis
            if Vdist(playerPos, 2731.67, -1231.52, 49.37) < 10.0 then  -- Saint Denis location
                local endTime = GetGameTimer()
                local timeTaken = (endTime - startTime) / 1000  -- Time in seconds

                TriggerServerEvent('vorp:submitRaceTime', timeTaken)
                DetachEntity(pig, true, true)
                DeleteEntity(pig)

                VorpCore.NotifyRightTip("You have completed the race in " .. timeTaken .. " seconds!", 5000)
                break
            end
            Wait(500)
        end
    end)
end)

-- View Leaderboard
RegisterNetEvent('vorp:viewLeaderboard')
AddEventHandler('vorp:viewLeaderboard', function()
    -- Generate leaderboard UI
    local elements = {}

    for i, entry in ipairs(leaderboard) do
        table.insert(elements, { label = entry.characterName .. " - " .. entry.time .. " seconds", value = i })
    end

    VorpCore.UI.Menu.Open('default', GetCurrentResourceName(), 'leaderboard_menu', {
        title = "Pig Carry Race Leaderboard",
        align = 'top-left',
        elements = elements
    }, function(data, menu)
        menu.close()
    end, function(data, menu)
        menu.close()
    end)
end)

-- Submit Race Time
RegisterServerEvent('vorp:submitRaceTime')
AddEventHandler('vorp:submitRaceTime', function(time)
    local source = source
    local Character = VorpCore.getUser(source).getUsedCharacter
    local charName = Character.firstname .. " " .. Character.lastname

    table.insert(leaderboard, { characterName = charName, time = time })
    table.sort(leaderboard, function(a, b) return a.time < b.time end)

    if #leaderboard > 10 then
        table.remove(leaderboard, #leaderboard)
    end
end)

-- Weekly Leaderboard Reset and Reward Distribution
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(7 * 24 * 60 * 60 * 1000)  -- 1 week

        -- Check if there's a winner
        if leaderboard[1] then
            local topPlayer = leaderboard[1].characterName

            -- Give reward to the top player
            for _, player in ipairs(GetPlayers()) do
                local Character = VorpCore.getUser(player).getUsedCharacter
                local charName = Character.firstname .. " " .. Character.lastname

                if charName == topPlayer then
                    TriggerClientEvent('vorp:giveReward', player)
                    VorpCore.NotifyRightTip("Congratulations! You have won the weekly race and received a " .. rewardItem .. "!", 5000)
                end
            end
        end

        -- Reset leaderboard
        leaderboard = {}
    end
end)

-- Give Reward to the Player
RegisterNetEvent('vorp:giveReward')
AddEventHandler('vorp:giveReward', function()
    local player = source
    local Character = VorpCore.getUser(player).getUsedCharacter
    local charIdentifier = Character.identifier

    -- Give the reward item
    VorpInv.addItem(charIdentifier, rewardItem, 1)  -- Adjust quantity if needed
end)
