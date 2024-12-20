SetTimer(10000, function()
    for i = 0, playermanager:GetPlayerCap() - 1, 1 do
        local player = GetPlayer(i)
        if player then
            if not player:IsFakeClient() then
                local expiretime = ExpireTimes[tostring(player:GetSteamID())]
                local group = player:GetVar("vip.group")
                if group ~= "none" and group ~= nil then
                    if expiretime ~= 0 and (expiretime or os.time()) - os.time() < 0 or not GroupsMap[group] then
                        db:QueryBuilder():Table(tostring(config:Fetch("vips.table_name"))):Delete():Where("steamid", "=", tostring(player:GetSteamID()))
                        player:SetVar("vip.group", "none")
                        ExpireTimes[tostring(player:GetSteamID())] = nil
                    end
                end
            end
        end
    end
end)
