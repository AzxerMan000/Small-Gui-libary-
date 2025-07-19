-- SmallGUI.lua
local SmallGUI = {}
SmallGUI.__index = SmallGUI

local Players = game:GetService("Players")

function SmallGUI.new(windowTitle)
    local self = setmetatable({}, SmallGUI)
    
    self.player = Players.LocalPlayer
    self.gui = Instance.new("ScreenGui")
    self.gui.Name = "SmallGUI"
    self.gui.ResetOnSpawn = false
    self.gui.Parent = self.player:WaitForChild("PlayerGui")
    
    self.windowSize = UDim2.new(0, 400, 0, 300)
    self.windowTitle = windowTitle or "SmallGUI"
    
    self.tabs = {}
    self.currentTab = nil
    
    -- Create window
    self.window = Instance.new("Frame", self.gui)
    self.window.Size = self.windowSize
    self.window.Position = UDim2.new(0.5, -self.windowSize.X.Offset/2, 0.5, -self.windowSize.Y.Offset/2)
    self.window.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    self.window.BorderSizePixel = 0
    self.window.Active = true
    self.window.Draggable = true
    Instance.new("UICorner", self.window).CornerRadius = UDim.new(0, 16)
    
    -- Title bar
    self.titleBar = Instance.new("Frame", self.window)
    self.titleBar.Size = UDim2.new(1, 0, 0, 30)
    self.titleBar.Position = UDim2.new(0, 0, 0, 0)
    self.titleBar.BackgroundTransparency = 1
    
    -- Title label
    self.titleLabel = Instance.new("TextLabel", self.titleBar)
    self.titleLabel.Size = UDim2.new(1, -90, 1, 0)
    self.titleLabel.Position = UDim2.new(0, 10, 0, 0)
    self.titleLabel.BackgroundTransparency = 1
    self.titleLabel.Text = self.windowTitle
    self.titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    self.titleLabel.Font = Enum.Font.GothamBold
    self.titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    self.titleLabel.TextSize = 20
    
    -- Close button
    self.closeBtn = Instance.new("TextButton", self.titleBar)
    self.closeBtn.Size = UDim2.new(0, 30, 0, 30)
    self.closeBtn.Position = UDim2.new(1, -35, 0, 0)
    self.closeBtn.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
    self.closeBtn.Text = "X"
    self.closeBtn.TextColor3 = Color3.new(1, 1, 1)
    self.closeBtn.Font = Enum.Font.GothamBold
    self.closeBtn.TextSize = 16
    self.closeBtn.BorderSizePixel = 0
    Instance.new("UICorner", self.closeBtn).CornerRadius = UDim.new(0, 8)
    
    self.closeBtn.MouseButton1Click:Connect(function()
        self.gui:Destroy()
    end)

    -- Minimize Button
self.minimizeBtn = Instance.new("TextButton", self.titleBar)
self.minimizeBtn.Size = UDim2.new(0, 30, 0, 30)
self.minimizeBtn.Position = UDim2.new(1, -70, 0, 0)
self.minimizeBtn.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
self.minimizeBtn.Text = "_"
self.minimizeBtn.TextColor3 = Color3.new(1, 1, 1)
self.minimizeBtn.Font = Enum.Font.GothamBold
self.minimizeBtn.TextSize = 16
self.minimizeBtn.BorderSizePixel = 0
Instance.new("UICorner", self.minimizeBtn).CornerRadius = UDim.new(0, 8)

     -- Minimize Functionality
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
        self.window.Size = self.windowSize
    end
