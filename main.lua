local GameObject = require('game_object')
local DrawGenerator = require('draw_generator')
local Color = require('color')
local Camera = require('camera')

local objects = {}
local actions = {}
local events = { key = {} }

---@type Camera
local camera;

function love.load()
    -- todo create config file
    local go = GameObject:new(0, 0, 100, 100)
    local rectFunc = DrawGenerator.generateRectangle('fill', Color:blue())
    go:setDraw(rectFunc)
    objects[#objects + 1] = go

    camera = Camera:new(0, 0)

    local w = 100;
    local h = 100;
    go = GameObject:new(
    camera.x + love.graphics.getWidth() / 2 - w / 2,
    camera.y + love.graphics.getHeight() / 2 - h / 2,
        w, h
    )
    rectFunc = DrawGenerator.generateRectangle('fill', Color:blue())
    go:setDraw(rectFunc)
    objects[#objects + 1] = go

    local shipSpeed = 200

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
    -- todo what we gona do when objects will be more 1000?
    -- решать это здесь или же где-то в другом месте менять сам массив objects, исключая неиспользуемые объекты (вне зоны)
    for i = 1, #objects do
        objects[i]:draw(camera)
    end
end