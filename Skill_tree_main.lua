-- Define skill categories and perks
local SKILL_CATEGORIES = {
    casual_play = {
        name = "Casual Play",
        perks = {
            { id = 1, name = "Quick Reflexes", description = "Increases reaction speed.", points = 5 },
            { id = 2, name = "Enhanced Stamina", description = "Boosts stamina regeneration.", points = 6 },
            { id = 3, name = "Resourcefulness", description = "Reduces cost of consumables.", points = 4 },
            { id = 4, name = "Lucky Find", description = "Increases chance of finding rare items.", points = 5 },
            { id = 5, name = "Hardened Resolve", description = "Reduces effect of negative status.", points = 6 },
            { id = 6, name = "Negotiator", description = "Reduces service costs.", points = 7 },
            { id = 7, name = "Adrenaline Rush", description = "Boosts temporary speed and strength.", points = 8 },
            { id = 8, name = "Comfortable Living", description = "Reduces hunger and thirst rates.", points = 6 },
            { id = 9, name = "Charismatic", description = "Increases persuasion success rate.", points = 5 },
            { id = 10, name = "Eagle Eye", description = "Enhances ranged weapon accuracy.", points = 7 },
            -- Additional perks
            { id = 11, name = "Tactical Advantage", description = "Improves combat strategy.", points = 6 },
            { id = 12, name = "Survival Instinct", description = "Increases awareness of surroundings.", points = 7 },
            { id = 13, name = "Quick Learner", description = "Speeds up skill learning.", points = 5 },
            { id = 14, name = "Master Collector", description = "Increases collection efficiency.", points = 6 },
            { id = 15, name = "Efficient Travel", description = "Reduces travel fatigue.", points = 7 },
            { id = 16, name = "Expert Navigator", description = "Improves navigation and map reading.", points = 8 },
            { id = 17, name = "Resource Savvy", description = "Increases resource gathering rates.", points = 6 },
            { id = 18, name = "Resilient", description = "Reduces damage from falls and accidents.", points = 7 },
            { id = 19, name = "Adrenaline Control", description = "Enhances control during high-stress situations.", points = 8 },
            { id = 20, name = "Luck of the Draw", description = "Further increases chances of rare finds.", points = 9 }
        }
    },
    native_american = {
        name = "Native American",
        perks = {
            { id = 1, name = "Nature's Wisdom", description = "Improves foraging efficiency.", points = 5 },
            { id = 2, name = "Herbal Mastery", description = "Enhances herbal remedies.", points = 6 },
            { id = 3, name = "Animal Kinship", description = "Increases affinity with animals.", points = 7 },
            { id = 4, name = "Spirit Guide", description = "Enhances spiritual perception.", points = 6 },
            { id = 5, name = "Tribal Camouflage", description = "Improves camouflage in wilderness.", points = 7 },
            -- Additional perks
            { id = 6, name = "Eagle's Sight", description = "Enhances vision in low light.", points = 6 },
            { id = 7, name = "Medicine Man", description = "Boosts healing from traditional methods.", points = 8 },
            { id = 8, name = "Sky Dancer", description = "Increases agility and movement speed.", points = 7 },
            { id = 9, name = "Warrior's Spirit", description = "Improves combat skills.", points = 6 },
            { id = 10, name = "Ancient Wisdom", description = "Enhances knowledge of ancient traditions.", points = 8 },
            { id = 11, name = "Silent Tracker", description = "Increases stealth while tracking.", points = 7 },
            { id = 12, name = "Cultural Heritage", description = "Boosts interactions with tribal members.", points = 6 },
            { id = 13, name = "Sacred Grounds", description = "Increases effectiveness in sacred places.", points = 8 },
            { id = 14, name = "Nature's Call", description = "Improves animal communication.", points = 7 },
            { id = 15, name = "Sky Watcher", description = "Enhances ability to predict weather patterns.", points = 6 },
            { id = 16, name = "Mystic Arts", description = "Improves effectiveness of mystical practices.", points = 8 },
            { id = 17, name = "Totem Master", description = "Enhances the power of totems.", points = 7 },
            { id = 18, name = "Earth's Embrace", description = "Increases physical resilience.", points = 6 },
            { id = 19, name = "Ancient Rituals", description = "Boosts the potency of ancient rituals.", points = 8 },
            { id = 20, name = "Elders' Blessing", description = "Grants powerful blessings from elders.", points = 9 }
        }
    },
    black_smithing = {
        name = "Black Smithing",
        perks = {
            { id = 1, name = "Forging Speed", description = "Reduces time needed to forge items.", points = 5 },
            { id = 2, name = "Enhanced Durability", description = "Improves item durability.", points = 6 },
            { id = 3, name = "Precise Crafting", description = "Reduces material waste in crafting.", points = 7 },
            { id = 4, name = "Artisan's Touch", description = "Increases the value of crafted items.", points = 6 },
            -- Additional perks
            { id = 5, name = "Metal Mastery", description = "Increases effectiveness with different metals.", points = 7 },
            { id = 6, name = "Tool Proficiency", description = "Enhances the effectiveness of smithing tools.", points = 6 },
            { id = 7, name = "Forging Artistry", description = "Boosts the aesthetic quality of crafted items.", points = 8 },
            { id = 8, name = "Smith's Strength", description = "Improves physical strength for smithing tasks.", points = 7 },
            { id = 9, name = "Efficient Smelting", description = "Increases efficiency in smelting ores.", points = 6 },
            { id = 10, name = "Advanced Techniques", description = "Unlocks advanced smithing techniques.", points = 8 },
            { id = 11, name = "Legendary Smith", description = "Enhances the overall quality of crafted legendary items.", points = 9 },
            { id = 12, name = "Refinement Specialist", description = "Improves the refinement process of materials.", points = 7 },
            { id = 13, name = "Precision Hammering", description = "Increases precision during hammering.", points = 6 },
            { id = 14, name = "Resilient Materials", description = "Improves the resilience of materials used in crafting.", points = 8 },
            { id = 15, name = "Forging Perfection", description = "Achieves near-perfect forging results.", points = 9 },
            { id = 16, name = "Smith's Knowledge", description = "Enhances overall knowledge of blacksmithing.", points = 7 },
            { id = 17, name = "Crafting Mastery", description = "Boosts mastery over all crafting processes.", points = 8 },
            { id = 18, name = "Metalworking Genius", description = "Increases ingenuity in metalworking.", points = 6 },
            { id = 19, name = "Artisan's Precision", description = "Enhances precision in crafting intricate designs.", points = 7 },
            { id = 20, name = "Ultimate Forging", description = "Unlocks the ultimate forging abilities.", points = 10 }
        }
    },
    criminal = {
        name = "Criminal",
        perks = {
            { id = 1, name = "Lockpicking Master", description = "Improves lockpicking skills.", points = 5 },
            { id = 2, name = "Smooth Talker", description = "Enhances persuasion and negotiation skills.", points = 6 },
            { id = 3, name = "Quick Getaway", description = "Improves your ability to escape from dangerous situations.", points = 5 },
            { id = 4, name = "Disguise Expert", description = "Reduces the chance of being recognized in disguise.", points = 6 },
            { id = 5, name = "Master of Deception", description = "Enhances your ability to deceive others.", points = 7 },
            -- Additional perks
            { id = 6, name = "Undetected Movement", description = "Increases stealth and reduces detection.", points = 6 },
            { id = 7, name = "Negotiation Skills", description = "Improves outcomes of negotiations and deals.", points = 7 },
            { id = 8, name = "Criminal Influence", description = "Boosts influence over criminal networks.", points = 8 },
            { id = 9, name = "Safecracker", description = "Enhances skills in cracking safes and vaults.", points = 7 },
            { id = 10, name = "Escape Artist", description = "Improves ability to evade law enforcement.", points = 8 },
            { id = 11, name = "Heist Planning", description = "Boosts efficiency in planning heists.", points = 7 },
            { id = 12, name = "Shadow Manipulation", description = "Increases effectiveness in hiding and blending in.", points = 8 },
            { id = 13, name = "Master Forger", description = "Enhances skills in forgery and counterfeiting.", points = 9 },
            { id = 14, name = "Silent Approach", description = "Improves ability to move silently and unnoticed.", points = 6 },
            { id = 15, name = "Criminal Networks", description = "Expands and strengthens criminal connections.", points = 7 },
            { id = 16, name = "Cunning Planner", description = "Improves strategic planning for criminal activities.", points = 8 },
            { id = 17, name = "Undercover Skills", description = "Enhances effectiveness in undercover operations.", points = 7 },
            { id = 18, name = "Deceptive Charisma", description = "Increases charisma when deceiving others.", points = 6 },
            { id = 19, name = "Master of Disguise", description = "Unlocks advanced disguises and concealment methods.", points = 8 },
            { id = 20, name = "Criminal Genius", description = "Unlocks exceptional criminal capabilities.", points = 9 }
        }
    },
    hunting = {
        name = "Hunting",
        perks = {
            { id = 1, name = "Stealthy Hunter", description = "Improves stealth while hunting.", points = 5 },
            { id = 2, name = "Precision Shot", description = "Increases accuracy with ranged weapons.", points = 6 },
            { id = 3, name = "Tracker", description = "Enhances tracking abilities.", points = 5 },
            { id = 4, name = "Survivalist", description = "Boosts survival skills in the wilderness.", points = 7 },
            { id = 5, name = "Field Medic", description = "Improves first aid skills in the field.", points = 6 },
            -- Additional perks
            { id = 6, name = "Efficient Hunting", description = "Increases efficiency in hunting and gathering.", points = 7 },
            { id = 7, name = "Camouflage Expert", description = "Enhances ability to blend into surroundings.", points = 6 },
            { id = 8, name = "Rapid Reload", description = "Speeds up the reloading process for ranged weapons.", points = 7 },
            { id = 9, name = "Expert Tracker", description = "Increases skill in tracking elusive game.", points = 8 },
            { id = 10, name = "Survival Instincts", description = "Boosts instincts for survival in extreme conditions.", points = 7 },
            { id = 11, name = "Perfect Aim", description = "Enhances aim stability and accuracy.", points = 8 },
            { id = 12, name = "Game Master", description = "Improves handling and processing of game.", points = 7 },
            { id = 13, name = "Advanced Camouflage", description = "Unlocks advanced camouflage techniques.", points = 8 },
            { id = 14, name = "Precision Tracker", description = "Enhances precision while tracking.", points = 7 },
            { id = 15, name = "Master Hunter", description = "Achieves mastery in all hunting skills.", points = 9 },
            { id = 16, name = "Wilderness Expert", description = "Boosts overall knowledge of wilderness survival.", points = 8 },
            { id = 17, name = "Efficient Foraging", description = "Increases efficiency in foraging and gathering resources.", points = 6 },
            { id = 18, name = "Quiet Approach", description = "Enhances quiet movement to avoid spooking game.", points = 7 },
            { id = 19, name = "Advanced Tracking", description = "Unlocks advanced tracking abilities.", points = 8 },
            { id = 20, name = "Ultimate Hunter", description = "Unlocks ultimate hunting capabilities.", points = 10 }
        }
    },
    doctor_services = {
        name = "Doctor Services",
        perks = {
            { id = 1, name = "Advanced Medicine", description = "Improves healing efficiency.", points = 5 },
            { id = 2, name = "Efficient Treatments", description = "Reduces time required for treatments.", points = 6 },
            { id = 3, name = "Field Surgeon", description = "Enhances surgical skills in the field.", points = 7 },
            { id = 4, name = "Pain Management", description = "Improves ability to manage pain.", points = 6 },
            { id = 5, name = "Herbal Remedies", description = "Boosts effectiveness of herbal treatments.", points = 7 },
            -- Additional perks
            { id = 6, name = "Quick Recovery", description = "Speeds up patient recovery time.", points = 6 },
            { id = 7, name = "Medical Knowledge", description = "Enhances overall medical knowledge.", points = 8 },
            { id = 8, name = "Expert Diagnosis", description = "Improves diagnostic accuracy.", points = 7 },
            { id = 9, name = "Surgical Precision", description = "Increases precision during surgeries.", points = 8 },
            { id = 10, name = "Field Medic Mastery", description = "Achieves mastery in field medicine.", points = 9 },
            { id = 11, name = "Herbal Expert", description = "Unlocks advanced herbal treatment methods.", points = 8 },
            { id = 12, name = "Emergency Response", description = "Improves efficiency in emergency situations.", points = 7 },
            { id = 13, name = "Pain Relief Specialist", description = "Enhances ability to provide pain relief.", points = 6 },
            { id = 14, name = "Advanced Field Medicine", description = "Unlocks advanced field medical techniques.", points = 8 },
            { id = 15, name = "Medical Crafting", description = "Boosts effectiveness of medical crafting.", points = 7 },
            { id = 16, name = "Revitalizing Treatments", description = "Enhances revitalizing treatments and remedies.", points = 8 },
            { id = 17, name = "Surgical Mastery", description = "Unlocks ultimate surgical skills.", points = 9 },
            { id = 18, name = "Expert Practitioner", description = "Increases proficiency as a medical practitioner.", points = 7 },
            { id = 19, name = "Healing Arts", description = "Boosts the effectiveness of all healing practices.", points = 8 },
            { id = 20, name = "Ultimate Medical Knowledge", description = "Unlocks the ultimate in medical knowledge and skills.", points = 10 }
        }
    }
}