end)
        

    
    
    -- Left Tab List
    self.tabList = Instance.new("ScrollingFrame", self.window)
    self.tabList.Size = UDim2.new(0, 120, 1, -40)
    self.tabList.Position = UDim2.new(0, 10, 0, 40)
    self.tabList.BackgroundTransparency = 1
    self.tabList.ScrollBarThickness = 6
    self.tabList.CanvasSize = UDim2.new(0, 0, 0, 0)
    self.tabList.AutomaticCanvasSize = Enum.AutomaticSize.Y
    self.tabList.ScrollingDirection = Enum.ScrollingDirection.Y
    
    self.tabLayout = Instance.new("UIListLayout", self.tabList)
    self.tabLayout.FillDirection = Enum.FillDirection.Vertical
    self.tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    self.tabLayout.VerticalAlignment = Enum.VerticalAlignment.Top
    self.tabLayout.Padding = UDim.new(0, 8)
    
    -- Right Buttons Frame
    self.buttonFrame = Instance.new("ScrollingFrame", self.window)
    self.buttonFrame.Size = UDim2.new(1, -150, 1, -40)
    self.buttonFrame.Position = UDim2.new(0, 140, 0, 40)
    self.buttonFrame.BackgroundTransparency = 1
    self.buttonFrame.ScrollBarThickness = 6
    self.buttonFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    self.buttonFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    self.buttonFrame.ScrollingDirection = Enum.ScrollingDirection.Y
    
    self.buttonLayout = Instance.new("UIListLayout", self.buttonFrame)
    self.buttonLayout.FillDirection = Enum.FillDirection.Vertical
    self.buttonLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    self.buttonLayout.VerticalAlignment = Enum.VerticalAlignment.Top
    self.buttonLayout.Padding = UDim.new(0, 8)
    
    return self
end

function SmallGUI:addTab(tabName)
    if self.tabs[tabName] then
        warn("Tab '" .. tabName .. "' already exists.")
        return
    end
    
    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(1, -10, 0, 40)
    tabBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    tabBtn.Text = tabName
    tabBtn.Font = Enum.Font.GothamBold
    tabBtn.TextSize = 18
    tabBtn.TextColor3 = Color3.new(1, 1, 1)
    tabBtn.Parent = self.tabList
    Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0, 10)
    
    local tabData = {
        button = tabBtn,
        buttons = {}
    }
    
    tabBtn.MouseButton1Click:Connect(function()
        self:switchTab(tabName)
    end)
    
    self.tabs[tabName] = tabData
    
    -- If this is the first tab added, auto-switch to it
    if not self.currentTab then
        self:switchTab(tabName)
    end
    
    return tabData
end

function SmallGUI:addButtonToTab(tabName, buttonName, color, callback)
    local tab = self.tabs[tabName]
    if not tab then
        warn("Tab '" .. tabName .. "' does not exist.")
        return
    end
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0.9, 0, 0, 40)
    btn.BackgroundColor3 = color or Color3.fromRGB(100, 100, 100)
    btn.Text = buttonName
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 16
    btn.TextColor3 = Color3.new(1, 1, 1)
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 12)
    
    btn.MouseButton1Click:Connect(function()
        if callback then
            callback()
        end
    end)
    
    table.insert(tab.buttons, btn)
    
    -- If this tab is current, show the button immediately
    if self.currentTab == tabName then
        btn.Parent = self.buttonFrame
    end
    
    return btn
end

function SmallGUI:switchTab(tabName)
    if self.currentTab == tabName then return end
    
    -- Clear current buttons from right side
    for _, child in pairs(self.buttonFrame:GetChildren()) do
        if child:IsA("TextButton") then
            child.Parent = nil
        end
    end
    
    self.currentTab = tabName

    
function SmallGUI:switchTab(tabName)
    -- your switchTab implementation
    end

    -- Update tab button colors to highlight selected tab
    for name, tabData in pairs(self.tabs) do
        if tabData.button then
            tabData.button.BackgroundColor3 = (name == tabName) and Color3.fromRGB(90, 90, 90) or Color3.fromRGB(60, 60, 60)
        end
    end
    
    -- Show buttons for the selected tab
    local tabData = self.tabs[tabName]
    if tabData then
        for _, btn in ipairs(tabData.buttons) do
            btn.Parent = self.buttonFrame
        end
    end
end

function SmallGUI:setTitle(newTitle)
    if self.titleLabel then
        self.titleLabel.Text = newTitle
    end
end

return SmallGUI
