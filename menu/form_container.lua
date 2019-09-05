local Point = require('model.point')
local IFormElement = require('interface.form_element')
local Button = require('menu.button')

---@class FormContainer : MenuObject
---@field protected point Point
---@field protected area Area
---@field protected color Color
---@field protected elements table<IFormElement, function>
---@field protected columnHeight number
---@field protected acceptButton Button
local FormContainer = {}

---@param point Point
---@param area Area
---@param columnHeight number
function FormContainer:new(point, area, columnHeight)
    local newObj = {
        point = point,
        area = area,
        elements = {},
        columnHeight = columnHeight
    }
    newObj.acceptButton = Button:newWithText(
        point:clone(0, area.h / 2 - columnHeight / 2),
        'ACCEPT',
        Resources:getFont(FONT_CASANOVA, 26),
        true,
        function()
            for _, callback in pairs(newObj.elements) do
                callback()
            end
        end
    )

    setmetatable(newObj, self)
    self.__index = self

    return newObj
end

---@param element IFormElement
---@param callback function
function FormContainer:add(element, callback)
    assert(isImplement(element, IFormElement), 'attempt to add not FormElement to FormContainer')
    self.elements[element] = callback
    self:recalculateElements()
end

---@param element IFormElement
function FormContainer:remove(element)
    self.elements[element] = nil
    self:recalculateElements()
end

---@protected
function FormContainer:recalculateElements()
    local yOffset = self.point.y - self.area.h / 2
    local i = 1
    for element in pairs(self.elements) do
        local position = Point:new(self.point.x, yOffset + self.columnHeight * (i - 0.5))
        element:setPosition(position)
        i = i + 1
    end
end

---@return table
function FormContainer:getElements()
    return {self.acceptButton}
end

function FormContainer:draw()
    for element in pairs(self.elements) do
        element:draw()
    end

    self.acceptButton:draw()
end

return FormContainer