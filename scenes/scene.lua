local EventCollection = require('collection.event_collection')
local Menu = require('menu')
local Action = require('action')
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
    newObj.events:addEvent(Event.KEY, Action:new(function() App.changeScene(Params.default.scene) end), 'escape')

    return newObj
end

function Scene:load() end

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

function Scene:drawParticles()
    ---@param particle ParticleSystem
    for _, particle in ipairs(self.particles) do
        local x, y = particle:getPosition()
        love.graphics.draw(particle, Draw.calcX(x), Draw.calcY(y))
    end
end

---@param particle ParticleSystem
function Scene:addParticle(particle)
    self.particles[#self.particles + 1] = particle
end

return Scene