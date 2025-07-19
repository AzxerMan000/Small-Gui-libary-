--// Clean & Working Small Curved GUI Library local SmallGUI = {} SmallGUI.__index = SmallGUI

-- Services local Players = game:GetService("Players") local player = Players.LocalPlayer

-- Create new GUI function SmallGUI.new(title) local self = setmetatable({}, SmallGUI)

-- ScreenGui
local gui = Instance.new("ScreenGui")
gui.Name = "SmallWindowGUI"
gui.ResetOnSpawn = false
gui.Parent = game:GetService("CoreGui")
self.gui = gui

-- Main Frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 320, 0, 220)
frame.Position = UDim2.new(0.5, -160, 0.5, -110)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
frame.Active = true
frame.Draggable = true
frame.Parent = gui
self.frame = frame

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = frame

-- Titlebar
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 0, 30)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = title or "Window"
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 18
titleLabel.TextColor3 = Color3.new(1, 1, 1)
titleLabel.Parent = frame

-- Tabs List
local tabList = Instance.new("Frame")
tabList.Position = UDim2.new(0, 0, 0, 30)
tabList.Size = UDim2.new(0, 100, 1, -30)
tabList.BackgroundTransparency = 1
tabList.Parent = frame
self.tabList = tabList

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 5)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = tabList

-- Content Area
local contentFrame = Instance.new("Frame")
contentFrame.Position = UDim2.new(0, 100, 0, 30)
contentFrame.Size = UDim2.new(1, -100, 1, -30)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = frame
self.contentFrame = contentFrame

self.tabs = {}
self.currentTab = nil

return self

end

function SmallGUI:addTab(name) if self.tabs[name] then return end

local tabBtn = Instance.new("TextButton")
tabBtn.Size = UDim2.new(1, -10, 0, 35)
tabBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
tabBtn.Text = name
tabBtn.Font = Enum.Font.Gotham
tabBtn.TextSize = 14
tabBtn.TextColor3 = Color3.new(1,1,1)
tabBtn.Parent = self.tabList

Instance.new("UICorner", tabBtn).CornerRadius = UDim.new(0, 8)

local tabContent = Instance.new("Frame")
tabContent.Size = UDim2.new(1, 0, 1, 0)
tabContent.Visible = false
tabContent.BackgroundTransparency = 1
tabContent.Parent = self.contentFrame

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 4)
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Parent = tabContent

self.tabs[name] = tabContent

tabBtn.MouseButton1Click:Connect(function()
    self:switchTab(name)
end)

end

function SmallGUI:switchTab(name) for tabName, frame in pairs(self.tabs) do frame.Visible = (tabName == name) end self.currentTab = name end

function SmallGUI:addButtonToTab(tab, label, color, callback) if not self.tabs[tab] then self:addTab(tab) end

local button = Instance.new("TextButton")
button.Size = UDim2.new(1, -10, 0, 30)
button.BackgroundColor3 = color or Color3.fromRGB(90,90,90)
button.Text = label
button.Font = Enum.Font.Gotham
button.TextSize = 14
button.TextColor3 = Color3.new(1,1,1)
button.Parent = self.tabs[tab]

Instance.new("UICorner", button).CornerRadius = UDim.new(0, 6)

button.MouseButton1Click:Connect(callback)

end

function SmallGUI:addToggleToTab(tab, label, color, default, callback) if not self.tabs[tab] then self:addTab(tab) end

local toggled = default or false
local toggle = Instance.new("TextButton")
toggle.Size = UDim2.new(1, -10, 0, 30)
toggle.BackgroundColor3 = color or Color3.fromRGB(80,80,80)
toggle.Text = label .. ": " .. (toggled and "ON" or "OFF")
toggle.Font = Enum.Font.Gotham
toggle.TextSize = 14
toggle.TextColor3 = Color3.new(1,1,1)
toggle.Parent = self.tabs[tab]

Instance.new("UICorner", toggle).CornerRadius = UDim.new(0, 6)

toggle.MouseButton1Click:Connect(function()
    toggled = not toggled
    toggle.Text = label .. ": " .. (toggled and "ON" or "OFF")
    if callback then callback(toggled) end
end)

end

return SmallGUI

