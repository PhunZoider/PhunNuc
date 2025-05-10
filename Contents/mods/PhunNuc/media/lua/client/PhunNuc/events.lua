if isServer() then
    return
end
local Core = PhunNuc

Events.OnFillInventoryObjectContextMenu.Add(Core.contexts.openItem);
