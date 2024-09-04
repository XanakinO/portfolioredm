-- Restaurant Job with spawnable NPCs -Xanakin_
-- Simplified and Organized for Easy Configuration

-- Import VORP Core
local VorpCore = exports.vorp_core:vorpAPI()

-- Job Configuration
local job = 'restaurant'

-- Configurable Restaurant Menu
local restaurant_menu = {
    {item = "simple_dish", price = 5, skill = 1},    -- Simple Dish: Low skill, low price
    {item = "complex_dish", price = 15, skill = 3},  -- Complex Dish: Higher skill, higher price
}

-- Configurable Rank Progression
local rank_progression = {
    {rank = 1, profit = 10, wage = 5},   -- Rank 1: Low profit, low wage
    {rank = 2, profit = 15, wage = 10},  -- Rank 2: Medium profit, medium wage
    {rank = 3, profit = 25, wage = 15},  -- Rank 3: High profit, high wage
}

-- Configurable Customer Spawn Rate (in seconds)
local customer_spawn_rate = 10

-- Player Statistics (Automatically Managed)
local playerStats = {}

--------------------------------------------------
-- Initialization Functions
--------------------------------------------------

-- Initialize player statistics if not already set
local function initializePlayerStats(player)
    if not playerStats[player] then
        playerStats[player] = {
            total_cooked = 0,
            total_sales = 0,
            dishes = {}
        }
    end
end

--------------------------------------------------
-- Cooking and Sales Functions
--------------------------------------------------

-- Handle the cooking process, determine success based on skill
local function cookFood(player, food_item)
    local skill = getPlayerSkill(player)
    local success = math.random(0, 100)

    if success <= skill then
        -- Successful cooking
        TriggerClientEvent('vorp:notify', player, "Successfully cooked " .. food_item.item)
        updateCookStats(player, food_item.item)
    else
        -- Failed cooking
        TriggerClientEvent('vorp:notify', player, "Failed to cook " .. food_item.item)
    end
end

-- Update cooking stats when a dish is cooked
local function updateCookStats(player, dish)
    initializePlayerStats(player)
    playerStats[player].total_cooked = playerStats[player].total_cooked + 1
    if not playerStats[player].dishes[dish] then
        playerStats[player].dishes[dish] = 0
    end
    playerStats[player].dishes[dish] = playerStats[player].dishes[dish] + 1
end

-- Handle selling process, including bartering
local function sellFood(player, customer, food_item)
    local final_price = barterPrice(player, customer, food_item)
    updateSalesStats(player, food_item.item, final_price)
    -- Logic to complete the sale and give player money
    TriggerClientEvent('vorp:notify', player, "You sold " .. food_item.item .. " for $" .. final_price)
end

-- Update sales stats when a dish is sold
local function updateSalesStats(player, dish, price)
    initializePlayerStats(player)
    playerStats[player].total_sales = playerStats[player].total_sales + price
end

-- Handle bartering process with customers
local function barterPrice(player, customer, food_item)
    local barterSuccess = math.random(0, 100)
    local base_price = food_item.price
    local final_price = base_price

    if barterSuccess > 50 then
        final_price = final_price + math.random(1, 10) -- Increase price if bartering succeeds
        TriggerClientEvent('vorp:notify', player, "Successfully bartered. New price: " .. final_price)
    else
        final_price = final_price - math.random(1, 5) -- Decrease price if bartering fails
        TriggerClientEvent('vorp:notify', player, "Bartering failed. New price: " .. final_price)
    end

    return final_price
end

--------------------------------------------------
-- Rank and Progression Functions
--------------------------------------------------

-- Check and update rank progression for players
local function checkRankProgress(player)
    local rank = getPlayerRank(player)
    for _, rank_data in ipairs(rank_progression) do
        if rank_data.rank == rank then
            -- Apply profit and wage changes
            TriggerClientEvent('vorp:notify', player, "Your new profit is: " .. rank_data.profit)
            TriggerClientEvent('vorp:notify', player, "Your new wage is: " .. rank_data.wage)
        end
    end
