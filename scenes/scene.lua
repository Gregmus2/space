local EventCollection = require('collection.event_collection')

---@class Scene
---@field public drawableObjects DrawObject[]
---@field public world World
---@field public isLoaded boolean
---@field public events EventCollection
local Scene = {}

function Scene:new()
    newObj = {
        drawableObjects = {},
        events = EventCollection:new(),
        world = nil,
        isLoaded = false
    }
    self.__index = self
    setmetatable(newObj, self)

    return newObj
end

function Scene:load() end

---@param dt number
function Scene:update(dt) end

return Scene