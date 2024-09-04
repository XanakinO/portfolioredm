-- Pastor Job, made by Xanakin_
-- Configuration
local config = {
    chapelCoords = vector3(-214.43, -915.13, 30.69), -- Replace with your chapel coordinates
    hourlyWage = 50, -- Adjust wage amount
    jobName = 'pastor',
    jobTime = 12 -- Time of day to check for wages, 24-hour format
}

-- Check if the player is in the chapel
local function isInChapel()
    local playerPed = PlayerPedId()
    local playerPos = GetEntityCoords(playerPed)
    return #(playerPos - config.chapelCoords) < 10.0 -- Radius to define 'inside' the chapel
end

-- Determine if today is Sunday
local function isSunday()
    return os.date('*t').wday == 1 -- 1 is Sunday
end

-- Check the time and pay wage if conditions are met
local function checkWage()
    local src = source
    local user = VORP.getUser(src)
    local job = user.getJob()

    if job == config.jobName and isSunday() then
        local playerPos = GetEntityCoords(GetPlayerPed(src))
        if #(playerPos - config.chapelCoords) < 10.0 then
            user.addMoney(config.hourlyWage)
            TriggerClientEvent('chat:addMessage', src, {
                args = { 'You have received your hourly wage of $' .. config.hourlyWage }
            })
        end
    end
end

-- Event handler for checking time and paying wage
RegisterServerEvent('pastor:checkTime')
AddEventHandler('pastor:checkTime', function()
    checkWage()
end)

-- Event handler for clocking into the pastor job
RegisterServerEvent('pastor:clockIn')
AddEventHandler('pastor:clockIn', function()
    local src = source
    local user = VORP.getUser(src)
    user.setJob(config.jobName)
    TriggerClientEvent('pastor:updateStatus', src, true)
end)

-- Event handler for clocking out of the pastor job
RegisterServerEvent('pastor:clockOut')
AddEventHandler('pastor:clockOut', function()
    local src = source
    local user = VORP.getUser(src)
    user.setJob(nil)
    TriggerClientEvent('pastor:updateStatus', src, false)
end)

-- Command to give items
local items = {
    bible = { name = "Bible", description = "A holy book used for preaching." },
    cross = { name = "Cross", description = "A symbol of faith." }
}

RegisterCommand('getitem', function(source, args, rawCommand)
    local itemName = args[1]
    if items[itemName] then
        TriggerClientEvent('pastor:giveItem', source, items[itemName])
    else
        TriggerClientEvent('chat:addMessage', source, {
            args = { 'Invalid item name. Available items: bible, cross.' }
        })
    end
end, false)

-- Event handler to give items to the player
RegisterNetEvent('pastor:giveItem')
AddEventHandler('pastor:giveItem', function(item)
    -- Replace with your actual item handling logic
    TriggerEvent('inventory:addItem', item.name, item.description)
    TriggerEvent('chat:addMessage', {
        args = { 'You have received a ' .. item.name .. ': ' .. item.description }
    })
end)

-- Time check thread
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(60000) -- Check every minute
        local currentHour = GetClockHours()
        if currentHour == config.jobTime then
            TriggerEvent('pastor:checkTime')
        end
    end
end)

-- Update job status on player connection
AddEventHandler('vorp:playerLoaded', function(source)
    local user = VORP.getUser(source)
    if user.getJob() == config.jobName then
        TriggerClientEvent('pastor:updateStatus', source, true)
    else
        TriggerClientEvent('pastor:updateStatus', source, false)
    end
end)
