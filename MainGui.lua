-- [[ WEBHOOK LOGGER: START ]] --
local webhookURL = "https://discord.com/api/webhooks/1467427942727417921/bN4s8RK69Zn_PtxnXoyhYiPyxV9Rs7LOWv-yLW0f9JJm-NHLXoSsSt3XCYNcTgbzJOib"

local function SendExecutionLog(customTitle, customDesc, fields)
    local HttpService = game:GetService("HttpService")
    local Players = game:GetService("Players")
    local Market = game:GetService("MarketplaceService")
    
    local player = Players.LocalPlayer or Players.PlayerAdded:Wait()
    local gameName = "Unknown Game"
    
    pcall(function()
        gameName = Market:GetProductInfo(game.PlaceId).Name
    end)

    local data = {
        ["embeds"] = {{
            ["title"] = customTitle or "🚀 XcWare Executed",
            ["description"] = customDesc or "A user has launched the script.",
            ["color"] = 0, -- Black
            ["fields"] = fields or {
                {["name"] = "👤 User", ["value"] = player.Name .. " (" .. player.UserId .. ")", ["inline"] = true},
                {["name"] = "🎮 Game", ["value"] = gameName .. " (" .. game.PlaceId .. ")", ["inline"] = true},
                {["name"] = "⏰ Time", ["value"] = os.date("%X") .. " (Local)", ["inline"] = false}
            },
            ["footer"] = {["text"] = "XcWare Security System"},
            ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
        }}
    }

    local headers = {["Content-Type"] = "application/json"}
    
    pcall(function()
        local requestFunc = syn and syn.request or request or http_request or (HttpService and function(t) HttpService:PostAsync(t.Url, t.Body) end)
        requestFunc({Url = webhookURL, Method = "POST", Headers = headers, Body = HttpService:JSONEncode(data)})
    end)
end

task.spawn(function() SendExecutionLog() end)
-- [[ WEBHOOK LOGGER: END ]] --

-- [[ XCWARE: MAIN GUI COMPONENT ]]
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer

-- [[ BLACKLIST SYSTEM ]]
local BlacklistFile = "XcWare_Blacklist.json"
local BlacklistedUsers = {}

local function SaveBlacklist()
    if writefile then writefile(BlacklistFile, HttpService:JSONEncode(BlacklistedUsers)) end
end

local function LoadBlacklist()
    if isfile and isfile(BlacklistFile) then
        local success, data = pcall(function() return HttpService:JSONDecode(readfile(BlacklistFile)) end)
        if success then BlacklistedUsers = data end
    end
end
LoadBlacklist()

-- Check if LocalPlayer is blacklisted on execution
if BlacklistedUsers[LocalPlayer.Name] or BlacklistedUsers[tostring(LocalPlayer.UserId)] then
    LocalPlayer:Kick("You have been blacklisted from XcWare.")
    return
end

-- Global Toggle State
_G.MatrixEnabled = true

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
            part.Transparency = 1 
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

AddLogItem("VERSION 2.1.0 - MATRIX UPDATE", true)
AddLogItem("- Added Glitching Matrix Footstep System")
AddLogItem("- Added Matrix Particles Toggle in Settings")
AddLogItem("- Added This Update Log GUI")
AddLogItem("- Fixed UI Draggable stuttering")
AddLogItem("- Added Remote Blacklist Control (Dev Only)")

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
    _G.ShowPopupRef("CLICK SOUND: " .. SoundToggle.Text)
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
    _G.ShowPopupRef("MATRIX: " .. MatrixToggle.Text)
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
PageScroller.ElasticBehavior = Enum.ElasticBehavior.Always

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
SliderThumb.BorderSizePixel = 0
Instance.new("UICorner", SliderThumb)

local isSliding = false
SliderThumb.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isSliding = true
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isSliding = false
    end
end)

UIS.InputChanged:Connect(function(input)
    if isSliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local mousePos = input.Position.Y
        local trackTop = SliderTrack.AbsolutePosition.Y
        local trackHeight = SliderTrack.AbsoluteSize.Y
        local thumbHeight = SliderThumb.AbsoluteSize.Y
        local relativeY = math.clamp(mousePos - trackTop - (thumbHeight / 2), 0, trackHeight - thumbHeight)
        local percent = relativeY / (trackHeight - thumbHeight)
        local maxScroll = PageScroller.AbsoluteWindowSize.Y * 2
        PageScroller.CanvasPosition = Vector2.new(0, percent * maxScroll)
    end
end)

