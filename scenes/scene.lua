local EventCollection = require('collection.event_collection')
local Menu = require('menu')
local Event = require('enum.event')
local Params = require('params')
local Updatable = require('interface.updatable')

---@class Scene
---@field public objects GameObject[]|DrawObject[]
---@field public world World
---@field public isLoaded boolean
---@field public events EventCollection
---@field public menu Menu
---@field protected updatable Updatable[]
local Scene = {}

function Scene:new()
    local newObj = {
        objects = {},
        events = EventCollection:new(),
        world = nil,
        isLoaded = false,
        menu = Menu:new(),
        updatable = {}
    }
    self.__index = self
    setmetatable(newObj, self)
    newObj.events:addAction(Event.KEY, function() App.changeScene(Params.default.scene) end, 'escape')

    return newObj
end

---@param prevScene Scene
function Scene:load(prevScene) end

---@param dt number
function Scene:update(dt)
    self:updateElements(dt)
end

function Scene:sleep() end

function Scene:draw()
    for _, object in ipairs(self.objects) do
        object:draw()
    end
    self.menu:draw()
end

---@protected
---@param dt number
function Scene:updateElements(dt)
    for _, element in ipairs(self.updatable) do
        element:update(dt)
    end
end

---@param updatable Updatable
function Scene:addUpdatable(updatable)
    assert(isImplement(updatable, Updatable), 'object hasn\'t update method')
    self.updatable[#self.updatable + 1] = updatable
end

function Scene:createWorld()
    self.world = love.physics.newWorld(0, 0, true)
    self.world:setCallbacks(self.beginContact, self.endContact, self.preSolve, self.postSolve)
end

function Scene.beginContact(a, b, coll)

end

function Scene.endContact(a, b, coll)

end

function Scene.preSolve(a, b, coll)

end

function Scene.postSolve(a, b, coll, normalimpulse, tangentimpulse)

end

return Scene