task.spawn(function()
-- =================================================================================
-- [ SYSTEM REMINDER: DETAILED HUD + CHAT LOG + SERVER MONITORING ]
-- [ FIXED: MOBILE SLIDER + FULL INFO RESTORED + MINIMIZE CLIPPING ]
-- [ UPDATE: PROXIMITY CRITICAL 4 STUDS | GENDER REMOVED ]
-- =================================================================================

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- [[ CONFIG ]]
local Settings = {
    Enabled = false,
    FOVSize = 150,
    ProxDistance = 4, 
}

-- [[ UI INITIALIZATION ]]
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "XcWare_Ultimate_Red"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false
ScreenGui.DisplayOrder = -1 

-- [[ MONITORING GUI ]]
local MonitorLabel = Instance.new("TextLabel")
MonitorLabel.Size = UDim2.new(0, 200, 0, 25); MonitorLabel.Position = UDim2.new(1, -210, 1, -30)
MonitorLabel.BackgroundTransparency = 1; MonitorLabel.Text = "● [Whole Server Is being monitored]"
MonitorLabel.TextColor3 = Color3.fromRGB(255, 0, 0); MonitorLabel.Font = Enum.Font.Code
MonitorLabel.TextSize = 12; MonitorLabel.TextXAlignment = Enum.TextXAlignment.Right; MonitorLabel.Parent = ScreenGui

-- [[ FLYING NOTIFICATION ]]
local FlyNotify = Instance.new("TextLabel")
FlyNotify.Size = UDim2.new(0, 400, 0, 50); FlyNotify.Position = UDim2.new(0.5, -200, 0.2, 0)
FlyNotify.BackgroundTransparency = 1; FlyNotify.Text = ""; FlyNotify.TextColor3 = Color3.fromRGB(255, 0, 0)
FlyNotify.Font = Enum.Font.GothamBold; FlyNotify.TextSize = 20; FlyNotify.Visible = false; FlyNotify.Parent = ScreenGui

-- [[ CROSSHAIR & FOV ]]
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 0.5; FOVCircle.Color = Color3.fromRGB(255, 0, 0); FOVCircle.Transparency = 1; FOVCircle.Visible = false

local function CreateLine()
    local l = Drawing.new("Line")
    l.Thickness = 1.5; l.Color = Color3.fromRGB(255, 0, 0); l.Visible = true; return l
end
local L1, L2, L3, L4 = CreateLine(), CreateLine(), CreateLine(), CreateLine()

-- [[ MONITORING STORAGE ]]
local PlayerESP = {}
local ViolationData = {} 
local ViolationReasons = {}

local function CreateESP(player)
    local circle = Drawing.new("Circle")
    circle.Visible = false; circle.Radius = 4; circle.Thickness = 2; circle.Filled = true
    PlayerESP[player] = circle
    ViolationData[player] = 0; ViolationReasons[player] = {}
end

local function RemoveESP(player)
    if PlayerESP[player] then PlayerESP[player]:Remove(); PlayerESP[player] = nil end
    ViolationData[player] = nil; ViolationReasons[player] = nil
end

local function AddReason(player, reason)
    if not ViolationReasons[player] then ViolationReasons[player] = {} end
    local alreadyHas = false
    for _, r in pairs(ViolationReasons[player]) do if r == reason then alreadyHas = true end end
    if not alreadyHas then table.insert(ViolationReasons[player], reason) end
end

-- [[ DRAGGING ]]
local function EnableDragging(gui)
    local dragging, dragInput, dragStart, startPos
    gui.InputBegan:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
            dragging = true; dragStart = input.Position; startPos = gui.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    gui.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- [[ MAIN CONTROL WINDOW ]]
local ControlFrame = Instance.new("Frame")
ControlFrame.Size = UDim2.new(0, 240, 0, 180); ControlFrame.Position = UDim2.new(0.05, 0, 0.4, 0)
ControlFrame.BackgroundColor3 = Color3.fromRGB(10, 0, 0); ControlFrame.Active = true; ControlFrame.ClipsDescendants = true; ControlFrame.Parent = ScreenGui
Instance.new("UICorner", ControlFrame)

local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 35); Header.BackgroundColor3 = Color3.fromRGB(40, 0, 0); Header.Parent = ControlFrame
Instance.new("UICorner", Header)

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 1, 0); Title.BackgroundTransparency = 1; Title.Text = "Info Lock aim by XcWare"
Title.TextColor3 = Color3.fromRGB(255, 0, 0); Title.Font = Enum.Font.GothamBold; Title.TextSize = 14; Title.Parent = Header

