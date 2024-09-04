local quests = {}
local dialogTrees = {}
local npcLocations = {}

-- Function to load quests from the database (if using a database)
local function LoadQuests()
    -- Load quests from a database or a file
end

-- Function to save quests to the database
local function SaveQuest(questId, questData)
    -- Save quest to a database or a file
end

-- Admin menu for quest configuration
RegisterCommand('questadmin', function(source)
    local src = source
    TriggerClientEvent('questadmin:open', src)
end, true)

-- Admin Menu Configuration
RegisterNetEvent('questadmin:open')
AddEventHandler('questadmin:open', function()
    local src = source
    local questConfig = {
        availableQuestIds = GetAvailableQuestIds(),
        availableNPCs = GetAvailableNPCs(),
        availableDialogTrees = GetAvailableDialogTrees(),
    }
    TriggerClientEvent('questadmin:openMenu', src, questConfig)
end)

-- Event to create a new quest
RegisterNetEvent('createQuest')
AddEventHandler('createQuest', function(questData)
    local questId = #quests + 1
    quests[questId] = questData
    SaveQuest(questId, questData)
end)

-- Event to create a new dialog tree
RegisterNetEvent('createDialogTree')
AddEventHandler('createDialogTree', function(dialogTreeData)
    local treeId = #dialogTrees + 1
    dialogTrees[treeId] = dialogTreeData
    -- Save dialog tree to a database or a file if needed
end)

-- Event to add an NPC to the quest
RegisterNetEvent('addNPCToQuest')
AddEventHandler('addNPCToQuest', function(npcData)
    local npcId = #npcLocations + 1
    npcLocations[npcId] = npcData
    -- Save NPC location to a database or a file if needed
end)

-- Event to spawn a quest NPC
RegisterNetEvent('spawnQuestNPC')
AddEventHandler('spawnQuestNPC', function(npcData)
    local npcId = #npcLocations + 1
    npcLocations[npcId] = npcData
    TriggerClientEvent('spawnNPC', -1, npcData)
end)

-- Handling quest start from dialog
RegisterNetEvent('dialog:response')
AddEventHandler('dialog:response', function(nodeId, responseIndex)
    local src = source
    local node = dialogTrees[nodeId]
    local response = node.responses[responseIndex]

    if response.questTrigger then
        TriggerClientEvent('quest:start', src, response.questTrigger)
    end

    if response.nextNode then
        TriggerClientEvent('dialog:nextNode', src, response.nextNode)
    end
end)

-- Event to start a quest
RegisterNetEvent('quest:start')
AddEventHandler('quest:start', function(questId)
    local src = source
    local quest = quests[questId]

    if quest then
        -- Initialize quest objectives
        TriggerClientEvent('quest:init', src, quest)
    end
end)

-- Expanded Client-side Quest Admin Menu
RegisterNetEvent('questadmin:openMenu')
AddEventHandler('questadmin:openMenu', function(questConfig)
    -- Open the NUI or a similar interface to configure the quest

    -- Example: Displaying options to admin
    TriggerClientEvent('questadmin:displayMenu', -1, {
        questName = "Example Quest",
        description = "Kill 5 bandits at the marked location.",
        prerequisites = {"Another Quest Completed", "Minimum Level 5"},
        objectives = {
            {type = "kill", target = "bandit", count = 5, location = {x = 123, y = 456, z = 789}},
            {type = "collect", item = "herb", count = 3, location = {x = 111, y = 222, z = 333}},
        },
        rewards = {
            money = 100,
            items = {["gold_bar"] = 1},
            xp = 50
        },
        failureConditions = {"Fail to complete within 24 hours"},
        successDialog = "Thank you for your help! Here is your reward.",
        failureDialog = "You failed to complete the task. Better luck next time.",
        npcSelection = "Quest Giver",
        dialogTree = "Tree 1"
    })
end)

