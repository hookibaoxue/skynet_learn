local skynet = require "skynet"

skynet.start(function()
    skynet.newservice("debug_console",8000)
    skynet.error("<-------------------PingMain start------------------->")
    local ping1 = skynet.newservice("ping")
    local ping2 = skynet.newservice("ping")
    local ping3 = skynet.newservice("ping")
    skynet.error("pingman: send ping message from pingman to ping1, param: ping2 address")
    skynet.send(ping1, "lua", "start", ping2)
    skynet.send(ping2, "lua", "start", ping3)
    skynet.exit()
end)