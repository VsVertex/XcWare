-- XcMono
-- ui by crix

local P=game:GetService("Players")
local T=game:GetService("TweenService")
local UIS=game:GetService("UserInputService")

local pl=P.LocalPlayer
if not pl then return end

local pg=pl:WaitForChild("PlayerGui",10)
if not pg then return end

local GN="XcMono"
local PH=8*3600

local C={
    panel=Color3.fromRGB(255,255,255),
    panelTop=Color3.fromRGB(248,248,250),
    track=Color3.fromRGB(244,244,247),
    button=Color3.fromRGB(240,240,244),
    buttonHover=Color3.fromRGB(232,232,236),
    buttonPressed=Color3.fromRGB(210,210,216),
    border=Color3.fromRGB(210,210,216),
    text=Color3.fromRGB(20,20,25),
    subText=Color3.fromRGB(120,120,130),
    accent=Color3.fromRGB(0,0,0),
    sidebar=Color3.fromRGB(246,246,248),
    activeTab=Color3.fromRGB(225,225,232),
    pill=Color3.fromRGB(20,20,25),
    pillText=Color3.fromRGB(240,240,245),
}

for _,n in ipairs({GN})do
    local a=pg:FindFirstChild(n)
    if a then a:Destroy()end
    local b=pl:FindFirstChild(n)
    if b then b:Destroy()end
end

local function stroke(o,col,t,tr)
    local s=Instance.new("UIStroke")
    s.Color=col or C.border
    s.Thickness=t or 1
    s.Transparency=tr or 0
    s.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
    s.LineJoinMode=Enum.LineJoinMode.Miter
    s.Parent=o
    return s
end

local function tw(o,d,p,st,dr)
    local a=T:Create(o,TweenInfo.new(d,st or Enum.EasingStyle.Quint,dr or Enum.EasingDirection.Out),p)
    a:Play()
    return a
end

local function crispText(lbl)
    pcall(function()
        lbl.TextScaled=false
        lbl.RichText=false
    end)
end

local gui=Instance.new("ScreenGui")
gui.Name=GN
gui.ResetOnSpawn=false
gui.DisplayOrder=999
gui.IgnoreGuiInset=true
gui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling
gui.Enabled=true

local parented=false
pcall(function()
    gui.Parent=pg
    parented=true
end)

if not parented then
    pcall(function()
        gui.Parent=game:GetService("CoreGui")
    end)
end

-- ══════════════════════════════════════════════════════════════════
--  MAIN PANEL
-- ══════════════════════════════════════════════════════════════════
local frame=Instance.new("Frame")
frame.Name="MainPanel"
frame.Size=UDim2.new(0,520,0,320)
frame.Position=UDim2.new(0,12,0.5,-160)
frame.BackgroundColor3=C.panel
frame.BorderSizePixel=0
frame.ClipsDescendants=true
frame.Active=true
frame.Parent=gui
stroke(frame,C.border,1,0)

local OPEN_POS=UDim2.new(0,12,0.5,-160)
local OPEN_SIZE=UDim2.new(0,520,0,320)
local TOP_SIZE=UDim2.new(0,520,0,40)

-- ══════════════════════════════════════════════════════════════════
--  TOP BAR
-- ══════════════════════════════════════════════════════════════════
local topBar=Instance.new("Frame")
topBar.Name="TopBar"
topBar.Size=UDim2.new(1,0,0,40)
topBar.Position=UDim2.new(0,0,0,0)
topBar.BackgroundColor3=C.panelTop
topBar.BorderSizePixel=0
topBar.Active=true
topBar.Parent=frame

local topBarStroke=Instance.new("UIStroke")
topBarStroke.Color=C.border
topBarStroke.Thickness=1
topBarStroke.Transparency=0
topBarStroke.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
topBarStroke.LineJoinMode=Enum.LineJoinMode.Miter
topBarStroke.Parent=topBar

local titleLbl=Instance.new("TextLabel")
titleLbl.Size=UDim2.new(0,200,1,0)
titleLbl.Position=UDim2.new(0,16,0,0)
titleLbl.BackgroundTransparency=1
titleLbl.Font=Enum.Font.GothamBold
titleLbl.Text="XcMono"
titleLbl.TextColor3=C.text
titleLbl.TextSize=15
titleLbl.TextXAlignment=Enum.TextXAlignment.Left
crispText(titleLbl)
titleLbl.Parent=topBar

