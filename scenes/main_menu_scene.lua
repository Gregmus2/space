local Scene = require('scenes.scene')
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

    local menuX = wpixels(0.2)
    local quitButton = Button:newWithText(
            menuX,
            hpixels(9.5),
            'quit',
            Resources:getFont(FONT_CASANOVA, 26),
            false,
            function()
                love.event.quit()
            end
    );
    local testButton = Button:newWithText(
            menuX,
            quitButton.y - quitButton.h,
            'test',
            Resources:getFont(FONT_CASANOVA, 26),
            false,
            function()
                App.changeScene(TestScene)
            end
    );
    local gameButton = Button:newWithText(
            menuX,
            testButton.y - testButton.h,
            'start',
            Resources:getFont(FONT_CASANOVA, 26),
            false,
            function()
                App.changeScene(SpaceScene)
            end
    );

    self.menu:addElement(gameButton)
    self.menu:addElement(testButton)
    self.menu:addElement(quitButton)
end

return MainMenuScene