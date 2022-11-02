local Field = require "field"
require "command/commands"
require "crystals/crystal-builder"

local GameModel = {}

function GameModel:new(ui)
    local newObj = { field = Field:new(ui.rows, ui.columns), ui = ui }
    self.__index = self
    return setmetatable(newObj, self)
end

function GameModel:init()
    for i = 1, self.field.rows do
        for j = 1, self.field.columns do
            self.field[i][j] = GetRandomCrystal()
        end
    end

    while self:tick() do end
end

function GameModel:tick()
    local field = self.field
    local changed, groups = field:hasGroups()

    if not changed or groups == nil then return changed end

    field = field:selectCellsByGroups(groups)

    for j = 1, field.columns do
        local newColumn = {}

        for i = field.rows, 1, -1 do
            if not field[i][j].isSelected then
                newColumn[#newColumn + 1] = field[i][j]
            end
        end

        for i = field.rows, 1, -1 do
            local value = newColumn[field.rows - i + 1]
            field[i][j] = value ~= nil and newColumn[field.rows - i + 1] or GetRandomCrystal()
        end
    end

    self.field = field
    return changed
end

function GameModel:move(from, to)
    local copyField = self.field:move(from, to)

    if copyField:hasGroups() then
        self.field = copyField
    end
end

function GameModel:mix(attempts)
    for _ = 1, self.field.columns * self.field.rows do
        local from = { x = math.random(self.field.columns), y = math.random(self.field.columns) }
        local to = { x = math.random(self.field.columns), y = math.random(self.field.columns) }

        self.field:swap(from, to)

        if self.field:hasGroups() then
            self.field:swap(to, from)
        end
    end

    local hasMoves = self.field:hasPossibleMoves()
    if not hasMoves and attempts > 0 then
        return self:mix(attempts - 1)
    elseif not hasMoves then
        return false
    end

    return true
end

function GameModel:dump()
    self.ui:printField(self.field)
end

function GameModel:start()
    self:init()
    self:dump()

    while true do
        if not self.field:hasPossibleMoves() then
            if not self:mix(3) then
                -- couldn't mix
                self:start()
            end
            self:dump()
        end

        local command = self.ui:getCommand()

        if command.type == QUIT then return end
        if command.type == MOVE then
            self:move(command.from, command.to)

            self:dump()
            local changed = false
            repeat
                changed = self:tick()
                self:dump()
            until not changed
        end
    end
end

return GameModel
