local Params = require('params')
local Core = require('ship_components.core')
local Engine = require('ship_components.engine')
local Weapon = require('ship_components.weapon')
local Reactor = require('ship_components.reactor')
local Polygon = require('drawable.polygon')
local ParticlesFactory = require('factory.particles_factory')
local Event = require('enum.event')

---@class ShipComponentBuilder
local ShipComponentBuilder = {}

---@param world World
---@param point Point
---@param color Color
---@param vertexes number[]
---@param mass number
---@param rotateSpeed number
function ShipComponentBuilder:buildCore(world, point, color, vertexes, mass, rotateSpeed)
    local draw, fixture = self.build(world, point, color, vertexes, mass)
    return Core:new(draw, fixture, rotateSpeed)
end

---@param world World
---@param scene Scene
---@param point Point
---@param color Color
---@param vertexes number[]
---@param mass number
---@param speed number
function ShipComponentBuilder:buildEngine(world, scene, point, color, vertexes, mass, speed)
    local draw, fixture = self.build(world, point, color, vertexes, mass)
    local particle = ParticlesFactory.getEngineFire(3)
    local engine = Engine:new(draw, fixture, speed, particle)
    particle:stop()
    particle:setPosition(point:get())
    particle:setDirection(engine.fixture:getBody():getAngle() - 3.14159)
    scene:addUpdatable(particle)

    --particles
    scene.events:addAction(Event.KEY, function() particle:start() end, 'w')
    scene.events:addAction(Event.KEY_RELEASE, function() particle:pause() end, 'w')

    -- sound
    scene.events:addAction(Event.KEY, function()
        TEsound.play('resources/engine_start.wav', 'static', {'engine_start'}, 1, 1, function()
            TEsound.playLooping('resources/engine.wav', 'static', {'engine'})
        end)
    end, 'w')
    scene.events:addAction(Event.KEY_RELEASE, function()
        TEsound.stop('engine_start')
        TEsound.stop('engine')
    end, 'w')

    return engine
end

---@param world World
---@param scene Scene
---@param point Point
---@param color Color
---@param vertexes number[]
---@param mass number
---@param bulletEmitter BulletEmitter
function ShipComponentBuilder:buildWeapon(world, scene, point, color, vertexes, mass, bulletEmitter)
    local draw, fixture = self.build(world, point, color, vertexes, mass)
    local weapon =  Weapon:new(draw, fixture, bulletEmitter, 5)
    scene:addUpdatable(weapon)

    return weapon
end

---@param world World
---@param point Point
---@param color Color
---@param vertexes number[]
---@param mass number
---@param capacity number
---@param recovery number
function ShipComponentBuilder:buildReactor(world, point, color, vertexes, mass, capacity, recovery)
    local draw, fixture = self.build(world, point, color, vertexes, mass)
    local reactor =  Reactor:new(draw, fixture, capacity, recovery)

    return reactor
end

---@param world World
---@param point Point
---@param color Color
---@param vertexes number[]
---@param mass number
---@return Drawable, Fixture
function ShipComponentBuilder.build(world, point, color, vertexes, mass)
    local draw = Polygon:new('fill', color, vertexes)
    local shape = love.physics.newPolygonShape(vertexes)
    local body = love.physics.newBody(world, point.x, point.y, 'dynamic')
    body:setFixedRotation(false)
    body:setLinearDamping(1)
    body:setAngularDamping(10)
    local fixture = love.physics.newFixture(body, shape, mass)
    fixture:setFriction(Params.default.friction)

    return draw, fixture
end

return ShipComponentBuilder