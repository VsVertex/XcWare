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
    border=Color3.fromRGB(210,210,216),
    text=Color3.fromRGB(20,20,25),
    subText=Color3.fromRGB(120,120,130),
    sidebar=Color3.fromRGB(246,246,248),
    activeTab=Color3.fromRGB(225,225,232),
    barFill=Color3.fromRGB(232,232,236),
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

local function crisp(lbl)
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
--  CONSTANTS
-- ══════════════════════════════════════════════════════════════════
local PANEL_W=520
local PANEL_H=320
local PANEL_SIDEBAR_W=100

local BAR_W_COLLAPSED=40
local BAR_W_SIDEBAR=PANEL_SIDEBAR_W
local BAR_VISIBLE_H=240

local CIRCLE_SIZE=26

-- fixed on-screen x dock, used for BOTH collapsed + open states.
-- this is the actual fix: the panel never slides past the edge of
-- the screen anymore -- it just grows/shrinks its own width in place
local PANEL_X=12

local function getViewport()
    local cam=workspace.CurrentCamera
    if cam then
        local v=cam.ViewportSize
        if v and v.X>0 and v.Y>0 then return v end
    end
    return Vector2.new(1280,720)
end

-- clamp the "open" panel size to whatever the current screen can fit
local function getOpenDims()
    local vp=getViewport()
    local w=math.min(PANEL_W,math.max(300,vp.X-24))
    local h=math.min(PANEL_H,math.max(220,vp.Y-24))
    return w,h
end

local function getBarVisH(openH)
    return math.min(BAR_VISIBLE_H,openH-40)
end

-- only used once, for the initial slide-in on load
local function getIntroHiddenX()
    local vp=getViewport()
    local openW=getOpenDims()
    return -math.min(openW+40,vp.X+60)
end

-- ══════════════════════════════════════════════════════════════════
--  MAIN PANEL FRAME
-- ══════════════════════════════════════════════════════════════════
local openW0,openH0=getOpenDims()

local frame=Instance.new("Frame")
frame.Name="MainPanel"
frame.Size=UDim2.new(0,openW0,0,openH0)
frame.Position=UDim2.new(0,PANEL_X,0.5,-openH0/2)
frame.BackgroundColor3=C.panel
frame.BorderSizePixel=0
frame.ClipsDescendants=false
frame.Active=true
frame.Parent=gui
stroke(frame,C.border,1,0)

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
crisp(titleLbl)
titleLbl.Parent=topBar

local timeLbl=Instance.new("TextLabel")
timeLbl.Size=UDim2.new(0,200,1,0)
timeLbl.Position=UDim2.new(1,-260,0,0)
timeLbl.BackgroundTransparency=1
timeLbl.Font=Enum.Font.Code
timeLbl.Text="12:00:00 AM PHT"
timeLbl.TextColor3=C.subText
timeLbl.TextSize=11
timeLbl.TextXAlignment=Enum.TextXAlignment.Right
crisp(timeLbl)
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
--  MINUS BUTTON (blends into topbar -- black dash, no box)
-- ══════════════════════════════════════════════════════════════════
local minusBtn=Instance.new("TextButton")
minusBtn.Name="MinusBtn"
minusBtn.Size=UDim2.new(0,30,0,30)
minusBtn.Position=UDim2.new(1,-36,0,5)
minusBtn.BackgroundTransparency=1
minusBtn.BorderSizePixel=0
minusBtn.Font=Enum.Font.GothamBold
minusBtn.Text="−"
minusBtn.TextColor3=Color3.fromRGB(0,0,0)
minusBtn.TextSize=18
minusBtn.AutoButtonColor=false
minusBtn.ZIndex=6
minusBtn.Parent=topBar
crisp(minusBtn)

-- ══════════════════════════════════════════════════════════════════
--  SIDEBAR
-- ══════════════════════════════════════════════════════════════════
local sidebar=Instance.new("Frame")
sidebar.Name="Sidebar"
sidebar.Size=UDim2.new(0,PANEL_SIDEBAR_W,1,-40)
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

crisp(homeTab)

-- ══════════════════════════════════════════════════════════════════
--  4 EMPTY BOXES (collapsed state, bottom of bar)
-- ══════════════════════════════════════════════════════════════════
local boxesHolder=Instance.new("Frame")
boxesHolder.Name="QuickBoxes"
boxesHolder.Size=UDim2.new(1,-8,0,140)
boxesHolder.Position=UDim2.new(0,4,1,-148)
boxesHolder.BackgroundTransparency=1
boxesHolder.Visible=false
boxesHolder.ZIndex=3
boxesHolder.Parent=sidebar

