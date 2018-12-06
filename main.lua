local Color = require('color')
local Camera = require('camera')
local GameObjectFactory = require('factory.game_object_factory')

---@type GameObject[]
local objects = {}
local actions = {}
local events = { key = {} }

local screenOutRadius = math.sqrt(love.graphics.getWidth() ^ 2 + love.graphics.getHeight() ^ 2) / 2

---@type Camera
local camera;

function love.load()
    love.math.setRandomSeed(love.timer.getTime())
    love.graphics.setBackgroundColor(0.03, 0.04, 0.08)

    love.physics.setMeter(64)
    world = love.physics.newWorld(0, 0, true)

    -- todo create config file

--[[    for i = 0, 100 do
        local go = GameObject:new(
            love.math.random(0, 5000),
            love.math.random(0, 5000),
            love.math.random(0, 150),
            love.math.random(0, 150)
        )
        local color = Color:new(love.math.random(), love.math.random(), love.math.random())
        Drawable:rectangle(go, 'fill', color)
        objects[#objects + 1] = go
    end]]

    local go2 = GameObjectFactory.generateCircle(
        world,
        0,
        0,
        'fill',
        Color:red(),
        60,
        'static'
    )
    objects[#objects + 1] = go2

    camera = Camera:new(love.graphics.getWidth() / 2, love.graphics.getHeight() / 2)

    local go = GameObjectFactory.generateCircle(
        world,
        camera.x,
        camera.y,
        'fill',
        Color:blue(),
        50,
        'dynamic',
        1
    )
    objects[#objects + 1] = go

    local shipSpeed = 50000

    -- todo create events for each main object and merge them in this events
    camera:assignObject(go)
    events['key']['d'] = function(dt) camera.object.physics:getBody():applyForce(shipSpeed * dt, 0) end
    events['key']['w'] = function(dt) camera.object.physics:getBody():applyForce(0, -shipSpeed * dt) end
    events['key']['a'] = function(dt) camera.object.physics:getBody():applyForce(-shipSpeed * dt, 0) end
    events['key']['s'] = function(dt) camera.object.physics:getBody():applyForce(0, shipSpeed * dt) end
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
        if math.abs(distance) <= screenOutRadius * (1/camera.scale) then
            go.draw:draw(camera, x, y)
        end
    end
end