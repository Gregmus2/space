local EventCollection = require('collection.event_collection')
local Menu = require('menu')
local Event = require('enum.event')
local Params = require('params')
local Updatable = require('interface.updatable')
local Visible = require('interface.visible')

---@class Scene
---@field public world World
---@field public isLoaded boolean
---@field public events EventCollection
---@field public menu Menu
---@field protected updatable Updatable[]
---@field protected visible Visible[]
---@field public cameraState table<string, any>
local Scene = {}

function Scene:new()
    local newObj = {
        events = EventCollection:new(),
        world = nil,
        isLoaded = false,
        menu = nil,
        updatable = {},
        visible = {}
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
    for _, visible in ipairs(self.visible) do
        visible:draw()
    end
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

---@param visible Visible
function Scene:addVisible(visible)
    assert(isImplement(visible, Visible), 'object hasn\'t draw method')
    self.visible[#self.visible + 1] = visible
end

function Scene:createWorld()
    self.world = love.physics.newWorld(0, 0, true)
    self.world:setCallbacks(self.beginContact, self.endContact, self.preSolve, self.postSolve)
    self:addUpdatable(self.world)
end

function Scene:createMenu()
    self.menu = Menu:new()
    self:addUpdatable(self.menu)
    self:addVisible(self.menu)
end

---@param a Fixture
---@param b Fixture
---@param coll Contact
function Scene.beginContact(a, b, coll)
    if (a:getBody():isBullet()) then
        a:destroy();
    end
    if (b:getBody():isBullet()) then
        b:destroy();
    end
end

function Scene.endContact(a, b, coll)

end

function Scene.preSolve(a, b, coll)

end

function Scene.postSolve(a, b, coll, normalimpulse, tangentimpulse)

end

function Scene:reset()
    self.events:clear()
    self.updatable = {}
    self.visible = {}
end

return Scene