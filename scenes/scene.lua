---@class Scene
---@field public drawableObjects DrawObject[]
---@field public world World
---@field public camera Camera
---@field public isLoaded boolean
---@field public events table<string, table<string, Action>>
local Scene = {}

function Scene:new()
    newObj = {
        drawableObjects = {},
        events = { key = {} },
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