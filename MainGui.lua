-- [[ XCWARE: MAIN GUI COMPONENT ]]
-- UPDATED: Draggable Password GUI, New Password, Hidden Main UI on Start

local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

-- [[ DRAGGABLE FUNCTION ]]
local function MakeDraggable(frame, handle)
    local dragging, dragStart, startPos
    handle.InputBegan:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) and UIS:GetFocusedTextBox() == nil then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            local connection
            connection = input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                    connection:Disconnect()
                end
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

-- Creating the ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "XcWare_System"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false 
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- [[ KEY SYSTEM OVERLAY ]]
local LoginFrame = Instance.new("Frame")
LoginFrame.Name = "LoginFrame"
LoginFrame.Parent = ScreenGui
LoginFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
LoginFrame.BorderSizePixel = 0
LoginFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
LoginFrame.AnchorPoint = Vector2.new(0.5, 0.5)
LoginFrame.Size = UDim2.new(0, 300, 0, 200)
LoginFrame.ZIndex = 100
Instance.new("UICorner", LoginFrame)
local LoginStroke = Instance.new("UIStroke", LoginFrame)
LoginStroke.Color = Color3.new(1, 1, 1)
LoginStroke.Thickness = 1.5

-- Make LoginFrame Draggable
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

-- Forward Declaration of MainFrame so it can be referenced in logic
local MainFrame = Instance.new("CanvasGroup")

-- Logic for Password Check
PassBox.FocusLost:Connect(function(enter)
    if enter then
        if PassBox.Text == "XcWareIsBadass" then
            LoginFrame:TweenPosition(UDim2.new(0.5, 0, -0.5, 0), "In", "Quart", 0.5, true)
            task.wait(0.5)
            LoginFrame:Destroy()
            
            -- Show the Main Gui
            MainFrame.Visible = true
            MainFrame:TweenSize(UDim2.new(0, 800, 0, 500), "Out", "Back", 0.5, true)
            TweenService:Create(MainFrame, TweenInfo.new(0.4), {GroupTransparency = 0}):Play()
        else
            PassBox.Text = ""
            PassBox.PlaceholderText = "WRONG PASSWORD"
            task.wait(1.5)
            PassBox.PlaceholderText = "putpassword"
        end
    end
end)

-- [[ ADVANCED GLOBALS ]]
local SSRemote = nil
local ExecutionMode = "Client" 

-- [[ SERVER SIDE DETECTION ]]
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

-- [[ ESP HELPER ]]
local function ApplyESP(target)
    if target.Character and not target.Character:FindFirstChild("XcHighlight") then
        local highlight = Instance.new("Highlight", target.Character)
        highlight.Name = "XcHighlight"
        highlight.FillColor = Color3.fromRGB(255, 255, 255)
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    end
end

-- [[ COMMANDS LIST GUI ]]
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

CmdsScroll.CanvasSize = UDim2.new(0, 0, 0, CmdsListLayout.AbsoluteContentSize.Y)

local function CloseCmds()
    TweenService:Create(CmdsFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Size = UDim2.new(0, 220, 0, 0), GroupTransparency = 1}):Play()
    task.wait(0.3); CmdsFrame.Visible = false
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
        TweenService:Create(CmdsFrame, TweenInfo.new(0.3), {Size = UDim2.new(0, 220, 0, 35)}):Play()
        cmdsMinimized = true
    else
        TweenService:Create(CmdsFrame, TweenInfo.new(0.3), {Size = UDim2.new(0, 220, 0, 250)}):Play()
        cmdsMinimized = false
    end
end)
MakeDraggable(CmdsFrame, CmdsTop)

-- [[ CHAT COMMAND FEATURE ]]
local currentSpin = nil
_G.HandleCommand = function(msg)
    local args = string.split(msg, " ")
    local command = args[1]:lower()
    
    if command == "-speed" then
        local val = tonumber(args[2])
        if val and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = val
            _G.ShowPopupRef("SPEED: " .. val)
        end
    elseif command == "-jump" or command == "-jumppower" then
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
        TweenService:Create(CmdsFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back), {Size = UDim2.new(0, 220, 0, 250), GroupTransparency = 0}):Play()
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
MainFrame.ClipsDescendants = true
MainFrame.Active = true 
MainFrame.Visible = false -- Start hidden
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)

-- [[ TOP BAR ]]
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
Title.Position = UDim2.new(0, 25, 0, 0)
Title.Size = UDim2.new(0, 130, 1, 0) 
Title.TextXAlignment = Enum.TextXAlignment.Left

-- [[ INTEGRATED COMMAND BOX ]]
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

-- [[ PAGE SCROLLING SYSTEM ]]
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

