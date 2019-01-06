local GameObject = require('game_object.game_object')

---@class DrawObject : GameObject
---@field protected drawable Draw
---@field protected angle number
---@field protected speed number
---@field protected rotateSpeed number
local DrawObject = GameObject:new()

---@param drawable Draw
---@param x number
---@param y number
function DrawObject:new(drawable, x, y)
    local newObj = {
        x = x,
        y = y,
        angle = 0,
        speed = 5000,
        rotateSpeed = 5,
        drawable = drawable
    }
    setmetatable(newObj, self)
    self.__index = self

    return newObj
end

---@param dt number
---@param direction number
function DrawObject:rotate(dt, direction)
    self.angle = self.angle + self.rotateSpeed * dt * direction
    self.drawable.angle = self.angle
end

---@param dt number
---@param direction number
function GameObject:move(dt, direction)
    local dSpeed = direction * self.speed * dt
    self.x = self.x + math.cos(self.angle) * dSpeed
    self.y = self.y + math.sin(self.angle) * dSpeed
end

function DrawObject:draw()
    local x, y = self:getPosition()
    local distance = math.sqrt((x - (App.camera.x)) ^ 2 + (y - (App.camera.y)) ^ 2) - self.drawable.visibilityRadius
    if math.abs(distance) <= Params.screenOutRadius * (1/App.camera.scale) then
        self.drawable:draw(x, y, self.angle)
    end
end

return DrawObject