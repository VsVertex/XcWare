local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local ContentProvider = game:GetService("ContentProvider")

local ASSET_ID = "rbxassetid://109413736577552" 
local CLICK_ID = "rbxassetid://6895079853" 
local LocalPlayer = Players.LocalPlayer

-- [[ GUI INIT ]]
local sg = Instance.new("ScreenGui")
sg.Name = "LiquidOrb_Dex_Edition"
sg.IgnoreGuiInset = true
sg.ResetOnSpawn = false
-- Improved Parent Logic
if gethui then
    sg.Parent = gethui()
elseif game:GetService("CoreGui"):FindFirstChild("RobloxGui") then
    sg.Parent = game:GetService("CoreGui").RobloxGui
else
    sg.Parent = CoreGui
end

-- [[ GLOBAL SIZE VARIABLE ]]
local originalMainSize = UDim2.new(0, 380, 0, 185)

-- [[ MAIN CONTAINER ]]
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Parent = sg
Main.Size = UDim2.new(0, 0, 0, 0) -- Starts at 0 for Intro
Main.Position = UDim2.new(0.5, 0, 0.5, 0)
Main.AnchorPoint = Vector2.new(0.5, 0.5)
Main.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Main.Active = true 
Main.BackgroundTransparency = 1 
Main.Visible = true

local MainCorner = Instance.new("UICorner", Main)
MainCorner.CornerRadius = UDim.new(0, 16)

-- [[ BLUR SETUP ]]
local ScreenBlur = Lighting:FindFirstChild("DexBlur") or Instance.new("BlurEffect")
ScreenBlur.Name = "DexBlur"
ScreenBlur.Size = 0
ScreenBlur.Parent = Lighting

-- [[ IMAGE MAPPING ]]
local IMAGE_MAP = {
    [1] = {Id = "rbxassetid://115399776211075", Name = "Settings"},
    [2] = {Id = "rbxassetid://124076950797557", Name = "Clock"},
    [3] = {Id = "rbxassetid://115465739237343", Name = "GameList"},
}

-- [[ NEW SETTINGS GUI ]]
local SettingsPanel = Instance.new("Frame")
SettingsPanel.Name = "SettingsPanel"
SettingsPanel.Parent = sg
SettingsPanel.BackgroundColor3 = Color3.fromRGB(12, 12, 15)
SettingsPanel.Size = UDim2.new(0, 450, 0, 300) 
SettingsPanel.AnchorPoint = Vector2.new(0.5, 0.5)
SettingsPanel.Position = UDim2.new(0.5, 0, 0.5, 0)
SettingsPanel.BackgroundTransparency = 1
SettingsPanel.Visible = false
SettingsPanel.ClipsDescendants = true

Instance.new("UICorner", SettingsPanel).CornerRadius = UDim.new(0, 24)

local SettingsLabel = Instance.new("TextLabel")
SettingsLabel.Parent = SettingsPanel
SettingsLabel.Size = UDim2.new(0, 200, 0, 50)
SettingsLabel.Position = UDim2.new(0, 25, 0, 15)
SettingsLabel.BackgroundTransparency = 1
SettingsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
SettingsLabel.TextTransparency = 1
SettingsLabel.Font = Enum.Font.GothamBold
SettingsLabel.TextSize = 28
SettingsLabel.Text = "Settings"
SettingsLabel.TextXAlignment = Enum.TextXAlignment.Left

local SettingsClose = Instance.new("TextButton")
SettingsClose.Parent = SettingsPanel
SettingsClose.Size = UDim2.new(0, 40, 0, 40)
SettingsClose.Position = UDim2.new(1, -50, 0, 15)
SettingsClose.BackgroundTransparency = 1
SettingsClose.Text = "×"
SettingsClose.TextColor3 = Color3.fromRGB(200, 200, 200)
SettingsClose.TextSize = 35
SettingsClose.Font = Enum.Font.GothamLight

-- [[ TOP BAR & LOGO ]]
local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Parent = Main
TopBar.Size = UDim2.new(1, 0, 0, 44)
TopBar.BackgroundColor3 = Color3.fromRGB(8, 8, 10)
TopBar.BorderSizePixel = 0
TopBar.ZIndex = 20
TopBar.Visible = false 

Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 16)

local Logo = Instance.new("ImageLabel")
Logo.Parent = Main
Logo.BackgroundTransparency = 1
Logo.Size = UDim2.new(0, 36, 0, 36)
Logo.Position = UDim2.new(0, 12, 0, 4) 
Logo.Image = ASSET_ID
Logo.ZIndex = 21
Logo.ImageTransparency = 1 

local Title = Instance.new("TextLabel")
Title.Parent = Main
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 54, 0, 4) 
Title.Size = UDim2.new(0, 100, 0, 36)
Title.Text = "Dex"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 22
Title.Font = Enum.Font.GothamBold
Title.ZIndex = 21
Title.TextTransparency = 1

