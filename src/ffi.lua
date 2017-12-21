local ffi = require('ffi')

local ext

if ffi.os == 'Linux' then
    ext = 'so'
else
    ext = 'dylib'
end

ffi.cdef[[
void pretty_print(const char* input);
]]

local lib = ffi.load('target/debug/libelayr.' .. ext)
local pretty_print = lib.pretty_print

local input = io.read("*a")

pretty_print(input)
