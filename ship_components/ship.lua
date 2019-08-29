local Components = require('interface.component')
local Point = require('model.point')

---@class Ship : GameObject
---@field protected core Core
---@field protected engines Engine[]
---@field protected other GameObject[]
---@field protected joints table<Engine, Joint>
---@field protected energy number
---@field public energyCapacity number
---@field public events EventCollection
---@field public energyRecoverSpeed number
local Ship = {}

---@param core Core
---@param engines Engine[]
---@param other GameObject[]
---@param events EventCollection
function Ship:new(core, engines, other, events)
    local newObj = {
        core = core,
        engines = {},
        other = {},
        joints = {},
        energy = 0,
        energyCapacity = 0,
        energyRecoverSpeed = 1, -- in sec
        events = events
    }

    setmetatable(newObj, self)
    self.__index = self

    local coreBody = core.fixture:getBody()
    for _, engine in ipairs(engines) do
        local joint = love.physics.newWeldJoint( coreBody, engine.fixture:getBody(), coreBody:getX(), coreBody:getY() )
        newObj.joints[engine] = joint
        newObj:addEngine(engine)
    end
    for _, component in ipairs(other) do
        local joint = love.physics.newWeldJoint( coreBody, component.fixture:getBody(), coreBody:getX(), coreBody:getY() )
        newObj.joints[component] = joint
        newObj:addComponent(component)
    end

    return newObj
end

---@param engine Engine
function Ship:addEngine(engine)
    self.engines[#self.engines + 1] = engine
end

---@param component Component
function Ship:addComponent(component)
    assert(isImplement(component, Components), 'object hasn\'t connect method')
    self.other[#self.other + 1] = component
    component:connect(self)
end

---@param dt number
---@param direction number
function Ship:rotate(dt, direction)
    self.core:rotate(dt, direction)
end

---@param dt number
---@param direction number
function Ship:move(dt, direction)
    ---@param engine Engine
    for _, engine in ipairs(self.engines) do
        engine:move(dt, direction)
    end
end

---@return Point
function Ship:getPosition()
    local body = self.core.fixture:getBody()

    return Point:new(body:getPosition())
end

---@param point Point
function Ship:setPosition(point)
    local origin_point = self.core:getPosition()
    local diff_point = point:clone()
    diff_point:diffPoint(origin_point)

    self.core:setPosition(point)
    for _, engine in ipairs(self.engines) do
        engine:addPosition(diff_point)
    end
    for _, component in ipairs(self.other) do
        component:addPosition(diff_point)
    end
end

function Ship:draw()
    self.core:draw()
    for _, engine in ipairs(self.engines) do
        engine:draw()
    end
    for _, component in ipairs(self.other) do
        component:draw()
    end
end

---@return GameObject[]
function Ship:getObjects()
    local result = {}
    table.merge(result, self.engines)
    table.merge(result, self.other)

    return result
end

function Ship:unJoin()
    for _, joint in pairs(self.joints) do
        joint:destroy()
    end
end

function Ship:reJoin()
    local coreBody = self.core.fixture:getBody()
    for _, engine in ipairs(self.engines) do
        self.joints[engine] = love.physics.newWeldJoint( coreBody, engine.fixture:getBody(), coreBody:getX(), coreBody:getY() )
    end
    for _, component in ipairs(self.other) do
        self.joints[component] = love.physics.newWeldJoint( coreBody, component.fixture:getBody(), coreBody:getX(), coreBody:getY() )
    end
end

function Ship:clearVisual()
    for _, engine in ipairs(self.engines) do
        engine:resetParticles()
    end
    for _, component in ipairs(self.other) do
        component:clearVisual()
    end
end

---@return World
function Ship:getWorld()
    return self.core.fixture:getBody():getWorld()
end

---@param points number
---@return boolean
function Ship:spendEnergy(points)
    if self.energy < points then
        return false
    end

    self.energy = self.energy - points

    return true
end

---@param dt number
function Ship:update(dt)
    if self.energy < self.energyCapacity then
        self.energy = self.energy + (self.energyRecoverSpeed * dt)
    end
end

return Ship