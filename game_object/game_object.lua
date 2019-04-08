local Params = require('params')

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

---@return number, number @ x, y
function GameObject:getPosition()
    return self.fixture:getBody():getPosition()
end

---@param x number
---@param y number
function GameObject:setPosition(x, y)
    self.fixture:getBody():setPosition(x, y)
end

---@param dx number
---@param dy number
function GameObject:addPosition(dx, dy)
    local x, y = self.fixture:getBody():getPosition()
    self.fixture:getBody():setPosition(x + dx, y + dy)
end

function GameObject:isDestroyed()
    return self.fixture:isDestroyed()
end

function GameObject:destroy()
    self.fixture:destroy()
end

function GameObject:draw()
    if self.drawable == nil then
        return
    end

    local x, y = self:getPosition()
    local distance = math.sqrt((x - (App.camera.x)) ^ 2 + (y - (App.camera.y)) ^ 2) - self.drawable.visibilityRadius
    if math.abs(distance) <= Params.screenOutRadius * (1/App.camera.scale) then
        self.drawable:draw(x, y, self.fixture:getBody():getAngle())
    end
end

return GameObject