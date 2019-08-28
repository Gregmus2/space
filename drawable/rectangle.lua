local Draw = require('drawable.drawable')

---@class Rectangle : Draw
---@field public w number
---@field public h number
local Rectangle = Draw:new()

---@param mode string
---@param color Color
---@param w number
---@param h number
---@return Rectangle
function Rectangle:new(mode, color, w, h)
    local newObj = {
        visibilityRadius = math.sqrt(w ^ 2 + h ^ 2) / 2,
        mode = mode,
        color = color,
        w = w,
        h = h
    }
    setmetatable(newObj, self)
    self.__index = self

    return newObj
end

---@param point Point
---@param realPoint Point
function Rectangle:drawShape(point, realPoint)
    love.graphics.rectangle(
        self.mode,
        realPoint.x - self.w * App.camera.scale / 2,
        realPoint.y - self.h * App.camera.scale / 2,
        self.w * App.camera.scale,
        self.h * App.camera.scale
    )
end

return Rectangle