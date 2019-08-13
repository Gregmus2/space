---@class Button : MenuObject
---@field public x number
---@field public y number
---@field public w number
---@field public h number
---@field public color Color
---@field public action function
---@field public print Text
---@field public print_x number
---@field public print_y number
local Button = {}

---@param x number
---@param y number
---@param w number
---@param h number
---@param action function
function Button:new(x, y, w, h, action)
    local newObj = {
        x = x,
        y = y,
        w = w,
        h = h,
        action = action,
        drawable = {}
    }
    setmetatable(newObj, self)
    self.__index = self

    return newObj
end

---@param x number
---@param y number
---@param text string
---@param font Font
---@param action function
function Button:newWithText(x, y, text, font, center, action)
    local newObj = {
        x = x,
        y = y,
        action = action,
        drawable = {},
        center = center
    }

    newObj.print = love.graphics.newText( font, text )
    newObj.w = newObj.print:getWidth()
    newObj.h = newObj.print:getHeight()

    if center then
        newObj.print_x = x - newObj.print:getWidth() / 2
        newObj.print_y = y - newObj.print:getHeight() / 2
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
        drawable:draw(self.x, self.y, 0)
    end

    if self.print ~= nil then
        love.graphics.draw(self.print, self.print_x or self.x, self.print_y or self.y)
    end
end

---@param x number
---@param y number
---@return boolean
function Button:checkPoint(x, y)
    return
        x > (self.center and self.x - self.w / 2 or self.x) and
        x < (self.center and self.x + self.w / 2 or self.x + self.w) and
        y > (self.center and self.y - self.h / 2 or self.y) and
        y < (self.center and self.y + self.h / 2 or self.y + self.h)
end

return Button