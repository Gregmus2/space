local Draw = require('drawable.drawable')

---@class Txt : Draw
---@field public text Text
---@field public visibilityRadius number
---@field public color Color
local Txt = Draw:new()

---@param text string
---@param color Color
---@param font Font
---@return Txt
function Txt:new(text, color, font)
    local text_obj = love.graphics.newText( font, text )
    local newObj = {
        visibilityRadius = math.sqrt(text_obj:getWidth() ^ 2 + text_obj:getHeight() ^ 2) / 2,
        color = color,
        text = text_obj
    }
    setmetatable(newObj, self)
    self.__index = self

    return newObj
end

---@param point Point
---@param realPoint Point
function Txt:drawShape(point, realPoint)
    love.graphics.draw(
        self.text,
        realPoint.x - self.text:getWidth() * App.camera.scale / 2,
        realPoint.y - self.text:getHeight() * App.camera.scale / 2
    )
end

return Txt