local Params = require('params')
local Point = require('model.point')

---@class GameObject
---@field public drawable Draw
---@field public fixture Fixture
---@field protected speed number
---@field protected rotateSpeed number
local GameObject = {}

---@param fixture Fixture
function GameObject:new(fixture)
    local newObj = {
        fixture = fixture,
        speed = 5000,
        rotateSpeed = 50
    }
    setmetatable(newObj, self)
    self.__index = self

    return newObj
end

---@param draw Draw
---@return GameObject
function GameObject:addDraw(draw)
    self.drawable = draw

    return self
end

---@param dt number
---@param direction number
function GameObject:rotate(dt, direction)
    self.fixture:getBody():applyAngularImpulse(self.rotateSpeed * dt * direction)
end

---@param angle number
function GameObject:forceRotate(angle)
    self.fixture:getBody():setAngle(self.fixture:getBody():getAngle() + angle)
end

---@param angle number
function GameObject:setAngle(angle)
    self.fixture:getBody():setAngle(angle)
end

---@param dt number
---@param direction number
function GameObject:move(dt, direction)
    local dSpeed = direction * self.speed * dt
    self.fixture:getBody():applyForce(math.cos(self.fixture:getBody():getAngle()) * dSpeed, math.sin(self.fixture:getBody():getAngle()) * dSpeed)
end

---@return Point
function GameObject:getPosition()
    return Point:new(self.fixture:getBody():getPosition())
end

---@param point Point
function GameObject:setPosition(point)
    self.fixture:getBody():setPosition(point:get())
end

---@param point Point
function GameObject:addPosition(point)
    local newPosition = self:getPosition():clone(point:get())
    self.fixture:getBody():setPosition(newPosition:get())
end

function GameObject:isDestroyed()
    return self.fixture:isDestroyed()
end

function GameObject:destroy()
    if not self.fixture:isDestroyed() then
        self.fixture:destroy()
    end
end

function GameObject:draw()
    if self.drawable == nil then
        return
    end

    local point = self:getPosition()
    local distance = math.distance(point, App.camera.point) - self.drawable.visibilityRadius
    if math.abs(distance) <= Params.screenOutRadius * (1/App.camera.scale) then
        self.drawable:draw(point, self.fixture:getBody():getAngle())
    end
end

return GameObject