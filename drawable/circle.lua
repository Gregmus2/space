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

---@param x number
---@param y number
---@param realX number
---@param realY number
function Circle:drawShape(x, y, realX, realY)
    love.graphics.circle(
        self.mode,
        realX,
        realY,
        self.r * App.camera.scale
    )
end

return Circle