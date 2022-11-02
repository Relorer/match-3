local Crystal = require "crystals.crystal"

local HorizontalLineCrystal = {}

function HorizontalLineCrystal:new(color)
    local newObj = Crystal:new(color)
    self.__index = self
    return setmetatable(newObj, self)
end

function HorizontalLineCrystal:copy()
    local newObj = HorizontalLineCrystal:new(self.color)
    for orig_key, orig_value in pairs(self) do
        newObj[orig_key] = orig_value
    end
    return newObj
end

function HorizontalLineCrystal:applySpecialEffects(field, x, y)
    for i = 1, field.columns do
        field[y][i].isSelected = true
    end
end

return HorizontalLineCrystal
