local Scene = require('scenes.scene')
local Params = require('params')
local SpaceScene = require('scenes.space_scene')
local TestScene = require('scenes.test_scene')
local Button = require('menu.button')
local Rectangle = require('drawable.rectangle')
local Text = require('drawable.text')
local Color = require('color')

---@class MainMenuScene : Scene
local MainMenuScene = Scene:new()

function MainMenuScene:load(prevScene)
    if self.isLoaded then
        return
    end
    self.isLoaded = true
    self:createMenu()

    local d = Rectangle:new('fill', Color:white(), 200, 50)
    local gameButton = Button:new(
            Params.halfScreenW,
            Params.halfScreenH - 100,
            200, 50,
            function() App.changeScene(SpaceScene) end
    ):addDrawable(d):addDrawable(Text:new("start", Params.halfScreenW, Params.halfScreenH - 100, Color:blue()));
    local testButton = Button:new(
            Params.halfScreenW,
            Params.halfScreenH + 100,
            200,
            50,
            function() App.changeScene(TestScene) end
    ):addDrawable(d);

    self.menu:addElement(gameButton)
    self.menu:addElement(testButton)
end

return MainMenuScene
