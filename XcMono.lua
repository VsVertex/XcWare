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
    border=Color3.fromRGB(222,222,228),
    text=Color3.fromRGB(20,20,25),
    subText=Color3.fromRGB(120,120,130),
    accent=Color3.fromRGB(0,0,0),
    sidebar=Color3.fromRGB(246,246,248),
    activeTab=Color3.fromRGB(225,225,232),
}

for _,n in ipairs({GN})do
    local a=pg:FindFirstChild(n)
    if a then a:Destroy()end
    local b=pl:FindFirstChild(n)
    if b then b:Destroy()end
end

local function corner(o,r)
    local c=Instance.new("UICorner")
    c.CornerRadius=UDim.new(0,r or 8)
    c.Parent=o
    return c
end

local function stroke(o,col,t,tr)
    local s=Instance.new("UIStroke")
    s.Color=col or C.border
    s.Thickness=t or 1
    s.Transparency=tr or 0
    s.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
    s.Parent=o
    return s
end

local function tw(o,d,p,st,dr)
    local a=T:Create(o,TweenInfo.new(d,st or Enum.EasingStyle.Quint,dr or Enum.EasingDirection.Out),p)
    a:Play()
    return a
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

local frame=Instance.new("Frame")
frame.Name="MainPanel"
frame.Size=UDim2.new(0,520,0,320)
frame.Position=UDim2.new(0,12,0.5,-160)
frame.BackgroundColor3=C.panel
frame.BorderSizePixel=0
frame.ClipsDescendants=false
frame.Active=true
frame.Parent=gui
corner(frame,12)
stroke(frame,C.border,1,0)

local topBar=Instance.new("Frame")
topBar.Name="TopBar"
topBar.Size=UDim2.new(1,0,0,40)
topBar.Position=UDim2.new(0,0,0,0)
topBar.BackgroundColor3=C.panelTop
topBar.BorderSizePixel=0
topBar.Active=true
topBar.Parent=frame
corner(topBar,12)

local topBarCover=Instance.new("Frame")
topBarCover.Size=UDim2.new(1,0,0,12)
topBarCover.Position=UDim2.new(0,0,1,-12)
topBarCover.BackgroundColor3=C.panelTop
topBarCover.BorderSizePixel=0
topBarCover.ZIndex=topBar.ZIndex
topBarCover.Parent=topBar

local topBarStroke=Instance.new("UIStroke")
topBarStroke.Color=C.border
topBarStroke.Thickness=1
topBarStroke.Transparency=0.4
topBarStroke.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
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
titleLbl.Parent=topBar

local timeLbl=Instance.new("TextLabel")
timeLbl.Size=UDim2.new(0,220,1,0)
timeLbl.Position=UDim2.new(1,-236,0,0)
timeLbl.BackgroundTransparency=1
timeLbl.Font=Enum.Font.Code
timeLbl.Text="12:00:00 AM PHT"
timeLbl.TextColor3=C.subText
timeLbl.TextSize=11
timeLbl.TextXAlignment=Enum.TextXAlignment.Right
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
sideStroke.Transparency=0.4
sideStroke.ApplyStrokeMode=Enum.ApplyStrokeMode.Border
sideStroke.Parent=sidebar

local contentArea=Instance.new("Frame")
contentArea.Name="ContentArea"
contentArea.Size=UDim2.new(1,-100,1,-40)
contentArea.Position=UDim2.new(0,100,0,40)
contentArea.BackgroundColor3=C.panel
contentArea.BorderSizePixel=0
contentArea.ClipsDescendants=true
contentArea.Parent=frame

local emptyTab=Instance.new("Frame")
emptyTab.Name="Tab1"
emptyTab.Size=UDim2.new(1,0,1,0)
emptyTab.Position=UDim2.new(0,0,0,0)
emptyTab.BackgroundTransparency=1
emptyTab.Visible=true
emptyTab.Parent=contentArea

local emptyLabel=Instance.new("TextLabel")
emptyLabel.Size=UDim2.new(1,0,1,0)
emptyLabel.Position=UDim2.new(0,0,0,0)
emptyLabel.BackgroundTransparency=1
emptyLabel.Font=Enum.Font.Gotham
emptyLabel.Text=""
emptyLabel.TextColor3=C.subText
emptyLabel.TextSize=11
emptyLabel.TextXAlignment=Enum.TextXAlignment.Center
emptyLabel.TextYAlignment=Enum.TextYAlignment.Center
emptyLabel.Parent=emptyTab

local dragging=false
local dragStart=nil
local startPos=nil
local activeInput=nil

topBar.InputBegan:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.MouseButton1
        or input.UserInputType==Enum.UserInputType.Touch then
        dragging=true
        activeInput=input
        dragStart=input.Position
        startPos=frame.Position
    end
end)

local function stopDrag(input)
    if activeInput and input~=activeInput then return end
    dragging=false
    activeInput=nil
end

topBar.InputEnded:Connect(function(input)
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
        frame.Position=UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset+delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset+delta.Y
        )
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType==Enum.UserInputType.MouseButton1
        or input.UserInputType==Enum.UserInputType.Touch then
        stopDrag(input)
    end
end)

frame.Position=UDim2.new(0,-600,0.5,-160)
task.spawn(function()
    task.wait(0.1)
    tw(frame,0.45,{Position=UDim2.new(0,12,0.5,-160)},Enum.EasingStyle.Quint)
end)
