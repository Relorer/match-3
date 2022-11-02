-- A workaround for connecting modules from the folder with the main script
local function scriptPath()
    local str = debug.getinfo(2, "S").source:sub(2)
    return str:match("(.*[/\\])")
end

package.path = package.path .. ";" .. scriptPath() .. [[/?.lua]]

local GameModel = require "game-model"
local UI = require "ui"

math.randomseed(os.time())

local function main()
    local ui = UI:new(10, 10)
    local gameModel = GameModel:new(ui)
    gameModel:start()
end

main()
