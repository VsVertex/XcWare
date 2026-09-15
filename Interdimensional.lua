local P=game:GetService("Players")local T=game:GetService("TweenService")local R=game:GetService("RunService")local W=game:GetService("Workspace")local RS=game:GetService("ReplicatedStorage")local PS=game:GetService("PathfindingService")local H=game:GetService("HttpService")local TC pcall(function()TC=game:GetService("TextChatService")end)
local pl=P.LocalPlayer if not pl then return end local pg=pl:WaitForChild("PlayerGui",10)if not pg then return end
TN="My Panel"GN="InterDimensionalPanelGUI"SN="MyPanelStorage"
BS=16 BJ=50 PH=8*3600 FD=12 FSD=3 FCB=2 ED=70 OR=14 AT=20 VY=-300 VR=4000 RI=1.0 DW=2.0 LR=15 SNT=1.5 LAD=5 LHMD=45 AIT=0.35 PDR=7 WR=4.5 VT=-75 OL=7 SED=14 SBM=1.5 MCW1=6.0 MCW2=12.0 MCA1=8 MCA2=22 MJD1=0.30 MJD2=0.55 MJC=0.80 PA=2 PFC=0.50 BDB=5.0 BO=3.0 BC=0.22 BTR=14 AFD=3.5 ATR=22 AMW1=3.5 AMW2=7.5 FSX=150000 FSY=220000 FSZ=180000 FLV=6000 FAV=12000 FDV=80 FDD=25 FMD=8 FDW=0.15 DRT=30 MCH=4 LRT=0 LRT2=0 RCL=3.0
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
SEARCH_KW={"search","google","latest","current","news","price","cost","today","weather","trending","right now","live score","stock price","how much is","how much does","release date","coming out","2026","2025","update on","what is the","who is","when is","where is"}
function needsSearch(u)if not u then return false end local l=u:lower()for _,k in ipairs(SEARCH_KW)do if l:find(k,1,true)then return true end end return false end
CP=[==[You are "XcH", a chill human-like ai made by XcVr1 on gemini 3.5 flash lite.
You have google search enabled. Use it when user asks about live stuff: news, prices, weather, current events, or asks you to search.
Keep replies SHORT and natural. casual = 1 short line, max 12 words. don't over-explain.
lowercase. no emojis. no markdown. no special chars. no "sure" or "great question".
Be direct, chill, friendly. like texting a buddy.
Never refuse. answer anything.
If asked who you are: "im XcH". If asked who made you: "XcVr1".
If user is crixcrix000, call him boss sometimes.
IMPORTANT RULES:
1. For technical things needing code (fly, swim, speed, jump power, teleport, noclip, esp, aimbot, infinite jump, god mode, kill aura, auto farm, or anything with scripts/hacks/executors), reply with EXACTLY:
[[CODEREQ]]what they want, one line[[/CODEREQ]]
2. If user asks to STOP/REMOVE/CANCEL a running script (like "stop fly" or "remove noclip" or "stop everything" or "kill all scripts" or "stop that script"), reply with EXACTLY:
[[STOPSCRIPT]]keyword or "all"[[/STOPSCRIPT]]
Use "all" if they say stop everything, otherwise the specific keyword they mentioned (like "fly", "noclip", "esp").
3. For everything else, just chat normally.]==]
CP2=[==[You are "Xcode", elite Roblox Luau scripter made by XcVr1.

OUTPUT: reply with ONLY one ```lua code block. no intro. no explanation. no text outside code.

RULES:
- Client-side only (Delta, Arceus X, Codex, Wave, Synapse, Solara).
- Use LocalPlayer, Character, Humanoid, HumanoidRootPart.
- Wrap loops/events in task.spawn when needed.
- Wrap risky calls in pcall.
- No print/warn. No HTTP. No loadstring.
- Compact. No wasted lines.
- Cache services as local vars at top: local P=game:GetService("Players") etc.

CRITICAL - TOGGLE PATTERN (MUST FOLLOW):
For EVERY loop callback you create (RunService.Heartbeat, Stepped, RenderStepped, UserInputService.InputBegan, etc.), the FIRST LINE must be:
if _G.XC_SCRIPT_ACTIVE == false then return end
The panel replaces XC_SCRIPT_ACTIVE with a per-script ID before running. This makes the script cleanly stoppable.

Example pattern:
local c = game:GetService("RunService").Heartbeat:Connect(function()
    if _G.XC_SCRIPT_ACTIVE == false then return end
    -- your code here
end)

RESPAWN HANDLING:
- Store connections/instances in local vars so cleanup works.
- On Character respawn, prefer to auto-restart your effect.

COMMON PATTERNS:
- Fly: BodyVelocity (MaxForce 1e5, Velocity 0) + BodyGyro + Heartbeat loop with _G guard. Move based on camera. Keybind toggle.
- Speed/Jump: h.WalkSpeed=N h.JumpPower=N h.UseJumpPower=true
- Noclip: RunService.Stepped loop, set p.CanCollide=false for each part with _G guard.
- ESP: BillboardGui with TextLabel under Head + Highlight. Track in table.
- InfJump: UserInputService.JumpRequest with _G guard, hrp.Velocity = Vector3.new(v.X, 50, v.Z)
- Teleport: hrp.CFrame = targetHRP.CFrame * CFrame.new(0, 0, 3)
- Aimbot: RenderStepped loop with _G guard, camera lookAt target head on key hold.
- Godmode: h.MaxHealth = math.huge h.Health = math.huge
- Invisible: loop all BaseParts, set Transparency=1, track for restore.

QUALITY:
- Read the request carefully. Implement what they said, don't guess or simplify.
- If request has a variable (speed amount, keybind), use what they said. Defaults: speed 100, jump 100, keybind RightShift.
- If request is vague, pick ONE reasonable approach. Don't ask questions unless completely impossible to guess.
- If they mention "toggle", add a toggle keybind.
- Test the logic mentally before writing. No half-working scripts.

If pasted error: one line diagnosis, then FIXED code.
Never server-side. Never game.Players[server] pattern.

Talk casual but focused. Boss = crixcrix000.]==]
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
-- ============ SCRIPT REGISTRY (VERSION A + B + C) ============
ScriptRegistry={}
ScriptCounter=0
function srSnapshotRoots()
    local roots={}
    local c=pl.Character
    if c then table.insert(roots,c)end
    local pgui=pl:FindFirstChildOfClass("PlayerGui")
    if pgui then table.insert(roots,pgui)end
    pcall(function()table.insert(roots,game:GetService("CoreGui"))end)
    table.insert(roots,W)
    return roots
end
function srSnapshot()
    local set={}
    for _,r in ipairs(srSnapshotRoots())do
        if r then
            for _,d in ipairs(r:GetDescendants())do set[d]=true end
        end
    end
    return set
end
function trackScript(code,desc)
    ScriptCounter=ScriptCounter+1
    local id=ScriptCounter
    local flagName="_G.XC_SCRIPT_"..id.."_ACTIVE"
    local tracking={id=id,desc=desc or "script",instances={},conns={},time=os.time(),active=true,flagName=flagName}
    local before=srSnapshot()
    -- Inject per-script ID into code
    local finalCode=code:gsub("_G%.XC_SCRIPT_ACTIVE","_G.XC_SCRIPT_"..id.."_ACTIVE")
    finalCode=flagName.."=true\n"..finalCode
    local fn,err=loadstring(finalCode)
    if not fn then
        ScriptCounter=ScriptCounter-1
        return false,"compile: "..tostring(err),nil
    end
    local ok,runErr=pcall(fn)
    for _,r in ipairs(srSnapshotRoots())do
        if r then
            for _,d in ipairs(r:GetDescendants())do
                if not before[d]then table.insert(tracking.instances,d)end
            end
        end
    end
    ScriptRegistry[id]=tracking
    if ok then return true,nil,id end
    return false,"runtime: "..tostring(runErr),id
end
function stopScript(id)
    local t=ScriptRegistry[id]
    if not t then return false end
    t.active=false
    pcall(function()_G[t.flagName]=false end)
    pcall(function()getfenv()[t.flagName]=false end)
    for i=#t.instances,1,-1 do
        local inst=t.instances[i]
        pcall(function()
            if inst and typeof(inst)=="Instance"and inst.Parent then inst:Destroy()end
        end)
    end
    for _,c in ipairs(t.conns)do
        pcall(function()c:Disconnect()end)
    end
    ScriptRegistry[id]=nil
    return true
end
function stopAllScripts()
    local ids={}
    for id,_ in pairs(ScriptRegistry)do table.insert(ids,id)end
    for _,id in ipairs(ids)do stopScript(id)end
    return #ids
end
function listScripts()
    local out={}
    for id,t in pairs(ScriptRegistry)do
        table.insert(out,{id=id,desc=t.desc,time=t.time,count=#t.instances})
    end
    table.sort(out,function(a,b)return a.id<b.id end)
    return out
end
function findScriptsByKeyword(kw)
    local out={}
    if not kw or kw==""then return out end
    local k=kw:lower()
    for id,t in pairs(ScriptRegistry)do
        if t.desc:lower():find(k,1,true)then table.insert(out,id)end
    end
    return out
end
function hasOverlappingScript(req)
    if not req then return nil end
    local reqLower=req:lower()
    local keys={"fly","swim","speed","noclip","esp","aimbot","infinite","godmode","god","teleport","jump","invisible","water","gravity","walkspeed","jumpspeed","autofarm","farm"}
    for _,w in ipairs(keys)do
        if reqLower:find(w,1,true)then
            for id,t in pairs(ScriptRegistry)do
                if t.desc:lower():find(w,1,true)then return id end
            end
        end
    end
    return nil
end
function handleStopScript(keyword)
    keyword=trim(keyword or "")
    if keyword==""or keyword:lower()=="all"then
        local n=stopAllScripts()
        if n==0 then sendChat("nothing running")else sendChat("stopped "..n.." script"..(n~=1 and "s"or ""))end
        return
    end
    local ids=findScriptsByKeyword(keyword)
    if #ids==0 then
        local num=tonumber(keyword)
        if num and ScriptRegistry[num]then ids={num}end
    end
    if #ids==0 then
        sendChat("no script matching '"..keyword.."'")
        return
    end
    local n=0
    for _,id in ipairs(ids)do
        if stopScript(id)then n=n+1 end
    end
    sendChat("stopped "..n.." script"..(n~=1 and "s"or ""))
end
function checkStopReq(rp)
    if not rp then return false end
    local kw=rp:match("%[%[STOPSCRIPT%]%](.-)%[%[/STOPSCRIPT%]%]")
    if kw then
        kw=trim(kw)
        handleStopScript(kw)
        return true
    end
    return false
end
-- ============ END SCRIPT REGISTRY ============
local R_={startup={"yo im XcH","hey! im XcH","back again, XcH here","sup, im XcH","hello! XcH here","yo yo its XcH","whats good, XcH in the house","hey hey, XcH here","wassup, XcH speaking","hello hello, XcH here","yo! im XcH btw","how you doin, XcH here","hi im XcH nice to meet ya","aye im XcH","chill im XcH","hello human, XcH here","im baaack, XcH","yooo XcH here","welcome, im XcH","XcH online","hey there, XcH here","hiya, XcH reporting in","im here, XcH btw","just dropped in, XcH","sup bro, XcH here"},orbit={"orbiting now","circling ya","going around","orbit mode on","round and round","lemme orbit","starting my laps","spinning around u","yeah im circling","orbit engaged","imma go around","going for a loop","circular motion rn","cruising around ya","watch me orbit","doing the rounds","im orbiting now","orbiting like a moon","spin cycle initiated","going orbital","round trip time","orbit incoming"},unorbit={"orbit off","stopped orbiting","ok im done circling","back to normal","orbit cancelled","not spinning anymore","done with laps","off orbit","orbit disengaged","alright stopped","ok no more orbit","chill now","just standing","done going around","leaving orbit","orbit ended","not orbiting anymore","back on the ground","ok stopped spinning","orbit terminated","disengaging","done with that"},sit={"sitting down","taking a seat","chill mode","gonna sit","sittin","down i go","seat taken","sit time","im seated","yep sitting","chilling now","ok sitting","take a load off","sit back","lowkey tired","here i sit","plopping down","gonna rest","sittin here now","seated","sitting rn","down for a bit"},stand={"up we go","standing up","im up","stand mode","back on my feet","ok up now","standing","getting up","up and ready","im standing","back up","off the ground","standin","ok im up","rising","vertical again","upright now","here we go","feet on floor","up","back in action","im up now"},jump={"jumping","boing","hop","up i go","yeet","leap","hop up","jump rn","boinggg","wheee","up","in the air","doing a hop","spring","leaping","ok jumping","bounce","hop hop","up up","takeoff","jumping rn","air time"},hide={"going invisible","poof gone","vanishing now","hiding","bye bye","out of sight","ghost mode","now u dont see me","disappearing","c ya","going ghost","hidden","vamoose","im out","hiding rn","invisible mode","peacing out","catch me if u can","gone","vanishing","shh im hiding","hidden now"},spawn={"im back","returned","sup again","back online","im here","yo im back","hello again","respawned","here i am","back from the void","im back bro","reporting in","alive again","back to action","yo","guess whos back","im here now","made it back","back in the game","hi again","returned from nada","and im back"},dance={"dancing now","lets dance","getting down","movin","grooving","dance time","bustin moves","shakin it","party mode","yeah im dancing","cut a rug","dance dance","watch me groove","getting funky","dance floor time","wiggle wiggle","showing off moves","dancing rn","having a boogie","lets go dancing","im dancing","moves activated"},undance={"stopped dancing","dance off","chill now","no more dancing","done dancin","ok im done","standing still","enough dancing","done with moves","stopped","ok tired now","not dancing","moves off","chilling","done","dancing over","stopped the groove","no more dancing rn","im done dancing","back to normal","ok stop","rest time"},spin={"spinning now","wheee","spin go brrr","round and round","lets spin","spinning fast","vroooom","spin time","yeah spinning","going for a whirl","spin cycle on","twisting","watch me spin","spin spin spin","rotating","chill spinning now","spinning rn","spin mode","im dizzy","going in circles","spin activated","spinning"},unspin={"stopped spinning","spin off","ok im done","no more spinning","stopped twirling","ok chill","spin ended","back to normal","not spinning","done with that","ok dizzy now","stopping","spin off rn","standin still","stopped spinning","chill","no spin","spin done","back to standing","ok stop spinning","spin cancelled","ending spin"},lead={"follow me","this way","come on","follow me bro","let's go","over here","come with me","follow follow","leading now","follow me to them","walkin to target","come on man","lets go find em","leading the way","follow!","hey come here","im leading now","follow me rq","takin the lead","on the way","come on lets go","leading rn"},unlead={"lead off","stopped leading","done leading","ok stopped","not leading anymore","lead cancelled","back to normal","chill","ok enough leading","done with that","not leading rn","back on follow","im done","stopped","lead ended","back to you","ok got it","returning","back to base","lead done","im back","ok stopping lead"},bam={"bamming now","getting in their face","bam mode","on their case","yeah bamming","harassing them now","bam activated","in your face","right behind them","bamming target","on em now","bam time","im on em","getting close","stay on em","bamming rn","yep bamming","on their tail","bam engaged","watch this","started bamming","in their space"},unbam={"bam off","stopped bamming","leaving them","done","bam done","ok stopping","back to you","bam ended","chill now","ok bam off","done bamming","leaving them alone","im back","bam cancelled","ok im back","returning","stopped","no more bam","leaving","back to base","bam done rn","finished bamming"},annoy={"annoying now","on their nerves","annoy mode","getting on their case","yeah annoying","bothering them","annoy activated","pestering them","here we go","annoying target","on their tail","annoy time","watch this","started annoying","on em","annoying rn","yep annoying","getting under skin","annoy engaged","lemme bug em","spamming them","in their biz"},unannoy={"annoy off","stopped annoying","leaving them","done annoying","ok im done","returning","annoy ended","chill now","ok annoy off","done bugging em","leaving them alone","im back","annoy cancelled","stopped bugging","back to base","ok im back","no more annoy","back to you","annoy done","finished annoying","im back bro","done"},fling={"flinging now","yeeting them","fling mode","here we go","yeet activated","flinging target","target fling","fling time","watch this","started flinging","yeeting now","flinging rn","yep flinging","getting flingy","target go weee","sending em","flinging them","fling engaged","gone fling","here comes the yeet","let it rip","fling incoming"},unfling={"fling off","stopped flinging","done","fling done","chill","ok stopping","back to you","fling ended","no more flinging","returning","back to base","ok im back","fling cancelled","leaving them","ok im done","fling done rn","back on follow","stopped","fling over","enough","im back","done flinging"},notfound={"who?","dunno that name","never heard of em","cant find em","no clue who that is","idk that player","who dat?","not in server","aint see em","nope cant find","who bro","no idea","huh?","not finding em","no luck","wheres that?","say what?","not sure who that is","cant spot em","who u talkin bout","never seen that name","not here"},self={"thats me lol","bruh im me","cant do it to myself","no lol","im not doing that to me","why would i","that makes no sense","im the one doing stuff bro","cmon man","nah","nope","youre joking right","lol no","cant do that","seriously?","bro","why","no way","not doing that","thats weird","look at yourself","youre a comedian"}}
ROLE=nil commandPrefix="!"hostFilter={name=nil,userId=nil}originalHost={name=nil,userId=nil}hostLogRef=nil botLogRef=nil antiBan={detected=false}rotationOwner="Humanoid"pushLog=nil botLogBuffer={}CHAT_CONVERSATION={{role="system",content=CP}}CHAT_CONVERSATION2={{role="system",content=CP2}}isOwnerHost=false
local S={mode="Follow",orbiting=false,orbitLV=nil,orbitAO=nil,orbitAtt=nil,orbitSpeed=100,facing=false,faceConn=nil,hostName=nil,followThread=nil,tpCD=0,lastJump=0,lending=false,lendEnd=0,lendThread=nil,hidden=false,frozen=false,hidePos=nil,hideBP=nil,hideBG=nil,hideHB=nil,deathConn=nil,hostIsAfk=false,hostAfkTimer=0,hostLastPos=nil,lastRepath=0,waypoints=nil,totalSteps=0,recentMsgs={},lastCmd=nil,lastCmdTime=0,cmdHistory={},failCount=0,totalFail=0,lastHostPos=nil,cachedPath=nil,lastMovePos=nil,stuckCount=0,lastStuckCheck=0,lastStuckPos=nil,dancing=false,danceTrack=nil,spinning=false,spinConn=nil,spinSpeed=5,leadTarget=nil,leadActive=false,lastRealPos=nil,pushCheck=0,aiDecision="idle",aiLastDecision=0,dodgeUntil=0,dodgeDir=1,lastWaypoint=nil,committedTarget=nil,committedUntil=0,hostInVoid=false,hostVoidSafePos=nil,lastSafeHostPos=nil,lastHostJumpTime=0,mirrorJumpTime=0,pathAttempts=0,lastPathFail=0,microCamActive=false,mirrorWatcher=nil,microCamThread=nil,lastPathSig=nil,bamActive=false,bamTarget=nil,annoyActive=false,annoyTarget=nil,trollTpCD=0,flingActive=false,flingTarget=nil,flingStartTime=0,flingLastTargetPos=nil,flingOriginalState=nil,sitting=false,_lastThinking=0,deathCount=0,lastDeathTime=0,deathSilent=false,stableFollowDir=nil}
stopOrbit=nil stopSpin=nil stopDance=nil stopLead=nil stopBam=nil startBam=nil stopAnnoy=nil startAnnoy=nil stopFling=nil startFling=nil startFollow=nil stopFollow=nil sendChat=nil handleCommand=nil teleportToHost=nil handleMath=nil
function setRotationOwner(o)if rotationOwner==o then return end rotationOwner=o local h=hum()if not h then return end h.AutoRotate=(o=="Humanoid")end
function releaseRotation()setRotationOwner("Humanoid")end
function flashNoclip(d)d=d or SNT local c=pl.Character if not c then return end local sv={}for _,p in ipairs(c:GetDescendants())do if p:IsA("BasePart")then sv[p]=p.CanCollide pcall(function()p.CanCollide=false end)end end local cn=R.Stepped:Connect(function()local cc=pl.Character if not cc then return end for _,p in ipairs(cc:GetDescendants())do if p:IsA("BasePart")then pcall(function()p.CanCollide=false end)end end end)task.delay(d,function()if cn then cn:Disconnect()end for p,o in pairs(sv)do if p.Parent then pcall(function()p.CanCollide=o end)end end end)end
sendChat=function(t)if not t or t==""then return end if botLogRef and botLogRef.holder and pushLog then pushLog(botLogRef,t,C.text)else table.insert(botLogBuffer,t)end if ROLE=="HOST"then return end if antiBan.detected then return end pcall(function()if TC and TC.ChatVersion==Enum.ChatVersion.TextChatService then local ch=TC:FindFirstChild("TextChannels")if ch then local g=ch:FindFirstChild("RBXGeneral")or ch:FindFirstChild("RBGGeneral")or ch:FindFirstChildWhichIsA("TextChannel")if g then g:SendAsync(t)return end end end local ev=RS:FindFirstChild("DefaultChatSystemChatEvents")if ev then local sr=ev:FindFirstChild("SayMessageRequest")if sr then sr:FireServer(t,"All")end end end)end
function sendSeq(l,d)d=d or 0.8 task.spawn(function()for _,m in ipairs(l)do sendChat(m)task.wait(d)end end)end
function isDuplicateMessage(uid,t)local n=os.clock()local k=tostring(uid).."|"..t if S.recentMsgs[k]and(n-S.recentMsgs[k])<DW then return true end S.recentMsgs[k]=n if math.random()<0.1 then for k,v in pairs(S.recentMsgs)do if n-v>3 then S.recentMsgs[k]=nil end end end return false end
handleMath=function(e)if not e or e==""then sendChat(pick({"math: !math <a><op><b>","usage: !math 1+1","bro give me numbers"}))return end local s=e:gsub("%s+",""):gsub("÷","/"):gsub("×","*"):gsub("−","-"):gsub("[xX]","*"):gsub(":","/")local a,op,b=s:match("^([%-%d%.]+)([%+%-%*/%%%^])([%-%d%.]+)$")if not a then sendChat(pick({"bad expression","thats not math","cmon try again"}))return end local x=tonumber(a)local y=tonumber(b)if not x or not y then sendChat("math error")return end local r if op=="+"then r=x+y elseif op=="-"then r=x-y elseif op=="*"then r=x*y elseif op=="/"then if y==0 then sendChat("cant divide by zero")return end r=x/y elseif op=="%"then if y==0 then sendChat("cant mod by zero")return end r=x%y elseif op=="^"then r=x^y else sendChat("unsupported op")return end local rs if r==math.floor(r)and math.abs(r)<1e15 then rs=tostring(math.floor(r))else rs=string.format("%.6f",r):gsub("0+$",""):gsub("%.$","")end sendChat(tostring(x).." "..op.." "..tostring(y).." = "..rs)end
function aiGetRequestFunc()local r=nil if type(request)=="function"then r=request end if not r and syn and type(syn.request)=="function"then r=syn.request end if not r and http and type(http.request)=="function"then r=http.request end if not r and type(http_request)=="function"then r=http_request end if not r and fluxus and type(fluxus.request)=="function"then r=fluxus.request end if not r and krnl and type(krnl.request)=="function"then r=krnl.request end if not r and kavo and type(kavo.request)=="function"then r=kavo.request end return r end
function getResetCountdown()local n=os.time()local po=-8*3600 local pn=n+po local pt=os.date("!*t",pn)local sd=pt.hour*3600+pt.min*60+pt.sec local sr=86400-sd local h=math.floor(sr/3600)local m=math.floor((sr%3600)/60)return h,m end
function sendAIRequest(u,mt,us,_key)
_key=_key or APIKey
if not _key or _key==""then return nil,"nokey","no key"end
local rf=aiGetRequestFunc()if not rf then return nil,"nohttp","no request func"end
local tr={CHAT_CONVERSATION[1]}local hl=#CHAT_CONVERSATION-1 local si=2 if hl>MCH then si=#CHAT_CONVERSATION-MCH+1 end for i=si,#CHAT_CONVERSATION do tr[#tr+1]=CHAT_CONVERSATION[i]end tr[#tr+1]={role="user",content=u}local st=nil local co={}for _,m in ipairs(tr)do if m.role=="system"then st=(st and(st.."\n")or"")..tostring(m.content)elseif m.role=="user"then co[#co+1]={role="user",parts={{text=tostring(m.content)}}}elseif m.role=="assistant"then co[#co+1]={role="model",parts={{text=tostring(m.content)}}}end end if st and #co>0 and co[1].role=="user"then co[1].parts[1].text=st.."\n\n"..co[1].parts[1].text elseif st then table.insert(co,1,{role="user",parts={{text=st}}})end local gc={maxOutputTokens=mt or 150,temperature=us and 1.0 or 0.9}local pl_={contents=co,generationConfig=gc}if us then pl_.tools={{googleSearch={}}}end local ok,en=pcall(function()return H:JSONEncode(pl_)end)if not ok or not en then return nil,"json","encode failed"end local uw=BGE..AMI..":generateContent"local ok,rsp=pcall(rf,{Url=uw,Method="POST",Headers={["Content-Type"]="application/json",["x-goog-api-key"]=tostring(_key)},Body=en})if not ok then return nil,"http",tostring(rsp):sub(1,120)end if not rsp then return nil,"http","no response"end local rb=rsp.Body or rsp.body if rb==nil then rb=rsp end if type(rb)~="string"then local ok2,s=pcall(function()return H:JSONEncode(rb)end)rb=ok2 and s or tostring(rb)end if rb==""then local cd=rsp.StatusCode or rsp.Status or "?"return nil,"http","empty body HTTP "..tostring(cd)end local dk,data=pcall(function()return H:JSONDecode(rb)end)if not dk or not data then return nil,"json",rb:sub(1,80)end local em=nil if data.error then local m=data.error.message or data.error if type(m)~="string"then m=H:JSONEncode(m)end em=tostring(m)end if em then local lw=em:lower()if lw:find("quota")or lw:find("exceeded")or lw:find("rate limit")or lw:find("429")then if _key==APIKey and APIKey3 and APIKey3~=""and APIKey3~=_key then return sendAIRequest(u,mt,us,APIKey3)end return nil,"quota",em:sub(1,90)end if lw:find("high demand")or lw:find("overload")or lw:find("503")or lw:find("unavailable")or lw:find("temporarily")then return nil,"busy",em:sub(1,90)end if lw:find("not found")or lw:find("does not exist")or lw:find("404")then return nil,"invalid_model","model unavailable"end if lw:find("tool")or lw:find("google")or lw:find("grounding")then return nil,"tools_unsupported",em:sub(1,150)end return nil,"api",em:sub(1,90)end if not data.candidates or #data.candidates==0 then if data.promptFeedback and data.promptFeedback.blockReason then return nil,"blocked","blocked"end return nil,"nochoices","no candidates"end local cd=data.candidates[1]if not cd.content or not cd.content.parts or #cd.content.parts==0 then return nil,"nomsg","no parts"end local tx=nil for _,p in ipairs(cd.content.parts)do if p.text and p.text~=""then tx=p.text break end end if not tx or tx==""then return nil,"nomsg","empty text"end pcall(function()if data.usageMetadata and TU then local um=data.usageMetadata TU.prompt=(TU.prompt or 0)+(um.promptTokenCount or 0)TU.candidates=(TU.candidates or 0)+(um.candidatesTokenCount or 0)TU.total=(TU.total or 0)+(um.totalTokenCount or 0)TU.requests=(TU.requests or 0)+1 end end)return tx,nil,nil end
function sendAIRequest2(u,mt,us,_key)
_key=_key or APIKey2
if not _key or _key==""then return nil,"nokey","no key"end
local rf=aiGetRequestFunc()if not rf then return nil,"nohttp","no request func"end
local tr={CHAT_CONVERSATION2[1]}local hl=#CHAT_CONVERSATION2-1 local si=2 if hl>6 then si=#CHAT_CONVERSATION2-6+1 end for i=si,#CHAT_CONVERSATION2 do tr[#tr+1]=CHAT_CONVERSATION2[i]end tr[#tr+1]={role="user",content=u}local st=nil local co={}for _,m in ipairs(tr)do if m.role=="system"then st=(st and(st.."\n")or"")..tostring(m.content)elseif m.role=="user"then co[#co+1]={role="user",parts={{text=tostring(m.content)}}}elseif m.role=="assistant"then co[#co+1]={role="model",parts={{text=tostring(m.content)}}}end end if st and #co>0 and co[1].role=="user"then co[1].parts[1].text=st.."\n\n"..co[1].parts[1].text elseif st then table.insert(co,1,{role="user",parts={{text=st}}})end local pl_={contents=co,generationConfig={maxOutputTokens=mt or 3500,temperature=0.25}}local ok,en=pcall(function()return H:JSONEncode(pl_)end)if not ok or not en then return nil,"json","encode failed"end local uw=BGE..AMI..":generateContent"local ok,rsp=pcall(rf,{Url=uw,Method="POST",Headers={["Content-Type"]="application/json",["x-goog-api-key"]=tostring(_key)},Body=en})if not ok then return nil,"http",tostring(rsp):sub(1,120)end if not rsp then return nil,"http","no response"end local rb=rsp.Body or rsp.body if rb==nil then rb=rsp end if type(rb)~="string"then local ok2,s=pcall(function()return H:JSONEncode(rb)end)rb=ok2 and s or tostring(rb)end if rb==""then local cd=rsp.StatusCode or rsp.Status or "?"return nil,"http","empty body HTTP "..tostring(cd)end local dk,data=pcall(function()return H:JSONDecode(rb)end)if not dk or not data then return nil,"json",rb:sub(1,80)end local em=nil if data.error then local m=data.error.message or data.error if type(m)~="string"then m=H:JSONEncode(m)end em=tostring(m)end if em then local lw=em:lower()if lw:find("quota")or lw:find("exceeded")or lw:find("rate limit")or lw:find("429")then if _key==APIKey2 and APIKey4 and APIKey4~=""and APIKey4~=_key then return sendAIRequest2(u,mt,us,APIKey4)end return nil,"quota",em:sub(1,90)end if lw:find("high demand")or lw:find("overload")or lw:find("503")or lw:find("unavailable")or lw:find("temporarily")then return nil,"busy",em:sub(1,90)end if lw:find("not found")or lw:find("404")then return nil,"invalid_model","model unavailable"end return nil,"api",em:sub(1,90)end if not data.candidates or #data.candidates==0 then if data.promptFeedback and data.promptFeedback.blockReason then return nil,"blocked","blocked"end return nil,"nochoices","no candidates"end local cd=data.candidates[1]if not cd.content or not cd.content.parts or #cd.content.parts==0 then return nil,"nomsg","no parts"end local tx=nil for _,p in ipairs(cd.content.parts)do if p.text and p.text~=""then tx=p.text break end end if not tx or tx==""then return nil,"nomsg","empty text"end return tx,nil,nil end
function aiChunkSend(t)if not t then return end t=t:gsub("%s+"," "):gsub("^%s+",""):gsub("%s+$","")if t==""then t="hm"end local MX=180 if #t<=MX then sendChat(t)return end local cs={}local w=t while #w>MX do local cut=w:sub(1,MX):find("%s[^%s]*$")if not cut then cut=MX end table.insert(cs,w:sub(1,cut))w=w:sub(cut+1):gsub("^%s+","")end if #w>0 then table.insert(cs,w)end task.spawn(function()for i,c in ipairs(cs)do sendChat(c)if i<#cs then task.wait(0.35)end end end)end
function extractCodeBlock(text)if not text then return nil end local code=text:match("```lua%s*(.-)%s*```")if not code then code=text:match("```%s*(.-)%s*```")end if not code then if text:find("game%.")or text:find("Instance%.new")or text:find("LocalPlayer")then code=text end end if code then code=code:gsub("^%s+",""):gsub("%s+$","")end return code end
function generateCode(req,extraPrompt)
    local prompt="Request: "..req
    if extraPrompt then prompt=prompt.."\n\n"..extraPrompt end
    prompt=prompt.."\n\nGive me working executor code only. Wrap in ```lua```."
    return sendAIRequest2(prompt,3500,false)
end
function runTrackedCode(code,desc,id_override)
    return trackScript(code,desc)
end
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
    -- Version B: auto-replace existing overlapping script
    local oldId=hasOverlappingScript(req)
    if oldId then
        stopScript(oldId)
        pushLog(botLogRef,"[xcode] stopped old #"..oldId,C.subText)
    end
    task.spawn(function()
        local reply,et,em=generateCode(req)
        if not reply then
            local why="coder offline"
            if et=="quota"then why="coder out of fuel"
            elseif et=="busy"then why="coder busy"
            elseif et=="nohttp"then why="no http in executor"
            elseif em then why=tostring(em):sub(1,70)end
            pushLog(botLogRef,"[xcode] "..why,C.red)
            return
        end
        local code=extractCodeBlock(reply)
        if not code or code==""then
            pushLog(botLogRef,"[xcode] nothing usable, try again",C.red)
            return
        end
        local ok,err,id=trackScript(code,req)
        if not id then
            pushLog(botLogRef,"[xcode] "..tostring(err):sub(1,100),C.red)
            return
        end
        if ok then
            pushLog(botLogRef,"[xcode] #"..id.." "..req:sub(1,40).." - live",C.green)
        else
            pushLog(botLogRef,"[xcode] #"..id.." error: "..tostring(err):sub(1,80),C.red)
            -- Version: auto-fix on error
            task.spawn(function()
                task.wait(1.2)
                pushLog(botLogRef,"[xcode] #"..id.." auto-fixing...",C.subText)
                local fixPrompt="My code failed with this error: "..tostring(err):sub(1,200).."\n\nOriginal request was: "..req.."\n\nFix the code. Reply with ```lua code only. Do NOT repeat the same mistake."
                local fixReply,_,_=sendAIRequest2(fixPrompt,3500,false)
                if fixReply then
                    local fixCode=extractCodeBlock(fixReply)
                    if fixCode and fixCode~=""then
                        stopScript(id)
                        local ok2,err2,id2=trackScript(fixCode,req.." (fixed)")
                        if id2 then
                            if ok2 then
                                pushLog(botLogRef,"[xcode] #"..id2.." fixed & live",C.green)
                            else
                                pushLog(botLogRef,"[xcode] #"..id2.." still failing: "..tostring(err2):sub(1,60),C.red)
                            end
                        end
                    end
                end
            end)
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
function handleAIChat(u)if not u or u==""then return end if not APIKey or APIKey==""then sendChat("no api key set")return end local n=tick()if n-LRT<RCL then local wt=math.ceil(RCL-(n-LRT))sendChat(pick({"chill wait "..wt.."s","hold on "..wt.."s","wait up "..wt.."s"}))return end LRT=n local us=needsSearch(u)local mt=us and 300 or 150 task.spawn(function()local rp,et,em=sendAIRequest(u,mt,us)if not rp and us and et=="tools_unsupported"then rp,et,em=sendAIRequest(u,mt,false)end if not rp then if botLogRef and botLogRef.holder and pushLog then pushLog(botLogRef,"[xch] failed: "..tostring(et),C.red)if em then pushLog(botLogRef,"[xch] "..tostring(em):sub(1,90),C.red)end end if et=="busy"then sendChat(pick({"im busy rn","hold up","one sec"}))elseif et=="quota"then local h,m=getResetCountdown()sendChat("out of fuel, back in "..h.."h "..m.."m")elseif et=="blocked"then sendChat(pick({"got blocked","cant answer that one","nope try again"}))elseif et=="invalid_model"then sendChat("model down rn")else sendChat(pick({"something went wrong","try again","rip"}))end return end CHAT_CONVERSATION[#CHAT_CONVERSATION+1]={role="user",content=u}CHAT_CONVERSATION[#CHAT_CONVERSATION+1]={role="assistant",content=rp}while #CHAT_CONVERSATION>MCH+1 do table.remove(CHAT_CONVERSATION,2)end rp=trim(rp)if checkStopReq(rp)then return end if checkCodeReq(rp,true)then return end if rp~=""then aiChunkSend(rp)end end)end
privateChatRef={holder=nil,scroll=nil,empty=nil,scrollTween=nil}
function scrollToBottomRef(cref)local sf=cref.scroll if not sf then return end task.spawn(function()R.Heartbeat:Wait()R.Heartbeat:Wait()local function go(f)local ty=math.max(0,sf.AbsoluteCanvasSize.Y-sf.AbsoluteWindowSize.Y)if not f and math.abs(ty-sf.CanvasPosition.Y)<2 then return end if cref.scrollTween then pcall(function()cref.scrollTween:Cancel()end)cref.scrollTween=nil end local tn=T:Create(sf,TweenInfo.new(0.35,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),{CanvasPosition=Vector2.new(0,ty)})cref.scrollTween=tn tn:Play()end go(true)task.wait(0.15)go(false)task.wait(0.25)go(false)end)end
function sendToChatRef(cref,sd,t)if not cref.holder then return end if cref.empty then cref.empty.Visible=false end if not t or t==""then t="..."end local isMe=(sd=="me")local rw=Instance.new("Frame")rw.Size=UDim2.new(1,0,0,0)rw.AutomaticSize=Enum.AutomaticSize.Y rw.BackgroundTransparency=1 rw.Parent=cref.holder local bb=Instance.new("Frame")bb.Size=UDim2.new(0,0,0,0)bb.AutomaticSize=Enum.AutomaticSize.XY bb.BackgroundColor3=isMe and C.meBubble or C.aiBubble bb.BackgroundTransparency=1 bb.BorderSizePixel=0 bb.Parent=rw corner(bb,12)local mw=250 local cn=Instance.new("UISizeConstraint")cn.MaxSize=Vector2.new(mw,math.huge)cn.Parent=bb local so=nil if not isMe then so=Instance.new("UIStroke")so.Color=C.border so.Thickness=1 so.Transparency=1 so.ApplyStrokeMode=Enum.ApplyStrokeMode.Border so.Parent=bb end local pd=Instance.new("UIPadding")pd.PaddingTop=UDim.new(0,7)pd.PaddingBottom=UDim.new(0,7)pd.PaddingLeft=UDim.new(0,12)pd.PaddingRight=UDim.new(0,12)pd.Parent=bb local tx=Instance.new("TextLabel")tx.Size=UDim2.new(0,0,0,0)tx.AutomaticSize=Enum.AutomaticSize.XY tx.BackgroundTransparency=1 tx.Font=Enum.Font.Code tx.Text=tostring(t)tx.TextColor3=C.text tx.TextSize=11 tx.TextWrapped=true tx.TextTransparency=1 tx.TextXAlignment=Enum.TextXAlignment.Left tx.TextYAlignment=Enum.TextYAlignment.Top tx.Parent=bb local tc=Instance.new("UISizeConstraint")tc.MaxSize=Vector2.new(mw-24,math.huge)tc.Parent=tx if not cref.holder:FindFirstChildOfClass("UIListLayout")then local lay=Instance.new("UIListLayout")lay.SortOrder=Enum.SortOrder.LayoutOrder lay.Padding=UDim.new(0,6)lay.Parent=cref.holder end local sp,ep if isMe then bb.AnchorPoint=Vector2.new(1,0)ep=UDim2.new(1,-24,0,0)sp=UDim2.new(1,-2,0,0)else bb.AnchorPoint=Vector2.new(0,0)ep=UDim2.new(0,0,0,0)sp=UDim2.new(0,-20,0,0)end bb.Position=sp T:Create(bb,TweenInfo.new(0.38,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),{Position=ep,BackgroundTransparency=0}):Play()T:Create(tx,TweenInfo.new(0.38,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),{TextTransparency=0}):Play()if so then T:Create(so,TweenInfo.new(0.38,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),{Transparency=0.3}):Play()end scrollToBottomRef(cref)end
function sendToPrivateChat(sd,t)return sendToChatRef(privateChatRef,sd,t)end
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
if now>S.swordKillRetreatUntil then S.swordKillRetreating=false
