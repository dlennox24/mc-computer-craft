local state = require("state")
local move = require("movement")

local inventory = {}

local function isFull()
    for i = 1, 16 do
        if turtle.getItemCount(i) == 0 then
            return false
        end
    end
    return true
end

local function dumpAllDown()
    for i = 1, 16 do
        turtle.select(i)
        turtle.dropDown()
    end
end

function inventory.checkAndDump()
    if not isFull() then
        return
    end

    print("Inventory full. Returning to dump.")

    local saved = {
        x = state.data.x,
        y = state.data.y,
        z = state.data.z,
        facing = state.data.facing
    }

    -- Return to origin X/Z
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

    -- Go up to surface
    while state.data.y < 0 do
        move.up()
    end

    dumpAllDown()

    print("Returning to work site.")

    -- Return back down
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
end

return inventory