end

--------------------------------------------------
-- Customer Management Functions
--------------------------------------------------

-- Spawn customers at the restaurant
local function spawnCustomer()
    -- Logic to create and place NPC at the restaurant
    local customer = -- Create NPC Logic Here
    table.insert(customers, customer)
end

--------------------------------------------------
-- Menu Management Functions
--------------------------------------------------

-- Add or remove items from the restaurant menu
local function manageMenu(player, action, item)
    if action == "add" then
        table.insert(restaurant_menu, item)
        TriggerClientEvent('vorp:notify', player, item.item .. " has been added to the menu.")
    elseif action == "remove" then
        for i, menuItem in ipairs(restaurant_menu) do
            if menuItem.item == item then
                table.remove(restaurant_menu, i)
                TriggerClientEvent('vorp:notify', player, item .. " has been removed from the menu.")
                break
            end
        end
    end
end

--------------------------------------------------
-- Leaderboard and Admin Menu Functions
--------------------------------------------------

-- Display the leaderboard with player statistics
local function showLeaderboard(player)
    local sorted_players = {}

    -- Sort players by total cooked
    for playerID, stats in pairs(playerStats) do
        table.insert(sorted_players, {playerID = playerID, total_cooked = stats.total_cooked, total_sales = stats.total_sales})
    end

    table.sort(sorted_players, function(a, b) return a.total_cooked > b.total_cooked end)

    -- Display the leaderboard in pages
    local page = 1
    local items_per_page = 10
    local total_pages = math.ceil(#sorted_players / items_per_page)

    TriggerClientEvent('vorp:notify', player, "Leaderboard - Page " .. page .. "/" .. total_pages)

    for i = (page-1)*items_per_page+1, math.min(page*items_per_page, #sorted_players) do
        local p = sorted_players[i]
        TriggerClientEvent('vorp:notify', player, "Player: " .. p.playerID .. " | Total Cooked: " .. p.total_cooked .. " | Total Sales: $" .. p.total_sales)
    end
end

-- Show the admin menu for managing the job
local function showAdminMenu(player)
    TriggerClientEvent('vorp:showAdminMenu', player)
end

--------------------------------------------------
-- Event Handlers
--------------------------------------------------

-- Event to start the restaurant job
RegisterServerEvent('vorp:restaurantJob:start')
AddEventHandler('vorp:restaurantJob:start', function()
    local _source = source
    TriggerClientEvent('vorp:notify', _source, "You have started your shift at the restaurant.")
    spawnCustomer()
end)

-- Event to cook food
RegisterServerEvent('vorp:restaurantJob:cook')
AddEventHandler('vorp:restaurantJob:cook', function(food_item)
    local _source = source
    cookFood(_source, food_item)
end)

-- Event to sell food
RegisterServerEvent('vorp:restaurantJob:sell')
AddEventHandler('vorp:restaurantJob:sell', function(customer, food_item)
    local _source = source
    sellFood(_source, customer, food_item)
end)

-- Event to manage menu
RegisterServerEvent('vorp:restaurantJob:manageMenu')
AddEventHandler('vorp:restaurantJob:manageMenu', function(action, item)
    local _source = source
    manageMenu(_source, action, item)
end)

-- Event to display leaderboard
RegisterServerEvent('vorp:restaurantJob:showLeaderboard')
AddEventHandler('vorp:restaurantJob:showLeaderboard', function()
    local _source = source
    showLeaderboard(_source)
end)

-- Event to open admin menu
RegisterServerEvent('vorp:restaurantJob:openAdminMenu')
AddEventHandler('vorp:restaurantJob:openAdminMenu', function()
    local _source = source
    showAdminMenu(_source)
end)

--------------------------------------------------
-- Helper Functions (Stubs)
--------------------------------------------------

-- Function to get player skill (stubbed for demo)
local function getPlayerSkill(player)
    -- Logic to get the player's cooking skill
    return 50
end

-- Function to get player rank (stubbed for demo)
local function getPlayerRank(player)
    -- Logic to get the player's current rank
    return 1
end