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

-- [[ IMAGE MAPPING ]]
local IMAGE_MAP = {
    [1] = {Id = "rbxassetid://115399776211075", Name = "Settings"},
    [2] = {Id = "rbxassetid://124076950797557", Name = "Clock"},
    [3] = {Id = "rbxassetid://115465739237343", Name = "GameList"},
}

-- [[ BLUR SETUP ]]
local ScreenBlur = Lighting:FindFirstChild("DexBlur") or Instance.new("BlurEffect")
ScreenBlur.Name = "DexBlur"
ScreenBlur.Size = 0
ScreenBlur.Parent = Lighting

-- [[ GUI INIT ]]
local sg = Instance.new("ScreenGui")
sg.Name = "LiquidOrb_Dex_Edition"
sg.IgnoreGuiInset = true
sg.Parent = (gethui and gethui()) or CoreGui

-- [[ GLOBAL SIZE VARIABLE ]]
local originalMainSize = UDim2.new(0, 380, 0, 185)

-- [[ MAIN CONTAINER ]]
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Parent = sg
Main.Size = UDim2.new(0, 0, 0, 0) 
Main.Position = UDim2.new(0.5, 0, 0.5, 0)
Main.AnchorPoint = Vector2.new(0.5, 0.5)
Main.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Main.Active = true 
Main.BackgroundTransparency = 1 
Main.Visible = true -- Ensure visible for the intro

local MainCorner = Instance.new("UICorner", Main)
MainCorner.CornerRadius = UDim.new(0, 16)

-- [[ NEW SETTINGS GUI ]]
local SettingsPanel = Instance.new("Frame")
SettingsPanel.Name = "SettingsPanel"
SettingsPanel.Parent = sg
SettingsPanel.BackgroundColor3 = Color3.fromRGB(12, 12, 15)
SettingsPanel.BorderSizePixel = 0
SettingsPanel.Size = UDim2.new(0, 450, 0, 300) 
SettingsPanel.AnchorPoint = Vector2.new(0.5, 0.5)
SettingsPanel.Position = UDim2.new(0.5, 0, 0.5, 0)
SettingsPanel.BackgroundTransparency = 1
SettingsPanel.Visible = false
SettingsPanel.ClipsDescendants = true

local SettingsCorner = Instance.new("UICorner", SettingsPanel)
SettingsCorner.CornerRadius = UDim.new(0, 24)

local SettingsLabel = Instance.new("TextLabel")
SettingsLabel.Name = "SettingsLabel"
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
SettingsClose.Name = "CloseSettings"
SettingsClose.Parent = SettingsPanel
SettingsClose.Size = UDim2.new(0, 40, 0, 40)
SettingsClose.Position = UDim2.new(1, -50, 0, 15)
SettingsClose.BackgroundTransparency = 1
SettingsClose.Text = "×"
SettingsClose.TextColor3 = Color3.fromRGB(200, 200, 200)
SettingsClose.TextSize = 35
SettingsClose.Font = Enum.Font.GothamLight

-- [[ EXTERNAL CLOCK POPOUT ]]
local ClockPopout = Instance.new("Frame")
ClockPopout.Name = "ClockPopout"
ClockPopout.Parent = sg
ClockPopout.BackgroundTransparency = 1 
ClockPopout.Size = UDim2.new(0, 300, 0, 80)
ClockPopout.AnchorPoint = Vector2.new(0.5, 0)
ClockPopout.Visible = false
ClockPopout.ZIndex = 5

local TimeLabel = Instance.new("TextLabel")
TimeLabel.Name = "TimeLabel"
TimeLabel.Parent = ClockPopout
TimeLabel.Size = UDim2.new(1, 0, 0, 45)
TimeLabel.Position = UDim2.new(0, 0, 0, 0)
TimeLabel.BackgroundTransparency = 1
TimeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TimeLabel.TextTransparency = 1 
TimeLabel.Font = Enum.Font.RobotoMono
TimeLabel.TextSize = 38
TimeLabel.Text = ""

local DateLabel = Instance.new("TextLabel")
DateLabel.Name = "DateLabel"
DateLabel.Parent = ClockPopout
DateLabel.Size = UDim2.new(1, 0, 0, 20)
DateLabel.Position = UDim2.new(0, 0, 0, 45)
DateLabel.BackgroundTransparency = 1
DateLabel.TextColor3 = Color3.fromRGB(180, 180, 185)
DateLabel.TextTransparency = 1 
DateLabel.Font = Enum.Font.GothamMedium
DateLabel.TextSize = 16