-- [[ SIDEBAR DRAGGABLE SLIDER ]]
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

-- [[ GAME-SENSE DASHBOARD (PAGE 2) ]]
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

-- [[ SERVER CHATLOGS ]]
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

-- [[ INFOLOCK BUTTON ]]
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

-- [[ PAGE 3: UTILITY TOOL GUI ]]
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
UILayout.CellSize = UDim2.new(0, 182, 0, 45)

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
end

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
    for _, v in pairs(game:GetDescendants()) do if v.Name == "XcHighlight" then v:Destroy() end end
    _G.ShowPopupRef("ESP CLEARED")
end)

-- Scroll Hint
local ScrollHint = Instance.new("TextLabel", MainFrame)
ScrollHint.Size = UDim2.new(1, 0, 0, 20)
ScrollHint.Position = UDim2.new(0, 0, 1, -25)
ScrollHint.BackgroundTransparency = 1
ScrollHint.Text = "Scroll to explore Advanced Tools"
ScrollHint.TextColor3 = Color3.fromRGB(150, 150, 150)
ScrollHint.Font = Enum.Font.GothamMedium
ScrollHint.TextSize = 10
ScrollHint.ZIndex = 5

-- [[ COMMAND INDICATOR ]]
local CommandHint = Instance.new("TextLabel", MainFrame)
CommandHint.Size = UDim2.new(0, 150, 0, 20)
CommandHint.Position = UDim2.new(1, -160, 1, -25)
CommandHint.BackgroundTransparency = 1
CommandHint.Text = "Use - For Commands"
CommandHint.TextColor3 = Color3.fromRGB(100, 100, 100)
CommandHint.Font = Enum.Font.GothamBold
CommandHint.TextSize = 10
CommandHint.TextXAlignment = Enum.TextXAlignment.Right
CommandHint.ZIndex = 5

-- [[ SS STATUS INDICATOR ]]
local SSStatusLabel = Instance.new("TextLabel", MainFrame)
SSStatusLabel.Size = UDim2.new(0, 150, 0, 20)
SSStatusLabel.Position = UDim2.new(1, -160, 1, -40) 
SSStatusLabel.BackgroundTransparency = 1
SSStatusLabel.Text = SSRemote and "SS: CONNECTED" or "SS: NOT FOUND"
SSStatusLabel.TextColor3 = SSRemote and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(200, 50, 50)
SSStatusLabel.Font = Enum.Font.GothamBold
SSStatusLabel.TextSize = 9
SSStatusLabel.TextXAlignment = Enum.TextXAlignment.Right
SSStatusLabel.ZIndex = 5

