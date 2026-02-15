local state = require("state")

local movement = {}

local function updateForward()
    if state.data.facing == 0 then
        state.data.z = state.data.z - 1
    elseif state.data.facing == 1 then
        state.data.x = state.data.x + 1
    elseif state.data.facing == 2 then
        state.data.z = state.data.z + 1
    elseif state.data.facing == 3 then
        state.data.x = state.data.x - 1
    end
end

function movement.forward()
    while turtle.detect() do
        turtle.dig()
        sleep(0.3)
    end

    if turtle.forward() then
        updateForward()
        state.save()
        return true
    end

    return false
end

function movement.up()
    while turtle.detectUp() do
        turtle.digUp()
        sleep(0.3)
    end

    if turtle.up() then
        state.data.y = state.data.y + 1
        state.save()
        return true
    end

    return false
end

function movement.down()
    while turtle.detectDown() do
        turtle.digDown()
        sleep(0.3)
    end

    if turtle.down() then
        state.data.y = state.data.y - 1
        state.save()
        return true
    end

    return false
end

function movement.turnLeft()
    turtle.turnLeft()
    state.data.facing = (state.data.facing + 3) % 4
    state.save()
end

function movement.turnRight()
    turtle.turnRight()
    state.data.facing = (state.data.facing + 1) % 4
    state.save()
end

return movement
