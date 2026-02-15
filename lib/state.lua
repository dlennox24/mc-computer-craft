local state = {}

state.data = {
    x = 0,
    y = 0,
    z = 0,
    facing = 0
}

local STATE_FILE = "quarry_state"

function state.load()
    if fs.exists(STATE_FILE) then
        local file = fs.open(STATE_FILE, "r")
        state.data = textutils.unserialize(file.readAll())
        file.close()
    end
end

function state.save()
    local file = fs.open(STATE_FILE, "w")
    file.write(textutils.serialize(state.data))
    file.close()
end

return state
