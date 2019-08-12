local Draw = require('drawable.drawable')

---@class Text : Draw
---@field public text string
---@field public x number
---@field public y number
---@field public color Color
local Text = Draw:new()

---@param text string
---@param x number
---@param y number
---@param color Color
---@return Text
function Text:new(text, x, y, color)
    local newObj = {
        visibilityRadius = math.sqrt((string.len(text) * 4) ^ 2 + (8) ^ 2) / 2,
        text = text,
        x = x,
        y = y,
        color = color
    }
    setmetatable(newObj, self)
    self.__index = self

    return newObj
end

---@param x number
---@param y number
---@param realX number
---@param realY number
function Text:drawShape(x, y, realX, realY)
    love.graphics.print(
        self.text,
        self.x,
        self.y,
        0
    )
end

return Text