local skynet = require "skynet"
local socket = require "skynet.socket"
local showLog = require "showLog"
local CMD = {}

function CMD.recvMessage(source, fd)
    socket.start(fd)
    while true do
        local readdata = socket.read(fd)
        if readdata ~= nil then
            showLog.info(fd.." recv  "..readdata)
            socket.write(fd, readdata)
        else
            showLog.info(fd.." close ")
            socket.close(fd)
        end
    end
end

skynet.start(function()
    skynet.dispatch("lua", function(session, source, cmd, ...)
        local func = assert(CMD[cmd])
        func(source, ...)
    end)
end)