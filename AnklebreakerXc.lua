-- Hard Obfuscated AnkleBreaker by XC
local a=game:GetService("Players")local b=a.LocalPlayer;local c=game:GetService("RunService")
local d=(gethui and gethui())or game:GetService("CoreGui")
if d:FindFirstChild("\84\101\108\101\112\111\114\116\71\117\105")then d.TeleportGui:Destroy()end
local e=Instance.new("\83\99\114\101\101\110\71\117\105")e.Name="\84\101\108\101\112\111\114\116\71\117\105"e.ResetOnSpawn=false e.Parent=d
local f=Instance.new("\70\114\97\109\101")f.Name="\77\97\105\110\70\114\97\109\101"f.Size=UDim2.new(0,250,0,460)f.Position=UDim2.new(0.5,-125,0.5,-230)f.BackgroundColor3=Color3.fromRGB(15,15,15)f.Active=true f.Draggable=true f.Parent=e
Instance.new("\85\73\67\111\114\110\101\114",f).CornerRadius=UDim.new(0,10)
local g=Instance.new("\84\101\120\116\76\97\98\101\108")g.Size=UDim2.new(1,0,0,40)g.Text="\65\78\75\76\69\66\82\69\65\75\69\82\32\66\89\32\88\67"g.Font=Enum.Font.GothamBold g.TextSize=14 g.TextColor3=Color3.new(1,1,1)g.BackgroundTransparency=1 g.Parent=f
local h=Instance.new("\83\99\114\111\108\108\105\110\103\70\114\97\109\101")h.Size=UDim2.new(1,-10,1,-260)h.Position=UDim2.new(0,5,0,45)h.BackgroundTransparency=1 h.ScrollBarThickness=0 h.CanvasSize=UDim2.new(0,0,0,0)h.AutomaticCanvasSize=Enum.AutomaticSize.Y h.Parent=f
local i=Instance.new("\85\73\71\114\105\100\76\97\121\111\117\116")i.Parent=h i.CellPadding=UDim2.new(0,5,0,15)i.CellSize=UDim2.new(0,75,0,90)i.HorizontalAlignment=Enum.HorizontalAlignment.Center
local j=false
local k=Instance.new("\84\101\120\116\66\117\116\116\111\110")k.Size=UDim2.new(1,-20,0,30)k.Position=UDim2.new(0,10,1,-170)k.Text="\65\85\84\79\32\83\65\86\69\58\32\79\70\70"k.Font=Enum.Font.GothamBold k.BackgroundColor3=Color3.fromRGB(60,60,60)k.TextColor3=Color3.new(1,1,1)k.Parent=f
Instance.new("\85\73\67\111\114\110\101\114",k).CornerRadius=UDim.new(0,6)
local l=Instance.new("\84\101\120\116\66\117\116\116\111\110")l.Size=UDim2.new(0.5,-12,0,30)l.Position=UDim2.new(0,10,1,-130)l.Text="\83\69\84\32\80\79\83"l.Font=Enum.Font.GothamBold l.BackgroundColor3=Color3.fromRGB(40,120,40)l.TextColor3=Color3.new(1,1,1)l.Parent=f
Instance.new("\85\73\67\111\114\110\101\114",l).CornerRadius=UDim.new(0,6)
local m=Instance.new("\84\101\120\116\66\117\116\116\111\110")m.Size=UDim2.new(0.5,-12,0,30)m.Position=UDim2.new(0.5,2,1,-130)m.Text="\84\80\32\80\79\83"m.Font=Enum.Font.GothamBold m.BackgroundColor3=Color3.fromRGB(40,80,150)m.TextColor3=Color3.new(1,1,1)m.Parent=f
Instance.new("\85\73\67\111\114\110\101\114",m).CornerRadius=UDim.new(0,6)
local n=Instance.new("\84\101\120\116\66\117\116\116\111\110")n.Size=UDim2.new(1,-20,0,30)n.Position=UDim2.new(0,10,1,-90)n.Text="\83\69\84\32\83\80\65\87\78"n.Font=Enum.Font.GothamBold n.BackgroundColor3=Color3.fromRGB(120,40,120)n.TextColor3=Color3.new(1,1,1)n.Parent=f
Instance.new("\85\73\67\111\114\110\101\114",n).CornerRadius=UDim.new(0,6)
local o=Instance.new("\84\101\120\116\66\117\116\116\111\110")o.Size=UDim2.new(0.5,-12,0,30)o.Position=UDim2.new(0,10,1,-50)o.Text="\83\80\69\69\68\58\32\79\70\70"o.Font=Enum.Font.GothamBold o.BackgroundColor3=Color3.fromRGB(60,60,60)o.TextColor3=Color3.new(1,1,1)o.Parent=f
Instance.new("\85\73\67\111\114\110\101\114",o).CornerRadius=UDim.new(0,6)
local p=Instance.new("\84\101\120\116\66\111\120")p.Size=UDim2.new(0.5,-12,0,30)p.Position=UDim2.new(0.5,2,1,-50)p.Text="100"p.Font=Enum.Font.GothamBold p.BackgroundColor3=Color3.fromRGB(40,40,40)p.TextColor3=Color3.new(1,1,1)p.Parent=f
Instance.new("\85\73\67\111\114\110\101\114",p).CornerRadius=UDim.new(0,6)

