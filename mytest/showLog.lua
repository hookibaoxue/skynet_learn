local skynet = require "skynet"

local _M = {}

local COL_INFO   = "\27[1;92m" -- 亮绿色（加粗）
local COL_WARN   = "\27[1;93m" -- 亮黄色（加粗）
local COL_ERROR  = "\27[1;91m" -- 亮红色（加粗）
local COL_RESET  = "\27[0m"

local function do_log(color, ...)
    -- 1. 自动处理所有传入参数，转换为字符串
    local args = {...}
    local tmp = {}
    for i = 1, select("#", ...) do
        tmp[i] = tostring(args[i])
    end
    local content = table.concat(tmp, "  ") -- 用两个空格分隔多个参数

    -- 2. 获取调用位置 (层级为 3)
    local info = debug.getinfo(3, "Sl")
    local source = info.short_src:match("^.+/(.+)$") or info.short_src

    -- 3. 拼接最终字符串
    local prefix = string.format("%s[%s:%d]%s ", color, source, info.currentline, COL_RESET)

    -- 4. 调用原生接口输出
    skynet.error(prefix .. content)
end

function _M.info(...)
    do_log(COL_INFO, ...)
end

function _M.warn(...)
    do_log(COL_WARN, ...)
end
function _M.error(...)
    do_log(COL_ERROR, ...)
end

return _M