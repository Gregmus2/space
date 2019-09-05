local charset = {}  do -- [0-9a-zA-Z]
    for c = 48, 57  do table.insert(charset, string.char(c)) end
    for c = 65, 90  do table.insert(charset, string.char(c)) end
    for c = 97, 122 do table.insert(charset, string.char(c)) end
end

function string.random(length)
    if not length or length <= 0 then return '' end
    return string.random(length - 1) .. charset[math.random(1, #charset)]
end

function string:split(sep)
    if sep == nil then
        sep = "%s"
    end

    local t={}
    for str in string.gmatch(self, "([^"..sep.."]+)") do
        table.insert(t, str)
    end

    return t
end