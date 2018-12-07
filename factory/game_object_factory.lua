local GameObject = require('game_object')
local Circle = require('drawable.circle')
local Rectangle = require('drawable.rectangle')

---@class GameObjectFactory
local GameObjectFactory = {}

--[[
    todo позже можно будет возвращать скелет без физики, а генерировать game object после вызова generate у скелета
        У скелета будет функция add или enable physics, в которую уйдет добрая часть этих параметров
        А world можно вынести в params
]]
---@param world World
---@param x number
---@param y number
---@param mode string
---@param color Color
---@param radius number
---@param bodyType string
---@param mass number
---@param restitution number|nil
---@return GameObject
function GameObjectFactory.generateCircle(world, x, y, mode, color, radius, bodyType, mass, restitution)
    local drawable = Circle:new(mode, color, radius)
    local body = love.physics.newBody(world, x, y, bodyType)
    local shape = love.physics.newCircleShape(radius)
    local physics = love.physics.newFixture(body, shape)
    if (restitution ~= nil) then
        physics:setRestitution(restitution)
    end

    return GameObject:new(drawable, physics)
end

---@param world World
---@param x number
---@param y number
---@param mode string
---@param color Color
---@param w number
---@param h number
---@param bodyType string
---@param restitution number|nil
---@return GameObject
function GameObjectFactory.generateRectangle(world, x, y, mode, color, w, h, bodyType, restitution)
    local drawable = Rectangle:new(mode, color, w, h)
    local body = love.physics.newBody(world, x, y, bodyType)
    body:setFixedRotation(true)
    local shape = love.physics.newRectangleShape(w, h)
    local physics = love.physics.newFixture(body, shape)
    if (restitution ~= nil) then
        physics:setRestitution(restitution)
    end

    return GameObject:new(drawable, physics)
end

return GameObjectFactory