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
function Circle:draw(x, y, angle)
    love.graphics.setColor(self.color.r, self.color.g, self.color.b)
    love.graphics.circle(
        self.mode,
        self.calcX(x),
        self.calcY(y),
        self.r * App.camera.scale
    )
end

return Circle