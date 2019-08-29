local Area = require('model.area')

---@class Button : MenuObject
---@field public point Point
---@field public area Area
---@field public color Color
---@field public action function
---@field public print Text
---@field public print_point Point
local Button = {}

---@param point Point
---@param area Area
---@param action function
function Button:new(point, area, action)
    local newObj = {
        point = point,
        area = area,
        action = action,
        drawable = {}
    }
    setmetatable(newObj, self)
    self.__index = self

    return newObj
end

---@param point Point
---@param text string
---@param font Font
---@param action function
function Button:newWithText(point, text, font, center, action)
    local newObj = {
        point = point,
        action = action,
        drawable = {},
        center = center
    }

    newObj.print = love.graphics.newText( font, text )
    newObj.area = Area:new(
        newObj.print:getWidth(),
        newObj.print:getHeight()
    )

    if center then
        newObj.print_point = point:clone(-newObj.print:getWidth() / 2, -newObj.print:getHeight() / 2)
    end

    setmetatable(newObj, self)
    self.__index = self

    return newObj
end

---@param drawable Draw
function Button:addDrawable(drawable)
    table.insert(self.drawable, drawable)

    return self
end

function Button:draw()
    ---@param drawable Draw
    for _, drawable in ipairs(self.drawable) do
        drawable:draw(self.point, 0)
    end

    if self.print ~= nil then
        love.graphics.draw(self.print, self.print_point and self.print_point.x or self.point.x, self.print_point and self.print_point.y or self.point.y)
    end
end

---@param point Point
---@return boolean
function Button:checkPoint(point)
    return
        point.x > (self.center and self.point.x - self.area.w / 2 or self.point.x) and
        point.x < (self.center and self.point.x + self.area.w / 2 or self.point.x + self.area.w) and
        point.y > (self.center and self.point.y - self.area.h / 2 or self.point.y) and
        point.y < (self.center and self.point.y + self.area.h / 2 or self.point.y + self.area.h)
end

return Button