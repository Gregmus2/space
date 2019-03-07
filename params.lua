---@class Params
---@field public halfScreenH number
---@field public halfScreenW number
local Params = {
    default = {
        linearDumping = 0.1,
        friction = 1,
        scene = nil,
        config = {
            width = 1024,
            height = 768,
            msaa = 8
        },
        bullets_lifetime = 1.5
    },
    worldMeter = 64,
}

function Params:init()
    self.halfScreenW = love.graphics.getWidth() / 2;
    self.halfScreenH = love.graphics.getHeight() / 2;
    self.screenOutRadius = math.sqrt(love.graphics.getWidth() ^ 2 + love.graphics.getHeight() ^ 2) / 2
end

return Params