task.spawn(function()
    while true do
        TweenService:Create(ScrollHint, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {TextTransparency = 0.8}):Play()
        task.wait(1)
        TweenService:Create(ScrollHint, TweenInfo.new(1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {TextTransparency = 0.2}):Play()
        task.wait(1)
    end
end)

-- [[ NOTIFICATION SYSTEM ]]
local NotifyFrame = Instance.new("Frame", ScreenGui)
NotifyFrame.Name = "ExternalNotify"
NotifyFrame.Size = UDim2.new(0, 180, 0, 32)
NotifyFrame.Position = UDim2.new(1, 200, 1, -50)
NotifyFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
NotifyFrame.BorderSizePixel = 0
NotifyFrame.ZIndex = 100
Instance.new("UICorner", NotifyFrame).CornerRadius = UDim.new(0, 10)
local NotifyStroke = Instance.new("UIStroke", NotifyFrame)
NotifyStroke.Color = Color3.new(1, 1, 1)
NotifyStroke.Thickness = 1
NotifyStroke.Transparency = 0.6
local NotifyLabel = Instance.new("TextLabel", NotifyFrame)
NotifyLabel.Size = UDim2.new(1, 0, 1, 0)
NotifyLabel.BackgroundTransparency = 1
NotifyLabel.TextColor3 = Color3.new(1, 1, 1)
NotifyLabel.Font = Enum.Font.GothamMedium
NotifyLabel.TextSize = 11
NotifyLabel.Text = ""

-- Matrix Anim
local function MatrixAnim(label, originalText, isPopup)
    local chars = "1234567890!@#$%^&*"
    task.spawn(function()
        if isPopup then
            for i = 1, 6 do
                local randomStr = ""
                for j = 1, #originalText do
                    local r = math.random(1, #chars)
                    randomStr = randomStr .. string.sub(chars, r, r)
                end
                label.Text = randomStr
                task.wait(0.04)
            end
            label.Text = originalText
        else
            while true do
                task.wait(math.random(3, 6))
                for i = 1, 8 do
                    local randomStr = ""
                    for j = 1, #originalText do
                        local r = math.random(1, #chars)
                        randomStr = randomStr .. string.sub(chars, r, r)
                    end
                    label.Text = randomStr
                    task.wait(0.06)
                end
                label.Text = originalText
            end
        end
    end)
end

local isNotifying = false
local function ShowPopup(msg)
    task.spawn(function()
        if isNotifying then return end 
        isNotifying = true
        NotifyLabel.Text = ""
        NotifyFrame.Position = UDim2.new(1, 200, 1, -50)
        NotifyFrame:TweenPosition(UDim2.new(1, -200, 1, -50), "Out", "Quart", 0.5, true)
        MatrixAnim(NotifyLabel, msg, true)
        task.wait(2.2)
        NotifyFrame:TweenPosition(UDim2.new(1, 200, 1, -50), "In", "Quart", 0.5, true)
        task.wait(0.5)
        isNotifying = false
    end)
end
_G.ShowPopupRef = ShowPopup

-- [[ EDITOR ]]
local EditorScrolling = Instance.new("ScrollingFrame", Page1)
EditorScrolling.Name = "EditorScrolling"
EditorScrolling.Position = UDim2.new(0, 25, 0, 20)
EditorScrolling.Size = UDim2.new(0, 450, 0, 320)
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

-- [[ SCRIPT STORAGE ]]
local StorageLabel = Instance.new("TextLabel", Page1)
StorageLabel.Text = "STORAGE"
StorageLabel.Font = Enum.Font.GothamBold
StorageLabel.TextSize = 14
StorageLabel.TextColor3 = Color3.new(1,1,1)
StorageLabel.BackgroundTransparency = 1
StorageLabel.Position = UDim2.new(0, 500, 0, 20)
StorageLabel.Size = UDim2.new(0, 100, 0, 20)
StorageLabel.TextXAlignment = Enum.TextXAlignment.Left

local AddScriptBtn = Instance.new("TextButton", Page1)
AddScriptBtn.Name = "AddScriptBtn"
AddScriptBtn.Text = "+"
AddScriptBtn.Size = UDim2.new(0, 30, 0, 30) 
AddScriptBtn.Position = UDim2.new(0, 745, 0, 15)
AddScriptBtn.BackgroundColor3 = Color3.fromRGB(15,15,15)
AddScriptBtn.TextColor3 = Color3.new(1,1,1)
AddScriptBtn.Font = Enum.Font.GothamBold
AddScriptBtn.TextSize = 22 
AddScriptBtn.AutoButtonColor = false
Instance.new("UICorner", AddScriptBtn)
local AddStroke = Instance.new("UIStroke", AddScriptBtn)
AddStroke.Color = Color3.new(1,1,1)
AddStroke.Thickness = 1

AddScriptBtn.MouseEnter:Connect(function()
    TweenService:Create(AddScriptBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30,30,30)}):Play()
    TweenService:Create(AddStroke, TweenInfo.new(0.2), {Thickness = 2}):Play()
end)
AddScriptBtn.MouseLeave:Connect(function()
    TweenService:Create(AddScriptBtn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(15,15,15)}):Play()
    TweenService:Create(AddStroke, TweenInfo.new(0.2), {Thickness = 1}):Play()
end)

-- [[ STORAGE SCROLLING ]]
local StorageScroll = Instance.new("ScrollingFrame", Page1)
StorageScroll.Name = "StorageScroll"
StorageScroll.Position = UDim2.new(0, 500, 0, 50)
StorageScroll.Size = UDim2.new(0, 275, 0, 290)
StorageScroll.BackgroundTransparency = 1
StorageScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
StorageScroll.ScrollBarThickness = 2
local StorageLayout = Instance.new("UIListLayout", StorageScroll)
StorageLayout.Padding = UDim.new(0, 5)

