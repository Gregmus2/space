local Event = require('enum.event')
local Draw = require('drawable.drawable')

---@class EventFactory
local EventFactory= {}

---@param events EventCollection
---@param draggableObjects PhysicalDrawObject[]
function EventFactory.draggableEvent(events, draggableObjects)
    local uniqName = string.random(10)

    events:addAction(Event.MOUSE,
        function(params)
            ---@param go PhysicalDrawObject
            for _, go in ipairs(draggableObjects) do
                if go.physics:getShape():testPoint(
                    Draw.calcX(go.physics:getBody():getX()),
                    Draw.calcY(go.physics:getBody():getY()),
                    0, params.x, params.y
                ) then
                    events:addAction(Event.MOUSE_MOVE, function(moveParams) go:setPosition(Draw:calcRealX(moveParams.x), Draw:calcRealY(moveParams.y)) end, nil, uniqName)
                    events:addAction(Event.WHEEL, function(wheelParams) go:forceRotate(wheelParams.y * 0.1) end, nil, uniqName)
                end
            end
        end, 1
    )
    events:addAction(Event.MOUSE_RELEASE,
        function(params)
            events:removeAction(Event.MOUSE_MOVE, nil, uniqName)
            events:removeAction(Event.WHEEL, nil, uniqName)
        end, 1
    )
end

return EventFactory