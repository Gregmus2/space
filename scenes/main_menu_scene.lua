local Scene = require('scenes.scene')
local Params = require('params')
local SpaceScene = require('scenes.space_scene')
local TestScene = require('scenes.test_scene')
local Button = require('menu.button')

---@class MainMenuScene : Scene
local MainMenuScene = Scene:new()

function MainMenuScene:load(prevScene)
    if self.isLoaded then
        return
    end
    self.isLoaded = true
    self:createMenu()

    local gameButton = Button:new(Params.halfScreenW, Params.halfScreenH - 100, 200, 50, function() App.changeScene(SpaceScene) end);
    local testButton = Button:new(Params.halfScreenW, Params.halfScreenH + 100, 200, 50, function() App.changeScene(TestScene) end);
    self.menu:addElement(gameButton)
    self.menu:addElement(testButton)
end

return MainMenuScene
