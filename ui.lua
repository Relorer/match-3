require "command/move-command"
require "command/quit-command"
require "utils"

local function clearConsole()
    os.execute("cls")
end

local UI = {}

function UI:new(rows, columns)
    local newObj = {
        rows = rows,
        columns = columns,
    }

    self.__index = self
    return setmetatable(newObj, self)
end

function UI:printField(field)
    clearConsole()

    io.write("  ")
    for i = 1, field.rows do
        io.write(i - 1 .. " ")
    end
    print()
    io.write(" ")
    for i = 1, field.rows do
        io.write("--")
    end
    print()
    for i = 1, field.rows do
        io.write(i - 1 .. "|")
        for j = 1, field.columns do
            io.write(field[i][j].color .. " ")
        end
        print()
    end
    print()
    SleepWindows(1)
end

function UI:getCommand()
    while true do
        local textCommand = io.read()

        local moveCommand = TryGetMoveCommandFromString(textCommand)
        if moveCommand ~= nil then return moveCommand end

        local quitCommand = TryGetQuitCommandFromString(textCommand)
        if quitCommand ~= nil then return quitCommand end
    end
end

return UI
