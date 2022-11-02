local Crystal = {}

function Crystal:new(color)
    local newObj = { color = color, isSelected = false }
    self.__index = self
    return setmetatable(newObj, self)
end

function Crystal:copy()
    local newObj = Crystal:new(self.color)
    for orig_key, orig_value in pairs(self) do
        newObj[orig_key] = orig_value
    end
    return newObj
end

function Crystal:applySpecialEffects(field, x, y)
end

return Crystal
