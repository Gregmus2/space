local Params = require('params')
local Core = require('ship_components.core')
local Engine = require('ship_components.engine')
local Polygon = require('drawable.polygon')
local ParticlesFactory = require('factory.particles_factory')
local Event = require('enum.event')
local Action = require('action')

---@class ShipComponentBuilder
local ShipComponentBuilder = {}

---@param world World
---@param x number
---@param y number
---@param color Color
---@param vertexes number[]
---@param mass number
---@param rotateSpeed number
function ShipComponentBuilder:buildCore(world, x, y, color, vertexes, mass, rotateSpeed)
    local draw, fixture = self.build(world, x, y, color, vertexes, mass)
    return Core:new(draw, fixture, rotateSpeed)
end

---@param world World
---@param scene Scene
---@param x number
---@param y number
---@param color Color
---@param vertexes number[]
---@param mass number
---@param speed number
function ShipComponentBuilder:buildEngine(world, scene, x, y, color, vertexes, mass, speed)
    local draw, fixture = self.build(world, x, y, color, vertexes, mass)
    local particle = ParticlesFactory.getEngineFire(20, 0)
    particle:pause()
    scene:addParticle(particle)
    local engine = Engine:new(draw, fixture, speed, particle)
    scene.events:addEvent(Event.KEY, Action:new(function(dt) particle:start() end), 'w')
    scene.events:addEvent(Event.KEY_RELEASE, Action:new(function(dt) particle:pause() end, true), 'w')

    return engine
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
    body:setLinearDamping(1)
    body:setAngularDamping(10)
    local physics = love.physics.newFixture(body, shape, mass)
    physics:setFriction(Params.default.friction)

    return draw, physics
end

return ShipComponentBuilder