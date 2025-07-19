-- SmallGUI Library with Scrollable Tabs

local SmallGUI = {} SmallGUI.__index = SmallGUI

function SmallGUI.new(title) local self = setmetatable({}, SmallGUI)

self.tabs = {}
self.buttonContainers = {}
self.currentTab = nil

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SmallGUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 400, 0, 300)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.Parent = screenGui
self.window = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 40)
titleLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
titleLabel.Text = title or "Window"
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 20
titleLabel.TextColor3 = Color3.new(1, 1, 1)
titleLabel.Parent = mainFrame

local tabList = Instance.new("Frame")
tabList.Size = UDim2.new(0, 120, 1, -40)
tabList.Position = UDim2.new(0, 0, 0, 40)
tabList.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
tabList.Parent = mainFrame
self.tabList = tabList

local tabContainer = Instance.new("Frame")
tabContainer.Size = UDim2.new(1, -120, 1, -40)
tabContainer.Position = UDim2.new(0, 120, 0, 40)
tabContainer.BackgroundTransparency = 1
tabContainer.Parent = mainFrame
self.tabContainer = tabContainer

return self

end

function SmallGUI:addTab(tabName) if self.tabs[tabName] then warn("Tab already exists: " .. tabName) return end

local tabBtn = Instance.new("TextButton")
tabBtn.Size = UDim2.new(1, -10, 0, 40)
tabBtn.Position = UDim2.new(0, 5, 0, #self.tabs * 45 + 5)
tabBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
tabBtn.Text = tabName
tabBtn.Font = Enum.Font.GothamBold
tabBtn.TextSize = 18
tabBtn.TextColor3 = Color3.new(1, 1, 1)
tabBtn.Parent = self.tabList
Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0, 10)

local container = Instance.new("ScrollingFrame")
container.Name = "Container_" .. tabName
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
self.buttonContainers[tabName] = container

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 5)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = container

self.tabs[tabName] = tabBtn

tabBtn.MouseButton1Click:Connect(function()
    self:switchTab(tabName)
end)

if not self.currentTab then
    self:switchTab(tabName)
end

end

function SmallGUI:switchTab(tabName) for name, container in pairs(self.buttonContainers) do container.Visible = (name == tabName) end self.currentTab = tabName end

function SmallGUI:addButtonToTab(tabName, buttonText, color, callback) if not self.tabs[tabName] then self:addTab(tabName) end

local container = self.buttonContainers[tabName]
if not container then return end

local button = Instance.new("TextButton")
button.Size = UDim2.new(1, -10, 0, 35)
button.BackgroundColor3 = color or Color3.fromRGB(100, 100, 100)
button.Text = buttonText
button.Font = Enum.Font.Gotham
button.TextSize = 14
button.TextColor3 = Color3.new(1, 1, 1)
button.BorderSizePixel = 0
button.LayoutOrder = 1
button.Parent = container

local corner = Instance.new("UICorner", button)
corner.CornerRadius = UDim.new(0, 6)

if callback then
    button.MouseButton1Click:Connect(callback)
end

end

return SmallGUI

