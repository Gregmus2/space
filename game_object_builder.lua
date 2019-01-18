local GameObject = require('game_object.game_object')
local Params = require('params')

---@class GameObjectBuilder
---@field protected fixture Fixture
---@field protected x number
---@field protected y number
local GameObjectBuilder = {}

---@param x number
---@param y number
function GameObjectBuilder:new(x, y)
    local newObj = {
        x = x,
        y = y
    }
    self.__index = self
    setmetatable(newObj, self)

    return newObj
end

---@param world World
---@param radius number
---@param bodyType string
---@param mass number
---@param linearDamping number|nil
---@param friction number|nil
---@return GameObjectBuilder
function GameObjectBuilder:addCirclePhysics(world, radius, bodyType, mass, linearDamping, friction)
    local shape = love.physics.newCircleShape(radius)
    self:addPhysics(shape, world, bodyType, mass, linearDamping, friction)

    return self
end

---@param world World
---@param w number
---@param h number
---@param bodyType string
---@param mass number
---@param linearDamping number|nil
---@param friction number|nil
---@return GameObjectBuilder
function GameObjectBuilder:addRectanglePhysics(world, w, h, bodyType, mass, linearDamping, friction)
    local shape = love.physics.newRectangleShape(w, h)
    self:addPhysics(shape, world, bodyType, mass, linearDamping, friction)

    return self
end

---@private
---@param shape Shape
---@param world World
---@param bodyType string
---@param mass number
---@param linearDamping number|nil
---@param friction number|nil
function GameObjectBuilder:addPhysics(shape, world, bodyType, mass, linearDamping, friction)
    local body = love.physics.newBody(world, self.x, self.y, bodyType)
    body:setFixedRotation(false)
    if (linearDamping ~= nil) then
        body:setLinearDamping(linearDamping or Params.default.linearDumping)
    end
    self.fixture = love.physics.newFixture(body, shape, mass)
    self.fixture:setFriction(friction or Params.default.friction)
end

---@param world World
---@param vertexes number[]
---@param bodyType string
---@param mass number
---@param linearDamping number|nil
---@param friction number|nil
---@return GameObjectBuilder
function GameObjectBuilder:addPolygonPhysics(world, vertexes, bodyType, mass, linearDamping, friction)
    local shape = love.physics.newPolygonShape(vertexes)
    self:addPhysics(shape, world, bodyType, mass, linearDamping, friction)

    return self
end

---@return GameObject
function GameObjectBuilder:createGameObject()
    return GameObject:new(self.fixture)
end

return GameObjectBuilder