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
            msaa = 8,
            debug = 0
        },
        bullets_lifetime = 1
    },
    worldMeter = 64,
    resolutions = {
        "640x480",
        "800x600",
        "1024x768",
        "1280x720",
        "1280x800",
        "1366x768",
        "1440x900",
        "1600x900",
        "1680x1050",
        "1920x1080",
        "1920x1200",
    }
}

function Params:init()
    self.halfScreenW = love.graphics.getWidth() / 2;
    self.halfScreenH = love.graphics.getHeight() / 2;
    self.screenOutRadius = math.sqrt(love.graphics.getWidth() ^ 2 + love.graphics.getHeight() ^ 2) / 2
end

return Params