local EventCollection = require('collection.event_collection')
local Menu = require('menu')
local Action = require('action')
local Event = require('enum.event')
local Params = require('params')

---@class Scene
---@field public objects GameObject[]
---@field public world World
---@field public isLoaded boolean
---@field public events EventCollection
---@field public menu Menu
local Scene = {}

function Scene:new()
    local newObj = {
        objects = {},
        events = EventCollection:new(),
        world = nil,
        isLoaded = false,
        menu = Menu:new()
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

return Scene