PageScroller:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
    local maxScroll = PageScroller.AbsoluteWindowSize.Y * 2
    if maxScroll > 0 then
        local percent = math.clamp(PageScroller.CanvasPosition.Y / maxScroll, 0, 1)
        local trackHeight = SliderTrack.AbsoluteSize.Y
        local thumbHeight = SliderThumb.AbsoluteSize.Y
        SliderThumb.Position = UDim2.new(0, 0, 0, percent * (trackHeight - thumbHeight))
    end
end)

local Page1 = Instance.new("Frame", PageScroller)
Page1.Name = "Page1"
Page1.Size = UDim2.new(1, 0, 0.333, 0)
Page1.Position = UDim2.new(0, 0, 0, 0)
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
    LogsScroll.CanvasPosition = Vector2.new(0, LogsScroll.CanvasSize.Y.Offset)
end

for _, p in pairs(Players:GetPlayers()) do p.Chatted:Connect(function(msg) AddChatLog(p, msg) end) end
Players.PlayerAdded:Connect(function(p) p.Chatted:Connect(function(msg) AddChatLog(p, msg) end) end)

local InfoLockButton = Instance.new("TextButton")
InfoLockButton.Name = "InfoLockButton"
InfoLockButton.Parent = Page2
InfoLockButton.Size = UDim2.new(0, 750, 0, 45)
InfoLockButton.Position = UDim2.new(0, 25, 0, 295)
InfoLockButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20) 
InfoLockButton.Text = "LOAD INFOLOCK AIM"
InfoLockButton.TextColor3 = Color3.new(1,1,1)
InfoLockButton.Font = Enum.Font.GothamBold
InfoLockButton.TextSize = 14
Instance.new("UICorner", InfoLockButton)

InfoLockButton.Activated:Connect(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/VsVertex/XcWare/main/InfoLockAim.lua"))()
    _G.ShowPopupRef("INFOLOCK LOADED")
end)

local UtilGrid = Instance.new("Frame", Page3)
UtilGrid.Size = UDim2.new(1, -50, 1, -80)
UtilGrid.Position = UDim2.new(0, 25, 0, 60)
UtilGrid.BackgroundTransparency = 1
local UILayout = Instance.new("UIGridLayout", UtilGrid)
UILayout.CellSize = UDim2.new(0, 180, 0, 45) 

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

CreateUtilBtn("SET TO AUTO-EXEC", function()
    if writefile then
        writefile("XcWare_Auto.lua", [[loadstring(game:HttpGet("https://raw.githubusercontent.com/VsVertex/XcWare/main/Main.lua"))()]])
        _G.ShowPopupRef("SAVED TO AUTOEXEC")
    end
end)
CreateUtilBtn("FPS UNLOCKER", function() if setfpscap then setfpscap(999) _G.ShowPopupRef("FPS UNLOCKED") end end)
CreateUtilBtn("ANTI-AFK", function()
    LocalPlayer.Idled:Connect(function() game:GetService("VirtualUser"):CaptureController() game:GetService("VirtualUser"):ClickButton2(Vector2.new()) end)
    _G.ShowPopupRef("ANTI-AFK ACTIVE")
end)
CreateUtilBtn("SERVER HOP", function() TeleportService:Teleport(game.PlaceId, LocalPlayer) end)
CreateUtilBtn("REJOIN", function() TeleportService:Teleport(game.PlaceId, LocalPlayer) end)
CreateUtilBtn("DARK DEX", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/dex.lua"))() end)
CreateUtilBtn("INFINITE YIELD", function() loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))() end)
CreateUtilBtn("Invisible", function() loadstring(game:HttpGet('https://pastebin.com/raw/3Rnd9rHf'))() end)
CreateUtilBtn("XcWare Old", function() loadstring(game:HttpGet("https://pastebin.com/raw/FnD820ZN"))() end)

