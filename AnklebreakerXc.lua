-- Anklebreaker by XC - Fixed for Arceus X Neo (GUI should show now)

if not game:IsLoaded() then game.Loaded:Wait() end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")

-- Stronger CoreGui placement for Arceus X Neo
local targetParent = gethui and gethui() or game:GetService("CoreGui")

if targetParent:FindFirstChild("TeleportGui") then
    targetParent.TeleportGui:Destroy()
end

local sg = Instance.new("ScreenGui")
sg.Name = "TeleportGui"
sg.ResetOnSpawn = false
sg.DisplayOrder = 9999  -- High priority so it shows on top
sg.Parent = targetParent

local frame = Instance.new("Frame")
frame.Name = "MainFrame"
frame.Size = UDim2.new(0, 250, 0, 530)
frame.Position = UDim2.new(0.5, -125, 0.5, -265)
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
scroll.Size = UDim2.new(1, -10, 1, -360)
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

-- All your original UI buttons (unchanged)
local autoSaveEnabled = false
local autoSaveBtn = Instance.new("TextButton")
autoSaveBtn.Size = UDim2.new(1, -20, 0, 32)
autoSaveBtn.Position = UDim2.new(0, 10, 1, -285)
autoSaveBtn.Text = "AUTO SAVE: OFF"
autoSaveBtn.Font = Enum.Font.GothamBold
autoSaveBtn.TextSize = 13
autoSaveBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
autoSaveBtn.TextColor3 = Color3.new(1, 1, 1)
autoSaveBtn.Parent = frame
Instance.new("UICorner", autoSaveBtn).CornerRadius = UDim.new(0, 6)

local setBtn = Instance.new("TextButton")
setBtn.Size = UDim2.new(0.5, -12, 0, 32)
setBtn.Position = UDim2.new(0, 10, 1, -245)
setBtn.Text = "SET POS"
setBtn.Font = Enum.Font.GothamBold
setBtn.TextSize = 13
setBtn.BackgroundColor3 = Color3.fromRGB(40, 120, 40)
setBtn.TextColor3 = Color3.new(1, 1, 1)
setBtn.Parent = frame
Instance.new("UICorner", setBtn).CornerRadius = UDim.new(0, 6)

local tpBtn = Instance.new("TextButton")
tpBtn.Size = UDim2.new(0.5, -12, 0, 32)
tpBtn.Position = UDim2.new(0.5, 2, 1, -245)
tpBtn.Text = "TP POS"
tpBtn.Font = Enum.Font.GothamBold
tpBtn.TextSize = 13
tpBtn.BackgroundColor3 = Color3.fromRGB(40, 80, 150)
tpBtn.TextColor3 = Color3.new(1, 1, 1)
tpBtn.Parent = frame
Instance.new("UICorner", tpBtn).CornerRadius = UDim.new(0, 6)

local spawnBtn = Instance.new("TextButton")
spawnBtn.Size = UDim2.new(0.5, -12, 0, 32)
spawnBtn.Position = UDim2.new(0, 10, 1, -205)
spawnBtn.Text = "SET SPAWN"
spawnBtn.Font = Enum.Font.GothamBold
spawnBtn.TextSize = 13
spawnBtn.BackgroundColor3 = Color3.fromRGB(120, 40, 120)
spawnBtn.TextColor3 = Color3.new(1, 1, 1)
spawnBtn.Parent = frame
Instance.new("UICorner", spawnBtn).CornerRadius = UDim.new(0, 6)

local removeSpawnBtn = Instance.new("TextButton")
removeSpawnBtn.Size = UDim2.new(0.5, -12, 0, 32)
removeSpawnBtn.Position = UDim2.new(0.5, 2, 1, -205)
removeSpawnBtn.Text = "REMOVE SPAWN"
removeSpawnBtn.Font = Enum.Font.GothamBold
removeSpawnBtn.TextSize = 13
removeSpawnBtn.BackgroundColor3 = Color3.fromRGB(170, 40, 40)
removeSpawnBtn.TextColor3 = Color3.new(1, 1, 1)
removeSpawnBtn.Parent = frame
Instance.new("UICorner", removeSpawnBtn).CornerRadius = UDim.new(0, 6)

