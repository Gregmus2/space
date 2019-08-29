local Scene = require('scenes.scene')
local SpaceScene = require('scenes.space_scene')
local TestScene = require('scenes.test_scene')
local SettingsScene = require('scenes.settings_scene')
local Button = require('menu.button')
local Config = require('config')
local Canvas = require('drawable.canvas')
local Area = require('model.area')
local Point = require('model.point')
local Event = require('enum.event')

---@class MainMenuScene : Scene
local MainMenuScene = Scene:new()

function MainMenuScene:load(prevScene)
    self:buildBack(prevScene)

    if self.isLoaded then
        return
    end
    self.isLoaded = true
    self:createMenu()

    local menuX = wpixels(0.2)
    local font = Resources:getFont(FONT_CASANOVA, 26)
    local quitButton = Button:newWithText(
        Point:new(
            menuX,
            hpixels(9.5)
        ),
        'quit',
        font,
        false,
        function()
            love.event.quit()
        end
    );
    local testButton = Button:newWithText(
        Point:new(
            menuX,
            quitButton.point.y - quitButton.area.h
        ),
        'test',
        font,
        false,
        function()
            App.changeScene(TestScene)
        end
    );
    local settingsButton = Button:newWithText(
        Point:new(
            menuX,
            testButton.point.y - testButton.area.h
        ),
        'settings',
        font,
        false,
        function()
            App.changeScene(SettingsScene)
        end
    );
    local gameButton = Button:newWithText(
        Point:new(
            menuX,
            settingsButton.point.y - settingsButton.area.h
        ),
        'start',
        font,
        false,
        function()
            App.changeScene(SpaceScene)
        end
    );

    self.menu:addElement(gameButton)
    self.menu:addElement(testButton)
    self.menu:addElement(settingsButton)
    self.menu:addElement(quitButton)

    self.events:addAction(Event.KEY, function() App.changeScene(SpaceScene) end, 'escape', 'menu')
end

function MainMenuScene:draw()
    for _, visible in ipairs(self.visible) do
        visible:draw()
    end

    if self.back ~= nil then
        self.back:drawShape()
    end
end

---@private
---@param prevScene Scene
function MainMenuScene:buildBack(prevScene)
    if prevScene == nil then
        return
    end

    if self.back == nil then
        self.back = Canvas:new(
            Area:new(Config.width, Config.height),
            function()
                if prevScene.cameraState then
                    App.camera:setState(prevScene.cameraState)
                end
                prevScene:draw()
                App.camera:reset()
            end,
            Point:new(0, 0)
        )
    end

    self.back:snapshot()
end

return MainMenuScene