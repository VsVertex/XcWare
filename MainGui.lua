-- [[ XCWARE: ULTIMATE CONTROL COMPONENT ]]
-- UPDATED: Detached Side Panels (Attached to Main via RunService)
-- ADDED: Permanent Blacklist System (Username-based)
-- ADDED: Developer Exclusive Matrix Sleek Theme
-- RESTRICTION: Only Developer (Crixcrix000) has Control/Blacklist access
-- NO EXISTING FEATURES REMOVED

local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer

-- Global Toggle State
_G.MatrixEnabled = true
local BlacklistFile = "XcWare_Blacklist.json"
local BlacklistedUsers = {}

-- Load Blacklist
if isfile and isfile(BlacklistFile) then
    local success, data = pcall(function() return HttpService:JSONDecode(readfile(BlacklistFile)) end)
    if success then BlacklistedUsers = data end
end

-- Security Check: Is user blacklisted?
if BlacklistedUsers[LocalPlayer.Name] then
    LocalPlayer:Kick("You have been blacklisted from XcWare forever.")
    return
end

-- Helper function for glitch colors
local function GetGlitchColor()
    local colors = {
        Color3.fromRGB(0, 255, 70),   -- Matrix Green
        Color3.fromRGB(255, 0, 80),   -- Glitch Red
        Color3.fromRGB(0, 190, 255),  -- Cyber Blue
        Color3.fromRGB(255, 255, 255),-- White
        Color3.fromRGB(180, 0, 255)   -- Purple
    }
    return colors[math.random(1, #colors)]
end

-- [[ XCWARE ATTACHED FOLLOW SYSTEM ]]
task.spawn(function()
    local orbitItems = {}
    local textCount = 4 
    local matrixChars = "01XC#%&?@$!<>[]"
    local myName = LocalPlayer.DisplayName or LocalPlayer.Name
    
    local function createOrbitText()
        local part = Instance.new("Part")
        part.Size = Vector3.new(1, 1, 1)
        part.Transparency = 1
        part.CanCollide = false
        part.Anchored = true
        part.Parent = game.Workspace
        
        local bg = Instance.new("BillboardGui", part)
        bg.Size = UDim2.new(0, 150, 0, 50)
        bg.AlwaysOnTop = true
        
        local label = Instance.new("TextLabel", bg)
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = "Xc(" .. myName .. ")"
        label.TextColor3 = Color3.new(1, 1, 1)
        label.TextStrokeTransparency = 0.5
        label.Font = Enum.Font.Code
        label.TextSize = 16
        
        return part
    end

    for i = 1, textCount do 
        table.insert(orbitItems, createOrbitText()) 
    end

    RunService.RenderStepped:Connect(function()
        local char = LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        
        for _, part in ipairs(orbitItems) do
            part.Transparency = _G.MatrixEnabled and 1 or 1 
            if part:FindFirstChild("BillboardGui") then
                part.BillboardGui.Enabled = _G.MatrixEnabled
            end
        end

        if root and _G.MatrixEnabled then
            for i, part in ipairs(orbitItems) do
                local label = part.BillboardGui.TextLabel
                
                if math.random(1, 10) > 7 then
                    local char1 = string.sub(matrixChars, math.random(1, #matrixChars), math.random(1, #matrixChars))
                    label.Text = char1 .. "c(" .. myName .. ")"
                else
                    label.Text = "Xc(" .. myName .. ")"
                end
                
                if math.random(1, 10) > 8 then
                    label.TextColor3 = GetGlitchColor()
                end

                if math.random(1, 15) > 13 then
                    local randomOffset = Vector3.new(
                        math.random(-3, 3), 
                        math.random(-1, 4), 
                        math.random(-3, 3)
                    )
                    local targetPos = root.Position + randomOffset
                    part.CFrame = CFrame.new(targetPos)
                end
            end
        end
    end)
end)

-- [[ XCWARE GLITCHING MATRIX FOOTSTEP SYSTEM ]]
task.spawn(function()
    local matrixChars = "01XC#%&?@$!<>[]{}/*-+%$!?"
    
    local function CreateFootstepMatrix(pos)
        if not _G.MatrixEnabled then return end 
        
        local part = Instance.new("Part")
        part.Size = Vector3.new(2, 0.1, 2)
        part.CFrame = CFrame.new(pos - Vector3.new(0, 2.8, 0)) * CFrame.Angles(0, math.rad(math.random(0,360)), 0)
        part.Anchored = true
        part.CanCollide = false
        part.Transparency = 1
        part.Parent = game.Workspace

        local gui = Instance.new("SurfaceGui", part)
        gui.Face = Enum.NormalId.Top
        gui.SizingMode = Enum.SurfaceGuiSizingMode.PixelsPerStud
        gui.PixelsPerStud = 50

        local label = Instance.new("TextLabel", gui)
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Font = Enum.Font.Code
        label.TextSize = 35
        label.TextColor3 = GetGlitchColor()
        label.Text = "XC"

        for i = 1, 4 do
            task.spawn(function()
                local driftPart = Instance.new("Part")
                driftPart.Size = Vector3.new(1, 1, 1)
                driftPart.Transparency = 1
                driftPart.Anchored = true
                driftPart.CanCollide = false
                driftPart.CFrame = part.CFrame * CFrame.new(math.random(-1,1), 0, math.random(-1,1))
                driftPart.Parent = game.Workspace
                
                local bbg = Instance.new("BillboardGui", driftPart)
                bbg.Size = UDim2.new(0, 50, 0, 20)
                bbg.AlwaysOnTop = true
                
                local bblabel = Instance.new("TextLabel", bbg)
                bblabel.Size = UDim2.new(1, 0, 1, 0)
                bblabel.BackgroundTransparency = 1
                bblabel.Font = Enum.Font.Code
                bblabel.TextSize = math.random(12, 18)
                bblabel.TextColor3 = GetGlitchColor()
                
                local driftGoal = driftPart.Position + Vector3.new(math.random(-5, 5), math.random(5, 10), math.random(-5, 5))
                local driftTween = TweenService:Create(driftPart, TweenInfo.new(2, Enum.EasingStyle.Linear), {Position = driftGoal})
                local fadeTween = TweenService:Create(bblabel, TweenInfo.new(2), {TextTransparency = 1})
                
                driftTween:Play()
                fadeTween:Play()
                
                task.spawn(function()
                    local t = 0
                    while t < 2 do
                        t = t + task.wait(0.05)
                        local r1 = math.random(1, #matrixChars)
                        bblabel.Text = string.sub(matrixChars, r1, r1)
                        if math.random(1,5) == 1 then bblabel.TextColor3 = GetGlitchColor() end
                    end
                end)
                
                task.wait(2)
                driftPart:Destroy()
            end)
        end

        task.spawn(function()
            local timer = 0
            while timer < 2.5 do
                local dt = task.wait(math.random(0.02, 0.08))
                timer = timer + dt
                local c1 = math.random(1, #matrixChars)
                local c2 = math.random(1, #matrixChars)
                label.Text = string.sub(matrixChars, c1, c1) .. string.sub(matrixChars, c2, c2)
                label.TextColor3 = GetGlitchColor()
                label.Rotation = math.random(-10, 10)
            end
            
            TweenService:Create(label, TweenInfo.new(0.5), {TextTransparency = 1}):Play()
            task.wait(0.5)
            part:Destroy()
        end)
    end

    RunService.Heartbeat:Connect(function()
        local char = LocalPlayer.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChild("Humanoid")
        
        if _G.MatrixEnabled and root and hum and hum.MoveDirection.Magnitude > 0 then
            if math.random(1, 6) == 1 then
                CreateFootstepMatrix(root.Position)
            end
        end
    end)
end)

local iOS_Out = TweenInfo.new(0.6, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
local iOS_In = TweenInfo.new(0.4, Enum.EasingStyle.Quint, Enum.EasingDirection.In)

local ClickSound = Instance.new("Sound", CoreGui)
ClickSound.SoundId = "rbxassetid://8394620892" 
ClickSound.Volume = 1
local ClickEnabled = false

local function PlayClick()
    if ClickEnabled then
        ClickSound:Play()
    end
end

local function MakeDraggable(frame, handle)
    local dragging = false
    local dragInput, dragStart, startPos
    local smoothness = 0.15

    local function update(input)
        local delta = input.Position - dragStart
        local targetPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        TweenService:Create(frame, TweenInfo.new(smoothness, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {Position = targetPos}):Play()
    end

    handle.InputBegan:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and UIS:GetFocusedTextBox() == nil then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)

    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "XcWare_System"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false 
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local function MatrixAnim(label, originalText, isPopup)
    local chars = "01XC#%&?@$"
    task.spawn(function()
        if isPopup then
            for i = 1, 8 do
                local randomStr = ""
                for j = 1, #originalText do
                    local r = math.random(1, #chars)
                    randomStr = randomStr .. string.sub(chars, r, r)
                end
                label.Text = "Xc: " .. randomStr
                task.wait(0.03)
            end
            label.Text = "Xc: " .. originalText
        else
            while true do
                task.wait(math.random(1, 3))
                for i = 1, 15 do
                    local randomStr = ""
                    for j = 1, #originalText do
                        local r = math.random(1, #chars)
                        randomStr = randomStr .. string.sub(chars, r, r)
                    end
                    label.Text = randomStr
                    task.wait(0.04)
                end
                label.Text = originalText
            end
        end
    end)
end

local LoginFrame = Instance.new("CanvasGroup")
LoginFrame.Name = "LoginFrame"
LoginFrame.Parent = ScreenGui
LoginFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
LoginFrame.BorderSizePixel = 0
LoginFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
LoginFrame.AnchorPoint = Vector2.new(0.5, 0.5)
LoginFrame.Size = UDim2.new(0, 300, 0, 200)
LoginFrame.ZIndex = 100
Instance.new("UICorner", LoginFrame).CornerRadius = UDim.new(0, 12)
local LoginStroke = Instance.new("UIStroke", LoginFrame)
LoginStroke.Color = Color3.new(1, 1, 1)
LoginStroke.Thickness = 1.5

MakeDraggable(LoginFrame, LoginFrame)

local LoginLabel = Instance.new("TextLabel", LoginFrame)
LoginLabel.Text = "Join Discord To Get Key"
LoginLabel.Size = UDim2.new(1, 0, 0, 40)
LoginLabel.Position = UDim2.new(0, 0, 0, 10)
LoginLabel.BackgroundTransparency = 1
LoginLabel.TextColor3 = Color3.new(1, 1, 1)
LoginLabel.Font = Enum.Font.GothamBold
LoginLabel.TextSize = 14

local PassBox = Instance.new("TextBox", LoginFrame)
PassBox.Name = "PasswordBox"
PassBox.Size = UDim2.new(0, 240, 0, 35)
PassBox.Position = UDim2.new(0.5, 0, 0.45, 0)
PassBox.AnchorPoint = Vector2.new(0.5, 0.5)
PassBox.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
PassBox.TextColor3 = Color3.new(1, 1, 1)
PassBox.PlaceholderText = "putpassword"
PassBox.Text = ""
PassBox.Font = Enum.Font.Code
PassBox.TextSize = 14
Instance.new("UICorner", PassBox)
Instance.new("UIStroke", PassBox).Color = Color3.fromRGB(60, 60, 60)

local CopyDiscord = Instance.new("TextButton", LoginFrame)
CopyDiscord.Size = UDim2.new(0, 240, 0, 30)
CopyDiscord.Position = UDim2.new(0.5, 0, 0.7, 0)
CopyDiscord.AnchorPoint = Vector2.new(0.5, 0.5)
CopyDiscord.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
CopyDiscord.Text = "https://discord.gg/6hmSdNd3xU"
CopyDiscord.TextColor3 = Color3.fromRGB(150, 150, 150)
CopyDiscord.Font = Enum.Font.Code
CopyDiscord.TextSize = 10
Instance.new("UICorner", CopyDiscord)

CopyDiscord.Activated:Connect(function()
    setclipboard("https://discord.gg/6hmSdNd3xU")
    CopyDiscord.Text = "COPIED TO CLIPBOARD!"
    task.wait(2)
    CopyDiscord.Text = "https://discord.gg/6hmSdNd3xU"
end)

local MainFrame = Instance.new("CanvasGroup")

PassBox.FocusLost:Connect(function(enter)
    if enter then
        if PassBox.Text == "XcWareIsBadass" then
            TweenService:Create(LoginFrame, iOS_In, {Position = UDim2.new(0.5, 0, -0.5, 0)}):Play()
            task.wait(0.4)
            LoginFrame:Destroy()
            MainFrame.Visible = true
            TweenService:Create(MainFrame, iOS_Out, {Size = UDim2.new(0, 800, 0, 500), GroupTransparency = 0}):Play()
            _G.StartCredits()
        else
            PassBox.Text = ""
            PassBox.PlaceholderText = "WRONG PASSWORD"
            task.wait(1.5)
            PassBox.PlaceholderText = "putpassword"
        end
    end
end)

local SSRemote = nil
local ExecutionMode = "Client" 

local function GetSS()
    local Names = {"ExecuteRemote", "ServerSide", "Handshake", "Fire", "Vulnerability", "RunCode", "RemoteEvent", "execute", "Backdoor", "v3rm", "G_Remotes", "DataRemote"}
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("RemoteEvent") then
            for _, name in pairs(Names) do
                if v.Name:lower():find(name:lower()) then
                    return v
                end
            end
        end
    end
    return nil
end
SSRemote = GetSS()

local function ApplyESP(target)
    if target.Character and not target.Character:FindFirstChild("XcHighlight") then
        local highlight = Instance.new("Highlight", target.Character)
        highlight.Name = "XcHighlight"
        highlight.FillColor = Color3.fromRGB(255, 255, 255)
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        
        local tag = Instance.new("BillboardGui", target.Character)
        tag.Name = "XcTag"
        tag.Size = UDim2.new(0, 200, 0, 50)
        tag.AlwaysOnTop = true
        tag.ExtentsOffset = Vector3.new(0, 3, 0)
        
        local infoLabel = Instance.new("TextLabel", tag)
        infoLabel.Size = UDim2.new(1, 0, 1, 0)
        infoLabel.BackgroundTransparency = 1
        infoLabel.TextColor3 = Color3.new(1, 1, 1)
        infoLabel.Font = Enum.Font.GothamBold
        infoLabel.TextSize = 14
        infoLabel.TextStrokeTransparency = 0
        
        task.spawn(function()
            while target.Character and target.Character:FindFirstChild("XcTag") do
                local hum = target.Character:FindFirstChildOfClass("Humanoid")
                if hum then
                    infoLabel.Text = string.format("%s\n[HP: %d]", target.DisplayName, math.floor(hum.Health))
                end
                task.wait(0.1)
            end
        end)
    end
end

local CmdsFrame = Instance.new("CanvasGroup")
CmdsFrame.Name = "CmdsList"
CmdsFrame.Parent = ScreenGui
CmdsFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
CmdsFrame.Position = UDim2.new(0.2, 0, 0.5, 0)
CmdsFrame.Size = UDim2.new(0, 220, 0, 0) 
CmdsFrame.AnchorPoint = Vector2.new(0.5, 0.5)
CmdsFrame.GroupTransparency = 1
CmdsFrame.Visible = false
CmdsFrame.ClipsDescendants = true
CmdsFrame.Active = true 
Instance.new("UICorner", CmdsFrame).CornerRadius = UDim.new(0, 10)
local CmdsStroke = Instance.new("UIStroke", CmdsFrame)
CmdsStroke.Color = Color3.new(1, 1, 1)
CmdsStroke.Thickness = 1.2

local CmdsTop = Instance.new("Frame", CmdsFrame)
CmdsTop.Size = UDim2.new(1, 0, 0, 35)
CmdsTop.BackgroundTransparency = 1
CmdsTop.Active = true 

local CmdsTitle = Instance.new("TextLabel", CmdsTop)
CmdsTitle.Text = "CMDS"
CmdsTitle.Size = UDim2.new(1, 0, 1, 0)
CmdsTitle.Position = UDim2.new(0, 12, 0, 0)
CmdsTitle.TextColor3 = Color3.new(1,1,1)
CmdsTitle.Font = Enum.Font.GothamBold
CmdsTitle.TextSize = 13
CmdsTitle.BackgroundTransparency = 1
CmdsTitle.TextXAlignment = Enum.TextXAlignment.Left

local CmdsScroll = Instance.new("ScrollingFrame", CmdsFrame)
CmdsScroll.Size = UDim2.new(1, -10, 1, -45)
CmdsScroll.Position = UDim2.new(0, 5, 0, 40)
CmdsScroll.BackgroundTransparency = 1
CmdsScroll.BorderSizePixel = 0
CmdsScroll.ScrollBarThickness = 2
CmdsScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
local CmdsListLayout = Instance.new("UIListLayout", CmdsScroll)

local function AddClickableCmd(cmdText, funcText)
    local btn = Instance.new("TextButton", CmdsScroll)
    btn.Size = UDim2.new(1, 0, 0, 22) 
    btn.BackgroundTransparency = 1
    btn.Text = " " .. cmdText
    btn.TextColor3 = Color3.fromRGB(180, 180, 180)
    btn.Font = Enum.Font.Code
    btn.TextSize = 11
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Activated:Connect(function()
        _G.HandleCommand(funcText or cmdText)
    end)
end

AddClickableCmd("-cmds")
AddClickableCmd("-openss")
AddClickableCmd("-scripthub")
AddClickableCmd("-rst")
AddClickableCmd("-killscript", "-rstscript")
AddClickableCmd("-sethealth (Num)", "-sethealth 100")
AddClickableCmd("-givetool (Tool)", "-givetool tptool")
AddClickableCmd("-rejoin")
AddClickableCmd("-setspeed (Num)", "-setspeed 50")
AddClickableCmd("-setjump (Num)", "-setjump 100")

CmdsScroll.CanvasSize = UDim2.new(0, 0, 0, CmdsListLayout.AbsoluteContentSize.Y)

local function CloseCmds()
    TweenService:Create(CmdsFrame, iOS_In, {Size = UDim2.new(0, 220, 0, 0), GroupTransparency = 1}):Play()
    task.wait(0.4); CmdsFrame.Visible = false
end

local CmdsClose = Instance.new("TextButton", CmdsTop)
CmdsClose.Text = "X"
CmdsClose.Size = UDim2.new(0, 22, 0, 22)
CmdsClose.Position = UDim2.new(1, -28, 0, 6)
CmdsClose.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
CmdsClose.TextColor3 = Color3.new(1,1,1)
CmdsClose.Font = Enum.Font.GothamBold
CmdsClose.TextSize = 10
Instance.new("UICorner", CmdsClose)
CmdsClose.Activated:Connect(CloseCmds)

local CmdsMini = Instance.new("TextButton", CmdsTop)
CmdsMini.Text = "-"
CmdsMini.Size = UDim2.new(0, 22, 0, 22)
CmdsMini.Position = UDim2.new(1, -55, 0, 6)
CmdsMini.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
CmdsMini.TextColor3 = Color3.new(1,1,1)
CmdsMini.Font = Enum.Font.GothamBold
CmdsMini.TextSize = 10
Instance.new("UICorner", CmdsMini)

local cmdsMinimized = false
CmdsMini.Activated:Connect(function()
    if not cmdsMinimized then
        TweenService:Create(CmdsFrame, iOS_Out, {Size = UDim2.new(0, 220, 0, 35)}):Play()
        cmdsMinimized = true
    else
        TweenService:Create(CmdsFrame, iOS_Out, {Size = UDim2.new(0, 220, 0, 250)}):Play()
        cmdsMinimized = false
    end
end)
MakeDraggable(CmdsFrame, CmdsTop)

local currentSpin = nil
_G.HandleCommand = function(msg)
    local args = string.split(msg, " ")
    local command = args[1]:lower()
    
    if command == "-speed" or command == "-setspeed" then
        local val = tonumber(args[2])
        if val and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = val
            _G.ShowPopupRef("SPEED: " .. val)
        end
    elseif command == "-jump" or command == "-jumppower" or command == "-setjump" then
        local val = tonumber(args[2])
        if val and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.UseJumpPower = true
            LocalPlayer.Character.Humanoid.JumpPower = val
            _G.ShowPopupRef("JUMP: " .. val)
        end
    elseif command == "-spin" then
        local speed = tonumber(args[2]) or 50
        if currentSpin then currentSpin:Destroy() end
        local humRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if humRoot then
            currentSpin = Instance.new("AngularVelocity", humRoot)
            currentSpin.Name = "XcWare_Spin"
            currentSpin.MaxTorque = math.huge
            currentSpin.AngularVelocity = Vector3.new(0, speed, 0)
            currentSpin.Attachment0 = humRoot:FindFirstChildOfClass("Attachment") or Instance.new("Attachment", humRoot)
            _G.ShowPopupRef("SPIN: " .. speed)
        end
    elseif command == "-unspin" then
        local humRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if humRoot and humRoot:FindFirstChild("XcWare_Spin") then
            humRoot:FindFirstChild("XcWare_Spin"):Destroy()
            _G.ShowPopupRef("UNSPUN")
        end
    elseif command == "-tp" or command == "-teleport" then
        local targetName = args[2]
        if targetName then
            for _, p in pairs(Players:GetPlayers()) do
                if string.find(p.Name:lower(), targetName:lower()) and p.Character then
                    LocalPlayer.Character:MoveTo(p.Character.PrimaryPart.Position)
                    _G.ShowPopupRef("TP TO: " .. p.DisplayName)
                    break
                end
            end
        end
    elseif command == "-esp" then
        local targetName = args[2]
        if targetName then
            for _, p in pairs(Players:GetPlayers()) do
                if string.find(p.Name:lower(), targetName:lower()) then
                    ApplyESP(p)
                    _G.ShowPopupRef("ESP: " .. p.DisplayName)
                    break
                end
            end
        end
    elseif command == "-espall" then
        for _, p in pairs(Players:GetPlayers()) do ApplyESP(p) end
        _G.ShowPopupRef("ESP ALL ENABLED")
    elseif command == "-reset" or command == "-rst" then
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.Health = 0
            _G.ShowPopupRef("RESETTING")
        end
    elseif command == "-rstscript" or command == "-killscript" then
        _G.ShowPopupRef("RESTARTING...")
        task.wait(0.5)
        ScreenGui:Destroy()
        loadstring(game:HttpGet("https://raw.githubusercontent.com/VsVertex/XcWare/main/Main.lua"))() 
    elseif command == "-sethealth" or command == "-sh" then
        local val = tonumber(args[2])
        if val and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.Health = val
            _G.ShowPopupRef("HEALTH SET: " .. val)
        end
    elseif command == "-leave" then
        game:Shutdown()
    elseif command == "-rejoin" then
        _G.ShowPopupRef("REJOINING...")
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    elseif command == "-cmds" then
        CmdsFrame.Visible = true
        TweenService:Create(CmdsFrame, iOS_Out, {Size = UDim2.new(0, 220, 0, 250), GroupTransparency = 0}):Play()
    elseif command == "-openss" then
        _G.ShowPopupRef("LOADING SS...")
        loadstring(game:HttpGet("https://raw.githubusercontent.com/its-LALOL/LALOL-Hub/main/Backdoor-Scanner/script"))()
    elseif command == "-scripthub" then
        _G.ShowPopupRef("LOADING SCRIPTHUB...")
        loadstring(game:HttpGet("https://raw.githubusercontent.com/scripthubekitten/SCRIPTHUBV3/main/SCRIPTHUBV3", true))()
    elseif command == "-fling" then
        local targetName = args[2]
        if targetName then
            for _, p in pairs(Players:GetPlayers()) do
                if string.find(p.Name:lower(), targetName:lower()) then
                    _G.ShowPopupRef("FLINGING: " .. p.DisplayName)
                    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                    local thrp = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
                    if hrp and thrp then
                        local oldPos = hrp.CFrame
                        hrp.CFrame = thrp.CFrame
                        hrp.Velocity = Vector3.new(0, 8000, 0)
                        task.wait(0.1)
                        hrp.CFrame = oldPos
                    end
                    break
                end
            end
        end
    elseif command == "-givetool" then
        local toolName = args[2] and args[2]:lower()
        if toolName == "tptool" then
            local tpTool = Instance.new("Tool")
            tpTool.Name = "XcTeleportTool"
            tpTool.RequiresHandle = false
            tpTool.Activated:Connect(function()
                local mouse = LocalPlayer:GetMouse()
                if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(mouse.Hit.p) + Vector3.new(0, 3, 0)
                    _G.ShowPopupRef("TELEPORTED")
                end
            end)
            tpTool.Parent = LocalPlayer.Backpack
            _G.ShowPopupRef("GIVEN: TP TOOL")
        elseif toolName == "f3x" then
            loadstring(game:GetObjects("rbxassetid://6695644299")[1].Source)()
            _G.ShowPopupRef("GIVEN: F3X")
        end
    end
end

LocalPlayer.Chatted:Connect(_G.HandleCommand)

-- [[ MAIN CONTAINER ]]
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0) 
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Size = UDim2.new(0, 0, 0, 0) 
MainFrame.GroupTransparency = 1 
MainFrame.ClipsDescendants = false
MainFrame.Active = true 
MainFrame.Visible = false 
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)

local TopBar = Instance.new("Frame", MainFrame)
TopBar.Name = "TopBar"
TopBar.BackgroundTransparency = 1 
TopBar.Size = UDim2.new(1, 0, 0, 60)
TopBar.ZIndex = 10
TopBar.Active = true 

local Title = Instance.new("TextLabel", TopBar)
Title.Text = "XCWARE"
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 24
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 25, 0, -8) 
Title.Size = UDim2.new(0, 130, 1, 0) 
Title.TextXAlignment = Enum.TextXAlignment.Left

-- [[ PLAYER RANK LABEL ]]
local RankLabel = Instance.new("TextLabel", TopBar)
RankLabel.Name = "PlayerRank"
RankLabel.Size = UDim2.new(0, 130, 0, 20)
RankLabel.Position = UDim2.new(0, 25, 0, 32)
RankLabel.BackgroundTransparency = 1
RankLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
RankLabel.Font = Enum.Font.Code
RankLabel.TextSize = 11
RankLabel.TextXAlignment = Enum.TextXAlignment.Left

local function SetRank()
    local user = LocalPlayer.Name
    if user == "Crixcrix000" then
        RankLabel.Text = "[ DEVELOPER ]"
        RankLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
        -- Developer SLEEK Look
        MainFrame.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
        local devStroke = Instance.new("UIStroke", MainFrame)
        devStroke.Color = Color3.fromRGB(0, 255, 100)
        devStroke.Thickness = 1.8
    elseif user == "bl0eq" or user == "blox22bolu" then
        RankLabel.Text = "[ SCRIPT TESTER ]"
        RankLabel.TextColor3 = Color3.fromRGB(0, 190, 255)
    else
        RankLabel.Text = "[ MEMBER ]"
        RankLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
    end
end
SetRank()

task.spawn(function()
    local hue = 0
    while task.wait() do
        hue = hue + 0.01
        if hue > 1 then hue = 0 end
        Title.TextColor3 = Color3.fromHSV(hue, 0.8, 1)
    end
end)

local CMDBoxFrame = Instance.new("Frame", TopBar)
CMDBoxFrame.Name = "CommandBoxContainer"
CMDBoxFrame.Size = UDim2.new(0, 350, 0, 30)
CMDBoxFrame.Position = UDim2.new(0, 150, 0.5, 0)
CMDBoxFrame.AnchorPoint = Vector2.new(0, 0.5)
CMDBoxFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
CMDBoxFrame.ZIndex = 20
Instance.new("UICorner", CMDBoxFrame)
local CMDStroke = Instance.new("UIStroke", CMDBoxFrame)
CMDStroke.Color = Color3.new(1, 1, 1)
CMDStroke.Thickness = 1
CMDStroke.Transparency = 0.5

local CMDInput = Instance.new("TextBox", CMDBoxFrame)
CMDInput.Size = UDim2.new(1, -20, 1, 0)
CMDInput.Position = UDim2.new(0, 10, 0, 0)
CMDInput.BackgroundTransparency = 1
CMDInput.Text = ""
CMDInput.PlaceholderText = "Run command... (e.g. -speed 50)"
CMDInput.PlaceholderColor3 = Color3.fromRGB(80, 80, 80)
CMDInput.TextColor3 = Color3.new(1, 1, 1)
CMDInput.Font = Enum.Font.Code
CMDInput.TextSize = 12
CMDInput.ClearTextOnFocus = true
CMDInput.ZIndex = 21

CMDInput.FocusLost:Connect(function(enterPressed)
    if enterPressed and CMDInput.Text ~= "" then
        _G.HandleCommand(CMDInput.Text)
        CMDInput.Text = ""
    end
end)

local CreditsOverlay = Instance.new("Frame", MainFrame)
CreditsOverlay.Name = "CreditsOverlay"
CreditsOverlay.Size = UDim2.new(1, 0, 1, 0)
CreditsOverlay.BackgroundColor3 = Color3.new(0, 0, 0)
CreditsOverlay.BackgroundTransparency = 1
CreditsOverlay.Visible = false
CreditsOverlay.ZIndex = 50
Instance.new("UICorner", CreditsOverlay).CornerRadius = UDim.new(0, 12)

local CreditsContainer = Instance.new("Frame", CreditsOverlay)
CreditsContainer.Size = UDim2.new(1, 0, 1, 0)
CreditsContainer.BackgroundTransparency = 1
CreditsContainer.ClipsDescendants = true

_G.StartCredits = function()
    CreditsOverlay.Visible = true
    TweenService:Create(CreditsOverlay, iOS_Out, {BackgroundTransparency = 0.1}):Play()
    
    local creds = {
        "XCWARE SYSTEM", "", "Original Creator", "Crixcrix000", "", "Beta Testers", "DreadX", "Bl0eq", "", "Special Beta Tester", "HexaXahSan", "", "THANK YOU FOR USING"
    }
    
    local creditLabel = Instance.new("TextLabel", CreditsContainer)
    creditLabel.Size = UDim2.new(1, 0, 0, #creds * 40)
    creditLabel.Position = UDim2.new(0, 0, 1, 0)
    creditLabel.BackgroundTransparency = 1
    creditLabel.TextColor3 = Color3.new(1, 1, 1)
    creditLabel.Font = Enum.Font.GothamMedium
    creditLabel.TextSize = 18
    creditLabel.Text = table.concat(creds, "\n")
    
    local tween = TweenService:Create(creditLabel, TweenInfo.new(8, Enum.EasingStyle.Linear), {Position = UDim2.new(0, 0, 0, -creditLabel.Size.Y.Offset)})
    tween:Play()
    
    tween.Completed:Connect(function()
        TweenService:Create(CreditsOverlay, iOS_In, {BackgroundTransparency = 1}):Play()
        task.wait(0.4)
        CreditsOverlay.Visible = false
        creditLabel:Destroy()
    end)
end

local UpdateLogFrame = Instance.new("CanvasGroup")
UpdateLogFrame.Name = "UpdateLogs"
UpdateLogFrame.Parent = ScreenGui
UpdateLogFrame.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
UpdateLogFrame.Size = UDim2.new(0, 350, 0, 400)
UpdateLogFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
UpdateLogFrame.AnchorPoint = Vector2.new(0.5, 0.5)
UpdateLogFrame.Visible = false
UpdateLogFrame.ZIndex = 300
Instance.new("UICorner", UpdateLogFrame)
local LogStroke = Instance.new("UIStroke", UpdateLogFrame)
LogStroke.Color = Color3.new(1,1,1)
LogStroke.Thickness = 1.5

local LogTop = Instance.new("Frame", UpdateLogFrame)
LogTop.Size = UDim2.new(1, 0, 0, 40)
LogTop.BackgroundTransparency = 1
MakeDraggable(UpdateLogFrame, LogTop)

local LogTitle = Instance.new("TextLabel", LogTop)
LogTitle.Text = "SCRIPT UPDATE LOG"
LogTitle.Size = UDim2.new(1, -40, 1, 0)
LogTitle.Position = UDim2.new(0, 15, 0, 0)
LogTitle.BackgroundTransparency = 1
LogTitle.TextColor3 = Color3.new(1, 1, 1)
LogTitle.Font = Enum.Font.GothamBold
LogTitle.TextSize = 16
LogTitle.TextXAlignment = Enum.TextXAlignment.Left

local LogClose = Instance.new("TextButton", LogTop)
LogClose.Text = "X"
LogClose.Size = UDim2.new(0, 25, 0, 25)
LogClose.Position = UDim2.new(1, -35, 0, 7)
LogClose.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
LogClose.TextColor3 = Color3.new(1, 1, 1)
LogClose.Font = Enum.Font.GothamBold
LogClose.TextSize = 12
Instance.new("UICorner", LogClose)
LogClose.Activated:Connect(function() UpdateLogFrame.Visible = false end)

local LogScroll = Instance.new("ScrollingFrame", UpdateLogFrame)
LogScroll.Size = UDim2.new(1, -20, 1, -50)
LogScroll.Position = UDim2.new(0, 10, 0, 45)
LogScroll.BackgroundTransparency = 1
LogScroll.BorderSizePixel = 0
LogScroll.ScrollBarThickness = 3
LogScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
LogScroll.ScrollingDirection = Enum.ScrollingDirection.Y
local LogLayout = Instance.new("UIListLayout", LogScroll)
LogLayout.Padding = UDim.new(0, 8)

local function AddLogItem(txt, isHeader)
    local item = Instance.new("TextLabel", LogScroll)
    item.Size = UDim2.new(1, -5, 0, 20)
    item.BackgroundTransparency = 1
    item.TextColor3 = isHeader and Color3.new(0, 1, 0.5) or Color3.new(0.9, 0.9, 0.9)
    item.Font = isHeader and Enum.Font.GothamBold or Enum.Font.Code
    item.TextSize = isHeader and 14 or 12
    item.Text = txt
    item.TextXAlignment = Enum.TextXAlignment.Left
    item.TextWrapped = true
    item.AutomaticSize = Enum.AutomaticSize.Y
    LogScroll.CanvasSize = UDim2.new(0, 0, 0, LogLayout.AbsoluteContentSize.Y)
end

AddLogItem("VERSION 2.5.0 - DEV CONTROL UPDATE", true)
AddLogItem("- Added Developer Control Panel")
AddLogItem("- Added Permanent Blacklist System")
AddLogItem("- Added Detached Side Panels")
AddLogItem("- Added Dev Sleek Matrix Theme")
AddLogItem("- Added Blacklist/Unblacklist Buttons")

local SettingsFrame = Instance.new("Frame", ScreenGui)
SettingsFrame.Name = "SettingsFrame"
SettingsFrame.Size = UDim2.new(0, 400, 0, 300)
SettingsFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
SettingsFrame.AnchorPoint = Vector2.new(0.5, 0.5)
SettingsFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
SettingsFrame.Visible = false
SettingsFrame.ZIndex = 200
Instance.new("UICorner", SettingsFrame)
local SettingsStroke = Instance.new("UIStroke", SettingsFrame)
SettingsStroke.Color = Color3.new(1, 1, 1)
SettingsStroke.Thickness = 1.5

local SettingsTop = Instance.new("Frame", SettingsFrame)
SettingsTop.Size = UDim2.new(1, 0, 0, 40)
SettingsTop.BackgroundTransparency = 1
MakeDraggable(SettingsFrame, SettingsTop)

local SettingsTitle = Instance.new("TextLabel", SettingsTop)
SettingsTitle.Text = "SETTINGS"
SettingsTitle.Size = UDim2.new(1, -40, 1, 0)
SettingsTitle.Position = UDim2.new(0, 15, 0, 0)
SettingsTitle.BackgroundTransparency = 1
SettingsTitle.TextColor3 = Color3.new(1, 1, 1)
SettingsTitle.Font = Enum.Font.GothamBold
SettingsTitle.TextSize = 16
SettingsTitle.TextXAlignment = Enum.TextXAlignment.Left

local SoundLabel = Instance.new("TextLabel", SettingsFrame)
SoundLabel.Text = "GUI CLICK SOUND"
SoundLabel.Size = UDim2.new(0, 150, 0, 30)
SoundLabel.Position = UDim2.new(0, 20, 0, 60)
SoundLabel.BackgroundTransparency = 1
SoundLabel.TextColor3 = Color3.new(0.8, 0.8, 0.8)
SoundLabel.Font = Enum.Font.GothamMedium
SoundLabel.TextSize = 14
SoundLabel.TextXAlignment = Enum.TextXAlignment.Left

local SoundToggle = Instance.new("TextButton", SettingsFrame)
SoundToggle.Name = "SoundToggle"
SoundToggle.Size = UDim2.new(0, 60, 0, 25)
SoundToggle.Position = UDim2.new(0, 310, 0, 62)
SoundToggle.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
SoundToggle.Text = "OFF"
SoundToggle.TextColor3 = Color3.fromRGB(255, 50, 50)
SoundToggle.Font = Enum.Font.GothamBold
SoundToggle.TextSize = 12
Instance.new("UICorner", SoundToggle)

SoundToggle.Activated:Connect(function()
    ClickEnabled = not ClickEnabled
    SoundToggle.Text = ClickEnabled and "ON" or "OFF"
    SoundToggle.TextColor3 = ClickEnabled and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 50, 50)
end)

local MatrixLabel = Instance.new("TextLabel", SettingsFrame)
MatrixLabel.Text = "MATRIX PARTICLES"
MatrixLabel.Size = UDim2.new(0, 150, 0, 30)
MatrixLabel.Position = UDim2.new(0, 20, 0, 100)
MatrixLabel.BackgroundTransparency = 1
MatrixLabel.TextColor3 = Color3.new(0.8, 0.8, 0.8)
MatrixLabel.Font = Enum.Font.GothamMedium
MatrixLabel.TextSize = 14
MatrixLabel.TextXAlignment = Enum.TextXAlignment.Left

local MatrixToggle = Instance.new("TextButton", SettingsFrame)
MatrixToggle.Name = "MatrixToggle"
MatrixToggle.Size = UDim2.new(0, 60, 0, 25)
MatrixToggle.Position = UDim2.new(0, 310, 0, 102)
MatrixToggle.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MatrixToggle.Text = "ON"
MatrixToggle.TextColor3 = Color3.fromRGB(0, 255, 100)
MatrixToggle.Font = Enum.Font.GothamBold
MatrixToggle.TextSize = 12
Instance.new("UICorner", MatrixToggle)

MatrixToggle.Activated:Connect(function()
    _G.MatrixEnabled = not _G.MatrixEnabled
    MatrixToggle.Text = _G.MatrixEnabled and "ON" or "OFF"
    MatrixToggle.TextColor3 = _G.MatrixEnabled and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 50, 50)
end)

local SettingsClose = Instance.new("TextButton", SettingsTop)
SettingsClose.Text = "X"
SettingsClose.Size = UDim2.new(0, 30, 0, 30)
SettingsClose.Position = UDim2.new(1, -35, 0, 5)
SettingsClose.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
SettingsClose.TextColor3 = Color3.new(1, 1, 1)
SettingsClose.Font = Enum.Font.GothamBold
SettingsClose.TextSize = 12
Instance.new("UICorner", SettingsClose)
SettingsClose.Activated:Connect(function() SettingsFrame.Visible = false end)

local PageScroller = Instance.new("ScrollingFrame", MainFrame)
PageScroller.Name = "PageScroller"
PageScroller.Size = UDim2.new(1, 0, 1, -60) 
PageScroller.Position = UDim2.new(0, 0, 0, 60)
PageScroller.BackgroundTransparency = 1
PageScroller.BorderSizePixel = 0
PageScroller.CanvasSize = UDim2.new(0, 0, 3, 0) 
PageScroller.ScrollBarThickness = 0 
PageScroller.ScrollingEnabled = true
PageScroller.ScrollingDirection = Enum.ScrollingDirection.Y

local SliderTrack = Instance.new("Frame", MainFrame)
SliderTrack.Name = "SliderTrack"
SliderTrack.Size = UDim2.new(0, 4, 1, -80)
SliderTrack.Position = UDim2.new(1, -10, 0, 70)
SliderTrack.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
SliderTrack.BorderSizePixel = 0
Instance.new("UICorner", SliderTrack)

local SliderThumb = Instance.new("Frame", SliderTrack)
SliderThumb.Name = "SliderThumb"
SliderThumb.Size = UDim2.new(1, 0, 0.333, 0) 
SliderThumb.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
Instance.new("UICorner", SliderThumb)

local Page1 = Instance.new("Frame", PageScroller)
Page1.Name = "Page1"
Page1.Size = UDim2.new(1, 0, 0.333, 0)
Page1.BackgroundTransparency = 1

local Page2 = Instance.new("Frame", PageScroller)
Page2.Name = "Page2"
Page2.Size = UDim2.new(1, 0, 0.333, 0)
Page2.Position = UDim2.new(0, 0, 0.333, 0) 
Page2.BackgroundTransparency = 1

local Page3 = Instance.new("Frame", PageScroller)
Page3.Name = "Page3"
Page3.Size = UDim2.new(1, 0, 0.333, 0)
Page3.Position = UDim2.new(0, 0, 0.666, 0)
Page3.BackgroundTransparency = 1

local DashFrame = Instance.new("Frame", Page2)
DashFrame.Size = UDim2.new(0, 350, 0, 260)
DashFrame.Position = UDim2.new(0, 25, 0, 20)
DashFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Instance.new("UICorner", DashFrame)

local GameInfo = Instance.new("TextLabel", DashFrame)
GameInfo.Size = UDim2.new(1, -20, 1, -50)
GameInfo.Position = UDim2.new(0, 10, 0, 45)
GameInfo.BackgroundTransparency = 1
GameInfo.TextColor3 = Color3.fromRGB(200, 200, 200)
GameInfo.Font = Enum.Font.Code
GameInfo.TextSize = 12
GameInfo.TextXAlignment = Enum.TextXAlignment.Left
GameInfo.TextYAlignment = Enum.TextYAlignment.Top

task.spawn(function()
    while task.wait(1) do
        local ping = tonumber(LocalPlayer:GetNetworkPing() * 2000) or 0
        local fps = math.floor(1/RunService.RenderStepped:Wait())
        GameInfo.Text = string.format("GAME: %s\nID: %d\nPLAYERS: %d/%d\nPING: %.1fms\nFPS: %d", 
            game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name, 
            game.PlaceId, #Players:GetPlayers(), Players.MaxPlayers, ping, fps)
    end
end)

local LogsFrame = Instance.new("Frame", Page2)
LogsFrame.Size = UDim2.new(0, 385, 0, 260)
LogsFrame.Position = UDim2.new(0, 390, 0, 20)
LogsFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Instance.new("UICorner", LogsFrame)

local LogsScroll = Instance.new("ScrollingFrame", LogsFrame)
LogsScroll.Size = UDim2.new(1, -20, 1, -50)
LogsScroll.Position = UDim2.new(0, 10, 0, 45)
LogsScroll.BackgroundTransparency = 1
LogsScroll.BorderSizePixel = 0
LogsScroll.ScrollBarThickness = 2
LogsScroll.CanvasSize = UDim2.new(0,0,0,0)
local LogsLayout = Instance.new("UIListLayout", LogsScroll)

local function AddChatLog(player, message)
    local log = Instance.new("TextLabel", LogsScroll)
    log.Size = UDim2.new(1, 0, 0, 20)
    log.BackgroundTransparency = 1
    log.TextColor3 = Color3.fromRGB(180, 180, 180)
    log.Font = Enum.Font.Code
    log.TextSize = 11
    log.Text = string.format("[%s]: %s", player.Name, message)
    log.TextXAlignment = Enum.TextXAlignment.Left
    log.TextWrapped = true
    log.AutomaticSize = Enum.AutomaticSize.Y
    LogsScroll.CanvasSize = UDim2.new(0, 0, 0, LogsLayout.AbsoluteContentSize.Y)
end

for _, p in pairs(Players:GetPlayers()) do p.Chatted:Connect(function(msg) AddChatLog(p, msg) end) end
Players.PlayerAdded:Connect(function(p) p.Chatted:Connect(function(msg) AddChatLog(p, msg) end) end)

local InfoLockButton = Instance.new("TextButton", Page2)
InfoLockButton.Size = UDim2.new(0, 750, 0, 45)
InfoLockButton.Position = UDim2.new(0, 25, 0, 295)
InfoLockButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20) 
InfoLockButton.Text = "LOAD INFOLOCK AIM"
InfoLockButton.TextColor3 = Color3.new(1,1,1)
InfoLockButton.Font = Enum.Font.GothamBold
InfoLockButton.TextSize = 14
Instance.new("UICorner", InfoLockButton)

local UtilGrid = Instance.new("Frame", Page3)
UtilGrid.Size = UDim2.new(1, -50, 1, -80)
UtilGrid.Position = UDim2.new(0, 25, 0, 60)
UtilGrid.BackgroundTransparency = 1
Instance.new("UIGridLayout", UtilGrid).CellSize = UDim2.new(0, 180, 0, 45) 

local function CreateUtilBtn(name, callback)
    local btn = Instance.new("TextButton", UtilGrid)
    btn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    btn.Text = name
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 12
    Instance.new("UICorner", btn)
    btn.Activated:Connect(callback)
    return btn
end

CreateUtilBtn("SET TO AUTO-EXEC", function() end)
CreateUtilBtn("FPS UNLOCKER", function() if setfpscap then setfpscap(999) end end)
CreateUtilBtn("ANTI-AFK", function() end)
CreateUtilBtn("DARK DEX", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/dex.lua"))() end)
CreateUtilBtn("REMOTE SPY", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/exuax/SimpleSpyV3/main/main.lua"))() end)
CreateUtilBtn("INFINITE YIELD", function() loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))() end)
CreateUtilBtn("XcWare Old", function() loadstring(game:HttpGet("https://pastebin.com/raw/FnD820ZN"))() end)

local function ShowPopup(msg)
    local popupFrame = Instance.new("Frame", ScreenGui)
    popupFrame.Size = UDim2.new(0, 180, 0, 32)
    popupFrame.Position = UDim2.new(1, 200, 1, -50)
    popupFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    Instance.new("UICorner", popupFrame)
    local notifyLabel = Instance.new("TextLabel", popupFrame)
    notifyLabel.Size = UDim2.new(1, 0, 1, 0)
    notifyLabel.BackgroundTransparency = 1
    notifyLabel.TextColor3 = Color3.new(1, 1, 1)
    notifyLabel.Font = Enum.Font.Code 
    notifyLabel.TextSize = 11
    notifyLabel.Text = msg
    TweenService:Create(popupFrame, iOS_Out, {Position = UDim2.new(1, -200, 1, -50)}):Play()
    task.delay(2.5, function() popupFrame:Destroy() end)
end
_G.ShowPopupRef = ShowPopup

local EditorScrolling = Instance.new("ScrollingFrame", Page1)
EditorScrolling.Position = UDim2.new(0, 25, 0, 20)
EditorScrolling.Size = UDim2.new(0, 450, 0, 320)
EditorScrolling.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
EditorScrolling.CanvasSize = UDim2.new(5, 0, 10, 0) 
Instance.new("UICorner", EditorScrolling)

local CodeEditor = Instance.new("TextBox", EditorScrolling)
CodeEditor.Size = UDim2.new(1, 0, 1, 0)
CodeEditor.BackgroundTransparency = 1
CodeEditor.TextColor3 = Color3.new(1, 1, 1)
CodeEditor.Font = Enum.Font.Code
CodeEditor.TextSize = 14
CodeEditor.MultiLine = true
CodeEditor.TextXAlignment = Enum.TextXAlignment.Left
CodeEditor.TextYAlignment = Enum.TextYAlignment.Top

local function StyleButton(btn, text, pos)
    btn.Parent = TopBar; btn.Text = text; btn.TextColor3 = Color3.new(1,1,1); btn.BackgroundColor3 = Color3.new(0,0,0)
    btn.Size = UDim2.new(0, 32, 0, 32); btn.Position = pos; btn.Font = Enum.Font.GothamBold; btn.ZIndex = 10 
    Instance.new("UICorner", btn)
    return btn
end

local CloseBtn = StyleButton(Instance.new("TextButton"), "X", UDim2.new(1, -50, 0, 14))
local MiniBtn = StyleButton(Instance.new("TextButton"), "-", UDim2.new(1, -95, 0, 14))
local PageSwitchBtn = StyleButton(Instance.new("TextButton"), "2", UDim2.new(1, -140, 0, 14))
local SettingsBtn = StyleButton(Instance.new("TextButton"), "⚙", UDim2.new(1, -185, 0, 14))
local LogsBtn = StyleButton(Instance.new("TextButton"), "L", UDim2.new(1, -230, 0, 14))

-- [[ DEVELOPER EXCLUSIVE: DETACHED CONTROL PANELS ]]
local UserListFrame = Instance.new("CanvasGroup", ScreenGui) -- Parented to ScreenGui for true "outside" feel
UserListFrame.Size = UDim2.new(0, 220, 0, 400)
UserListFrame.BackgroundColor3 = Color3.fromRGB(2, 2, 2)
Instance.new("UICorner", UserListFrame)
local UL_Stroke = Instance.new("UIStroke", UserListFrame)
UL_Stroke.Color = Color3.fromRGB(0, 255, 100)

local UL_Title = Instance.new("TextLabel", UserListFrame)
UL_Title.Size = UDim2.new(1, 0, 0, 30)
UL_Title.Text = "ACTIVE USERS (DEV ONLY)"
UL_Title.TextColor3 = Color3.new(1, 1, 1)
UL_Title.Font = Enum.Font.GothamBold
UL_Title.TextSize = 10
UL_Title.BackgroundTransparency = 1

local UL_Scroll = Instance.new("ScrollingFrame", UserListFrame)
UL_Scroll.Size = UDim2.new(1, -10, 1, -40)
UL_Scroll.Position = UDim2.new(0, 5, 0, 35)
UL_Scroll.BackgroundTransparency = 1
local UL_Layout = Instance.new("UIListLayout", UL_Scroll)

local RemoteFrame = Instance.new("CanvasGroup", ScreenGui)
RemoteFrame.Size = UDim2.new(0, 220, 0, 400)
RemoteFrame.BackgroundColor3 = Color3.fromRGB(2, 2, 2)
Instance.new("UICorner", RemoteFrame)
local RM_Stroke = Instance.new("UIStroke", RemoteFrame)
RM_Stroke.Color = Color3.fromRGB(255, 0, 0)

-- Attach side panels logic
RunService.RenderStepped:Connect(function()
    if MainFrame.Visible then
        UserListFrame.Position = MainFrame.Position - UDim2.new(0, 630, 0, 250)
        RemoteFrame.Position = MainFrame.Position + UDim2.new(0, 410, 0, -250)
    end
end)

local function UpdateUserList()
    for _, v in pairs(UL_Scroll:GetChildren()) do if v:IsA("Frame") then v:Destroy() end end
    for _, p in pairs(Players:GetPlayers()) do
        local container = Instance.new("Frame", UL_Scroll)
        container.Size = UDim2.new(1, 0, 0, 45)
        container.BackgroundTransparency = 1
        
        local l = Instance.new("TextLabel", container)
        l.Size = UDim2.new(1, 0, 0, 20)
        l.Text = p.Name
        l.TextColor3 = Color3.new(1,1,1)
        l.BackgroundTransparency = 1
        l.Font = Enum.Font.Code
        l.TextSize = 10
        
        local blBtn = Instance.new("TextButton", container)
        blBtn.Size = UDim2.new(0, 80, 0, 20)
        blBtn.Position = UDim2.new(0, 5, 0, 22)
        blBtn.Text = "BLACKLIST"
        blBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        blBtn.TextColor3 = Color3.new(1,1,1)
        blBtn.Font = Enum.Font.GothamBold
        blBtn.TextSize = 9
        Instance.new("UICorner", blBtn)
        
        local unBlBtn = Instance.new("TextButton", container)
        unBlBtn.Size = UDim2.new(0, 90, 0, 20)
        unBlBtn.Position = UDim2.new(1, -95, 0, 22)
        unBlBtn.Text = "UNBLACKLIST"
        unBlBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
        unBlBtn.TextColor3 = Color3.new(1,1,1)
        unBlBtn.Font = Enum.Font.GothamBold
        unBlBtn.TextSize = 9
        Instance.new("UICorner", unBlBtn)

        blBtn.Activated:Connect(function()
            BlacklistedUsers[p.Name] = true
            if writefile then writefile(BlacklistFile, HttpService:JSONEncode(BlacklistedUsers)) end
            ShowPopup("BLACKLISTED: " .. p.Name)
        end)

        unBlBtn.Activated:Connect(function()
            BlacklistedUsers[p.Name] = nil
            if writefile then writefile(BlacklistFile, HttpService:JSONEncode(BlacklistedUsers)) end
            ShowPopup("REMOVED: " .. p.Name)
        end)
    end
end
Players.PlayerAdded:Connect(UpdateUserList)
UpdateUserList()

-- Hide/Show Panels based on Dev Rank
if LocalPlayer.Name ~= "Crixcrix000" then
    UserListFrame.Visible = false
    RemoteFrame.Visible = false
end

-- Re-implement basic functions
PageSwitchBtn.Activated:Connect(function()
    local pageHeight = PageScroller.AbsoluteWindowSize.Y
    if PageScroller.CanvasPosition.Y < pageHeight then
        PageScroller.CanvasPosition = Vector2.new(0, pageHeight)
        PageSwitchBtn.Text = "3"
    elseif PageScroller.CanvasPosition.Y < pageHeight * 2 then
        PageScroller.CanvasPosition = Vector2.new(0, pageHeight * 2)
        PageSwitchBtn.Text = "1"
    else
        PageScroller.CanvasPosition = Vector2.new(0, 0)
        PageSwitchBtn.Text = "2"
    end
end)

CloseBtn.Activated:Connect(function() ScreenGui:Destroy() end)
MakeDraggable(MainFrame, TopBar)

MainFrame.Visible = true
TweenService:Create(MainFrame, iOS_Out, {Size = UDim2.new(0, 800, 0, 500), GroupTransparency = 0}):Play()
_G.ShowPopupRef("XCWARE READY - " .. LocalPlayer.Name)
