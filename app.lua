local Camera = require('camera')
local Params = require('params')
local Config = require('config')
local MainMenuScene = require('scenes.main_menu_scene')
local Event = require('enum.event')
local EventCollection = require('collection.event_collection')
require('resources')

---@class App
---@field public camera Camera
---@field public scene Scene
App = {
    camera = nil,
    scene = MainMenuScene,
    debug = false,
    events = EventCollection:new()
}

function App.load()
    Config:load()
    love.window.setMode(Config.width, Config.height, { msaa = Config.msaa } )
    love.math.setRandomSeed(love.timer.getTime())
    love.graphics.setBackgroundColor(0.03, 0.04, 0.08)
    love.physics.setMeter(Params.worldMeter)
    App.debug = Config.debug
    Params:init()
    Params.default.scene = MainMenuScene
    Resources:load()

    App.events:addAction(Event.KEY, function() App.debug = not App.debug end, '`')

    App.camera = Camera:new(Params.halfScreenW, Params.halfScreenH)

    App.wten = Config.width / 10
    App.hten = Config.height / 10
end

---@param scene Scene
function App.changeScene(scene)
    App.scene:sleep()
    App.camera:reset()
    collectgarbage()
    local prevScene = App.scene
    App.scene = scene
    scene:load(prevScene)
end

---@param scene Scene
---@param param any
function App.changeSceneWithParam(scene, param)
    App.scene:sleep()
    App.camera:reset()
    collectgarbage()
    local prevScene = App.scene
    App.scene = scene
    scene:load(prevScene, param)
end

---@param dt number
function App.update(dt)
    App.scene:update(dt)
end

function App.draw()
    if App.debug then
        love.graphics.setColor(1, 1, 1)
        love.graphics.print('FPS: ' .. love.timer.getFPS(), 10, 10);
    end
end

--- convert width tens to pixels
function wpixels(tens)
    return App.wten * tens
end

--- convert height tens to pixels
function hpixels(tens)
    return App.hten * tens
end