-- Function to get skill data for a player
local function getSkillData(player)
    local user = VORP.getUser(player)
    local char = user.getCharacter()
    local skillData = char:getData("skillTree") or { points = 0 }
    
    for category, data in pairs(SKILL_CATEGORIES) do
        if not skillData[category] then
            skillData[category] = {}
        end
        for _, perk in ipairs(data.perks) do
            if not skillData[category][perk.id] then
                skillData[category][perk.id] = false
            end
        end
    end

    return skillData
end

-- Function to unlock a perk
local function unlockPerk(player, category, perkId)
    local skillData = getSkillData(player)
    local user = VORP.getUser(player)
    local char = user.getCharacter()
    
    local perk = SKILL_CATEGORIES[category].perks[perkId]
    if not perk then
        return false, "Perk not found."
    end

    if skillData.points < perk.points then
        return false, "Not enough skill points."
    end

    skillData[category][perkId] = true
    skillData.points = skillData.points - perk.points
    char:setData("skillTree", skillData)

    -- Implement the perk effect based on the category and perkId
    applyPerkEffect(player, category, perkId)

    return true, "Perk unlocked."
end

-- Function to apply perk effects
local function applyPerkEffect(player, category, perkId)
    local user = VORP.getUser(player)
    if category == "casual_play" then
        if perkId == 1 then
            user:setReactionSpeed(user:getReactionSpeed() + 0.1)
        end
    elseif category == "native_american" then
        if perkId == 1 then
            user:setForagingEfficiency(user:getForagingEfficiency() + 0.2)
        end
    -- Add additional category effects here
    end