-- [[ SOUND SYSTEM ]]
local ClickSound = Instance.new("Sound")
ClickSound.Name = "DexClick"
ClickSound.SoundId = CLICK_ID
ClickSound.Volume = 0.8
ClickSound.Parent = Main

task.spawn(function()
    ContentProvider:PreloadAsync({ClickSound})
end)

local function PlayClick()
    local s = ClickSound:Clone()
    s.Parent = Main
    s:Play()
    s.Ended:Connect(function() s:Destroy() end)
    task.delay(2, function() if s then s:Destroy() end end)
end

-- [[ TOP BAR ]]
local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Parent = Main
TopBar.Size = UDim2.new(1, 0, 0, 44)
TopBar.BackgroundColor3 = Color3.fromRGB(8, 8, 10)
TopBar.BorderSizePixel = 0
TopBar.ZIndex = 20
TopBar.Visible = false 

local TopCorner = Instance.new("UICorner", TopBar)
TopCorner.CornerRadius = UDim.new(0, 16)

local Logo = Instance.new("ImageLabel")
Logo.Parent = Main
Logo.BackgroundTransparency = 1
Logo.Size = UDim2.new(0, 36, 0, 36)
Logo.Position = UDim2.new(0, 12, 0, 4) 
Logo.Image = ASSET_ID
Logo.ZIndex = 21
Logo.ImageTransparency = 1 

local Title = Instance.new("TextLabel")
Title.Name = "Title"
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

local Greeting = Instance.new("TextLabel")
Greeting.Name = "Greeting"
Greeting.Parent = TopBar
Greeting.Size = UDim2.new(0, 220, 0, 20)
Greeting.Position = UDim2.new(1, -265, 0, 6) 
Greeting.BackgroundTransparency = 1
Greeting.TextColor3 = Color3.fromRGB(180, 180, 185)
Greeting.TextSize = 13
Greeting.Font = Enum.Font.RobotoMono 
Greeting.TextXAlignment = Enum.TextXAlignment.Right
Greeting.ZIndex = 21
Greeting.TextTransparency = 1

local Close = Instance.new("TextButton")
Close.Name = "Close"
Close.Parent = TopBar
Close.Size = UDim2.new(0, 32, 0, 32)
Close.Position = UDim2.new(1, -40, 0.5, -16)
Close.BackgroundTransparency = 1
Close.Text = "×"
Close.TextColor3 = Color3.fromRGB(255, 255, 255)
Close.TextSize = 28
Close.ZIndex = 25

-- [[ CAROUSEL SYSTEM ]]
local Container = Instance.new("Frame")
Container.Name = "CarouselContainer"
Container.Parent = Main
Container.Size = UDim2.new(1, 0, 1, -44)
Container.Position = UDim2.new(0, 0, 0, 44)
Container.BackgroundTransparency = 1
Container.ClipsDescendants = true
Container.Visible = false

local Canvas = Instance.new("Frame")
Canvas.Name = "Canvas"
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

-- [[ TOGGLE LOGICS ]]
local clockOpen = false
local function ToggleClock()
    PlayClick()
    clockOpen = not clockOpen
    
    local info = TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    
    if clockOpen then
        ClockPopout.Visible = true
        TweenService:Create(TimeLabel, info, {TextTransparency = 0}):Play()
        TweenService:Create(DateLabel, info, {TextTransparency = 0}):Play()
    else
        local fadeOut = TweenService:Create(TimeLabel, info, {TextTransparency = 1})
        TweenService:Create(DateLabel, info, {TextTransparency = 1}):Play()
        fadeOut:Play()
        fadeOut.Completed:Connect(function()
            if not clockOpen then ClockPopout.Visible = false end
        end)
    end
end

local settingsOpen = false

local function ToggleSettings()
    PlayClick()
    settingsOpen = not settingsOpen
    
    local tvInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
    local panelInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    
    if settingsOpen then
        local squeezeH = TweenService:Create(Main, tvInfo, {Size = UDim2.new(0, 400, 0, 2)})
        local squeezeV = TweenService:Create(Main, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)})
        
        squeezeH:Play()
        squeezeH.Completed:Connect(function()
            squeezeV:Play()
            squeezeV.Completed:Connect(function()
                Main.Visible = false
                SettingsPanel.Visible = true
                SettingsPanel.Size = UDim2.new(0, 0, 0, 0)
                TweenService:Create(SettingsPanel, panelInfo, {Size = UDim2.new(0, 450, 0, 300), BackgroundTransparency = 0}):Play()
                TweenService:Create(SettingsLabel, panelInfo, {TextTransparency = 0}):Play()
                TweenService:Create(SettingsClose, panelInfo, {TextTransparency = 0}):Play()
            end)
        end)
    else
        local closePanel = TweenService:Create(SettingsPanel, tvInfo, {Size = UDim2.new(0, 450, 0, 0), BackgroundTransparency = 1})
        TweenService:Create(SettingsLabel, tvInfo, {TextTransparency = 1}):Play()
        TweenService:Create(SettingsClose, tvInfo, {TextTransparency = 1}):Play()
        
        closePanel:Play()
        closePanel.Completed:Connect(function()
            SettingsPanel.Visible = false
            Main.Visible = true
            Main.Size = UDim2.new(0, 0, 0, 0)
            
            local unsqueezeV = TweenService:Create(Main, tvInfo, {Size = UDim2.new(0, 400, 0, 2)})
            local unsqueezeH = TweenService:Create(Main, tvInfo, {Size = originalMainSize})
            
            unsqueezeV:Play()
            unsqueezeV.Completed:Connect(function()
                unsqueezeH:Play()
            end)
        end)
    end
