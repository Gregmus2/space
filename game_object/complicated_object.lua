local GameObject = require('game_object.game_object')
local Params = require('params')
local Point = require('model.point')

---@class ComplicatedObject : PhysicalDrawObject
---@field public drawable[] Draw
---@field public fixture[] Fixture
---@field protected speed number
---@field protected rotateSpeed number
local ComplicatedObject = GameObject:new()

---@param fixture Fixture[]
function ComplicatedObject:new(fixture)
    local newObj = {
        drawable = {},
        fixture = fixture,
        speed = 5000,
        rotateSpeed = 50
    }
    setmetatable(newObj, self)
    self.__index = self

    return newObj
end

---@param draw Draw
---@return ComplicatedObject
function ComplicatedObject:addDraw(draw)
    self.drawable[#self.drawable + 1] = draw

    return self
end

---@param dt number
---@param direction number
function ComplicatedObject:rotate(dt, direction) end

---@param angle number
function ComplicatedObject:forceRotate(angle) end

---@param dt number
---@param direction number
function ComplicatedObject:move(dt, direction) end

---@return Point
function ComplicatedObject:getPosition()
    return Point:new(self.fixture[1]:getBody():getPosition())
end

---@param point Point
function ComplicatedObject:setPosition(point)
    self.fixture[1]:getBody():setPosition(point:get())
end

function ComplicatedObject:testPoint(tx, ty, tr, x, y)
    return self.fixture[1]:getShape():testPoint(tx, ty, tr, x, y)
end

-- TODO refactoring
function ComplicatedObject:draw()
    if #self.drawable == 0 then
        return
    end

    local x, y = self.fixture[1]:getBody():getPosition()
    local point = Point:new(x, y)
    local distance = math.distance(point, App.camera.point) - self.drawable[1].visibilityRadius
    if math.abs(distance) <= Params.screenOutRadius * (1/App.camera.scale) then
        for _, drawable in ipairs(self.drawable) do
            drawable:draw(point, self.fixture[1]:getBody():getAngle())
        end
    end
end

return ComplicatedObject