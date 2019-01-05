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

end

---@param dt number
---@param direction number
function ComplicatedObject:move(dt, direction)

end

---@return number, number @ x, y
function ComplicatedObject:getPosition()

end

---@param x number
---@param y number
function ComplicatedObject:setPosition(x, y)

end

function ComplicatedObject:draw()
    for _, object in ipairs(self.gameObjects) do
        object:draw()
    end
end

return ComplicatedObject