local Scene = require('scenes.scene')
local Color = require('color')
local GameObjectBuilder = require('game_object_builder')
local Event = require('enum.event')
local Action = require('action')

---@class LoadScene : Scene
---@field protected pause1 DrawObject
---@field protected pause2 DrawObject
local LoadScene = Scene:new()

---@param scene Scene
function LoadScene:load(scene)
    if self.isLoaded then
        self:awake()
        return
    end
    self.isLoaded = true

    self.pause1 = GameObjectBuilder
        :new(App.camera.x - 50, App.camera.y)
        :addRectangleDraw('fill', Color:white(), 50, 100)
        :createGameObject()

    self.pause2 = GameObjectBuilder
        :new(App.camera.x + 50, App.camera.y)
        :addRectangleDraw('fill', Color:white(), 50, 100)
        :createGameObject()

    self.drawableObjects[#self.drawableObjects + 1] = self.pause1
    self.drawableObjects[#self.drawableObjects + 1] = self.pause2

    self.events:addEvent(Event.KEY, 'space', Action:new(function(dt) App.changeScene(scene) end ))
end

---@private
function LoadScene:awake()
    self.pause1:setPosition(App.camera.x - 50, App.camera.y)
    self.pause2:setPosition(App.camera.x + 50, App.camera.y)
end

return LoadScene
