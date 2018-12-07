local Color = require('color')
local Camera = require('camera')
local GameObjectFactory = require('factory.game_object_factory')
local Params = require('params')

---@type GameObject[]
local objects = {}
local actions = {}
local events = { key = {} }

---@type Camera
local camera;

function love.load()
    love.window.setMode( 1024, 768, {msaa=8} )
    love.math.setRandomSeed(love.timer.getTime())
    love.graphics.setBackgroundColor(0.03, 0.04, 0.08)
    love.physics.setMeter(64)
    world = love.physics.newWorld(0, 0, true)

    Params:init()

    for i = 0, 100 do
        local color = Color:new(love.math.random(), love.math.random(), love.math.random())
        local go = GameObjectFactory.generateRectangle(
            world,
            love.math.random(0, 5000),
            love.math.random(0, 5000),
            'fill',
            color,
            love.math.random(0, 150),
            love.math.random(0, 150),
            'static'
        )
        objects[#objects + 1] = go
    end

    camera = Camera:new(love.graphics.getWidth() / 2, love.graphics.getHeight() / 2)

    local go2 = GameObjectFactory.generateCircle(
            world,
            0,
            0,
            'fill',
            Color:blue(),
            50,
            'static',
            1
    )
    objects[#objects + 1] = go2

    local go = GameObjectFactory.generateRectangle(
        world,
        camera.x,
        camera.y,
        'fill',
        Color:blue(),
        50,
        50,
        'dynamic'
    )
    objects[#objects + 1] = go

    -- todo create events for each main object and merge them in this events
    camera:assignObject(go)
    events['key']['d'] = function(dt) camera.object:rotate(dt, 1) end
    events['key']['w'] = function(dt) camera.object:move(dt, 1) end
    events['key']['a'] = function(dt) camera.object:rotate(dt, -1) end
    events['key']['s'] = function(dt) camera.object:move(dt, -1) end
end

function love.update(dt)
    world:update(dt)
    camera:setCoords(camera.object.physics:getBody():getPosition())

    for _,action in pairs(actions) do
        action(dt)
    end
end

function love.wheelmoved(x, y)
    camera:addScale(y * 0.1)
end

function love.keypressed(key)
    if events['key'][key] ~= nil then
        actions[key] = events['key'][key]
    end
end

function love.keyreleased(key)
    if actions[key] ~= nil then
        actions[key] = nil
    end
end

function love.draw()

    -- todo добавить плавность масштабирования
    for i = 1, #objects do
        local go = objects[i]
        local x, y = go.physics:getBody():getPosition()
        local distance = math.sqrt((x - (camera.x)) ^ 2 + (y - (camera.y)) ^ 2) - go.draw.visibilityRadius
        if math.abs(distance) <= Params.screenOutRadius * (1/camera.scale) then
            go.draw:draw(camera, x, y)
        end
    end
end