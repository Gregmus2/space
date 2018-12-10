local Camera = require('camera')
local Params = require('params')
local Config = require('config')
local SpaceScene = require('scenes.space_scene')

---@class App
---@field public camera Camera
---@field public scene Scene
App = {
    camera = nil,
    scene = SpaceScene
}

function App.load()
    Config:load()
    love.window.setMode(Config.width, Config.height, { msaa = Config.msaa } )
    love.math.setRandomSeed(love.timer.getTime())
    love.graphics.setBackgroundColor(0.03, 0.04, 0.08)
    love.physics.setMeter(Params.worldMeter)
    Params:init()

    App.camera = Camera:new(Params.halfScreenW, Params.halfScreenH)
end

---@param scene Scene
function App.changeScene(scene)
    App.scene:sleep()
    App.camera:reset()
    scene:load()
    App.scene = scene
end

---@param scene Scene
---@param param any
function App.changeSceneWithParam(scene, param)
    App.scene:sleep()
    App.camera:reset()
    scene:load(param)
    App.scene = scene
end

---@param dt number
function App.update(dt)
    App.scene:update(dt)
end