local speedToggle = Instance.new("TextButton")
speedToggle.Size = UDim2.new(0.5, -12, 0, 32)
speedToggle.Position = UDim2.new(0, 10, 1, -165)
speedToggle.Text = "SPEED: OFF"
speedToggle.Font = Enum.Font.GothamBold
speedToggle.TextSize = 13
speedToggle.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
speedToggle.TextColor3 = Color3.new(1, 1, 1)
speedToggle.Parent = frame
Instance.new("UICorner", speedToggle).CornerRadius = UDim.new(0, 6)

local speedInput = Instance.new("TextBox")
speedInput.Size = UDim2.new(0.5, -12, 0, 32)
speedInput.Position = UDim2.new(0.5, 2, 1, -165)
speedInput.Text = "100"
speedInput.Font = Enum.Font.GothamBold
speedInput.TextSize = 13
speedInput.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
speedInput.TextColor3 = Color3.new(1, 1, 1)
speedInput.Parent = frame
Instance.new("UICorner", speedInput).CornerRadius = UDim.new(0, 6)

-- Bomb Stealer Button (at the bottom)
local bombStealBtn = Instance.new("TextButton")
bombStealBtn.Size = UDim2.new(1, -20, 0, 36)
bombStealBtn.Position = UDim2.new(0, 10, 1, -125)
bombStealBtn.Text = "STEAL BOMB"
bombStealBtn.Font = Enum.Font.GothamBold
bombStealBtn.TextSize = 14
bombStealBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
bombStealBtn.TextColor3 = Color3.new(1, 1, 1)
bombStealBtn.Parent = frame
Instance.new("UICorner", bombStealBtn).CornerRadius = UDim.new(0, 6)

-- Loop TP Toggle
local loopEnabled = false
local loopTarget = nil
local originalCFrame = nil

local loopToggle = Instance.new("TextButton")
loopToggle.Size = UDim2.new(1, -20, 0, 36)   
loopToggle.Position = UDim2.new(0, 10, 1, -85)
loopToggle.Text = "LOOP TP: OFF"
loopToggle.Font = Enum.Font.GothamBold
loopToggle.TextSize = 14
loopToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
loopToggle.TextColor3 = Color3.new(1, 1, 1)
loopToggle.Parent = frame
Instance.new("UICorner", loopToggle).CornerRadius = UDim.new(0, 4)

loopToggle.MouseButton1Click:Connect(function()
    loopEnabled = not loopEnabled
    loopToggle.Text = loopEnabled and "LOOP TP: ON" or "LOOP TP: OFF"
    loopToggle.BackgroundColor3 = loopEnabled and Color3.fromRGB(0, 170, 80) or Color3.fromRGB(50, 50, 50)
    
    if not loopEnabled then
        loopTarget = nil
        if originalCFrame and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = originalCFrame
        end
    end
end)

-- LOGIC VARIABLES
local savedCFrame, spawnCFrame, speedEnabled, speedVal = nil, nil, false, 100
local activeStrobeTarget, strobeState = nil, true

-- All your original button handlers (100% unchanged)
autoSaveBtn.MouseButton1Click:Connect(function()
    autoSaveEnabled = not autoSaveEnabled
    autoSaveBtn.Text = autoSaveEnabled and "AUTO SAVE: ON" or "AUTO SAVE: OFF"
    autoSaveBtn.BackgroundColor3 = autoSaveEnabled and Color3.fromRGB(200, 100, 0) or Color3.fromRGB(60, 60, 60)
end)

setBtn.MouseButton1Click:Connect(function()
    if not autoSaveEnabled and LocalPlayer.Character then
        savedCFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
        setBtn.Text = "SAVED!" task.wait(0.3) setBtn.Text = "SET POS"
    end
end)

tpBtn.MouseButton1Click:Connect(function()
    if savedCFrame and LocalPlayer.Character then LocalPlayer.Character.HumanoidRootPart.CFrame = savedCFrame end
end)

spawnBtn.MouseButton1Click:Connect(function()
    if LocalPlayer.Character then spawnCFrame = LocalPlayer.Character.HumanoidRootPart.CFrame 
    spawnBtn.Text = "SPAWN SET!" task.wait(0.5) spawnBtn.Text = "SET SPAWN" end
end)

removeSpawnBtn.MouseButton1Click:Connect(function()
    spawnCFrame = nil
    removeSpawnBtn.Text = "REMOVED!" task.wait(0.5) removeSpawnBtn.Text = "REMOVE SPAWN"
end)

