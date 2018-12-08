local EventCollection = require('collection.event_collection')

---@class Scene
---@field public drawableObjects DrawObject[]
---@field public world World
---@field public camera Camera
---@field public isLoaded boolean
---@field public events EventCollection
local Scene = {}

function Scene:new()
    newObj = {
        drawableObjects = {},
        events = EventCollection:new(),
        world = nil,
        camera = nil,
        isLoaded = false
    }
    self.__index = self
    setmetatable(newObj, self)

    return newObj
end

---@param camera Camera
function Scene:load(camera) end

---@param dt number
function Scene:update(dt) end

return Scene