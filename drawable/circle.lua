local Draw = require('drawable.drawable')

---@class Circle : Draw
---@field public r number
local Circle = Draw:new()

---@param mode string
---@param color Color
---@param r number
---@return Circle
function Circle:new(mode, color, r)
    local newObj = {
        visibilityRadius = r / 2,
        mode = mode,
        color = color,
        r = r
    }
    setmetatable(newObj, self)
    self.__index = self

    return newObj
end

---@param point
---@param realPoint Point
function Circle:drawShape(point, realPoint)
    love.graphics.circle(
        self.mode,
        realPoint.x,
        realPoint.y,
        self.r * App.camera.scale
    )
end

return Circle