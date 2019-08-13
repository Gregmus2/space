---@param directory string
function scandir(directory)
    local i, t, popen = 0, {}, io.popen
    for filename in string.gmatch(popen('dir "'..directory..'"'):read(), "[^%s]+") do
        i = i + 1
        t[i] = filename
    end

    return t
end