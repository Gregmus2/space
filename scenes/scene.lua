local EventCollection = require('collection.event_collection')

---@class Scene
---@field public drawableObjects DrawObject[]
---@field public menuObjects MenuObject[]
---@field public world World
---@field public isLoaded boolean
---@field public events EventCollection
local Scene = {}

function Scene:new()
    newObj = {
        drawableObjects = {},
        menuObjects = {},
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

function Scene:sleep() end

---@param go GameObject
function Scene:draw(go)
    local x, y = go:getPosition()
    go:draw(x, y)
end

---@param mo MenuObject
function Scene:drawMenu(mo)
    mo:draw()
end

return Scene