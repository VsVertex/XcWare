-- [[ XCWARE: MAIN GUI COMPONENT ]]
-- Themes: Pitch Black, Sleek UI
-- Features: Split Logic (Minimize vs Close), Black Buttons, Ultra-Smooth Easing

local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

-- Creating the ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "XcWare_System"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false 
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- [[ MAIN CONTAINER (600x400) ]]
local MainFrame = Instance.new("CanvasGroup")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0) 
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Size = UDim2.new(0, 0, 0, 0) 
MainFrame.GroupTransparency = 1 
MainFrame.ClipsDescendants = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)

-- [[ FEATURE CONTAINER ]]
local Container = Instance.new("ScrollingFrame")
Container.Name = "Container"
Container.Parent = MainFrame
Container.BackgroundTransparency = 1
Container.BorderSizePixel = 0
Container.Position = UDim2.new(0, 10, 0, 70) -- Starts below the TopBar
Container.Size = UDim2.new(1, -20, 1, -80)
Container.ScrollBarThickness = 2
Container.CanvasSize = UDim2.new(0, 0, 0, 0)

local Layout = Instance.new("UIListLayout", Container)
Layout.Padding = UDim.new(0, 8)
Layout.SortOrder = Enum.SortOrder.LayoutOrder

-- Auto-resize scroll area
Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    Container.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y)
end)


-- [[ TOP BAR (The Draggable Handle) ]]
local TopBar = Instance.new("Frame")
TopBar.Name = "TopBar"
TopBar.Parent = MainFrame
TopBar.BackgroundTransparency = 1 
TopBar.Size = UDim2.new(1, 0, 0, 60)

local Title = Instance.new("TextLabel")
Title.Parent = TopBar
Title.Text = "XCWARE"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 24
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 20, 0, 0)
Title.Size = UDim2.new(0, 250, 1, 0)
Title.TextXAlignment = Enum.TextXAlignment.Left

-- [[ DOCK / TASKBAR (For Close Function) ]]
local MinimizedBar = Instance.new("TextButton")
MinimizedBar.Name = "MinimizedBar"
MinimizedBar.Parent = ScreenGui
MinimizedBar.Visible = false
MinimizedBar.Size = UDim2.new(0, 220, 0, 45)
MinimizedBar.Position = UDim2.new(0.5, 0, 1, -60)
MinimizedBar.AnchorPoint = Vector2.new(0.5, 0.5)
MinimizedBar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MinimizedBar.AutoButtonColor = false
MinimizedBar.Text = ""
Instance.new("UICorner", MinimizedBar).CornerRadius = UDim.new(0, 12)
local BarStroke = Instance.new("UIStroke", MinimizedBar)
BarStroke.Color = Color3.fromRGB(255, 255, 255)
BarStroke.Thickness = 1.5

local BarLabel = Instance.new("TextLabel", MinimizedBar)
BarLabel.Size = UDim2.new(1, 0, 1, 0)
BarLabel.BackgroundTransparency = 1
BarLabel.Text = "XCWARE"
BarLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
BarLabel.Font = Enum.Font.GothamBold
BarLabel.TextSize = 18

-- [[ MATRIX ANIMATION ]]
local function MatrixAnim(label, originalText)
    local chars = "1234567890!@#$%^&*"
    while true do
        task.wait(math.random(3, 5))
        for i = 1, 10 do
            local randomStr = ""
            for j = 1, #originalText do
                local r = math.random(1, #chars)
                randomStr = randomStr .. string.sub(chars, r, r)
            end
            label.Text = randomStr
            task.wait(0.05)
        end
        label.Text = originalText
    end
end
task.spawn(function() MatrixAnim(Title, "XCWARE") end)
task.spawn(function() MatrixAnim(BarLabel, "XCWARE") end)

-- [[ IMPROVED DRAGGABLE ]]
local function MakeDraggable(frame, handle)
    local dragging, dragInput, dragStart, startPos
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end
MakeDraggable(MainFrame, TopBar)

-- [[ PITCH BLACK BUTTONS ]]
local function StyleButton(btn, text, pos)
    btn.Parent = TopBar
    btn.Text = text
    btn.TextColor3 = Color3.new(1,1,1)
    btn.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- PITCH BLACK
    btn.Size = UDim2.new(0, 32, 0, 32)
    btn.Position = pos
    btn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    local stroke = Instance.new("UIStroke", btn)
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.Thickness = 1
    return btn
end

local CloseBtn = Instance.new("TextButton")
StyleButton(CloseBtn, "X", UDim2.new(1, -45, 0, 14))

local MiniBtn = Instance.new("TextButton")
StyleButton(MiniBtn, "-", UDim2.new(1, -85, 0, 14))

-- [[ SPLIT TOGGLE LOGIC ]]
local isMinimized = false

local function OpenFromTaskbar()
    MinimizedBar:TweenSize(UDim2.new(0, 0, 0, 45), "Out", "Quart", 0.3, true)
    task.wait(0.2)
    MinimizedBar.Visible = false
    MainFrame.Visible = true
    MainFrame:TweenSize(UDim2.new(0, 600, 0, 400), "Out", "Back", 0.5, true)
    TweenService:Create(MainFrame, TweenInfo.new(0.4), {GroupTransparency = 0}):Play()
    isMinimized = false
end

local function CloseLogic()
    MainFrame:TweenSize(UDim2.new(0, 0, 0, 0), "In", "Quart", 0.4, true)
    TweenService:Create(MainFrame, TweenInfo.new(0.4), {GroupTransparency = 1}):Play()
    task.wait(0.4)
    MainFrame.Visible = false
    MinimizedBar.Visible = true
    MinimizedBar.Size = UDim2.new(0, 0, 0, 45)
    MinimizedBar:TweenSize(UDim2.new(0, 220, 0, 45), "Out", "Back", 0.5, true)
end

local function MinimizeLogic()
    if not isMinimized then
        -- Shrink to just the TopBar
        MainFrame:TweenSize(UDim2.new(0, 600, 0, 60), "Out", "Quart", 0.4, true)
        isMinimized = true
    else
        -- Expand back to full
        MainFrame:TweenSize(UDim2.new(0, 600, 0, 400), "Out", "Back", 0.4, true)
        isMinimized = false
    end
end

-- [[ CONNECTIONS ]]
CloseBtn.MouseButton1Click:Connect(CloseLogic)
MiniBtn.MouseButton1Click:Connect(MinimizeLogic)
MinimizedBar.MouseButton1Click:Connect(OpenFromTaskbar)

-- Startup
task.wait(0.1)
MainFrame.Visible = true
MainFrame:TweenSize(UDim2.new(0, 600, 0, 400), "Out", "Back", 0.5, true)
TweenService:Create(MainFrame, TweenInfo.new(0.4), {GroupTransparency = 0}):Play()

print("XcWare: Split Minimize/Close System Loaded")
