local skynet = require "skynet"
local mysql = require "skynet.db.mysql"
local socket = require "skynet.socket"
local showLog = require "showLog"

local db = nil

local function connect(fd, addr)
    showLog.info(fd.." connected addr: "..addr)
    socket.start(fd)
    while true do
        local readdata = socket.read(fd)
        if readdata ~= nil then
            readdata = string.gsub(readdata, "[\r\n]", "")
            local cmd, strdata = string.match(readdata, "^(%S+)%s*(.*)$")
            showLog.info(cmd, "================strdata", strdata)

            if cmd == "get" then
                local res = db:query("select * from testtable")
                for i, val in pairs(res) do
                    -- showLog.info(i, " id: ", val.id,"create time:", val.create_time, "value:", val.name)
                    socket.write(fd, "id: "..val.id.."  value: "..val.name.." \n")
                end
            elseif cmd == "set" then
                -- (\'"..data.."\')")
                db:query("INSERT INTO testtable (name) VALUES (\'"..strdata.."\')")
            else
                showLog.info(fd.." recv  "..readdata)
                socket.write(fd, readdata)
            end
        else
            showLog.info(fd.." close ")
            socket.close(fd)
        end
    end

end

skynet.start(function ()
    local listenfd = socket.listen("0.0.0.0", 8888)
    socket.start(listenfd, connect)

    -- 连接数据库
    local dbConfig = {
		host="127.0.0.1",
		port=3306,
		database="skynet_study",
		user="root",
		password="123456#",
                charset="utf8mb4",
		max_packet_size = 1024 * 1024,
		on_connect = nil,
    }

    db = mysql.connect(dbConfig)

    --[[
    INSERT INTO table_name (column1, column2, column3, ...)
VALUES (value1, value2, value3, ...);
    ]]

    -- 插入数据
    -- local res = db:query("INSERT INTO testtable (name) VALUES ('测试3')")

    -- 查询
    local res2 = db:query("select * from testtable")
    for i, val in pairs(res2) do
        showLog.info(i, " id: ", val.id,"create time:", val.create_time, "value:", val.name)
    end

end)