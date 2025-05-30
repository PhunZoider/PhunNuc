if isServer() then
    return
end
local tools = require "PhunNuc/ui/tools"
local Core = PhunNuc
local profileName = "PhunNucRDD"

Core.ui.rdd = ISCollapsableWindowJoypad:derive(profileName);
Core.ui.rdd.instances = {}
local UI = Core.ui.rdd

function UI.open(player)

    local playerIndex = player:getPlayerNum()

    local core = getCore()
    local width = 500 * tools.FONT_SCALE
    local height = 500 * tools.FONT_SCALE

    local x = (core:getScreenWidth() - width) / 2
    local y = (core:getScreenHeight() - height) / 2

    local instance = UI:new(x, y, width, height, player, playerIndex);
    instance:initialise();
    ISLayoutManager.RegisterWindow(profileName, UI, instance)
    instance:addToUIManager();
    instance:setVisible(true);
    instance:ensureVisible()
    return instance;

end

function UI:new(x, y, width, height, player, playerIndex)
    local o = {};
    o = ISCollapsableWindowJoypad:new(x, y, width, height, player);
    setmetatable(o, self);
    self.__index = self;

    o.variableColor = {
        r = 0.9,
        g = 0.55,
        b = 0.1,
        a = 1
    };
    o.backgroundColor = {
        r = 0,
        g = 0,
        b = 0,
        a = 0.8
    };
    o.buttonBorderColor = {
        r = 0.7,
        g = 0.7,
        b = 0.7,
        a = 1
    };
    o.controls = {}
    o.data = {}
    o.moveWithMouse = false;
    o.anchorRight = true
    o.anchorBottom = true
    o.player = player
    o.playerIndex = playerIndex
    o.zOffsetLargeFont = 25;
    o.zOffsetMediumFont = 20;
    o.zOffsetSmallFont = 6;
    o:setWantKeyEvents(true)
    return o;
end

function UI:RestoreLayout(name, layout)

    ISLayoutManager.DefaultRestoreWindow(self, layout)
    if name == profileName then
        ISLayoutManager.DefaultRestoreWindow(self, layout)
        self.userPosition = layout.userPosition == 'true'
    end
    self:recalcSize();
end

function UI:SaveLayout(name, layout)
    ISLayoutManager.DefaultSaveWindow(self, layout)
    if self.userPosition then
        layout.userPosition = 'true'
    else
        layout.userPosition = 'false'
    end
end

function UI:createChildren()

    ISCollapsableWindowJoypad.createChildren(self)

    local th = self:titleBarHeight()
    local rh = self:resizeWidgetHeight()
    local padding = 10
    local x = padding
    local y = th
    local w = self.width
    local h = self.height - rh - th
    local buttonY = w - rh - th - padding

end

function UI:prerender()

    ISCollapsableWindowJoypad.prerender(self)

    self:drawTextureScaledAspect2(self.data[self.page].texture, 0.0, self.controls.textPanel.y,
        self.controls.textPanel.width, self.controls.textPanel.height, 1, 1, 1, 1)

end

function UI:onResize()

end

function UI:close()
    if not self.locked then
        ISCollapsableWindowJoypad.close(self);
    end
end

function UI:isKeyConsumed(key)
    return key == Keyboard.KEY_ESCAPE
end

function UI:onKeyRelease(key)
    if key == Keyboard.KEY_ESCAPE then
        self:close()
    end
end
