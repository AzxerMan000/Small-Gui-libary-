-- SmallGUI.lua
local SmallGUI = {}
SmallGUI.__index = SmallGUI

local UserInputService = game:GetService("UserInputService")

function SmallGUI.new(title)
    local self = setmetatable({}, SmallGUI)
    
    -- Store tabs
    self.tabs = {}
    self.currentTab = nil
    
    -- Create ScreenGui
    self.gui = Instance.new("ScreenGui")
    self.gui.Name = "SmallGUI"
    self.gui.ResetOnSpawn = false
    self.gui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    
    -- Main window frame
    self.window = Instance.new("Frame")
    self.window.Size = UDim2.new(0, 400, 0, 300)
    self.window.Position = UDim2.new(0.5, 0, 0.5, 0)
    self.window.AnchorPoint = Vector2.new(0.5, 0.5)
    self.window.BackgroundColor3 = Color3.fromRGB(35,35,35)
    self.window.BorderSizePixel = 0
    self.window.Parent = self.gui
    Instance.new("UICorner", self.window).CornerRadius = UDim.new(0, 15)
    
    -- Title bar
    self.titleBar = Instance.new("Frame", self.window)
    self.titleBar.Size = UDim2.new(1, 0, 0, 30)
    self.titleBar.BackgroundTransparency = 1
    
    -- Title label
    self.titleLabel = Instance.new("TextLabel", self.titleBar)
    self.titleLabel.Size = UDim2.new(1, -80, 1, 0)
    self.titleLabel.Position = UDim2.new(0, 10, 0, 0)
    self.titleLabel.BackgroundTransparency = 1
    self.titleLabel.Text = title or "SmallGUI"
    self.titleLabel.TextColor3 = Color3.fromRGB(255,255,255)
    self.titleLabel.Font = Enum.Font.GothamBold
    self.titleLabel.TextSize = 20
    self.titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    
    -- Close button
    self.closeBtn = Instance.new("TextButton", self.titleBar)
    self.closeBtn.Size = UDim2.new(0, 30, 0, 30)
    self.closeBtn.Position = UDim2.new(1, -35, 0, 0)
    self.closeBtn.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
    self.closeBtn.Text = "X"
    self.closeBtn.TextColor3 = Color3.new(1,1,1)
    self.closeBtn.Font = Enum.Font.GothamBold
    self.closeBtn.TextSize = 16
    self.closeBtn.BorderSizePixel = 0
    Instance.new("UICorner", self.closeBtn).CornerRadius = UDim.new(0, 8)
    self.closeBtn.MouseButton1Click:Connect(function()
        self.gui:Destroy()
    end)
    
    -- Minimize button
    self.minimizeBtn = Instance.new("TextButton", self.titleBar)
    self.minimizeBtn.Size = UDim2.new(0, 30, 0, 30)
    self.minimizeBtn.Position = UDim2.new(1, -70, 0, 0)
    self.minimizeBtn.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
    self.minimizeBtn.Text = "_"
    self.minimizeBtn.TextColor3 = Color3.new(1,1,1)
    self.minimizeBtn.Font = Enum.Font.GothamBold
    self.minimizeBtn.TextSize = 20
    self.minimizeBtn.BorderSizePixel = 0
    Instance.new("UICorner", self.minimizeBtn).CornerRadius = UDim.new(0, 8)
    
    self.isMinimized = false
    self.minimizeBtn.MouseButton1Click:Connect(function()
        self.isMinimized = not self.isMinimized
        if self.isMinimized then
            self.tabList.Visible = false
            self.buttonFrame.Visible = false
            self.window.Size = UDim2.new(0, self.window.Size.X.Offset, 0, 40)
        else
            self.tabList.Visible = true
            self.buttonFrame.Visible = true
            self.window.Size = UDim2.new(0, 400, 0, 300)
        end
    end)
    
    -- Left tab list (scrollable)
    self.tabList = Instance.new("ScrollingFrame", self.window)
    self.tabList.Size = UDim2.new(0, 120, 1, -40)
    self.tabList.Position = UDim2.new(0, 10, 0, 40)
    self.tabList.BackgroundTransparency = 1
    self.tabList.ScrollBarThickness = 6
    self.tabList.AutomaticCanvasSize = Enum.AutomaticSize.Y
    self.tabList.ScrollingDirection = Enum.ScrollingDirection.Y
    self.tabList.VerticalScrollBarInset = Enum.ScrollBarInset.Always
    
    self.tabLayout = Instance.new("UIListLayout", self.tabList)
    self.tabLayout.FillDirection = Enum.FillDirection.Vertical
    self.tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    self.tabLayout.VerticalAlignment = Enum.VerticalAlignment.Top
    self.tabLayout.Padding = UDim.new(0, 6)
    
    -- Right button frame (scrollable)
    self.buttonFrame = Instance.new("ScrollingFrame", self.window)
    self.buttonFrame.Size = UDim2.new(1, -150, 1, -40)
    self.buttonFrame.Position = UDim2.new(0, 140, 0, 40)
    self.buttonFrame.BackgroundTransparency = 1
    self.buttonFrame.ScrollBarThickness = 6
    self.buttonFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    self.buttonFrame.ScrollingDirection = Enum.ScrollingDirection.Y
    self.buttonFrame.VerticalScrollBarInset = Enum.ScrollBarInset.Always
    
    self.buttonLayout = Instance.new("UIListLayout", self.buttonFrame)
    self.buttonLayout.FillDirection = Enum.FillDirection.Vertical
    self.buttonLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    self.buttonLayout.VerticalAlignment = Enum.VerticalAlignment.Top
    self.buttonLayout.Padding = UDim.new(0, 8)
    
    -- Make window draggable (mouse + touch)
    local dragging = false
    local dragInput, dragStart, startPos
    
    local function update(input)
        local delta = input.Position - dragStart
        self.window.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
    
    self.titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = self.window.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    self.titleBar.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            update(input)
        end
    end)
    
    return self