local MainMin = Instance.new("TextButton")
MainMin.Size = UDim2.new(0, 30, 0, 30); MainMin.Position = UDim2.new(1, -35, 0, 2)
MainMin.BackgroundColor3 = Color3.fromRGB(60, 0, 0); MainMin.Text = "-"; MainMin.TextColor3 = Color3.fromRGB(255, 255, 255); MainMin.Parent = Header
Instance.new("UICorner", MainMin)

local ContentContainer = Instance.new("Frame")
ContentContainer.Size = UDim2.new(1, 0, 1, -35); ContentContainer.Position = UDim2.new(0, 0, 0, 35)
ContentContainer.BackgroundTransparency = 1; ContentContainer.Parent = ControlFrame

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(0, 220, 0, 45); ToggleBtn.Position = UDim2.new(0, 10, 0, 10)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(20, 0, 0); ToggleBtn.Text = "LOCK: OFF"; ToggleBtn.TextColor3 = Color3.fromRGB(255, 0, 0); ToggleBtn.Parent = ContentContainer
Instance.new("UICorner", ToggleBtn)

local SliderBack = Instance.new("Frame")
SliderBack.Size = UDim2.new(0, 220, 0, 60); SliderBack.Position = UDim2.new(0, 10, 0, 65); SliderBack.BackgroundTransparency = 1; SliderBack.Parent = ContentContainer

local SliderLabel = Instance.new("TextLabel")
SliderLabel.Size = UDim2.new(1, 0, 0, 20); SliderLabel.BackgroundTransparency = 1; SliderLabel.Text = "FOV SIZE: 150"; SliderLabel.TextColor3 = Color3.fromRGB(255, 0, 0); SliderLabel.Parent = SliderBack

local Bar = Instance.new("TextButton")
Bar.Size = UDim2.new(1, 0, 0, 10); Bar.Position = UDim2.new(0, 0, 0, 30); Bar.BackgroundColor3 = Color3.fromRGB(40, 0, 0); Bar.Text = ""; Bar.Parent = SliderBack
Instance.new("UICorner", Bar)

local Knocker = Instance.new("Frame")
Knocker.Size = UDim2.new(0, 35, 0, 35); Knocker.Position = UDim2.new(0.3, -17, 0.5, -17); Knocker.BackgroundColor3 = Color3.fromRGB(255, 0, 0); Knocker.Parent = Bar
Instance.new("UICorner", Knocker)

-- [[ PLAYER INFO OVERLAY ]]
local InfoContainer = Instance.new("Frame")
InfoContainer.Size = UDim2.new(0, 340, 0, 500); InfoContainer.Position = UDim2.new(0.02, 0, 0.1, 0)
InfoContainer.BackgroundTransparency = 1; InfoContainer.Visible = false; InfoContainer.Parent = ScreenGui

local AvatarPic = Instance.new("ImageLabel")
AvatarPic.Size = UDim2.new(0, 90, 0, 90); AvatarPic.BackgroundColor3 = Color3.fromRGB(20, 0, 0); AvatarPic.BorderSizePixel = 2; AvatarPic.BorderColor3 = Color3.fromRGB(255, 0, 0); AvatarPic.Parent = InfoContainer
Instance.new("UICorner", AvatarPic)

