local skynet = require "skynet"

skynet.start(function()
    skynet.error("<-------------------PingMain start------------------->")
    local ping1 = skynet.newservice("ping")
    local ping2 = skynet.newservice("ping")
    skynet.error("pingman: send ping message from pingman to ping1, param: ping2 address")
    skynet.send(ping1, "lua", "start", ping2)
    skynet.exit()
end)