local boxesLayout=Instance.new("UIListLayout")
boxesLayout.Padding=UDim.new(0,6)
boxesLayout.SortOrder=Enum.SortOrder.LayoutOrder
boxesLayout.HorizontalAlignment=Enum.HorizontalAlignment.Center
boxesLayout.VerticalAlignment=Enum.VerticalAlignment.Bottom
boxesLayout.Parent=boxesHolder

local quickBoxes={}
for i=1,4 do
    local b=Instance.new("Frame")
    b.Name="Box"..i
    b.Size=UDim2.new(0,26,0,26)
    b.BackgroundColor3=C.barFill
    b.BorderSizePixel=0
    b.LayoutOrder=i
    b.ZIndex=4
    b.Parent=boxesHolder
    stroke(b,C.border,1,0.1)
    quickBoxes[i]=b
end

-- ══════════════════════════════════════════════════════════════════
--  CIRCLE ARROW
-- ══════════════════════════════════════════════════════════════════
local circleBtn=Instance.new("TextButton")
circleBtn.Name="CircleArrow"
circleBtn.Size=UDim2.new(0,CIRCLE_SIZE,0,CIRCLE_SIZE)
circleBtn.Position=UDim2.new(0,PANEL_SIDEBAR_W-CIRCLE_SIZE/2,0.5,-CIRCLE_SIZE/2)
circleBtn.BackgroundColor3=C.panelTop
circleBtn.BorderSizePixel=0
circleBtn.Font=Enum.Font.GothamBold
circleBtn.Text=">"
circleBtn.TextColor3=C.text
circleBtn.TextSize=13
circleBtn.AutoButtonColor=false
circleBtn.ZIndex=10
circleBtn.Visible=false
circleBtn.Parent=frame
stroke(circleBtn,C.border,1,0)

local circleCorner=Instance.new("UICorner")
circleCorner.CornerRadius=UDim.new(0.5,0)
circleCorner.Parent=circleBtn

crisp(circleBtn)

-- ══════════════════════════════════════════════════════════════════
--  CONTENT AREA
-- ══════════════════════════════════════════════════════════════════
local contentArea=Instance.new("Frame")
contentArea.Name="ContentArea"
contentArea.Size=UDim2.new(1,-PANEL_SIDEBAR_W,1,-40)
contentArea.Position=UDim2.new(0,PANEL_SIDEBAR_W,0,40)
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
crisp(homeLabel)
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
crisp(homeSub)
homeSub.Parent=homePage

-- ══════════════════════════════════════════════════════════════════
--  STATE
-- ══════════════════════════════════════════════════════════════════
local collapsed=false
local busy=false
local introDone=false
local dragProgress=0
local dragActive=false
local dragStartX=nil
local DRAG_RANGE=160
local HOLD_THRESHOLD=0.15
local holdStart=0
local holdTimer=nil
local holdReady=false

-- ══════════════════════════════════════════════════════════════════
--  TOPBAR DRAG (open state)
-- ══════════════════════════════════════════════════════════════════
local topDragActive=false
local topDragStart=nil
local topDragStartPos=nil
local topActiveInput=nil

topBar.InputBegan:Connect(function(input)
    if collapsed then return end
    if input.UserInputType==Enum.UserInputType.MouseButton1
        or input.UserInputType==Enum.UserInputType.Touch then
        topDragActive=true
        topActiveInput=input
        topDragStart=input.Position
        topDragStartPos=frame.Position
    end
end)

local function stopTopDrag(input)
    if topActiveInput and input~=topActiveInput then return end
    topDragActive=false
    topActiveInput=nil
end

topBar.InputEnded:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.MouseButton1
        or input.UserInputType==Enum.UserInputType.Touch then
        stopTopDrag(input)
    end
end)

UIS.InputChanged:Connect(function(input)
    if not topDragActive then return end
    if topActiveInput and input~=topActiveInput then return end
    if input.UserInputType==Enum.UserInputType.MouseMovement
        or input.UserInputType==Enum.UserInputType.Touch then
        local d=input.Position-topDragStart
        frame.Position=UDim2.new(
            topDragStartPos.X.Scale,
            topDragStartPos.X.Offset+math.floor(d.X+0.5),
            topDragStartPos.Y.Scale,
            topDragStartPos.Y.Offset+math.floor(d.Y+0.5)
        )
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.MouseButton1
        or input.UserInputType==Enum.UserInputType.Touch then
        stopTopDrag(input)
    end
end)

