local Drawable = require('drawable.drawable')

---@class Circle : Drawable
---@field public r number
local Circle = Drawable:new()

---@param mode string
---@param color Color
---@param r number
---@return Circle
function Circle:new(mode, color, r)
    newObj = {
        visibilityRadius = r / 2,
        mode = mode,
        color = color,
        r = r
    }
    setmetatable(newObj, self)
    self.__index = self

    return newObj
end

---@param camera Camera
---@param x number
---@param y number
function Circle:draw(camera, x, y)
    love.graphics.setColor(self.color.r, self.color.g, self.color.b)
    love.graphics.circle(
        self.mode,
        self.calcX(camera, x),
        self.calcY(camera, y),
        self.r * camera.scale
    )
end

return Circle