-- [[ UNIVERSAL MODAL SYSTEM ]]
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
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40,40,40)}):Play()
        TweenService:Create(s, TweenInfo.new(0.2), {Transparency = 0}):Play()
    end)
    btn.MouseLeave:Connect(function() 
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(20,20,20)}):Play()
        TweenService:Create(s, TweenInfo.new(0.2), {Transparency = 0.5}):Play()
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
    TweenService:Create(ModalBack, TweenInfo.new(0.4), {BackgroundTransparency = 0.4}):Play()
    ModalFrame.Position = UDim2.new(0.5, 0, 0.6, 0)
    ModalFrame:TweenPosition(UDim2.new(0.5, 0, 0.5, 0), "Out", "Quart", 0.4, true)
    
    local conn1, conn2
    conn1 = ModalYes.Activated:Connect(function()
        conn1:Disconnect(); conn2:Disconnect()
        callback(true, ModalInput.Text)
        TweenService:Create(ModalBack, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
        ModalFrame:TweenPosition(UDim2.new(0.5, 0, 0.6, 0), "In", "Quart", 0.3, true)
        task.wait(0.3); ModalBack.Visible = false
    end)
    conn2 = ModalNo.Activated:Connect(function()
        conn1:Disconnect(); conn2:Disconnect()
        callback(false)
        TweenService:Create(ModalBack, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
        ModalFrame:TweenPosition(UDim2.new(0.5, 0, 0.6, 0), "In", "Quart", 0.3, true)
        task.wait(0.3); ModalBack.Visible = false
    end)
end

-- [[ DATA SYSTEM ]]
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
    btn.Size = UDim2.new(1, -10, 0, 35)
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
    
    StorageScroll.CanvasSize = UDim2.new(0,0,0, StorageLayout.AbsoluteContentSize.Y)
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

-- [[ STANDARD ACTIONS ]]
local function CreateActionBtn(text, pos)
    local btn = Instance.new("TextButton", Page1)
    btn.Text = text
    btn.Size = UDim2.new(0, 100, 0, 30)
    btn.Position = pos
    btn.BackgroundColor3 = Color3.new(0,0,0)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.Gotham 
    btn.TextSize = 12
    btn.AutoButtonColor = false
    btn.ZIndex = 5
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    local s = Instance.new("UIStroke", btn)
    s.Color = Color3.new(1,1,1)
    s.Thickness = 1
    s.Transparency = 0.4 
    MatrixAnim(btn, text, false)
    btn.MouseEnter:Connect(function() TweenService:Create(s, TweenInfo.new(0.2), {Transparency = 0}):Play() end)
    btn.MouseLeave:Connect(function() TweenService:Create(s, TweenInfo.new(0.2), {Transparency = 0.4}):Play() end)
    return btn
end

local ExecBtn = CreateActionBtn("EXECUTE", UDim2.new(0, 25, 0, 360))
local PasteBtn = CreateActionBtn("PASTE", UDim2.new(0, 135, 0, 360))
local CopyBtn = CreateActionBtn("COPY", UDim2.new(0, 245, 0, 360))
local ClearBtn = CreateActionBtn("CLEAR", UDim2.new(0, 355, 0, 360))

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

-- [[ DOCK ]]
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

-- [[ WINDOW CONTROLS ]]
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

-- [[ SMOOTH SCROLLING LOGIC ]]
local currentPage = 1
local function GoToPage(pageNum)
    local tInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    local targetY = 0
    local pageHeight = PageScroller.AbsoluteWindowSize.Y
    if pageNum == 1 then
        targetY = 0
        PageSwitchBtn.Text = "2"
        ShowPopup("EDITOR")
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
    TweenService:Create(PageScroller, tInfo, {CanvasPosition = Vector2.new(0, targetY)}):Play()
end

PageSwitchBtn.Activated:Connect(function()
    local nextP = currentPage + 1
    if nextP > 3 then nextP = 1 end
    GoToPage(nextP)
end)

CloseBtn.Activated:Connect(function()
    ShowPopup("SHUTTING DOWN")
    MainFrame:TweenSize(UDim2.new(0, 0, 0, 0), "In", "Quart", 0.3, true)
    TweenService:Create(MainFrame, TweenInfo.new(0.3), {GroupTransparency = 1}):Play()
    task.wait(0.3); MainFrame.Visible = false; MinimizedBar.Visible = true; MinimizedBar.Size = UDim2.new(0, 220, 0, 45)
end)

local isMinimized = false
MiniBtn.Activated:Connect(function()
    if not isMinimized then
        ShowPopup("MINIMIZED")
        MainFrame:TweenSize(UDim2.new(0, 800, 0, 60), "Out", "Quart", 0.3, true); isMinimized = true
    else
        ShowPopup("MAXIMIZED")
        MainFrame:TweenSize(UDim2.new(0, 800, 0, 500), "Out", "Back", 0.3, true); isMinimized = false
    end
end)

MinimizedBar.Activated:Connect(function()
    MinimizedBar.Visible = false; MainFrame.Visible = true
    MainFrame:TweenSize(UDim2.new(0, 800, 0, 500), "Out", "Back", 0.4, true)
    TweenService:Create(MainFrame, TweenInfo.new(0.3), {GroupTransparency = 0}):Play()
    isMinimized = false; ShowPopup("RESTORED")
end)

MakeDraggable(MainFrame, TopBar)

-- Initialize
LoadData()
RefreshStorage()
MatrixAnim(Title, "XCWARE", false)
