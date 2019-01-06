---@class Ship : GameObject
---@field protected components table<string, PhysicalDrawObject>
local Ship = {}

---@param core Core
---@param engines Engine[]
function Ship:new(core, engines)
    local newObj = {
        components = {
            core = core,
            engines = engines
        }
    }

    local coreBody = core.physics:getBody()
    for _, engine in ipairs(engines) do
        love.physics.newWeldJoint( coreBody, engine.physics:getBody(), coreBody:getX(), coreBody:getY() )
    end

    setmetatable(newObj, self)
    self.__index = self

    return newObj
end

---@param dt number
---@param direction number
function Ship:rotate(dt, direction)
    self.components.core:rotate(dt, direction)
end

---@param dt number
---@param direction number
function Ship:move(dt, direction)
    ---@param engine Engine
    for _, engine in ipairs(self.components.engines) do
        engine:move(dt, direction)
    end
end

function Ship:draw()
    self.components.core:draw()
    for _, engine in ipairs(self.components.engines) do
        engine:draw()
    end
end

return Ship