local Crystal = require "crystals.crystal"
local HorizontalLineCrystal = require "crystals.horizontal-line-crystal"

local crystals = { 
    {crystal = Crystal, chance = 95}, 
    {crystal = HorizontalLineCrystal, chance = 5} 
}
local colors = { 'A', 'B', 'C', 'D', 'E', 'F' }

-- convert the chances in a convenient form
for i = 2, #crystals do
    crystals[i].chance = crystals[i].chance + crystals[i - 1].chance
end

function GetRandomCrystal()
    local color = colors[math.random(#colors)]

    local num = math.random(crystals[#crystals].chance)

    for i = 1, #crystals do
        if crystals[i].chance >= num then
            return crystals[i].crystal:new(color)
        end
    end
end