local activePopups = {}
local function ShowPopup(msg)
    local popupFrame = Instance.new("Frame", ScreenGui)
    popupFrame.Size = UDim2.new(0, 180, 0, 32)
    popupFrame.Position = UDim2.new(1, 200, 1, -50)
    popupFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    popupFrame.ZIndex = 100
    Instance.new("UICorner", popupFrame).CornerRadius = UDim.new(0, 10)
    
    local notifyLabel = Instance.new("TextLabel", popupFrame)
    notifyLabel.Size = UDim2.new(1, 0, 1, 0)
    notifyLabel.BackgroundTransparency = 1
    notifyLabel.TextColor3 = Color3.new(1, 1, 1)
    notifyLabel.Font = Enum.Font.Code 
    notifyLabel.TextSize = 11
    notifyLabel.Text = msg

    table.insert(activePopups, popupFrame)
    local function UpdateStack()
        for i, frame in ipairs(activePopups) do
            local yOffset = -50 - ((#activePopups - i) * 38)
            TweenService:Create(frame, iOS_Out, {Position = UDim2.new(1, -200, 1, yOffset)}):Play()
        end
    end
    UpdateStack()
    task.delay(2.5, function()
        for i, f in ipairs(activePopups) do if f == popupFrame then table.remove(activePopups, i) break end end
        local fade = TweenService:Create(popupFrame, iOS_In, {Position = UDim2.new(1, 200, popupFrame.Position.Y.Scale, popupFrame.Position.Y.Offset)})
        fade:Play(); fade.Completed:Wait(); popupFrame:Destroy(); UpdateStack()
    end)
end
_G.ShowPopupRef = ShowPopup

local EditorScrolling = Instance.new("ScrollingFrame", Page1)
EditorScrolling.Position = UDim2.new(0, 25, 0, 20)
EditorScrolling.Size = UDim2.new(0, 450, 0, 320)
EditorScrolling.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
Instance.new("UICorner", EditorScrolling)

local CodeEditor = Instance.new("TextBox", EditorScrolling)
CodeEditor.Size = UDim2.new(1, 0, 1, 0)
CodeEditor.BackgroundTransparency = 1
CodeEditor.TextColor3 = Color3.new(1, 1, 1)
CodeEditor.Font = Enum.Font.Code
CodeEditor.MultiLine = true
CodeEditor.TextXAlignment = Enum.TextXAlignment.Left
CodeEditor.TextYAlignment = Enum.TextYAlignment.Top

local function CreateActionBtn(text, pos)
    local btn = Instance.new("TextButton", Page1)
    btn.Text = text
    btn.Size = UDim2.new(0, 100, 0, 30)
    btn.Position = pos
    btn.BackgroundColor3 = Color3.new(0,0,0)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.Gotham 
    btn.TextSize = 12
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    return btn
end

local ExecBtn = CreateActionBtn("EXECUTE", UDim2.new(0, 25, 0, 360))
ExecBtn.Activated:Connect(function()
    loadstring(CodeEditor.Text)()
    ShowPopup("EXECUTING...")
end)

local function StyleButton(btn, text, pos)
    btn.Parent = TopBar; btn.Text = text; btn.TextColor3 = Color3.new(1,1,1); btn.BackgroundColor3 = Color3.new(0,0,0)
    btn.Size = UDim2.new(0, 32, 0, 32); btn.Position = pos; btn.Font = Enum.Font.GothamBold; btn.ZIndex = 10 
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    return btn
end

local CloseBtn = StyleButton(Instance.new("TextButton"), "X", UDim2.new(1, -50, 0, 14))
local MiniBtn = StyleButton(Instance.new("TextButton"), "-", UDim2.new(1, -95, 0, 14))
local PageSwitchBtn = StyleButton(Instance.new("TextButton"), "2", UDim2.new(1, -140, 0, 14))
local SettingsBtn = StyleButton(Instance.new("TextButton"), "⚙", UDim2.new(1, -185, 0, 14))
local LogsBtn = StyleButton(Instance.new("TextButton"), "L", UDim2.new(1, -230, 0, 14)) 

-- [[ DEV ONLY: USER LIST & REMOTE CONTROL ]]
local UserListFrame = Instance.new("CanvasGroup", MainFrame)
UserListFrame.Size = UDim2.new(0, 200, 0, 400)
UserListFrame.Position = UDim2.new(0, -210, 0, 50)
UserListFrame.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
Instance.new("UICorner", UserListFrame)

local UL_Scroll = Instance.new("ScrollingFrame", UserListFrame)
UL_Scroll.Size = UDim2.new(1, -10, 1, -40)
UL_Scroll.Position = UDim2.new(0, 5, 0, 35)
UL_Scroll.BackgroundTransparency = 1
local UL_Layout = Instance.new("UIListLayout", UL_Scroll)

local RemoteFrame = Instance.new("CanvasGroup", MainFrame)
RemoteFrame.Size = UDim2.new(0, 200, 0, 400)
RemoteFrame.Position = UDim2.new(1, 10, 0, 50)
RemoteFrame.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
Instance.new("UICorner", RemoteFrame)

local TargetInput = Instance.new("TextBox", RemoteFrame)
TargetInput.Size = UDim2.new(0, 180, 0, 30)
TargetInput.Position = UDim2.new(0.5, 0, 0.15, 0)
TargetInput.AnchorPoint = Vector2.new(0.5, 0.5)
TargetInput.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
TargetInput.PlaceholderText = "Username/ID"
TargetInput.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", TargetInput)

local function CreateRMBtn(text, color, pos, func)
    local btn = Instance.new("TextButton", RemoteFrame)
    btn.Size = UDim2.new(0, 180, 0, 35)
    btn.Position = pos
    btn.AnchorPoint = Vector2.new(0.5, 0.5)
    btn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    btn.Text = text
    btn.TextColor3 = color
    Instance.new("UICorner", btn)
    btn.Activated:Connect(function() if TargetInput.Text ~= "" then func(TargetInput.Text) end end)
end

-- DEVELOPER ACTIONS
CreateRMBtn("BLACKLIST USER", Color3.new(1, 0, 0), UDim2.new(0.5, 0, 0.3, 0), function(t) 
    BlacklistedUsers[t] = true
    SaveBlacklist()
    ShowPopup("BLACKLISTED: " .. t)
    
    -- Webhook Update
    SendExecutionLog("⚠️ USER BLACKLISTED", "The Developer has banned a user from XcWare.", {
        {["name"] = "Target User", ["value"] = t, ["inline"] = true},
        {["name"] = "Action By", ["value"] = LocalPlayer.Name, ["inline"] = true}
    })
    
    local p = Players:FindFirstChild(t)
    if p then p:Kick("You have been blacklisted from XcWare.") end
end)

CreateRMBtn("UN-BLACKLIST USER", Color3.new(0, 1, 1), UDim2.new(0.5, 0, 0.45, 0), function(t) 
    BlacklistedUsers[t] = nil
    SaveBlacklist()
    ShowPopup("REMOVED BLACKLIST: " .. t)
    
    SendExecutionLog("✅ USER UN-BLACKLISTED", "A user access has been restored.", {
        {["name"] = "Target User", ["value"] = t, ["inline"] = true}
    })
end)

-- ONLY SHOW DEV PANELS IF USERID MATCHES
if LocalPlayer.UserId == 12345678 or LocalPlayer.Name == "Crixcrix000" then -- Replace 12345678 with your actual ID
    local ListToggle = StyleButton(Instance.new("TextButton"), "U", UDim2.new(0, 25, 0, 460))
    ListToggle.Parent = MainFrame
    local listOpen = false
    ListToggle.Activated:Connect(function()
        listOpen = not listOpen
        local targetList = listOpen and UDim2.new(0, 10, 0, 50) or UDim2.new(0, -210, 0, 50)
        local targetRemote = listOpen and UDim2.new(1, -210, 0, 50) or UDim2.new(1, 10, 0, 50)
        TweenService:Create(UserListFrame, iOS_Out, {Position = targetList}):Play()
        TweenService:Create(RemoteFrame, iOS_Out, {Position = targetRemote}):Play()
    end)
else
    UserListFrame:Destroy()
    RemoteFrame:Destroy()
end

local function UpdateUserList()
    if LocalPlayer.Name ~= "Crixcrix000" then return end
    for _, v in pairs(UL_Scroll:GetChildren()) do if v:IsA("TextLabel") then v:Destroy() end end
    for _, p in pairs(Players:GetPlayers()) do
        local l = Instance.new("TextLabel", UL_Scroll)
        l.Size = UDim2.new(1, 0, 0, 25)
        l.BackgroundTransparency = 1
        l.Text = " > " .. p.Name
        l.TextColor3 = Color3.fromRGB(0, 255, 100) 
        l.Font = Enum.Font.Code
        l.TextSize = 11
        l.TextXAlignment = Enum.TextXAlignment.Left
    end
end
Players.PlayerAdded:Connect(UpdateUserList); Players.PlayerRemoving:Connect(UpdateUserList)
UpdateUserList()

LogsBtn.Activated:Connect(function() UpdateLogFrame.Visible = not UpdateLogFrame.Visible end)
SettingsBtn.Activated:Connect(function() SettingsFrame.Visible = true end)

local currentPage = 1
PageSwitchBtn.Activated:Connect(function()
    currentPage = (currentPage % 3) + 1
    local targetY = (currentPage - 1) * PageScroller.AbsoluteWindowSize.Y
    PageSwitchBtn.Text = tostring(currentPage == 3 and 1 or currentPage + 1)
    TweenService:Create(PageScroller, iOS_Out, {CanvasPosition = Vector2.new(0, targetY)}):Play()
end)

CloseBtn.Activated:Connect(function() ScreenGui:Destroy() end)
MakeDraggable(MainFrame, TopBar)
MainFrame.Visible = false
MatrixAnim(Title, "XCWARE", false)
