---@class PolygonFactory
local PolygonFactory = {}

---@param size number
function PolygonFactory.generateShip(size)
    return {
        1 * size, 0 * size,
        -1 * size, 1 * size,
        -0.5 * size, 0 * size,
        -1 * size, -1 * size,
    }
end

return PolygonFactory