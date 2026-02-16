--tell the turtle EXACTLY where to look
package.path = package.path .. ";/lib/?.lua;/lib/?/init.lua"

local state = require("lib/state")
local move = require("lib/movement")
local fuel = require("lib/fuel")
local inventory = require("lib/inventory")

state.load()

local WIDTH = 16
local DEPTH = 16



local function mineLayer()
    for row = 1, DEPTH do
        for col = 1, WIDTH - 1 do
            move.forward()
            fuel.ensureMidRun()
            inventory.checkAndDump()

        end

        if row < DEPTH then
            if row % 2 == 1 then
                move.turnRight()
                move.forward()
                fuel.ensureMidRun()
                inventory.checkAndDump()

                move.turnRight()
            else
                move.turnLeft()
                move.forward()
                fuel.ensureMidRun()
                inventory.checkAndDump()
                move.turnLeft()
            end
        end
    end
end

local function returnToStartOfLayer()
    -- Face north
    while state.data.facing ~= 0 do
        move.turnLeft()
    end

    -- Return to origin x,z
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
end

local function quarry()
    
    -- local estimatedMoves = 16 * 16 * 20  -- rough estimate
    -- if not fuel.ensure(estimatedMoves) then
    --     print("Not enough fuel.")
    --     return
    -- end
    
    while true do
        mineLayer()
        returnToStartOfLayer()

        if not turtle.detectDown() then
            print("No block below. Stopping.")
            break
        end

        local success, data = turtle.inspectDown()
        if success and data.name == "minecraft:bedrock" then
            print("Bedrock reached.")
            break
        end

        move.down()
    end
end

quarry()