end

SettingsClose.MouseButton1Click:Connect(ToggleSettings)

for i = 1, iconCount do
	local IconBase = Instance.new("ImageLabel")
	IconBase.Name = "Icon_"..i
	IconBase.Parent = Canvas
	IconBase.AnchorPoint = Vector2.new(0.5, 0.5)
	IconBase.BackgroundTransparency = 1
    IconBase.Image = IMAGE_MAP[i].Id
    IconBase.ScaleType = Enum.ScaleType.Fit
    
    local Glow = Instance.new("ImageLabel")
    Glow.Name = "Glow"
    Glow.Parent = IconBase
    Glow.Size = UDim2.new(1.4, 0, 1.4, 0)
    Glow.Position = UDim2.new(-0.2, 0, -0.2, 0)
    Glow.BackgroundTransparency = 1
    Glow.Image = "rbxassetid://5028857084"
    Glow.ImageColor3 = Color3.fromRGB(255, 255, 255)
    Glow.ImageTransparency = 1
    Glow.ZIndex = IconBase.ZIndex - 1

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

-- [[ NAVIGATION ]]
local function CreateNavButton(text, pos)
	local btn = Instance.new("TextButton")
	btn.Parent = Container
	btn.Size = UDim2.new(0, 100, 0, 100)
	btn.Position = pos
	btn.AnchorPoint = Vector2.new(0.5, 0.5)
	btn.BackgroundTransparency = 1
	btn.Text = "" 
	btn.ZIndex = 30
	return btn
end

local NavLeft = CreateNavButton("<", UDim2.new(0.2, 0, 0.5, 0))
local NavRight = CreateNavButton(">", UDim2.new(0.8, 0, 0.5, 0))
local NavMiddle = CreateNavButton("O", UDim2.new(0.5, 0, 0.5, 0))

NavLeft.MouseButton1Click:Connect(function()
    currentIndex = currentIndex - 1
    PlayClick()
end)

NavRight.MouseButton1Click:Connect(function()
    currentIndex = currentIndex + 1
    PlayClick()
end)

NavMiddle.MouseButton1Click:Connect(function()
    local realIndex = ((currentIndex - 1) % iconCount) + 1
    local action = IMAGE_MAP[realIndex].Name
    if action == "Clock" then
        ToggleClock()
    elseif action == "Settings" then
        ToggleSettings()
    end
end)

-- [[ UPDATE LOOPS ]]
local function UpdateClock()
    local date = os.date("*t") 
    local hour = date.hour % 12
    if hour == 0 then hour = 12 end
    local ampm = date.hour >= 12 and "PM" or "AM"
    
    TimeLabel.Text = string.format("%02d:%02d %s", hour, date.min, ampm)
    DateLabel.Text = os.date("%A, %B %d, %Y")
end

local function UpdateCarousel()
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
        icon.ImageColor3 = Color3.fromRGB(80, 80, 80):Lerp(Color3.fromRGB(255, 255, 255), selectFactor)
        icon.ImageTransparency = math.clamp(0.1 + (distance * 0.6), 0, 0.8)
        local label = icon:FindFirstChild("IconLabel")
        if label then
            label.TextTransparency = math.clamp(1 - selectFactor, 0, 1)
            label.TextColor3 = Color3.fromRGB(100, 100, 100):Lerp(Color3.fromRGB(255, 255, 255), selectFactor)
        end
	end
end

local function UpdateGreeting()
	local hour = tonumber(os.date("%H"))
	local name = LocalPlayer.DisplayName
	local str = (hour < 12 and "Good Morning") or (hour < 18 and "Good Afternoon") or "Good Evening"
	Greeting.Text = str .. ", " .. name .. "!"
end

