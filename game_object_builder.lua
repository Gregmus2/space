local GameObject = require('game_object.game_object')
local DrawObject = require('game_object.draw_object')
local PhysicalObject = require('game_object.physical_object')
local PhysicalDrawObject = require('game_object.physical_draw_object')
local ComplicatedObject = require('game_object.complicated_object')
local Circle = require('drawable.circle')
local Rectangle = require('drawable.rectangle')
local Polygon = require('drawable.polygon')
local Params = require('params')

---@class GameObjectBuilder
---@field protected draw Draw|nil
---@field protected physics Fixture|nil
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

---@param mode string
---@param color Color
---@param radius number
---@return GameObjectBuilder
function GameObjectBuilder:addCircleDraw(mode, color, radius)
    self.draw = Circle:new(mode, color, radius)

    return self
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
    self.physics = self:addPhysics(shape, world, bodyType, mass, linearDamping, friction)

    return self
end

---@param mode string
---@param color Color
---@param w number
---@param h number
---@return GameObjectBuilder
function GameObjectBuilder:addRectangleDraw(mode, color, w, h)
    self.draw = Rectangle:new(mode, color, w, h)

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
    self.physics = self:addPhysics(shape, world, bodyType, mass, linearDamping, friction)

    return self
end

---@private
---@param shape Shape
---@param world World
---@param bodyType string
---@param mass number
---@param linearDamping number|nil
---@param friction number|nil
---@return Fixture
function GameObjectBuilder:addPhysics(shape, world, bodyType, mass, linearDamping, friction)
    local body = love.physics.newBody(world, self.x, self.y, bodyType)
    body:setFixedRotation(false)
    if (linearDamping ~= nil) then
        body:setLinearDamping(linearDamping or Params.default.linearDumping)
    end
    local physics = love.physics.newFixture(body, shape, mass)
    physics:setFriction(friction or Params.default.friction)

    return physics
end

---@param mode string
---@param color Color
---@param vertexes number[]
---@return GameObjectBuilder
function GameObjectBuilder:addPolygonDraw(mode, color, vertexes)
    self.draw = Polygon:new(mode, color, vertexes)

    return self
end

---@param world World
---@param vertexes number[]
---@param bodyType string
---@param mass number
---@param linearDamping number|nil
---@param friction number|nil
---@return GameObjectBuilder
function GameObjectBuilder:addPolygonPhysics(world, vertexes, bodyType, mass, linearDamping, friction)
    local countOfVertexes = #vertexes
    if countOfVertexes <= 16 then
        local shape = love.physics.newPolygonShape(vertexes)
        self.physics = self:addPhysics(shape, world, bodyType, mass, linearDamping, friction)
    else
        self.physics = {}
        local groups = math.ceil((countOfVertexes - 2) / 14)
        local vertexesInGroup = (math.ceil((countOfVertexes - 2) / 2 / groups)) * 2
        for i = 1, groups do
            local vertexesPart = {}
            local a = (i-1)*vertexesInGroup+3
            local remainder = countOfVertexes - a
            table.move(vertexes, a, a + (remainder < vertexesInGroup and remainder or vertexesInGroup - 1), 3, vertexesPart)
            vertexesPart[1], vertexesPart[2] = 0, 0
            local shape = love.physics.newPolygonShape(vertexesPart)
            self.physics[i] = self:addPhysics(shape, world, bodyType, mass, linearDamping, friction)
        end
        for i = 1, #self.physics - 1 do
            local firstBody = self.physics[i]:getBody()
            love.physics.newWeldJoint( firstBody, self.physics[i + 1]:getBody(), firstBody:getX(), firstBody:getY() )
        end
    end

    return self
end

---@return GameObject
function GameObjectBuilder:createGameObject()
    if self.draw ~= nil and self.physics ~= nil then
        if type(self.physics) == 'table' then
            return ComplicatedObject:new({self.draw}, self.physics)
        else
            return PhysicalDrawObject:new(self.draw, self.physics)
        end
    elseif self.draw ~= nil then
        return DrawObject:new(self.draw, self.x, self.y)
    elseif self.physics ~= nil then
        return PhysicalObject:new(self.physics)
    else
        return GameObject:new(self.x, self.y)
    end
end

return GameObjectBuilder