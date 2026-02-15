local state = require("state")
local move = require("movement")

local fuel = {}

local BUFFER = 50

local function distanceToOrigin()
    return math.abs(state.data.x)
        + math.abs(state.data.z)
        + math.abs(state.data.y)
end

local function minimumRequired()
    local returnCost = distanceToOrigin()
    local resumeCost = math.abs(state.data.y)
    return returnCost + resumeCost + BUFFER
end

function fuel.refuelFromInventory()
    for i = 1, 16 do
        turtle.select(i)
        if turtle.refuel(0) then
            turtle.refuel()
        end
    end
end

local function refuelFromChest()
    print("Refueling from fuel chest...")

    -- Face north at origin
    while state.data.facing ~= 0 do
        move.turnLeft()
    end

    turtle.select(1)
    turtle.suckUp(64)
    fuel.refuelFromInventory()
end

function fuel.ensureMidRun()
    if turtle.getFuelLevel() == "unlimited" then
        return true
    end

    local current = turtle.getFuelLevel()
    local required = minimumRequired()

    if current >= required then
        return true
    end

    print("Low fuel. Emergency return.")

    local saved = {
        x = state.data.x,
        y = state.data.y,
        z = state.data.z,
        facing = state.data.facing
    }

    -- Return to origin
    while state.data.facing ~= 0 do
        move.turnLeft()
    end

    while state.data.x ~= 0 do
        if state.data.x > 0 then
            move.turnLeft()
            move.forward()
            move.turnRight()
        else
            move.turnRight()
            move.forward()
            move.turnLeft()
        end
    end

    while state.data.z ~= 0 do
        move.forward()
    end

    while state.data.y < 0 do
        move.up()
    end

    refuelFromChest()

    if turtle.getFuelLevel() < minimumRequired() then
        print("Not enough fuel in chest.")
        error("Fuel depleted.")
    end

    print("Fuel restored. Returning to work.")

    -- Return down
    while state.data.y > saved.y do
        move.down()
    end

    -- Return X
    while state.data.x < saved.x do
        move.turnRight()
        move.forward()
        move.turnLeft()
    end

    while state.data.x > saved.x do
        move.turnLeft()
        move.forward()
        move.turnRight()
    end

    -- Return Z
    while state.data.z ~= saved.z do
        move.forward()
    end

    -- Restore facing
    while state.data.facing ~= saved.facing do
        move.turnLeft()
    end

    print("Resumed mining.")

    return true
end

return fuel
