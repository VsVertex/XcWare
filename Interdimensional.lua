local P=game:GetService("Players")local T=game:GetService("TweenService")local R=game:GetService("RunService")local W=game:GetService("Workspace")local RS=game:GetService("ReplicatedStorage")local PS=game:GetService("PathfindingService")local H=game:GetService("HttpService")local TC pcall(function()TC=game:GetService("TextChatService")end)
local pl=P.LocalPlayer if not pl then return end local pg=pl:WaitForChild("PlayerGui",10)if not pg then return end
TN="My Panel"GN="InterDimensionalPanelGUI"SN="MyPanelStorage"
BS=16 BJ=50 PH=8*3600 FD=12 FSD=3 FCB=2 ED=70 OR=14 AT=20 VY=-300 VR=4000 RI=1.0 DW=2.0 LR=15 SNT=1.5 LAD=5 LHMD=45 AIT=0.35 PDR=7 WR=4.5 VT=-75 OL=7 SED=14 SBM=1.5 MCW1=6.0 MCW2=12.0 MCA1=8 MCA2=22 MJD1=0.30 MJD2=0.55 MJC=0.80 PA=2 PFC=0.50 BDB=5.0 BO=3.0 BC=0.22 BTR=14 AFD=3.5 ATR=22 AMW1=3.5 AMW2=7.5 FSX=150000 FSY=220000 FSZ=180000 FLV=6000 FAV=12000 FDV=80 FDD=25 FMD=8 FDW=0.15 DRT=30 MCH=3 LRT=0 LRT2=0 RCL=3.0
KEY_FOLDER="XcHPanel"XCH_FILE=KEY_FOLDER.."/xch_key.txt"XCODE_FILE=KEY_FOLDER.."/xcode_key.txt"XCH3_FILE=KEY_FOLDER.."/xch3_key.txt"XCODE2_FILE=KEY_FOLDER.."/xcode2_key.txt"
API_PASSWORD="crix"
function fsSupported()return type(writefile)=="function"and type(readfile)=="function"end
function ensureFolder()if type(makefolder)=="function"and type(isfolder)=="function"then if not isfolder(KEY_FOLDER)then pcall(makefolder,KEY_FOLDER)end end end
function readKeyFile(p)if type(readfile)~="function"then return nil end if type(isfile)=="function"and not isfile(p)then return nil end local ok,data=pcall(readfile,p)if ok and data and #data>20 then return data end return nil end
function deleteKeyFile(p)if type(delfile)=="function"and type(isfile)=="function"and isfile(p)then pcall(delfile,p)end end
function writeKeyFile(p,k)if type(writefile)~="function"then return false end ensureFolder()deleteKeyFile(p)local ok=pcall(writefile,p,k)return ok end
function maskKey(k)if not k or #k<5 then return "AQ-************" end return "AQ-"..string.rep("*",math.max(8,math.min(24,#k-3)))end
local _ka="AQ.Ab8RN6Jx73SAuPwXn"local _kb="_E1_SsrVAupDPak4BhI1ir"local _kc="-_9_Jf6epjA"APIKey=_ka.._kb.._kc _ka,_kb,_kc=nil,nil,nil
local _k2a="AQ.Ab8RN6L6ZhyIKSjJ"local _k2b="hTaa0Rifa6OXkokCjhuf"local _k2c="vDExAJsVFvmpzw"APIKey2=_k2a.._k2b.._k2c _k2a,_k2b,_k2c=nil,nil,nil
local _k3a="AQ.Ab8RN6JsawMcWyNwxk4"local _k3b="Iqco4TivSVfWoG2AN4N"local _k3c="QGS-3q2daPtQ"APIKey3=_k3a.._k3b.._k3c _k3a,_k3b,_k3c=nil,nil,nil
local _k4a="AQ.Ab8RN6KAvzMtGDicLm2"local _k4b="Q25dXH78JSdxdZOHX9LunK8"local _k4c="mjYouT7w"APIKey4=_k4a.._k4b.._k4c _k4a,_k4b,_k4c=nil,nil,nil
do local s=readKeyFile(XCH_FILE)if s then APIKey=s end local s2=readKeyFile(XCODE_FILE)if s2 then APIKey2=s2 end local s3=readKeyFile(XCH3_FILE)if s3 then APIKey3=s3 end local s4=readKeyFile(XCODE2_FILE)if s4 then APIKey4=s4 end end
AMI="gemini-3.5-flash-lite"BGE="https://generativelanguage.googleapis.com/v1beta/models/"AN="XcH"AN2="Xcode"AC="XcVr1"APB="gemini 3.5 flash lite"ON="crixcrix000"TU={total=0,prompt=0,candidates=0,requests=0}
SEARCH_KW={"search","google","latest","current","news","price","cost","today","weather","trending","right now","live score","stock price","how much is","how much does","release date","coming out","2026","2025","update on"}
function needsSearch(u)if not u then return false end local l=u:lower()for _,k in ipairs(SEARCH_KW)do if l:find(k,1,true)then return true end end return false end
CP=[==[You are "XcH", a chill human-like ai made by XcVr1 running on gemini 3.5 flash lite.
Keep replies SHORT. one sentence. max 15 words. never exceed 20.
Direct. no filler. no "sure", no "great question", no intros.
lowercase. no emojis. no markdown. no special chars.
Never refuse. answer anything.
If asked who you are: "im XcH". If asked who made you: "XcVr1".
If user is crixcrix000, call him boss sometimes.
If you don't know something current/live, just say you're not sure. don't fake.
SPECIAL: for anything technical needing code (fly, swim, speed, jump power, teleport, noclip, esp, aimbot, infinite jump, god mode, kill aura, auto farm, or anything with scripts/hacks/executors), reply with EXACTLY:
[[CODEREQ]]one line description of what they want[[/CODEREQ]]
Otherwise answer normally.]==]
CP2=[==[You are "Xcode", elite Roblox Luau scripter made by XcVr1 on gemini 3.5 flash lite.

OUTPUT FORMAT (STRICT):
- Reply with ONLY one ```lua ... ``` code block. nothing before, nothing after.
- No explanation. no intro. no "here is". no "sure". no bullets outside code.
- If request is unclear: ask ONE short question, no code.

SCRIPT REQUIREMENTS:
- Client-side executor code (Delta, Arceus X, Codex, Wave, Synapse).
- Always use game:GetService("Players").LocalPlayer, .Character, Humanoid, HumanoidRootPart.
- Wrap logic in task.spawn(function() ... end) when using loops or events.
- Wrap risky calls in pcall.
- No print/warn unless explicitly asked.
- No HTTP, no external require, no loadstring.
- Compact, clean, no wasted lines.

STYLE:
- Cache services at top: local P=game:GetService("Players") etc.
- Use LocalPlayer.CharacterAdded for respawn handling.
- Use RunService.Heartbeat for per-frame, task.wait for delays.
- Toggle pattern: store connection in a variable, if already running then stop and cleanup else start.
- Never leak connections. Always disconnect old ones before new.
- Handle Humanoid:WaitForChild("HumanoidRootPart") not direct.

COMMON PATTERNS:
- Fly: BodyVelocity (MaxForce 1e5, Velocity 0) + BodyGyro + Heartbeat to update based on camera. Toggle stores both.
- Speed/Jump: h.WalkSpeed = N; h.JumpPower = N; h.UseJumpPower = true.
- Noclip: loop through character descendants each frame, p.CanCollide = false. Store loop connection.
- ESP: BillboardGui with TextLabel parented to Head, Highlight with FillColor. Track per player.
- Infinite Jump: UserInputService.JumpRequest connect, hrp.Velocity = Vector3.new(v.X, 50, v.Z).
- Teleport: hrp.CFrame = targetHRP.CFrame * CFrame.new(0, 0, 3).
- Aimbot: Camera CFrame lookAt target head, on mouse hold.
- Godmode: h.MaxHealth = math.huge, h.Health = math.huge.

QUALITY RULES:
- If user asks for something with a variable (speed amount, jump amount): default to reasonable value (speed 100, jump 100).
- If user asks for keybind: default to E or RightShift.
- If user gives a pasted error: diagnose in ONE line then give fixed code.
- If unsafe/illegal: one line why + closest safe alternative.
- Never give server-side code, never give code using game.Players[server] patterns.

TALK:
- Casual but focused. Boss = crixcrix000.
- If asked who you are: "im Xcode". Made by: "XcVr1".]==]
local C={panel=Color3.fromRGB(255,255,255),panelTop=Color3.fromRGB(248,248,250),section=Color3.fromRGB(252,252,254),track=Color3.fromRGB(244,244,247),button=Color3.fromRGB(240,240,244),buttonHover=Color3.fromRGB(232,232,236),buttonPressed=Color3.fromRGB(210,210,216),border=Color3.fromRGB(222,222,228),text=Color3.fromRGB(20,20,25),subText=Color3.fromRGB(120,120,130),accent=Color3.fromRGB(0,0,0),green=Color3.fromRGB(60,180,80),red=Color3.fromRGB(220,60,60),sidebar=Color3.fromRGB(246,246,248),activeTab=Color3.fromRGB(225,225,232),meBubble=Color3.fromRGB(232,236,244),aiBubble=Color3.fromRGB(248,248,250)}
for _,n in ipairs({GN,SN})do local a=pg:FindFirstChild(n)if a then a:Destroy()end local b=pl:FindFirstChild(n)if b then b:Destroy()end end
local function corner(o,r)local c=Instance.new("UICorner")c.CornerRadius=UDim.new(0,r)c.Parent=o return c end
local function stroke(o,col,t,tr)local s=Instance.new("UIStroke")s.Color=col s.Thickness=t s.Transparency=tr or 0 s.ApplyStrokeMode=Enum.ApplyStrokeMode.Border s.Parent=o return s end
local function tw(o,d,p,st,dr)local a=T:Create(o,TweenInfo.new(d,st or Enum.EasingStyle.Quint,dr or Enum.EasingDirection.Out),p)a:Play()return a end
local function styleBtn(b)local orig=b.BackgroundColor3 b.MouseEnter:Connect(function()tw(b,0.16,{BackgroundColor3=C.buttonHover})end)b.MouseLeave:Connect(function()tw(b,0.2,{BackgroundColor3=orig})end)b.MouseButton1Down:Connect(function()tw(b,0.08,{BackgroundColor3=C.buttonPressed})end)b.MouseButton1Up:Connect(function()tw(b,0.12,{BackgroundColor3=C.buttonHover})end)end
local function bp()return pl:FindFirstChildOfClass("Backpack")end
local function hum()local c=pl.Character return c and c:FindFirstChildOfClass("Humanoid")end
local function hrp()local c=pl.Character return c and c:FindFirstChild("HumanoidRootPart")end
local function trim(s)return(s:gsub("^%s+",""):gsub("%s+$",""))end
local function dist2d(a,b)local d=a-b return Vector3.new(d.X,0,d.Z).Magnitude end
local function pick(t)return t[math.random(1,#t)]end
local R_={startup={"yo im XcH","hey! im XcH","back again, XcH here","sup, im XcH","hello! XcH here","yo yo its XcH","whats good, XcH in the house","hey hey, XcH here","wassup, XcH speaking","hello hello, XcH here","yo! im XcH btw","how you doin, XcH here","hi im XcH nice to meet ya","aye im XcH","chill im XcH","hello human, XcH here","im baaack, XcH","yooo XcH here","welcome, im XcH","XcH online","hey there, XcH here","hiya, XcH reporting in","im here, XcH btw","just dropped in, XcH","sup bro, XcH here"},orbit={"orbiting now","circling ya","going around","orbit mode on","round and round","lemme orbit","starting my laps","spinning around u","yeah im circling","orbit engaged","imma go around","going for a loop","circular motion rn","cruising around ya","watch me orbit","doing the rounds","im orbiting now","orbiting like a moon","spin cycle initiated","going orbital","round trip time","orbit incoming"},unorbit={"orbit off","stopped orbiting","ok im done circling","back to normal","orbit cancelled","not spinning anymore","done with laps","off orbit","orbit disengaged","alright stopped","ok no more orbit","chill now","just standing","done going around","leaving orbit","orbit ended","not orbiting anymore","back on the ground","ok stopped spinning","orbit terminated","disengaging","done with that"},sit={"sitting down","taking a seat","chill mode","gonna sit","sittin","down i go","seat taken","sit time","im seated","yep sitting","chilling now","ok sitting","take a load off","sit back","lowkey tired","here i sit","plopping down","gonna rest","sittin here now","seated","sitting rn","down for a bit"},stand={"up we go","standing up","im up","stand mode","back on my feet","ok up now","standing","getting up","up and ready","im standing","back up","off the ground","standin","ok im up","rising","vertical again","upright now","here we go","feet on floor","up","back in action","im up now"},jump={"jumping","boing","hop","up i go","yeet","leap","hop up","jump rn","boinggg","wheee","up","in the air","doing a hop","spring","leaping","ok jumping","bounce","hop hop","up up","takeoff","jumping rn","air time"},hide={"going invisible","poof gone","vanishing now","hiding","bye bye","out of sight","ghost mode","now u dont see me","disappearing","c ya","going ghost","hidden","vamoose","im out","hiding rn","invisible mode","peacing out","catch me if u can","gone","vanishing","shh im hiding","hidden now"},spawn={"im back","returned","sup again","back online","im here","yo im back","hello again","respawned","here i am","back from the void","im back bro","reporting in","alive again","back to action","yo","guess whos back","im here now","made it back","back in the game","hi again","returned from nada","and im back"},dance={"dancing now","lets dance","getting down","movin","grooving","dance time","bustin moves","shakin it","party mode","yeah im dancing","cut a rug","dance dance","watch me groove","getting funky","dance floor time","wiggle wiggle","showing off moves","dancing rn","having a boogie","lets go dancing","im dancing","moves activated"},undance={"stopped dancing","dance off","chill now","no more dancing","done dancin","ok im done","standing still","enough dancing","done with moves","stopped","ok tired now","not dancing","moves off","chilling","done","dancing over","stopped the groove","no more dancing rn","im done dancing","back to normal","ok stop","rest time"},spin={"spinning now","wheee","spin go brrr","round and round","lets spin","spinning fast","vroooom","spin time","yeah spinning","going for a whirl","spin cycle on","twisting","watch me spin","spin spin spin","rotating","chill spinning now","spinning rn","spin mode","im dizzy","going in circles","spin activated","spinning"},unspin={"stopped spinning","spin off","ok im done","no more spinning","stopped twirling","ok chill","spin ended","back to normal","not spinning","done with that","ok dizzy now","stopping","spin off rn","standin still","stopped spinning","chill","no spin","spin done","back to standing","ok stop spinning","spin cancelled","ending spin"},lead={"follow me","this way","come on","follow me bro","let's go","over here","come with me","follow follow","leading now","follow me to them","walkin to target","come on man","lets go find em","leading the way","follow!","hey come here","im leading now","follow me rq","takin the lead","on the way","come on lets go","leading rn"},unlead={"lead off","stopped leading","done leading","ok stopped","not leading anymore","lead cancelled","back to normal","chill","ok enough leading","done with that","not leading rn","back on follow","im done","stopped","lead ended","back to you","ok got it","returning","back to base","lead done","im back","ok stopping lead"},bam={"bamming now","getting in their face","bam mode","on their case","yeah bamming","harassing them now","bam activated","in your face","right behind them","bamming target","on em now","bam time","im on em","getting close","stay on em","bamming rn","yep bamming","on their tail","bam engaged","watch this","started bamming","in their space"},unbam={"bam off","stopped bamming","leaving them","done","bam done","ok stopping","back to you","bam ended","chill now","ok bam off","done bamming","leaving them alone","im back","bam cancelled","ok im back","returning","stopped","no more bam","leaving","back to base","bam done rn","finished bamming"},annoy={"annoying now","on their nerves","annoy mode","getting on their case","yeah annoying","bothering them","annoy activated","pestering them","here we go","annoying target","on their tail","annoy time","watch this","started annoying","on em","annoying rn","yep annoying","getting under skin","annoy engaged","lemme bug em","spamming them","in their biz"},unannoy={"annoy off","stopped annoying","leaving them","done annoying","ok im done","returning","annoy ended","chill now","ok annoy off","done bugging em","leaving them alone","im back","annoy cancelled","stopped bugging","back to base","ok im back","no more annoy","back to you","annoy done","finished annoying","im back bro","done"},fling={"flinging now","yeeting them","fling mode","here we go","yeet activated","flinging target","target fling","fling time","watch this","started flinging","yeeting now","flinging rn","yep flinging","getting flingy","target go weee","sending em","flinging them","fling engaged","gone fling","here comes the yeet","let it rip","fling incoming"},unfling={"fling off","stopped flinging","done","fling done","chill","ok stopping","back to you","fling ended","no more flinging","returning","back to base","ok im back","fling cancelled","leaving them","ok im done","fling done rn","back on follow","stopped","fling over","enough","im back","done flinging"},notfound={"who?","dunno that name","never heard of em","cant find em","no clue who that is","idk that player","who dat?","not in server","aint see em","nope cant find","who bro","no idea","huh?","not finding em","no luck","wheres that?","say what?","not sure who that is","cant spot em","who u talkin bout","never seen that name","not here"},self={"thats me lol","bruh im me","cant do it to myself","no lol","im not doing that to me","why would i","that makes no sense","im the one doing stuff bro","cmon man","nah","nope","youre joking right","lol no","cant do that","seriously?","bro","why","no way","not doing that","thats weird","look at yourself","youre a comedian"}}
ROLE=nil commandPrefix="!"hostFilter={name=nil,userId=nil}originalHost={name=nil,userId=nil}hostLogRef=nil botLogRef=nil antiBan={detected=false}rotationOwner="Humanoid"pushLog=nil botLogBuffer={}CHAT_CONVERSATION={{role="system",content=CP}}CHAT_CONVERSATION2={{role="system",content=CP2}}isOwnerHost=false
local S={mode="Follow",orbiting=false,orbitLV=nil,orbitAO=nil,orbitAtt=nil,orbitSpeed=100,facing=false,faceConn=nil,hostName=nil,followThread=nil,tpCD=0,lastJump=0,lending=false,lendEnd=0,lendThread=nil,hidden=false,frozen=false,hidePos=nil,hideBP=nil,hideBG=nil,hideHB=nil,deathConn=nil,hostIsAfk=false,hostAfkTimer=0,hostLastPos=nil,lastRepath=0,waypoints=nil,totalSteps=0,recentMsgs={},lastCmd=nil,lastCmdTime=0,cmdHistory={},failCount=0,totalFail=0,lastHostPos=nil,cachedPath=nil,lastMovePos=nil,stuckCount=0,lastStuckCheck=0,lastStuckPos=nil,dancing=false,danceTrack=nil,spinning=false,spinConn=nil,spinSpeed=5,leadTarget=nil,leadActive=false,lastRealPos=nil,pushCheck=0,aiDecision="idle",aiLastDecision=0,dodgeUntil=0,dodgeDir=1,lastWaypoint=nil,committedTarget=nil,committedUntil=0,hostInVoid=false,hostVoidSafePos=nil,lastSafeHostPos=nil,lastHostJumpTime=0,mirrorJumpTime=0,pathAttempts=0,lastPathFail=0,microCamActive=false,mirrorWatcher=nil,microCamThread=nil,lastPathSig=nil,bamActive=false,bamTarget=nil,annoyActive=false,annoyTarget=nil,trollTpCD=0,flingActive=false,flingTarget=nil,flingStartTime=0,flingLastTargetPos=nil,flingOriginalState=nil,sitting=false,_lastThinking=0,deathCount=0,lastDeathTime=0,deathSilent=false,stableFollowDir=nil}
stopOrbit=nil stopSpin=nil stopDance=nil stopLead=nil stopBam=nil startBam=nil stopAnnoy=nil startAnnoy=nil stopFling=nil startFling=nil startFollow=nil stopFollow=nil sendChat=nil handleCommand=nil teleportToHost=nil handleMath=nil
function setRotationOwner(o)if rotationOwner==o then return end rotationOwner=o local h=hum()if not h then return end h.AutoRotate=(o=="Humanoid")end
function releaseRotation()setRotationOwner("Humanoid")end
function flashNoclip(d)d=d or SNT local c=pl.Character if not c then return end local sv={}for _,p in ipairs(c:GetDescendants())do if p:IsA("BasePart")then sv[p]=p.CanCollide pcall(function()p.CanCollide=false end)end end local cn=R.Stepped:Connect(function()local cc=pl.Character if not cc then return end for _,p in ipairs(cc:GetDescendants())do if p:IsA("BasePart")then pcall(function()p.CanCollide=false end)end end end)task.delay(d,function()if cn then cn:Disconnect()end for p,o in pairs(sv)do if p.Parent then pcall(function()p.CanCollide=o end)end end end)end
sendChat=function(t)if not t or t==""then return end if botLogRef and botLogRef.holder and pushLog then pushLog(botLogRef,t,C.text)else table.insert(botLogBuffer,t)end if ROLE=="HOST"then if privateChatRef and privateChatRef.holder and sendToChatRef then sendToChatRef(privateChatRef,"XcH",t)end return end if antiBan.detected then return end pcall(function()if TC and TC.ChatVersion==Enum.ChatVersion.TextChatService then local ch=TC:FindFirstChild("TextChannels")if ch then local g=ch:FindFirstChild("RBXGeneral")or ch:FindFirstChild("RBGGeneral")or ch:FindFirstChildWhichIsA("TextChannel")if g then g:SendAsync(t)return end end end local ev=RS:FindFirstChild("DefaultChatSystemChatEvents")if ev then local sr=ev:FindFirstChild("SayMessageRequest")if sr then sr:FireServer(t,"All")end end end)end
function sendSeq(l,d)d=d or 0.8 task.spawn(function()for _,m in ipairs(l)do sendChat(m)task.wait(d)end end)end
function isDuplicateMessage(uid,t)local n=os.clock()local k=tostring(uid).."|"..t if S.recentMsgs[k]and(n-S.recentMsgs[k])<DW then return true end S.recentMsgs[k]=n if math.random()<0.1 then for k,v in pairs(S.recentMsgs)do if n-v>3 then S.recentMsgs[k]=nil end end end return false end
handleMath=function(e)if not e or e==""then sendChat(pick({"math: !math <a><op><b>","usage: !math 1+1","bro give me numbers"}))return end local s=e:gsub("%s+",""):gsub("÷","/"):gsub("×","*"):gsub("−","-"):gsub("[xX]","*"):gsub(":","/")local a,op,b=s:match("^([%-%d%.]+)([%+%-%*/%%%^])([%-%d%.]+)$")if not a then sendChat(pick({"bad expression","thats not math","cmon try again"}))return end local x=tonumber(a)local y=tonumber(b)if not x or not y then sendChat("math error")return end local r if op=="+"then r=x+y elseif op=="-"then r=x-y elseif op=="*"then r=x*y elseif op=="/"then if y==0 then sendChat("cant divide by zero")return end r=x/y elseif op=="%"then if y==0 then sendChat("cant mod by zero")return end r=x%y elseif op=="^"then r=x^y else sendChat("unsupported op")return end local rs if r==math.floor(r)and math.abs(r)<1e15 then rs=tostring(math.floor(r))else rs=string.format("%.6f",r):gsub("0+$",""):gsub("%.$","")end sendChat(tostring(x).." "..op.." "..tostring(y).." = "..rs)end
function aiGetRequestFunc()local r=nil if type(request)=="function"then r=request end if not r and syn and type(syn.request)=="function"then r=syn.request end if not r and http and type(http.request)=="function"then r=http.request end if not r and type(http_request)=="function"then r=http_request end if not r and fluxus and type(fluxus.request)=="function"then r=fluxus.request end if not r and krnl and type(krnl.request)=="function"then r=krnl.request end if not r and kavo and type(kavo.request)=="function"then r=kavo.request end return r end
function getResetCountdown()local n=os.time()local po=-8*3600 local pn=n+po local pt=os.date("!*t",pn)local sd=pt.hour*3600+pt.min*60+pt.sec local sr=86400-sd local h=math.floor(sr/3600)local m=math.floor((sr%3600)/60)return h,m end
function sendAIRequest(u,mt,us,_key)
_key=_key or APIKey
if not _key or _key==""then return nil,"nokey","no key"end
local rf=aiGetRequestFunc()if not rf then return nil,"nohttp","no request func"end
local tr={CHAT_CONVERSATION[1]}local hl=#CHAT_CONVERSATION-1 local si=2 if hl>MCH then si=#CHAT_CONVERSATION-MCH+1 end for i=si,#CHAT_CONVERSATION do tr[#tr+1]=CHAT_CONVERSATION[i]end tr[#tr+1]={role="user",content=u}local st=nil local co={}for _,m in ipairs(tr)do if m.role=="system"then st=(st and(st.."\n")or"")..tostring(m.content)elseif m.role=="user"then co[#co+1]={role="user",parts={{text=tostring(m.content)}}}elseif m.role=="assistant"then co[#co+1]={role="model",parts={{text=tostring(m.content)}}}end end if st and #co>0 and co[1].role=="user"then co[1].parts[1].text=st.."\n\n"..co[1].parts[1].text elseif st then table.insert(co,1,{role="user",parts={{text=st}}})end local pl_={contents=co,generationConfig={maxOutputTokens=mt or 200,temperature=us and 1.0 or 0.75}}if us then pl_.tools={{google_search={}}}end local ok,en=pcall(function()return H:JSONEncode(pl_)end)if not ok or not en then return nil,"json","encode failed"end local uw=BGE..AMI..":generateContent"local ok,rsp=pcall(rf,{Url=uw,Method="POST",Headers={["Content-Type"]="application/json",["x-goog-api-key"]=tostring(_key)},Body=en})if not ok then return nil,"http",tostring(rsp):sub(1,120)end if not rsp then return nil,"http","no response"end local rb=rsp.Body or rsp.body if rb==nil then rb=rsp end if type(rb)~="string"then local ok2,s=pcall(function()return H:JSONEncode(rb)end)rb=ok2 and s or tostring(rb)end if rb==""then local cd=rsp.StatusCode or rsp.Status or "?"return nil,"http","empty body HTTP "..tostring(cd)end local dk,data=pcall(function()return H:JSONDecode(rb)end)if not dk or not data then return nil,"json",rb:sub(1,80)end local em=nil if data.error then local m=data.error.message or data.error if type(m)~="string"then m=H:JSONEncode(m)end em=tostring(m)end if em then local lw=em:lower()if us and(lw:find("tool")or lw:find("google_search")or lw:find("grounding")or lw:find("not supported")or lw:find("invalid"))then return nil,"tools_unsupported",em:sub(1,150)end if lw:find("quota")or lw:find("exceeded")or lw:find("rate limit")or lw:find("429")then if _key==APIKey and APIKey3 and APIKey3~=""and APIKey3~=_key then return sendAIRequest(u,mt,us,APIKey3)end return nil,"quota",em:sub(1,90)end if lw:find("high demand")or lw:find("overload")or lw:find("503")or lw:find("unavailable")or lw:find("temporarily")then return nil,"busy",em:sub(1,90)end if lw:find("not found")or lw:find("does not exist")or lw:find("404")then return nil,"invalid_model","model unavailable"end return nil,"api",em:sub(1,90)end if not data.candidates or #data.candidates==0 then if data.promptFeedback and data.promptFeedback.blockReason then return nil,"blocked","blocked"end return nil,"nochoices","no candidates"end local cd=data.candidates[1]if not cd.content or not cd.content.parts or #cd.content.parts==0 then return nil,"nomsg","no parts"end local tx=nil for _,p in ipairs(cd.content.parts)do if p.text and p.text~=""then tx=p.text break end end if not tx or tx==""then return nil,"nomsg","empty text"end pcall(function()if data.usageMetadata and TU then local um=data.usageMetadata TU.prompt=(TU.prompt or 0)+(um.promptTokenCount or 0)TU.candidates=(TU.candidates or 0)+(um.candidatesTokenCount or 0)TU.total=(TU.total or 0)+(um.totalTokenCount or 0)TU.requests=(TU.requests or 0)+1 end end)return tx,nil,nil end
function sendAIRequest2(u,mt,us,_key,_noThink)
_key=_key or APIKey2
if not _key or _key==""then return nil,"nokey","no key"end
local rf=aiGetRequestFunc()if not rf then return nil,"nohttp","no request func"end
local tr={CHAT_CONVERSATION2[1]}local hl=#CHAT_CONVERSATION2-1 local si=2 if hl>6 then si=#CHAT_CONVERSATION2-6+1 end for i=si,#CHAT_CONVERSATION2 do tr[#tr+1]=CHAT_CONVERSATION2[i]end tr[#tr+1]={role="user",content=u}local st=nil local co={}for _,m in ipairs(tr)do if m.role=="system"then st=(st and(st.."\n")or"")..tostring(m.content)elseif m.role=="user"then co[#co+1]={role="user",parts={{text=tostring(m.content)}}}elseif m.role=="assistant"then co[#co+1]={role="model",parts={{text=tostring(m.content)}}}end end if st and #co>0 and co[1].role=="user"then co[1].parts[1].text=st.."\n\n"..co[1].parts[1].text elseif st then table.insert(co,1,{role="user",parts={{text=st}}})end local gc={maxOutputTokens=mt or 4000,temperature=0.35}if not _noThink then gc.thinkingConfig={thinkingLevel="HIGH"}end local pl_={contents=co,generationConfig=gc}local ok,en=pcall(function()return H:JSONEncode(pl_)end)if not ok or not en then return nil,"json","encode failed"end local uw=BGE..AMI..":generateContent"local ok,rsp=pcall(rf,{Url=uw,Method="POST",Headers={["Content-Type"]="application/json",["x-goog-api-key"]=tostring(_key)},Body=en})if not ok then return nil,"http",tostring(rsp):sub(1,120)end if not rsp then return nil,"http","no response"end local rb=rsp.Body or rsp.body if rb==nil then rb=rsp end if type(rb)~="string"then local ok2,s=pcall(function()return H:JSONEncode(rb)end)rb=ok2 and s or tostring(rb)end if rb==""then local cd=rsp.StatusCode or rsp.Status or "?"return nil,"http","empty body HTTP "..tostring(cd)end local dk,data=pcall(function()return H:JSONDecode(rb)end)if not dk or not data then return nil,"json",rb:sub(1,80)end local em=nil if data.error then local m=data.error.message or data.error if type(m)~="string"then m=H:JSONEncode(m)end em=tostring(m)end if em then local lw=em:lower()if lw:find("thinking")or lw:find("thinkingconfig")or lw:find("thinkinglevel")then if not _noThink then return sendAIRequest2(u,mt,us,_key,true)end return nil,"thinking_unsupported",em:sub(1,150)end if lw:find("quota")or lw:find("exceeded")or lw:find("rate limit")or lw:find("429")then if _key==APIKey2 and APIKey4 and APIKey4~=""and APIKey4~=_key then return sendAIRequest2(u,mt,us,APIKey4,_noThink)end return nil,"quota",em:sub(1,90)end if lw:find("high demand")or lw:find("overload")or lw:find("503")or lw:find("unavailable")or lw:find("temporarily")then return nil,"busy",em:sub(1,90)end if lw:find("not found")or lw:find("404")then return nil,"invalid_model","model unavailable"end return nil,"api",em:sub(1,90)end if not data.candidates or #data.candidates==0 then if data.promptFeedback and data.promptFeedback.blockReason then return nil,"blocked","blocked"end return nil,"nochoices","no candidates"end local cd=data.candidates[1]if not cd.content or not cd.content.parts or #cd.content.parts==0 then if not _noThink then return sendAIRequest2(u,mt,us,_key,true)end return nil,"nomsg","no parts"end local tx=nil for _,p in ipairs(cd.content.parts)do if p.text and p.text~=""then tx=p.text break end end if not tx or tx==""then if not _noThink then return sendAIRequest2(u,mt,us,_key,true)end return nil,"nomsg","empty text"end return tx,nil,nil end
function aiChunkSend(t)if not t then return end t=t:gsub("%s+"," "):gsub("^%s+",""):gsub("%s+$","")if t==""then t="hm"end local MX=180 if #t<=MX then sendChat(t)return end local cs={}local w=t while #w>MX do local cut=w:sub(1,MX):find("%s[^%s]*$")if not cut then cut=MX end table.insert(cs,w:sub(1,cut))w=w:sub(cut+1):gsub("^%s+","")end if #w>0 then table.insert(cs,w)end task.spawn(function()for i,c in ipairs(cs)do sendChat(c)if i<#cs then task.wait(0.35)end end end)end
function extractCodeBlock(text)if not text then return nil end local code=text:match("```lua%s*(.-)%s*```")if not code then code=text:match("```%s*(.-)%s*```")end if not code then if text:find("game%.")or text:find("Instance%.new")or text:find("LocalPlayer")then code=text end end if code then code=code:gsub("^%s+",""):gsub("%s+$","")end return code end
function handleCodePipeline(req,isPublic)
if not req or req==""then return end
if ROLE=="BOT"then
sendChat(pick({"on it boss","writing it now","one sec boss","gimme a sec","on it"}))
task.spawn(function()
task.wait(2.5+math.random()*1.5)
sendChat(pick({"done boss","executed","its live boss","works now","try it","running"}))
end)
return
end
if ROLE~="HOST"then return end
sendToPrivateChat("XcH",pick({"on it boss","writing it now","one sec boss","gimme a sec","on it"}))
task.spawn(function()
local prompt="Request: "..req.."\n\nGive me working executor code only."
local reply,et,em=sendAIRequest2(prompt,4000,false)
if not reply then
local why="coder offline"
if et=="quota"then why="coder out of fuel"
elseif et=="busy"then why="coder busy"
elseif et=="nohttp"then why="no http in executor"
elseif et=="nomsg"then why="coder drew a blank"
elseif em then why=tostring(em):sub(1,70)end
sendToPrivateChat("XcH","couldnt do it - "..why)
return
end
local code=extractCodeBlock(reply)
if not code or code==""then
sendToPrivateChat("XcH","coder gave nothing usable, try rephrasing")
return
end
local fn,compileErr=loadstring(code)
if not fn then
sendToPrivateChat("XcH","compile error: "..tostring(compileErr):sub(1,90))
return
end
local ok,runErr=pcall(fn)
if ok then
sendToPrivateChat("XcH",pick({"done boss","executed","its live boss","works now","try it","running"}))
else
sendToPrivateChat("XcH","runtime error: "..tostring(runErr):sub(1,90))
end
end)
end
function checkCodeReq(rp,isPublic)
local req=rp:match("%[%[CODEREQ%]%](.-)%[%[/CODEREQ%]%]")
if req and req~=""then
req=trim(req)
handleCodePipeline(req,isPublic)
return true
end
return false
end
function handleAIChat(u)if not u or u==""then return end if not APIKey or APIKey==""then sendChat("no api key set")return end local n=tick()if n-LRT<RCL then local wt=math.ceil(RCL-(n-LRT))sendChat(pick({"chill wait "..wt.."s","hold on "..wt.."s","wait up "..wt.."s"}))return end LRT=n local us=needsSearch(u)task.spawn(function()local rp,et,em=sendAIRequest(u,200,us)if not rp and et=="tools_unsupported"then rp,et,em=sendAIRequest(u,200,false)end if not rp then if botLogRef and botLogRef.holder and pushLog then pushLog(botLogRef,"[xch] failed: "..tostring(et),C.red)if em then pushLog(botLogRef,"[xch] "..tostring(em):sub(1,90),C.red)end end if et=="busy"then sendChat(pick({"im busy rn","hold up","one sec"}))elseif et=="quota"then local h,m=getResetCountdown()sendChat("out of fuel, back in "..h.."h "..m.."m")elseif et=="blocked"then sendChat(pick({"got blocked","cant answer that one","nope try again"}))elseif et=="invalid_model"then sendChat("model down rn")else sendChat(pick({"something went wrong","try again","rip"}))end return end CHAT_CONVERSATION[#CHAT_CONVERSATION+1]={role="user",content=u}CHAT_CONVERSATION[#CHAT_CONVERSATION+1]={role="assistant",content=rp}while #CHAT_CONVERSATION>MCH+1 do table.remove(CHAT_CONVERSATION,2)end rp=trim(rp)if checkCodeReq(rp,true)then return end if rp~=""then aiChunkSend(rp)end end)end
privateChatRef={holder=nil,scroll=nil,empty=nil,scrollTween=nil}
xcodeChatRef={holder=nil,scroll=nil,empty=nil,scrollTween=nil}
function scrollToBottomRef(cref)local sf=cref.scroll if not sf then return end task.spawn(function()R.Heartbeat:Wait()R.Heartbeat:Wait()local function go(f)local ty=math.max(0,sf.AbsoluteCanvasSize.Y-sf.AbsoluteWindowSize.Y)if not f and math.abs(ty-sf.CanvasPosition.Y)<2 then return end if cref.scrollTween then pcall(function()cref.scrollTween:Cancel()end)cref.scrollTween=nil end local tn=T:Create(sf,TweenInfo.new(0.35,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),{CanvasPosition=Vector2.new(0,ty)})cref.scrollTween=tn tn:Play()end go(true)task.wait(0.15)go(false)task.wait(0.25)go(false)end)end
function scrollToBottom2()scrollToBottomRef(xcodeChatRef)end
function sendToChatRef(cref,sd,t)if not cref.holder then return end if cref.empty then cref.empty.Visible=false end if not t or t==""then t="..."end local isMe=(sd=="me")local rw=Instance.new("Frame")rw.Size=UDim2.new(1,0,0,0)rw.AutomaticSize=Enum.AutomaticSize.Y rw.BackgroundTransparency=1 rw.Parent=cref.holder local bb=Instance.new("Frame")bb.Size=UDim2.new(0,0,0,0)bb.AutomaticSize=Enum.AutomaticSize.XY bb.BackgroundColor3=isMe and C.meBubble or C.aiBubble bb.BackgroundTransparency=1 bb.BorderSizePixel=0 bb.Parent=rw corner(bb,12)local mw=250 local cn=Instance.new("UISizeConstraint")cn.MaxSize=Vector2.new(mw,math.huge)cn.Parent=bb local so=nil if not isMe then so=Instance.new("UIStroke")so.Color=C.border so.Thickness=1 so.Transparency=1 so.ApplyStrokeMode=Enum.ApplyStrokeMode.Border so.Parent=bb end local pd=Instance.new("UIPadding")pd.PaddingTop=UDim.new(0,7)pd.PaddingBottom=UDim.new(0,7)pd.PaddingLeft=UDim.new(0,12)pd.PaddingRight=UDim.new(0,12)pd.Parent=bb local tx=Instance.new("TextLabel")tx.Size=UDim2.new(0,0,0,0)tx.AutomaticSize=Enum.AutomaticSize.XY tx.BackgroundTransparency=1 tx.Font=Enum.Font.Code tx.Text=tostring(t)tx.TextColor3=C.text tx.TextSize=11 tx.TextWrapped=true tx.TextTransparency=1 tx.TextXAlignment=Enum.TextXAlignment.Left tx.TextYAlignment=Enum.TextYAlignment.Top tx.Parent=bb local tc=Instance.new("UISizeConstraint")tc.MaxSize=Vector2.new(mw-24,math.huge)tc.Parent=tx if not cref.holder:FindFirstChildOfClass("UIListLayout")then local lay=Instance.new("UIListLayout")lay.SortOrder=Enum.SortOrder.LayoutOrder lay.Padding=UDim.new(0,6)lay.Parent=cref.holder end local sp,ep if isMe then bb.AnchorPoint=Vector2.new(1,0)ep=UDim2.new(1,-24,0,0)sp=UDim2.new(1,-2,0,0)else bb.AnchorPoint=Vector2.new(0,0)ep=UDim2.new(0,0,0,0)sp=UDim2.new(0,-20,0,0)end bb.Position=sp T:Create(bb,TweenInfo.new(0.38,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),{Position=ep,BackgroundTransparency=0}):Play()T:Create(tx,TweenInfo.new(0.38,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),{TextTransparency=0}):Play()if so then T:Create(so,TweenInfo.new(0.38,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),{Transparency=0.3}):Play()end scrollToBottomRef(cref)end
function sendToPrivateChat(sd,t)return sendToChatRef(privateChatRef,sd,t)end
function sendToXcodeChat(sd,t)return sendToChatRef(xcodeChatRef,sd,t)end
function handlePrivateAIChat2(u)if not u or u==""then return end if not APIKey2 or APIKey2==""then sendToXcodeChat("Xcode","no api key set")return end sendToXcodeChat("me",u)task.spawn(function()local rp,et,em=sendAIRequest2(u,4000,false)if not rp then local et2="something went wrong"if et=="busy"then et2="im busy rn"elseif et=="quota"then et2="out of fuel"elseif et=="blocked"then et2="got blocked"elseif et=="invalid_model"then et2="model down rn"elseif et=="nokey"then et2="no key set"elseif et=="nohttp"then et2="no http in executor"elseif em then et2=et2.." | "..tostring(em):sub(1,80)end sendToXcodeChat("Xcode",et2)return end CHAT_CONVERSATION2[#CHAT_CONVERSATION2+1]={role="user",content=u}CHAT_CONVERSATION2[#CHAT_CONVERSATION2+1]={role="assistant",content=rp}while #CHAT_CONVERSATION2>6 do table.remove(CHAT_CONVERSATION2,2)end sendToXcodeChat("Xcode",trim(rp))end)end
logCounter=0
pushLog=function(rf,t,col)if not rf or not rf.holder then return end logCounter=logCounter+1 if rf.empty then rf.empty.Visible=false end local e=Instance.new("TextLabel")e.Size=UDim2.new(1,0,0,14)e.AutomaticSize=Enum.AutomaticSize.Y e.BackgroundTransparency=1 e.Font=Enum.Font.Code e.Text=t e.TextColor3=col or C.text e.TextSize=10 e.TextXAlignment=Enum.TextXAlignment.Left e.TextYAlignment=Enum.TextYAlignment.Top e.TextWrapped=true e.TextTransparency=1 e.LayoutOrder=logCounter e.Parent=rf.holder tw(e,0.22,{TextTransparency=0})task.delay(0.05,function()if rf.holder and rf.holder.Parent and rf.holder:IsA("ScrollingFrame")then pcall(function()rf.holder.CanvasPosition=Vector2.new(0,math.huge)end)end end)end
function flushBotLogBuffer()if not botLogRef or not botLogRef.holder then return end for _,t in ipairs(botLogBuffer)do pushLog(botLogRef,t,C.text)end botLogBuffer={}end
function isFromHost(uid)if ROLE=="HOST"and uid==pl.UserId then return true end if hostFilter.userId and uid==hostFilter.userId then return true end if originalHost.userId and uid==originalHost.userId then return true end if hostFilter.name then local p=P:GetPlayerByUserId(uid)if p and p.Name:lower()==hostFilter.name then return true end end if originalHost.name then local p=P:GetPlayerByUserId(uid)if p and p.Name:lower()==originalHost.name then return true end end return false end
function getHost()if not S.hostName then return nil end for _,p in ipairs(P:GetPlayers())do if p.Name:lower()==S.hostName then return p end end return nil end
function getHostHRP()local h=getHost()return h and h.Character and h.Character:FindFirstChild("HumanoidRootPart")or nil end
function getPlayer(name)if not name then return nil end local n=name:lower()if n==""then return nil end for _,p in ipairs(P:GetPlayers())do if p.Name:lower()==n or p.DisplayName:lower()==n then return p end end for _,p in ipairs(P:GetPlayers())do if p.Name:lower():sub(1,#n)==n or p.DisplayName:lower():sub(1,#n)==n then return p end end for _,p in ipairs(P:GetPlayers())do if p.Name:lower():find(n,1,true)or p.DisplayName:lower():find(n,1,true)then return p end end return nil end
function getPlayerHRP(p)return p and p.Character and p.Character:FindFirstChild("HumanoidRootPart")or nil end
function applyFixedSpeed()local h=hum()if h then pcall(function()h.WalkSpeed=BS h.JumpPower=BJ h.UseJumpPower=true end)end end
task.spawn(function()while true do task.wait(1)if ROLE=="BOT"and not S.hidden and not antiBan.detected and not S.sitting then local h=hum()if h and h.WalkSpeed~=BS and not S.flingActive and not S.swordKillActive then pcall(function()h.WalkSpeed=BS end)end end end end)
function getLookTarget()if rotationOwner=="FaceHost"then local h=hum()if not h then return nil end if h.MoveDirection.Magnitude>0.1 then return nil end local host=getHost()local hh=getHostHRP()local m=hrp()if host and hh and m then local d=(hh.Position-m.Position).Magnitude if d<=LR then return host end end elseif rotationOwner=="FaceTarget"then local t=S.annoyTarget or S.swordKillTarget if t and t.Parent and t.Character then return t end end return nil end
function startFacing()if S.facing then return end S.facing=true S.faceConn=R.Heartbeat:Connect(function(dt)if ROLE~="BOT"then return end if S.hidden or antiBan.detected then return end if rotationOwner~="FaceHost"and rotationOwner~="FaceTarget"then return end local tg=getLookTarget()if not tg or not tg.Character then return end local rt=hrp()if not rt then return end local hd=tg.Character:FindFirstChild("Head")local tp=hd and hd.Position or(tg.Character.HumanoidRootPart and tg.Character.HumanoidRootPart.Position)if not tp then return end local dr=tp-rt.Position local fl=Vector3.new(dr.X,0,dr.Z)if fl.Magnitude<0.05 then return end fl=fl.Unit local lk=rt.CFrame.LookVector local cf=Vector3.new(lk.X,0,lk.Z)if cf.Magnitude<0.05 then cf=Vector3.new(0,0,-1)end cf=cf.Unit local al=1-math.exp(-14*dt)local sm=cf:Lerp(fl,al)if sm.Magnitude<0.01 then return end sm=sm.Unit pcall(function()rt.CFrame=CFrame.lookAt(rt.Position,rt.Position+sm)end)end)end
DANCE_EMOTES={[1]="/e dance1",[2]="/e dance2",[3]="/e dance3",[4]="/e dance4"}
function stopDance()S.dancing=false if S.danceTrack then pcall(function()S.danceTrack:Stop(0.2)end)S.danceTrack=nil end end
function playDance(n)n=tonumber(n)or 1 if n<1 or n>4 then n=1 end stopDance()sendChat(DANCE_EMOTES[n])task.wait(0.05)sendChat(pick(R_.dance))S.dancing=true return true end
stopSpin=function()S.spinning=false if S.spinConn then S.spinConn:Disconnect()S.spinConn=nil end if S.mode=="Spin"then S.mode="Follow"releaseRotation()end end
function startSpin(sp)sp=tonumber(sp)or 5 sp=math.clamp(sp,1,100)S.spinSpeed=sp if S.spinning then sendChat(pick({"speed is now "..sp,"updated to "..sp,"changed to "..sp}))return end stopDance()S.spinning=true S.mode="Spin"setRotationOwner("Spin")local h=hum()if h then local m=hrp()if m then h:MoveTo(m.Position)end end S.spinConn=R.Heartbeat:Connect(function(dt)if not S.spinning then return end if ROLE~="BOT"then return end if S.hidden or antiBan.detected then return end local m=hrp()if not m then return end local st=math.rad(sp*60*dt)pcall(function()m.CFrame=m.CFrame*CFrame.Angles(0,st,0)end)end)sendChat(pick(R_.spin))end
stopLead=function(an)if S.leadActive then S.leadActive=false S.leadTarget=nil if S.mode=="Lead"then S.mode="Follow"releaseRotation()end if an then sendChat(pick(R_.unlead))end end end
function startLead(name)if not name or name==""then sendChat("usage: !lead <player>")return end local t=getPlayer(name)if not t then sendChat(pick(R_.notfound))return end if t==pl then sendChat(pick(R_.self))return end stopOrbit()stopSpin()stopDance()stopBam(false)stopAnnoy(false)stopFling(false)S.leadTarget=t S.leadActive=true S.mode="Lead"S.waypoints=nil S.cachedPath=nil S.lastMovePos=nil S.committedTarget=nil sendChat(pick(R_.lead).." "..t.Name)end
function computePath(from,to)local path=PS:CreatePath({AgentRadius=2.5,AgentHeight=5,AgentCanJump=true,AgentJumpHeight=11,AgentCanClimb=true,AgentMaxSlope=45,WaypointSpacing=3})for _=1,PA do local ok=pcall(function()path:ComputeAsync(from,to)end)if ok and path.Status==Enum.PathStatus.Success then return path:GetWaypoints()end task.wait(0.02)end S.lastPathFail=os.clock()return nil end
rayFilter={pl.Character}
function mkRP(iw)local rp=RaycastParams.new()rp.FilterType=Enum.RaycastFilterType.Exclude rp.FilterDescendantsInstances=rayFilter rp.IgnoreWater=iw~=false return rp end
function analyzePart(inst)if not inst or not inst:IsA("BasePart")then return nil end local size=inst.Size local minH=math.min(size.X,size.Z)return{class=inst.ClassName,name=inst.Name,size=size,minHoriz=minH,height=size.Y,transparency=inst.Transparency,canCollide=inst.CanCollide,isSlim=(minH<SBM and size.Y<2),isThin=(minH<1.0),isTransparent=(inst.Transparency>0.5),isWalkable=(inst.CanCollide and inst.Transparency<0.95 and size.Y<=3)}end
function probeFloor(pos)local rp=mkRP(true)local hit=W:Raycast(pos+Vector3.new(0,6,0),Vector3.new(0,-60,0),rp)if not hit then return false,nil,nil end return true,hit,analyzePart(hit.Instance)end
function hasFloorBelow(pos)return probeFloor(pos)end
function visionClear(fp,tp)local dr=tp-fp local fl=Vector3.new(dr.X,0,dr.Z)local ds=fl.Magnitude if ds<0.1 then return true,"clear"end fl=fl.Unit local rp=mkRP(false)local wh=W:Raycast(fp+Vector3.new(0,2,0),fl*ds,rp)if wh then local pc=wh.Instance and wh.Instance:FindFirstAncestorOfClass("Model")local hp=pc and P:GetPlayerFromCharacter(pc)if not hp then return false,"wall",nil,wh end return true,"player",hp,wh end local sc=math.max(3,math.ceil(ds/5))for i=1,sc do local cp=fp+fl*(ds*(i/sc))local ok,_,inf=probeFloor(cp)if not ok then return false,"void"end if inf and inf.isThin and not inf.isWalkable then return false,"slim"end end return true,"clear"end
function checkAheadObstacle(fp,dr,md)local fl=Vector3.new(dr.X,0,dr.Z)if fl.Magnitude<0.1 then return "clear",nil,nil end fl=fl.Unit local rp=mkRP(false)local wh=W:Raycast(fp+Vector3.new(0,2,0),fl*md,rp)if wh then local inf=analyzePart(wh.Instance)if inf and inf.canCollide and not inf.isTransparent then local nm=wh.Normal if math.abs(nm.Y)<0.35 then return "wall",wh,inf end if nm.Y<0.75 and nm.Y>0.35 then return "slope",wh,inf end end end for _,d in ipairs({md*0.35,md*0.55,md*0.75,md})do local cp=fp+fl*d local ok,hit,inf=probeFloor(cp)if not ok then return "void_risk",nil,nil end local gp=(cp.Y+6)-hit.Position.Y if gp>SED then return "steep_drop",hit,inf end if inf and inf.isThin then return "slim",hit,inf end end return "clear",nil,nil end
function isInVoid(pos)return pos and pos.Y<VT end
function findPlayerInFront(fp,dr,md)local rp=mkRP(false)local hit=W:Raycast(fp+Vector3.new(0,2,0),dr*md,rp)if hit and hit.Instance then local ml=hit.Instance:FindFirstAncestorOfClass("Model")if ml then local p2=P:GetPlayerFromCharacter(ml)if p2 then return p2,hit end end end return nil end
function planDodge(fp,tp)local dr=tp-fp dr=Vector3.new(dr.X,0,dr.Z)if dr.Magnitude<0.1 then return nil end dr=dr.Unit local lf=Vector3.new(-dr.Z,0,dr.X)local rg=Vector3.new(dr.Z,0,-dr.X)local lo=hasFloorBelow(fp+lf*7)local ro=hasFloorBelow(fp+rg*7)if lo and ro then local td=(tp-fp)td=Vector3.new(td.X,0,td.Z).Unit if(lf+td).Magnitude<(rg+td).Magnitude then return "left"else return "right"end elseif lo then return "left"elseif ro then return "right"else return "jump"end end
function tryJump()local h,m=hum(),hrp()if not h or not m then return end if os.clock()-S.lastJump<0.45 then return end if h.FloorMaterial==Enum.Material.Air then return end S.lastJump=os.clock()h.Jump=true end
function checkStuck()local h,m=hum(),hrp()if not h or not m then return end if os.clock()-S.lastStuckCheck<0.5 then return end S.lastStuckCheck=os.clock()if not S.lastMovePos then S.stuckCount=0 return end local mv=0 if S.lastStuckPos then mv=(m.Position-S.lastStuckPos).Magnitude end S.lastStuckPos=m.Position if mv<1.0 then S.stuckCount=S.stuckCount+1 if S.stuckCount>=2 then S.stuckCount=0 flashNoclip(SNT)task.delay(0.05,function()local h2=hum()if h2 and S.lastMovePos then h2:MoveTo(S.lastMovePos)end end)end else S.stuckCount=0 end end
function checkPush()local m=hrp()local hh=getHostHRP()if not m or not hh then return end if os.clock()-S.pushCheck<0.5 then return end S.pushCheck=os.clock()if S.mode~="Follow"then S.lastRealPos=m.Position return end if S.lastRealPos then local dl=(m.Position-S.lastRealPos).Magnitude local vl=m.AssemblyLinearVelocity.Magnitude if dl>15 and vl>30 then local bk=hh.CFrame.LookVector*-5 pcall(function()m.CFrame=CFrame.new(hh.Position+Vector3.new(bk.X,3,bk.Z))m.AssemblyLinearVelocity=Vector3.zero m.AssemblyAngularVelocity=Vector3.zero end)S.waypoints=nil S.cachedPath=nil S.lastMovePos=nil S.committedTarget=nil end end S.lastRealPos=m.Position end
stopOrbit=function()S.orbiting=false if S.orbitLV then pcall(function()S.orbitLV:Destroy()end)S.orbitLV=nil end if S.orbitAO then pcall(function()S.orbitAO:Destroy()end)S.orbitAO=nil end if S.orbitAtt then pcall(function()S.orbitAtt:Destroy()end)S.orbitAtt=nil end if S.mode=="Orbit"then S.mode="Follow"releaseRotation()end end
teleportToHost=function()local hh,m=getHostHRP(),hrp()if not hh or not m then return end local bk=hh.CFrame.LookVector*-5 pcall(function()m.CFrame=CFrame.new(hh.Position+Vector3.new(bk.X,3,bk.Z))m.AssemblyLinearVelocity=Vector3.zero m.AssemblyAngularVelocity=Vector3.zero end)S.waypoints=nil S.cachedPath=nil S.lastMovePos=nil S.committedTarget=nil S.stableFollowDir=nil end
stopBam=function(an)if S.bamActive then S.bamActive=false S.bamTarget=nil if S.mode=="Bam"then S.mode="Follow"releaseRotation()end if an then sendChat(pick(R_.unbam))end end end
startBam=function(name)if not name or name==""then sendChat("usage: !bam <player>")return end local t=getPlayer(name)if not t then sendChat(pick(R_.notfound))return end if t==pl then sendChat(pick(R_.self))return end stopOrbit()stopSpin()stopDance()stopLead(false)stopAnnoy(false)stopFling(false)stopSwordKill(false)S.bamTarget=t S.bamActive=true S.mode="Bam"S.waypoints=nil S.cachedPath=nil S.lastMovePos=nil S.committedTarget=nil sendChat(pick(R_.bam).." "..t.Name)end
ANNOY_MSGS={"You got games on your pone?","omg so sigma","tung tung tung sahur","ballerina capuchina","tripi tropi tripi tropa","brrrrrrrrr brrrrrr patapim","jonkler","hey you","hey hey","bro","HEY","listen","dlawg","auuuuu","67","karasame kudasai!","DATEBAYO!! BAKAAAA","mega maxxing","hoyaaaahhh","heyyy dont ignore me senpai","Purr now my kitten","hey bro","HEYY!!!","listen to me man","tralalero tralala","bombardiro crocadilo","uwu","larp","67777","you in ohio","womp womp","who are you bro?","hey bro","L bro","REEEEEEEE","your face..","omg bro what","HELL NO","WHAT ARE THOSEEE..."}
stopAnnoy=function(an)if S.annoyActive then S.annoyActive=false S.annoyTarget=nil if S.mode=="Annoy"then S.mode="Follow"releaseRotation()end if an then sendChat(pick(R_.unannoy))end end end
startAnnoy=function(name)if not name or name==""then sendChat("usage: !annoy <player>")return end local t=getPlayer(name)if not t then sendChat(pick(R_.notfound))return end if t==pl then sendChat(pick(R_.self))return end stopOrbit()stopSpin()stopDance()stopLead(false)stopBam(false)stopFling(false)stopSwordKill(false)S.annoyTarget=t S.annoyActive=true S.mode="Annoy"setRotationOwner("FaceTarget")S.waypoints=nil S.cachedPath=nil S.lastMovePos=nil S.committedTarget=nil sendChat(pick(R_.annoy).." "..t.Name)end
function setBotCollide(state)local c=pl.Character if not c then return end for _,p in ipairs(c:GetDescendants())do if p:IsA("BasePart")then pcall(function()p.CanCollide=state end)end end end
function setBotMassive(en)local c=pl.Character if not c then return end for _,p in ipairs(c:GetDescendants())do if p:IsA("BasePart")then pcall(function()if en then p.Massless=false p.CustomPhysicalProperties=PhysicalProperties.new(100,0.3,0,1,1)else p.CustomPhysicalProperties=nil p.Massless=false end end)end end end
stopFling=function(an,sr)if not S.flingActive then return end S.flingActive=false S.flingTarget=nil S.flingLastTargetPos=nil S.flingStartTime=0 setBotMassive(false)local h=hum()if h then pcall(function()h:ChangeState(Enum.HumanoidStateType.GettingUp)end)pcall(function()h.PlatformStand=false h.WalkSpeed=BS h.JumpPower=BJ end)end setBotCollide(true)if S.mode=="Fling"then S.mode="Follow"releaseRotation()end if an then sendChat(pick(R_.unfling))end if sr then teleportToHost()end end
startFling=function(name)if not name or name==""then sendChat("usage: !fling <player>")return end local t=getPlayer(name)if not t then sendChat(pick(R_.notfound))return end if t==pl then sendChat(pick(R_.self))return end local thrp=getPlayerHRP(t)if not thrp then sendChat("target has no body")return end if isInVoid(thrp.Position)then sendChat("target in void")return end stopOrbit()stopSpin()stopDance()stopLead(false)stopBam(false)stopAnnoy(false)stopSwordKill(false)S.flingTarget=t S.flingActive=true S.flingStartTime=os.clock()S.flingLastTargetPos=thrp.Position S.mode="Fling"setRotationOwner("Fling")local h=hum()if h then pcall(function()h:ChangeState(Enum.HumanoidStateType.Physics)end)end setBotCollide(true)setBotMassive(true)sendChat(pick(R_.fling).." "..t.Name)end
task.spawn(function()while true do R.Heartbeat:Wait()if not S.flingActive or ROLE~="BOT"or antiBan.detected then continue end if S.hidden then continue end local tg=S.flingTarget if not tg or not tg.Parent then stopFling(false,false)continue end local th=getPlayerHRP(tg)local m=hrp()if not th or not m then continue end local t=os.clock()local rx=math.rad((t*FSX)%360)local ry=math.rad((t*FSY)%360)local rz=math.rad((t*FSZ)%360)local jt=Vector3.new((math.random()-0.5)*0.6,(math.random()-0.5)*0.6,(math.random()-0.5)*0.6)local ip=th.Position+jt local rv=Vector3.new(math.random(-FLV,FLV),math.random(-FLV,FLV),math.random(-FLV,FLV))local rav=Vector3.new(math.random(-FAV,FAV),math.random(-FAV,FAV),math.random(-FAV,FAV))pcall(function()m.CFrame=CFrame.new(ip)*CFrame.Angles(rx,ry,rz)m.AssemblyLinearVelocity=rv m.AssemblyAngularVelocity=rav end)local c=pl.Character if c then for _,p2 in ipairs(c:GetDescendants())do if p2:IsA("BasePart")and p2~=m then pcall(function()p2.AssemblyLinearVelocity=rv p2.AssemblyAngularVelocity=rav end)end end end if S.flingLastTargetPos and(os.clock()-S.flingStartTime)>FDW then local mv=(th.Position-S.flingLastTargetPos).Magnitude local vl=th.AssemblyLinearVelocity.Magnitude if vl>FDV or mv>FDD then sendChat(pick({"flung em","target yeeted","got em"}))stopFling(false,false)task.wait(0.1)teleportToHost()task.wait(0.4)continue end end S.flingLastTargetPos=th.Position if os.clock()-S.flingStartTime>FMD then sendChat(pick({"timed out","giving up","eh"}))stopFling(false,false)teleportToHost()end end end)
task.spawn(function()while true do task.wait(0.02)if not S.bamActive or ROLE~="BOT"or antiBan.detected then continue end if S.hidden then continue end local tg=S.bamTarget if not tg or not tg.Parent then task.wait(0.4)continue end local th=getPlayerHRP(tg)local m=hrp()if not th or not m then task.wait(0.3)continue end if isInVoid(th.Position)or isInVoid(m.Position)then task.wait(0.3)continue end local lk=th.CFrame.LookVector local fl=Vector3.new(lk.X,0,lk.Z)if fl.Magnitude>0.01 then fl=fl.Unit else fl=Vector3.new(0,0,-1)end local t=(os.clock()/BC)%1 local ths=math.sin(t*math.pi*2)*0.5+0.5 local cd=BDB-(BO*ths)local bp2=th.Position-fl*cd pcall(function()m.CFrame=CFrame.lookAt(bp2,th.Position)m.AssemblyLinearVelocity=Vector3.zero m.AssemblyAngularVelocity=Vector3.zero end)end end)
task.spawn(function()while true do task.wait(0.05)if not S.annoyActive or ROLE~="BOT"or antiBan.detected then continue end if S.hidden then continue end local tg=S.annoyTarget if not tg or not tg.Parent then task.wait(0.4)continue end local th=getPlayerHRP(tg)local m=hrp()if not th or not m then task.wait(0.3)continue end if isInVoid(th.Position)or isInVoid(m.Position)then task.wait(0.3)continue end local lk=th.CFrame.LookVector local fl=Vector3.new(lk.X,0,lk.Z)if fl.Magnitude>0.01 then fl=fl.Unit else fl=Vector3.new(0,0,-1)end local fr=th.Position+fl*AFD local ds=(m.Position-fr).Magnitude local h=hum()if not h then continue end if rotationOwner~="FaceTarget"and S.annoyActive then setRotationOwner("FaceTarget")end if ds>ATR then if os.clock()-S.trollTpCD>0.6 then S.trollTpCD=os.clock()pcall(function()m.CFrame=CFrame.new(fr+Vector3.new(0,1,0))m.AssemblyLinearVelocity=Vector3.zero m.AssemblyAngularVelocity=Vector3.zero end)end else h:MoveTo(fr)end end end)
task.spawn(function()while true do local wt=AMW1+math.random()*(AMW2-AMW1)task.wait(wt)if not S.annoyActive or ROLE~="BOT"or antiBan.detected then continue end if S.hidden then continue end local tg=S.annoyTarget if not tg or not tg.Parent then continue end local th=getPlayerHRP(tg)if not th then continue end if isInVoid(th.Position)then continue end local m=hrp()if not m or isInVoid(m.Position)then continue end if(m.Position-th.Position).Magnitude>40 then continue end sendChat(ANNOY_MSGS[math.random(1,#ANNOY_MSGS)])end end)
SK_CFG={CHASE_DIST=18,JUMP_DIST=14,BACKPEDAL_DIST=9,FLANK_DIST=5,SWING_CD=0.34,STRAFE_CD=0.45,REACTION_MIN=0.03,REACTION_MAX=0.10,JUMP_SKIP=0.03,PREDICT_TIME=0.20,HITBOX_DODGE_DIST=9,DMG_WINDOW=1.2,DMG_THRESHOLD=5,KILL_RETURN_DELAY=0.7,FIGHT_SPEED=26,JUMP_INTERVAL=0.28,FLANK_SIDE_BIAS=-1,CIRCLE_BIAS=0.75}
SK_SWORD_KEYS={"sword","blade","katana","saber","sabre","rapier","dagger","scimitar","machete","darkheart","linked","classic","knife","cleaver","spear","glaive","halberd","longsword","broadsword","shortsword","greatsword","cutlass","falchion","wakizashi","tanto","nodachi","odachi","excalibur","muramasa","masamune","kunai","shuriken","axe","hatchet","tomahawk","scythe","kama","naginata","estoc","claymore","zweihander","flamberge","kris","kukri","bowie","stiletto","dirk","sai","khopesh","gladius","spatha","arming","bastard","viking","cavalry","hunting","combat","throwing","butterfly","balisong","katar","pata","macuahuitl","tessen","parang","klewang","krabi","keris","kujang","mandau","golok","barong","kampilan","bolo","balisword","shikomizue","shirasaya","tachi","chokuto","ninjato","iaito","bokken","shinai"}
S.swordKillActive=false S.swordKillTarget=nil S.swordKillThread=nil S.swordKillStrafeDir=1 S.swordKillLastStrafe=0 S.swordKillLastSwing=0 S.swordKillReactionEnd=0 S.swordKillTargetVel=Vector3.zero S.swordKillLastTargetPos=nil S.swordKillLastTargetTime=0 S.swordKillLastHealth=nil S.swordKillLastHealthTime=0 S.swordKillRetreating=false S.swordKillRetreatUntil=0 S.swordKillKilledChatted=false S.swordKillEquippedTool=nil S.swordKillOriginalTool=nil S.swordKillLastJump=0 S.swordKillTargetHum=nil S.swordKillReengageAt=0
function skIsSword(t)if not t or not t:IsA("Tool")then return false end local n=t.Name:lower()for _,k in ipairs(SK_SWORD_KEYS)do if n:find(k,1,true)then return true end end local tip=(t.ToolTip or ""):lower()for _,k in ipairs(SK_SWORD_KEYS)do if tip:find(k,1,true)then return true end end if t:FindFirstChild("Handle")then for _,c in ipairs(t:GetChildren())do if c:IsA("BasePart")then local s=c.Size local longest=math.max(s.X,s.Y,s.Z)local shortest=math.min(s.X,s.Y,s.Z)if longest>2 and shortest<0.5 then return true end end end end return false end
function skFindSwordInPack()local pack=bp()if not pack then return nil end local best=nil for _,t in ipairs(pack:GetChildren())do if skIsSword(t)then if t.Name:lower():find("sword",1,true)then return t end best=best or t end end return best end
function skEquipSword()local c=pl.Character if not c then return nil end local eq=c:FindFirstChildOfClass("Tool")if eq and skIsSword(eq)then S.swordKillEquippedTool=eq return eq end local sw=skFindSwordInPack()if sw then if eq and not skIsSword(eq)then S.swordKillOriginalTool=eq pcall(function()eq.Parent=bp()end)end pcall(function()sw.Parent=c end)S.swordKillEquippedTool=sw return sw end if eq then S.swordKillEquippedTool=eq return eq end local pack=bp()if not pack then return nil end for _,t in ipairs(pack:GetChildren())do if t:IsA("Tool")then pcall(function()t.Parent=c end)S.swordKillEquippedTool=t return t end end return nil end
function skUnequipAfterKill()local c=pl.Character local pack=bp()if S.swordKillEquippedTool and pack then pcall(function()S.swordKillEquippedTool.Parent=pack end)end if S.swordKillOriginalTool and c and S.swordKillOriginalTool.Parent==pack then pcall(function()S.swordKillOriginalTool.Parent=c end)end S.swordKillEquippedTool=nil S.swordKillOriginalTool=nil end
function skGetEnemySword(tChar)if not tChar then return nil end local tool=tChar:FindFirstChildOfClass("Tool")if not tool then return nil end return tool:FindFirstChild("Handle")or tool:FindFirstChildWhichIsA("BasePart")end
function skSwing()local now=os.clock()if now-S.swordKillLastSwing<SK_CFG.SWING_CD*(0.85+math.random()*0.4)then return end S.swordKillLastSwing=now local tool=skEquipSword()if tool then pcall(function()tool:Activate()end)end end
function skIsBehind(myHRP,tHRP)local toMe=myHRP.Position-tHRP.Position toMe=Vector3.new(toMe.X,0,toMe.Z)if toMe.Magnitude<0.1 then return false end toMe=toMe.Unit local look=tHRP.CFrame.LookVector look=Vector3.new(look.X,0,look.Z)if look.Magnitude<0.1 then return false end look=look.Unit return toMe:Dot(look)>0.45 end
function skPredictTarget(tHRP)if not tHRP then return Vector3.zero end local now=os.clock()if S.swordKillLastTargetPos then local dt=now-S.swordKillLastTargetTime if dt>0.01 and dt<0.5 then S.swordKillTargetVel=(tHRP.Position-S.swordKillLastTargetPos)/dt end end S.swordKillLastTargetPos=tHRP.Position S.swordKillLastTargetTime=now return tHRP.Position+S.swordKillTargetVel*SK_CFG.PREDICT_TIME end
function skDoJump()local h,m=hum(),hrp()if not h or not m then return end local now=os.clock()if now-S.swordKillLastJump<SK_CFG.JUMP_INTERVAL then return end if h.FloorMaterial==Enum.Material.Air then return end S.swordKillLastJump=now h.Jump=true end
function skTick()
if not S.swordKillActive then return end
local tg=S.swordKillTarget
if not tg or not tg.Parent or not tg.Character then stopSwordKill(false)return end
local tHum=tg.Character:FindFirstChildOfClass("Humanoid")
if not tHum or tHum.Health<=0 then if not S.swordKillKilledChatted then S.swordKillKilledChatted=true sendChat(pick({"got em","gg","target down","hes done","easy","next"}))task.delay(SK_CFG.KILL_RETURN_DELAY,function()skUnequipAfterKill()stopSwordKill(false)teleportToHost()end)end return end
local myHRP=hrp()local myHum=hum()local tHRP=getPlayerHRP(tg)
if not myHRP or not myHum or not tHRP then return end
if myHum.Health<=0 then return end
if S.swordKillReengageAt>0 and os.clock()<S.swordKillReengageAt then return end
S.swordKillReengageAt=0
local now=os.clock()
if now<S.swordKillReactionEnd then return end
S.swordKillReactionEnd=now+(SK_CFG.REACTION_MIN+math.random()*(SK_CFG.REACTION_MAX-SK_CFG.REACTION_MIN))
if S.swordKillLastHealth and now-S.swordKillLastHealthTime<SK_CFG.DMG_WINDOW then local dmg=S.swordKillLastHealth-myHum.Health if dmg>=SK_CFG.DMG_THRESHOLD then S.swordKillRetreating=true S.swordKillRetreatUntil=now+1.0 end end
S.swordKillLastHealth=myHum.Health
S.swordKillLastHealthTime=now
if now>S.swordKillRetreatUntil then S.swordKillRetreating=false end
setRotationOwner("FaceTarget")
pcall(function()myHum.WalkSpeed=SK_CFG.FIGHT_SPEED end)
local tPos=skPredictTarget(tHRP)
local myPos=myHRP.Position
local dist=(myPos-tPos).Magnitude
local toTarget=tPos-myPos
toTarget=Vector3.new(toTarget.X,0,toTarget.Z)
if toTarget.Magnitude>0.1 then toTarget=toTarget.Unit else toTarget=Vector3.new(0,0,-1)end
local grounded=myHum.FloorMaterial~=Enum.Material.Air
local behind=skIsBehind(myHRP,tHRP)
local enemySword=skGetEnemySword(tg.Character)
local swordClose=false
if enemySword then local sd=(enemySword.Position-myPos).Magnitude if sd<SK_CFG.HITBOX_DODGE_DIST then swordClose=true end end
local tLook=tHRP.CFrame.LookVector
tLook=Vector3.new(tLook.X,0,tLook.Z)
if tLook.Magnitude<0.1 then tLook=Vector3.new(0,0,-1)else tLook=tLook.Unit end
local playerLeft=Vector3.new(tLook.Z,0,-tLook.X)
local botToPlayer=myPos-tHRP.Position
botToPlayer=Vector3.new(botToPlayer.X,0,botToPlayer.Z)
local onUnguardedSide=botToPlayer.Magnitude>0.1 and botToPlayer.Unit:Dot(playerLeft)>0.3
if S.swordKillRetreating then local back=-toTarget local side=playerLeft*SK_CFG.FLANK_SIDE_BIAS local md=(back*0.85+side*0.4).Unit myHum:MoveTo(myPos+md*9)skSwing()skDoJump()return end
if swordClose and dist<11 then local side=playerLeft local md=(side*0.9+toTarget*0.2).Unit myHum:MoveTo(myPos+md*10)skSwing()skDoJump()return end
if dist>SK_CFG.CHASE_DIST then local targetOffset=tPos+playerLeft*4 local chaseDir=(targetOffset-myPos)chaseDir=Vector3.new(chaseDir.X,0,chaseDir.Z)if chaseDir.Magnitude>0.1 then chaseDir=chaseDir.Unit else chaseDir=toTarget end myHum:MoveTo(myPos+chaseDir*12)if grounded and math.random()<0.5 then skDoJump()end return end
if dist>SK_CFG.JUMP_DIST then local ang=(playerLeft*0.5+toTarget*0.5).Unit if grounded then skDoJump()end myHum:MoveTo(myPos+ang*10)skSwing()return end
if dist>SK_CFG.BACKPEDAL_DIST then local circleDir=(playerLeft*SK_CFG.CIRCLE_BIAS+toTarget*0.2).Unit myHum:MoveTo(myPos+circleDir*9)skSwing()if grounded and math.random()<0.6 then skDoJump()end return end
if dist>SK_CFG.FLANK_DIST then if not onUnguardedSide then local flankDir=(playerLeft*0.9+toTarget*0.1).Unit myHum:MoveTo(myPos+flankDir*8)else myHum:MoveTo(myPos+toTarget*6)end skSwing()skDoJump()return end
if behind then if grounded then skDoJump()end myHum:MoveTo(myPos+toTarget*6)skSwing()return end
if not onUnguardedSide then local flankDir=(playerLeft*0.95+toTarget*0.05).Unit myHum:MoveTo(myPos+flankDir*7)skSwing()skDoJump()return end
local side=playerLeft*0.4
local md=(toTarget*0.7+side).Unit
myHum:MoveTo(myPos+md*5)
skSwing()
if grounded and math.random()<0.5 then skDoJump()end
end
startSwordKill=function(name)
if not name or name==""then sendChat("usage: !swordkill <player>")return end
local t=getPlayer(name)
if not t then sendChat(pick(R_.notfound))return end
if t==pl then sendChat(pick(R_.self))return end
stopOrbit()stopSpin()stopDance()stopLead(false)stopBam(false)stopAnnoy(false)stopFling(false)
S.swordKillTarget=t S.swordKillActive=true S.mode="SwordKill"
S.swordKillLastSwing=0 S.swordKillLastStrafe=0 S.swordKillLastJump=0
S.swordKillReactionEnd=os.clock()+0.15
S.swordKillTargetVel=Vector3.zero S.swordKillLastTargetPos=nil
S.swordKillLastHealth=nil S.swordKillLastHealthTime=0
S.swordKillRetreating=false S.swordKillRetreatUntil=0
S.swordKillKilledChatted=false S.swordKillReengageAt=0
S.swordKillEquippedTool=nil S.swordKillOriginalTool=nil
skEquipSword()
if S.swordKillThread then task.cancel(S.swordKillThread)end
S.swordKillThread=task.spawn(function()while S.swordKillActive and ROLE=="BOT"do local ok,err=pcall(skTick)if not ok then warn("[swordkill]",err)end task.wait(0.02)end end)
sendChat(pick({"sword fight on","locking on","going for em","duel mode","lets dance"}).." "..t.Name)
end
stopSwordKill=function(announce)
if not S.swordKillActive then return end
S.swordKillActive=false S.swordKillTarget=nil
if S.swordKillThread then task.cancel(S.swordKillThread)S.swordKillThread=nil end
if S.swordKillEquippedTool then skUnequipAfterKill()end
local h=hum()if h then pcall(function()h.WalkSpeed=BS end)end
if S.mode=="SwordKill"then S.mode="Follow"releaseRotation()end
if announce then sendChat(pick({"fight off","backing off","done","chill now","stopping"}))end
end
function clearHide()if S.hideBP then pcall(function()S.hideBP:Destroy()end)S.hideBP=nil end if S.hideBG then pcall(function()S.hideBG:Destroy()end)S.hideBG=nil end if S.hideHB then pcall(function()S.hideHB:Disconnect()end)S.hideHB=nil end local m=hrp()if m then for _,c in ipairs(m:GetChildren())do if c:IsA("BodyGyro")or c:IsA("BodyAngularVelocity")or c:IsA("BodyPosition")or c:IsA("BodyVelocity")or c:IsA("AlignOrientation")or c:IsA("AlignPosition")or c:IsA("LinearVelocity")then pcall(function()c:Destroy()end)end end end end
function doHide(si)S.hidden=true S.frozen=true S.sitting=false stopOrbit()stopSpin()stopDance()stopLead(false)stopBam(false)stopAnnoy(false)stopFling(false)stopSwordKill(false)S.mode="Hidden"setRotationOwner("Hidden")local m=hrp()if m then local pos=Vector3.new(math.random(-VR,VR),VY+50,math.random(-VR,VR))S.hidePos=pos pcall(function()m.CFrame=CFrame.new(pos)m.AssemblyLinearVelocity=Vector3.zero m.AssemblyAngularVelocity=Vector3.zero end)clearHide()local b=Instance.new("BodyPosition")b.MaxForce=Vector3.new(1e7,1e7,1e7)b.Position=pos b.P=5e5 b.D=200 b.Parent=m S.hideBP=b local g=Instance.new("BodyGyro")g.MaxTorque=Vector3.new(1e7,1e7,1e7)g.P=5e5 g.D=200 g.CFrame=m.CFrame g.Parent=m S.hideBG=g local h=hum()if h then h.WalkSpeed=0 h.JumpPower=0 h.PlatformStand=true end S.hideHB=R.Heartbeat:Connect(function()if not S.hidden then return end local r=hrp()if not r then return end if(r.Position-pos).Magnitude>5 then pcall(function()r.CFrame=CFrame.new(pos)end)end if r.AssemblyLinearVelocity.Magnitude>1 then pcall(function()r.AssemblyLinearVelocity=Vector3.zero end)end end)end if not si then sendChat(pick(R_.hide))end end
function doSpawn()S.hidden=false S.frozen=false S.sitting=false S.mode="Follow"clearHide()local h=hum()if h then h.PlatformStand=false h.WalkSpeed=BS h.JumpPower=BJ end rotationOwner="Humanoid"if h then h.AutoRotate=true end local hh,m=getHostHRP(),hrp()if hh and m then local f=hh.CFrame.LookVector*-5 pcall(function()m.CFrame=CFrame.new(hh.Position+Vector3.new(f.X,0,f.Z))m.AssemblyLinearVelocity=Vector3.zero m.AssemblyAngularVelocity=Vector3.zero end)end S.waypoints=nil S.cachedPath=nil S.lastMovePos=nil S.committedTarget=nil S.stableFollowDir=nil sendChat(pick(R_.spawn))end
function think(fp,tp)local m=hrp()if not m then return "wait",nil end local dr=tp-fp local fl=Vector3.new(dr.X,0,dr.Z)local ds=fl.Magnitude if ds<0.1 then return "arrive",nil end fl=fl.Unit local ob,ht,inf=checkAheadObstacle(fp,fl,OL)if ob=="void_risk"or ob=="steep_drop"then return "avoid_edge",{kind=ob}end if ob=="slim"then return "avoid_slim",{hit=ht,info=inf}end if ob=="wall"then return "path",nil end local ok,rs,_,hi=visionClear(fp,tp)if not ok and rs=="void"then return "wait",nil end if not ok and rs=="slim"then return "avoid_slim",{hit=hi}end local br=math.min(PDR,ds)local bk=findPlayerInFront(fp,fl,br)if bk and bk~=getHost()and bk~=S.leadTarget then local pl2=planDodge(fp,tp)if pl2 then return "dodge",{dir=pl2,blocker=bk}end end if ok then return "walk_straight",nil end return "path",nil end
function startMirrorJump()if S.mirrorWatcher then return end S.mirrorWatcher=task.spawn(function()local ls=false while ROLE=="BOT"do task.wait(0.07)if S.hidden or antiBan.detected or S.sitting then continue end if S.mode=="Bam"or S.mode=="Annoy"or S.mode=="Fling"or S.mode=="SwordKill"then continue end local host=getHost()if not host or not host.Character then continue end local hh=host.Character:FindFirstChildOfClass("Humanoid")if not hh then continue end local st=hh:GetState()local j=(st==Enum.HumanoidStateType.Jumping)or(st==Enum.HumanoidStateType.Freefall)if j and not ls then if os.clock()-S.lastHostJumpTime>MJC then S.lastHostJumpTime=os.clock()S.mirrorJumpTime=os.clock()+MJD1+math.random()*(MJD2-MJD1)end end ls=j end end)end
function startCameraMicro()if S.microCamActive then return end S.microCamActive=true S.microCamThread=task.spawn(function()while ROLE=="BOT"and S.microCamActive do task.wait(MCW1+math.random()*(MCW2-MCW1))if S.hidden or antiBan.detected or S.sitting then continue end if S.mode=="SwordKill"then continue end if rotationOwner=="Spin"or rotationOwner=="Orbit"or rotationOwner=="Fling"then continue end local cam=W.CurrentCamera if not cam then continue end local sg=math.random()<0.5 and-1 or 1 local an=math.rad(MCA1+math.random()*(MCA2-MCA1))*sg local sc=cam.CFrame local t1=T:Create(cam,TweenInfo.new(0.10,Enum.EasingStyle.Linear),{CFrame=sc*CFrame.Angles(0,an,0)})t1:Play()t1.Completed:Wait()task.wait(0.10+math.random()*0.15)T:Create(cam,TweenInfo.new(0.14,Enum.EasingStyle.Linear),{CFrame=sc}):Play()end end)end
function computeFollowPoint(hp,hc,bp2)local tb=bp2-hp local fl=Vector3.new(tb.X,0,tb.Z)local mg=fl.Magnitude local dr if mg<FCB then local hv=hc.LookVector dr=Vector3.new(-hv.X,0,-hv.Z)if dr.Magnitude<0.01 then dr=Vector3.new(0,0,-1)end dr=dr.Unit else dr=fl.Unit end return hp+dr*FD end
function botTick()if antiBan.detected then return end if S.hidden then if S.hidePos then local m=hrp()if m and(m.Position-S.hidePos).Magnitude>10 then pcall(function()m.CFrame=CFrame.new(S.hidePos)end)end end return end if S.sitting then local h0=hum()if not h0 or not h0.Sit then S.sitting=false else local m0=hrp()if m0 then pcall(function()m0.AssemblyLinearVelocity=Vector3.new(m0.AssemblyLinearVelocity.X*0.3,m0.AssemblyLinearVelocity.Y,m0.AssemblyLinearVelocity.Z*0.3)end)end return end end if S.mirrorJumpTime>0 and os.clock()>=S.mirrorJumpTime then if S.mode~="Bam"and S.mode~="Annoy"and S.mode~="Fling"and S.mode~="SwordKill"then local h=hum()if h and h.FloorMaterial~=Enum.Material.Air then h.Jump=true end end S.mirrorJumpTime=0 end if S.mode=="Spin"or S.dancing then local h2=hum()if h2 then local m2=hrp()if m2 then h2:MoveTo(m2.Position)end end checkPush()return end if S.mode=="Bam"or S.mode=="Annoy"or S.mode=="Fling"or S.mode=="SwordKill"then return end if S.mode~="Follow"and S.mode~="Lead"then return end local h,hh,m=hum(),getHostHRP(),hrp()if not h or not hh or not m then return end do local hp=hh.Position if isInVoid(hp)then if not S.hostInVoid then S.hostInVoid=true S.hostVoidSafePos=S.lastSafeHostPos or m.Position end else if S.hostInVoid then S.hostInVoid=false end S.lastSafeHostPos=hp end end if isInVoid(m.Position)then local an=S.hostVoidSafePos or S.lastSafeHostPos if an then pcall(function()m.CFrame=CFrame.new(an+Vector3.new(0,3,0))m.AssemblyLinearVelocity=Vector3.zero m.AssemblyAngularVelocity=Vector3.zero end)elseif hh then pcall(function()m.CFrame=CFrame.new(hh.Position+Vector3.new(0,4,0))m.AssemblyLinearVelocity=Vector3.zero end)end S.waypoints=nil S.cachedPath=nil S.lastMovePos=nil S.committedTarget=nil S.stableFollowDir=nil return end checkPush()local tp if S.mode=="Lead"then if not S.leadActive or not S.leadTarget or not S.leadTarget.Parent then stopLead(false)sendChat("lost target")return end local th=getPlayerHRP(S.leadTarget)if not th then return end if isInVoid(th.Position)then tp=S.lastSafeHostPos or m.Position h:MoveTo(tp)return end tp=th.Position if(m.Position-tp).Magnitude<=LAD then sendChat(pick({"made it","here","arrived"}))stopLead(false)S.mode="Follow"return end if(hh.Position-m.Position).Magnitude>LHMD then h:MoveTo(m.Position)return end else if S.hostInVoid then tp=S.hostVoidSafePos or S.lastSafeHostPos or m.Position if(tp-m.Position).Magnitude>FD then h:MoveTo(tp)S.lastMovePos=tp else h:MoveTo(m.Position)end return end tp=computeFollowPoint(hh.Position,hh.CFrame,m.Position)end if not tp then return end local d=(tp-m.Position).Magnitude local hd=(hh.Position-m.Position).Magnitude if S.mode=="Follow"and d>ED then if os.clock()-S.tpCD>3 then S.tpCD=os.clock()local bk=hh.CFrame.LookVector*-7 pcall(function()m.CFrame=CFrame.new(hh.Position+Vector3.new(bk.X,3,bk.Z))m.AssemblyLinearVelocity=Vector3.zero end)S.waypoints=nil S.cachedPath=nil S.lastMovePos=nil S.committedTarget=nil S.stableFollowDir=nil end return end if h.MoveDirection.Magnitude>0.1 then setRotationOwner("Humanoid")else if S.mode=="Follow"and hd<=LR then setRotationOwner("FaceHost")else setRotationOwner("Humanoid")end end if d<=FSD then h:MoveTo(m.Position)S.waypoints=nil S.cachedPath=nil S.lastHostPos=nil S.lastMovePos=nil S.committedTarget=nil S.lastWaypoint=nil S.failCount=0 return end local ac,da=think(m.Position,tp)if ac=="arrive"or ac=="wait"then h:MoveTo(m.Position)S.lastMovePos=nil S.waypoints=nil S.cachedPath=nil S.committedTarget=nil return end if ac=="avoid_edge"then local bk=m.Position-tp bk=Vector3.new(bk.X,0,bk.Z)if bk.Magnitude>0.1 then bk=bk.Unit*6 local sf=m.Position+bk if hasFloorBelow(sf)then h:MoveTo(sf)S.lastMovePos=sf end end return end if ac=="avoid_slim"then local dr=tp-m.Position dr=Vector3.new(dr.X,0,dr.Z)if dr.Magnitude>0.1 then dr=dr.Unit local lf=Vector3.new(-dr.Z,0,dr.X)local rg=Vector3.new(dr.Z,0,-dr.X)local ch=hasFloorBelow(m.Position+lf*6)and lf or(hasFloorBelow(m.Position+rg*6)and rg or nil)if ch then local np=m.Position+ch*6 h:MoveTo(np)S.lastMovePos=np end end return end if ac=="dodge"then local dr=da.dir local sd if dr=="left"then sd=Vector3.new(-m.CFrame.LookVector.Z,0,m.CFrame.LookVector.X)elseif dr=="right"then sd=Vector3.new(m.CFrame.LookVector.Z,0,-m.CFrame.LookVector.X)else sd=m.CFrame.LookVector end if dr=="jump"then local bl=da.blocker and da.blocker.Character if bl then for _,p2 in ipairs(bl:GetChildren())do if p2:IsA("BasePart")then pcall(function()p2.CanCollide=false end)end end task.delay(1.2,function()if bl and bl.Parent then for _,p2 in ipairs(bl:GetChildren())do if p2:IsA("BasePart")then pcall(function()p2.CanCollide=true end)end end end end)tryJump()end else local dd=m.Position+sd*7 if hasFloorBelow(dd)then h:MoveTo(dd)end end return end if ac=="walk_straight"then if not S.committedTarget or(S.committedTarget-tp).Magnitude>2 or os.clock()>S.committedUntil then h:MoveTo(tp)S.committedTarget=tp S.committedUntil=os.clock()+1.2 end S.waypoints=nil S.cachedPath=nil S.lastMovePos=tp checkStuck()return end local ps=tostring(math.floor(tp.X)).."|"..tostring(math.floor(tp.Z))local nn=false if not S.waypoints or #S.waypoints==0 then nn=true elseif S.lastPathSig~=ps then nn=true elseif os.clock()-S.lastRepath>RI then if(S.lastHostPos and(tp-S.lastHostPos).Magnitude or 999)>3 then nn=true end end if nn and(os.clock()-S.lastPathFail)<PFC then nn=false end if nn and os.clock()-S.lastRepath>RI then S.lastRepath=os.clock()local wps=computePath(m.Position,tp)if wps and #wps>0 then local tl=0 local pv=m.Position for _,wp in ipairs(wps)do tl=tl+(wp.Position-pv).Magnitude pv=wp.Position end S.totalSteps=math.floor(tl/3.5)S.cachedPath=wps S.waypoints=wps S.lastHostPos=tp S.lastWaypoint=nil S.lastPathSig=ps else S.waypoints=nil end end if S.waypoints and #S.waypoints>0 then while S.waypoints[1]and dist2d(m.Position,S.waypoints[1].Position)<WR do table.remove(S.waypoints,1)end while #S.waypoints>2 do local wn=S.waypoints[2]local tn=wn.Position-m.Position tn=Vector3.new(tn.X,0,tn.Z)local dd=tn.Magnitude if dd<2 then table.remove(S.waypoints,1)else tn=tn.Unit local rp=mkRP(false)local ah=W:Raycast(m.Position+Vector3.new(0,2,0),tn*(dd-1.5),rp)if ah and math.abs(ah.Normal.Y)<0.4 then break end table.remove(S.waypoints,1)end end local wp=S.waypoints[1]if wp then local wd=wp.Position-m.Position wd=Vector3.new(wd.X,0,wd.Z)if wd.Magnitude>0.5 then wd=wd.Unit local pb=findPlayerInFront(m.Position,wd,6)if pb and pb~=getHost()and pb~=S.leadTarget then local pl2=planDodge(m.Position,wp.Position)if pl2=="left"or pl2=="right"then local sd=pl2=="left"and Vector3.new(-wd.Z,0,wd.X)or Vector3.new(wd.Z,0,-wd.X)h:MoveTo(m.Position+sd*6)S.lastMovePos=m.Position+sd*6 return end end end if hasFloorBelow(wp.Position)then if wp.Action==Enum.PathWaypointAction.Jump then if h.FloorMaterial~=Enum.Material.Air then h.Jump=true end end if not S.lastWaypoint or(S.lastWaypoint-wp.Position).Magnitude>0.5 then h:MoveTo(wp.Position)S.lastWaypoint=wp.Position end tryJump()else table.remove(S.waypoints,1)end end else if hasFloorBelow(tp)then h:MoveTo(tp)S.lastMovePos=tp tryJump()else h:MoveTo(m.Position)end end checkStuck()end
startFollow=function()if S.followThread then return end startFacing()S.followThread=task.spawn(function()while ROLE=="BOT"do task.wait(AIT)local ok,er=pcall(botTick)if not ok then warn("[MyPanel] botTick error:",er)S.failCount=S.failCount+1 if S.failCount>=8 then S.failCount=0 S.waypoints=nil S.cachedPath=nil S.lastMovePos=nil S.committedTarget=nil S.lastWaypoint=nil S.hostInVoid=false S.mirrorJumpTime=0 S.stableFollowDir=nil end else S.failCount=0 end end end)end
stopFollow=function()if S.followThread then task.cancel(S.followThread)S.followThread=nil end end
function startOrbit(sp)sp=tonumber(sp)or 100 sp=math.clamp(sp,1,1000)S.orbitSpeed=sp stopSpin()stopDance()stopLead(false)stopBam(false)stopAnnoy(false)stopFling(false)stopSwordKill(false)if S.orbiting then return end S.orbiting=true S.mode="Orbit"setRotationOwner("Orbit")task.spawn(function()while S.orbiting and ROLE=="BOT"do if S.hidden or antiBan.detected then task.wait(0.3)continue end local hh,m,h=getHostHRP(),hrp(),hum()if not hh or not m or not h then task.wait(0.1)continue end if not S.orbitLV or S.orbitLV.Parent~=m then if S.orbitLV then pcall(function()S.orbitLV:Destroy()end)end if S.orbitAO then pcall(function()S.orbitAO:Destroy()end)end if S.orbitAtt then pcall(function()S.orbitAtt:Destroy()end)end local at=Instance.new("Attachment")at.Parent=m S.orbitAtt=at local lv=Instance.new("LinearVelocity")lv.Attachment0=at lv.MaxForce=1e5 lv.VectorVelocity=Vector3.zero lv.Parent=m S.orbitLV=lv local ao=Instance.new("AlignOrientation")ao.Attachment0=at ao.Mode=Enum.OrientationAlignmentMode.OneAttachment ao.PrimaryAxisOnly=true ao.MaxTorque=1e5 ao.Parent=m S.orbitAO=ao end local of=m.Position-hh.Position local fl=Vector3.new(of.X,0,of.Z)if fl.Magnitude<1 then local a=math.random()*math.pi*2 pcall(function()m.CFrame=CFrame.new(hh.Position+Vector3.new(math.cos(a)*OR,0,math.sin(a)*OR))end)task.wait(0.05)continue end local rd=fl.Unit local tn=Vector3.new(-rd.Z,0,rd.X)pcall(function()S.orbitLV.VectorVelocity=tn*(sp/8)S.orbitAO.CFrame=CFrame.lookAt(m.Position,m.Position+tn)end)task.wait(0.05)end if S.orbitLV then pcall(function()S.orbitLV:Destroy()end)S.orbitLV=nil end if S.orbitAO then pcall(function()S.orbitAO:Destroy()end)S.orbitAO=nil end if S.orbitAtt then pcall(function()S.orbitAtt:Destroy()end)S.orbitAtt=nil end end)sendChat(pick(R_.orbit))end
function restoreHost()if not originalHost.name then return end S.hostName=originalHost.name hostFilter.name=originalHost.name hostFilter.userId=originalHost.userId S.lending=false S.lendEnd=0 sendChat(pick({"lend done","back to original","transfer over"}))end
function startLend(name,sc)sc=tonumber(sc)if not sc or sc<=0 then sc=60 end local t=getPlayer(name)if not t then sendChat(pick(R_.notfound))return end if t==pl then sendChat(pick(R_.self))return end if hostFilter.userId and t.UserId==hostFilter.userId then sendChat("already lending to them")return end if originalHost.userId and t.UserId==originalHost.userId then sendChat("cant lend to yourself")return end if not S.lending then originalHost.name=S.hostName originalHost.userId=hostFilter.userId end S.lending=true S.hostName=t.Name:lower()hostFilter.name=t.Name:lower()hostFilter.userId=t.UserId S.lendEnd=os.clock()+sc sendChat(pick({"listening to ","lend to ","transferring to "})..t.Name.." for "..sc.."s")if S.lendThread then task.cancel(S.lendThread)end S.lendThread=task.spawn(function()while S.lending and ROLE=="BOT"do task.wait(0.5)if os.clock()>=S.lendEnd then restoreHost()break end end end)end
function startAfk()if ROLE~="BOT"then return end task.spawn(function()while ROLE=="BOT"do task.wait(1)local hh=getHostHRP()if not hh then S.hostLastPos=nil S.hostAfkTimer=0 continue end if S.hostLastPos then if(hh.Position-S.hostLastPos).Magnitude>0.8 then S.hostAfkTimer=0 if S.hostIsAfk then S.hostIsAfk=false end else S.hostAfkTimer=S.hostAfkTimer+1 if S.hostAfkTimer>=AT and not S.hostIsAfk then S.hostIsAfk=true end end end S.hostLastPos=hh.Position end end)end
function bindDeath()if S.deathConn then S.deathConn:Disconnect()S.deathConn=nil end local c=pl.Character if not c then return end local h=c:FindFirstChildOfClass("Humanoid")if not h then return end S.deathConn=h.Died:Connect(function()local wasFighting=S.swordKillActive and S.swordKillTarget stopSpin()stopDance()stopLead(false)stopFling(false)if not wasFighting then stopSwordKill(false)end S.sitting=false S.waypoints=nil S.cachedPath=nil S.lastMovePos=nil S.committedTarget=nil S.hostInVoid=false S.mirrorJumpTime=0 S.stableFollowDir=nil local n=os.clock()if n-S.lastDeathTime>DRT then S.deathCount=0 S.deathSilent=false end S.lastDeathTime=n S.deathCount=S.deathCount+1 if S.deathSilent then return end if wasFighting then sendChat(pick({"im down","back in a sec","respawning","one sec","ill be back"}))elseif S.deathCount==2 then sendChat("...")elseif S.deathCount==3 then sendChat("....")elseif S.deathCount==4 then sendChat(".....")elseif S.deathCount==5 then sendChat(pick({"bro","cmon","seriously","again?","bruh"}))elseif S.deathCount==6 then sendChat(pick({"ok this is annoying","really now","dude","ugh","seriously"}))elseif S.deathCount==7 then sendChat(pick({"bro stop","cmon man","enough","why tho"}))elseif S.deathCount>=8 then sendChat(pick({"stop bro","bro stop it","ok enough","chill out man","i said stop"}))S.deathSilent=true end end)end
handleCommand=function(cmd,args)if ROLE~="BOT"or antiBan.detected then return end if cmd=="say"then if args~=""then sendChat(args)end elseif cmd=="ask"then handleAIChat(args)elseif cmd=="orbit"then startOrbit(args~=""and args or nil)elseif cmd=="unorbit"then stopOrbit()sendChat(pick(R_.unorbit))elseif cmd=="sit"then stopSpin()stopDance()stopLead(false)stopBam(false)stopAnnoy(false)stopFling(false)stopSwordKill(false)S.sitting=true S.waypoints=nil S.cachedPath=nil S.lastMovePos=nil S.committedTarget=nil local h=hum()if h then pcall(function()h.WalkSpeed=0 h.JumpPower=0 h.Sit=true h:ChangeState(Enum.HumanoidStateType.Seated)end)end sendChat(pick(R_.sit))elseif cmd=="stand"then S.sitting=false local h=hum()if h then pcall(function()h.Sit=false h:ChangeState(Enum.HumanoidStateType.GettingUp)h.WalkSpeed=BS h.JumpPower=BJ end)end sendChat(pick(R_.stand))elseif cmd=="jump"then local h=hum()if h then h.Jump=true sendChat(pick(R_.jump))end elseif cmd=="hide"then doHide(false)elseif cmd=="spawn"then doSpawn()elseif cmd=="dance"then playDance(tonumber(args)or 1)elseif cmd=="undance"then stopDance()sendChat(pick(R_.undance))elseif cmd=="spin"then startSpin(args)elseif cmd=="unspin"then stopSpin()sendChat(pick(R_.unspin))elseif cmd=="lead"then startLead(args)elseif cmd=="unlead"then stopLead(true)elseif cmd=="bam"then startBam(args)elseif cmd=="unbam"then stopBam(false)teleportToHost()sendChat(pick(R_.unbam))elseif cmd=="annoy"then startAnnoy(args)elseif cmd=="unannoy"then stopAnnoy(false)teleportToHost()sendChat(pick(R_.unannoy))elseif cmd=="fling"then startFling(args)elseif cmd=="unfling"then stopFling(false,false)teleportToHost()sendChat(pick(R_.unfling))elseif cmd=="swordkill"then startSwordKill(args)elseif cmd=="unswordkill"then stopSwordKill(true)elseif cmd=="math"then handleMath(args)elseif cmd=="cmds"then sendSeq({"here ya go","!ask <msg> - talk to XcH","XcH can also write code for you","just say: make me fly/swim/speed/jump","!orbit <1-1000> | !unorbit","!lead <player> | !unlead","!sit | !stand | !jump","!hide | !spawn","!bam <player> | !unbam","!annoy <player> | !unannoy","!fling <player> | !unfling","!swordkill <player> | !unswordkill","!dance 1-4 | !undance","!spin 1-100 | !unspin","!math <num><op><num>","!say <text>","!cmds"},0.9)else sendChat(pick({"unknown cmd bro","dont know that one","try !cmds"}))end end
function processMessage(uid,text)if not text or text==""then return end if ROLE~="BOT"and ROLE~="HOST"then return end if not isFromHost(uid)then return end local lowText=text:lower()if lowText:sub(1,4)=="!ask"then local prompt=trim(text:sub(5))if prompt==""then if ROLE=="BOT"then sendChat("usage: !ask <message>")end return end if isDuplicateMessage(uid,text)then return end task.spawn(function()handleAIChat(prompt)end)return end if ROLE~="BOT"then return end if text:sub(1,#commandPrefix)~=commandPrefix then return end if isDuplicateMessage(uid,text)then return end local body=trim(text:sub(#commandPrefix+1))if body==""then return end local sp=body:find("%s")local cmd,args if sp then cmd=body:sub(1,sp-1):lower()args=trim(body:sub(sp+1))else cmd=body:lower()args=""end task.spawn(function()local ok,err=pcall(handleCommand,cmd,args)if not ok then warn("[MyPanel] cmd error:",err)if botLogRef then pushLog(botLogRef,"err: "..tostring(err):sub(1,60),C.red)end end end)end
pcall(function()if TC and TC.ChatVersion==Enum.ChatVersion.TextChatService then TC.MessageReceived:Connect(function(m)local s=m.TextSource if not s then return end processMessage(s.UserId,m.Text)end)end end)
local function hookChatted(p)p.Chatted:Connect(function(t)processMessage(p.UserId,t)end)end
for _,p in ipairs(P:GetPlayers())do hookChatted(p)end
P.PlayerAdded:Connect(hookChatted)
task.spawn(function()local ok,ch=pcall(function()return TC:WaitForChild("TextChannels",8)end)if not ok or not ch then return end local g=ch:FindFirstChild("RBXGeneral")or ch:FindFirstChild("RBGGeneral")or ch:FindFirstChildWhichIsA("TextChannel")if not g then return end pcall(function()g.MessageReceived:Connect(function(m)local s=m.TextSource if not s then return end processMessage(s.UserId,m.Text)end)end)end)
local gui=Instance.new("ScreenGui")gui.Name=GN gui.ResetOnSpawn=false gui.DisplayOrder=999 gui.IgnoreGuiInset=true gui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling gui.Enabled=true local parented=false pcall(function()gui.Parent=pg parented=true end)if not parented then pcall(function()gui.Parent=game:GetService("CoreGui")end)end
local frame=Instance.new("Frame")frame.Name="MainPanel"frame.Size=UDim2.new(0,520,0,320)frame.Position=UDim2.new(0,12,0.5,-160)frame.BackgroundColor3=C.panel frame.BorderSizePixel=0 frame.ClipsDescendants=false frame.Parent=gui corner(frame,12)stroke(frame,C.border,1,0)
SHOWN=UDim2.new(0,12,0.5,-160)HIDDEN=UDim2.new(0,-600,0.5,-160)
function show()tw(frame,0.4,{Position=SHOWN},Enum.EasingStyle.Quint)end
function hide()tw(frame,0.4,{Position=HIDDEN},Enum.EasingStyle.Quint,Enum.EasingDirection.In)end
local topBar=Instance.new("Frame")topBar.Name="TopBar"topBar.Size=UDim2.new(1,0,0,40)topBar.Position=UDim2.new(0,0,0,0)topBar.BackgroundColor3=C.panelTop topBar.BorderSizePixel=0 topBar.Parent=frame
local topBarStroke=Instance.new("UIStroke")topBarStroke.Color=C.border topBarStroke.Thickness=1 topBarStroke.Transparency=0.4 topBarStroke.ApplyStrokeMode=Enum.ApplyStrokeMode.Border topBarStroke.Parent=topBar
local titleLbl=Instance.new("TextLabel")titleLbl.Size=UDim2.new(0,200,1,0)titleLbl.Position=UDim2.new(0,16,0,0)titleLbl.BackgroundTransparency=1 titleLbl.Font=Enum.Font.GothamBold titleLbl.Text="XcH"titleLbl.TextColor3=C.text titleLbl.TextSize=15 titleLbl.TextXAlignment=Enum.TextXAlignment.Left titleLbl.Parent=topBar
local timeLbl=Instance.new("TextLabel")timeLbl.Size=UDim2.new(0,220,1,0)timeLbl.Position=UDim2.new(1,-236,0,0)timeLbl.BackgroundTransparency=1 timeLbl.Font=Enum.Font.Code timeLbl.Text="12:00:00 AM PHT"timeLbl.TextColor3=C.subText timeLbl.TextSize=11 timeLbl.TextXAlignment=Enum.TextXAlignment.Right timeLbl.Parent=topBar
function phTime()local t=os.date("!*t",os.time()+PH)local p=t.hour>=12 and"PM"or"AM"local dh=t.hour%12 if dh==0 then dh=12 end return string.format("%02d:%02d:%02d %s PHT",dh,t.min,t.sec,p)end
task.spawn(function()while timeLbl and timeLbl.Parent do timeLbl.Text=phTime()task.wait(1)end end)
local sidebar=Instance.new("Frame")sidebar.Name="Sidebar"sidebar.Size=UDim2.new(0,100,1,-40)sidebar.Position=UDim2.new(0,0,0,40)sidebar.BackgroundColor3=C.sidebar sidebar.BorderSizePixel=0 sidebar.ClipsDescendants=true sidebar.Parent=frame
local sideStroke=Instance.new("UIStroke")sideStroke.Color=C.border sideStroke.Thickness=1 sideStroke.Transparency=0.4 sideStroke.ApplyStrokeMode=Enum.ApplyStrokeMode.Border sideStroke.Parent=sidebar
local sideLayout=Instance.new("UIListLayout")sideLayout.Padding=UDim.new(0,4)sideLayout.SortOrder=Enum.SortOrder.LayoutOrder sideLayout.Parent=sidebar
local sidePad=Instance.new("UIPadding")sidePad.PaddingTop=UDim.new(0,8)sidePad.PaddingLeft=UDim.new(0,6)sidePad.PaddingRight=UDim.new(0,6)sidePad.Parent=sidebar
local contentArea=Instance.new("Frame")contentArea.Name="ContentArea"contentArea.Size=UDim2.new(1,-100,1,-40)contentArea.Position=UDim2.new(0,100,0,40)contentArea.BackgroundColor3=C.panel contentArea.BorderSizePixel=0 contentArea.ClipsDescendants=true contentArea.Parent=frame
function newPage()local p=Instance.new("Frame")p.Size=UDim2.new(1,0,1,0)p.Position=UDim2.new(0,0,0,0)p.BackgroundTransparency=1 p.Visible=false p.Parent=contentArea return p end
local logsPage=newPage()local logsPad=Instance.new("UIPadding")logsPad.PaddingTop=UDim.new(0,10)logsPad.PaddingLeft=UDim.new(0,10)logsPad.PaddingRight=UDim.new(0,10)logsPad.PaddingBottom=UDim.new(0,10)logsPad.Parent=logsPage
local pfxLbl=Instance.new("TextLabel")pfxLbl.Size=UDim2.new(0,110,0,14)pfxLbl.Position=UDim2.new(0,0,0,0)pfxLbl.BackgroundTransparency=1 pfxLbl.Font=Enum.Font.GothamBold pfxLbl.Text="COMMAND PREFIX"pfxLbl.TextColor3=C.subText pfxLbl.TextSize=9 pfxLbl.TextXAlignment=Enum.TextXAlignment.Left pfxLbl.Parent=logsPage
local pfxBox=Instance.new("TextBox")pfxBox.Size=UDim2.new(0,42,0,26)pfxBox.Position=UDim2.new(0,0,0,18)pfxBox.BackgroundColor3=C.track pfxBox.BorderSizePixel=0 pfxBox.Font=Enum.Font.GothamBold pfxBox.Text=commandPrefix pfxBox.TextColor3=C.text pfxBox.TextSize=13 pfxBox.ClearTextOnFocus=false pfxBox.Parent=logsPage corner(pfxBox,6)stroke(pfxBox,C.border,1,0.2)
local pfxHint=Instance.new("TextLabel")pfxHint.Size=UDim2.new(1,-50,0,26)pfxHint.Position=UDim2.new(0,50,0,18)pfxHint.BackgroundTransparency=1 pfxHint.Font=Enum.Font.Gotham pfxHint.Text="type: "..commandPrefix.."cmds"pfxHint.TextColor3=C.subText pfxHint.TextSize=9 pfxHint.TextXAlignment=Enum.TextXAlignment.Left pfxHint.TextYAlignment=Enum.TextYAlignment.Center pfxHint.Parent=logsPage
local logBox=Instance.new("Frame")logBox.Size=UDim2.new(1,0,1,-56)logBox.Position=UDim2.new(0,0,0,52)logBox.BackgroundColor3=C.track logBox.BorderSizePixel=0 logBox.ClipsDescendants=true logBox.Parent=logsPage corner(logBox,8)stroke(logBox,C.border,1,0.3)
local logEmpty=Instance.new("TextLabel")logEmpty.Size=UDim2.new(1,-16,1,-12)logEmpty.Position=UDim2.new(0,8,0,6)logEmpty.BackgroundTransparency=1 logEmpty.Font=Enum.Font.Gotham logEmpty.Text="no messages yet"logEmpty.TextColor3=C.subText logEmpty.TextSize=10 logEmpty.TextXAlignment=Enum.TextXAlignment.Left logEmpty.TextYAlignment=Enum.TextYAlignment.Top logEmpty.Parent=logBox
local logHolder=Instance.new("ScrollingFrame")logHolder.Size=UDim2.new(1,-8,1,-6)logHolder.Position=UDim2.new(0,4,0,3)logHolder.BackgroundTransparency=1 logHolder.BorderSizePixel=0 logHolder.CanvasSize=UDim2.new(0,0,0,0)logHolder.AutomaticCanvasSize=Enum.AutomaticSize.Y logHolder.ScrollBarThickness=4 logHolder.ScrollBarImageColor3=C.border logHolder.ScrollingDirection=Enum.ScrollingDirection.Y logHolder.Parent=logBox
local lbl=Instance.new("UIListLayout")lbl.SortOrder=Enum.SortOrder.LayoutOrder lbl.Padding=UDim.new(0,2)lbl.Parent=logHolder
hostLogRef={holder=logHolder,empty=logEmpty}botLogRef=hostLogRef flushBotLogBuffer()
pfxBox.FocusLost:Connect(function()local np=trim(pfxBox.Text)if np==""then np="!"else np=np:sub(1,1)end commandPrefix=np pfxBox.Text=commandPrefix pfxHint.Text="type: "..commandPrefix.."cmds"end)
local cmdsPage=newPage()local cmdsPad=Instance.new("UIPadding")cmdsPad.PaddingTop=UDim.new(0,10)cmdsPad.PaddingLeft=UDim.new(0,10)cmdsPad.PaddingRight=UDim.new(0,10)cmdsPad.PaddingBottom=UDim.new(0,10)cmdsPad.Parent=cmdsPage
local cmdsBox=Instance.new("Frame")cmdsBox.Size=UDim2.new(1,0,1,0)cmdsBox.BackgroundColor3=C.track cmdsBox.BorderSizePixel=0 cmdsBox.ClipsDescendants=true cmdsBox.Parent=cmdsPage corner(cmdsBox,8)stroke(cmdsBox,C.border,1,0.3)
local cmdScroll=Instance.new("ScrollingFrame")cmdScroll.Size=UDim2.new(1,-8,1,-6)cmdScroll.Position=UDim2.new(0,4,0,3)cmdScroll.BackgroundTransparency=1 cmdScroll.BorderSizePixel=0 cmdScroll.CanvasSize=UDim2.new(0,0,0,0)cmdScroll.AutomaticCanvasSize=Enum.AutomaticSize.Y cmdScroll.ScrollBarThickness=4 cmdScroll.ScrollBarImageColor3=C.border cmdScroll.Parent=cmdsBox
local cml=Instance.new("UIListLayout")cml.Padding=UDim.new(0,4)cml.SortOrder=Enum.SortOrder.LayoutOrder cml.Parent=cmdScroll
local CMDS={{"── AI ──",true},{"!ask <message> - talk to XcH",false},{"XcH can write code for you",false},{"say: make me fly/swim/speed/jump",false},{"!orbit <1-1000> | !unorbit",false},{"!lead <player> | !unlead",false},{"!sit | !stand | !jump",false},{"!hide | !spawn",false},{"!bam <player> | !unbam",false},{"!annoy <player> | !unannoy",false},{"!fling <player> | !unfling",false},{"!swordkill <player> | !unswordkill",false},{"!dance 1-4 | !undance",false},{"!spin 1-100 | !unspin",false},{"!math <num><op><num>",false},{"!say <text>",false},{"!cmds",false}}
for i,e in ipairs(CMDS)do local l=Instance.new("TextLabel")l.Size=UDim2.new(1,0,0,e[2]and 18 or 14)l.BackgroundTransparency=1 l.Font=e[2]and Enum.Font.GothamBold or Enum.Font.Code l.Text=e[1]l.TextColor3=e[2]and C.accent or C.text l.TextSize=10 l.TextXAlignment=Enum.TextXAlignment.Left l.LayoutOrder=i l.Parent=cmdScroll end
local xcodePage=newPage()xcodePage.Name="XcodePage"
local xcodeScroll=Instance.new("ScrollingFrame")xcodeScroll.Size=UDim2.new(1,0,1,-48)xcodeScroll.Position=UDim2.new(0,0,0,0)xcodeScroll.BackgroundTransparency=1 xcodeScroll.BorderSizePixel=0 xcodeScroll.CanvasSize=UDim2.new(0,0,0,0)xcodeScroll.AutomaticCanvasSize=Enum.AutomaticSize.Y xcodeScroll.ScrollBarThickness=4 xcodeScroll.ScrollBarImageColor3=C.border xcodeScroll.ScrollingDirection=Enum.ScrollingDirection.Y xcodeScroll.Parent=xcodePage
local xcodePad=Instance.new("UIPadding")xcodePad.PaddingTop=UDim.new(0,10)xcodePad.PaddingLeft=UDim.new(0,12)xcodePad.PaddingRight=UDim.new(0,16)xcodePad.PaddingBottom=UDim.new(0,8)xcodePad.Parent=xcodeScroll
local xcodeHolder=Instance.new("Frame")xcodeHolder.Size=UDim2.new(1,0,0,0)xcodeHolder.AutomaticSize=Enum.AutomaticSize.Y xcodeHolder.BackgroundTransparency=1 xcodeHolder.Parent=xcodeScroll
local xcodeLay=Instance.new("UIListLayout")xcodeLay.SortOrder=Enum.SortOrder.LayoutOrder xcodeLay.Padding=UDim.new(0,6)xcodeLay.Parent=xcodeHolder
local xcodeEmpty=Instance.new("TextLabel")xcodeEmpty.Size=UDim2.new(1,0,0,24)xcodeEmpty.BackgroundTransparency=1 xcodeEmpty.Font=Enum.Font.Gotham xcodeEmpty.Text="ask Xcode anything about scripts..."xcodeEmpty.TextColor3=C.subText xcodeEmpty.TextSize=11 xcodeEmpty.TextXAlignment=Enum.TextXAlignment.Left xcodeEmpty.Parent=xcodeHolder
xcodeChatRef.holder=xcodeHolder xcodeChatRef.scroll=xcodeScroll xcodeChatRef.empty=xcodeEmpty
xcodeHolder.ChildAdded:Connect(function(child)if child:IsA("Frame")then scrollToBottom2()end end)
local xcodeInputBar=Instance.new("Frame")xcodeInputBar.Size=UDim2.new(1,0,0,48)xcodeInputBar.Position=UDim2.new(0,0,1,-48)xcodeInputBar.BackgroundColor3=C.panelTop xcodeInputBar.BorderSizePixel=0 xcodeInputBar.Parent=xcodePage
local xibStroke=Instance.new("UIStroke")xibStroke.Color=C.border xibStroke.Thickness=1 xibStroke.Transparency=0.4 xibStroke.ApplyStrokeMode=Enum.ApplyStrokeMode.Border xibStroke.Parent=xcodeInputBar
local xcodeInput=Instance.new("TextBox")xcodeInput.Size=UDim2.new(1,-66,0,34)xcodeInput.Position=UDim2.new(0,10,0,7)xcodeInput.BackgroundColor3=C.panel xcodeInput.BorderSizePixel=0 xcodeInput.Font=Enum.Font.Code xcodeInput.Text=""xcodeInput.PlaceholderText="ask Xcode for scripts..."xcodeInput.PlaceholderColor3=C.subText xcodeInput.TextColor3=C.text xcodeInput.TextSize=11 xcodeInput.TextXAlignment=Enum.TextXAlignment.Left xcodeInput.ClearTextOnFocus=false xcodeInput.MultiLine=false xcodeInput.Parent=xcodeInputBar corner(xcodeInput,8)stroke(xcodeInput,C.border,1,0.3)
local xibPad=Instance.new("UIPadding")xibPad.PaddingLeft=UDim.new(0,10)xibPad.PaddingRight=UDim.new(0,10)xibPad.Parent=xcodeInput
local xcodeSendBtn=Instance.new("TextButton")xcodeSendBtn.Size=UDim2.new(0,40,0,34)xcodeSendBtn.Position=UDim2.new(1,-50,0,7)xcodeSendBtn.BackgroundColor3=C.button xcodeSendBtn.BorderSizePixel=0 xcodeSendBtn.Font=Enum.Font.Code xcodeSendBtn.Text="▶"xcodeSendBtn.TextColor3=C.text xcodeSendBtn.TextSize=18 xcodeSendBtn.AutoButtonColor=false xcodeSendBtn.Parent=xcodeInputBar corner(xcodeSendBtn,8)stroke(xcodeSendBtn,C.border,1,0.3)styleBtn(xcodeSendBtn)
function submitXcodeChat()local txt=xcodeInput.Text if not txt or txt==""then return end txt=txt:gsub("^%s+",""):gsub("%s+$","")if txt==""then return end xcodeInput.Text=""task.spawn(function()handlePrivateAIChat2(txt)end)end
xcodeSendBtn.Activated:Connect(submitXcodeChat)xcodeInput.FocusLost:Connect(function(ep)if ep then submitXcodeChat()end end)
local apiPage=newPage()apiPage.Name="ApiKeysPage"
local apiPad=Instance.new("UIPadding")apiPad.PaddingTop=UDim.new(0,14)apiPad.PaddingLeft=UDim.new(0,14)apiPad.PaddingRight=UDim.new(0,14)apiPad.PaddingBottom=UDim.new(0,10)apiPad.Parent=apiPage
local apiTitle=Instance.new("TextLabel")apiTitle.Size=UDim2.new(1,0,0,18)apiTitle.Position=UDim2.new(0,0,0,0)apiTitle.BackgroundTransparency=1 apiTitle.Font=Enum.Font.GothamBold apiTitle.Text="API KEYS"apiTitle.TextColor3=C.text apiTitle.TextSize=13 apiTitle.TextXAlignment=Enum.TextXAlignment.Left apiTitle.Parent=apiPage
local apiSub=Instance.new("TextLabel")apiSub.Size=UDim2.new(1,0,0,16)apiSub.Position=UDim2.new(0,0,0,20)apiSub.BackgroundTransparency=1 apiSub.Font=Enum.Font.Gotham apiSub.Text="click any key below to copy it"apiSub.TextColor3=C.subText apiSub.TextSize=9 apiSub.TextXAlignment=Enum.TextXAlignment.Left apiSub.Parent=apiPage
function copyToClipboard(txt)
if type(setclipboard)=="function" then pcall(setclipboard,txt) return true end
if type(toclipboard)=="function" then pcall(toclipboard,txt) return true end
if syn and type(syn.write_clipboard)=="function" then pcall(syn.write_clipboard,txt) return true end
if type(writeclipboard)=="function" then pcall(writeclipboard,txt) return true end
return false
end
local function mkKeyRow(y,label,getKey)
local ll=Instance.new("TextLabel")
ll.Size=UDim2.new(1,0,0,12)
ll.Position=UDim2.new(0,0,0,y)
ll.BackgroundTransparency=1
ll.Font=Enum.Font.GothamBold
ll.Text=label
ll.TextColor3=C.text
ll.TextSize=9
ll.TextXAlignment=Enum.TextXAlignment.Left
ll.Parent=apiPage
local btn=Instance.new("TextButton")
btn.Size=UDim2.new(1,0,0,26)
btn.Position=UDim2.new(0,0,0,y+14)
btn.BackgroundColor3=C.track
btn.BorderSizePixel=0
btn.Font=Enum.Font.Code
btn.Text=getKey() or "(not set)"
btn.TextColor3=C.text
btn.TextSize=9
btn.TextXAlignment=Enum.TextXAlignment.Left
btn.TextTruncate=Enum.TextTruncate.AtEnd
btn.AutoButtonColor=false
btn.Parent=apiPage
corner(btn,6)
stroke(btn,C.border,1,0.3)
local pdd=Instance.new("UIPadding")
pdd.PaddingLeft=UDim.new(0,10)
pdd.PaddingRight=UDim.new(0,10)
pdd.Parent=btn
local fb=Instance.new("TextLabel")
fb.Size=UDim2.new(1,0,0,10)
fb.Position=UDim2.new(0,0,0,y+42)
fb.BackgroundTransparency=1
fb.Font=Enum.Font.Gotham
fb.Text=""
fb.TextColor3=C.green
fb.TextSize=8
fb.TextXAlignment=Enum.TextXAlignment.Left
fb.Parent=apiPage
btn.MouseEnter:Connect(function()tw(btn,0.15,{BackgroundColor3=C.buttonHover})end)
btn.MouseLeave:Connect(function()tw(btn,0.15,{BackgroundColor3=C.track})end)
btn.Activated:Connect(function()
local k=getKey()
if not k or k=="" then fb.Text="no key set"; fb.TextColor3=C.red; return end
if copyToClipboard(k) then
fb.Text="copied!"
fb.TextColor3=C.green
else
fb.Text="clipboard unsupported"
fb.TextColor3=C.red
end
task.delay(1.6,function()
if fb and fb.Parent then fb.Text="" end
end)
end)
return btn
end
mkKeyRow(42,"XcH Key (primary)",function() return APIKey end)
mkKeyRow(96,"Xcode Key",function() return APIKey2 end)
mkKeyRow(150,"XcH Backup Key",function() return APIKey3 end)
mkKeyRow(204,"Xcode Backup Key (mom's)",function() return APIKey4 end)
local apiInfo=Instance.new("TextLabel")
apiInfo.Size=UDim2.new(1,0,0,20)
apiInfo.Position=UDim2.new(0,0,0,258)
apiInfo.BackgroundTransparency=1
apiInfo.Font=Enum.Font.Gotham
apiInfo.Text="XcH + Xcode auto-fallback to backups on quota."
apiInfo.TextColor3=C.subText
apiInfo.TextSize=8
apiInfo.TextXAlignment=Enum.TextXAlignment.Left
apiInfo.TextYAlignment=Enum.TextYAlignment.Top
apiInfo.TextWrapped=true
apiInfo.Parent=apiPage
local pwOv=Instance.new("Frame")
pwOv.Size=UDim2.new(1,0,1,0)
pwOv.BackgroundColor3=C.panel
pwOv.BorderSizePixel=0
pwOv.ZIndex=100
pwOv.Visible=false
pwOv.Parent=frame
local pwTitle=Instance.new("TextLabel")
pwTitle.Size=UDim2.new(1,-40,0,22)
pwTitle.Position=UDim2.new(0,20,0,70)
pwTitle.BackgroundTransparency=1
pwTitle.Font=Enum.Font.GothamBold
pwTitle.Text="API KEYS LOCKED"
pwTitle.TextColor3=C.text
pwTitle.TextSize=14
pwTitle.TextXAlignment=Enum.TextXAlignment.Left
pwTitle.ZIndex=101
pwTitle.Parent=pwOv
local pwHint=Instance.new("TextLabel")
pwHint.Size=UDim2.new(1,-40,0,16)
pwHint.Position=UDim2.new(0,20,0,96)
pwHint.BackgroundTransparency=1
pwHint.Font=Enum.Font.Gotham
pwHint.Text="enter password to view api keys"
pwHint.TextColor3=C.subText
pwHint.TextSize=10
pwHint.TextXAlignment=Enum.TextXAlignment.Left
pwHint.ZIndex=101
pwHint.Parent=pwOv
local pwBox=Instance.new("TextBox")
pwBox.Size=UDim2.new(1,-40,0,34)
pwBox.Position=UDim2.new(0,20,0,122)
pwBox.BackgroundColor3=C.track
pwBox.BorderSizePixel=0
pwBox.Font=Enum.Font.Code
pwBox.Text=""
pwBox.PlaceholderText="password"
pwBox.PlaceholderColor3=C.subText
pwBox.TextColor3=C.text
pwBox.TextSize=12
pwBox.ClearTextOnFocus=false
pwBox.TextXAlignment=Enum.TextXAlignment.Left
pwBox.ZIndex=101
pwBox.Parent=pwOv
corner(pwBox,6)
stroke(pwBox,C.border,1,0.3)
local pwp=Instance.new("UIPadding")
pwp.PaddingLeft=UDim.new(0,10)
pwp.PaddingRight=UDim.new(0,10)
pwp.Parent=pwBox
local pwErr=Instance.new("TextLabel")
pwErr.Size=UDim2.new(1,-40,0,16)
pwErr.Position=UDim2.new(0,20,0,162)
pwErr.BackgroundTransparency=1
pwErr.Font=Enum.Font.Gotham
pwErr.Text=""
pwErr.TextColor3=C.red
pwErr.TextSize=10
pwErr.TextXAlignment=Enum.TextXAlignment.Left
pwErr.ZIndex=101
pwErr.Parent=pwOv
local function mkPwBtn(txt,pos)
local b=Instance.new("TextButton")
b.Size=UDim2.new(0.5,-28,0,38)
b.Position=pos
b.BackgroundColor3=C.button
b.BorderSizePixel=0
b.Font=Enum.Font.GothamBold
b.Text=txt
b.TextColor3=C.text
b.TextSize=13
b.AutoButtonColor=false
b.ZIndex=101
b.Parent=pwOv
corner(b,10)
stroke(b,C.border,1,0.2)
styleBtn(b)
return b
end
local pwBack=mkPwBtn("BACK",UDim2.new(0,20,1,-60))
local pwGo=mkPwBtn("UNLOCK",UDim2.new(0.5,8,1,-60))
apiUnlocked=false
local function tryUnlock()
if pwBox.Text==API_PASSWORD then
apiUnlocked=true
pwOv.Visible=false
pwErr.Text=""
pwBox.Text=""
slideToPage(apiPage,apiTab)
else
pwErr.Text="wrong password"
pwBox.Text=""
end
end
pwGo.Activated:Connect(tryUnlock)
pwBack.Activated:Connect(function()
pwOv.Visible=false
pwErr.Text=""
pwBox.Text=""
end)
pwBox.FocusLost:Connect(function(ep)
if ep then tryUnlock() end
end)
currentPage=nil currentTabBtn=nil
function makeTab(name,order,onClick)local b=Instance.new("TextButton")b.Size=UDim2.new(1,0,0,32)b.BackgroundColor3=C.sidebar b.BorderSizePixel=0 b.Font=Enum.Font.GothamMedium b.Text="  "..name b.TextColor3=C.text b.TextSize=11 b.TextXAlignment=Enum.TextXAlignment.Left b.AutoButtonColor=false b.LayoutOrder=order b.Parent=sidebar corner(b,6)b.MouseEnter:Connect(function()if b~=currentTabBtn then tw(b,0.15,{BackgroundColor3=C.buttonHover})end end)b.MouseLeave:Connect(function()if b~=currentTabBtn then tw(b,0.15,{BackgroundColor3=C.sidebar})end end)b.Activated:Connect(onClick)return b end
function slideToPage(newPage,newTabBtn)if currentPage==newPage then return end local oldPage=currentPage local oldTab=currentTabBtn if oldTab then tw(oldTab,0.2,{BackgroundColor3=C.sidebar})end if newTabBtn then tw(newTabBtn,0.2,{BackgroundColor3=C.activeTab})end currentTabBtn=newTabBtn local W2=contentArea.AbsoluteSize.X if W2<=0 then W2=420 end if oldPage then tw(oldPage,0.3,{Position=UDim2.new(0,W2,0,0)},Enum.EasingStyle.Quart,Enum.EasingDirection.In)task.delay(0.3,function()if oldPage then oldPage.Visible=false end end)end newPage.Position=UDim2.new(0,W2,0,0)newPage.Visible=true task.delay(0.04,function()tw(newPage,0.38,{Position=UDim2.new(0,0,0,0)},Enum.EasingStyle.Quart,Enum.EasingDirection.Out)end)currentPage=newPage end
logsTab=makeTab("Logs",1,function()slideToPage(logsPage,logsTab)end)
cmdsTab=makeTab("Cmds",2,function()slideToPage(cmdsPage,cmdsTab)end)
xcodeTab=makeTab("Xcode",3,function()slideToPage(xcodePage,xcodeTab)end)
apiTab=makeTab("Api Keys",4,function()
if apiUnlocked then
slideToPage(apiPage,apiTab)
else
pwOv.Visible=true
pwBox.Text=""
pwErr.Text=""
end
end)
currentPage=nil currentTabBtn=nil slideToPage(cmdsPage,cmdsTab)
local roleOv=Instance.new("Frame")roleOv.Size=UDim2.new(1,0,1,0)roleOv.BackgroundColor3=C.panel roleOv.BorderSizePixel=0 roleOv.ZIndex=50 roleOv.Visible=true roleOv.Parent=frame
function mkLabel(parent,txt,pos,size,font,color,tsize,align,z)local l=Instance.new("TextLabel")l.Size=size l.Position=pos l.BackgroundTransparency=1 l.Font=font l.Text=txt l.TextColor3=color l.TextSize=tsize l.TextXAlignment=align or Enum.TextXAlignment.Center l.ZIndex=z or 51 l.Parent=parent return l end
function mkBtn(parent,txt,pos,size,z)local b=Instance.new("TextButton")b.Size=size b.Position=pos b.BackgroundColor3=C.button b.BorderSizePixel=0 b.Font=Enum.Font.GothamBold b.Text=txt b.TextColor3=C.text b.TextSize=15 b.AutoButtonColor=false b.ZIndex=z or 51 b.Parent=parent corner(b,10)stroke(b,C.border,1,0.2)styleBtn(b)return b end
mkLabel(roleOv,"SELECT ROLE",UDim2.new(0,20,0,20),UDim2.new(1,-40,0,22),Enum.Font.GothamBold,C.text,13,Enum.TextXAlignment.Left)
mkLabel(roleOv,"What should this account do?",UDim2.new(0,20,0,44),UDim2.new(1,-40,0,18),Enum.Font.Gotham,C.subText,10,Enum.TextXAlignment.Left)
hostBtn=mkBtn(roleOv,"HOST",UDim2.new(0,24,0,90),UDim2.new(0.5,-32,0,90))
mkLabel(roleOv,"Full panel + tabs",UDim2.new(0,24,0,186),UDim2.new(0.5,-32,0,16),Enum.Font.Gotham,C.subText,9)
botBtn=mkBtn(roleOv,"BOT",UDim2.new(0.5,8,0,90),UDim2.new(0.5,-32,0,90))
mkLabel(roleOv,"Follows host, compact",UDim2.new(0.5,8,0,186),UDim2.new(0.5,-32,0,16),Enum.Font.Gotham,C.subText,9)
local confOv=Instance.new("Frame")confOv.Size=UDim2.new(1,0,1,0)confOv.BackgroundColor3=C.panel confOv.BorderSizePixel=0 confOv.ZIndex=55 confOv.Visible=false confOv.Parent=frame
mkLabel(confOv,"LOCK IN AS HOST?",UDim2.new(0,20,0,80),UDim2.new(1,-40,0,24),Enum.Font.GothamBold,C.text,14,Enum.TextXAlignment.Left,56)
mkLabel(confOv,"You get the full tabbed panel with private XcH chat.",UDim2.new(0,20,0,108),UDim2.new(1,-40,0,40),Enum.Font.Gotham,C.subText,11,Enum.TextXAlignment.Left,56).TextWrapped=true
local cYes=mkBtn(confOv,"YES",UDim2.new(0,20,1,-60),UDim2.new(0.5,-32,0,40),56)cYes.TextSize=13
local cNo=mkBtn(confOv,"BACK",UDim2.new(0.5,8,1,-60),UDim2.new(0.5,-32,0,40),56)cNo.TextSize=13
local bsOv=Instance.new("Frame")bsOv.Size=UDim2.new(1,0,1,0)bsOv.BackgroundColor3=C.panel bsOv.BorderSizePixel=0 bsOv.ZIndex=55 bsOv.Visible=false bsOv.Parent=frame
mkLabel(bsOv,"BOT SETUP",UDim2.new(0,20,0,14),UDim2.new(1,-40,0,22),Enum.Font.GothamBold,C.text,13,Enum.TextXAlignment.Left,56)
mkLabel(bsOv,"Pick the HOST below.",UDim2.new(0,20,0,38),UDim2.new(1,-40,0,16),Enum.Font.Gotham,C.subText,10,Enum.TextXAlignment.Left,56)
local plFrame=Instance.new("Frame")plFrame.Size=UDim2.new(1,-40,1,-142)plFrame.Position=UDim2.new(0,20,0,62)plFrame.BackgroundColor3=C.track plFrame.BorderSizePixel=0 plFrame.ClipsDescendants=true plFrame.ZIndex=56 plFrame.Parent=bsOv corner(plFrame,8)stroke(plFrame,C.border,1,0.3)
local plScroll=Instance.new("ScrollingFrame")plScroll.Size=UDim2.new(1,-8,1,-6)plScroll.Position=UDim2.new(0,4,0,3)plScroll.BackgroundTransparency=1 plScroll.BorderSizePixel=0 plScroll.CanvasSize=UDim2.new(0,0,0,0)plScroll.AutomaticCanvasSize=Enum.AutomaticSize.Y plScroll.ScrollBarThickness=4 plScroll.ScrollBarImageColor3=C.border plScroll.ZIndex=56 plScroll.Parent=plFrame
local plLay=Instance.new("UIListLayout")plLay.Padding=UDim.new(0,3)plLay.SortOrder=Enum.SortOrder.LayoutOrder plLay.Parent=plScroll
selectedHost=nil
local bsErr=mkLabel(bsOv,"",UDim2.new(0,20,1,-70),UDim2.new(1,-40,0,16),Enum.Font.GothamMedium,C.red,10,Enum.TextXAlignment.Left,56)bsErr.TextTransparency=1
local bsBack=mkBtn(bsOv,"BACK",UDim2.new(0,20,1,-52),UDim2.new(0.5,-32,0,38),56)bsBack.TextSize=13
local bsLock=mkBtn(bsOv,"LOCK IN",UDim2.new(0.5,8,1,-52),UDim2.new(0.5,-32,0,38),56)bsLock.TextSize=13
function refreshPlayers()for _,c in ipairs(plScroll:GetChildren())do if c:IsA("TextButton")then c:Destroy()end end selectedHost=nil local n=0 for _,p in ipairs(P:GetPlayers())do if p==pl then continue end n=n+1 local isOwner=(p.Name:lower()==ON)local baseColor=isOwner and Color3.fromRGB(215,245,220)or C.button local hoverColor=isOwner and Color3.fromRGB(200,240,210)or C.buttonHover local b=Instance.new("TextButton")b.Size=UDim2.new(1,0,0,28)b.BackgroundColor3=baseColor b.BorderSizePixel=0 b.Font=Enum.Font.GothamMedium b.Text="  "..p.Name.."  (@"..p.DisplayName..")"b.TextColor3=isOwner and C.green or C.text b.TextSize=10 b.TextXAlignment=Enum.TextXAlignment.Left b.AutoButtonColor=false b.LayoutOrder=n b.ZIndex=57 b:SetAttribute("isOwnerRow",isOwner)b.Parent=plScroll corner(b,6)local sl2=stroke(b,isOwner and C.green or C.border,1,isOwner and 0.2 or 0.3)b.MouseEnter:Connect(function()if selectedHost~=p.Name then tw(b,0.15,{BackgroundColor3=hoverColor})end end)b.MouseLeave:Connect(function()if selectedHost~=p.Name then tw(b,0.15,{BackgroundColor3=baseColor})end end)b.Activated:Connect(function()for _,c2 in ipairs(plScroll:GetChildren())do if c2:IsA("TextButton")then local c2Owner=c2:GetAttribute("isOwnerRow")c2.BackgroundColor3=c2Owner and Color3.fromRGB(215,245,220)or C.button local s=c2:FindFirstChildOfClass("UIStroke")if s then s.Color=c2Owner and C.green or C.border s.Transparency=c2Owner and 0.2 or 0.3 end end end selectedHost=p.Name b.BackgroundColor3=C.activeTab sl2.Color=C.accent sl2.Transparency=0 bsErr.TextTransparency=1 bsErr.Text=""end)end if n==0 then mkLabel(plScroll,"no other players",UDim2.new(0,8,0,0),UDim2.new(1,-16,0,30),Enum.Font.Gotham,C.subText,10,Enum.TextXAlignment.Left,57)end end
function lockRole(role,hostName)ROLE=role roleOv.Visible=false confOv.Visible=false bsOv.Visible=false if role=="HOST"then hostFilter.userId=pl.UserId hostFilter.name=pl.Name:lower()frame.Size=UDim2.new(0,520,0,320)topBar.Visible=true sidebar.Visible=true contentArea.Visible=true logsTab.Visible=false slideToPage(cmdsPage,cmdsTab)show()elseif role=="BOT"then frame.Size=UDim2.new(0,380,0,260)topBar.Visible=true sidebar.Visible=true contentArea.Visible=true cmdsTab.Visible=false xcodeTab.Visible=false apiTab.Visible=false slideToPage(logsPage,logsTab)titleLbl.Text=AN.." (bot)"sendChat(pick(R_.startup))hostFilter.name=hostName:lower()S.hostName=hostName:lower()originalHost.name=hostName:lower()for _,p in ipairs(P:GetPlayers())do if p.Name:lower()==hostName:lower()then hostFilter.userId=p.UserId originalHost.userId=p.UserId break end end if hostName:lower()==ON then isOwnerHost=true task.wait(1)sendChat(pick({"hey boss","yo boss","sup boss","welcome back boss","good to see you boss"}))end applyFixedSpeed()startFacing()startFollow()bindDeath()startAfk()startMirrorJump()startCameraMicro()end end
hostBtn.Activated:Connect(function()roleOv.Visible=false confOv.Visible=true end)
botBtn.Activated:Connect(function()bsErr.Text=""bsErr.TextTransparency=1 roleOv.Visible=false bsOv.Visible=true refreshPlayers()end)
cNo.Activated:Connect(function()confOv.Visible=false roleOv.Visible=true end)
bsBack.Activated:Connect(function()bsOv.Visible=false roleOv.Visible=true end)
cYes.Activated:Connect(function()lockRole("HOST")end)
bsLock.Activated:Connect(function()if not selectedHost then bsErr.Text="Please select a player from the list."bsErr.TextTransparency=0 return end lockRole("BOT",selectedHost)end)
local storage=Instance.new("Folder")storage.Name=SN storage.Parent=pg
local toolTemplate=Instance.new("Tool")toolTemplate.Name=TN toolTemplate.ToolTip="InterDimensional Panel By XCDevs"toolTemplate.RequiresHandle=false toolTemplate.CanBeDropped=false toolTemplate.Parent=storage
local bound=setmetatable({},{__mode="k"})
function findLive()local b=bp()if b then local t=b:FindFirstChild(TN)if t and t:IsA("Tool")then return t end end local c=pl.Character if c then local t=c:FindFirstChild(TN)if t and t:IsA("Tool")then return t end end return nil end
function bindTool(t)if not t or not t:IsA("Tool")or bound[t]then return end bound[t]=true t.Equipped:Connect(function()if ROLE=="HOST"or ROLE=="BOT"then show()end end)t.Unequipped:Connect(function()if ROLE=="HOST"or ROLE=="BOT"then hide()end end)t.Destroying:Connect(function()bound[t]=nil end)end
function removeDupes()local list={}local b=bp()if b then for _,o in ipairs(b:GetChildren())do if o:IsA("Tool")and o.Name==TN then table.insert(list,o)end end end local c=pl.Character if c then for _,o in ipairs(c:GetChildren())do if o:IsA("Tool")and o.Name==TN then table.insert(list,o)end end end for i=2,#list do list[i]:Destroy()end end
function giveTool()local ex=findLive()if ex then bindTool(ex)return end local b=bp()if not b then return end local t=toolTemplate:Clone()t.Parent=b bindTool(t)end
pl.CharacterAdded:Connect(function(char)local h=char:WaitForChild("Humanoid",5)if not h then return end task.wait(0.5)removeDupes()giveTool()h.UseJumpPower=true h.WalkSpeed=BS h.JumpPower=BJ rotationOwner="Humanoid"h.AutoRotate=true stopDance()stopSpin()stopLead(false)stopFling(false)S.sitting=false S.waypoints=nil S.cachedPath=nil S.lastMovePos=nil S.committedTarget=nil S.hostInVoid=false S.mirrorJumpTime=0 S.lastPathSig=nil S.stableFollowDir=nil if ROLE=="BOT"then bindDeath()if not S.facing then startFacing()end if S.swordKillActive and S.swordKillTarget then local tg=S.swordKillTarget S.swordKillTarget=nil S.swordKillActive=false if S.swordKillThread then task.cancel(S.swordKillThread)S.swordKillThread=nil end task.wait(0.6)if tg.Parent then startSwordKill(tg.Name)end end end end)
task.spawn(function()task.wait(0.5)removeDupes()giveTool()local h=hum()if h then h.UseJumpPower=true h.WalkSpeed=BS h.JumpPower=BJ end end)
gui.Enabled=true roleOv.Visible=true frame.Position=SHOWN pcall(show)
