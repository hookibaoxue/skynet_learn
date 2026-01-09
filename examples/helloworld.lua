local skynet = require "skynet"

-- 每个服务必须有一个启动函数
skynet.start(function()
    skynet.error("Hello World! This is my first Skynet service.")
    -- 打印完后，让这个服务退出
    skynet.exit()
end)