local GameObject = require('game_object')
local Circle = require('drawable.circle')
local Rectangle = require('drawable.rectangle')
local Polygon = require('drawable.polygon')
local Params = require('params')

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
---@param linearDamping number|nil
---@param friction number|nil
---@return GameObject
function GameObjectFactory.generateCircle(world, x, y, mode, color, radius, bodyType, mass, linearDamping, friction)
    local drawable = Circle:new(mode, color, radius)
    local body = love.physics.newBody(world, x, y, bodyType)
    body:setFixedRotation(true)
    if (linearDamping ~= nil) then
        body:setLinearDamping(linearDamping or Params.default.linearDumping)
    end
    local shape = love.physics.newCircleShape(radius)
    local physics = love.physics.newFixture(body, shape, mass)
    physics:setFriction(friction or Params.default.friction)

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
---@param mass number
---@param linearDamping number|nil
---@param friction number|nil
---@return GameObject
function GameObjectFactory.generateRectangle(world, x, y, mode, color, w, h, bodyType, mass, linearDamping, friction)
    local drawable = Rectangle:new(mode, color, w, h)
    local body = love.physics.newBody(world, x, y, bodyType)
    body:setFixedRotation(true)
    if (linearDamping ~= nil) then
        body:setLinearDamping(linearDamping or Params.default.linearDumping)
    end
    local shape = love.physics.newRectangleShape(w, h)
    local physics = love.physics.newFixture(body, shape, mass)
    physics:setFriction(friction or Params.default.friction)

    return GameObject:new(drawable, physics)
end

---@param world World
---@param x number
---@param y number
---@param mode string
---@param color Color
---@param vertexes table
---@param bodyType string
---@param mass number
---@param linearDamping number|nil
---@param friction number|nil
---@return GameObject
function GameObjectFactory.generatePolygon(world, x, y, mode, color, vertexes, bodyType, mass, linearDamping, friction)
    local drawable = Polygon:new(mode, color, vertexes)
    local body = love.physics.newBody(world, x, y, bodyType)
    body:setFixedRotation(true)
    if (linearDamping ~= nil) then
        body:setLinearDamping(linearDamping or Params.default.linearDumping)
    end
    local shape = love.physics.newPolygonShape(vertexes)
    local physics = love.physics.newFixture(body, shape, mass)
    physics:setFriction(friction or Params.default.friction)

    return GameObject:new(drawable, physics)
end

return GameObjectFactory