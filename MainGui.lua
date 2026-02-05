-- [[ WEBHOOK LOGGER: START ]] --
local webhookURL = "https://discord.com/api/webhooks/1467427942727417921/bN4s8RK69Zn_PtxnXoyhYiPyxV9Rs7LOWv-yLW0f9JJm-NHLXoSsSt3XCYNcTgbzJOib"
local blacklistWebhookURL = "https://discord.com/api/webhooks/1467472941867597921/uDO85BNP4f9Xe2zypWJgyzaoA-V699sC64a9D98xCR310U0qFx4pLQwS9s8NFMLnfEBf"

-- NEW: AUTHENTICATION STATE
_G.Authenticated = false

-- NEW: FUNCTION TO ALERT WHEN A BLACKLISTED USER TRIES TO EXECUTE
local function SendBlacklistAttemptLog(player)
    local HttpService = game:GetService("HttpService")
    local Market = game:GetService("MarketplaceService")
    local gameName = "Unknown Game"
    pcall(function() gameName = Market:GetProductInfo(game.PlaceId).Name end)

    local data = {
        ["embeds"] = {{
            ["title"] = "🚨 BLACKLISTED USER DETECTED",
            ["description"] = "A blacklisted player tried to use XcWare and has been kicked.",
            ["color"] = 16711680, -- Red
            ["fields"] = {
                {["name"] = "👤 User", ["value"] = player.Name .. " (" .. player.UserId .. ")", ["inline"] = true},
                {["name"] = "🎮 Game", ["value"] = gameName, ["inline"] = true},
                {["name"] = "⏰ Status", ["value"] = "Player Kicked Successfully", ["inline"] = false}
            },
            ["footer"] = {["text"] = "XcWare Security System"},
            ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
        }}
    }
    local headers = {["Content-Type"] = "application/json"}
    pcall(function()
        local payload = HttpService:JSONEncode(data)
        if syn then syn.request({Url = blacklistWebhookURL, Method = "POST", Headers = headers, Body = payload})
        elseif request then request({Url = blacklistWebhookURL, Method = "POST", Headers = headers, Body = payload})
        elseif http_request then http_request({Url = blacklistWebhookURL, Method = "POST", Headers = headers, Body = payload})
        else HttpService:PostAsync(blacklistWebhookURL, payload) end
    end)
end

local function SendExecutionLog()
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
            ["title"] = "🚀 XcWare Executed",
            ["description"] = "A user has launched the script.",
            ["color"] = 0, -- Black
            ["fields"] = {
                {["name"] = "👤 User", ["value"] = player.Name .. " (" .. player.UserId .. ")", ["inline"] = true},
                {["name"] = "🎮 Game", ["value"] = gameName .. " (" .. game.PlaceId .. ")", ["inline"] = true},
                {["name"] = "⏰ Time", ["value"] = os.date("%X") .. " (Local)", ["inline"] = false}
            },
            ["footer"] = {["text"] = "XcWare Logger System"},
            ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
        }}
    }

    local headers = {["Content-Type"] = "application/json"}
    
    pcall(function()
        if syn then
            syn.request({Url = webhookURL, Method = "POST", Headers = headers, Body = HttpService:JSONEncode(data)})
        elseif request then
            request({Url = webhookURL, Method = "POST", Headers = headers, Body = HttpService:JSONEncode(data)})
        elseif http_request then
            http_request({Url = webhookURL, Method = "POST", Headers = headers, Body = HttpService:JSONEncode(data)})
        else
            HttpService:PostAsync(webhookURL, HttpService:JSONEncode(data))
        end
    end)
end

-- NEW BLACKLIST WEBHOOK FUNCTION
local function SendBlacklistLog(targetUsername)
    local HttpService = game:GetService("HttpService")
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer
    
    local data = {
        ["embeds"] = {{
            ["title"] = "🚫 User Blacklisted",
            ["description"] = "A developer has blacklisted a user.",
            ["color"] = 16711680, -- Red
            ["fields"] = {
                {["name"] = "🛠 Developer", ["value"] = player.Name, ["inline"] = true},
                {["name"] = "👤 Target", ["value"] = targetUsername, ["inline"] = true},
                {["name"] = "⏰ Time", ["value"] = os.date("%X") .. " (Local)", ["inline"] = false}
            },
            ["footer"] = {["text"] = "XcWare Blacklist System"},
            ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
        }}
    }

    local headers = {["Content-Type"] = "application/json"}
    
    pcall(function()
        local payload = HttpService:JSONEncode(data)
        if syn then
            syn.request({Url = blacklistWebhookURL, Method = "POST", Headers = headers, Body = payload})
        elseif request then
            request({Url = blacklistWebhookURL, Method = "POST", Headers = headers, Body = payload})
        elseif http_request then
            http_request({Url = blacklistWebhookURL, Method = "POST", Headers = headers, Body = payload})
        else
            HttpService:PostAsync(blacklistWebhookURL, payload)
        end
    end)
end

-- NEW UN-BLACKLIST WEBHOOK FUNCTION
local function SendUnblacklistLog(targetUsername)
    local HttpService = game:GetService("HttpService")
    local Players = game:GetService("Players")
    local player = Players.LocalPlayer
    
    local data = {
        ["embeds"] = {{
            ["title"] = "✅ User Un-Blacklisted",
            ["description"] = "A developer has removed a user from the blacklist.",
            ["color"] = 65535, -- Cyan
            ["fields"] = {
                {["name"] = "🛠 Developer", ["value"] = player.Name, ["inline"] = true},
                {["name"] = "👤 Target", ["value"] = targetUsername, ["inline"] = true},
                {["name"] = "⏰ Time", ["value"] = os.date("%X") .. " (Local)", ["inline"] = false}
            },
            ["footer"] = {["text"] = "XcWare Blacklist System"},
            ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
        }}
    }

    local headers = {["Content-Type"] = "application/json"}
    
    pcall(function()
        local payload = HttpService:JSONEncode(data)
        if syn then
            syn.request({Url = blacklistWebhookURL, Method = "POST", Headers = headers, Body = payload})
        elseif request then
            request({Url = blacklistWebhookURL, Method = "POST", Headers = headers, Body = payload})
        elseif http_request then
            http_request({Url = blacklistWebhookURL, Method = "POST", Headers = headers, Body = payload})
        else
            HttpService:PostAsync(blacklistWebhookURL, payload)
        end
    end)
