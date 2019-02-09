local GameObject = require('game_object.game_object')
local Params = require('params')

---@class Weapon : GameObject
---@field protected bulletEmitter BulletEmitter
local Weapon = GameObject:new()

---@param drawable Draw
---@param fixture Fixture
---@param bulletEmitter BulletEmitter
function Weapon:new(drawable, fixture, bulletEmitter)
    local newObj = {
        drawable = drawable,
        fixture = fixture,
        bulletEmitter = bulletEmitter
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

---@param dt number
---@param direction number
function Weapon:move(dt, direction) end

function Weapon:draw()
    self.bulletEmitter:draw()

    local x, y = self:getPosition()
    local distance = math.sqrt((x - (App.camera.x)) ^ 2 + (y - (App.camera.y)) ^ 2) - self.drawable.visibilityRadius
    if math.abs(distance) <= Params.screenOutRadius * (1/App.camera.scale) then
        self.drawable:draw(x, y, self.fixture:getBody():getAngle())
    end
end

return Weapon