LocalPlayer.CharacterAdded:Connect(function(char)
    if spawnCFrame then task.wait(0.05) char:WaitForChild("HumanoidRootPart").CFrame = spawnCFrame end
end)

speedToggle.MouseButton1Click:Connect(function()
    speedEnabled = not speedEnabled
    speedToggle.Text = speedEnabled and "SPEED: ON" or "SPEED: OFF"
end)

speedInput.FocusLost:Connect(function() speedVal = tonumber(speedInput.Text) or 16 end)

-- Bomb Stealer
bombStealBtn.MouseButton1Click:Connect(function()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    
    local root = char.HumanoidRootPart
    local originalPos = root.CFrame
    
    local bombHolder = nil
    for _, p in ipairs(Players:GetPlayers()) do
        if p \~= LocalPlayer and p.Character then
            if p.Backpack:FindFirstChild("Bomb") or p.Character:FindFirstChild("Bomb") then
                bombHolder = p
                break
            end
        end
    end
    
    if bombHolder and bombHolder.Character and bombHolder.Character:FindFirstChild("HumanoidRootPart") then
        root.CFrame = bombHolder.Character.HumanoidRootPart.CFrame * CFrame.new(0, 3, 0)
        task.wait(0.25)
        root.CFrame = originalPos
    end
end)

-- Player Button
local function createPlayerButton(p)
    if p == LocalPlayer then return end
    
    local container = Instance.new("Frame")
    container.Name = p.Name
    container.BackgroundTransparency = 1
    container.Parent = scroll

    local btn = Instance.new("ImageButton")
    btn.Size = UDim2.new(0, 65, 0, 65)
    btn.Position = UDim2.new(0.5, -32, 0, 0)
    btn.Image = Players:GetUserThumbnailAsync(p.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.Parent = container
    Instance.new("UICorner", btn).CornerRadius = UDim.new(1, 0)

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 0, 20)
    nameLabel.Position = UDim2.new(0, 0, 0, 68)
    nameLabel.Text = p.DisplayName:sub(1,10)
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = 10
    nameLabel.TextColor3 = Color3.new(1, 1, 1)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Parent = container

    btn.MouseButton1Click:Connect(function()
        if loopEnabled then
            loopTarget = p
            if LocalPlayer.Character then
                originalCFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
            end
        else
            if LocalPlayer.Character then
                local pre = savedCFrame or LocalPlayer.Character.HumanoidRootPart.CFrame
                activeStrobeTarget = p
                task.wait(0.08)
                activeStrobeTarget = nil
                LocalPlayer.Character.HumanoidRootPart.CFrame = pre
            end
        end
    end)
end

local function fullRefresh()
    for _, child in pairs(scroll:GetChildren()) do if child:IsA("Frame") then child:Destroy() end end
    for _, p in pairs(Players:GetPlayers()) do createPlayerButton(p) end
end

Players.PlayerAdded:Connect(createPlayerButton)
Players.PlayerRemoving:Connect(function(p) if scroll:FindFirstChild(p.Name) then scroll[p.Name]:Destroy() end end)
fullRefresh()

-- Main Loop TP Logic
RunService.Heartbeat:Connect(function()
    if loopEnabled and loopTarget and loopTarget.Character and loopTarget.Character:FindFirstChild("HumanoidRootPart") then
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = loopTarget.Character.HumanoidRootPart.CFrame * CFrame.new(0, 3, 0)
        end
    end
end)

-- Original Heartbeat
RunService.Heartbeat:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        if autoSaveEnabled and not activeStrobeTarget then savedCFrame = LocalPlayer.Character.HumanoidRootPart.CFrame end
        if speedEnabled and LocalPlayer.Character:FindFirstChild("Humanoid") then LocalPlayer.Character.Humanoid.WalkSpeed = speedVal end
        if activeStrobeTarget and activeStrobeTarget.Character and activeStrobeTarget.Character:FindFirstChild("HumanoidRootPart") then
            strobeState = not strobeState
            LocalPlayer.Character.HumanoidRootPart.CFrame = activeStrobeTarget.Character.HumanoidRootPart.CFrame * (strobeState and CFrame.new(0, 0, 3) or CFrame.new(0, 0, -3))
        end
    end
end)

print("✅ Anklebreaker GUI loaded - If you don't see it, try restarting Arceus X Neo") 
