local IClickable = require('interface.clickable')
local IUpdatable = require('interface.updatable')
local ICollection = require('interface.collection')
local Point = require('model.point')

---@class Menu
---@field protected elements MenuObject[]
---@field protected updatable IUpdatable[]
---@field protected clickable IClickable[]
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
    if isImplement(element, IClickable) then
        self.clickable[#self.clickable + 1] = element
    end
    if isImplement(element, IUpdatable) then
        self.updatable[#self.updatable+ 1] = element
    end
    if isImplement(element, ICollection) then
        for _, el in ipairs(element:getElements()) do
            self:addElement(el)
        end
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