-- Client-side handling of NPC spawning
RegisterNetEvent('spawnNPC')
AddEventHandler('spawnNPC', function(npcData)
    local model = GetHashKey(npcData.model)
    
    -- Ensure the model is loaded
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(1)
    end

    -- Create the NPC
    local npc = CreatePed(4, model, npcData.location.x, npcData.location.y, npcData.location.z, 0.0, false, true)
    SetEntityAsMissionEntity(npc, true, true)
    FreezeEntityPosition(npc, true)
    SetModelAsNoLongerNeeded(model)

    -- Add blip or marker if needed
end)

-- Client-side event to open the admin menu
RegisterNetEvent('openQuestAdminMenu')
AddEventHandler('openQuestAdminMenu', function()
    -- Open the menu using NUI or any other method
    -- Admins can create quests, dialog trees, and assign NPCs to quests here
end)

-- Client-side event to handle quest initialization
RegisterNetEvent('quest:init')
AddEventHandler('quest:init', function(quest)
    -- Initialize the quest for the player, show objectives, etc.
end)

-- Client-side event to progress to the next dialog node
RegisterNetEvent('dialog:nextNode')
AddEventHandler('dialog:nextNode', function(nextNodeId)
    -- Progress the dialog based on the node ID
end)

-- Server event to handle admin menu actions
RegisterNetEvent('questadmin:action')
AddEventHandler('questadmin:action', function(action, data)
    local src = source

    if action == "createQuest" then
        local questId = #quests + 1
        quests[questId] = data
        SaveQuest(questId, data)
    elseif action == "createDialogTree" then
        local treeId = #dialogTrees + 1
        dialogTrees[treeId] = data
    elseif action == "addNPC" then
        local npcId = #npcLocations + 1
        npcLocations[npcId] = data
        TriggerClientEvent('spawnNPC', -1, data)
    end

    -- Feedback to admin
    TriggerClientEvent('notification', src, "Action successful!")
end)

-- Utility functions to manage quests, dialogs, and NPCs
function GetAvailableQuestIds()
    -- Return a list of available quest IDs
    return quests
end

function GetAvailableNPCs()
    -- Return a list of available NPCs for quest assignment
    return npcLocations
end

function GetAvailableDialogTrees()
    -- Return a list of available dialog trees
    return dialogTrees
end

-- Define example quests with NPC interactions and dialog trees
local exampleQuests = {
    -- Act 1: Betrayal and Investigation
    {
        name = "The First Betrayal",
        description = "Investigate the betrayal within your ranks.",
        prerequisites = {},
        objectives = {
            {type = "investigate", location = {x = -500, y = 1000, z = 0}},
        },
        rewards = {
            money = 50,
            items = {},
            xp = 25
        },
        failureConditions = {},
        successDialog = "The betrayal is confirmed. Now you must decide how to handle it.",
        failureDialog = "The betrayal is not clear. You need to investigate further.",
        responses = {
            {text = "I’ll confront the traitor.", questTrigger = 2, nextNode = 4},
            {text = "I need more information.", nextNode = 5}
        }
    },
    -- Act 2: Murder and Lies
    {
        name = "The Murder Mystery",
        description = "Investigate a murder that might be connected to the betrayal.",
        prerequisites = {"The First Betrayal"},
        objectives = {
            {type = "investigate", location = {x = -700, y = 1200, z = 0}},
        },
        rewards = {
            money = 100,
            items = {},
            xp = 75
        },
        failureConditions = {},
        successDialog = "You've gathered enough clues about the murder.",
        failureDialog = "The investigation didn't reveal much. You need more time.",
        responses = {
            {text = "I’ll follow the new leads.", questTrigger = 3, nextNode = 6},
            {text = "I need more time to investigate.", nextNode = 7}
        }
    },
    {
        name = "The Lover’s Secret",
        description = "Uncover the truth about the lover involved in the betrayal.",
        prerequisites = {"The Murder Mystery"},
        objectives = {
            {type = "investigate", location = {x = -800, y = 1300, z = 0}},
        },
        rewards = {
            money = 150,
            items = {},
            xp = 100
        },
        failureConditions = {},
        successDialog = "You've learned the truth about the lover's involvement.",
        failureDialog = "The truth about the lover remains hidden. Try again.",
        responses = {
            {text = "Confront the lover with what I know.", questTrigger = 4, nextNode = 8},
            {text = "I need more evidence.", nextNode = 9}
        }
    },
    -- Act 3: The Deal and Final Showdown
    {
        name = "The Dangerous Deal",
        description = "Make a risky deal to resolve the ongoing conflict.",
        prerequisites = {"The Lover’s Secret"},
        objectives = {
            {type = "interact", location = {x = -900, y = 1400, z = 0}},
        },
        rewards = {
            money = 200,
            items = {},
            xp = 150
        },
        failureConditions = {},
        successDialog = "The deal is made. The conflict might be over.",
        failureDialog = "The deal failed. The conflict continues.",
        responses = {
            {text = "Proceed with the deal.", questTrigger = 5, nextNode = 10},
            {text = "Abandon the deal.", nextNode = 11}
        }
    },
    {
        name = "The Final Confrontation",
        description = "Confront the main antagonist and end the conflict.",
        prerequisites = {"The Dangerous Deal"},
        objectives = {
            {type = "confront", location = {x = -1000, y = 1500, z = 0}},
        },
        rewards = {
            money = 300,
            items = {["gold_bar"] = 2},
            xp = 200
        },
        failureConditions = {},
        successDialog = "The antagonist is defeated. The conflict is over.",
        failureDialog = "The confrontation failed. The conflict continues.",
        responses = {
            {text = "Finish the confrontation.", questTrigger = 6},
            {text = "Retreat and regroup.", nextNode = 12}
        }
    }
}

