---@class Params
---@field public halfScreenH number
---@field public halfScreenW number
local Params = {}

function Params:init()
    self.halfScreenW = love.graphics.getWidth() / 2;
    self.halfScreenH = love.graphics.getHeight() / 2;
    self.screenOutRadius = math.sqrt(love.graphics.getWidth() ^ 2 + love.graphics.getHeight() ^ 2) / 2
end

return Params