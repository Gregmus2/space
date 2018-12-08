local Scene = require('scenes.scene')
local Color = require('color')
local GameObjectBuilder = require('game_object_builder')

---@class LoadScene : Scene
---@field protected pause1 DrawObject
---@field protected pause2 DrawObject
local LoadScene = Scene:new()

---@param camera Camera
function LoadScene:load(camera)
    if self.isLoaded then
        self:awake()
        return
    end
    self.isLoaded = true
    self.camera = camera

    self.pause1 = GameObjectBuilder
        :new(camera.x - 50, camera.y)
        :addRectangleDraw('fill', Color:white(), 50, 100)
        :createGameObject()

    self.pause2 = GameObjectBuilder
        :new(camera.x + 50, camera.y)
        :addRectangleDraw('fill', Color:white(), 50, 100)
        :createGameObject()

    self.drawableObjects[#self.drawableObjects + 1] = self.pause1
    self.drawableObjects[#self.drawableObjects + 1] = self.pause2
end

---@private
function LoadScene:awake()
    self.pause1:setPosition(self.camera.x - 50, self.camera.y)
    self.pause2:setPosition(self.camera.x + 50, self.camera.y)
end

return LoadScene
