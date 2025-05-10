if isServer() then
    return
end
local Core = PhunNuc
Core.contexts = {}

Core.contexts.openItem = function(player, context, items)
    local item = items[1]
    local item2 = items[2]
    local items2 = items[1].items
    local item
    if items2 == nil then
        item = items[1]
    else
        item = items2[1]
    end

    if item:getType() == Core.consts.Guide then
        local option = context:addOptionOnTop(getText("IGUI_PhunNuc_Read_Guide"), player, function()
            Core.ui.guide.open(getSpecificPlayer(player), item)
        end)

    end
end
