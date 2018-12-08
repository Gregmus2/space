local Camera = require('camera')
local Params = require('params')
local Config = require('config')
local SpaceScene = require('scenes.space_scene')
local LoadScene = require('scenes.pause_scene')
local Action = require('action')

---@type table<string, fun(dt:number):void>
local actions = {}
---@type Camera
local camera;
---@type Scene
local scene = SpaceScene
---@type table<string, table<string, Action>>
local globalEvents = { key = {} }

function love.load()
    Config:load()
    love.window.setMode(Config.width, Config.height, { msaa = Config.msaa } )
    love.math.setRandomSeed(love.timer.getTime())
    love.graphics.setBackgroundColor(0.03, 0.04, 0.08)
    love.physics.setMeter(Params.worldMeter)
    Params:init()

    camera = Camera:new(Params.halfScreenW, Params.halfScreenH)

    scene:load(camera)

    globalEvents['key']['space'] = Action:new(function(dt)
        -- todo сделать app класс и вынести все туда. Вынести эту логику туда в отдельную функцию
        if scene == SpaceScene then
            LoadScene:load(camera)
            scene = LoadScene
        else
            SpaceScene:load(camera)
            scene = SpaceScene
        end
    end)
end

function love.update(dt)
    scene:update(dt)

    for _,action in pairs(actions) do
        action(dt)
    end
end

function love.wheelmoved(x, y)
    -- todo добавить плавность масштабирования
    camera:addScale(y * 0.1)
end

function love.keypressed(key)
    local action = scene.events['key'][key] or globalEvents['key'][key]
    if action == nil then return end

    if action.isLong then
        actions[key] = action.action
    else
        action.action()
    end
end

function love.keyreleased(key)
    if actions[key] ~= nil then
        actions[key] = nil
    end
end

function love.draw()
    for i = 1, #scene.objects do
        local go = scene.objects[i]
        local x, y = go.physics:getBody():getPosition()
        local distance = math.sqrt((x - (camera.x)) ^ 2 + (y - (camera.y)) ^ 2) - go.draw.visibilityRadius
        if math.abs(distance) <= Params.screenOutRadius * (1/camera.scale) then
            go.draw:draw(camera, x, y)
        end
    end
end