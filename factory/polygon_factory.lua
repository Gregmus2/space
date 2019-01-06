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

---@param size number
function PolygonFactory.generateRocket(w, h, h2)
    return {
        1 * h / 2, -1 * w / 2,
        1 * h / 2 + h2, 0,
        1 * h / 2, 1 * w / 2,
        -1 * h / 2, 1 * w / 2,
        -1 * h / 2, -1 * w / 2
    }
end

---@param size number
function PolygonFactory.generateRectangle(w, h)
    return {
        1 * w / 2, -1 * h / 2,
        1 * w / 2, 1 * h / 2,
        -1 * w / 2, 1 * h / 2,
        -1 * w / 2, -1 * h / 2
    }
end

return PolygonFactory