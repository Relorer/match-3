require "crystals/crystal-builder"

local Field = {}

function Field:new(rows, columns)
    local newObj = { rows = rows, columns = columns }
    for i = 1, rows do
        newObj[i] = {}
        for j = 1, columns do
            newObj[i][j] = nil
        end
    end
    self.__index = self
    return setmetatable(newObj, self)
end

function Field:copy()
    local newObj = Field:new(self.rows, self.columns)
    for i = 1, self.rows do
        newObj[i] = {}
        for j = 1, self.columns do
            newObj[i][j] = self[i][j]:copy()
        end
    end
    return newObj
end

function Field:swap(from, to)
    local temp = self[from.y][from.x]
    self[from.y][from.x] = self[to.y][to.x]
    self[to.y][to.x] = temp
end

function Field:getVerticalGroups()
    local lastGroupIndex = 1
    local groups = { {} }

    for i = 1, self.rows do
        for j = 1, self.columns do
            local lastGroup = groups[lastGroupIndex]

            if #lastGroup > 0 and self[lastGroup[#lastGroup].y][lastGroup[#lastGroup].x].color ~= self[i][j].color then
                lastGroupIndex = #lastGroup >= 3 and lastGroupIndex + 1 or lastGroupIndex
                groups[lastGroupIndex] = {}
                lastGroup = groups[lastGroupIndex]
            end

            lastGroup[#lastGroup + 1] = { x = j, y = i }
        end
        lastGroupIndex = #groups[lastGroupIndex] >= 3 and lastGroupIndex + 1 or lastGroupIndex
        groups[lastGroupIndex] = {}
    end

    return groups
end

function Field:getHorizontalGroups()
    local lastGroupIndex = 1
    local groups = { {} }

    for i = 1, self.rows do
        for j = 1, self.columns do
            local lastGroup = groups[lastGroupIndex]

            if #lastGroup > 0 and self[lastGroup[#lastGroup].y][lastGroup[#lastGroup].x].color ~= self[j][i].color then
                lastGroupIndex = #lastGroup >= 3 and lastGroupIndex + 1 or lastGroupIndex
                groups[lastGroupIndex] = {}
                lastGroup = groups[lastGroupIndex]
            end

            lastGroup[#lastGroup + 1] = { value = self[j][i], x = i, y = j }
        end
        lastGroupIndex = #groups[lastGroupIndex] >= 3 and lastGroupIndex + 1 or lastGroupIndex
        groups[lastGroupIndex] = {}
    end

    return groups
end

function Field:selectCellsByGroups(groups)
    local copyField = self:copy()
    for i = 1, #groups do
        local group = groups[i]
        for j = 1, #group do
            local cell            = group[j]
            copyField[cell.y][cell.x].isSelected = true
            copyField[cell.y][cell.x]:applySpecialEffects(copyField, cell.x, cell.y)
        end
    end
    return copyField
end

function Field:move(from, to)
    if not (from.x > 0 and from.x <= self.columns and
        from.y > 0 and from.y <= self.rows and
        to.x > 0 and to.x <= self.columns and
        to.y > 0 and to.y <= self.rows and
        math.abs(from.x - to.x) + math.abs(from.y - to.y) == 1) then
        return self
    end

    local copyField = self:copy()

    copyField:swap(from, to)

    return copyField
end

function Field:hasGroups()
    local groups = { table.unpack(self:getVerticalGroups()), table.unpack(self:getHorizontalGroups()) }

    for i = 1, #groups do
        local group = groups[i]
        for _ = 1, #group do
            return true, groups
        end
    end

    return false, nil
end

function Field:hasPossibleMoves()
    for i = 1, self.rows do
        for j = 1, self.columns do
            if self:move({ x = j, y = i }, { x = j + 1, y = i }):hasGroups() then return true end
            if self:move({ x = j, y = i }, { x = j - 1, y = i }):hasGroups() then return true end
            if self:move({ x = j, y = i }, { x = j, y = i + 1 }):hasGroups() then return true end
            if self:move({ x = j, y = i }, { x = j, y = i - 1 }):hasGroups() then return true end
        end
    end
end

return Field