-- ══════════════════════════════════════════════════════════════════
--  APPLY PROGRESS (0 collapsed → 1 open)
-- ══════════════════════════════════════════════════════════════════
local function applyProgress(p)
    p=math.clamp(p,0,1)

    local openW,openH=getOpenDims()
    local barVisH=getBarVisH(openH)

    -- sidebar's own width: 40 → 100
    local bw=BAR_W_COLLAPSED+(BAR_W_SIDEBAR-BAR_W_COLLAPSED)*p

    -- frame's overall width: 40 (thin bar) → full open width
    local fw=BAR_W_COLLAPSED+(openW-BAR_W_COLLAPSED)*p

    -- frame height: bar height → full open height
    local fh=barVisH+(openH-barVisH)*p
    local fyOff=-barVisH/2+(-openH/2+barVisH/2)*p

    sidebar.Size=UDim2.new(0,bw,1,-40)
    circleBtn.Position=UDim2.new(0,bw-CIRCLE_SIZE/2,0.5,-CIRCLE_SIZE/2)

    if p<0.4 then
        boxesHolder.Visible=true
        homeTab.Visible=false
        for _,b in ipairs(quickBoxes)do
            b.BackgroundTransparency=0
        end
    else
        boxesHolder.Visible=false
        homeTab.Visible=true
    end

    -- X is ALWAYS PANEL_X now -- the panel never leaves the screen,
    -- it just shrinks down to a thin dockable bar in place
    frame.Position=UDim2.new(0,PANEL_X,0.5,math.floor(fyOff+0.5))
    frame.Size=UDim2.new(0,math.floor(fw+0.5),0,math.floor(fh+0.5))

    local cp=math.clamp((p-0.5)/0.5,0,1)
    contentArea.BackgroundTransparency=1-cp
    for _,ch in ipairs(contentArea:GetDescendants())do
        if ch:IsA("TextLabel")or ch:IsA("TextButton")then
            ch.TextTransparency=1-cp
        end
    end
    -- title + clock live outside contentArea, fade them the same way
    -- so nothing floats over the screen once the panel is collapsed
    titleLbl.TextTransparency=1-cp
    timeLbl.TextTransparency=1-cp
end

-- ══════════════════════════════════════════════════════════════════
--  COLLAPSE
-- ══════════════════════════════════════════════════════════════════
local function collapse()
    if busy or collapsed then return end
    busy=true

    tw(minusBtn,0.15,{TextTransparency=1},Enum.EasingStyle.Quad,Enum.EasingDirection.In)

    for _,b in ipairs(quickBoxes)do
        b.BackgroundTransparency=1
        tw(b,0.3,{BackgroundTransparency=0})
    end

    homeTab.Visible=true
    tw(homeTab,0.15,{TextTransparency=1,BackgroundTransparency=1},Enum.EasingStyle.Quad,Enum.EasingDirection.In)
    task.delay(0.15,function()
        homeTab.Visible=false
        homeTab.BackgroundTransparency=0
        homeTab.TextTransparency=0
    end)
    boxesHolder.Visible=true

    local startT=os.clock()
    local duration=0.45
    task.spawn(function()
        while os.clock()-startT<duration do
            local a=(os.clock()-startT)/duration
            local e=1-math.pow(1-a,3)
            applyProgress(1-e)
            task.wait()
        end
        applyProgress(0)
        for _,ch in ipairs(contentArea:GetDescendants())do
            if ch:IsA("TextLabel")or ch:IsA("TextButton")then
                ch.TextTransparency=1
            end
        end
        contentArea.BackgroundTransparency=1
        circleBtn.Visible=true
        collapsed=true
        busy=false
    end)
end