local timeLbl=Instance.new("TextLabel")
timeLbl.Size=UDim2.new(0,200,1,0)
timeLbl.Position=UDim2.new(1,-216,0,0)
timeLbl.BackgroundTransparency=1
timeLbl.Font=Enum.Font.Code
timeLbl.Text="12:00:00 AM PHT"
timeLbl.TextColor3=C.subText
timeLbl.TextSize=11
timeLbl.TextXAlignment=Enum.TextXAlignment.Right
crispText(timeLbl)
timeLbl.Parent=topBar

local function phTime()
    local t=os.date("!*t",os.time()+PH)
    local p=t.hour>=12 and "PM" or "AM"
    local dh=t.hour%12
    if dh==0 then dh=12 end
    return string.format("%02d:%02d:%02d %s PHT",dh,t.min,t.sec,p)
end

task.spawn(function()
    while timeLbl and timeLbl.Parent do
        timeLbl.Text=phTime()
        task.wait(1)
    end
end)

-- ══════════════════════════════════════════════════════════════════
--  SIDEBAR
-- ══════════════════════════════════════════════════════════════════
local sidebar=Instance.new("Frame")
sidebar.Name="Sidebar"
sidebar.Size=UDim2.new(0,100,1,-40)
sidebar.Position=UDim2.new(0,0,0,40)
sidebar.BackgroundColor3=C.sidebar
sidebar.BorderSizePixel=0
sidebar.ClipsDescendants=true
sidebar.Parent=frame

local sideStroke=Instance.new("UIStroke")
sideStroke.Color=C.border
sideStroke.Thickness=1
sideStroke.Transparency=0
sideStroke.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
sideStroke.LineJoinMode=Enum.LineJoinMode.Miter
sideStroke.Parent=sidebar

local sideLayout=Instance.new("UIListLayout")
sideLayout.Padding=UDim.new(0,0)
sideLayout.SortOrder=Enum.SortOrder.LayoutOrder
sideLayout.Parent=sidebar

local homeTab=Instance.new("TextButton")
homeTab.Name="HomeTab"
homeTab.Size=UDim2.new(1,0,0,36)
homeTab.Position=UDim2.new(0,0,0,0)
homeTab.BackgroundColor3=C.activeTab
homeTab.BorderSizePixel=0
homeTab.Font=Enum.Font.GothamMedium
homeTab.Text="  Home"
homeTab.TextColor3=C.text
homeTab.TextSize=11
homeTab.TextXAlignment=Enum.TextXAlignment.Left
homeTab.AutoButtonColor=false
homeTab.LayoutOrder=1
homeTab.Parent=sidebar

local homeStroke=Instance.new("UIStroke")
homeStroke.Color=C.border
homeStroke.Thickness=1
homeStroke.Transparency=0
homeStroke.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
homeStroke.LineJoinMode=Enum.LineJoinMode.Miter
homeStroke.Parent=homeTab

crispText(homeTab)

-- ══════════════════════════════════════════════════════════════════
--  CONTENT AREA
-- ══════════════════════════════════════════════════════════════════
local contentArea=Instance.new("Frame")
contentArea.Name="ContentArea"
contentArea.Size=UDim2.new(1,-100,1,-40)
contentArea.Position=UDim2.new(0,100,0,40)
contentArea.BackgroundColor3=C.panel
contentArea.BorderSizePixel=0
contentArea.ClipsDescendants=true
contentArea.Parent=frame

local homePage=Instance.new("Frame")
homePage.Name="HomePage"
homePage.Size=UDim2.new(1,0,1,0)
homePage.Position=UDim2.new(0,0,0,0)
homePage.BackgroundTransparency=1
homePage.Visible=true
homePage.Parent=contentArea

local homeLabel=Instance.new("TextLabel")
homeLabel.Size=UDim2.new(1,0,0,20)
homeLabel.Position=UDim2.new(0,16,0,16)
homeLabel.BackgroundTransparency=1
homeLabel.Font=Enum.Font.GothamBold
homeLabel.Text="HOME"
homeLabel.TextColor3=C.text
homeLabel.TextSize=13
homeLabel.TextXAlignment=Enum.TextXAlignment.Left
crispText(homeLabel)
homeLabel.Parent=homePage

