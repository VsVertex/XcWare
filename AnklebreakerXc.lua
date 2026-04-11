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
frame.Size = UDim2.new(0, 250, 0, 580)   -- Increased height to fit the new toggle
frame.Position = UDim2.new(0.5, -125, 0.5, -290)
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

-- === EXISTING BUTTONS (unchanged) ===
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

-- LOOP TP Toggle (unchanged)
local loopEnabled = false
local loopTarget = nil
local originalCFrame = nil

local loopToggle = Instance.new("TextButton")
loopToggle.Size = UDim2.new(1, -20, 0, 36)   
loopToggle.Position = UDim2.new(0, 10, 1, -85)   -- Moved up a bit
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

-- === NEW: STEAL BOMB TOGGLE (at the very bottom) ===
local itemName = "Bomb"
local stealBombToggled = false
local savedCFrameBomb = nil
local strobeStateBomb = false

local stealBombToggle = Instance.new("TextButton")
stealBombToggle.Size = UDim2.new(1, -20, 0, 36)
stealBombToggle.Position = UDim2.new(0, 10, 1, -45)  -- Bottom position
stealBombToggle.Text = "STEAL BOMB: OFF"
stealBombToggle.Font = Enum.Font.GothamBold
stealBombToggle.TextSize = 14
stealBombToggle.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
stealBombToggle.TextColor3 = Color3.new(1, 1, 1)
stealBombToggle.Parent = frame
Instance.new("UICorner", stealBombToggle).CornerRadius = UDim.new(0, 4)

stealBombToggle.MouseButton1Click:Connect(function()
    stealBombToggled = not stealBombToggled
    stealBombToggle.Text = stealBombToggled and "STEAL BOMB: ON" or "STEAL BOMB: OFF"
    stealBombToggle.BackgroundColor3 = stealBombToggled and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
    
    if stealBombToggled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        savedCFrameBomb = LocalPlayer.Character.HumanoidRootPart.CFrame
    end
end)

-- LOGIC VARIABLES
local savedCFrame, spawnCFrame, speedEnabled, speedVal = nil, nil, false, 100
local activeStrobeTarget, strobeState = nil, true

-- BUTTON HANDLERS (unchanged)
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

-- Player Button (unchanged)
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

-- Original Heartbeat (unchanged)
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

-- === STEAL BOMB LOGIC (ARCEUS X OPTIMIZED) ===
RunService.RenderStepped:Connect(function()
    if not stealBombToggled or not savedCFrameBomb then return end
    
    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChild("Humanoid")
    if not root or not hum then return end

    hum.PlatformStand = false 

    local targetRoot = nil
    local iHaveIt = char:FindFirstChild(itemName) or (LocalPlayer.Backpack:FindFirstChild(itemName))

    for _, plr in pairs(Players:GetPlayers()) do
        if plr \~= LocalPlayer and plr.Character and plr.Character:FindFirstChild(itemName) then
            targetRoot = plr.Character:FindFirstChild("HumanoidRootPart")
            break
        end
    end

    if targetRoot then
        strobeStateBomb = not strobeStateBomb
        local offset = strobeStateBomb and 1.5 or -1.5 
        root.CFrame = targetRoot.CFrame * CFrame.new(0, 0, offset)
    elseif iHaveIt then
        root.CFrame = savedCFrameBomb
    else
        root.CFrame = savedCFrameBomb
    end
end)
