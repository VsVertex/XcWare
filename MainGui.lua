-- [[ XCWARE: ALL-IN-ONE EXECUTOR ]]
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "XcWare_System"; ScreenGui.Parent = CoreGui; ScreenGui.ResetOnSpawn = false

-- [[ MAIN WINDOW ]]
local MainFrame = Instance.new("CanvasGroup")
MainFrame.Name = "MainFrame"; MainFrame.Parent = ScreenGui; MainFrame.BackgroundColor3 = Color3.new(0,0,0)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0); MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Size = UDim2.new(0, 0, 0, 0); MainFrame.GroupTransparency = 1; MainFrame.ClipsDescendants = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)

-- [[ TOP BAR ]]
local TopBar = Instance.new("Frame", MainFrame)
TopBar.Name = "TopBar"; TopBar.BackgroundTransparency = 1; TopBar.Size = UDim2.new(1, 0, 0, 60)

local Title = Instance.new("TextLabel", TopBar)
Title.Text = "XCWARE"; Title.TextColor3 = Color3.new(1,1,1); Title.Font = Enum.Font.GothamBold
Title.TextSize = 24; Title.BackgroundTransparency = 1; Title.Position = UDim2.new(0, 20, 0, 0); Title.Size = UDim2.new(0, 200, 1, 0); Title.TextXAlignment = Enum.TextXAlignment.Left

-- [[ THE EXECUTOR BOX ]]
local EditorFrame = Instance.new("ScrollingFrame", MainFrame)
EditorFrame.Position = UDim2.new(0, 15, 0, 70); EditorFrame.Size = UDim2.new(1, -30, 0, 230)
EditorFrame.BackgroundColor3 = Color3.fromRGB(5, 5, 5); EditorFrame.CanvasSize = UDim2.new(2, 0, 5, 0)
EditorFrame.ScrollBarThickness = 3; Instance.new("UICorner", EditorFrame)

local Editor = Instance.new("TextBox", EditorFrame)
Editor.Size = UDim2.new(1, 0, 1, 0); Editor.BackgroundTransparency = 1; Editor.MultiLine = true
Editor.Text = "print('Hello XcWare')"; Editor.TextColor3 = Color3.new(1,1,1); Editor.Font = Enum.Font.Code
Editor.TextSize = 14; Editor.TextXAlignment = 0; Editor.TextYAlignment = 0; Editor.ClearTextOnFocus = false

-- [[ BUTTONS: EXECUTE / CLEAR / PASTE ]]
local BtnHolder = Instance.new("Frame", MainFrame)
BtnHolder.Position = UDim2.new(0, 15, 0, 310); BtnHolder.Size = UDim2.new(1, -30, 0, 40); BtnHolder.BackgroundTransparency = 1
local Layout = Instance.new("UIListLayout", BtnHolder); Layout.FillDirection = 0; Layout.Padding = UDim.new(0, 10)

local function MakeBtn(name, color)
    local b = Instance.new("TextButton", BtnHolder)
    b.Size = UDim2.new(0, 100, 1, 0); b.BackgroundColor3 = Color3.new(0,0,0); b.Text = name
    b.TextColor3 = Color3.new(1,1,1); b.Font = Enum.Font.GothamBold; Instance.new("UICorner", b)
    local s = Instance.new("UIStroke", b); s.Color = color; s.Thickness = 1.5
    return b
end

local Exec = MakeBtn("EXECUTE", Color3.new(0,1,0))
local Clear = MakeBtn("CLEAR", Color3.new(1,1,1))
local Paste = MakeBtn("PASTE", Color3.new(1,1,1))

-- [[ LOGIC: EXECUTE ]]
Exec.MouseButton1Click:Connect(function()
    local success, err = pcall(function() loadstring(Editor.Text)() end)
    if not success then warn("Error: "..err) end
end)

Clear.MouseButton1Click:Connect(function() Editor.Text = "" end)

-- [[ DOCK / TASKBAR ]]
local MinimizedBar = Instance.new("TextButton", ScreenGui)
MinimizedBar.Visible = false; MinimizedBar.Size = UDim2.new(0, 220, 0, 45); MinimizedBar.Position = UDim2.new(0.5, 0, 1, -60)
MinimizedBar.AnchorPoint = Vector2.new(0.5, 0.5); MinimizedBar.BackgroundColor3 = Color3.new(0,0,0)
MinimizedBar.Text = "XCWARE"; MinimizedBar.TextColor3 = Color3.new(1,1,1); MinimizedBar.Font = Enum.Font.GothamBold
Instance.new("UICorner", MinimizedBar); Instance.new("UIStroke", MinimizedBar).Color = Color3.new(1,1,1)

-- [[ DRAGGABLE ]]
local function Drag(f, h)
    local d, i, s, p; h.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then d = true; s = input.Position; p = f.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then d = false end end)
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if d and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - s
            f.Position = UDim2.new(p.X.Scale, p.X.Offset + delta.X, p.Y.Scale, p.Y.Offset + delta.Y)
        end
    end)
end
Drag(MainFrame, TopBar)

-- [[ MINIMIZE / CLOSE SYSTEM ]]
local function Toggle(show, isMin)
    if show then
        MinimizedBar.Visible = false; MainFrame.Visible = true
        MainFrame:TweenSize(UDim2.new(0, 600, 0, 400), "Out", "Back", 0.5, true)
        TweenService:Create(MainFrame, TweenInfo.new(0.4), {GroupTransparency = 0}):Play()
    else
        if isMin then -- Minimize just hides the body
            MainFrame:TweenSize(UDim2.new(0, 600, 0, 60), "Out", "Quart", 0.4, true)
        else -- Close goes to bar
            MainFrame:TweenSize(UDim2.new(0, 0, 0, 0), "In", "Quart", 0.4, true)
            TweenService:Create(MainFrame, TweenInfo.new(0.4), {GroupTransparency = 1}):Play()
            task.wait(0.4); MainFrame.Visible = false; MinimizedBar.Visible = true
        end
    end
end

-- Close/Min Buttons
local X = Instance.new("TextButton", TopBar)
X.Text = "X"; X.Size = UDim2.new(0,30,0,30); X.Position = UDim2.new(1,-40,0,15); X.BackgroundColor3 = Color3.new(0,0,0)
Instance.new("UIStroke", X).Color = Color3.new(1,0,0); Instance.new("UICorner", X); X.TextColor3 = Color3.new(1,1,1)

local M = Instance.new("TextButton", TopBar)
M.Text = "-"; M.Size = UDim2.new(0,30,0,30); M.Position = UDim2.new(1,-80,0,15); M.BackgroundColor3 = Color3.new(0,0,0)
Instance.new("UIStroke", M).Color = Color3.new(1,1,1); Instance.new("UICorner", M); M.TextColor3 = Color3.new(1,1,1)

X.MouseButton1Click:Connect(function() Toggle(false, false) end)
M.MouseButton1Click:Connect(function() Toggle(false, true) end)
MinimizedBar.MouseButton1Click:Connect(function() Toggle(true) end)

-- Initial Open
task.wait(0.1); Toggle(true)
