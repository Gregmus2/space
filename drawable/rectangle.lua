local Drawable = require('drawable.drawable')

---@class Rectangle : Drawable
---@field public w number
---@field public h number
local Rectangle = Drawable:new()

---@param mode string
---@param color Color
---@param w number
---@param h number
---@return Rectangle
function Rectangle:new(mode, color, w, h)
    newObj = {
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

---@param camera Camera
---@param x number
---@param y number
function Rectangle:draw(camera, x, y)
    love.graphics.setColor(self.color.r, self.color.g, self.color.b)

    local realXCenter = self.calcX(camera, x)
    local realYCenter = self.calcY(camera, y)
    self:rotate(realXCenter, realYCenter)
    love.graphics.rectangle(
        self.mode,
        realXCenter - self.w * camera.scale / 2,
        realYCenter - self.h * camera.scale / 2,
        self.w * camera.scale,
        self.h * camera.scale
    )
end

return Rectangle