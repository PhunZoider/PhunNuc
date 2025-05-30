PhunNuc = {
    name = "PhunNuc",
    consts = {
        Guide = "NUC_Mag3",
        repairPoints = "PhunNuc_RepairPoints",
    },
    data = {
        
    },
    commands = {},
    events = {},
    settings = {},
    ui = {}
}

local Core = PhunNuc
Core.isLocal = not isClient() and not isServer() and not isCoopHost()
Core.settings = SandboxVars[Core.name] or {}
for _, event in pairs(Core.events) do
    if not Events[event] then
        LuaEventManager.AddEvent(event)
    end
end

