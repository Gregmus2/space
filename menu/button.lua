local Color = require('color')

---@class Button : MenuObject
---@field protected x number
---@field protected y number
---@field protected w number
---@field protected h number
---@field protected color Color
---@field public action function
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
end

---@param x number
---@param y number
---@return boolean
function Button:checkPoint(x, y)
    return
        x > self.x - self.w / 2 and
        x < self.x + self.w / 2 and
        y > self.y - self.h / 2 and
        y < self.y + self.h / 2
end

return Button