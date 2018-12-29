local PhysicalDrawObject = require('game_object.physical_draw_object')
local GameObject = require('game_object.game_object')

---@class ComplicatedObject : GameObject
---@field public draw Draw
---@field public physics Fixture
---@field protected speed number
---@field protected rotateSpeed number
---@field protected angle number
local ComplicatedObject = GameObject:new()

---@param gameObjects PhysicalDrawObject[]
function ComplicatedObject:new(gameObjects)
    newObj = {
        gameObjects = gameObjects
    }
    setmetatable(newObj, self)
    self.__index = self

    return newObj
end

---@param dt number
---@param direction number
function ComplicatedObject:rotate(dt, direction)
    self.angle = self.angle + self.rotateSpeed * dt * direction
    self.draw.angle = self.angle
    self.physics:getBody():setAngle(self.angle)
end

---@param dt number
---@param direction number
function ComplicatedObject:move(dt, direction)
    local dSpeed = direction * self.speed * dt
    self.physics:getBody():applyForce(math.cos(self.angle) * dSpeed, math.sin(self.angle) * dSpeed)
end

---@return number, number @ x, y
function ComplicatedObject:getPosition()
    return self.physics:getBody():getPosition()
end

---@param x number
---@param y number
function ComplicatedObject:setPosition(x, y)
    return self.physics:getBody():setPosition(x, y)
end

return ComplicatedObject