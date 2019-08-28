local GameObject = require('game_object.game_object')
local Params = require('params')
local Event = require('enum.event')

---@class Reactor: GameObject
---@field public drawable Draw
---@field public fixture Fixture
---@field protected speed number
---@field protected rotateSpeed number
---@field protected particle ParticleSystem
---@field protected joint Joint
---@field protected uniq string
local Reactor = GameObject:new()

---@param drawable Draw
---@param fixture Fixture
---@param capacity number
---@param recoverySpeed number
function Reactor:new(drawable, fixture, capacity, recoverySpeed)
    local newObj = {
        uniq = string.random(10),
        drawable = drawable,
        fixture = fixture,
        capacity = capacity,
        recoverySpeed = recoverySpeed
    }
    fixture:getBody():setFixedRotation(false)

    setmetatable(newObj, self)
    self.__index = self

    return newObj
end

---@param dt number
---@param direction number
function Reactor:rotate(dt, direction) end

---@param dt number
---@param direction number
function Reactor:move(dt, direction) end

function Reactor:draw()
    local point = self:getPosition()
    local distance = math.distance(point, App.camera.point) - self.drawable.visibilityRadius
    if math.abs(distance) <= Params.screenOutRadius * (1/App.camera.scale) then
        self.drawable:draw(point, self.fixture:getBody():getAngle())
    end
end

---@param ship Ship
function Reactor:connect(ship)
    ship:addEnergyCapacity(self.capacity)
    ship:addEnergyRecovery(self.recoverySpeed)
end

---@param ship Ship
function Reactor:connect(ship)
    ship.energyCapacity = ship.energyCapacity + self.capacity
    ship.energyRecoverSpeed= ship.energyRecoverSpeed + self.recoverySpeed
    ship.events:addAction(Event.UPDATE, function ()
        self.drawable.color.a = ship.energy / ship.energyCapacity
    end, nil, self.uniq)
end

---@param ship Ship
function Reactor:disconnect(ship)
    ship.energyCapacity = ship.energyCapacity - self.capacity
    ship.energyRecoverSpeed= ship.energyRecoverSpeed - self.recoverySpeed
    ship.events:removeAction(Event.UPDATE, nil, self.uniq)
end

function Reactor:clearVisual() end

return Reactor