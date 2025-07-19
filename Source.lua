local SmallGUI = {}
SmallGUI.__index = SmallGUI

local UserInputService = game:GetService("UserInputService")
function SmallGUI.new(windowTitle, size)
    local self = setmetatable({}, SmallGUI)
    
    self.player = game:GetService("Players").LocalPlayer
    self.gui = Instance.new("ScreenGui")
    self.gui.Name = "SmallGUI"
    self.gui.ResetOnSpawn = false
    self.gui.Parent = self.player:WaitForChild("PlayerGui")
    
    self.windowSize = size or UDim2.new(0, 400, 0, 300)
    self.windowTitle = windowTitle or "SmallGUI"
    
    self.tabs = {}
    self.currentTab = nil
    
    -- Create window
    self.window = Instance.new("Frame", self.gui)
    self.window.Size = self.windowSize
    self.window.Position = UDim2.new(0.5, 0, 0.5, 0)
    self.window.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    self.window.BorderSizePixel = 0
    self.window.Active = true
    self.window.Draggable = false  -- We’ll handle dragging manually
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
    
    -- DRAGGING CODE (mouse & touch)
    local dragging = false
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
        if input.UserInputType == Enum.UserInputType.MouseButton1 or
           input.UserInputType == Enum.UserInputType.Touch then

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
        if (input.UserInputType == Enum.UserInputType.MouseMovement or
            input.UserInputType == Enum.UserInputType.Touch) and dragging then
            update(input)
        end
    end)
    
    return self
end
