local Button = require('menu.button')
local Circle = require('drawable.circle')
local Rectangle = require('drawable.rectangle')
local Polygon = require('drawable.polygon')
local Params = require('params')

---@class ButtonFactory
local ButtonFactory = {}

function ButtonFactory.createRectangleButton(world, x, y, mode, color, w, h)
    local draw = Rectangle:new(mode, color, w, h)
    local shape = love.physics.newRectangleShape(w, h)
    local body = love.physics.newBody(world, x, y, 'kinematic')
    body:setFixedRotation(true)
    local physics = love.physics.newFixture(body, shape)

    return Button:new(draw, physics)
end

return ButtonFactory