end

-- Adds a tab on left side
function SmallGUI:addTab(tabName)
    if self.tabs[tabName] then
        warn("Tab '"..tabName.."' already exists!")
        return
    end
    
    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(1, -10, 0, 40)
    tabBtn.BackgroundColor3 = Color3.fromRGB(60,60,60)
    tabBtn.Text = tabName
    tabBtn.Font = Enum.Font.GothamBold
    tabBtn.TextSize = 18
    tabBtn.TextColor3 = Color3.new(1,1,1)
    tabBtn.Parent = self.tabList
    Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0, 10)
    
    tabBtn.MouseButton1Click:Connect(function()
        self:switchTab(tabName)
    end)

    local toggle = Instance.new("TextButton")
toggle.Size = UDim2.new(1, -10, 0, 30)
toggle.Position = UDim2.new(0, 0, 0, 45) -- adjust as needed
toggle.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
toggle.Text = "Toggle: OFF"
toggle.Font = Enum.Font.Gotham
toggle.TextSize = 16
toggle.TextColor3 = Color3.new(1, 1, 1)
toggle.Parent = self.tabList
Instance.new("UICorner", toggle).CornerRadius = UDim.new(0, 8)

-- 🟩 Toggle functionality
local toggled = false
toggle.MouseButton1Click:Connect(function()
    toggled = not toggled
    toggle.Text = toggled and "Toggle: ON" or "Toggle: OFF"
    -- You can run custom logic here:
    -- if toggled then ... else ...
end)
    
    self.tabs[tabName] = {
        button = tabBtn,
        buttons = {}
    }
    
    -- If first tab, switch to it immediately
    if not self.currentTab then
        self:switchTab(tabName)
    end
    
    return self.tabs[tabName]
end

-- Adds a button to specified tab on right side
function SmallGUI:addButtonToTab(tabName, buttonText, color, callback)
    local tab = self.tabs[tabName]
    if not tab then
        warn("Tab '"..tabName.."' does not exist!")
        return
    end
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 40)
    btn.BackgroundColor3 = color or Color3.fromRGB(100,100,100)
    btn.Text = buttonText
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 16
    btn.TextColor3 = Color3.new(1,1,1)
    btn.BorderSizePixel = 0
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 12)
    
    btn.MouseButton1Click:Connect(function()
        if callback then callback() end
    end)
    
    table.insert(tab.buttons, btn)
    
    -- Show button immediately if this tab is active
    if self.currentTab == tabName then
        btn.Parent = self.buttonFrame
    end
    
    return btn
end

-- Switches tabs
function SmallGUI:switchTab(tabName)
    if self.currentTab == tabName then return end
    
    -- Clear current buttons
    for _, child in pairs(self.buttonFrame:GetChildren()) do
        if child:IsA("TextButton") then
            child.Parent = nil
        end
    end
    
    self.currentTab = tabName
    
    -- Highlight selected tab button
    for name, tab in pairs(self.tabs) do
        tab.button.BackgroundColor3 = (name == tabName) and Color3.fromRGB(90,90,90) or Color3.fromRGB(60,60,60)
    end
    
    -- Show buttons of new tab
    local newTab = self.tabs[tabName]
    if newTab then
        for _, btn in ipairs(newTab.buttons) do
            btn.Parent = self.buttonFrame
        end
    end
end

-- Change window title
function SmallGUI:setTitle(newTitle)
    if self.titleLabel then
        self.titleLabel.Text = newTitle
    end
end

return SmallGUI
