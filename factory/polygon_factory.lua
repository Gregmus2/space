---@class PolygonFactory
local PolygonFactory = {}

--- http://cglab.ca/~sander/misc/ConvexGeneration/convex.html
---
function PolygonFactory.generateRandomConvex(minPoints, maxPoints, avgSize)
    local X, Y, avgHalfSize = {}, {}, math.floor(avgSize / 2)

    local countOfPoints = math.random(minPoints, maxPoints)
    for i = 1, countOfPoints do
        X[i] = math.random(avgHalfSize)
        Y[i] = math.random(avgHalfSize)
    end

    table.sort(X)
    table.sort(Y)
    
    local XVec, YVec = {}, {}

    local lastTop, lastBot = X[1], X[1]
    for i = 2, countOfPoints - 1 do
        local x = X[i]

        if math.random() > 0.5 then
            XVec[#XVec + 1] = x - lastTop
            lastTop = x
        else
            XVec[#XVec + 1] = lastBot - x
            lastBot = x
        end
    end

    XVec[#XVec + 1] = X[#X] - lastTop
    XVec[#XVec + 1] = lastBot - X[#X]

    local lastLeft, lastRight = Y[1], Y[1]
    for i = 2, countOfPoints - 1 do
        local y = Y[i]

        if math.random() > 0.5 then
            YVec[#YVec + 1] = y - lastLeft
            lastLeft = y
        else
            YVec[#YVec + 1] = lastRight - y
            lastRight = y
        end
    end

    YVec[#YVec + 1] = Y[#Y] - lastLeft
    YVec[#YVec + 1] = lastRight - Y[#Y]

    table.shuffle(XVec)
    table.shuffle(YVec)

    local vectors = {}
    for i = 1, #XVec do
        vectors[i] = { XVec[i], YVec[i] }
    end

    table.sort(vectors, function(a, b)
        return a[1]*b[2] - a[2]*b[1] > 0
    end) -- sort by angle
    
    local points, x, y = {}, 0, 0
    for i = 1, countOfPoints do
        points[#points + 1] = {x, y}
        x = x + vectors[i][1]
        y = y + vectors[i][2]
    end

    local vertexes = {}
    for i = 1, #points do
        vertexes[i*2-1] = points[i][1]
        vertexes[i*2] = points[i][2]
    end

    return vertexes
end

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