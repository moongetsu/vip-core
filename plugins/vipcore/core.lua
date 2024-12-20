AddEventHandler("OnPluginStart", function(event)
    db = Database("swiftly_vipcore")
    if not db:IsConnected() then return EventResult.Continue end

    db:QueryBuilder():Table(tostring(config:Fetch("vips.table_name"))):Create({
        steamid = "string|max:128|unique",
        groupid = "string|max:128|unique",
        expiretime = "integer",
        features_status = "json|default:{}"
    }):Execute(function (err, result)
        if #err > 0 then
            print("ERROR: " .. err)
        end
    end)

    LoadVipGroups()
    LoadVipPlayers()
    GenerateMenu()

    return EventResult.Continue
end)

AddEventHandler("OnAllPluginsLoaded", function(event)
    if GetPluginState("admins") == PluginState_t.Started then
        exports["admins"]:RegisterMenuCategory("vips.adminmenu.title", "admin_vip", config:Fetch("vips.manage_vip_flags"))
    end

    return EventResult.Continue
end)

function GetPluginAuthor()
    return "Swiftly Solution"
end

function GetPluginVersion()
    return "v1.0.2"
end

function GetPluginName()
    return "VIP - Core"
end

function GetPluginWebsite()
    return "https://github.com/swiftly-solution/vip-core"
end
