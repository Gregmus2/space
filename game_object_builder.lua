local GameObject = require('game_object.game_object')
local ComplicatedObject = require('game_object.complicated_object')
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
    self.fixture = self:addPhysics(shape, world, bodyType, mass, linearDamping, friction)

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
    self.fixture = self:addPhysics(shape, world, bodyType, mass, linearDamping, friction)

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
    local fixture = love.physics.newFixture(body, shape, mass)
    fixture:setFriction(friction or Params.default.friction)

    return fixture
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
        self.fixture = self:addPhysics(shape, world, bodyType, mass, linearDamping, friction)
    else
        --[[
            если вершин более 8(на одну вершину x и y), то нужно делить их на полигоны,
            так как box2d не принимает полигоны с более 8 вершинами. В таком кейсе
            выходит объект, состоящий из vertexes/8 связанных между собой полигонов
            + каждый полигон должен начинаться с 0, 0, таким образом образуется фигура пиццы или пирога,
            что скрывает пробелы между полигонами. Только нулевая вершина находится не в центре фигуры,
            а скраю
            + нельзя иметь полигон с меньше, чем 3 вершинами, поэтому приходится
            распределять вершины равномерно по полигонам, этим и занимается этот кусок.
        --]]
        self.fixture = {}
        --[[
            8 = максимальное кол-во вершин
            (8 - 2) = две зарезервированные вершины (0-я вершина и вершина для стыка с прошлым полигоном)
            * 2 = количество точек (x, y)
            (countOfVertexes - 2) = минус нулевая вершина (0, 0)
        --]]
        local groups = math.ceil((countOfVertexes - 2) / ((8 - 2) * 2))
        local vertexesInGroup = (math.ceil((countOfVertexes - 2) / 2 / groups)) * 2
        for i = 1, groups do
            local vertexesPart = {}
            local a = (i-1)*vertexesInGroup+5
            local remainder = countOfVertexes - a
            -- копировать элементы от а до a + vertexesInGroup в vertexesPart на 5 элемент и далее (0-я вершина и вершина для склейки)
            table.move(vertexes, a, a + (remainder < vertexesInGroup and remainder or vertexesInGroup - 1), 5, vertexesPart)
            vertexesPart[1], vertexesPart[2] = 0, 0
            vertexesPart[3], vertexesPart[4] = vertexes[a-2], vertexes[a-1]
            local shape = love.physics.newPolygonShape(vertexesPart)
            self.fixture[i] = self:addPhysics(shape, world, bodyType, mass, linearDamping, friction)
        end
        for i = 1, #self.fixture - 1 do
            local firstBody = self.fixture[i]:getBody()
            love.physics.newWeldJoint( firstBody, self.fixture[i + 1]:getBody(), firstBody:getX(), firstBody:getY() )
        end
    end

    return self
end

---@return GameObject
function GameObjectBuilder:createGameObject()
    if type(self.fixture) == 'table' then
        return ComplicatedObject:new(self.fixture)
    else
        return GameObject:new(self.fixture)
    end
end

return GameObjectBuilder