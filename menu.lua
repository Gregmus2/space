local Clickable = require('interface.clickable')
local Updatable = require('interface.updatable')
local Point = require('model.point')

---@class Menu
---@field protected elements MenuObject[]
---@field protected updatable Updatable[]
---@field protected clickable Clickable[]
local Menu = {}

---@return Menu
function Menu:new()
    local newObj = {
        elements = {},
        updatable = {},
        clickable = {}
    }
    self.__index = self
    setmetatable(newObj, self)

    return newObj
end

---@param x number
---@param y number
function Menu:mouseRelease(x, y)
    for _, element in ipairs(self.clickable) do
        if element:checkPoint(Point:new(x, y)) then
            element.action()
        end
    end
end

---@param element MenuObject
function Menu:addElement(element)
    self.elements[#self.elements + 1] = element
    if isImplement(element, Clickable) then
        self.clickable[#self.clickable + 1] = element
    end
    if isImplement(element, Updatable) then
        self.updatable[#self.updatable+ 1] = element
    end
end

---@param dt number
function Menu:update(dt)
    for _, element in ipairs(self.updatable) do
        element:update(dt)
    end
end

function Menu:draw()
    for _, element in ipairs(self.elements) do
        element:draw()
    end
end

return Menu