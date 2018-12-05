local GameObject = require('game_object')
local Color = require('color')
local Camera = require('camera')
local Drawable = require('drawable')

---@type GameObject[]
local objects = {}
local actions = {}
local events = { key = {} }

local halfScreenW = love.graphics.getWidth() / 2;
local halfScreenH = love.graphics.getHeight() / 2;
local screenOutRadius = math.sqrt(love.graphics.getWidth() ^ 2 + love.graphics.getHeight() ^ 2) / 2

---@type Camera
local camera;

function love.load()
    love.math.setRandomSeed(love.timer.getTime())

    -- todo create config file

    for i = 0, 100 do
        local go = GameObject:new(
            love.math.random(0, 5000),
            love.math.random(0, 5000),
            love.math.random(0, 150),
            love.math.random(0, 150)
        )
        local color = Color:new(love.math.random(), love.math.random(), love.math.random())
        Drawable:rectangle(go, 'fill', color)
        objects[#objects + 1] = go
    end

    camera = Camera:new(love.graphics.getWidth() / 2, love.graphics.getHeight() / 2)

    local w = 50;
    local h = 50;
    go = GameObject:new(
        camera.x + love.graphics.getWidth() / 2,
        camera.y + love.graphics.getHeight() / 2,
            w, h
    )
    Drawable:circle(go, 'fill', Color:blue())
    objects[#objects + 1] = go

    local shipSpeed = 500

    -- todo create events for each main object and merge them in this events
    camera:assignObject(go)
    events['key']['d'] = function(dt) camera:move(shipSpeed * dt, 0) end
    events['key']['w'] = function(dt) camera:move(0, -shipSpeed * dt) end
    events['key']['a'] = function(dt) camera:move(-shipSpeed * dt, 0) end
    events['key']['s'] = function(dt) camera:move(0, shipSpeed * dt) end
end

function love.update(dt)
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
    -- todo добавить плавность передвижений, масштабирования
    for i = 1, #objects do
        local go = objects[i]
        local distance = math.sqrt((go.x - (camera.x + halfScreenW)) ^ 2 + (go.y - (camera.y + halfScreenH)) ^ 2) - go.draw.visibilityRadius
        if math.abs(distance) <= screenOutRadius * (1/camera.scale) then
            go.draw.draw(camera)
        end
    end
end