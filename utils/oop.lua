---@param target table @ object
---@param interface table @ class
function isImplement(target, interface)
    local metaTable = getmetatable(target)
    for key, _ in pairs(interface) do
        if metaTable[key] == nil then
            return false
        end
    end

    return true
end