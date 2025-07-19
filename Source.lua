-- MiniUI.lua
-- discord: azxerman_alt
local MiniUI = {}
MiniUI.__index = MiniUI

function MiniUI:CreateWindow(config)
	self.RequireKey = config.RequireKey or false
self.Key = config.Key or "default-key"
self.GetKeyURL = config.GetKeyURL or "https://yourlink.com"
	local self = setmetatable({}, MiniUI)

	self.Title = config.Title or "MiniUi"
	self.Tabs = {}

	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "MiniUI"
	ScreenGui.ResetOnSpawn = false
	ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

	local MainFrame = Instance.new("Frame")
	MainFrame.Size = UDim2.new(0, 500, 0, 300)
	MainFrame.Position = UDim2.new(0.5, -250, 0.5, -150)
	MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	MainFrame.Parent = ScreenGui
	
	local UserInputService = game:GetService("UserInputService")

local dragging
local dragInput
local dragStart
local startPos

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)


	
	-- 🔐 Key Protection Panel

	if self.RequireKey then 
local KeyPanel = Instance.new("Frame")
KeyPanel.Size = UDim2.new(1, 0, 1, 0)
KeyPanel.Position = UDim2.new(0, 0, 0, 0)
KeyPanel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
KeyPanel.ZIndex = 10 -- Makes it appear above everything else
KeyPanel.Parent = MainFrame

local KeyBox = Instance.new("TextBox")
KeyBox.PlaceholderText = "Enter Key..."
KeyBox.Size = UDim2.new(0, 200, 0, 30)
KeyBox.Position = UDim2.new(0.5, -100, 0.5, -30)
KeyBox.TextColor3 = Color3.new(1, 1, 1)
KeyBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
KeyBox.Parent = KeyPanel

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = KeyBox

local Submit = Instance.new("TextButton")
Submit.Text = "Submit"
Submit.Size = UDim2.new(0, 100, 0, 30)
Submit.Position = UDim2.new(0.5, -50, 0.5, 10)
Submit.BackgroundColor3 = Color3.fromRGB(50, 100, 50)
Submit.TextColor3 = Color3.new(1,1,1)
Submit.Parent = KeyPanel

local corner2 = Instance.new("UICorner")
corner2.CornerRadius = UDim.new(0, 8)
corner2.Parent = Submit

	local getKeyBtn = Instance.new("TextButton")
getKeyBtn.Text = "Get Key"
getKeyBtn.Size = UDim2.new(0, 100, 0, 30)
getKeyBtn.Position = UDim2.new(0.5, -50, 0.5, 50)
getKeyBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 200)
getKeyBtn.Parent = KeyPanel

getKeyBtn.MouseButton1Click:Connect(function()
    local HttpService = game:GetService("HttpService")
    local url = self.GetKeyURL 
    local success, result = pcall(function()
        return HttpService:GetAsync(url)
    end)
    if success then
        KeyBox.Text = result
        Submit.Text = "Key Loaded! Submit now"
    else
        Submit.Text = "Failed to get key!"
        task.wait(2)
        Submit.Text = "Submit"
    end
end)



	local TitleLabel = Instance.new("TextLabel")
	TitleLabel.Size = UDim2.new(1, 0, 0, 30)
	TitleLabel.Text = self.Title
	TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	TitleLabel.BackgroundTransparency = 1
	TitleLabel.Parent = MainFrame
	
	-- Close Button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -30, 0, 0)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.Parent = MainFrame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeBtn

closeBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
end)

-- Minimize Button
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 30, 0, 30)
minimizeBtn.Position = UDim2.new(1, -60, 0, 0)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
minimizeBtn.Text = "_"
minimizeBtn.TextColor3 = Color3.new(1,1,1)
minimizeBtn.Parent = MainFrame

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(0, 6)
minCorner.Parent = minimizeBtn

minimizeBtn.MouseButton1Click:Connect(function()
    if MainFrame.Size.Y.Offset > 40 then
        MainFrame.Size = UDim2.new(MainFrame.Size.X.Scale, MainFrame.Size.X.Offset, 0, 40)
        ContentFrame.Visible = false
        TabList.Visible = false
    else
        MainFrame.Size = UDim2.new(MainFrame.Size.X.Scale, MainFrame.Size.X.Offset, 0, 300)
        ContentFrame.Visible = true
        TabList.Visible = true
    end
end)

	local TabList = Instance.new("Frame")
	TabList.Size = UDim2.new(0, 120, 1, -30)
	TabList.Position = UDim2.new(0, 0, 0, 30)
	TabList.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	TabList.Parent = MainFrame

	local ContentFrame = Instance.new("Frame")
	ContentFrame.Size = UDim2.new(1, -120, 1, -30)
	ContentFrame.Position = UDim2.new(0, 120, 0, 30)
	ContentFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
	ContentFrame.Parent = MainFrame

	self.Main = MainFrame
	self.TabList = TabList
	self.ContentFrame = ContentFrame
	self.ScreenGui = ScreenGui

	return self
end

function MiniUI:CreateTab(tabName)
	local tabButton = Instance.new("TextButton")
	tabButton.Size = UDim2.new(1, 0, 0, 30)
	tabButton.Text = tabName
	tabButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	tabButton.Parent = self.TabList
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = tabButton

	

	local tabContent = Instance.new("Frame")
	tabContent.Visible = false
	tabContent.Size = UDim2.new(1, 0, 1, 0)
	tabContent.BackgroundTransparency = 1
	tabContent.Parent = self.ContentFrame

		local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 5)
layout.Parent = tabContent

	tabButton.MouseButton1Click:Connect(function()
		for _, child in ipairs(self.ContentFrame:GetChildren()) do
			if child:IsA("Frame") then
				child.Visible = false
			end
		end
		tabContent.Visible = true
	end)

	local tab = {
		Name = tabName,
		Button = tabButton,
		Frame = tabContent,
		Elements = {}
	}

	table.insert(self.Tabs, tab)
	return tab
end

function MiniUI:CreateButton(tab, text, callback)
	local button = Instance.new("TextButton")
	button.Size = UDim2.new(0, 150, 0, 30)
	button.Text = text
	button.TextColor3 = Color3.fromRGB(255, 255, 255)
	button.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
	button.Parent = tab.Frame

	button.MouseButton1Click:Connect(callback)
	table.insert(tab.Elements, button)
end

function MiniUI:CreateToggle(tab, text, callback)
	local toggleState = false

	local toggle = Instance.new("TextButton")
	toggle.Size = UDim2.new(0, 150, 0, 30)
	toggle.Text = text .. ": OFF"
	toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
	toggle.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
	toggle.Parent = tab.Frame

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 8)
	corner.Parent = toggle

	toggle.MouseButton1Click:Connect(function()
		toggleState = not toggleState

		if toggleState then
			toggle.Text = text .. ": ON"
			toggle.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
		else
			toggle.Text = text .. ": OFF"
			toggle.BackgroundColor3 = Color3.fromRGB(100, 0, 0)
		end

		callback(toggleState) -- Send true/false to the function
	end)

	table.insert(tab.Elements, toggle)
	
	
end


return MiniUI
