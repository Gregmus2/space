local Params = require('params')
local Core = require('ship_components.core')
local Engine = require('ship_components.engine')
local Polygon = require('drawable.polygon')

---@class ShipComponentBuilder
local ShipComponentBuilder = {}

---@param world World
---@param x number
---@param y number
---@param color Color
---@param vertexes number[]
---@param mass number
function ShipComponentBuilder:buildCore(world, x, y, color, vertexes, mass)
    return Core:new(self.build(world, x, y, color, vertexes, mass))
end

---@param world World
---@param x number
---@param y number
---@param color Color
---@param vertexes number[]
---@param mass number
function ShipComponentBuilder:buildEngine(world, x, y, color, vertexes, mass)
    return Engine:new(self.build(world, x, y, color, vertexes, mass))
end

---@protected
---@param world World
---@param x number
---@param y number
---@param color Color
---@param vertexes number[]
---@param mass number
---@return Drawable, Fixture
function ShipComponentBuilder.build(world, x, y, color, vertexes, mass)
    local draw = Polygon:new('fill', color, vertexes)
    local shape = love.physics.newPolygonShape(vertexes)
    local body = love.physics.newBody(world, x, y, 'dynamic')
    body:setFixedRotation(false)
    body:setLinearDamping(Params.default.linearDumping)
    body:setAngularDamping(0.1)
    local physics = love.physics.newFixture(body, shape, mass)
    physics:setFriction(Params.default.friction)

    return draw, physics
end

return ShipComponentBuilder