local InfoLabel = Instance.new("TextLabel")
InfoLabel.Size = UDim2.new(1, 0, 0, 350); InfoLabel.Position = UDim2.new(0, 0, 0, 100)
InfoLabel.BackgroundTransparency = 1; InfoLabel.TextColor3 = Color3.fromRGB(255, 0, 0); InfoLabel.Font = Enum.Font.Code; InfoLabel.TextSize = 13
InfoLabel.TextXAlignment = Enum.TextXAlignment.Left; InfoLabel.TextYAlignment = Enum.TextYAlignment.Top; InfoLabel.RichText = true; InfoLabel.Parent = InfoContainer

-- [[ CHAT LOG WINDOW ]]
local ChatMaster = Instance.new("Frame")
ChatMaster.Size = UDim2.new(0, 280, 0, 300); ChatMaster.Position = UDim2.new(0.7, 0, 0.1, 0)
ChatMaster.BackgroundColor3 = Color3.fromRGB(0, 0, 0); ChatMaster.BackgroundTransparency = 0.6; ChatMaster.Active = true; ChatMaster.Visible = false; ChatMaster.Parent = ScreenGui
Instance.new("UICorner", ChatMaster)

local ChatHeader = Instance.new("Frame")
ChatHeader.Size = UDim2.new(1, 0, 0, 30); ChatHeader.BackgroundColor3 = Color3.fromRGB(40, 0, 0); ChatHeader.Parent = ChatMaster
Instance.new("UICorner", ChatHeader)

local ChatTitleLabel = Instance.new("TextLabel")
ChatTitleLabel.Size = UDim2.new(1, -40, 1, 0); ChatTitleLabel.Position = UDim2.new(0, 10, 0, 0); ChatTitleLabel.BackgroundTransparency = 1; ChatTitleLabel.Text = "Chat logs"; ChatTitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255); ChatTitleLabel.Font = Enum.Font.Code; ChatTitleLabel.Parent = ChatHeader

local ChatMinBtn = Instance.new("TextButton")
ChatMinBtn.Size = UDim2.new(0, 25, 0, 25); ChatMinBtn.Position = UDim2.new(1, -30, 0, 2.5); ChatMinBtn.BackgroundColor3 = Color3.fromRGB(60, 0, 0); ChatMinBtn.Text = "-"; ChatMinBtn.Parent = ChatHeader
Instance.new("UICorner", ChatMinBtn)

local ChatLogFrame = Instance.new("ScrollingFrame")
ChatLogFrame.Size = UDim2.new(1, -10, 1, -40); ChatLogFrame.Position = UDim2.new(0, 5, 0, 35); ChatLogFrame.BackgroundTransparency = 1; ChatLogFrame.ScrollBarThickness = 2; ChatLogFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y; ChatLogFrame.Parent = ChatMaster
local ChatListLayout = Instance.new("UIListLayout")
ChatListLayout.Parent = ChatLogFrame; ChatListLayout.Padding = UDim.new(0, 2); ChatListLayout.SortOrder = Enum.SortOrder.LayoutOrder

local LockESP = Instance.new("Highlight")
LockESP.FillTransparency = 1; LockESP.OutlineColor = Color3.fromRGB(255, 0, 0); LockESP.Parent = CoreGui

-- [[ LOGIC ]]
local currentTarget = nil
local isProximityTarget = false
local playerChatHistory = {} 
local metaData = { LastChat = "None", JoinTime = 0 }
local ang1, ang2 = 0, 0