local homeSub=Instance.new("TextLabel")
homeSub.Size=UDim2.new(1,-32,0,16)
homeSub.Position=UDim2.new(0,16,0,38)
homeSub.BackgroundTransparency=1
homeSub.Font=Enum.Font.Gotham
homeSub.Text="welcome to XcMono"
homeSub.TextColor3=C.subText
homeSub.TextSize=10
homeSub.TextXAlignment=Enum.TextXAlignment.Left
crispText(homeSub)
homeSub.Parent=homePage

-- ══════════════════════════════════════════════════════════════════
--  COLLAPSED PILL (clock only, centered)
-- ══════════════════════════════════════════════════════════════════
local pill=Instance.new("TextButton")
pill.Name="Pill"
pill.Size=UDim2.new(0,120,0,22)
pill.Position=UDim2.new(0.5,-60,-40,0)
pill.BackgroundColor3=C.pill
pill.BorderSizePixel=0
pill.Text=""
pill.AutoButtonColor=false
pill.Visible=false
pill.ZIndex=20
pill.Parent=gui

local pillStroke=Instance.new("UIStroke")
pillStroke.Color=C.border
pillStroke.Thickness=1
pillStroke.Transparency=0.2
pillStroke.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
pillStroke.LineJoinMode=Enum.LineJoinMode.Miter
pillStroke.Parent=pill

local pillClock=Instance.new("TextLabel")
pillClock.Size=UDim2.new(1,0,1,0)
pillClock.Position=UDim2.new(0,0,0,0)
pillClock.BackgroundTransparency=1
pillClock.Font=Enum.Font.Code
pillClock.Text="12:00:00 AM PHT"
pillClock.TextColor3=C.pillText
pillClock.TextSize=11
pillClock.TextXAlignment=Enum.TextXAlignment.Center
crispText(pillClock)
pillClock.Parent=pill

local PILL_W_SMALL=120
local PILL_W_LARGE=520
local PILL_H=22
local PILL_TOP=6

local function pillPosAtWidth(w)
    return UDim2.new(0.5,-w/2,PILL_TOP,0)
end

local PILL_SHOWN_SMALL=pillPosAtWidth(PILL_W_SMALL)
local PILL_HIDDEN=UDim2.new(0.5,-PILL_W_SMALL/2,-PILL_H-8,0)

task.spawn(function()
    while pillClock and pillClock.Parent do
        pillClock.Text=phTime()
        task.wait(1)
    end
end)

-- ══════════════════════════════════════════════════════════════════
--  DRAG
-- ══════════════════════════════════════════════════════════════════
local dragging=false
local dragStart=nil
local startPos=nil
local activeInput=nil
local dragTarget=nil

local function beginDrag(input, target)
    dragging=true
    activeInput=input
    dragStart=input.Position
    startPos=target.Position
    dragTarget=target
end

local function stopDrag(input)
    if activeInput and input~=activeInput then return end
    dragging=false
    activeInput=nil
    dragTarget=nil
end

topBar.InputBegan:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.MouseButton1
        or input.UserInputType==Enum.UserInputType.Touch then
        beginDrag(input, frame)
    end
end)

topBar.InputEnded:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.MouseButton1
        or input.UserInputType==Enum.UserInputType.Touch then
        stopDrag(input)
    end
end)

pill.InputBegan:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.MouseButton1
        or input.UserInputType==Enum.UserInputType.Touch then
        beginDrag(input, pill)
    end
end)

pill.InputEnded:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.MouseButton1
        or input.UserInputType==Enum.UserInputType.Touch then
        stopDrag(input)
    end
end)

UIS.InputChanged:Connect(function(input)
    if not dragging then return end
    if activeInput and input~=activeInput then return end
    if input.UserInputType==Enum.UserInputType.MouseMovement
        or input.UserInputType==Enum.UserInputType.Touch then
        local delta=input.Position-dragStart
        if dragTarget then
            dragTarget.Position=UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset+math.floor(delta.X+0.5),
                startPos.Y.Scale,
                startPos.Y.Offset+math.floor(delta.Y+0.5)
            )
        end
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.MouseButton1
        or input.UserInputType==Enum.UserInputType.Touch then
        stopDrag(input)
    end
end)

-- ══════════════════════════════════════════════════════════════════
--  COLLAPSE / EXPAND (stretch + slide)
-- ══════════════════════════════════════════════════════════════════
local collapsed=false
local busy=false

