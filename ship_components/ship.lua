---@class Ship : GameObject
---@field protected core Core
---@field protected engines Engine[]
---@field protected other GameObject[]
---@field protected joints table<Engine, Joint>
local Ship = {}

---@param core Core
---@param engines Engine[]
---@param other GameObject[]
function Ship:new(core, engines, other)
    local newObj = {
        core = core,
        engines = engines,
        other = other,
        joints = {}
    }

    local coreBody = core.fixture:getBody()
    for _, engine in ipairs(engines) do
        local joint = love.physics.newWeldJoint( coreBody, engine.fixture:getBody(), coreBody:getX(), coreBody:getY() )
        newObj.joints[engine] = joint
    end
    for _, component in ipairs(other) do
        local joint = love.physics.newWeldJoint( coreBody, component.fixture:getBody(), coreBody:getX(), coreBody:getY() )
        newObj.joints[component] = joint
    end

    setmetatable(newObj, self)
    self.__index = self

    return newObj
end

---@param engine Engine
function Ship:addEngine(engine)
    self.engines[#self.engines + 1] = engine
end

---@param component GameObject
function Ship:addComponent(component)
    self.other[#self.other + 1] = component
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

---@return number, number @ x, y
function Ship:getPosition()
    local body = self.core.fixture:getBody()

    return body:getX(), body:getY()
end

---@param x number
---@param y number
function Ship:setPosition(x, y)
    local xOrigin, yOrigin = self.core:getPosition()
    local xDiff, yDiff = x - xOrigin, y - yOrigin

    self.core:setPosition(x, y)
    for _, engine in ipairs(self.engines) do
        engine:addPosition(xDiff, yDiff)
    end
    for _, component in ipairs(self.other) do
        component:addPosition(xDiff, yDiff)
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

return Ship