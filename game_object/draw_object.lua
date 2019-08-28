local Params = require('params')

---@class DrawObject
---@field protected drawable Draw
---@field protected angle number
---@field protected point Point
local DrawObject = {}

---@param drawable Draw
---@param point Point
function DrawObject:new(drawable, point)
    local newObj = {
        point = point,
        angle = 0,
        drawable = drawable
    }
    setmetatable(newObj, self)
    self.__index = self

    return newObj
end

function DrawObject:draw()
    local distance = math.sqrt((self.point.x - (App.camera.x)) ^ 2 + (self.point.y - (App.camera.y)) ^ 2) - self.drawable.visibilityRadius
    if math.abs(distance) <= Params.screenOutRadius * (1/App.camera.scale) then
        self.drawable:draw(self.point, self.angle)
    end
end

return DrawObject