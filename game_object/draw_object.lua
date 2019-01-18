local Params = require('params')

---@class DrawObject
---@field protected drawable Draw
---@field protected angle number
---@field protected x number
---@field protected y number
local DrawObject = {}

---@param drawable Draw
---@param x number
---@param y number
function DrawObject:new(drawable, x, y)
    local newObj = {
        x = x,
        y = y,
        angle = 0,
        drawable = drawable
    }
    setmetatable(newObj, self)
    self.__index = self

    return newObj
end

function DrawObject:draw()
    local distance = math.sqrt((self.x - (App.camera.x)) ^ 2 + (self.y - (App.camera.y)) ^ 2) - self.drawable.visibilityRadius
    if math.abs(distance) <= Params.screenOutRadius * (1/App.camera.scale) then
        self.drawable:draw(self.x, self.y, self.angle)
    end
end

return DrawObject