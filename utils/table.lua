---@param table1 table @ simple table with indexes
---@param table2 table @ simple table with indexes
function table.merge(table1, table2)
    for _, value in ipairs(table2) do
        table1[#table1 + 1] = value
    end
end

---@param t table
function table.shuffle(t)
    local iterations = #t
    local j

    for i = iterations, 2, -1 do
        j = math.random(i)
        t[i], t[j] = t[j], t[i]
    end
end

function table.deepCopy(orig, deep)
    if deep == 0 then
        return orig
    end
    local nextDeep = deep - 1

    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[table.deepCopy(orig_key, nextDeep)] = table.deepCopy(orig_value, nextDeep)
        end
        setmetatable(copy, table.deepCopy(getmetatable(orig), nextDeep))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end