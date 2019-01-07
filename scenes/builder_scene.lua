local Scene = require('scenes.scene')
local Color = require('color')
local GameObjectBuilder = require('game_object_builder')
local Event = require('enum.event')
local Draw = require('drawable.drawable')


---@class BuilderScene : Scene
---@field protected world World
---@field protected draggableObject PhysicalDrawObject[]
local BuilderScene = Scene:new()

function BuilderScene:load()
    if self.isLoaded then
        return
    end
    self.isLoaded = true
    self.draggableObject = {}
    self.world = love.physics.newWorld(0, 0, true)

    local draggable = GameObjectBuilder
        :new(0, 0)
        :addRectangleDraw('fill', Color:white(), 100, 100)
        :addRectanglePhysics(self.world, 100, 100, 'dynamic')
        :createGameObject()
    self.objects[#self.objects + 1] = draggable
    self.draggableObject[#self.draggableObject + 1] = draggable

    self.events:addAction(Event.MOUSE,
        function(params)
            for _, go in ipairs(self.draggableObject) do
                if go.physics:getShape():testPoint(
                    Draw.calcX(go.physics:getBody():getX()),
                    Draw.calcY(go.physics:getBody():getY()),
                    0, params.x, params.y
                ) then
                    self.events:addAction(Event.MOUSE_MOVE, function(moveParams) go.physics:getBody():setPosition(moveParams.x, moveParams.y) end, nil, 'drag')
                end
            end
        end, 1
    )
    self.events:addAction(Event.MOUSE_RELEASE,
        function(params)
            self.events:removeAction(Event.MOUSE_MOVE, nil, 'drag')
        end, 1
    )
end

return BuilderScene
