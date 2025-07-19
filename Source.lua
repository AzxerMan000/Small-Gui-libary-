local SmallGUI = {}
SmallGUI.__index = SmallGUI

local UserInputService = game:GetService("UserInputService")

function SmallGUI.new(title)
    local self = setmetatable({}, SmallGUI)

    self.tabs = {}
    self.buttonContainers = {}
    self.currentTab = nil
    self.isMinimized = false

    -- Create ScreenGui
    self.screenGui = Instance.new("ScreenGui")
    self.screenGui.Name = "SmallGUI"
    self.screenGui.ResetOnSpawn = false
    self.screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

    -- Main window frame
    self.window = Instance.new("Frame")
    self.window.Size = UDim2.new(0, 400, 0, 300)
    self.window.Position = UDim2.new(0.5, -200, 0.5, -150)
    self.window.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    self.window.BorderSizePixel = 0
    self.window.AnchorPoint = Vector2.new(0.5, 0.5)
    self.window.Parent = self.screenGui
    Instance.new("UICorner", self.window).CornerRadius = UDim.new(0, 16)

    -- Title bar
    self.titleBar = Instance.new("Frame", self.window)
    self.titleBar.Size = UDim2.new(1, 0, 0, 30)
    self.titleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Instance.new("UICorner", self.titleBar).CornerRadius = UDim.new(0, 16)

    -- Title label
    self.titleLabel = Instance.new("TextLabel", self.titleBar)
    self.titleLabel.Size = UDim2.new(1, -90, 1, 0)
    self.titleLabel.Position = UDim2.new(0, 10, 0, 0)
    self.titleLabel.BackgroundTransparency = 1
    self.titleLabel.Text = title or "SmallGUI"
    self.titleLabel.TextColor3 = Color3.new(1, 1, 1)
    self.titleLabel.Font = Enum.Font.GothamBold
    self.titleLabel.TextSize = 20
    self.titleLabel.TextXAlignment = Enum.TextXAlignment.Left

    -- Close button
    self.closeBtn = Instance.new("TextButton", self.titleBar)
    self.closeBtn.Size = UDim2.new(0, 30, 0, 30)
    self.closeBtn.Position = UDim2.new(1, -35, 0, 0)
    self.closeBtn.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
    self.closeBtn.Text = "X"
    self.closeBtn.TextColor3 = Color3.new(1, 1, 1)
    self.closeBtn.Font = Enum.Font.GothamBold
    self.closeBtn.TextSize = 18
    self.closeBtn.BorderSizePixel = 0
    Instance.new("UICorner", self.closeBtn).CornerRadius = UDim.new(0, 8)

    self.closeBtn.MouseButton1Click:Connect(function()
        self.screenGui:Destroy()
    end)

    -- Minimize button
    self.minimizeBtn = Instance.new("TextButton", self.titleBar)
    self.minimizeBtn.Size = UDim2.new(0, 30, 0, 30)
    self.minimizeBtn.Position = UDim2.new(1, -70, 0, 0)
    self.minimizeBtn.BackgroundColor3 = Color3.fromRGB(255, 200, 0)
    self.minimizeBtn.Text = "_"
    self.minimizeBtn.TextColor3 = Color3.new(1, 1, 1)
    self.minimizeBtn.Font = Enum.Font.GothamBold
    self.minimizeBtn.TextSize = 18
    self.minimizeBtn.BorderSizePixel = 0
    Instance.new("UICorner", self.minimizeBtn).CornerRadius = UDim.new(0, 8)

    self.minimizeBtn.MouseButton1Click:Connect(function()
        self.isMinimized = not self.isMinimized
        if self.isMinimized then
            self.tabList.Visible = false
            self.tabContainer.Visible = false
            self.window.Size = UDim2.new(0, 400, 0, 30)
        else
            self.tabList.Visible = true
            self.tabContainer.Visible = true
            self.window.Size = UDim2.new(0, 400, 0, 300)
        end
    end)

    -- Left tab list frame
    self.tabList = Instance.new("ScrollingFrame", self.window)
    self.tabList.Size = UDim2.new(0, 120, 1, -30)
    self.tabList.Position = UDim2.new(0, 0, 0, 30)
    self.tabList.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    self.tabList.BorderSizePixel = 0
    self.tabList.ScrollBarThickness = 6
    self.tabList.AutomaticCanvasSize = Enum.AutomaticSize.Y
    self.tabList.ClipsDescendants = true
    self.tabList.ScrollingDirection = Enum.ScrollingDirection.Y
    Instance.new("UICorner", self.tabList).CornerRadius = UDim.new(0, 12)

    -- Container for buttons on right side (tab content)
    self.tabContainer = Instance.new("Frame", self.window)
    self.tabContainer.Size = UDim2.new(1, -120, 1, -30)
    self.tabContainer.Position = UDim2.new(0, 120, 0, 30)
    self.tabContainer.BackgroundTransparency = 1
    self.tabContainer.ClipsDescendants = true

    -- Variables for dragging
    local dragging = false
    local dragInput
    local dragStart
    local startPos

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
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
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
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
            update(input)
        end
    end)

    return self
