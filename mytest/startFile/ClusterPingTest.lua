local skynet = require "skynet"
local socket = require "skynet.socket"
local cluster = require "skynet.cluster"

require "skynet.manager" -- 需要给服务起名字或者启动 C 模块，就必须引入 skynet.manager

skynet.start(function()
    cluster.reload({
        node1 = "127.0.0.1:7001",
        node2 = "127.0.0.1:7002",
    })

    local mynode = skynet.getenv("node")
    if mynode =="node1" then
        cluster.open(mynode)
        local ping1 = skynet.newservice("ping")
        local ping2 = skynet.newservice("ping")
        skynet.send(ping1, "lua", "start2", "node2", "pong")
        skynet.send(ping2, "lua", "start2", "node2", "pong")
    elseif mynode == "node2" then
        local ping3 = skynet.newservice("ping")
        skynet.name("pong", ping3)
        cluster.open(mynode)
    end
end)