RunService.RenderStepped:Connect(function()
	UpdateCarousel()
    UpdateClock()
	if TopBar.Visible then UpdateGreeting() end
    
    if ClockPopout.Visible or clockOpen then
        local targetY = Main.Position.Y.Offset + (Main.Size.Y.Offset / 2) + 50
        ClockPopout.Position = UDim2.new(Main.Position.X.Scale, Main.Position.X.Offset, Main.Position.Y.Scale, targetY)
    end
end)

-- [[ DRAGGING & MORPH ]]
local isMinimized = false
local iconSize = UDim2.new(0, 80, 0, 80)
local lastOrbPos = UDim2.new(0.5, 0, 0.5, 0)

local function Morph()
	isMinimized = not isMinimized
	if isMinimized then
        if clockOpen then ToggleClock() end
        if settingsOpen then ToggleSettings() end
        TweenService:Create(ScreenBlur, TweenInfo.new(0.6), {Size = 0}):Play()
		TweenService:Create(Main, TweenInfo.new(0.6, Enum.EasingStyle.Quart), {Size = iconSize, Position = lastOrbPos, BackgroundTransparency = 1}):Play()
        TweenService:Create(Logo, TweenInfo.new(0.6), {Position = UDim2.new(0, 0, 0, 0), Size = UDim2.new(1, 0, 1, 0)}):Play()
        TweenService:Create(Title, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
		TopBar.Visible, Container.Visible = false, false
	else
        TweenService:Create(ScreenBlur, TweenInfo.new(0.6), {Size = 20}):Play()
        lastOrbPos = Main.Position
		TopBar.Visible, Container.Visible = true, true
		TweenService:Create(Main, TweenInfo.new(0.7, Enum.EasingStyle.Back), {Size = originalMainSize, Position = UDim2.new(0.5, 0, 0.5, 0), BackgroundTransparency = 0}):Play()
        TweenService:Create(Logo, TweenInfo.new(0.5), {Position = UDim2.new(0, 12, 0, 4), Size = UDim2.new(0, 36, 0, 36)}):Play()
        TweenService:Create(Title, TweenInfo.new(0.5), {TextTransparency = 0}):Play()
	end
end

Close.MouseButton1Click:Connect(function()
    PlayClick()
    Morph()
end)

-- DRAGGING LOGIC
local dragging, dragStart, dragStartPos = false, nil, nil
local function SetupDrag(target)
	target.InputBegan:Connect(function(input)
		if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            local startTime = tick()
			dragging = true
			dragStart = input.Position
			dragStartPos = Main.Position
			local connection
			connection = UserInputService.InputEnded:Connect(function(endedInput)
				if endedInput.UserInputType == input.UserInputType then
					dragging = false
					connection:Disconnect()
                    if isMinimized and (tick() - startTime) < 0.2 and (endedInput.Position - dragStart).Magnitude < 5 then
                        Morph()
                    end
				end
			end)
		end
	end)
end
SetupDrag(TopBar)
SetupDrag(Main)

UserInputService.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local delta = input.Position - dragStart
		Main.Position = UDim2.new(dragStartPos.X.Scale, dragStartPos.X.Offset + delta.X, dragStartPos.Y.Scale, dragStartPos.Y.Offset + delta.Y)
		if isMinimized then lastOrbPos = Main.Position end
	end
end)

-- [[ INTRO ]]
local function ExecuteIntro()
	local Splash = Instance.new("ImageLabel", sg)
	Splash.Size, Splash.Position, Splash.AnchorPoint = UDim2.new(0, 110, 0, 110), UDim2.new(0.5, 0, 0.5, 0), Vector2.new(0.5, 0.5)
	Splash.BackgroundTransparency, Splash.Image, Splash.ImageTransparency = 1, ASSET_ID, 1
	Splash.ZIndex = 300
	
	TweenService:Create(Splash, TweenInfo.new(0.8), {ImageTransparency = 0}):Play()
	task.wait(1.4)
	TweenService:Create(Splash, TweenInfo.new(0.6, Enum.EasingStyle.Quart), {Size = UDim2.new(0,0,0,0), ImageTransparency = 1}):Play()
	task.wait(0.6)
	Splash:Destroy()
	
    Main.BackgroundTransparency, Logo.ImageTransparency = 0, 0
    Title.TextTransparency, Greeting.TextTransparency = 0, 0
	TopBar.Visible, Container.Visible = true, true
	TweenService:Create(Main, TweenInfo.new(1.1, Enum.EasingStyle.Exponential), {Size = originalMainSize}):Play()
    TweenService:Create(ScreenBlur, TweenInfo.new(1), {Size = 20}):Play()
end

task.spawn(ExecuteIntro)