end

-- Command to open the skill tree menu
RegisterCommand("skilltree", function(source, args, rawCommand)
    local skillData = getSkillData(source)
    TriggerClientEvent("skilltree:openMenu", source, skillData)
end, false)

-- Event to handle perk unlocking
RegisterNetEvent("skilltree:unlockPerk")
AddEventHandler("skilltree:unlockPerk", function(category, perkId)
    local success, message = unlockPerk(source, category, perkId)
    TriggerClientEvent("chat:addMessage", source, { args = { "[SkillTree]", message } })
    local skillData = getSkillData(source)
    TriggerClientEvent("skilltree:openMenu", source, skillData)
end)

-- Client-side script for the menu
RegisterNetEvent("skilltree:openMenu")
AddEventHandler("skilltree:openMenu", function(skillData)
    local menu = {}
    
    menu.title = "Skill Tree"
    menu.items = {}
    
    table.insert(menu.items, {
        label = "Skill Points: " .. skillData.points,
        type = "text"
    })
    
    for category, data in pairs(SKILL_CATEGORIES) do
        table.insert(menu.items, {
            label = data.name,
            type = "header"
        })

        for _, perk in ipairs(data.perks) do
            local unlocked = skillData[category][perk.id] or false
            local buttonLabel = unlocked and "Unlocked" or ("Unlock - " .. perk.points .. " points")

            table.insert(menu.items, {
                label = perk.name .. ": " .. perk.description,
                type = "button",
                buttonText = buttonLabel,
                buttonCallback = function()
                    if not unlocked then
                        TriggerServerEvent("skilltree:unlockPerk", category, perk.id)
                    end
                end
            })
        end
    end

    -- Display the menu to the player
    VORP.ShowMenu(menu)
end)

-- Show menu on command
RegisterCommand("skilltree", function()
    TriggerServerEvent("skilltree:openMenu")
end, false)
