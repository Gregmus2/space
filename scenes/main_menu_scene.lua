local Scene = require('scenes.scene')
local SpaceScene = require('scenes.space_scene')
local TestScene = require('scenes.test_scene')
local Button = require('menu.button')
local Config = require('config')

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


function MainMenuScene:draw()
    for _, visible in ipairs(self.visible) do
        visible:draw()
    end

    if self.back ~= nil then
        love.graphics.draw(self.back, 0, 0)
    end
end

---@private
---@param prevScene Scene
function MainMenuScene:buildBack(prevScene)
    if prevScene == nil then
        return
    end

    local canvas = love.graphics.newCanvas(Config.width, Config.height)
    love.graphics.setCanvas(canvas)
    love.graphics.clear()
    if prevScene.cameraState then
        App.camera:setState(prevScene.cameraState)
    end
    prevScene:draw()
    App.camera:reset()
    love.graphics.setCanvas()
    self.back = canvas
end

return MainMenuScene