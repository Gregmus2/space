local Scene = require('scenes.scene')
local Params = require('params')
local SpaceScene = require('scenes.space_scene')
local BuilderScene = require('scenes.builder_scene')
local TestScene = require('scenes.test_scene')
local Button = require('menu.button')

---@class MainMenuScene : Scene
local MainMenuScene = Scene:new()

function MainMenuScene:load()
    if self.isLoaded then
        return
    end
    self.isLoaded = true

    local gameButton = Button:new(Params.halfScreenW, Params.halfScreenH - 100, 200, 50, function() App.changeScene(SpaceScene) end);
    local builderButton = Button:new(Params.halfScreenW, Params.halfScreenH, 200, 50, function() App.changeScene(BuilderScene) end);
    local testButton = Button:new(Params.halfScreenW, Params.halfScreenH + 100, 200, 50, function() App.changeScene(TestScene) end);
    self.menu:addButton(gameButton)
    self.menu:addButton(builderButton)
    self.menu:addButton(testButton)
end

return MainMenuScene