local function GetTarget()
    local target = nil
    local maxDist = Settings.FOVSize
    local closestProx = Settings.ProxDistance
    local proxTarget = nil
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return nil end

    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChildOfClass("Humanoid") and v.Character.Humanoid.Health > 0 then
            local worldDist = (LocalPlayer.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude
            if worldDist < closestProx then
                proxTarget = v; closestProx = worldDist
            end
            local pos, onScreen = Camera:WorldToViewportPoint(v.Character.HumanoidRootPart.Position)
            if onScreen then
                local mag = (Vector2.new(pos.X, pos.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                if mag < maxDist then target = v; maxDist = mag end
            end
        end
    end
    if proxTarget then isProximityTarget = true; return proxTarget else isProximityTarget = false; return target end
end

local function UpdateChatUI(player)
    for _, child in pairs(ChatLogFrame:GetChildren()) do if child:IsA("TextLabel") then child:Destroy() end end
    ChatTitleLabel.Text = player.DisplayName .. " chat logs"
    local history = playerChatHistory[player.UserId] or {}
    for i, msg in ipairs(history) do
        local nl = Instance.new("TextLabel")
        nl.Size = UDim2.new(1, -5, 0, 18); nl.BackgroundTransparency = 1; nl.TextColor3 = Color3.fromRGB(255, 255, 255); nl.Font = Enum.Font.Code; nl.TextSize = 11; nl.TextXAlignment = Enum.TextXAlignment.Left; nl.Text = "> " .. msg; nl.TextWrapped = true; nl.LayoutOrder = i; nl.Parent = ChatLogFrame
    end
    ChatLogFrame.CanvasPosition = Vector2.new(0, 99999)
end

-- [[ VIOLATION CHECK ]]
local function CheckForViolations()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChildOfClass("Humanoid") then
            local hum = p.Character.Humanoid
            local root = p.Character.HumanoidRootPart
            local currentVel = root.AssemblyLinearVelocity
            local horizontalVel = Vector3.new(currentVel.X, 0, currentVel.Z).Magnitude
            if hum:GetState() == Enum.HumanoidStateType.Freefall and math.abs(currentVel.Y) < 5 and root.Position.Y > 20 then
                ViolationData[p] = (ViolationData[p] or 0) + 1; AddReason(p, "FLYING"); return p 
            end
            if horizontalVel > 38 then ViolationData[p] = (ViolationData[p] or 0) + 1; AddReason(p, "SPEED") end
            if currentVel.Y > 95 then ViolationData[p] = (ViolationData[p] or 0) + 1; AddReason(p, "JUMP") end
        end
    end
    return nil
end

RunService.RenderStepped:Connect(function()
    local Center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    ang1, ang2 = ang1 + 0.04, ang2 - 0.06
    local function UpdateCross(line, angle, dist, len)
        line.From = Center + Vector2.new(math.cos(angle), math.sin(angle)) * dist
        line.To = Center + Vector2.new(math.cos(angle), math.sin(angle)) * (dist + len)
    end
    UpdateCross(L1, ang1, 8, 12); UpdateCross(L2, ang1 + math.pi, 8, 12); UpdateCross(L3, ang2, 4, 10); UpdateCross(L4, ang2 + math.pi, 4, 10)
    FOVCircle.Position = Center; FOVCircle.Radius = Settings.FOVSize; FOVCircle.Visible = Settings.Enabled

    local violator = CheckForViolations()
    if violator then FlyNotify.Visible = true; FlyNotify.Text = "ALERT: (" .. violator.DisplayName .. ") IS EXPLOITING"; FlyNotify.TextTransparency = (math.sin(tick() * 10) + 1) / 2
    else FlyNotify.Visible = false end

    if Settings.Enabled then
        local target = GetTarget()
        if target and target.Character and target.Character:FindFirstChild("Head") then
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Character.Head.Position)
            if target ~= currentTarget then
                currentTarget = target; metaData.JoinTime = tick()
                AvatarPic.Image = "https://www.roblox.com/headshot-thumbnail/image?userId="..target.UserId.."&width=420&height=420&format=png"
                UpdateChatUI(target)
            end
            local hum = target.Character:FindFirstChildOfClass("Humanoid")
            local root = target.Character:FindFirstChild("HumanoidRootPart")
            local hpPct = math.floor((hum.Health / hum.MaxHealth) * 100)
            local hpCol = (hpPct > 70 and "0,255,0") or (hpPct > 30 and "255,255,0") or "255,0,0"
            local exploiterTag = ""
            if ViolationData[target] and ViolationData[target] > 5 then
                exploiterTag = string.format(" <font color='rgb(255,0,0)'><b>(EXPLOITER: %s)</b></font>", table.concat(ViolationReasons[target], ", "))
            end
            local dist = math.floor((LocalPlayer.Character.Head.Position - target.Character.Head.Position).Magnitude)
            local y = math.floor(target.AccountAge / 365); local m = math.floor((target.AccountAge % 365) / 30); local d = target.AccountAge % 30
            local lockHeader = isProximityTarget and "<font color='rgb(255,255,255)'>[ PROXIMITY CRITICAL ]</font>" or "<font color='rgb(255,0,0)'>[ TARGET LOCKED ]</font>"

            InfoContainer.Visible = true; ChatMaster.Visible = true
            InfoLabel.Text = string.format(
                "%s\nDISPLAY: %s%s\nUSER: @%s\nSTAMP: %dY, %dM, %dD (%d days) | <font color='rgb(%s)'>HP: %d%%</font>\n------------------------------\nDIST: <font color='rgb(255,255,255)'>%d studs</font>\nLIVE SPD: %d studs\nLIVE JMP: %d power\nSESSION: %ds",
                lockHeader, target.DisplayName, exploiterTag, target.Name, y, m, d, target.AccountAge, hpCol, hpPct, dist, math.floor(root.AssemblyLinearVelocity.Magnitude), math.floor(root.AssemblyLinearVelocity.Y), math.floor(tick() - metaData.JoinTime)
            )
            LockESP.Adornee = target.Character; LockESP.Enabled = true
        else InfoContainer.Visible = false; ChatMaster.Visible = false; LockESP.Enabled = false; currentTarget = nil end
    else InfoContainer.Visible = false; ChatMaster.Visible = false; LockESP.Enabled = false; currentTarget = nil end
end)

-- [[ SLIDER: MOBILE & PC FIX ]]
local sliding = false
local function UpdateSlider(input)
    local inputPos = input.Position.X
    local rel = math.clamp((inputPos - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
    Knocker.Position = UDim2.new(rel, -17, 0.5, -17)
    Settings.FOVSize = math.floor(rel * 600)
    SliderLabel.Text = "FOV SIZE: " .. Settings.FOVSize
end
Bar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then sliding = true; UpdateSlider(input) end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then sliding = false end
end)
UserInputService.InputChanged:Connect(function(input)
    if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then UpdateSlider(input) end
end)

ToggleBtn.MouseButton1Click:Connect(function() Settings.Enabled = not Settings.Enabled; ToggleBtn.Text = Settings.Enabled and "LOCK: ON" or "LOCK: OFF" end)
MainMin.MouseButton1Click:Connect(function()
    local isMin = ControlFrame.Size.Y.Offset < 50
    ControlFrame.Size = isMin and UDim2.new(0, 240, 0, 180) or UDim2.new(0, 240, 0, 35)
    ContentContainer.Visible = isMin; MainMin.Text = isMin and "-" or "+"
end)
ChatMinBtn.MouseButton1Click:Connect(function()
    local isMin = ChatMaster.Size.Y.Offset < 50
    ChatMaster.Size = isMin and UDim2.new(0, 280, 0, 300) or UDim2.new(0, 280, 0, 30)
    ChatLogFrame.Visible = isMin; ChatMinBtn.Text = isMin and "-" or "+"
end)

local function HookPlayer(p) if p ~= LocalPlayer then CreateESP(p); p.Chatted:Connect(function(msg) if not playerChatHistory[p.UserId] then playerChatHistory[p.UserId] = {} end; table.insert(playerChatHistory[p.UserId], msg); if currentTarget == p then UpdateChatUI(p) end end) end end
for _, p in pairs(Players:GetPlayers()) do HookPlayer(p) end
Players.PlayerAdded:Connect(HookPlayer); Players.PlayerRemoving:Connect(RemoveESP)
EnableDragging(ControlFrame); EnableDragging(ChatMaster)
end)