local q,r,s,t=nil,nil,false,100
local u,v=nil,true

k.MouseButton1Click:Connect(function()j=not j k.Text=j and "\65\85\84\79\32\83\65\86\69\58\32\79\78"or"\65\85\84\79\32\83\65\86\69\58\32\79\70\70"k.BackgroundColor3=j and Color3.fromRGB(200,100,0)or Color3.fromRGB(60,60,60)end)

l.MouseButton1Click:Connect(function()if not j and b.Character then q=b.Character.HumanoidRootPart.CFrame l.Text="\83\65\86\69\68\33"task.wait(0.3)l.Text="\83\69\84\32\80\79\83"end end)

m.MouseButton1Click:Connect(function()if q and b.Character then b.Character.HumanoidRootPart.CFrame=q end end)

n.MouseButton1Click:Connect(function()if b.Character then r=b.Character.HumanoidRootPart.CFrame n.Text="\83\80\65\87\78\32\83\69\84\33"task.wait(0.5)n.Text="\83\69\84\32\83\80\65\87\78"end end)

b.CharacterAdded:Connect(function(w)if r then task.wait(0.05)w:WaitForChild("\72\117\109\97\110\111\105\100\82\111\111\116\80\97\114\116").CFrame=r end end)

o.MouseButton1Click:Connect(function()s=not s o.Text=s and "\83\80\69\69\68\58\32\79\78"or"\83\80\69\69\68\58\32\79\70\70"end)

p.FocusLost:Connect(function()t=tonumber(p.Text)or 16 end)

local function x(y)if y==b then return end local z=Instance.new("\70\114\97\109\101")z.Name=y.Name z.BackgroundTransparency=1 z.Parent=h local A=Instance.new("\73\109\97\103\101\66\117\116\116\111\110")A.Size=UDim2.new(0,65,0,65)A.Position=UDim2.new(0.5,-32,0,0)A.Image=Players:GetUserThumbnailAsync(y.UserId,Enum.ThumbnailType.HeadShot,Enum.ThumbnailSize.Size150x150)A.BackgroundColor3=Color3.fromRGB(40,40,40)A.Parent=z Instance.new("\85\73\67\111\114\110\101\114",A).CornerRadius=UDim.new(1,0)local B=Instance.new("\84\101\120\116\76\97\98\101\108")B.Size=UDim2.new(1,0,0,20)B.Position=UDim2.new(0,0,0,68)B.Text=y.DisplayName:sub(1,10)B.Font=Enum.Font.GothamBold B.TextSize=10 B.TextColor3=Color3.new(1,1,1)B.BackgroundTransparency=1 B.Parent=z local function C(D)local E=D:WaitForChild("\72\117\109\97\110\111\105\100")z.Visible=(E.Health>0)E.HealthChanged:Connect(function(F)z.Visible=(F>0)end)end if y.Character then C(y.Character)end y.CharacterAdded:Connect(C)A.MouseButton1Click:Connect(function()if b.Character then local G=q or b.Character.HumanoidRootPart.CFrame u=y task.wait(0.08)u=nil b.Character.HumanoidRootPart.CFrame=G end end)end

local function H()for _,I in pairs(h:GetChildren())do if I:IsA("\70\114\97\109\101")then I:Destroy()end end for _,J in pairs(Players:GetPlayers())do x(J)end end

Players.PlayerAdded:Connect(x)
Players.PlayerRemoving:Connect(function(K)if h:FindFirstChild(K.Name)then h[K.Name]:Destroy()end end)
H()

c.Heartbeat:Connect(function()if b.Character and b.Character:FindFirstChild("\72\117\109\97\110\111\105\100\82\111\111\116\80\97\114\116")then if j and not u then q=b.Character.HumanoidRootPart.CFrame end if s and b.Character:FindFirstChild("\72\117\109\97\110\111\105\100")then b.Character.Humanoid.WalkSpeed=t end if u and u.Character and u.Character:FindFirstChild("\72\117\109\97\110\111\105\100\82\111\111\116\80\97\114\116")then v=not v b.Character.HumanoidRootPart.CFrame=u.Character.HumanoidRootPart.CFrame*(v and CFrame.new(0,0,3)or CFrame.new(0,0,-3))end end end)