local function collapse()
    if busy or collapsed then return end
    busy=true
    collapsed=true

    -- 1. retract the panel body upward (sidebar + content shrink to 0)
    tw(contentArea,0.30,{
        Size=UDim2.new(1,-100,0,0)
    },Enum.EasingStyle.Quart,Enum.EasingDirection.In)

    tw(sidebar,0.30,{
        Size=UDim2.new(0,100,0,0)
    },Enum.EasingStyle.Quart,Enum.EasingDirection.In)

    -- shrink frame height down to topbar only
    tw(frame,0.30,{
        Size=TOP_SIZE
    },Enum.EasingStyle.Quart,Enum.EasingDirection.In)

    task.wait(0.26)

    -- 2. slide the topbar up off-screen
    tw(frame,0.28,{
        Position=UDim2.new(0,12,-60,0)
    },Enum.EasingStyle.Quint,Enum.EasingDirection.In)

    task.wait(0.18)

    -- 3. pill appears at small width, at top of screen
    pill.Size=UDim2.new(0,PILL_W_SMALL,0,PILL_H)
    pill.Position=PILL_HIDDEN
    pill.BackgroundTransparency=0
    pill.Visible=true

    -- slide down into view
    tw(pill,0.22,{
        Position=PILL_SHOWN_SMALL
    },Enum.EasingStyle.Quint,Enum.EasingDirection.Out)

    task.wait(0.30)
    frame.Visible=false
    busy=false
end

local function expand()
    if busy or not collapsed then return end
    busy=true

    -- 1. slide pill up out of view
    tw(pill,0.20,{
        Position=PILL_HIDDEN
    },Enum.EasingStyle.Quint,Enum.EasingDirection.In)

    task.wait(0.16)
    pill.Visible=false
    pill.Size=UDim2.new(0,PILL_W_SMALL,0,PILL_H)
    pill.Position=PILL_SHOWN_SMALL

    -- 2. show frame at top, only topbar height, off-screen
    frame.Visible=true
    frame.Size=TOP_SIZE
    frame.Position=UDim2.new(0,12,-60,0)

    -- keep body collapsed at this moment
    contentArea.Size=UDim2.new(1,-100,0,0)
    sidebar.Size=UDim2.new(0,100,0,0)

    task.wait(0.02)

    -- 3. slide frame down into open position
    tw(frame,0.30,{
        Position=OPEN_POS
    },Enum.EasingStyle.Quint,Enum.EasingDirection.Out)

    task.wait(0.16)

    -- 4. stretch body open downward
    tw(frame,0.32,{
        Size=OPEN_SIZE
    },Enum.EasingStyle.Quart,Enum.EasingDirection.Out)

    tw(contentArea,0.32,{
        Size=UDim2.new(1,-100,1,-40)
    },Enum.EasingStyle.Quart,Enum.EasingDirection.Out)

    tw(sidebar,0.32,{
        Size=UDim2.new(0,100,1,-40)
    },Enum.EasingStyle.Quart,Enum.EasingDirection.Out)

    task.wait(0.34)
    collapsed=false
    busy=false
end

pill.Activated:Connect(function()
    if dragging then return end
    expand()
end)

pill.MouseEnter:Connect(function()
    tw(pill,0.15,{BackgroundColor3=Color3.fromRGB(40,40,45)})
end)
pill.MouseLeave:Connect(function()
    tw(pill,0.15,{BackgroundColor3=C.pill})
end)

-- collapse trigger: right-click OR long-press the topbar
-- (no arrow button now, so we need a gesture)
local pressStart=0
local longPressThreshold=0.6

topBar.InputBegan:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.MouseButton2 then
        if not busy then collapse() end
    elseif input.UserInputType==Enum.UserInputType.Touch
        or input.UserInputType==Enum.UserInputType.MouseButton1 then
        pressStart=os.clock()
    end
end)

topBar.InputEnded:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.Touch
        or input.UserInputType==Enum.UserInputType.MouseButton1 then
        local held=os.clock()-pressStart
        if held>=longPressThreshold and not busy then
            collapse()
        end
    end
end)

-- ══════════════════════════════════════════════════════════════════
--  INTRO
-- ══════════════════════════════════════════════════════════════════
frame.Position=UDim2.new(0,-600,0.5,-160)
task.spawn(function()
    task.wait(0.1)
    tw(frame,0.45,{Position=OPEN_POS},Enum.EasingStyle.Quint)
end)
