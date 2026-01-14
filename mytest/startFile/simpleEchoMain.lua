local skynet = require "skynet"
local socket = require "skynet.socket"
local showLog = require "showLog"

local MAXNUM = 3
-- local clientList = {}
local clientAddresList = {}
local function connect(fd, addr)
    showLog.info(fd.." connected addr: "..addr)
    local num = math.random(1, MAXNUM)
    local targetAddr = clientAddresList[num].addr
    skynet.send(targetAddr, "lua", "recvMessage", fd)
    -- socket.start调用 连接socket
    -- socket.start(fd)
    -- if not clientList[fd] then
    --     clientList[fd] = true   -- 记录连接的客户端socket
    -- end

    -- while true do
    --     local readdata = socket.read(fd)
    --     if readdata ~= nil then
    --         skynet.error(fd.." recv  "..readdata)

    --         -- 广播给所有客户端
    --         for _fd in pairs(clientList) do
    --             socket.write(_fd, readdata)
    --         end
    --     else
    --         skynet.error(fd.." close ")
    --         socket.close(fd)
    --         clientList[fd] = nil
    --     end
    -- end
end

skynet.start(function()
    for i = 1, MAXNUM do
        local addr = skynet.newservice("echoClient")
        clientAddresList[i] = {
            addr = addr,
        }
    end

    local port = tonumber(skynet.getenv("ECHO_PORT")) or 8888
    local listenfd = socket.listen("0.0.0.0", port)
    socket.start(listenfd, connect)
end)