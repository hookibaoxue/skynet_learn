local skynet = require "skynet"

local CMD = {}

local _addstep = 1

function CMD.start(source, target)
    skynet.send(target, "lua", "ping", _addstep)
end

function CMD.ping(source, addstep)
    local selfAddres = skynet.self()
    skynet.error("addres:[",selfAddres, "] recv ping count: ", addstep)
    skynet.sleep(100)
    local num = addstep + _addstep
    skynet.send(source, "lua", "ping", addstep + _addstep)
    if num >= 10 then
        skynet.exit()
    end
end

skynet.start(function()
    -- skynet.error("<-------------------Ping service start------------------->")
-- session:消息唯一id，source:消息来源地址，cmd:消息名，... 可变参数
-- session: 会话 ID（整数）。
-- 如果 session == 0，表示这是一个推送消息（push），不需要回复。
-- 如果 session > 0，表示这是一个请求消息（request），需要通过 skynet.ret(...) 回复结果。
    skynet.dispatch("lua", function(session, source, cmd, ...)
        local func = assert(CMD[cmd])
        func(source, ...)
    end)
end)