-- [[ CAROUSEL CONTAINER ]]
local Container = Instance.new("Frame")
Container.Name = "CarouselContainer"
Container.Parent = Main
Container.Size = UDim2.new(1, 0, 1, -44)
Container.Position = UDim2.new(0, 0, 0, 44)
Container.BackgroundTransparency = 1
Container.ClipsDescendants = true
Container.Visible = false

local Canvas = Instance.new("Frame")
Canvas.Parent = Container
Canvas.Size = UDim2.new(1, 0, 1, 0)
Canvas.Position = UDim2.new(0.5, 0, 0, 0)
Canvas.AnchorPoint = Vector2.new(0.5, 0)
Canvas.BackgroundTransparency = 1

local icons = {}
local spacing = 110 
local iconCount = 3 
local visualIndex = 1 
local currentIndex = 1

-- Load Icons
for i = 1, iconCount do
	local IconBase = Instance.new("ImageLabel")
	IconBase.Parent = Canvas
	IconBase.AnchorPoint = Vector2.new(0.5, 0.5)
	IconBase.BackgroundTransparency = 1
    IconBase.Image = IMAGE_MAP[i].Id
    IconBase.ScaleType = Enum.ScaleType.Fit
    
    local Label = Instance.new("TextLabel")
    Label.Name = "IconLabel"
    Label.Parent = IconBase
    Label.Size = UDim2.new(2, 0, 0, 20)
    Label.Position = UDim2.new(0.5, 0, 1, 12) 
    Label.AnchorPoint = Vector2.new(0.5, 0)
    Label.BackgroundTransparency = 1
    Label.Text = IMAGE_MAP[i].Name
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.Font = Enum.Font.GothamMedium
    Label.TextSize = 14
    Label.TextTransparency = 1

	table.insert(icons, IconBase)
end

-- [[ DRAGGING LOGIC ]]
local dragging, dragStart, dragStartPos = false, nil, nil
TopBar.InputBegan:Connect(function(input)
    if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
        dragging = true
        dragStart = input.Position
        dragStartPos = Main.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        Main.Position = UDim2.new(dragStartPos.X.Scale, dragStartPos.X.Offset + delta.X, dragStartPos.Y.Scale, dragStartPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
        dragging = false
    end
end)

-- [[ UPDATE LOOP ]]
RunService.RenderStepped:Connect(function()
    if not Container.Visible then return end
    visualIndex = visualIndex + (currentIndex - visualIndex) * 0.15 
	for i, icon in ipairs(icons) do
        local offset = (i - visualIndex)
        local loopRange = iconCount
        offset = ((offset + loopRange/2) % loopRange) - loopRange/2
        local xPos = offset * spacing
		local distance = math.abs(offset)
		local scale = math.clamp(1.4 - (distance * 0.6), 0.7, 1.4)
        local selectFactor = math.clamp(1 - (distance * 1.5), 0, 1) 
        icon.Position = UDim2.new(0.5, xPos, 0.5, -12) 
		icon.Size = UDim2.new(0, 60 * scale, 0, 60 * scale)
        icon.ImageTransparency = math.clamp(0.1 + (distance * 0.6), 0, 0.8)
        local label = icon:FindFirstChild("IconLabel")
        if label then label.TextTransparency = math.clamp(1 - selectFactor, 0, 1) end
	end
end)

-- [[ EXECUTION / INTRO ]]
local function ExecuteIntro()
    -- Safety: Force visible if it hangs
    task.delay(5, function()
        if Main.Size.X.Offset < 10 then
            Main.Size = originalMainSize
            Main.BackgroundTransparency = 0
            TopBar.Visible = true
            Container.Visible = true
            Logo.ImageTransparency = 0
            Title.TextTransparency = 0
        end
    end)

	local Splash = Instance.new("ImageLabel", sg)
	Splash.Size = UDim2.new(0, 110, 0, 110)
    Splash.Position = UDim2.new(0.5, 0, 0.5, 0)
    Splash.AnchorPoint = Vector2.new(0.5, 0.5)
	Splash.BackgroundTransparency = 1
    Splash.Image = ASSET_ID
    Splash.ImageTransparency = 1
	Splash.ZIndex = 300
	
	TweenService:Create(Splash, TweenInfo.new(0.8), {ImageTransparency = 0}):Play()
	task.wait(1.2)
	TweenService:Create(Splash, TweenInfo.new(0.5), {Size = UDim2.new(0,0,0,0), ImageTransparency = 1}):Play()
	task.wait(0.5)
	Splash:Destroy()
	
    Main.BackgroundTransparency = 0
    Logo.ImageTransparency = 0
    Title.TextTransparency = 0
	TopBar.Visible = true
    Container.Visible = true
	TweenService:Create(Main, TweenInfo.new(1, Enum.EasingStyle.Exponential), {Size = originalMainSize}):Play()
    TweenService:Create(ScreenBlur, TweenInfo.new(1), {Size = 20}):Play()
end

task.spawn(ExecuteIntro)
 
