if isServer() then
    return
end
local tools = require "PhunNuc/ui/tools"
local Core = PhunNuc
local profileName = "PhunNucGuide"

Core.ui.guide = ISCollapsableWindowJoypad:derive(profileName);
Core.ui.guide.instances = {}
local UI = Core.ui.guide

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

    self.controls.previous = ISButton:new(padding, buttonY, self.width / 2 - (padding * 1.5), tools.BUTTON_HGT, " < ",
        self, function()
            if self.page > 1 then
                self:navigate(self.page - 1)
            end
        end)

    self.controls.previous:initialise()
    self.controls.previous:setEnable(false)
    self.controls.previous:setAnchorLeft(true)
    self.controls.previous:setAnchorBottom(true)
    self:addChild(self.controls.previous)

    self.controls.next = ISButton:new(self.controls.previous.x + self.controls.previous.width + padding,
        self.controls.previous.y, self.controls.previous.width, self.controls.previous.height, " > ", self,
        function(target)
            if target.page < #target.data then
                target:navigate(target.page + 1)
            end
        end)
    self.controls.next:initialise()
    self.controls.next:setEnable(true)
    self.controls.next:setAnchorRight(true)
    self.controls.next:setAnchorBottom(true)
    self:addChild(self.controls.next)

    -- load image names/text 
    local panels = {"FindMag", "LearnElectronics", "Mainboard2", "PCRepair", "explor2", "ProtectionSuit", "NucWaste2",
                    "core3", "control2", "PowerON3", "Motor1", "maintain1", "fallout3", "repro1", "comsys2", "admin2", {
        text = "QR_CODE",
        image = "QR_CODE.PNG"
    }}

    for i = 1, #panels do
        -- to avoid changing assets, we use the same image for the QR code
        local texture = nil
        local text = nil
        if type(panels[i]) == "table" then
            text = getText("IGUI_PhunNuc_Guide_" .. panels[i].text)
            texture = getTexture("media/textures/ui/guide/" .. panels[i].image)
        else
            text = getText("IGUI_PhunNuc_Guide_" .. panels[i])
            texture = getTexture("media/textures/ui/guide/" .. panels[i] .. ".png")
        end

        table.insert(self.data, {
            texture = texture,
            text = text
        })
    end

    local textPanel = ISRichTextPanel:new(self.controls.next.x, y, self.controls.next.width,
        self.controls.next.y - y - 20)
    textPanel:setAnchorRight(true)
    textPanel:setAnchorBottom(true)
    textPanel:setAnchorLeft(true)
    textPanel:setAnchorRight(true)
    textPanel.marginLeft = 5
    textPanel.marginTop = 5
    textPanel.marginRight = 5
    textPanel.marginBottom = 5
    textPanel.background = false
    textPanel.borderColor = self.buttonBorderColor
    textPanel.autosetheight = false
    textPanel.clip = true

    self.controls.textPanel = textPanel
    self:addChild(textPanel)
    self.page = 1

    self:setTitle(getText("IGUI_PhunNuc_guide_x_of_y", self.page, #self.data))

end

function UI:prerender()

    ISCollapsableWindowJoypad.prerender(self)

    self:drawTextureScaledAspect2(self.data[self.page].texture, 0.0, self.controls.textPanel.y,
        self.controls.textPanel.width, self.controls.textPanel.height, 1, 1, 1, 1)

end

function UI:navigate(page)

    if self.page ~= page then
        self.page = page
    end

    self.controls.previous:setEnable(page > 1)
    self.controls.next:setEnable(page < #self.data)
    self.controls.textPanel:setText(self.data[page].text or "")
    self.controls.textPanel:paginate()
    self:setTitle(getText("IGUI_PhunNuc_guide_x_of_y", page, #self.data))

end

function UI:onResize()

    local previous = self.controls.previous
    local next = self.controls.next

    local textPanel = self.controls.textPanel
    local rh = self:resizeWidgetHeight()
    local th = self:titleBarHeight()
    local padding = 10

    local buttonY = self.height - rh - th - padding
    previous:setX(padding)
    previous:setY(buttonY)
    previous:setWidth(self.width / 2 - (padding * 1.5))
    previous:setHeight(tools.BUTTON_HGT)

    next:setX(previous.x + previous.width + padding)
    next:setY(previous.y)
    next:setWidth(previous.width)
    next:setHeight(previous.height)

    textPanel:setX(next.x)
    textPanel:setY(th)
    textPanel:setWidth(next.width)
    textPanel:setHeight(previous.y - th - padding)
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
