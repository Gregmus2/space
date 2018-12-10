local Scene = require('scenes.scene')
local Color = require('color')
local ButtonFactory = require('factory.button_factory')


---@class BuilderScene : Scene
---@field protected pause1 DrawObject
---@field protected pause2 DrawObject
---@field protected world World
local BuilderScene = Scene:new()

function BuilderScene:load()
    if self.isLoaded then
        return
    end
    self.isLoaded = true
    self.world = love.physics.newWorld(0, 0, true)

    self.menuObjects[#self.menuObjects + 1] = ButtonFactory.createRectangleButton(
        self.world, 50, 50, 'line', Color:white(), 100, 40
    )
end

return BuilderScene
