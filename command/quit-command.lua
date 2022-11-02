require "command/commands"

local QuitCommand = {}

function QuitCommand:new()
    local newObj = {type = QUIT}
    self.__index = self
    return setmetatable(newObj, self)
end

function TryGetQuitCommandFromString(textCommand)
    local command = string.match(textCommand, '(%S)')
    if command == 'q' then return QuitCommand:new() end
    return nil
end

return QuitCommand