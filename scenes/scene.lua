local EventCollection = require('collection.event_collection')
local Menu = require('menu')
local Event = require('enum.event')
local Params = require('params')
local Draw = require('drawable.drawable')

---@class Scene
---@field public objects GameObject[]
---@field public world World
---@field public isLoaded boolean
---@field public events EventCollection
---@field public menu Menu
---@field protected particles ParticleSystem[]
local Scene = {}

function Scene:new()
    local newObj = {
        objects = {},
        events = EventCollection:new(),
        world = nil,
        isLoaded = false,
        menu = Menu:new(),
        particles = {}
    }
    self.__index = self
    setmetatable(newObj, self)
    newObj.events:addAction(Event.KEY, function() App.changeScene(Params.default.scene) end, 'escape')

    return newObj
end

---@param prevScene Scene
function Scene:load(prevScene) end

---@param dt number
function Scene:update(dt) end

function Scene:sleep() end

function Scene:draw()
    for _, object in ipairs(self.objects) do
        object:draw()
    end
    self.menu:draw()
end

---@protected
---@param dt number
function Scene:updateParticles(dt)
    for _, particle in ipairs(self.particles) do
        particle:update(dt)
    end
end

---@param particle ParticleSystem
function Scene:addParticle(particle)
    self.particles[#self.particles + 1] = particle
end

return Scene