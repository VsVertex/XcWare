-- Wait for the game to load
if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

local targetParent = (gethui and gethui()) or game:GetService("CoreGui")

if targetParent:FindFirstChild("TeleportGui") then
    targetParent.TeleportGui:Destroy()
end

local sg = Instance.new("ScreenGui")
sg.Name = "TeleportGui"
sg.ResetOnSpawn = false
sg.Parent = targetParent

local frame = Instance.new("Frame")
frame.Name = "MainFrame"
frame.Size = UDim2.new(0, 250, 0, 490)  
frame.Position = UDim2.new(0.5, -125, 0.5, -245)
frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
frame.Active = true
frame.Draggable = true 
frame.Parent = sg

Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "ANKLEBREAKER BY XC"
title.Font = Enum.Font.GothamBold
title.TextSize = 14
title.TextColor3 = Color3.new(1, 1, 1)
title.BackgroundTransparency = 1
title.Parent = frame

local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -10, 1, -280)  
scroll.Position = UDim2.new(0, 5, 0, 45)
scroll.BackgroundTransparency = 1
scroll.ScrollBarThickness = 0
scroll.CanvasSize = UDim2.new(0, 0, 0, 0) 
scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y 
scroll.Parent = frame

local grid = Instance.new("UIGridLayout")
grid.Parent = scroll
grid.CellPadding = UDim2.new(0, 5, 0, 15)
grid.CellSize = UDim2.new(0, 75, 0, 90) 
grid.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- UI BUTTONS
local autoSaveEnabled = false
local autoSaveBtn = Instance.new("TextButton")
autoSaveBtn.Size = UDim2.new(1, -20, 0, 32)
autoSaveBtn.Position = UDim2.new(0, 10, 1, -205)
autoSaveBtn.Text = "AUTO SAVE: OFF"
autoSaveBtn.Font = Enum.Font.GothamBold
autoSaveBtn.TextSize = 13
autoSaveBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
autoSaveBtn.TextColor3 = Color3.new(1, 1, 1)
autoSaveBtn.Parent = frame
Instance.new("UICorner", autoSaveBtn).CornerRadius = UDim.new(0, 6)

local setBtn = Instance.new("TextButton")
setBtn.Size = UDim2.new(0.5, -12, 0, 32)
setBtn.Position = UDim2.new(0, 10, 1, -165)
setBtn.Text = "SET POS"
setBtn.Font = Enum.Font.GothamBold
setBtn.TextSize = 13
setBtn.BackgroundColor3 = Color3.fromRGB(40, 120, 40)
setBtn.TextColor3 = Color3.new(1, 1, 1)
setBtn.Parent = frame
Instance.new("UICorner", setBtn).CornerRadius = UDim.new(0, 6)

local tpBtn = Instance.new("TextButton")
tpBtn.Size = UDim2.new(0.5, -12, 0, 32)
tpBtn.Position = UDim2.new(0.5, 2, 1, -165)
tpBtn.Text = "TP POS"
tpBtn.Font = Enum.Font.GothamBold
tpBtn.TextSize = 13
tpBtn.BackgroundColor3 = Color3.fromRGB(40, 80, 150)
tpBtn.TextColor3 = Color3.new(1, 1, 1)
tpBtn.Parent = frame
Instance.new("UICorner", tpBtn).CornerRadius = UDim.new(0, 6)

local spawnBtn = Instance.new("TextButton")
spawnBtn.Size = UDim2.new(0.5, -12, 0, 32)
spawnBtn.Position = UDim2.new(0, 10, 1, -125)
spawnBtn.Text = "SET SPAWN"
spawnBtn.Font = Enum.Font.GothamBold
spawnBtn.TextSize = 13
spawnBtn.BackgroundColor3 = Color3.fromRGB(120, 40, 120)
spawnBtn.TextColor3 = Color3.new(1, 1, 1)
spawnBtn.Parent = frame
Instance.new("UICorner", spawnBtn).CornerRadius = UDim.new(0, 6)

local removeSpawnBtn = Instance.new("TextButton")
removeSpawnBtn.Size = UDim2.new(0.5, -12, 0, 32)
removeSpawnBtn.Position = UDim2.new(0.5, 2, 1, -125)
removeSpawnBtn.Text = "REMOVE SPAWN"
removeSpawnBtn.Font = Enum.Font.GothamBold
removeSpawnBtn.TextSize = 13
removeSpawnBtn.BackgroundColor3 = Color3.fromRGB(170, 40, 40)
removeSpawnBtn.TextColor3 = Color3.new(1, 1, 1)
removeSpawnBtn.Parent = frame
Instance.new("UICorner", removeSpawnBtn).CornerRadius = UDim.new(0, 6)

local speedToggle = Instance.new("TextButton")
speedToggle.Size = UDim2.new(0.5, -12, 0, 32)
speedToggle.Position = UDim2.new(0, 10, 1, -85)
speedToggle.Text = "SPEED: OFF"
speedToggle.Font = Enum.Font.GothamBold
speedToggle.TextSize = 13
speedToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
speedToggle.TextColor3 = Color3.new(1, 1, 1)
speedToggle.Parent = frame
Instance.new("UICorner", speedToggle).CornerRadius = UDim.new(0, 6)

local speedInput = Instance.new("TextBox")
speedInput.Size = UDim2.new(0.5, -12, 0, 32)
speedInput.Position = UDim2.new(0.5, 2, 1, -85)
speedInput.Text = "100"
speedInput.Font = Enum.Font.GothamBold
speedInput.TextSize = 13
speedInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
speedInput.TextColor3 = Color3.new(1, 1, 1)
speedInput.Parent = frame
Instance.new("UICorner", speedInput).CornerRadius = UDim.new(0, 6)

-- NEW: Loop TP Toggle (rectangle, flat, at the very bottom)
local loopEnabled = false
local loopTarget = nil
local originalCFrame = nil

local loopToggle = Instance.new("TextButton")
loopToggle.Size = UDim2.new(1, -20, 0, 36)   
loopToggle.Position = UDim2.new(0, 10, 1, -45)
loopToggle.Text = "LOOP TP: OFF"
loopToggle.Font = Enum.Font.GothamBold
loopToggle.TextSize = 14
loopToggle.BackgroundColor3 = Color3.fromRGB(50, 50
