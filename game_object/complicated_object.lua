local GameObject = require('game_object.game_object')
local Params = require('params')

---@class ComplicatedObject : PhysicalDrawObject
---@field public drawable[] Draw
---@field public physics[] Fixture
---@field protected speed number
---@field protected rotateSpeed number
local ComplicatedObject = GameObject:new()

---@param drawable Draw[]
---@param physics Fixture[]
function ComplicatedObject:new(drawable, physics)
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
function ComplicatedObject:rotate(dt, direction) end

---@param angle number
function ComplicatedObject:forceRotate(angle) end

---@param dt number
---@param direction number
function ComplicatedObject:move(dt, direction) end

---@return number, number @ x, y
function ComplicatedObject:getPosition() end

---@param x number
---@param y number
function ComplicatedObject:setPosition(x, y) end

-- TODO refactoring
function ComplicatedObject:draw()
    local x, y = self.physics[1]:getBody():getPosition()
    local distance = math.sqrt((x - (App.camera.x)) ^ 2 + (y - (App.camera.y)) ^ 2) - self.drawable[1].visibilityRadius
    if math.abs(distance) <= Params.screenOutRadius * (1/App.camera.scale) then
        for _, drawable in ipairs(self.drawable) do
            drawable:draw(x, y, self.physics[1]:getBody():getAngle())
        end
    end
end

return ComplicatedObject