end

function SmallGUI:addTab(tabName)
    if self.tabs[tabName] then
        warn("Tab already exists: "..tabName)
        return
    end

    local tabBtn = Instance.new("TextButton")
    tabBtn.Size = UDim2.new(1, -10, 0, 40)
    tabBtn.Position = UDim2.new(0, 5, 0, #self.tabs * 45 + 5)
    tabBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    tabBtn.Text = tabName
    tabBtn.Font = Enum.Font.GothamBold
    tabBtn.TextSize = 18
    tabBtn.TextColor3 = Color3.new(1, 1, 1)
    tabBtn.BorderSizePixel = 0
    tabBtn.Parent = self.tabList
    Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0, 10)

    local container = Instance.new("ScrollingFrame")
    container.Name = "Container_"..tabName
    container.Size = UDim2.new(1, 0, 1, 0)
    container.Position = UDim2.new(0, 0, 0, 0)
    container.BackgroundTransparency = 1
    container.ScrollBarThickness = 6
    container.CanvasSize = UDim2.new(0, 0, 0, 0)
    container.AutomaticCanvasSize = Enum.AutomaticSize.Y
    container.Visible = false
    container.ClipsDescendants = true
    container.ScrollingDirection = Enum.ScrollingDirection.Y
    container.Parent = self.tabContainer

    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 6)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = container

    self.tabs[tabName] = tabBtn
    self.buttonContainers[tabName] = container

    tabBtn.MouseButton1Click:Connect(function()
        self:switchTab(tabName)
    end)

    if not self.currentTab then
        self:switchTab(tabName)
    end
end

function SmallGUI:addButtonToTab(tabName, buttonText, color, callback)
    if not self.tabs[tabName] then
        self:addTab(tabName)
    end

    local container = self.buttonContainers[tabName]
    if not container then return end

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -12, 0, 38)
    btn.BackgroundColor3 = color or Color3.fromRGB(100, 100, 100)
    btn.Text = buttonText
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 16
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.BorderSizePixel = 0
    btn.Parent = container
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)

    btn.MouseButton1Click:Connect(function()
        if callback then
            callback()
        end
    end)
end

function SmallGUI:switchTab(tabName)
    if self.currentTab == tabName then return end
    for name, container in pairs(self.buttonContainers) do
        container.Visible = (name == tabName)
    end
    for name, tabBtn in pairs(self.tabs) do
        tabBtn.BackgroundColor3 = (name == tabName) and Color3.fromRGB(90, 90, 90) or Color3.fromRGB(60, 60, 60)
    end
    self.currentTab = tabName
end

function SmallGUI:setTitle(newTitle)
    if self.titleLabel then
        self.titleLabel.Text = newTitle
    end
end

return SmallGUI
