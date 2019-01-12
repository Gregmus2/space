---@param table1 table @ simple table with indexes
---@param table2 table @ simple table with indexes
function table.merge(table1, table2)
    for _, value in ipairs(table2) do
        table1[#table1 + 1] = value
    end
end