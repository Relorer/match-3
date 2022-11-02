require "command/commands"

local MoveCommand = {}

function MoveCommand:new(from, to)
    local newObj = {type = MOVE, from = from, to = to}
    self.__index = self
    return setmetatable(newObj, self)
end

function TryGetMoveCommandFromString(textCommand)
    local command, x, y, direction = string.match(textCommand, '(%S)[ \t]+(%d)[ \t]+(%d)[ \t]+(%S)')

    if command ~= "m" or
        x == nil or
        y == nil or
        not (direction == 'l' or
        direction == 'r' or
        direction == 'u' or
        direction == 'd')
    then
        return nil
    end

    x = tonumber(x) + 1
    y = tonumber(y) + 1

    local x2 = x
    local y2 = y

    if direction == 'l' then x2 = x2 - 1
    elseif direction == 'r' then x2 = x2 + 1
    elseif direction == 'u' then y2 = y2 - 1
    elseif direction == 'd' then y2 = y2 + 1
    end

    return MoveCommand:new({ x = x, y = y }, { x = x2, y = y2 })
end

return MoveCommand