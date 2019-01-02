local EventCollection = require('collection.event_collection')
local Menu = require('menu')

---@class Scene
---@field public drawableObjects DrawObject[]
---@field public world World
---@field public isLoaded boolean
---@field public events EventCollection
---@field public menu Menu
local Scene = {}

function Scene:new()
    newObj = {
        drawableObjects = {},
        events = EventCollection:new(),
        world = nil,
        isLoaded = false,
        menu = Menu:new()
    }
    self.__index = self
    setmetatable(newObj, self)

    return newObj
end

function Scene:load() end

---@param dt number
function Scene:update(dt) end

function Scene:sleep() end

---@param go GameObject
function Scene:draw(go)
    local x, y = go:getPosition()
    go.draw:draw(x, y)
end

return Scene