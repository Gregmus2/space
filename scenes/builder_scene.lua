local Scene = require('scenes.scene')
local Color = require('color')
local GameObjectBuilder = require('game_object_builder')
local Event = require('enum.event')
local Draw = require('drawable.drawable')


---@class BuilderScene : Scene
---@field protected world World
---@field protected draggableObject PhysicalDrawObject[]
local BuilderScene = Scene:new()

---@param hero Ship
---@param prevScene Scene
function BuilderScene:load(prevScene, hero)
    self.hero = hero
    if self.isLoaded then
        self:awake(prevScene)
        return
    end
    self.isLoaded = true
    self.draggableObject = {}
    self.world = love.physics.newWorld(0, 0, true)

    self:awake(prevScene)
end

function BuilderScene:sleep()
    self.hero:reJoin()
    self.draggableObject = {}
end

function BuilderScene:awake(prevScene)
    self.hero:unJoin()
    self.hero:clearVisual()
    App.camera:setCoords(self.hero:getPosition())

    local draggable = GameObjectBuilder
        :new(Draw:calcRealX(0), Draw:calcRealY(0))
        :addRectangleDraw('fill', Color:white(), 100, 100)
        :addRectanglePhysics(self.world, 100, 100, 'dynamic')
        :createGameObject()
    self.objects[#self.objects + 1] = draggable
    self.draggableObject[#self.draggableObject + 1] = draggable

    self.objects[#self.objects + 1] = self.hero
    local engines = self.hero:getObjects()
    for _, engine in ipairs(engines) do
        self.draggableObject[#self.draggableObject + 1] = engine
    end

    self.events:addAction(Event.MOUSE,
        function(params)
            for _, go in ipairs(self.draggableObject) do
                if go.physics:getShape():testPoint(
                    Draw.calcX(go.physics:getBody():getX()),
                    Draw.calcY(go.physics:getBody():getY()),
                    0, params.x, params.y
                ) then
                    self.events:addAction(Event.MOUSE_MOVE, function(moveParams) go:setPosition(Draw:calcRealX(moveParams.x), Draw:calcRealY(moveParams.y)) end, nil, 'drag')
                end
            end
        end, 1
    )
    self.events:addAction(Event.MOUSE_RELEASE,
        function(params)
            self.events:removeAction(Event.MOUSE_MOVE, nil, 'drag')
        end, 1
    )

    self.events:addAction(Event.KEY, function() App.changeScene(prevScene) end, 'f')
end

return BuilderScene
