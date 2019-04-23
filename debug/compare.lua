return function (func1, func2)
    ffi = require("ffi")
    ffi.cdef[[
        typedef long time_t;

        typedef struct timeval {
            time_t tv_sec;
            time_t tv_usec;
        } timeval;

        int gettimeofday(struct timeval* t, void* tzp);
    ]]

    gettimeofday_struct = ffi.new("timeval")

    local function gettimeofday()
        ffi.C.gettimeofday(gettimeofday_struct, nil)
        return tonumber(gettimeofday_struct.tv_sec) * 1000000 + tonumber(gettimeofday_struct.tv_usec)
    end

    local ITER_EXP = 7

    local fmt    = string.format


    local start

    for j = 1, ITER_EXP do
        start = gettimeofday()
        for i = 1, 10 ^ j do
            func1()
        end
        print(fmt("func1 (%s): %s", j, gettimeofday() - start))
    end

    for j = 1, ITER_EXP do
        start = gettimeofday()
        for i = 1, 10 ^ j do
            func2()
        end
        print(fmt("func2 (%s): %s", j, gettimeofday() - start))
    end

    love.event.quit( )
end