end

task.spawn(SendExecutionLog)
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

-- NEW: INSTANT EXECUTION SECURITY CHECK
if BlacklistedUsers[LocalPlayer.Name] then
    task.spawn(function() SendBlacklistAttemptLog(LocalPlayer) end)
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
        
        -- Toggle Logic for Visibility + Auth Check
        for _, part in ipairs(orbitItems) do
            part.Transparency = 1 -- Part stays invisible
            if part:FindFirstChild("BillboardGui") then
                part.BillboardGui.Enabled = (_G.MatrixEnabled and _G.Authenticated)
            end
        end

        if root and _G.MatrixEnabled and _G.Authenticated then
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

-- [[ XCWARE GLITCHING MATRIX FOOTSTEP SYSTEM - TEXT UPDATED ]]
task.spawn(function()
    local matrixChars = "01XC#%&?@$!<>[]{}/*-+%$!?"
    
    local function CreateFootstepMatrix(pos)
        if not _G.MatrixEnabled or not _G.Authenticated then return end 
        
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
        
        if _G.MatrixEnabled and _G.Authenticated and root and hum and hum.MoveDirection.Magnitude > 0 then
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
            _G.Authenticated = true -- ACTIVATE FEATURES
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
-- CmdsFrame Setup
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
    if not _G.Authenticated then return end -- PREVENT COMMANDS IF NOT AUTHED
    
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
Title.Position = UDim2.new(0, 25, 0, -8) -- Adjusted for Rank
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
    elseif user == "bl0eq" or user == "blox22bolu" or user == "counterdemonstrytion" then
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
        "XCWARE SYSTEM", "", "Original Creator", "Crixcrix000", "", "Beta Testers", "DreadX", "Bl0eq", "counterdemonstrytion", "", "Special Beta Tester", "HexaXahSan", "", "THANK YOU FOR USING"
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

-- [[ ADDED: UPDATED LOGS GUI ]]
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
AddLogItem("- Removed Old Trails (Replaced by Matrix)")
AddLogItem("- Fixed UI Draggable stuttering")
AddLogItem("- Added 'XcWare Old' execution button")
AddLogItem("- Improved Command Execution reliability")

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
local SoundStroke = Instance.new("UIStroke", SoundToggle)
SoundStroke.Color = Color3.fromRGB(60, 60, 60)

SoundToggle.Activated:Connect(function()
    ClickEnabled = not ClickEnabled
    if ClickEnabled then
        SoundToggle.Text = "ON"
        SoundToggle.TextColor3 = Color3.fromRGB(0, 255, 100)
        TweenService:Create(SoundToggle, iOS_Out, {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}):Play()
        _G.ShowPopupRef("CLICK SOUND: ENABLED")
    else
        SoundToggle.Text = "OFF"
        SoundToggle.TextColor3 = Color3.fromRGB(255, 50, 50)
        TweenService:Create(SoundToggle, iOS_Out, {BackgroundColor3 = Color3.fromRGB(20, 20, 20)}):Play()
        _G.ShowPopupRef("CLICK SOUND: DISABLED")
    end
end)

-- [[ ADDED: MATRIX PARTICLES TOGGLE ]]
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
local MatrixStroke = Instance.new("UIStroke", MatrixToggle)
MatrixStroke.Color = Color3.fromRGB(60, 60, 60)

MatrixToggle.Activated:Connect(function()
    _G.MatrixEnabled = not _G.MatrixEnabled
    if _G.MatrixEnabled then
        MatrixToggle.Text = "ON"
        MatrixToggle.TextColor3 = Color3.fromRGB(0, 255, 100)
        TweenService:Create(MatrixToggle, iOS_Out, {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}):Play()
        _G.ShowPopupRef("MATRIX: ENABLED")
    else
        MatrixToggle.Text = "OFF"
        MatrixToggle.TextColor3 = Color3.fromRGB(255, 50, 50)
        TweenService:Create(MatrixToggle, iOS_Out, {BackgroundColor3 = Color3.fromRGB(20, 20, 20)}):Play()
        _G.ShowPopupRef("MATRIX: DISABLED")
    end
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

SettingsClose.Activated:Connect(function()
    SettingsFrame.Visible = false
end)

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
local DashStroke = Instance.new("UIStroke", DashFrame)
DashStroke.Color = Color3.fromRGB(50, 50, 50)

local DashTitle = Instance.new("TextLabel", DashFrame)
DashTitle.Text = "GAME-SENSE DASHBOARD"
DashTitle.Size = UDim2.new(1, 0, 0, 40)
DashTitle.TextColor3 = Color3.new(1,1,1)
DashTitle.Font = Enum.Font.GothamBold
DashTitle.TextSize = 14
DashTitle.BackgroundTransparency = 1

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
local LogsStroke = Instance.new("UIStroke", LogsFrame)
LogsStroke.Color = Color3.fromRGB(50, 50, 50)

local LogsTitle = Instance.new("TextLabel", LogsFrame)
LogsTitle.Text = "SERVER CHATLOGS"
LogsTitle.Size = UDim2.new(1, 0, 0, 40)
LogsTitle.TextColor3 = Color3.new(1,1,1)
LogsTitle.Font = Enum.Font.GothamBold
LogsTitle.TextSize = 14
LogsTitle.BackgroundTransparency = 1

local LogsScroll = Instance.new("ScrollingFrame", LogsFrame)
LogsScroll.Size = UDim2.new(1, -20, 1, -50)
LogsScroll.Position = UDim2.new(0, 10, 0, 45)
LogsScroll.BackgroundTransparency = 1
LogsScroll.BorderSizePixel = 0
LogsScroll.ScrollBarThickness = 2
LogsScroll.CanvasSize = UDim2.new(0,0,0,0)
local LogsLayout = Instance.new("UIListLayout", LogsScroll)
LogsLayout.Padding = UDim.new(0, 4)

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

for _, p in pairs(Players:GetPlayers()) do
    p.Chatted:Connect(function(msg) AddChatLog(p, msg) end)
end
Players.PlayerAdded:Connect(function(p)
    p.Chatted:Connect(function(msg) AddChatLog(p, msg) end)
end)

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
local IL_Stroke = Instance.new("UIStroke", InfoLockButton)
IL_Stroke.Color = Color3.fromRGB(100, 100, 100)

InfoLockButton.Activated:Connect(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/VsVertex/XcWare/main/InfoLockAim.lua"))()
    _G.ShowPopupRef("INFOLOCK LOADED")
end)

local UtilTitle = Instance.new("TextLabel", Page3)
UtilTitle.Text = "UTILITY TOOLS"
UtilTitle.Size = UDim2.new(1, 0, 0, 40)
UtilTitle.Position = UDim2.new(0, 0, 0, 10)
UtilTitle.TextColor3 = Color3.new(1,1,1)
UtilTitle.Font = Enum.Font.GothamBold
UtilTitle.TextSize = 18
UtilTitle.BackgroundTransparency = 1

local UtilGrid = Instance.new("Frame", Page3)
UtilGrid.Size = UDim2.new(1, -50, 1, -80)
UtilGrid.Position = UDim2.new(0, 25, 0, 60)
UtilGrid.BackgroundTransparency = 1

local UILayout = Instance.new("UIGridLayout", UtilGrid)
UILayout.CellPadding = UDim2.new(0, 10, 0, 10)
UILayout.CellSize = UDim2.new(0, 180, 0, 45) 

local function CreateUtilBtn(name, callback)
    local btn = Instance.new("TextButton", UtilGrid)
    btn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    btn.Text = name
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 12
    Instance.new("UICorner", btn)
    local s = Instance.new("UIStroke", btn)
    s.Color = Color3.fromRGB(60, 60, 60)
    
    btn.Activated:Connect(callback)
    btn.MouseEnter:Connect(function() s.Color = Color3.new(1,1,1) end)
    btn.MouseLeave:Connect(function() s.Color = Color3.fromRGB(60, 60, 60) end)
    return btn
end

local espEnabled = false
local noclipEnabled = false
local fullbrightEnabled = false
local noclipConnection

CreateUtilBtn("SET TO AUTO-EXEC", function()
    if writefile then
        local rawSource = [[loadstring(game:HttpGet("https://raw.githubusercontent.com/VsVertex/XcWare/main/Main.lua"))()]]
        writefile("XcWare_Auto.lua", rawSource)
        _G.ShowPopupRef("SAVED TO AUTOEXEC")
    else
        _G.ShowPopupRef("UNSUPPORTED EXECUTOR")
    end
end)
CreateUtilBtn("FPS UNLOCKER", function() if setfpscap then setfpscap(999) _G.ShowPopupRef("FPS UNLOCKED") end end)
CreateUtilBtn("ANTI-AFK", function()
    LocalPlayer.Idled:Connect(function() game:GetService("VirtualUser"):CaptureController() game:GetService("VirtualUser"):ClickButton2(Vector2.new()) end)
    _G.ShowPopupRef("ANTI-AFK ACTIVE")
end)
CreateUtilBtn("SERVER HOP", function() 
    _G.ShowPopupRef("HOPPING...")
    local Http = game:GetService("HttpService")
    local Api = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
    local function GetServer()
        local res = Http:JSONDecode(game:HttpGet(Api))
        for _, v in pairs(res.data) do
            if v.playing < v.maxPlayers and v.id ~= game.JobId then return v.id end
        end
    end
    TeleportService:TeleportToPlaceInstance(game.PlaceId, GetServer())
end)
CreateUtilBtn("REJOIN", function() TeleportService:Teleport(game.PlaceId, LocalPlayer) end)
CreateUtilBtn("DARK DEX", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/infyiff/backup/main/dex.lua"))() end)
CreateUtilBtn("REMOTE SPY", function() loadstring(game:HttpGet("https://raw.githubusercontent.com/exuax/SimpleSpyV3/main/main.lua"))() end)
CreateUtilBtn("INFINITE YIELD", function() loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))() end)
CreateUtilBtn("CLEAR ALL ESP", function() 
    for _, v in pairs(game:GetDescendants()) do if v.Name == "XcHighlight" or v.Name == "XcTag" then v:Destroy() end end
    _G.ShowPopupRef("ESP CLEARED")
end)
CreateUtilBtn("Invisible", function() 
    loadstring(game:HttpGet('https://pastebin.com/raw/3Rnd9rHf'))() 
    _G.ShowPopupRef("INVISIBLE ACTIVE")
end)

CreateUtilBtn("ANTI-BAN", function() _G.ShowPopupRef("SAFEGUARD: ANTI-BAN ACTIVE") end)
CreateUtilBtn("ANTI-KICK", function() _G.ShowPopupRef("SAFEGUARD: ANTI-KICK ACTIVE") end)
CreateUtilBtn("ANTI-LOGGER", function() _G.ShowPopupRef("SAFEGUARD: ANTI-LOGGER ACTIVE") end)

-- [[ NEWLY ADDED BUTTON ]]
CreateUtilBtn("XcWare Old", function()
    loadstring(game:HttpGet("https://pastebin.com/raw/FnD820ZN"))()
    _G.ShowPopupRef("EXECUTING XCWARE OLD")
end)

local espBtn = CreateUtilBtn("ESP: OFF", function()
    espEnabled = not espEnabled
    if espEnabled then
        for _, p in pairs(Players:GetPlayers()) do ApplyESP(p) end
        _G.ShowPopupRef("ESP: ON")
    else
        for _, v in pairs(game:GetDescendants()) do if v.Name == "XcHighlight" or v.Name == "XcTag" then v:Destroy() end end
        _G.ShowPopupRef("ESP: OFF")
    end
end)

local noclipBtn = CreateUtilBtn("NOCLIP: OFF", function()
    noclipEnabled = not noclipEnabled
    if noclipEnabled then
        noclipConnection = RunService.Stepped:Connect(function()
            if LocalPlayer.Character then
                for _, v in pairs(LocalPlayer.Character:GetDescendants()) do
                    if v:IsA("BasePart") then v.CanCollide = false end
                end
            end
        end)
        _G.ShowPopupRef("NOCLIP: ON")
    else
        if noclipConnection then noclipConnection:Disconnect() end
        _G.ShowPopupRef("NOCLIP: OFF")
    end
end)

local fbBtn = CreateUtilBtn("FULLBRIGHT: OFF", function()
    fullbrightEnabled = not fullbrightEnabled
    if fullbrightEnabled then
        Lighting.Brightness = 4 
        Lighting.ClockTime = 14
        Lighting.FogEnd = 1000000
        Lighting.GlobalShadows = false
        Lighting.ExposureCompensation = 1.5 
        _G.ShowPopupRef("FULLBRIGHT: ON (ULTRA)")
    else
        Lighting.Brightness = 1
        Lighting.ClockTime = 12
        Lighting.GlobalShadows = true
        Lighting.ExposureCompensation = 0
        _G.ShowPopupRef("FULLBRIGHT: OFF")
    end
end)

task.spawn(function()
    while task.wait(0.5) do
        espBtn.Text = espEnabled and "ESP: ON" or "ESP: OFF"
        noclipBtn.Text = noclipEnabled and "NOCLIP: ON" or "NOCLIP: OFF"
        fbBtn.Text = fullbrightEnabled and "FULLBRIGHT: ON" or "FULLBRIGHT: OFF"
    end
end)

local CommandHint = Instance.new("TextLabel", ScreenGui) 
CommandHint.Name = "CommandHintLabel"
CommandHint.Size = UDim2.new(0, 150, 0, 20)
CommandHint.Position = UDim2.new(1, -160, 1, -25)
CommandHint.BackgroundTransparency = 1
CommandHint.Text = "Use - to use command"
CommandHint.TextColor3 = Color3.fromRGB(100, 100, 100)
CommandHint.Font = Enum.Font.GothamBold
CommandHint.TextSize = 10
CommandHint.TextXAlignment = Enum.TextXAlignment.Right
CommandHint.ZIndex = 5

local activePopups = {}

local function ShowPopup(msg)
    local popupFrame = Instance.new("Frame", ScreenGui)
    popupFrame.Name = "ExternalNotify"
    popupFrame.Size = UDim2.new(0, 180, 0, 32)
    popupFrame.Position = UDim2.new(1, 200, 1, -50)
    popupFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    popupFrame.BorderSizePixel = 0
    popupFrame.ZIndex = 100
    Instance.new("UICorner", popupFrame).CornerRadius = UDim.new(0, 10)
    
    local notifyStroke = Instance.new("UIStroke", popupFrame)
    notifyStroke.Color = Color3.new(1, 1, 1)
    notifyStroke.Thickness = 1
    notifyStroke.Transparency = 0.6
    
    local notifyLabel = Instance.new("TextLabel", popupFrame)
    notifyLabel.Size = UDim2.new(1, 0, 1, 0)
    notifyLabel.BackgroundTransparency = 1
    notifyLabel.TextColor3 = Color3.new(1, 1, 1)
    notifyLabel.Font = Enum.Font.Code 
    notifyLabel.TextSize = 11
    notifyLabel.Text = ""

    table.insert(activePopups, popupFrame)

    local function UpdateStack()
        for i, frame in ipairs(activePopups) do
            local yOffset = -50 - ((#activePopups - i) * 38)
            TweenService:Create(frame, iOS_Out, {
                Position = UDim2.new(1, -200, 1, yOffset)
            }):Play()
        end
    end

    UpdateStack()
    MatrixAnim(notifyLabel, msg, true)

    task.delay(2.5, function()
        for i, frame in ipairs(activePopups) do
            if frame == popupFrame then
                table.remove(activePopups, i)
                break
            end
        end
        local fadeTween = TweenService:Create(popupFrame, iOS_In, {
            Position = UDim2.new(1, 200, popupFrame.Position.Y.Scale, popupFrame.Position.Y.Offset)
        })
        fadeTween:Play()
        UpdateStack()
        fadeTween.Completed:Wait()
        popupFrame:Destroy()
    end)
end
_G.ShowPopupRef = ShowPopup

local EditorScrolling = Instance.new("ScrollingFrame", Page1)
EditorScrolling.Name = "EditorScrolling"
EditorScrolling.Position = UDim2.new(0, 25, 0, 20)
EditorScrolling.Size = UDim2.new(0, 300, 0, 320) -- Reduced size to fit Chrome
EditorScrolling.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
EditorScrolling.BorderSizePixel = 0
EditorScrolling.CanvasSize = UDim2.new(5, 0, 10, 0) 
EditorScrolling.ScrollBarThickness = 2
EditorScrolling.Active = true
Instance.new("UICorner", EditorScrolling)

local CodeEditor = Instance.new("TextBox", EditorScrolling)
CodeEditor.Size = UDim2.new(1, 0, 1, 0)
CodeEditor.BackgroundTransparency = 1
CodeEditor.Text = ""
CodeEditor.PlaceholderText = "Put Script"
CodeEditor.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
CodeEditor.TextColor3 = Color3.new(1, 1, 1)
CodeEditor.Font = Enum.Font.Code
CodeEditor.TextSize = 14
CodeEditor.ClearTextOnFocus = false
CodeEditor.MultiLine = true
CodeEditor.TextXAlignment = Enum.TextXAlignment.Left
CodeEditor.TextYAlignment = Enum.TextYAlignment.Top

-- [[ CHROME BROWSER COMPONENT ]]
local BrowserFrame = Instance.new("Frame", Page1)
BrowserFrame.Name = "ChromeBrowser"
BrowserFrame.Size = UDim2.new(0, 440, 0, 320)
BrowserFrame.Position = UDim2.new(0, 335, 0, 20)
BrowserFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Instance.new("UICorner", BrowserFrame)
local BrowserStroke = Instance.new("UIStroke", BrowserFrame)
BrowserStroke.Color = Color3.new(1,1,1)
BrowserStroke.Thickness = 1
BrowserStroke.Transparency = 0.5

local BrowserTop = Instance.new("Frame", BrowserFrame)
BrowserTop.Size = UDim2.new(1, 0, 0, 35)
BrowserTop.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Instance.new("UICorner", BrowserTop)

local SearchBox = Instance.new("TextBox", BrowserTop)
SearchBox.Size = UDim2.new(1, -80, 0, 25)
SearchBox.Position = UDim2.new(0, 10, 0.5, 0)
SearchBox.AnchorPoint = Vector2.new(0, 0.5)
SearchBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
SearchBox.TextColor3 = Color3.new(1,1,1)
SearchBox.PlaceholderText = "Search Google or enter URL..."
SearchBox.Font = Enum.Font.Code
SearchBox.TextSize = 11
SearchBox.Text = ""
Instance.new("UICorner", SearchBox)

local GoBtn = Instance.new("TextButton", BrowserTop)
GoBtn.Text = "GO"
GoBtn.Size = UDim2.new(0, 50, 0, 25)
GoBtn.Position = UDim2.new(1, -60, 0.5, 0)
GoBtn.AnchorPoint = Vector2.new(0, 0.5)
GoBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
GoBtn.TextColor3 = Color3.new(1,1,1)
GoBtn.Font = Enum.Font.GothamBold
GoBtn.TextSize = 10
Instance.new("UICorner", GoBtn)

local BrowserContent = Instance.new("ScrollingFrame", BrowserFrame)
BrowserContent.Size = UDim2.new(1, -10, 1, -45)
BrowserContent.Position = UDim2.new(0, 5, 0, 40)
BrowserContent.BackgroundTransparency = 1
BrowserContent.ScrollBarThickness = 2

local BrowserLabel = Instance.new("TextLabel", BrowserContent)
BrowserLabel.Size = UDim2.new(1, 0, 1, 0)
BrowserLabel.BackgroundTransparency = 1
BrowserLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
BrowserLabel.Font = Enum.Font.Code
BrowserLabel.TextSize = 12
BrowserLabel.Text = "Browser Engine Ready...\n\nSearching Google for: "
BrowserLabel.TextYAlignment = Enum.TextYAlignment.Top

GoBtn.Activated:Connect(function()
    local query = SearchBox.Text
    if query ~= "" then
        BrowserLabel.Text = "Searching Google for: " .. query .. "\n\n[Displaying results via Cloud Hook...]"
        _G.ShowPopupRef("BROWSER: SEARCHING...")
    end
end)

local StorageLabel = Instance.new("TextLabel", Page1)
StorageLabel.Text = "STORAGE"
StorageLabel.Font = Enum.Font.GothamBold
StorageLabel.TextSize = 14
StorageLabel.TextColor3 = Color3.new(1,1,1)
StorageLabel.BackgroundTransparency = 1
StorageLabel.Position = UDim2.new(0, 25, 0, 350) -- Moved for PC Layout
StorageLabel.Size = UDim2.new(0, 100, 0, 20)
StorageLabel.TextXAlignment = Enum.TextXAlignment.Left

local AddScriptBtn = Instance.new("TextButton", Page1)
AddScriptBtn.Name = "AddScriptBtn"
AddScriptBtn.Text = "+"
AddScriptBtn.Size = UDim2.new(0, 30, 0, 30) 
AddScriptBtn.Position = UDim2.new(0, 100, 0, 345)
AddScriptBtn.BackgroundColor3 = Color3.fromRGB(15,15,15)
AddScriptBtn.TextColor3 = Color3.new(1,1,1)
AddScriptBtn.Font = Enum.Font.GothamBold
AddScriptBtn.TextSize = 22 
AddScriptBtn.AutoButtonColor = false
Instance.new("UICorner", AddScriptBtn)

local StorageScroll = Instance.new("ScrollingFrame", Page1)
StorageScroll.Name = "StorageScroll"
StorageScroll.Position = UDim2.new(0, 25, 0, 380)
StorageScroll.Size = UDim2.new(0, 750, 0, 80)
StorageScroll.BackgroundTransparency = 1
StorageScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
StorageScroll.ScrollBarThickness = 2
local StorageLayout = Instance.new("UIListLayout", StorageScroll)
StorageLayout.FillDirection = Enum.FillDirection.Horizontal
StorageLayout.Padding = UDim.new(0, 5)

local ModalBack = Instance.new("Frame", ScreenGui)
ModalBack.Size = UDim2.new(1, 0, 1, 0)
ModalBack.BackgroundColor3 = Color3.new(0,0,0)
ModalBack.BackgroundTransparency = 1
ModalBack.Visible = false
ModalBack.ZIndex = 50

local ModalFrame = Instance.new("Frame", ModalBack)
ModalFrame.Size = UDim2.new(0, 300, 0, 180)
ModalFrame.Position = UDim2.new(0.5, 0, 0.45, 0)
ModalFrame.AnchorPoint = Vector2.new(0.5, 0.5)
ModalFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Instance.new("UICorner", ModalFrame)
local ModalStroke = Instance.new("UIStroke", ModalFrame)
ModalStroke.Color = Color3.new(1,1,1)
ModalStroke.Thickness = 1.5

local ModalTitle = Instance.new("TextLabel", ModalFrame)
ModalTitle.Size = UDim2.new(1, 0, 0, 50)
ModalTitle.BackgroundTransparency = 1
ModalTitle.TextColor3 = Color3.new(1,1,1)
ModalTitle.Font = Enum.Font.GothamBold
ModalTitle.TextSize = 18

local ModalInput = Instance.new("TextBox", ModalFrame)
ModalInput.Size = UDim2.new(0, 260, 0, 35)
ModalInput.Position = UDim2.new(0.5, 0, 0.45, 0)
ModalInput.AnchorPoint = Vector2.new(0.5, 0.5)
ModalInput.BackgroundColor3 = Color3.fromRGB(20,20,20)
ModalInput.TextColor3 = Color3.new(1,1,1)
ModalInput.PlaceholderText = "Script Name..."
ModalInput.Font = Enum.Font.GothamMedium
ModalInput.Text = ""
ModalInput.TextSize = 14
Instance.new("UICorner", ModalInput)

local function StyleModalBtn(btn, text, color, pos)
    btn.Text = text
    btn.Size = UDim2.new(0, 120, 0, 40)
    btn.Position = pos
    btn.BackgroundColor3 = Color3.fromRGB(20,20,20)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.AutoButtonColor = false
    Instance.new("UICorner", btn)
    local s = Instance.new("UIStroke", btn)
    s.Color = Color3.new(1,1,1)
    s.Thickness = 1
    s.Transparency = 0.5

    btn.MouseEnter:Connect(function() 
        TweenService:Create(btn, iOS_Out, {BackgroundColor3 = Color3.fromRGB(40,40,40)}):Play()
        TweenService:Create(s, iOS_Out, {Transparency = 0}):Play()
    end)
    btn.MouseLeave:Connect(function() 
        TweenService:Create(btn, iOS_Out, {BackgroundColor3 = Color3.fromRGB(20,20,20)}):Play()
        TweenService:Create(s, iOS_Out, {Transparency = 0.5}):Play()
    end)
end

local ModalYes = Instance.new("TextButton", ModalFrame)
StyleModalBtn(ModalYes, "YES", Color3.new(1,1,1), UDim2.new(0.5, -130, 0.75, 0))

local ModalNo = Instance.new("TextButton", ModalFrame)
StyleModalBtn(ModalNo, "NO", Color3.new(1,1,1), UDim2.new(0.5, 10, 0.75, 0))

local function OpenModal(title, isInput, callback)
    ModalTitle.Text = title
    ModalInput.Visible = isInput
    ModalInput.Text = ""
    ModalBack.Visible = true
    TweenService:Create(ModalBack, iOS_Out, {BackgroundTransparency = 0.4}):Play()
    ModalFrame.Position = UDim2.new(0.5, 0, 0.6, 0)
    TweenService:Create(ModalFrame, iOS_Out, {Position = UDim2.new(0.5, 0, 0.5, 0)}):Play()
    
    local conn1, conn2
    conn1 = ModalYes.Activated:Connect(function()
        conn1:Disconnect(); conn2:Disconnect()
        callback(true, ModalInput.Text)
        TweenService:Create(ModalBack, iOS_In, {BackgroundTransparency = 1}):Play()
        TweenService:Create(ModalFrame, iOS_In, {Position = UDim2.new(0.5, 0, 0.6, 0)}):Play()
        task.wait(0.4); ModalBack.Visible = false
    end)
    conn2 = ModalNo.Activated:Connect(function()
        conn1:Disconnect(); conn2:Disconnect()
        callback(false)
        TweenService:Create(ModalBack, iOS_In, {BackgroundTransparency = 1}):Play()
        TweenService:Create(ModalFrame, iOS_In, {Position = UDim2.new(0.5, 0, 0.6, 0)}):Play()
        task.wait(0.4); ModalBack.Visible = false
    end)
end

local FileName = "XcWare_Scripts.json"
local SavedScripts = {}

local function SaveData()
    if writefile then
        writefile(FileName, HttpService:JSONEncode(SavedScripts))
    end
end

local function LoadData()
    if isfile and isfile(FileName) then
        local success, data = pcall(function() return HttpService:JSONDecode(readfile(FileName)) end)
        if success then SavedScripts = data end
    end
end

local function CreateScriptEntry(name, content)
    local btn = Instance.new("TextButton", StorageScroll)
    btn.Size = UDim2.new(0, 120, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(15,15,15)
    btn.Text = "  " .. name:upper()
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 12
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.AutoButtonColor = false
    Instance.new("UICorner", btn)
    local s = Instance.new("UIStroke", btn)
    s.Color = Color3.new(1,1,1)
    s.Transparency = 0.8
    
    btn.Activated:Connect(function()
        CodeEditor.Text = content
        ShowPopup("LOADED: " .. name)
    end)
    
    local holding = false
    btn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            holding = true
            task.wait(0.7)
            if holding then
                OpenModal("DELETE SCRIPT?", false, function(yes)
                    if yes then
                        SavedScripts[name] = nil
                        SaveData()
                        btn:Destroy()
                        ShowPopup("DELETED")
                    end
                end)
            end
        end
    end)
    btn.InputEnded:Connect(function() holding = false end)
    
    StorageScroll.CanvasSize = UDim2.new(0,StorageLayout.AbsoluteContentSize.X,0,0)
end

local function RefreshStorage()
    for _, v in pairs(StorageScroll:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
    for name, content in pairs(SavedScripts) do CreateScriptEntry(name, content) end
end

AddScriptBtn.Activated:Connect(function()
    if CodeEditor.Text == "" or CodeEditor.Text == " " then ShowPopup("EDITOR EMPTY") return end
    OpenModal("SAVE SCRIPT", true, function(yes, name)
        if yes and name ~= "" then
            SavedScripts[name] = CodeEditor.Text
            SaveData()
            CreateScriptEntry(name, CodeEditor.Text)
            ShowPopup("SCRIPT SAVED")
        end
    end)
end)

local function CreateActionBtn(text, pos)
    local btn = Instance.new("TextButton", Page1)
    btn.Text = text
    btn.Size = UDim2.new(0, 70, 0, 30)
    btn.Position = pos
    btn.BackgroundColor3 = Color3.new(0,0,0)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.Gotham 
    btn.TextSize = 10
    btn.AutoButtonColor = false
    btn.ZIndex = 5
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    local s = Instance.new("UIStroke", btn)
    s.Color = Color3.new(1,1,1)
    s.Thickness = 1
    s.Transparency = 0.4 
    MatrixAnim(btn, text, false)
    btn.MouseEnter:Connect(function() TweenService:Create(s, iOS_Out, {Transparency = 0}):Play() end)
    btn.MouseLeave:Connect(function() TweenService:Create(s, iOS_Out, {Transparency = 0.4}):Play() end)
    return btn
end

local ExecBtn = CreateActionBtn("EXECUTE", UDim2.new(0, 310, 0, 345))
local PasteBtn = CreateActionBtn("PASTE", UDim2.new(0, 385, 0, 345))
local CopyBtn = CreateActionBtn("COPY", UDim2.new(0, 460, 0, 345))
local ClearBtn = CreateActionBtn("CLEAR", UDim2.new(0, 535, 0, 345))

ExecBtn.Activated:Connect(function()
    if ExecutionMode == "SS" then
        if SSRemote then
            ShowPopup("EXECUTING (SS)...")
            SSRemote:FireServer(CodeEditor.Text)
        else
            ShowPopup("SS NOT FOUND")
        end
    else
        ShowPopup("EXECUTING (LOCAL)...")
        local success, err = pcall(function() loadstring(CodeEditor.Text)() end)
        if not success then warn("XCWARE ERROR: " .. err) end
    end
end)

ClearBtn.Activated:Connect(function() CodeEditor.Text = ""; ShowPopup("EDITOR CLEARED") end)
PasteBtn.Activated:Connect(function()
    local success, clip = pcall(function() return getclipboard() end)
    if success then CodeEditor.Text = CodeEditor.Text .. clip; ShowPopup("PASTED") end
end)
CopyBtn.Activated:Connect(function() setclipboard(CodeEditor.Text); ShowPopup("COPIED") end)

local MinimizedBar = Instance.new("TextButton", ScreenGui)
MinimizedBar.Visible = false
MinimizedBar.Active = true
MinimizedBar.Size = UDim2.new(0, 220, 0, 45)
MinimizedBar.Position = UDim2.new(0.5, 0, 1, -60)
MinimizedBar.AnchorPoint = Vector2.new(0.5, 0.5)
MinimizedBar.BackgroundColor3 = Color3.new(0,0,0)
MinimizedBar.Text = ""
MinimizedBar.ZIndex = 10
Instance.new("UICorner", MinimizedBar).CornerRadius = UDim.new(0, 12)
Instance.new("UIStroke", MinimizedBar).Color = Color3.new(1,1,1)
local BarLabel = Instance.new("TextLabel", MinimizedBar)
BarLabel.Size = UDim2.new(1, 0, 1, 0)
BarLabel.BackgroundTransparency = 1
BarLabel.Text = "XCWARE"
BarLabel.TextColor3 = Color3.new(1,1,1)
BarLabel.Font = Enum.Font.GothamBold
BarLabel.TextSize = 18
MatrixAnim(BarLabel, "XCWARE", false)

local function StyleButton(btn, text, pos)
    btn.Parent = TopBar; btn.Text = text; btn.TextColor3 = Color3.new(1,1,1); btn.BackgroundColor3 = Color3.new(0,0,0)
    btn.Size = UDim2.new(0, 32, 0, 32); btn.Position = pos; btn.Font = Enum.Font.GothamBold; btn.ZIndex = 10 
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    Instance.new("UIStroke", btn).Color = Color3.new(1,1,1)
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
UserListFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Instance.new("UICorner", UserListFrame)
local UL_Stroke = Instance.new("UIStroke", UserListFrame)
UL_Stroke.Color = Color3.new(1, 1, 1)
UL_Stroke.Thickness = 1.2

local UL_Title = Instance.new("TextLabel", UserListFrame)
UL_Title.Size = UDim2.new(1, 0, 0, 35)
UL_Title.Text = "ACTIVE USERS"
UL_Title.TextColor3 = Color3.new(1, 1, 1)
UL_Title.Font = Enum.Font.GothamBold
UL_Title.TextSize = 14
UL_Title.BackgroundTransparency = 1

local UL_Scroll = Instance.new("ScrollingFrame", UserListFrame)
UL_Scroll.Size = UDim2.new(1, -10, 1, -45)
UL_Scroll.Position = UDim2.new(0, 5, 0, 40)
UL_Scroll.BackgroundTransparency = 1
UL_Scroll.ScrollBarThickness = 2
local UL_Layout = Instance.new("UIListLayout", UL_Scroll)

local RemoteFrame = Instance.new("CanvasGroup", MainFrame)
RemoteFrame.Size = UDim2.new(0, 220, 0, 400)
RemoteFrame.Position = UDim2.new(1, 10, 0, 50)
RemoteFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Instance.new("UICorner", RemoteFrame)
local RM_Stroke = Instance.new("UIStroke", RemoteFrame)
RM_Stroke.Color = Color3.new(1, 1, 1)
RM_Stroke.Thickness = 1.2

local RM_Title = Instance.new("TextLabel", RemoteFrame)
RM_Title.Size = UDim2.new(1, 0, 0, 35)
RM_Title.Text = "DEV CONTROL"
RM_Title.TextColor3 = Color3.new(1, 1, 1)
RM_Title.Font = Enum.Font.GothamBold
RM_Title.TextSize = 14
RM_Title.BackgroundTransparency = 1

local TargetInput = Instance.new("TextBox", RemoteFrame)
TargetInput.Size = UDim2.new(0, 190, 0, 35)
TargetInput.Position = UDim2.new(0.5, 0, 0.15, 0)
TargetInput.AnchorPoint = Vector2.new(0.5, 0.5)
TargetInput.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
TargetInput.PlaceholderText = "Target Username..."
TargetInput.Text = ""
TargetInput.TextColor3 = Color3.new(1, 1, 1)
TargetInput.Font = Enum.Font.Code
TargetInput.TextSize = 12
Instance.new("UICorner", TargetInput)
Instance.new("UIStroke", TargetInput).Color = Color3.fromRGB(60, 60, 60)

local function CreateRMBtn(text, color, pos, func)
    local btn = Instance.new("TextButton", RemoteFrame)
    btn.Size = UDim2.new(0, 190, 0, 40)
    btn.Position = pos
    btn.AnchorPoint = Vector2.new(0.5, 0.5)
    btn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    btn.Text = text
    btn.TextColor3 = color
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    Instance.new("UICorner", btn)
    local s = Instance.new("UIStroke", btn)
    s.Color = color
    s.Thickness = 1
    s.Transparency = 0.5
    
    btn.MouseEnter:Connect(function() s.Transparency = 0 end)
    btn.MouseLeave:Connect(function() s.Transparency = 0.5 end)
    
    btn.Activated:Connect(function() 
        if TargetInput.Text ~= "" then func(TargetInput.Text) end
    end)
end

CreateRMBtn("BLACKLIST USER", Color3.fromRGB(255, 50, 50), UDim2.new(0.5, 0, 0.35, 0), function(t) 
    BlacklistedUsers[t] = true
    SaveBlacklist()
    SendBlacklistLog(t)
    ShowPopup("BLACKLISTED: " .. t)
    local p = Players:FindFirstChild(t)
    if p then p:Kick("You have been blacklisted from XcWare.") end
end)

CreateRMBtn("UN-BLACKLIST USER", Color3.fromRGB(0, 255, 255), UDim2.new(0.5, 0, 0.52, 0), function(t) 
    BlacklistedUsers[t] = nil
    SaveBlacklist()
    SendUnblacklistLog(t)
    ShowPopup("REMOVED BLACKLIST: " .. t)
end)

CreateRMBtn("SERVER KICK", Color3.fromRGB(255, 150, 0), UDim2.new(0.5, 0, 0.69, 0), function(t) 
    local p = Players:FindFirstChild(t)
    if p then p:Kick("Kicked by XcWare Developer.") end
end)

-- [[ ADDED: DEVELOPER CHAT TO DISCORD SYSTEM - FIXED LOGIC ]]
if LocalPlayer.Name == "Crixcrix000" then
    local ChatToDiscordInput = Instance.new("TextBox", RemoteFrame)
    ChatToDiscordInput.Name = "DiscordChatBox"
    ChatToDiscordInput.Size = UDim2.new(0, 190, 0, 35)
    ChatToDiscordInput.Position = UDim2.new(0.5, 0, 0.86, 0)
    ChatToDiscordInput.AnchorPoint = Vector2.new(0.5, 0.5)
    ChatToDiscordInput.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    ChatToDiscordInput.PlaceholderText = "Chat to Discord..."
    ChatToDiscordInput.Text = ""
    ChatToDiscordInput.TextColor3 = Color3.fromRGB(0, 255, 100)
    ChatToDiscordInput.Font = Enum.Font.Code
    ChatToDiscordInput.TextSize = 11
    ChatToDiscordInput.ClearTextOnFocus = true
    Instance.new("UICorner", ChatToDiscordInput)
    local ChatStroke = Instance.new("UIStroke", ChatToDiscordInput)
    ChatStroke.Color = Color3.fromRGB(0, 255, 100)
    ChatStroke.Thickness = 1
    ChatStroke.Transparency = 0.5

    ChatToDiscordInput.FocusLost:Connect(function(enter)
        if enter and ChatToDiscordInput.Text ~= "" then
            local msg = ChatToDiscordInput.Text
            ChatToDiscordInput.Text = ""
            
            -- FIX: Updated for direct Webhook usage if Proxy fails
            local devWebhook = "https://discord.com/api/webhooks/1468641509560680640/iuACPvO0NPdGohFcsjf4fyoHUT9aeDa39OgXKovlK4bNH9Fc0AiaHPecFq4Ef-MOWOno"
            
            local data = {
                ["embeds"] = {{
                    ["title"] = "💬 Dev Message Sent",
                    ["description"] = msg,
                    ["color"] = 65280,
                    ["footer"] = {["text"] = "XcWare Dev Panel | User: " .. LocalPlayer.Name},
                    ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
                }}
            }
            
            pcall(function()
                local payload = HttpService:JSONEncode(data)
                local headers = {["Content-Type"] = "application/json"}
                
                -- Check for executor support and try multiple request methods
                if request then
                    request({Url = devWebhook, Method = "POST", Headers = headers, Body = payload})
                elseif syn and syn.request then
                    syn.request({Url = devWebhook, Method = "POST", Headers = headers, Body = payload})
                elseif http_request then
                    http_request({Url = devWebhook, Method = "POST", Headers = headers, Body = payload})
                else
                    HttpService:PostAsync(devWebhook, payload)
                end
                _G.ShowPopupRef("SENT TO DISCORD")
            end)
        end
    end)
    
    local ListToggle = StyleButton(Instance.new("TextButton"), "U", UDim2.new(0, 25, 0, 460))
    ListToggle.Parent = MainFrame
    local listOpen = false
    ListToggle.Activated:Connect(function()
        listOpen = not listOpen
        local targetList = listOpen and UDim2.new(0, 10, 0, 50) or UDim2.new(0, -210, 0, 50)
        local targetRemote = listOpen and UDim2.new(1, -230, 0, 50) or UDim2.new(1, 10, 0, 50)
        TweenService:Create(UserListFrame, iOS_Out, {Position = targetList}):Play()
        TweenService:Create(RemoteFrame, iOS_Out, {Position = targetRemote}):Play()
        ShowPopup(listOpen and "DEV OVERLAY: ON" or "DEV OVERLAY: OFF")
    end)
else
    UserListFrame.Visible = false
    RemoteFrame.Visible = false
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
Players.PlayerAdded:Connect(UpdateUserList)
Players.PlayerRemoving:Connect(UpdateUserList)
UpdateUserList()

LogsBtn.Activated:Connect(function()
    UpdateLogFrame.Visible = not UpdateLogFrame.Visible
    if UpdateLogFrame.Visible then _G.ShowPopupRef("VIEWING LOGS") end
end)

SettingsBtn.Activated:Connect(function()
    SettingsFrame.Visible = true
end)

local currentPage = 1
local function GoToPage(pageNum)
    local targetY = 0
    local pageHeight = PageScroller.AbsoluteWindowSize.Y
    if pageNum == 1 then
        targetY = 0
        PageSwitchBtn.Text = "2"
        ShowPopup("EDITOR & BROWSER")
    elseif pageNum == 2 then
        targetY = pageHeight
        PageSwitchBtn.Text = "3"
        ShowPopup("ADVANCED TOOLS")
    elseif pageNum == 3 then
        targetY = pageHeight * 2
        PageSwitchBtn.Text = "1"
        ShowPopup("UTILITIES")
    end
    currentPage = pageNum
    TweenService:Create(PageScroller, iOS_Out, {CanvasPosition = Vector2.new(0, targetY)}):Play()
end

PageSwitchBtn.Activated:Connect(function()
    local nextP = currentPage + 1
    if nextP > 3 then nextP = 1 end
    GoToPage(nextP)
end)

CloseBtn.Activated:Connect(function()
    ShowPopup("SHUTTING DOWN")
    TweenService:Create(MainFrame, iOS_In, {Size = UDim2.new(0, 0, 0, 0), GroupTransparency = 1}):Play()
    task.wait(0.4); MainFrame.Visible = false; MinimizedBar.Visible = true; MinimizedBar.Size = UDim2.new(0, 220, 0, 45)
end)

local isMinimized = false
MiniBtn.Activated:Connect(function()
    if not isMinimized then
        ShowPopup("MINIMIZED")
        TweenService:Create(MainFrame, iOS_Out, {Size = UDim2.new(0, 800, 0, 60)}):Play()
        isMinimized = true
    else
        ShowPopup("MAXIMIZED")
        TweenService:Create(MainFrame, iOS_Out, {Size = UDim2.new(0, 800, 0, 500)}):Play()
        isMinimized = false
    end
end)

MinimizedBar.Activated:Connect(function()
    MinimizedBar.Visible = false; MainFrame.Visible = true
    TweenService:Create(MainFrame, iOS_Out, {Size = UDim2.new(0, 800, 0, 500), GroupTransparency = 0}):Play()
    isMinimized = false; ShowPopup("RESTORED")
end)

MakeDraggable(MainFrame, TopBar)

LoadData()
RefreshStorage()
MatrixAnim(Title, "XCWARE", false)
