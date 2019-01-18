---@class Ship : GameObject
---@field protected core Core
---@field protected engines Engine[]
---@field protected joints table<Engine, Joint>
local Ship = {}

---@param core Core
---@param engines Engine[]
function Ship:new(core, engines)
    local newObj = {
        core = core,
        engines = engines,
        joints = {}
    }

    local coreBody = core.fixture:getBody()
    for _, engine in ipairs(engines) do
        local joint = love.physics.newWeldJoint( coreBody, engine.fixture:getBody(), coreBody:getX(), coreBody:getY() )
        newObj.joints[engine] = joint
    end

    setmetatable(newObj, self)
    self.__index = self

    return newObj
end

---@param engine Engine
function Ship:addEngine(engine)
    self.engines[#self.engines + 1] = engine
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
    self.core:setPosition(x, y)
end

function Ship:draw()
    self.core:draw()
    for _, engine in ipairs(self.engines) do
        engine:draw()
    end
end

---@return Engine[]
function Ship:getObjects()
    return self.engines
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
end

function Ship:clearVisual()
    for _, engine in ipairs(self.engines) do
        engine:resetParticles()
    end
end

---@return World
function Ship:getWorld()
    return self.core.fixture:getBody():getWorld()
end

return Ship