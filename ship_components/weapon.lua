local GameObject = require('game_object.game_object')
local Params = require('params')
local Event = require('enum.event')

---@class Weapon : GameObject
---@field protected bulletEmitter BulletEmitter
---@field protected energyPoints number
local Weapon = GameObject:new()

---@param drawable Draw
---@param fixture Fixture
---@param bulletEmitter BulletEmitter
---@param energyPoints number
function Weapon:new(drawable, fixture, bulletEmitter, energyPoints)
    local newObj = {
        uniq = string.random(10),
        drawable = drawable,
        fixture = fixture,
        bulletEmitter = bulletEmitter,
        energyPoints = energyPoints
    }
    fixture:getBody():setFixedRotation(false)

    setmetatable(newObj, self)
    self.__index = self

    return newObj
end

---@param dt number
---@param direction number
function Weapon:rotate(dt, direction) end

---@param dt number
function Weapon:update(dt)
    self.bulletEmitter:setPosition(self:getPosition())
    self.bulletEmitter:setAngle(self.fixture:getBody():getAngle())
    self.bulletEmitter:update(dt)
end

---@param point Point
function Weapon:addPosition(point)
    GameObject.addPosition(self, point)
    self.bulletEmitter:setPosition(self:getPosition())
end

---@param dt number
---@param direction number
function Weapon:move(dt, direction) end

function Weapon:clearVisual()
    self.bulletEmitter:stop()
    self.bulletEmitter:reset()
end

function Weapon:draw()
    self.bulletEmitter:draw()

    local point = self:getPosition()
    local distance = math.distance(point, App.camera.point) - self.drawable.visibilityRadius
    if math.abs(distance) <= Params.screenOutRadius * (1/App.camera.scale) then
        self.drawable:draw(point, self.fixture:getBody():getAngle())
    end
end

---@param ship Ship
function Weapon:connect(ship)
    ship.events:addAction(Event.MOUSE, function()
        self.bulletEmitter:start()
        ship.events:addAction(Event.UPDATE, function(params)
            if ship:spendEnergy(self.energyPoints * params.dt) == false then
                ship.events:removeAction(Event.UPDATE, nil, self.uniq)
                self.bulletEmitter:stop()
            end
        end, nil, self.uniq)
    end, 1, self.uniq)
    ship.events:addAction(Event.MOUSE_RELEASE, function()
        ship.events:removeAction(Event.UPDATE, nil, self.uniq)
        self.bulletEmitter:stop()
    end, 1, self.uniq)
end

---@param ship Ship
function Weapon:disconnect(ship)
    ship.events:removeAction(Event.UPDATE, nil, self.uniq)
    ship.events:removeAction(Event.MOUSE, 1, self.uniq)
    ship.events:removeAction(Event.MOUSE_RELEASE, 1, self.uniq)
end

return Weapon