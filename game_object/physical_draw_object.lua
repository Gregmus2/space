local GameObject = require('game_object.game_object')
local Params = require('params')

---@class PhysicalDrawObject : GameObject
---@field public drawable Draw
---@field public physics Fixture
---@field protected speed number
---@field protected rotateSpeed number
local PhysicalDrawObject = GameObject:new()

---@param drawable Draw
---@param physics Fixture
function PhysicalDrawObject:new(drawable, physics)
    local newObj = {
        drawable = drawable,
        physics = physics,
        speed = 5000,
        rotateSpeed = 50
    }
    setmetatable(newObj, self)
    self.__index = self

    return newObj
end

---@param dt number
---@param direction number
function PhysicalDrawObject:rotate(dt, direction)
    self.physics:getBody():applyAngularImpulse(self.rotateSpeed * dt * direction)
end

---@param dt number
---@param direction number
function PhysicalDrawObject:move(dt, direction)
    local dSpeed = direction * self.speed * dt
    self.physics:getBody():applyForce(math.cos(self.physics:getBody():getAngle()) * dSpeed, math.sin(self.physics:getBody():getAngle()) * dSpeed)
end

---@return number, number @ x, y
function PhysicalDrawObject:getPosition()
    return self.physics:getBody():getPosition()
end

---@param x number
---@param y number
function PhysicalDrawObject:setPosition(x, y)
    return self.physics:getBody():setPosition(x, y)
end

function PhysicalDrawObject:draw()
    local x, y = self:getPosition()
    local distance = math.sqrt((x - (App.camera.x)) ^ 2 + (y - (App.camera.y)) ^ 2) - self.drawable.visibilityRadius
    if math.abs(distance) <= Params.screenOutRadius * (1/App.camera.scale) then
        self.drawable:draw(x, y, self.physics:getBody():getAngle())
    end
end

return PhysicalDrawObject