-- Add example quests and NPCs
for _, quest in ipairs(exampleQuests) do
    local questId = #quests + 1
    quests[questId] = quest
    SaveQuest(questId, quest)
end

npcLocations[1] = {
    model = "a_m_m_farmer_01", -- Red Dead Redemption 2 model
    location = {x = -500, y = 1000, z = 0},
    dialog = {
        "I've been feeling uneasy lately. Something's not right.",
        "You should investigate the area for any clues."
    }
}

npcLocations[2] = {
    model = "a_f_m_downtown_01", -- Red Dead Redemption 2 model
    location = {x = -700, y = 1200, z = 0},
    dialog = {
        "The murder scene is a grim reminder of the dangers we face.",
        "Look for any signs of struggle or hidden clues."
    }
}

npcLocations[3] = {
    model = "a_m_m_southern_dandy_01", -- Red Dead Redemption 2 model
    location = {x = -800, y = 1300, z = 0},
    dialog = {
        "The lover’s involvement is a twist I didn’t see coming.",
        "Be cautious. The truth might be more dangerous than you think."
    }
}

npcLocations[4] = {
    model = "a_f_m_maid_01", -- Red Dead Redemption 2 model
    location = {x = -900, y = 1400, z = 0},
    dialog = {
        "The alliance we’re forming is risky but necessary.",
        "Remember, this alliance might be a double-edged sword."
    }
}

npcLocations[5] = {
    model = "a_m_m_town_01", -- Red Dead Redemption 2 model
    location = {x = -1000, y = 1500, z = 0},
    dialog = {
        "The deal is treacherous, but it’s the only way forward.",
        "Be careful. This deal might come back to haunt you."
    }
}

npcLocations[6] = {
    model = "a_f_m_broad_01", -- Red Dead Redemption 2 model
    location = {x = -1100, y = 1600, z = 0},
    dialog = {
        "The truth is explosive. Handle it with care.",
        "Uncovering the truth might be your downfall or your salvation."
    }
}

npcLocations[7] = {
    model = "a_m_m_wagoner_01", -- Red Dead Redemption 2 model
    location = {x = -1200, y = 1700, z = 0},
    dialog = {
        "This is it. The final confrontation.",
        "End this now, or you’ll never be free from the chaos."
    }
}

-- Utility functions to manage quests, dialogs, and NPCs
function GetAvailableQuestIds()
    -- Return a list of available quest IDs
    return quests
end

function GetAvailableNPCs()
    -- Return a list of available NPCs for quest assignment
    return npcLocations
end

function GetAvailableDialogTrees()
    -- Return a list of available dialog trees
    return dialogTrees
end

-- Initialization
AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        LoadQuests()
    end
end)
