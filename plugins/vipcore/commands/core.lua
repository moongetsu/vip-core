commands:Register("addvip", function(playerid, args, argc, silent)
    if playerid ~= -1 then return end
    if not db then return end
    if not db:IsConnected() then return end

    if argc < 3 then return print("Syntax: sw_addvip <steamid64> <groupid> <duration (seconds)>") end

    local steamid64 = args[1]
    local groupid = args[2]
    local duration = math.floor(tonumber(args[3]) or -1)

    if not GroupsMap[groupid] then return print("Error: Invalid Group ID.") end
    if duration < 0 then return print("Error: Duration needs to be a positive number") end

    db:QueryBuilder():Table(tostring(config:Fetch("vips.table_name"))):Select({}):Where("steamid", "=", steamid64):Execute(function (err, result)
            if #err > 0 then
                return print("ERROR: " .. err)
            end

            if #result == 0 then
                db:QueryBuilder():Table(tostring(config:Fetch("vips.table_name"))):Insert({steamid = steamid64, groupid = groupid, expiretime = (duration == 0 and 0 or os.time() + duration)}):Execute()
                print(string.format("Player %s is having VIP Group '%s' for %s.", steamid64, groupid,
                    ComputePrettyTime(duration)))
                local pids = FindPlayersByTarget(steamid64, false)
                if #pids == 0 then return end
                LoadPlayerGroup(pids[1]:GetSlot())
            else
                print("Error: Player already has a VIP Group.")
            end
        end)
end)

commands:Register("removevip", function(playerid, args, argc, silent)
    if playerid ~= -1 then return end
    if not db then return end
    if not db:IsConnected() then return end

    if argc < 1 then return print("Syntax: sw_removevip <steamid64>") end

    local steamid64 = args[1]

    db:QueryBuilder():Table(tostring(config:Fetch("vips.table_name"))):Delete():Where("steamid", "=", steamid64):Execute()
    print(string.format("Player %s is no longer having a VIP Group.", steamid64))
    local pids = FindPlayersByTarget(steamid64, false)
    if #pids == 0 then return end
    LoadPlayerGroup(pids[1]:GetSlot())
end)