-- ══════════════════════════════════════════════════════════════════
--  EXPAND
-- ══════════════════════════════════════════════════════════════════
local function expand()
    if busy or not collapsed then return end
    busy=true
    circleBtn.Visible=false

    for _,ch in ipairs(contentArea:GetDescendants())do
        if ch:IsA("TextLabel")or ch:IsA("TextButton")then
            ch.TextTransparency=1
        end
    end
    contentArea.BackgroundTransparency=1

    local startT=os.clock()
    local duration=0.5
    task.spawn(function()
        while os.clock()-startT<duration do
            local a=(os.clock()-startT)/duration
            local e=1-math.pow(1-a,3)
            applyProgress(e)
            task.wait()
        end
        applyProgress(1)
        collapsed=false
        busy=false
        tw(minusBtn,0.2,{TextTransparency=0},Enum.EasingStyle.Quad,Enum.EasingDirection.Out)
        homeTab.Visible=true
        boxesHolder.Visible=false
    end)
end

-- ══════════════════════════════════════════════════════════════════
--  MINUS BTN
-- ══════════════════════════════════════════════════════════════════
minusBtn.Activated:Connect(function()
    if not busy then collapse() end
end)

-- ══════════════════════════════════════════════════════════════════
--  CIRCLE DRAG TO EXPAND
-- ══════════════════════════════════════════════════════════════════
local function resetHold()
    holdReady=false
    holdStart=0
    if holdTimer then
        task.cancel(holdTimer)
        holdTimer=nil
    end
end

circleBtn.InputBegan:Connect(function(input)
    if not collapsed then return end
    if input.UserInputType==Enum.UserInputType.MouseButton1
        or input.UserInputType==Enum.UserInputType.Touch then
        holdStart=os.clock()
        holdReady=false
        dragActive=true
        dragStartX=input.Position.X
        dragProgress=0
        holdTimer=task.delay(HOLD_THRESHOLD,function()
            if dragActive then holdReady=true end
        end)
    end
end)

UIS.InputChanged:Connect(function(input)
    if not dragActive then return end
    if input.UserInputType==Enum.UserInputType.MouseMovement
        or input.UserInputType==Enum.UserInputType.Touch then
        if holdReady and collapsed then
            local dx=input.Position.X-dragStartX
            if dx<0 then dx=0 end
            local p=math.clamp(dx/DRAG_RANGE,0,1)
            dragProgress=p
            applyProgress(p)
        end
    end
end)

local function endCircleDrag()
    if not dragActive then return end
    dragActive=false
    resetHold()

    if dragProgress>0.6 then
        expand()
    else
        local startP=dragProgress
        if startP>0.01 then
            local startT=os.clock()
            local duration=0.2
            task.spawn(function()
                while os.clock()-startT<duration do
                    local a=(os.clock()-startT)/duration
                    local e=1-math.pow(1-a,3)
                    applyProgress(startP*(1-e))
                    task.wait()
                end
                applyProgress(0)
            end)
        end
    end
end

circleBtn.InputEnded:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.MouseButton1
        or input.UserInputType==Enum.UserInputType.Touch then
        endCircleDrag()
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.MouseButton1
        or input.UserInputType==Enum.UserInputType.Touch then
        endCircleDrag()
    end
end)

-- ══════════════════════════════════════════════════════════════════
--  SCREEN-SIZE / ORIENTATION REFLOW
-- ══════════════════════════════════════════════════════════════════
local function reflow()
    if not introDone then return end
    if dragActive or topDragActive or busy then return end
    applyProgress(collapsed and 0 or 1)
end

local function bindViewportListener()
    local cam=workspace.CurrentCamera
    if cam then
        cam:GetPropertyChangedSignal("ViewportSize"):Connect(reflow)
    end
end
bindViewportListener()
workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(bindViewportListener)

-- ══════════════════════════════════════════════════════════════════
--  INTRO
-- ══════════════════════════════════════════════════════════════════
do
    local openW,openH=getOpenDims()
    local barVisH=getBarVisH(openH)
    local hiddenX=getIntroHiddenX()
    frame.Position=UDim2.new(0,hiddenX,0.5,-barVisH/2)
    frame.Size=UDim2.new(0,BAR_W_COLLAPSED,0,barVisH)
    task.spawn(function()
        task.wait(0.15)
        local startT=os.clock()
        local duration=0.55
        while os.clock()-startT<duration do
            local a=(os.clock()-startT)/duration
            local e=1-math.pow(1-a,3)
            applyProgress(e)
            local curX=hiddenX+(PANEL_X-hiddenX)*e
            frame.Position=UDim2.new(0,math.floor(curX+0.5),frame.Position.Y.Scale,frame.Position.Y.Offset)
            task.wait()
        end
        applyProgress(1)
        introDone=true
    end)
end
