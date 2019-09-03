local Event = require('enum.event')
local Circle = require('drawable.circle')
local Color = require('color')
local Point = require('model.point')
local Txt = require('drawable.text')

---@class Slider
---@field protected width number
---@field protected choices table
---@field protected circle Circle
---@field protected start_point Point
---@field protected step_offset number
---@field protected current_index number
---@field protected color Color
---@field protected text_elements Txt[]
local Slider = {}

---@param width number
---@param choices table
---@param color Color
---@return Slider
function Slider:new(point, width, choices, color)
    local newObj = {
        width = width,
        choices = choices,
        circle = Circle:new('fill', Color:red(), 10),
        start_point = point:clone(-(width / 2)),
        step_offset = width / (#choices - 1),
        current_index = 0,
        color = color,
        text_elements = {}
    }
    setmetatable(newObj, self)
    self.__index = self

    local font = Resources:getFont(FONT_CASANOVA, 14)
    for i, value in pairs(choices) do
        newObj.text_elements[i] = Txt:new(value, Color:white(), font)
    end

    local slider_trigger_uniq = 'slider_drag_trigger' .. love.math.random()
    App.scene.events:addAction(Event.MOUSE,
        function(params)
            local mouse_point = Point:new(params.x, params.y)
            local slider_point = newObj.start_point:clone(newObj.current_index * newObj.step_offset)
            if math.distance(mouse_point, slider_point) <= newObj.circle.r then
                App.scene.events:addAction(Event.MOUSE_MOVE,
                    function(moveParams)
                        local diff = (moveParams.x - newObj.start_point.x) % newObj.step_offset
                        if diff > newObj.circle.r and newObj.step_offset - diff > newObj.circle.r then
                            return
                        end

                        local index = math.floor((moveParams.x - newObj.start_point.x - newObj.step_offset / 2) / newObj.step_offset) + 1
                        index = index < 0 and 0 or index
                        index = index > #newObj.choices - 1 and #newObj.choices - 1 or index
                        newObj.current_index = index
                    end, nil, slider_trigger_uniq
                )
            end
        end, 1
    )
    App.scene.events:addAction(Event.MOUSE_RELEASE,
        function(params)
            App.scene.events:removeAction(Event.MOUSE_MOVE, nil, slider_trigger_uniq)
        end, 1
    )

    return newObj
end

---@return any
function Slider:getCurrent()
    return self.choices[self.current_index + 1]
end

function Slider:draw()
    love.graphics.setColor(self.color:get())
    love.graphics.line(self.start_point.x, self.start_point.y, self.start_point.x + self.width, self.start_point.y)

    local circle_point = self.start_point:clone(self.current_index * self.step_offset)
    self.circle:draw(circle_point, 0)
    self.text_elements[self.current_index + 1]:draw(circle_point:clone(0, -(self.circle.r * 2)), 0)
end

---@param point Point
function Slider:setPosition(point)
    self.start_point = point:clone(-(self.width / 2))
end

return Slider