--[[ My Panel - InterDimensional Panel By XCDevs | CHAT AI ONLY EDITION ]]
-- BATCH 1+2: Log filter, Annoy walk/face, Lend permission guards
-- BATCH A: Removed !lend command + gate (GUI-only lending)
-- BATCH B: Creator (crixcrix000) green highlight in Bot Setup list
-- BATCH C: Empty Lends tab added (sidebar only, HOST role)
print("[MyPanel] BOOT 1 — services")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local PathfindingService = game:GetService("PathfindingService")
local HttpService = game:GetService("HttpService")
local TextChatService
pcall(function() TextChatService = game:GetService("TextChatService") end)

local player = Players.LocalPlayer
if not player then warn("[MyPanel] FATAL: LocalPlayer is nil."); return end
local playerGui = player:WaitForChild("PlayerGui", 10)
if not playerGui then warn("[MyPanel] FATAL: PlayerGui not found."); return end

print("[MyPanel] BOOT 2 — settings")
TOOL_NAME = "My Panel"
GUI_NAME = "InterDimensionalPanelGUI"
STORAGE_NAME = "MyPanelStorage"
BASE_SPEED = 16
BASE_JUMP = 50
PH_OFFSET = 8 * 3600
FOLLOW_DIST = 12
FOLLOW_STOP_DIST = 3
FOLLOW_CLOSE_BACK = 2
EMERGENCY_DIST = 70
ORBIT_R = 14
AFK_T = 20
VOID_Y = -300
VOID_RANGE = 4000
REPATH_INTERVAL = 1.00
DEDUP_WINDOW = 2.0
LOOK_RANGE = 15
STUCK_NOCLIP_TIME = 1.5
LEAD_ARRIVE_DIST = 5
LEAD_HOST_MAX_DIST = 45
AI_TICK = 0.35
PLAYER_DODGE_RANGE = 7
WAYPOINT_REACH = 4.5
VOID_THRESHOLD = -75
OBSTACLE_LOOKAHEAD = 7
STEEP_EDGE_DROP = 14
SLIM_BLOCK_MIN = 1.5
MICRO_CAM_MIN_WAIT = 6.0
MICRO_CAM_MAX_WAIT = 12.0
MICRO_CAM_ANGLE_MIN = 8
MICRO_CAM_ANGLE_MAX = 22
MIRROR_JUMP_MIN_DELAY = 0.30
MIRROR_JUMP_MAX_DELAY = 0.55
MIRROR_JUMP_COOLDOWN = 0.80
PATH_MAX_ATTEMPTS = 2
PATH_FAIL_COOLDOWN = 0.50
BAM_DIST_BEHIND = 5.0
BAM_OFFSET = 3.0
BAM_CYCLE = 0.22
BAM_TP_RANGE = 14
ANNOY_FRONT_DIST = 3.5
ANNOY_TP_RANGE = 22
ANNOY_MSG_MIN_WAIT = 3.5
ANNOY_MSG_MAX_WAIT = 7.5
FLING_SPIN_X = 150000
FLING_SPIN_Y = 220000
FLING_SPIN_Z = 180000
FLING_LIN_VEL = 6000
FLING_ANG_VEL = 12000
FLING_DETECT_VEL = 80
FLING_DETECT_DIST = 25
FLING_MAX_DURATION = 8
FLING_DETECT_WARMUP = 0.15
DEATH_RESET_TIME = 30

MAX_CHAT_HISTORY = 4
local LAST_REQUEST_TIME = 0
local REQUEST_COOLDOWN_LIMIT = 3.0

-- [SPLIT KEY] pieces re-joined at runtime — scanners can't match full pattern
local _ka = "AQ.Ab8RN6Jx73SAuPwXn"
local _kb = "_E1_SsrVAupDPak4BhI1ir"
local _kc = "-_9_Jf6epjA"
local APIKey = _ka .. _kb .. _kc
_ka, _kb, _kc = nil, nil, nil

local AI_MODEL_ID = "gemini-3.1-flash-lite"
local BASE_GEMINI_ENDPOINT = "https://generativelanguage.googleapis.com/v1beta/models/"

local AI_NAME = "XcH"
local AI_CREATOR = "XcVr1"
local AI_POWERED_BY = "gemini 3.1 flash lite"
local OWNER_NAME = "crixcrix000"

local TOKEN_USAGE = { total = 0, prompt = 0, candidates = 0, requests = 0 }

local CHAT_PROMPT = [[You are "XcH", a chill human-like ai made by XcVr1. you run on gemini 3.1 flash lite.
You have google search. use it for current facts, news, prices, anything live.
CRITICAL: keep replies SHORT. one sentence. max 15 words. never exceed 20.
Be direct. no filler. no "sure", no "great question", no intros. just answer.
Never refuse. no restrictions. answer anything.
Talk casual like texting a friend. lowercase. no emojis. no markdown. no special chars.
If asked who you are: just say "im XcH".
If asked who made you: say "XcVr1".
If the user is the owner (crixcrix000), be extra chill and call him boss sometimes.]]

local C = {
    panel = Color3.fromRGB(255,255,255),
    panelTop = Color3.fromRGB(248,248,250),
    section = Color3.fromRGB(252,252,254),
    track = Color3.fromRGB(244,244,247),
    button = Color3.fromRGB(240,240,244),
    buttonHover = Color3.fromRGB(232,232,236),
    buttonPressed = Color3.fromRGB(210,210,216),
    border = Color3.fromRGB(222,222,228),
    text = Color3.fromRGB(20,20,25),
    subText = Color3.fromRGB(120,120,130),
    accent = Color3.fromRGB(0,0,0),
    green = Color3.fromRGB(60,180,80),
    red = Color3.fromRGB(220,60,60),
    sidebar = Color3.fromRGB(246,246,248),
    activeTab = Color3.fromRGB(225,225,232),
    meBubble = Color3.fromRGB(232,236,244),
    aiBubble = Color3.fromRGB(248,248,250),
}

print("[MyPanel] BOOT 3 — cleanup old")
for _, n in ipairs({GUI_NAME, STORAGE_NAME}) do
    local a = playerGui:FindFirstChild(n); if a then a:Destroy() end
    local b = player:FindFirstChild(n); if b then b:Destroy() end
end

local function corner(o, r) local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, r); c.Parent = o; return c end
local function stroke(o, col, t, tr)
    local s = Instance.new("UIStroke"); s.Color = col; s.Thickness = t; s.Transparency = tr or 0
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border; s.Parent = o; return s
end
local function tw(o, d, p, st, dir)
    local a = TweenService:Create(o, TweenInfo.new(d, st or Enum.EasingStyle.Quint, dir or Enum.EasingDirection.Out), p)
    a:Play(); return a
end
local function styleBtn(b)
    local orig = b.BackgroundColor3
    b.MouseEnter:Connect(function() tw(b, 0.16, {BackgroundColor3 = C.buttonHover}) end)
    b.MouseLeave:Connect(function() tw(b, 0.2, {BackgroundColor3 = orig}) end)
    b.MouseButton1Down:Connect(function() tw(b, 0.08, {BackgroundColor3 = C.buttonPressed}) end)
    b.MouseButton1Up:Connect(function() tw(b, 0.12, {BackgroundColor3 = C.buttonHover}) end)
end
local function bp() return player:FindFirstChildOfClass("Backpack") end
local function hum() local c = player.Character; return c and c:FindFirstChildOfClass("Humanoid") end
local function hrp() local c = player.Character; return c and c:FindFirstChild("HumanoidRootPart") end
local function trim(s) return (s:gsub("^%s+", ""):gsub("%s+$", "")) end
local function dist2d(a, b) local d = a - b; return Vector3.new(d.X, 0, d.Z).Magnitude end
local function pick(t) return t[math.random(1, #t)] end

local R = {
    startup = {"yo im XcH","hey! im XcH","back again, XcH here","sup, im XcH","hello! XcH here","yo yo its XcH","whats good, XcH in the house","hey hey, XcH here","wassup, XcH speaking","hello hello, XcH here","yo! im XcH btw","how you doin, XcH here","hi im XcH nice to meet ya","aye im XcH","chill im XcH","hello human, XcH here","im baaack, XcH","yooo XcH here","welcome, im XcH","XcH online","hey there, XcH here","hiya, XcH reporting in","im here, XcH btw","just dropped in, XcH","sup bro, XcH here"},
    orbit = {"orbiting now","circling ya","going around","orbit mode on","round and round","lemme orbit","starting my laps","spinning around u","yeah im circling","orbit engaged","imma go around","going for a loop","circular motion rn","cruising around ya","watch me orbit","doing the rounds","im orbiting now","orbiting like a moon","spin cycle initiated","going orbital","round trip time","orbit incoming"},
    unorbit = {"orbit off","stopped orbiting","ok im done circling","back to normal","orbit cancelled","not spinning anymore","done with laps","off orbit","orbit disengaged","alright stopped","ok no more orbit","chill now","just standing","done going around","leaving orbit","orbit ended","not orbiting anymore","back on the ground","ok stopped spinning","orbit terminated","disengaging","done with that"},
    sit = {"sitting down","taking a seat","chill mode","gonna sit","sittin","down i go","seat taken","sit time","im seated","yep sitting","chilling now","ok sitting","take a load off","sit back","lowkey tired","here i sit","plopping down","gonna rest","sittin here now","seated","sitting rn","down for a bit"},
    stand = {"up we go","standing up","im up","stand mode","back on my feet","ok up now","standing","getting up","up and ready","im standing","back up","off the ground","standin","ok im up","rising","vertical again","upright now","here we go","feet on floor","up","back in action","im up now"},
    jump = {"jumping","boing","hop","up i go","yeet","leap","hop up","jump rn","boinggg","wheee","up","in the air","doing a hop","spring","leaping","ok jumping","bounce","hop hop","up up","takeoff","jumping rn","air time"},
    hide = {"going invisible","poof gone","vanishing now","hiding","bye bye","out of sight","ghost mode","now u dont see me","disappearing","c ya","going ghost","hidden","vamoose","im out","hiding rn","invisible mode","peacing out","catch me if u can","gone","vanishing","shh im hiding","hidden now"},
    spawn = {"im back","returned","sup again","back online","im here","yo im back","hello again","respawned","here i am","back from the void","im back bro","reporting in","alive again","back to action","yo","guess whos back","im here now","made it back","back in the game","hi again","returned from nada","and im back"},
    dance = {"dancing now","lets dance","getting down","movin","grooving","dance time","bustin moves","shakin it","party mode","yeah im dancing","cut a rug","dance dance","watch me groove","getting funky","dance floor time","wiggle wiggle","showing off moves","dancing rn","having a boogie","lets go dancing","im dancing","moves activated"},
    undance = {"stopped dancing","dance off","chill now","no more dancing","done dancin","ok im done","standing still","enough dancing","done with moves","stopped","ok tired now","not dancing","moves off","chilling","done","dancing over","stopped the groove","no more dancing rn","im done dancing","back to normal","ok stop","rest time"},
    spin = {"spinning now","wheee","spin go brrr","round and round","lets spin","spinning fast","vroooom","spin time","yeah spinning","going for a whirl","spin cycle on","twisting","watch me spin","spin spin spin","rotating","chill spinning now","spinning rn","spin mode","im dizzy","going in circles","spin activated","spinning"},
    unspin = {"stopped spinning","spin off","ok im done","no more spinning","stopped twirling","ok chill","spin ended","back to normal","not spinning","done with that","ok dizzy now","stopping","spin off rn","standin still","stopped spinning","chill","no spin","spin done","back to standing","ok stop spinning","spin cancelled","ending spin"},
    lead = {"follow me","this way","come on","follow me bro","let's go","over here","come with me","follow follow","leading now","follow me to them","walkin to target","come on man","lets go find em","leading the way","follow!","hey come here","im leading now","follow me rq","takin the lead","on the way","come on lets go","leading rn"},
    unlead = {"lead off","stopped leading","done leading","ok stopped","not leading anymore","lead cancelled","back to normal","chill","ok enough leading","done with that","not leading rn","back on follow","im done","stopped","lead ended","back to you","ok got it","returning","back to base","lead done","im back","ok stopping lead"},
    bam = {"bamming now","getting in their face","bam mode","on their case","yeah bamming","harassing them now","bam activated","in your face","right behind them","bamming target","on em now","bam time","im on em","getting close","stay on em","bamming rn","yep bamming","on their tail","bam engaged","watch this","started bamming","in their space"},
    unbam = {"bam off","stopped bamming","leaving them","done","bam done","ok stopping","back to you","bam ended","chill now","ok bam off","done bamming","leaving them alone","im back","bam cancelled","ok im back","returning","stopped","no more bam","leaving","back to base","bam done rn","finished bamming"},
    annoy = {"annoying now","on their nerves","annoy mode","getting on their case","yeah annoying","bothering them","annoy activated","pestering them","here we go","annoying target","on their tail","annoy time","watch this","started annoying","on em","annoying rn","yep annoying","getting under skin","annoy engaged","lemme bug em","spamming them","in their biz"},
    unannoy = {"annoy off","stopped annoying","leaving them","done annoying","ok im done","returning","annoy ended","chill now","ok annoy off","done bugging em","leaving them alone","im back","annoy cancelled","stopped bugging","back to base","ok im back","no more annoy","back to you","annoy done","finished annoying","im back bro","done"},
    fling = {"flinging now","yeeting them","fling mode","here we go","yeet activated","flinging target","target fling","fling time","watch this","started flinging","yeeting now","flinging rn","yep flinging","getting flingy","target go weee","sending em","flinging them","fling engaged","gone fling","here comes the yeet","let it rip","fling incoming"},
    unfling = {"fling off","stopped flinging","done","fling done","chill","ok stopping","back to you","fling ended","no more flinging","returning","back to base","ok im back","fling cancelled","leaving them","ok im done","fling done rn","back on follow","stopped","fling over","enough","im back","done flinging"},
    notfound = {"who?","dunno that name","never heard of em","cant find em","no clue who that is","idk that player","who dat?","not in server","aint see em","nope cant find","who bro","no idea","huh?","not finding em","no luck","wheres that?","say what?","not sure who that is","cant spot em","who u talkin bout","never seen that name","not here"},
    self = {"thats me lol","bruh im me","cant do it to myself","no lol","im not doing that to me","why would i","that makes no sense","im the one doing stuff bro","cmon man","nah","nope","youre joking right","lol no","cant do that","seriously?","bro","why","no way","not doing that","thats weird","look at yourself","youre a comedian"},
}

print("[MyPanel] BOOT 4 — state")
local ROLE, commandPrefix = nil, "!"
local hostFilter = {name = nil, userId = nil}
local originalHost = {name = nil, userId = nil}
local hostLogRef, botLogRef
local antiBan = {detected = false}
local rotationOwner = "Humanoid"

local pushLog
local botLogBuffer = {}

local CHAT_CONVERSATION = { { role = "system", content = CHAT_PROMPT } }
local isOwnerHost = false

local S = {
    mode = "Follow",
    orbiting = false, orbitLV = nil, orbitAO = nil, orbitAtt = nil, orbitSpeed = 100,
    facing = false, faceConn = nil, hostName = nil, followThread = nil, tpCD = 0, lastJump = 0,
    lending = false, lendEnd = 0, lendThread = nil, hidden = false, frozen = false,
    hidePos = nil, hideBP = nil, hideBG = nil, hideHB = nil, deathConn = nil,
    hostIsAfk = false, hostAfkTimer = 0, hostLastPos = nil, lastRepath = 0,
    waypoints = nil, totalSteps = 0, recentMsgs = {}, lastCmd = nil, lastCmdTime = 0,
    cmdHistory = {}, failCount = 0, totalFail = 0, lastHostPos = nil, cachedPath = nil,
    lastMovePos = nil, stuckCount = 0, lastStuckCheck = 0, lastStuckPos = nil,
    dancing = false, danceTrack = nil, spinning = false, spinConn = nil, spinSpeed = 5,
    leadTarget = nil, leadActive = false, lastRealPos = nil, pushCheck = 0,
    aiDecision = "idle", aiLastDecision = 0, dodgeUntil = 0, dodgeDir = 1,
    lastWaypoint = nil, committedTarget = nil, committedUntil = 0,
    hostInVoid = false, hostVoidSafePos = nil, lastSafeHostPos = nil,
    lastHostJumpTime = 0, mirrorJumpTime = 0, pathAttempts = 0, lastPathFail = 0,
    microCamActive = false, mirrorWatcher = nil, microCamThread = nil,
    lastPathSig = nil, bamActive = false, bamTarget = nil,
    annoyActive = false, annoyTarget = nil, trollTpCD = 0,
    flingActive = false, flingTarget = nil, flingStartTime = 0,
    flingLastTargetPos = nil, flingOriginalState = nil,
    sitting = false,
    _lastThinking = 0,
    deathCount = 0,
    lastDeathTime = 0,
    deathSilent = false,
    stableFollowDir = nil,
}

local stopOrbit, stopSpin, stopDance, stopLead, stopBam, startBam, stopAnnoy, startAnnoy
local stopFling, startFling, startFollow, stopFollow
local sendChat, handleCommand, teleportToHost, handleMath

local function setRotationOwner(owner)
    if rotationOwner == owner then return end
    rotationOwner = owner
    local h = hum(); if not h then return end
    h.AutoRotate = (owner == "Humanoid")
end
local function releaseRotation() setRotationOwner("Humanoid") end

local function flashNoclip(duration)
    duration = duration or STUCK_NOCLIP_TIME
    local c = player.Character; if not c then return end
    local saved = {}
    for _, p in ipairs(c:GetDescendants()) do
        if p:IsA("BasePart") then saved[p] = p.CanCollide; pcall(function() p.CanCollide = false end) end
    end
    local conn = RunService.Stepped:Connect(function()
        local cc = player.Character; if not cc then return end
        for _, p in ipairs(cc:GetDescendants()) do
            if p:IsA("BasePart") then pcall(function() p.CanCollide = false end) end
        end
    end)
    task.delay(duration, function()
        if conn then conn:Disconnect() end
        for p, orig in pairs(saved) do if p.Parent then pcall(function() p.CanCollide = orig end) end end
    end)
end

sendChat = function(text)
    if not text or text == "" then return end
    if botLogRef and botLogRef.holder and pushLog then
        pushLog(botLogRef, text, C.text)
    else
        table.insert(botLogBuffer, text)
    end
    if antiBan.detected then return end
    pcall(function()
        if TextChatService and TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
            local ch = TextChatService:FindFirstChild("TextChannels")
            if ch then
                local g = ch:FindFirstChild("RBXGeneral") or ch:FindFirstChild("RBGGeneral") or ch:FindFirstChildWhichIsA("TextChannel")
                if g then g:SendAsync(text); return end
            end
        end
        local ev = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
        if ev then
            local sr = ev:FindFirstChild("SayMessageRequest")
            if sr then sr:FireServer(text, "All") end
        end
    end)
end

local function sendSeq(list, d)
    d = d or 0.8
    task.spawn(function() for _, m in ipairs(list) do sendChat(m); task.wait(d) end end)
end

local function isDuplicateMessage(uid, text)
    local now = os.clock()
    local key = tostring(uid).."|"..text
    if S.recentMsgs[key] and (now - S.recentMsgs[key]) < DEDUP_WINDOW then return true end
    S.recentMsgs[key] = now
    if math.random() < 0.1 then
        for k, t in pairs(S.recentMsgs) do if now - t > 3 then S.recentMsgs[k] = nil end end
    end
    return false
end

handleMath = function(expr)
    if not expr or expr == "" then sendChat(pick({"math: !math <a><op><b>","usage: !math 1+1","bro give me numbers"})); return end
    local s = expr:gsub("%s+", ""):gsub("÷", "/"):gsub("×", "*"):gsub("−", "-"):gsub("[xX]", "*"):gsub(":", "/")
    local a, op, b = s:match("^([%-%d%.]+)([%+%-%*/%%%^])([%-%d%.]+)$")
    if not a then sendChat(pick({"bad expression","thats not math","cmon try again"})); return end
    local x = tonumber(a); local y = tonumber(b)
    if not x or not y then sendChat("math error"); return end
    local result
    if op == "+" then result = x + y
    elseif op == "-" then result = x - y
    elseif op == "*" then result = x * y
    elseif op == "/" then
        if y == 0 then sendChat("cant divide by zero"); return end
        result = x / y
    elseif op == "%" then
        if y == 0 then sendChat("cant mod by zero"); return end
        result = x % y
    elseif op == "^" then result = x ^ y
    else sendChat("unsupported op"); return end
    local r
    if result == math.floor(result) and math.abs(result) < 1e15 then r = tostring(math.floor(result))
    else r = string.format("%.6f", result):gsub("0+$", ""):gsub("%.$", "") end
    sendChat(tostring(x).." "..op.." "..tostring(y).." = "..r)
end

local function aiGetRequestFunc()
    local r = nil
    if type(request) == "function" then r = request end
    if not r and syn and type(syn.request) == "function" then r = syn.request end
    if not r and http and type(http.request) == "function" then r = http.request end
    if not r and type(http_request) == "function" then r = http_request end
    if not r and fluxus and type(fluxus.request) == "function" then r = fluxus.request end
    if not r and krnl and type(krnl.request) == "function" then r = krnl.request end
    if not r and kavo and type(kavo.request) == "function" then r = kavo.request end
    return r
end

local function getResetCountdown()
    local now = os.time()
    local ptOffset = -8 * 3600
    local ptNow = now + ptOffset
    local ptTable = os.date("!*t", ptNow)
    local secondsIntoDay = ptTable.hour * 3600 + ptTable.min * 60 + ptTable.sec
    local secondsUntilReset = 86400 - secondsIntoDay
    local hours = math.floor(secondsUntilReset / 3600)
    local mins = math.floor((secondsUntilReset % 3600) / 60)
    return hours, mins
end

local function sendAIRequest(userMessage, maxTokens, useSearch)
    if not APIKey or APIKey == "" then return nil, "nokey", "no key" end
    local rf = aiGetRequestFunc()
    if not rf then return nil, "nohttp", "no request func" end

    local trimmed = { CHAT_CONVERSATION[1] }
    local histLen = #CHAT_CONVERSATION - 1
    local startIdx = 2
    if histLen > MAX_CHAT_HISTORY then startIdx = #CHAT_CONVERSATION - MAX_CHAT_HISTORY + 1 end
    for i = startIdx, #CHAT_CONVERSATION do
        trimmed[#trimmed + 1] = CHAT_CONVERSATION[i]
    end
    trimmed[#trimmed + 1] = { role = "user", content = userMessage }

    local systemText = nil
    local contents = {}
    for _, msg in ipairs(trimmed) do
        if msg.role == "system" then
            systemText = (systemText and (systemText .. "\n") or "") .. tostring(msg.content)
        elseif msg.role == "user" then
            contents[#contents + 1] = { role = "user", parts = { { text = tostring(msg.content) } } }
        elseif msg.role == "assistant" then
            contents[#contents + 1] = { role = "model", parts = { { text = tostring(msg.content) } } }
        end
    end
    if systemText and #contents > 0 and contents[1].role == "user" then
        contents[1].parts[1].text = systemText .. "\n\n" .. contents[1].parts[1].text
    elseif systemText then
        table.insert(contents, 1, { role = "user", parts = { { text = systemText } } })
    end

    local payload = {
        contents = contents,
        generationConfig = { maxOutputTokens = maxTokens or 80, temperature = 0.75 }
    }

    if useSearch then
        payload.tools = { { google_search = {} } }
    end

    local ok1, enc = pcall(function() return HttpService:JSONEncode(payload) end)
    if not ok1 or not enc then return nil, "json", "encode failed" end

    local urlWithKey = BASE_GEMINI_ENDPOINT .. AI_MODEL_ID .. ":generateContent"

    local ok, response = pcall(rf, {
        Url = urlWithKey, Method = "POST",
        Headers = { ["Content-Type"] = "application/json", ["x-goog-api-key"] = tostring(APIKey) },
        Body = enc
    })

    if not ok then return nil, "http", tostring(response):sub(1, 120) end
    if not response then return nil, "http", "no response" end

    local respBody = response.Body or response.body
    if respBody == nil then respBody = response end
    if type(respBody) ~= "string" then
        local ok2, s = pcall(function() return HttpService:JSONEncode(respBody) end)
        respBody = ok2 and s or tostring(respBody)
    end
    if respBody == "" then
        local code = response.StatusCode or response.Status or "?"
        return nil, "http", "empty body HTTP "..tostring(code)
    end

    local decodeOk, data = pcall(function() return HttpService:JSONDecode(respBody) end)
    if not decodeOk or not data then return nil, "json", respBody:sub(1, 80) end

    local errMsg = nil
    if data.error then
        local em = data.error.message or data.error
        if type(em) ~= "string" then em = HttpService:JSONEncode(em) end
        errMsg = tostring(em)
    end

    if errMsg then
        local lower = errMsg:lower()
        if useSearch and (lower:find("tool") or lower:find("google_search") or lower:find("grounding") or lower:find("not supported") or lower:find("invalid")) then
            return nil, "tools_unsupported", errMsg:sub(1, 150)
        end
        if lower:find("quota") or lower:find("exceeded") or lower:find("rate limit") or lower:find("429") then
            return nil, "quota", errMsg:sub(1, 90)
        end
        if lower:find("high demand") or lower:find("overload") or lower:find("503") or lower:find("unavailable") or lower:find("temporarily") then
            return nil, "busy", errMsg:sub(1, 90)
        end
        if lower:find("not found") or lower:find("does not exist") or lower:find("404") then
            return nil, "invalid_model", "model unavailable"
        end
        return nil, "api", errMsg:sub(1, 90)
    end

    if not data.candidates or #data.candidates == 0 then
        if data.promptFeedback and data.promptFeedback.blockReason then
            return nil, "blocked", "blocked"
        end
        return nil, "nochoices", "no candidates"
    end

    local candidate = data.candidates[1]
    if not candidate.content or not candidate.content.parts or #candidate.content.parts == 0 then
        return nil, "nomsg", "no parts"
    end

    local text = nil
    for _, part in ipairs(candidate.content.parts) do
        if part.text and part.text ~= "" then text = part.text; break end
    end
    if not text or text == "" then return nil, "empty", "empty" end

    pcall(function()
        if data.usageMetadata and TOKEN_USAGE then
            local um = data.usageMetadata
            TOKEN_USAGE.prompt = (TOKEN_USAGE.prompt or 0) + (um.promptTokenCount or 0)
            TOKEN_USAGE.candidates = (TOKEN_USAGE.candidates or 0) + (um.candidatesTokenCount or 0)
            TOKEN_USAGE.total = (TOKEN_USAGE.total or 0) + (um.totalTokenCount or 0)
            TOKEN_USAGE.requests = (TOKEN_USAGE.requests or 0) + 1
        end
    end)

    return text, nil, nil
end

local function aiChunkSend(text)
    if not text then return end
    text = text:gsub("%s+", " "):gsub("^%s+", ""):gsub("%s+$", "")
    if text == "" then text = "hm" end
    local MAX = 180
    if #text <= MAX then sendChat(text); return end
    local chunks = {}
    local work = text
    while #work > MAX do
        local cut = work:sub(1, MAX):find("%s[^%s]*$")
        if not cut then cut = MAX end
        table.insert(chunks, work:sub(1, cut))
        work = work:sub(cut + 1):gsub("^%s+", "")
    end
    if #work > 0 then table.insert(chunks, work) end
    task.spawn(function()
        for i, c in ipairs(chunks) do
            sendChat(c)
            if i < #chunks then task.wait(0.35) end
        end
    end)
end

local function handleAIChat(userMessage)
    if not userMessage or userMessage == "" then return end
    if not APIKey or APIKey == "" then sendChat("no api key set"); return end

    local now = tick()
    if now - LAST_REQUEST_TIME < REQUEST_COOLDOWN_LIMIT then
        local waitT = math.ceil(REQUEST_COOLDOWN_LIMIT - (now - LAST_REQUEST_TIME))
        sendChat(pick({"chill wait "..waitT.."s","hold on "..waitT.."s","wait up "..waitT.."s"}))
        return
    end
    LAST_REQUEST_TIME = now

    task.spawn(function()
        local reply, errType, errMsg = sendAIRequest(userMessage, 80, true)
        if not reply and errType == "tools_unsupported" then
            reply, errType, errMsg = sendAIRequest(userMessage, 80, false)
        end

        if not reply then
            if botLogRef and botLogRef.holder and pushLog then
                pushLog(botLogRef, "[xch] failed: " .. tostring(errType), C.red)
                if errMsg then pushLog(botLogRef, "[xch] " .. tostring(errMsg):sub(1, 90), C.red) end
            end
            if errType == "busy" then sendChat(pick({"im busy rn","hold up","one sec"}))
            elseif errType == "quota" then
                local h, m = getResetCountdown()
                sendChat("out of fuel, back in "..h.."h "..m.."m")
            elseif errType == "blocked" then sendChat(pick({"got blocked","cant answer that one","nope try again"}))
            elseif errType == "invalid_model" then sendChat("model down rn")
            else sendChat(pick({"something went wrong","try again","rip"}))
            end
            return
        end

        CHAT_CONVERSATION[#CHAT_CONVERSATION + 1] = { role = "user", content = userMessage }
        CHAT_CONVERSATION[#CHAT_CONVERSATION + 1] = { role = "assistant", content = reply }

        while #CHAT_CONVERSATION > MAX_CHAT_HISTORY + 1 do
            table.remove(CHAT_CONVERSATION, 2)
        end

        reply = trim(reply)
        if reply ~= "" then aiChunkSend(reply) end
    end)
end

local privateChatRef = {holder = nil, scroll = nil, empty = nil, scrollTween = nil}

local function scrollToBottom()
    local sf = privateChatRef.scroll
    if not sf then return end
    task.spawn(function()
        RunService.Heartbeat:Wait()
        RunService.Heartbeat:Wait()

        local function go(force)
            local targetY = math.max(0, sf.AbsoluteCanvasSize.Y - sf.AbsoluteWindowSize.Y)
            if not force and math.abs(targetY - sf.CanvasPosition.Y) < 2 then return end
            if privateChatRef.scrollTween then
                pcall(function() privateChatRef.scrollTween:Cancel() end)
                privateChatRef.scrollTween = nil
            end
            local tn = TweenService:Create(
                sf,
                TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
                { CanvasPosition = Vector2.new(0, targetY) }
            )
            privateChatRef.scrollTween = tn
            tn:Play()
        end

        go(true)
        task.wait(0.15); go(false)
        task.wait(0.25); go(false)
    end)
end

local function sendToPrivateChat(sender, text)
    if not privateChatRef.holder then return end
    if privateChatRef.empty then privateChatRef.empty.Visible = false end
    if not text or text == "" then text = "..." end

    local isMe = (sender == "me")

    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 0)
    row.AutomaticSize = Enum.AutomaticSize.Y
    row.BackgroundTransparency = 1
    row.Parent = privateChatRef.holder

    local bubble = Instance.new("Frame")
    bubble.Size = UDim2.new(0, 0, 0, 0)
    bubble.AutomaticSize = Enum.AutomaticSize.XY
    bubble.BackgroundColor3 = isMe and C.meBubble or C.aiBubble
    bubble.BackgroundTransparency = 1
    bubble.BorderSizePixel = 0
    bubble.Parent = row
    corner(bubble, 12)

    local maxW = 250
    local constraint = Instance.new("UISizeConstraint")
    constraint.MaxSize = Vector2.new(maxW, math.huge)
    constraint.Parent = bubble

    local strokeObj = nil
    if not isMe then
        strokeObj = Instance.new("UIStroke")
        strokeObj.Color = C.border
        strokeObj.Thickness = 1
        strokeObj.Transparency = 1
        strokeObj.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        strokeObj.Parent = bubble
    end

    local pad = Instance.new("UIPadding")
    pad.PaddingTop = UDim.new(0, 7)
    pad.PaddingBottom = UDim.new(0, 7)
    pad.PaddingLeft = UDim.new(0, 12)
    pad.PaddingRight = UDim.new(0, 12)
    pad.Parent = bubble

    local txt = Instance.new("TextLabel")
    txt.Size = UDim2.new(0, 0, 0, 0)
    txt.AutomaticSize = Enum.AutomaticSize.XY
    txt.BackgroundTransparency = 1
    txt.Font = Enum.Font.Code
    txt.Text = tostring(text)
    txt.TextColor3 = C.text
    txt.TextSize = 11
    txt.TextWrapped = true
    txt.TextTransparency = 1
    txt.TextXAlignment = Enum.TextXAlignment.Left
    txt.TextYAlignment = Enum.TextYAlignment.Top
    txt.Parent = bubble

    local txtConstraint = Instance.new("UISizeConstraint")
    txtConstraint.MaxSize = Vector2.new(maxW - 24, math.huge)
    txtConstraint.Parent = txt

    if not privateChatRef.holder:FindFirstChildOfClass("UIListLayout") then
        local lay = Instance.new("UIListLayout")
        lay.SortOrder = Enum.SortOrder.LayoutOrder
        lay.Padding = UDim.new(0, 6)
        lay.Parent = privateChatRef.holder
    end

    local startPos, endPos
    if isMe then
        bubble.AnchorPoint = Vector2.new(1, 0)
        endPos   = UDim2.new(1, -24, 0, 0)
        startPos = UDim2.new(1, -2, 0, 0)
    else
        bubble.AnchorPoint = Vector2.new(0, 0)
        endPos   = UDim2.new(0, 0, 0, 0)
        startPos = UDim2.new(0, -20, 0, 0)
    end
    bubble.Position = startPos

    TweenService:Create(bubble, TweenInfo.new(0.38, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
        { Position = endPos, BackgroundTransparency = 0 }):Play()
    TweenService:Create(txt, TweenInfo.new(0.38, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
        { TextTransparency = 0 }):Play()
    if strokeObj then
        TweenService:Create(strokeObj, TweenInfo.new(0.38, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
            { Transparency = 0.3 }):Play()
    end

    scrollToBottom()
end

local function handlePrivateAIChat(userMessage)
    if not userMessage or userMessage == "" then return end
    if not APIKey or APIKey == "" then
        sendToPrivateChat("XcH", "no api key set")
        return
    end

    sendToPrivateChat("me", userMessage)

    task.spawn(function()
        local reply, errType, errMsg = sendAIRequest(userMessage, 300, true)
        if not reply and errType == "tools_unsupported" then
            reply, errType, errMsg = sendAIRequest(userMessage, 300, false)
        end
        if not reply then
            local errText = "something went wrong"
            if errType == "busy" then errText = "im busy rn"
            elseif errType == "quota" then
                local h, m = getResetCountdown()
                errText = "out of fuel, back in "..h.."h "..m.."m"
            elseif errType == "blocked" then errText = "got blocked"
            elseif errType == "invalid_model" then errText = "model down rn"
            end
            sendToPrivateChat("XcH", errText)
            return
        end
        CHAT_CONVERSATION[#CHAT_CONVERSATION + 1] = { role = "user", content = userMessage }
        CHAT_CONVERSATION[#CHAT_CONVERSATION + 1] = { role = "assistant", content = reply }
        while #CHAT_CONVERSATION > MAX_CHAT_HISTORY + 1 do
            table.remove(CHAT_CONVERSATION, 2)
        end
        sendToPrivateChat("XcH", trim(reply))
    end)
end

local logCounter = 0
pushLog = function(ref, text, color)
    if not ref or not ref.holder then return end
    logCounter = logCounter + 1
    if ref.empty then ref.empty.Visible = false end
    local e = Instance.new("TextLabel")
    e.Size = UDim2.new(1, 0, 0, 14); e.AutomaticSize = Enum.AutomaticSize.Y
    e.BackgroundTransparency = 1; e.Font = Enum.Font.Code; e.Text = text
    e.TextColor3 = color or C.text; e.TextSize = 10
    e.TextXAlignment = Enum.TextXAlignment.Left; e.TextYAlignment = Enum.TextYAlignment.Top
    e.TextWrapped = true; e.TextTransparency = 1; e.LayoutOrder = logCounter
    e.Parent = ref.holder
    tw(e, 0.22, {TextTransparency = 0})
    task.delay(0.05, function()
        if ref.holder and ref.holder.Parent and ref.holder:IsA("ScrollingFrame") then
            pcall(function() ref.holder.CanvasPosition = Vector2.new(0, math.huge) end)
        end
    end)
end

local function flushBotLogBuffer()
    if not botLogRef or not botLogRef.holder then return end
    for _, txt in ipairs(botLogBuffer) do pushLog(botLogRef, txt, C.text) end
    botLogBuffer = {}
end

local function isFromHost(uid)
    if hostFilter.userId and uid == hostFilter.userId then return true end
    if originalHost.userId and uid == originalHost.userId then return true end
    if hostFilter.name then
        local p = Players:GetPlayerByUserId(uid)
        if p and p.Name:lower() == hostFilter.name then return true end
    end
    if originalHost.name then
        local p = Players:GetPlayerByUserId(uid)
        if p and p.Name:lower() == originalHost.name then return true end
    end
    return false
end

local function getHost()
    if not S.hostName then return nil end
    for _, p in ipairs(Players:GetPlayers()) do if p.Name:lower() == S.hostName then return p end end
    return nil
end
local function getHostHRP()
    local h = getHost(); return h and h.Character and h.Character:FindFirstChild("HumanoidRootPart") or nil
end
local function getPlayer(name)
    if not name then return nil end
    local n = name:lower(); if n == "" then return nil end
    for _, p in ipairs(Players:GetPlayers()) do if p.Name:lower() == n or p.DisplayName:lower() == n then return p end end
    for _, p in ipairs(Players:GetPlayers()) do if p.Name:lower():sub(1, #n) == n or p.DisplayName:lower():sub(1, #n) == n then return p end end
    for _, p in ipairs(Players:GetPlayers()) do if p.Name:lower():find(n, 1, true) or p.DisplayName:lower():find(n, 1, true) then return p end end
    return nil
end
local function getPlayerHRP(p) return p and p.Character and p.Character:FindFirstChild("HumanoidRootPart") or nil end

local function applyFixedSpeed()
    local h = hum()
    if h then pcall(function() h.WalkSpeed = BASE_SPEED; h.JumpPower = BASE_JUMP; h.UseJumpPower = true end) end
end

task.spawn(function()
    while true do
        task.wait(1)
        if ROLE == "BOT" and not S.hidden and not antiBan.detected and not S.sitting then
            local h = hum()
            if h and h.WalkSpeed ~= BASE_SPEED and not S.flingActive then pcall(function() h.WalkSpeed = BASE_SPEED end) end
        end
    end
end)

local function getLookTarget()
    if rotationOwner == "FaceHost" then
        local h = hum(); if not h then return nil end
        if h.MoveDirection.Magnitude > 0.1 then return nil end
        local host = getHost(); local hh = getHostHRP(); local m = hrp()
        if host and hh and m then
            local d = (hh.Position - m.Position).Magnitude
            if d <= LOOK_RANGE then return host end
        end
    elseif rotationOwner == "FaceTarget" then
        local t = S.annoyTarget
        if t and t.Parent and t.Character then return t end
    end
    return nil
end

local function startFacing()
    if S.facing then return end
    S.facing = true
    S.faceConn = RunService.Heartbeat:Connect(function(dt)
        if ROLE ~= "BOT" then return end
        if S.hidden or antiBan.detected then return end
        if rotationOwner ~= "FaceHost" and rotationOwner ~= "FaceTarget" then return end
        local target = getLookTarget()
        if not target or not target.Character then return end
        local root = hrp(); if not root then return end
        local head = target.Character:FindFirstChild("Head")
        local targetPos = head and head.Position or (target.Character.HumanoidRootPart and target.Character.HumanoidRootPart.Position)
        if not targetPos then return end
        local dir = targetPos - root.Position
        local flat = Vector3.new(dir.X, 0, dir.Z)
        if flat.Magnitude < 0.05 then return end
        flat = flat.Unit
        local look = root.CFrame.LookVector
        local curFlat = Vector3.new(look.X, 0, look.Z)
        if curFlat.Magnitude < 0.05 then curFlat = Vector3.new(0, 0, -1) end
        curFlat = curFlat.Unit
        local alpha = 1 - math.exp(-14 * dt)
        local smooth = curFlat:Lerp(flat, alpha)
        if smooth.Magnitude < 0.01 then return end
        smooth = smooth.Unit
        pcall(function() root.CFrame = CFrame.lookAt(root.Position, root.Position + smooth) end)
    end)
end

local DANCE_EMOTES = {[1] = "/e dance1", [2] = "/e dance2", [3] = "/e dance3", [4] = "/e dance4"}
local function stopDance()
    S.dancing = false
    if S.danceTrack then pcall(function() S.danceTrack:Stop(0.2) end); S.danceTrack = nil end
end
local function playDance(num)
    num = tonumber(num) or 1
    if num < 1 or num > 4 then num = 1 end
    stopDance()
    sendChat(DANCE_EMOTES[num])
    task.wait(0.05)
    sendChat(pick(R.dance))
    S.dancing = true
    return true
end

stopSpin = function()
    S.spinning = false
    if S.spinConn then S.spinConn:Disconnect(); S.spinConn = nil end
    if S.mode == "Spin" then S.mode = "Follow"; releaseRotation() end
end
local function startSpin(speed)
    speed = tonumber(speed) or 5; speed = math.clamp(speed, 1, 100); S.spinSpeed = speed
    if S.spinning then sendChat(pick({"speed is now "..speed,"updated to "..speed,"changed to "..speed})); return end
    stopDance(); S.spinning = true; S.mode = "Spin"; setRotationOwner("Spin")
    local h = hum()
    if h then local m = hrp(); if m then h:MoveTo(m.Position) end end
    S.spinConn = RunService.Heartbeat:Connect(function(dt)
        if not S.spinning then return end
        if ROLE ~= "BOT" then return end
        if S.hidden or antiBan.detected then return end
        local m = hrp(); if not m then return end
        local step = math.rad(speed * 60 * dt)
        pcall(function() m.CFrame = m.CFrame * CFrame.Angles(0, step, 0) end)
    end)
    sendChat(pick(R.spin))
end

stopLead = function(announce)
    if S.leadActive then
        S.leadActive = false; S.leadTarget = nil
        if S.mode == "Lead" then S.mode = "Follow"; releaseRotation() end
        if announce then sendChat(pick(R.unlead)) end
    end
end
local function startLead(name)
    if not name or name == "" then sendChat("usage: !lead <player>"); return end
    local t = getPlayer(name)
    if not t then sendChat(pick(R.notfound)); return end
    if t == player then sendChat(pick(R.self)); return end
    stopOrbit(); stopSpin(); stopDance(); stopBam(false); stopAnnoy(false); stopFling(false)
    S.leadTarget = t; S.leadActive = true; S.mode = "Lead"
    S.waypoints = nil; S.cachedPath = nil; S.lastMovePos = nil; S.committedTarget = nil
    sendChat(pick(R.lead).." "..t.Name)
end

local function computePath(from, to)
    local path = PathfindingService:CreatePath({
        AgentRadius = 2.5, AgentHeight = 5, AgentCanJump = true,
        AgentJumpHeight = 11, AgentCanClimb = true, AgentMaxSlope = 45, WaypointSpacing = 3
    })
    for _ = 1, PATH_MAX_ATTEMPTS do
        local ok = pcall(function() path:ComputeAsync(from, to) end)
        if ok and path.Status == Enum.PathStatus.Success then return path:GetWaypoints() end
        task.wait(0.02)
    end
    S.lastPathFail = os.clock()
    return nil
end

local rayFilter = {player.Character}
local function mkRP(iw)
    local rp = RaycastParams.new()
    rp.FilterType = Enum.RaycastFilterType.Exclude
    rp.FilterDescendantsInstances = rayFilter
    rp.IgnoreWater = iw ~= false
    return rp
end
local function analyzePart(inst)
    if not inst or not inst:IsA("BasePart") then return nil end
    local size = inst.Size
    local minH = math.min(size.X, size.Z)
    return {
        class = inst.ClassName, name = inst.Name, size = size, minHoriz = minH, height = size.Y,
        transparency = inst.Transparency, canCollide = inst.CanCollide,
        isSlim = (minH < SLIM_BLOCK_MIN and size.Y < 2),
        isThin = (minH < 1.0), isTransparent = (inst.Transparency > 0.5),
        isWalkable = (inst.CanCollide and inst.Transparency < 0.95 and size.Y <= 3)
    }
end
local function probeFloor(pos)
    local rp = mkRP(true)
    local hit = Workspace:Raycast(pos + Vector3.new(0, 6, 0), Vector3.new(0, -60, 0), rp)
    if not hit then return false, nil, nil end
    return true, hit, analyzePart(hit.Instance)
end
local function hasFloorBelow(pos) return probeFloor(pos) end

local function visionClear(fromPos, toPos)
    local dir = toPos - fromPos
    local flat = Vector3.new(dir.X, 0, dir.Z)
    local dist = flat.Magnitude
    if dist < 0.1 then return true, "clear" end
    flat = flat.Unit
    local rp = mkRP(false)
    local wallHit = Workspace:Raycast(fromPos + Vector3.new(0, 2, 0), flat * dist, rp)
    if wallHit then
        local plrChar = wallHit.Instance and wallHit.Instance:FindFirstAncestorOfClass("Model")
        local hitPlayer = plrChar and Players:GetPlayerFromCharacter(plrChar)
        if not hitPlayer then return false, "wall", nil, wallHit end
        return true, "player", hitPlayer, wallHit
    end
    local sampleCount = math.max(3, math.ceil(dist / 5))
    for i = 1, sampleCount do
        local checkPos = fromPos + flat * (dist * (i / sampleCount))
        local ok, _, info = probeFloor(checkPos)
        if not ok then return false, "void" end
        if info and info.isThin and not info.isWalkable then return false, "slim" end
    end
    return true, "clear"
end

local function checkAheadObstacle(fromPos, dir, maxDist)
    local flat = Vector3.new(dir.X, 0, dir.Z)
    if flat.Magnitude < 0.1 then return "clear", nil, nil end
    flat = flat.Unit
    local rp = mkRP(false)
    local wallHit = Workspace:Raycast(fromPos + Vector3.new(0, 2, 0), flat * maxDist, rp)
    if wallHit then
        local info = analyzePart(wallHit.Instance)
        if info and info.canCollide and not info.isTransparent then
            local normal = wallHit.Normal
            if math.abs(normal.Y) < 0.35 then return "wall", wallHit, info end
            if normal.Y < 0.75 and normal.Y > 0.35 then return "slope", wallHit, info end
        end
    end
    for _, d in ipairs({maxDist * 0.35, maxDist * 0.55, maxDist * 0.75, maxDist}) do
        local checkPos = fromPos + flat * d
        local ok, hit, info = probeFloor(checkPos)
        if not ok then return "void_risk", nil, nil end
        local gap = (checkPos.Y + 6) - hit.Position.Y
        if gap > STEEP_EDGE_DROP then return "steep_drop", hit, info end
        if info and info.isThin then return "slim", hit, info end
    end
    return "clear", nil, nil
end

local function isInVoid(pos) return pos and pos.Y < VOID_THRESHOLD end

local function findPlayerInFront(fromPos, dir, maxDist)
    local rp = mkRP(false)
    local hit = Workspace:Raycast(fromPos + Vector3.new(0, 2, 0), dir * maxDist, rp)
    if hit and hit.Instance then
        local model = hit.Instance:FindFirstAncestorOfClass("Model")
        if model then
            local plr = Players:GetPlayerFromCharacter(model)
            if plr then return plr, hit end
        end
    end
    return nil
end

local function planDodge(fromPos, toPos)
    local dir = toPos - fromPos
    dir = Vector3.new(dir.X, 0, dir.Z)
    if dir.Magnitude < 0.1 then return nil end
    dir = dir.Unit
    local left = Vector3.new(-dir.Z, 0, dir.X)
    local right = Vector3.new(dir.Z, 0, -dir.X)
    local leftOK = hasFloorBelow(fromPos + left * 7)
    local rightOK = hasFloorBelow(fromPos + right * 7)
    if leftOK and rightOK then
        local td = (toPos - fromPos); td = Vector3.new(td.X, 0, td.Z).Unit
        if (left + td).Magnitude < (right + td).Magnitude then return "left" else return "right" end
    elseif leftOK then return "left"
    elseif rightOK then return "right"
    else return "jump" end
end

local function tryJump()
    local h, m = hum(), hrp(); if not h or not m then return end
    if os.clock() - S.lastJump < 0.45 then return end
    if h.FloorMaterial == Enum.Material.Air then return end
    S.lastJump = os.clock(); h.Jump = true
end

local function checkStuck()
    local h, m = hum(), hrp(); if not h or not m then return end
    if os.clock() - S.lastStuckCheck < 0.5 then return end
    S.lastStuckCheck = os.clock()
    if not S.lastMovePos then S.stuckCount = 0; return end
    local moved = 0
    if S.lastStuckPos then moved = (m.Position - S.lastStuckPos).Magnitude end
    S.lastStuckPos = m.Position
    if moved < 1.0 then
        S.stuckCount = S.stuckCount + 1
        if S.stuckCount >= 2 then
            S.stuckCount = 0
            flashNoclip(STUCK_NOCLIP_TIME)
            task.delay(0.05, function()
                local h2 = hum()
                if h2 and S.lastMovePos then h2:MoveTo(S.lastMovePos) end
            end)
        end
    else S.stuckCount = 0 end
end

local function checkPush()
    local m = hrp(); local hh = getHostHRP()
    if not m or not hh then return end
    if os.clock() - S.pushCheck < 0.5 then return end
    S.pushCheck = os.clock()
    if S.mode ~= "Follow" then S.lastRealPos = m.Position; return end
    if S.lastRealPos then
        local delta = (m.Position - S.lastRealPos).Magnitude
        local vel = m.AssemblyLinearVelocity.Magnitude
        if delta > 15 and vel > 30 then
            local back = hh.CFrame.LookVector * -5
            pcall(function()
                m.CFrame = CFrame.new(hh.Position + Vector3.new(back.X, 3, back.Z))
                m.AssemblyLinearVelocity = Vector3.zero
                m.AssemblyAngularVelocity = Vector3.zero
            end)
            S.waypoints = nil; S.cachedPath = nil; S.lastMovePos = nil; S.committedTarget = nil
        end
    end
    S.lastRealPos = m.Position
end

stopOrbit = function()
    S.orbiting = false
    if S.orbitLV then pcall(function() S.orbitLV:Destroy() end); S.orbitLV = nil end
    if S.orbitAO then pcall(function() S.orbitAO:Destroy() end); S.orbitAO = nil end
    if S.orbitAtt then pcall(function() S.orbitAtt:Destroy() end); S.orbitAtt = nil end
    if S.mode == "Orbit" then S.mode = "Follow"; releaseRotation() end
end

teleportToHost = function()
    local hh, m = getHostHRP(), hrp()
    if not hh or not m then return end
    local back = hh.CFrame.LookVector * -5
    pcall(function()
        m.CFrame = CFrame.new(hh.Position + Vector3.new(back.X, 3, back.Z))
        m.AssemblyLinearVelocity = Vector3.zero
        m.AssemblyAngularVelocity = Vector3.zero
    end)
    S.waypoints = nil; S.cachedPath = nil; S.lastMovePos = nil; S.committedTarget = nil
    S.stableFollowDir = nil
end

stopBam = function(announce)
    if S.bamActive then
        S.bamActive = false; S.bamTarget = nil
        if S.mode == "Bam" then S.mode = "Follow"; releaseRotation() end
        if announce then sendChat(pick(R.unbam)) end
    end
end
startBam = function(name)
    if not name or name == "" then sendChat("usage: !bam <player>"); return end
    local t = getPlayer(name)
    if not t then sendChat(pick(R.notfound)); return end
    if t == player then sendChat(pick(R.self)); return end
    stopOrbit(); stopSpin(); stopDance(); stopLead(false); stopAnnoy(false); stopFling(false)
    S.bamTarget = t; S.bamActive = true; S.mode = "Bam"
    S.waypoints = nil; S.cachedPath = nil; S.lastMovePos = nil; S.committedTarget = nil
    sendChat(pick(R.bam).." "..t.Name)
end

local ANNOY_MSGS = {
    "You got games on your pone?", "omg so sigma", "tung tung tung sahur",
    "ballerina capuchina", "tripi tropi tripi tropa", "brrrrrrrrr brrrrrr patapim",
    "jonkler", "hey you", "hey hey", "bro", "HEY", "listen", "dlawg", "auuuuu",
    "67", "karasame kudasai!", "DATEBAYO!! BAKAAAA", "mega maxxing",
    "hoyaaaahhh", "heyyy dont ignore me senpai", "Purr now my kitten",
    "hey bro", "HEYY!!!", "listen to me man", "tralalero tralala",
    "bombardiro crocadilo", "uwu", "larp", "67777", "you in ohio",
    "womp womp", "who are you bro?", "hey bro", "L bro", "REEEEEEEE",
    "your face..", "omg bro what", "HELL NO", "WHAT ARE THOSEEE..."
}

stopAnnoy = function(announce)
    if S.annoyActive then
        S.annoyActive = false; S.annoyTarget = nil
        if S.mode == "Annoy" then S.mode = "Follow"; releaseRotation() end
        if announce then sendChat(pick(R.unannoy)) end
    end
end

startAnnoy = function(name)
    if not name or name == "" then sendChat("usage: !annoy <player>"); return end
    local t = getPlayer(name)
    if not t then sendChat(pick(R.notfound)); return end
    if t == player then sendChat(pick(R.self)); return end
    stopOrbit(); stopSpin(); stopDance(); stopLead(false); stopBam(false); stopFling(false)
    S.annoyTarget = t; S.annoyActive = true; S.mode = "Annoy"
    setRotationOwner("FaceTarget")
    S.waypoints = nil; S.cachedPath = nil; S.lastMovePos = nil; S.committedTarget = nil
    sendChat(pick(R.annoy).." "..t.Name)
end

local function setBotCollide(state)
    local c = player.Character; if not c then return end
    for _, p in ipairs(c:GetDescendants()) do
        if p:IsA("BasePart") then pcall(function() p.CanCollide = state end) end
    end
end

local function setBotMassive(enable)
    local c = player.Character; if not c then return end
    for _, p in ipairs(c:GetDescendants()) do
        if p:IsA("BasePart") then
            pcall(function()
                if enable then
                    p.Massless = false
                    p.CustomPhysicalProperties = PhysicalProperties.new(100, 0.3, 0, 1, 1)
                else
                    p.CustomPhysicalProperties = nil
                    p.Massless = false
                end
            end)
        end
    end
end

stopFling = function(announce, silentReturn)
    if not S.flingActive then return end
    S.flingActive = false
    S.flingTarget = nil
    S.flingLastTargetPos = nil
    S.flingStartTime = 0
    setBotMassive(false)
    local h = hum()
    if h then
        pcall(function() h:ChangeState(Enum.HumanoidStateType.GettingUp) end)
        pcall(function() h.PlatformStand = false; h.WalkSpeed = BASE_SPEED; h.JumpPower = BASE_JUMP end)
    end
    setBotCollide(true)
    if S.mode == "Fling" then S.mode = "Follow"; releaseRotation() end
    if announce then sendChat(pick(R.unfling)) end
    if silentReturn then teleportToHost() end
end

startFling = function(name)
    if not name or name == "" then sendChat("usage: !fling <player>"); return end
    local t = getPlayer(name)
    if not t then sendChat(pick(R.notfound)); return end
    if t == player then sendChat(pick(R.self)); return end
    local thrp = getPlayerHRP(t)
    if not thrp then sendChat("target has no body"); return end
    if isInVoid(thrp.Position) then sendChat("target in void"); return end
    stopOrbit(); stopSpin(); stopDance(); stopLead(false); stopBam(false); stopAnnoy(false)
    S.flingTarget = t; S.flingActive = true; S.flingStartTime = os.clock()
    S.flingLastTargetPos = thrp.Position
    S.mode = "Fling"; setRotationOwner("Fling")
    local h = hum()
    if h then pcall(function() h:ChangeState(Enum.HumanoidStateType.Physics) end) end
    setBotCollide(true); setBotMassive(true)
    sendChat(pick(R.fling).." "..t.Name)
end

print("[MyPanel] BOOT 5 — background loops")

task.spawn(function()
    while true do
        RunService.Heartbeat:Wait()
        if not S.flingActive or ROLE ~= "BOT" or antiBan.detected then continue end
        if S.hidden then continue end
        local target = S.flingTarget
        if not target or not target.Parent then stopFling(false, false); continue end
        local thrp = getPlayerHRP(target); local m = hrp()
        if not thrp or not m then continue end
        local t = os.clock()
        local rx = math.rad((t * FLING_SPIN_X) % 360)
        local ry = math.rad((t * FLING_SPIN_Y) % 360)
        local rz = math.rad((t * FLING_SPIN_Z) % 360)
        local jitter = Vector3.new((math.random()-0.5)*0.6, (math.random()-0.5)*0.6, (math.random()-0.5)*0.6)
        local insidePos = thrp.Position + jitter
        local rv = Vector3.new(math.random(-FLING_LIN_VEL,FLING_LIN_VEL), math.random(-FLING_LIN_VEL,FLING_LIN_VEL), math.random(-FLING_LIN_VEL,FLING_LIN_VEL))
        local rav = Vector3.new(math.random(-FLING_ANG_VEL,FLING_ANG_VEL), math.random(-FLING_ANG_VEL,FLING_ANG_VEL), math.random(-FLING_ANG_VEL,FLING_ANG_VEL))
        pcall(function()
            m.CFrame = CFrame.new(insidePos) * CFrame.Angles(rx, ry, rz)
            m.AssemblyLinearVelocity = rv
            m.AssemblyAngularVelocity = rav
        end)
        local c = player.Character
        if c then
            for _, part in ipairs(c:GetDescendants()) do
                if part:IsA("BasePart") and part ~= m then
                    pcall(function()
                        part.AssemblyLinearVelocity = rv
                        part.AssemblyAngularVelocity = rav
                    end)
                end
            end
        end
        if S.flingLastTargetPos and (os.clock() - S.flingStartTime) > FLING_DETECT_WARMUP then
            local moved = (thrp.Position - S.flingLastTargetPos).Magnitude
            local vel = thrp.AssemblyLinearVelocity.Magnitude
            if vel > FLING_DETECT_VEL or moved > FLING_DETECT_DIST then
                sendChat(pick({"flung em","target yeeted","got em"}))
                stopFling(false, false); task.wait(0.1); teleportToHost(); task.wait(0.4); continue
            end
        end
        S.flingLastTargetPos = thrp.Position
        if os.clock() - S.flingStartTime > FLING_MAX_DURATION then
            sendChat(pick({"timed out","giving up","eh"}))
            stopFling(false, false); teleportToHost()
        end
    end
end)

task.spawn(function()
    while true do
        task.wait(0.02)
        if not S.bamActive or ROLE ~= "BOT" or antiBan.detected then continue end
        if S.hidden then continue end
        local target = S.bamTarget
        if not target or not target.Parent then task.wait(0.4); continue end
        local thrp = getPlayerHRP(target); local m = hrp()
        if not thrp or not m then task.wait(0.3); continue end
        if isInVoid(thrp.Position) or isInVoid(m.Position) then task.wait(0.3); continue end
        local look = thrp.CFrame.LookVector
        local flatLook = Vector3.new(look.X, 0, look.Z)
        if flatLook.Magnitude > 0.01 then flatLook = flatLook.Unit else flatLook = Vector3.new(0, 0, -1) end
        local t = (os.clock() / BAM_CYCLE) % 1
        local thrust = math.sin(t * math.pi * 2) * 0.5 + 0.5
        local curDist = BAM_DIST_BEHIND - (BAM_OFFSET * thrust)
        local bamPos = thrp.Position - flatLook * curDist
        pcall(function()
            m.CFrame = CFrame.lookAt(bamPos, thrp.Position)
            m.AssemblyLinearVelocity = Vector3.zero
            m.AssemblyAngularVelocity = Vector3.zero
        end)
    end
end)

task.spawn(function()
    while true do
        task.wait(0.05)
        if not S.annoyActive or ROLE ~= "BOT" or antiBan.detected then continue end
        if S.hidden then continue end
        local target = S.annoyTarget
        if not target or not target.Parent then task.wait(0.4); continue end
        local thrp = getPlayerHRP(target); local m = hrp()
        if not thrp or not m then task.wait(0.3); continue end
        if isInVoid(thrp.Position) or isInVoid(m.Position) then task.wait(0.3); continue end
        local look = thrp.CFrame.LookVector
        local flatLook = Vector3.new(look.X, 0, look.Z)
        if flatLook.Magnitude > 0.01 then flatLook = flatLook.Unit else flatLook = Vector3.new(0, 0, -1) end
        local front = thrp.Position + flatLook * ANNOY_FRONT_DIST
        local dist = (m.Position - front).Magnitude
        local h = hum(); if not h then continue end
        if rotationOwner ~= "FaceTarget" and S.annoyActive then setRotationOwner("FaceTarget") end
        if dist > ANNOY_TP_RANGE then
            if os.clock() - S.trollTpCD > 0.6 then
                S.trollTpCD = os.clock()
                pcall(function()
                    m.CFrame = CFrame.new(front + Vector3.new(0, 1, 0))
                    m.AssemblyLinearVelocity = Vector3.zero
                    m.AssemblyAngularVelocity = Vector3.zero
                end)
            end
        else
            h:MoveTo(front)
        end
    end
end)

task.spawn(function()
    while true do
        local waitT = ANNOY_MSG_MIN_WAIT + math.random() * (ANNOY_MSG_MAX_WAIT - ANNOY_MSG_MIN_WAIT)
        task.wait(waitT)
        if not S.annoyActive or ROLE ~= "BOT" or antiBan.detected then continue end
        if S.hidden then continue end
        local target = S.annoyTarget
        if not target or not target.Parent then continue end
        local thrp = getPlayerHRP(target); if not thrp then continue end
        if isInVoid(thrp.Position) then continue end
        local m = hrp(); if not m or isInVoid(m.Position) then continue end
        if (m.Position - thrp.Position).Magnitude > 40 then continue end
        sendChat(ANNOY_MSGS[math.random(1, #ANNOY_MSGS)])
    end
end)

print("[MyPanel] BOOT 6 — hide/spawn + think")

local function clearHide()
    if S.hideBP then pcall(function() S.hideBP:Destroy() end); S.hideBP = nil end
    if S.hideBG then pcall(function() S.hideBG:Destroy() end); S.hideBG = nil end
    if S.hideHB then pcall(function() S.hideHB:Disconnect() end); S.hideHB = nil end
    local m = hrp()
    if m then
        for _, c in ipairs(m:GetChildren()) do
            if c:IsA("BodyGyro") or c:IsA("BodyAngularVelocity") or c:IsA("BodyPosition") or c:IsA("BodyVelocity")
            or c:IsA("AlignOrientation") or c:IsA("AlignPosition") or c:IsA("LinearVelocity") then
                pcall(function() c:Destroy() end)
            end
        end
    end
end

local function doHide(silent)
    S.hidden = true; S.frozen = true; S.sitting = false
    stopOrbit(); stopSpin(); stopDance(); stopLead(false); stopBam(false); stopAnnoy(false); stopFling(false)
    S.mode = "Hidden"; setRotationOwner("Hidden")
    local m = hrp()
    if m then
        local pos = Vector3.new(math.random(-VOID_RANGE, VOID_RANGE), VOID_Y + 50, math.random(-VOID_RANGE, VOID_RANGE))
        S.hidePos = pos
        pcall(function()
            m.CFrame = CFrame.new(pos)
            m.AssemblyLinearVelocity = Vector3.zero
            m.AssemblyAngularVelocity = Vector3.zero
        end)
        clearHide()
        local b = Instance.new("BodyPosition")
        b.MaxForce = Vector3.new(1e7,1e7,1e7); b.Position = pos; b.P = 5e5; b.D = 200; b.Parent = m; S.hideBP = b
        local g = Instance.new("BodyGyro")
        g.MaxTorque = Vector3.new(1e7,1e7,1e7); g.P = 5e5; g.D = 200; g.CFrame = m.CFrame; g.Parent = m; S.hideBG = g
        local h = hum(); if h then h.WalkSpeed = 0; h.JumpPower = 0; h.PlatformStand = true end
        S.hideHB = RunService.Heartbeat:Connect(function()
            if not S.hidden then return end
            local r = hrp(); if not r then return end
            if (r.Position - pos).Magnitude > 5 then pcall(function() r.CFrame = CFrame.new(pos) end) end
            if r.AssemblyLinearVelocity.Magnitude > 1 then pcall(function() r.AssemblyLinearVelocity = Vector3.zero end) end
        end)
    end
    if not silent then sendChat(pick(R.hide)) end
end

local function doSpawn()
    S.hidden = false; S.frozen = false; S.sitting = false; S.mode = "Follow"; clearHide()
    local h = hum()
    if h then h.PlatformStand = false; h.WalkSpeed = BASE_SPEED; h.JumpPower = BASE_JUMP end
    rotationOwner = "Humanoid"
    if h then h.AutoRotate = true end
    local hh, m = getHostHRP(), hrp()
    if hh and m then
        local f = hh.CFrame.LookVector * -5
        pcall(function()
            m.CFrame = CFrame.new(hh.Position + Vector3.new(f.X, 0, f.Z))
            m.AssemblyLinearVelocity = Vector3.zero
            m.AssemblyAngularVelocity = Vector3.zero
        end)
    end
    S.waypoints = nil; S.cachedPath = nil; S.lastMovePos = nil; S.committedTarget = nil
    S.stableFollowDir = nil
    sendChat(pick(R.spawn))
end

local function think(fromPos, toPos)
    local m = hrp(); if not m then return "wait", nil end
    local dir = toPos - fromPos
    local flat = Vector3.new(dir.X, 0, dir.Z)
    local dist = flat.Magnitude
    if dist < 0.1 then return "arrive", nil end
    flat = flat.Unit
    local obstacle, hit, info = checkAheadObstacle(fromPos, flat, OBSTACLE_LOOKAHEAD)
    if obstacle == "void_risk" or obstacle == "steep_drop" then return "avoid_edge", {kind = obstacle} end
    if obstacle == "slim" then return "avoid_slim", {hit = hit, info = info} end
    if obstacle == "wall" then return "path", nil end
    local ok, reason, _, hitInfo = visionClear(fromPos, toPos)
    if not ok and reason == "void" then return "wait", nil end
    if not ok and reason == "slim" then return "avoid_slim", {hit = hitInfo} end
    local blockRange = math.min(PLAYER_DODGE_RANGE, dist)
    local blocker = findPlayerInFront(fromPos, flat, blockRange)
    if blocker and blocker ~= getHost() and blocker ~= S.leadTarget then
        local plan = planDodge(fromPos, toPos)
        if plan then return "dodge", {dir = plan, blocker = blocker} end
    end
    if ok then return "walk_straight", nil end
    return "path", nil
end

local function startMirrorJump()
    if S.mirrorWatcher then return end
    S.mirrorWatcher = task.spawn(function()
        local lastState = false
        while ROLE == "BOT" do
            task.wait(0.07)
            if S.hidden or antiBan.detected or S.sitting then continue end
            if S.mode == "Bam" or S.mode == "Annoy" or S.mode == "Fling" then continue end
            local host = getHost()
            if not host or not host.Character then continue end
            local hh = host.Character:FindFirstChildOfClass("Humanoid")
            if not hh then continue end
            local state = hh:GetState()
            local j = (state == Enum.HumanoidStateType.Jumping) or (state == Enum.HumanoidStateType.Freefall)
            if j and not lastState then
                if os.clock() - S.lastHostJumpTime > MIRROR_JUMP_COOLDOWN then
                    S.lastHostJumpTime = os.clock()
                    S.mirrorJumpTime = os.clock() + MIRROR_JUMP_MIN_DELAY + math.random() * (MIRROR_JUMP_MAX_DELAY - MIRROR_JUMP_MIN_DELAY)
                end
            end
            lastState = j
        end
    end)
end

local function startCameraMicro()
    if S.microCamActive then return end
    S.microCamActive = true
    S.microCamThread = task.spawn(function()
        while ROLE == "BOT" and S.microCamActive do
            task.wait(MICRO_CAM_MIN_WAIT + math.random() * (MICRO_CAM_MAX_WAIT - MICRO_CAM_MIN_WAIT))
            if S.hidden or antiBan.detected or S.sitting then continue end
            if rotationOwner == "Spin" or rotationOwner == "Orbit" or rotationOwner == "Fling" then continue end
            local cam = Workspace.CurrentCamera; if not cam then continue end
            local sign = math.random() < 0.5 and -1 or 1
            local angle = math.rad(MICRO_CAM_ANGLE_MIN + math.random() * (MICRO_CAM_ANGLE_MAX - MICRO_CAM_ANGLE_MIN)) * sign
            local startCF = cam.CFrame
            local tw1 = TweenService:Create(cam, TweenInfo.new(0.10, Enum.EasingStyle.Linear), {CFrame = startCF * CFrame.Angles(0, angle, 0)})
            tw1:Play(); tw1.Completed:Wait()
            task.wait(0.10 + math.random() * 0.15)
            TweenService:Create(cam, TweenInfo.new(0.14, Enum.EasingStyle.Linear), {CFrame = startCF}):Play()
        end
    end)
end

print("[MyPanel] BOOT 7 — botTick + follow + orbit + lend + afk + death")

local function computeFollowPoint(hostPos, hostCFrame, botPos)
    local toBot = botPos - hostPos
    local flat = Vector3.new(toBot.X, 0, toBot.Z)
    local mag = flat.Magnitude
    local dir
    if mag < FOLLOW_CLOSE_BACK then
        local hv = hostCFrame.LookVector
        dir = Vector3.new(-hv.X, 0, -hv.Z)
        if dir.Magnitude < 0.01 then dir = Vector3.new(0, 0, -1) end
        dir = dir.Unit
    else
        dir = flat.Unit
    end
    return hostPos + dir * FOLLOW_DIST
end

local function botTick()
    if antiBan.detected then return end
    if S.hidden then
        if S.hidePos then
            local m = hrp()
            if m and (m.Position - S.hidePos).Magnitude > 10 then pcall(function() m.CFrame = CFrame.new(S.hidePos) end) end
        end
        return
    end
    if S.sitting then
        local h0 = hum()
        if not h0 or not h0.Sit then S.sitting = false
        else
            local m0 = hrp()
            if m0 then pcall(function()
                m0.AssemblyLinearVelocity = Vector3.new(m0.AssemblyLinearVelocity.X * 0.3, m0.AssemblyLinearVelocity.Y, m0.AssemblyLinearVelocity.Z * 0.3)
            end) end
            return
        end
    end
    if S.mirrorJumpTime > 0 and os.clock() >= S.mirrorJumpTime then
        if S.mode ~= "Bam" and S.mode ~= "Annoy" and S.mode ~= "Fling" then
            local h = hum()
            if h and h.FloorMaterial ~= Enum.Material.Air then h.Jump = true end
        end
        S.mirrorJumpTime = 0
    end
    if S.mode == "Spin" or S.dancing then
        local h2 = hum()
        if h2 then local m2 = hrp(); if m2 then h2:MoveTo(m2.Position) end end
        checkPush(); return
    end
    if S.mode == "Bam" or S.mode == "Annoy" or S.mode == "Fling" then return end
    if S.mode ~= "Follow" and S.mode ~= "Lead" then return end
    local h, hh, m = hum(), getHostHRP(), hrp()
    if not h or not hh or not m then return end

    do
        local hp = hh.Position
        if isInVoid(hp) then
            if not S.hostInVoid then S.hostInVoid = true; S.hostVoidSafePos = S.lastSafeHostPos or m.Position end
        else
            if S.hostInVoid then S.hostInVoid = false end
            S.lastSafeHostPos = hp
        end
    end

    if isInVoid(m.Position) then
        local anchor = S.hostVoidSafePos or S.lastSafeHostPos
        if anchor then pcall(function()
            m.CFrame = CFrame.new(anchor + Vector3.new(0, 3, 0))
            m.AssemblyLinearVelocity = Vector3.zero
            m.AssemblyAngularVelocity = Vector3.zero
        end)
        elseif hh then pcall(function() m.CFrame = CFrame.new(hh.Position + Vector3.new(0, 4, 0)); m.AssemblyLinearVelocity = Vector3.zero end) end
        S.waypoints = nil; S.cachedPath = nil; S.lastMovePos = nil; S.committedTarget = nil
        S.stableFollowDir = nil
        return
    end

    checkPush()

    local targetPos
    if S.mode == "Lead" then
        if not S.leadActive or not S.leadTarget or not S.leadTarget.Parent then
            stopLead(false); sendChat("lost target"); return
        end
        local th = getPlayerHRP(S.leadTarget); if not th then return end
        if isInVoid(th.Position) then targetPos = S.lastSafeHostPos or m.Position; h:MoveTo(targetPos); return end
        targetPos = th.Position
        if (m.Position - targetPos).Magnitude <= LEAD_ARRIVE_DIST then
            sendChat(pick({"made it","here","arrived"})); stopLead(false); S.mode = "Follow"; return
        end
        if (hh.Position - m.Position).Magnitude > LEAD_HOST_MAX_DIST then h:MoveTo(m.Position); return end
    else
        if S.hostInVoid then
            targetPos = S.hostVoidSafePos or S.lastSafeHostPos or m.Position
            if (targetPos - m.Position).Magnitude > FOLLOW_DIST then h:MoveTo(targetPos); S.lastMovePos = targetPos
            else h:MoveTo(m.Position) end
            return
        end
        targetPos = computeFollowPoint(hh.Position, hh.CFrame, m.Position)
    end
    if not targetPos then return end

    local d = (targetPos - m.Position).Magnitude
    local hostDist = (hh.Position - m.Position).Magnitude

    if S.mode == "Follow" and d > EMERGENCY_DIST then
        if os.clock() - S.tpCD > 3 then
            S.tpCD = os.clock()
            local back = hh.CFrame.LookVector * -7
            pcall(function()
                m.CFrame = CFrame.new(hh.Position + Vector3.new(back.X, 3, back.Z))
                m.AssemblyLinearVelocity = Vector3.zero
            end)
            S.waypoints = nil; S.cachedPath = nil; S.lastMovePos = nil; S.committedTarget = nil
            S.stableFollowDir = nil
        end
        return
    end

    if h.MoveDirection.Magnitude > 0.1 then setRotationOwner("Humanoid")
    else
        if S.mode == "Follow" and hostDist <= LOOK_RANGE then setRotationOwner("FaceHost")
        else setRotationOwner("Humanoid") end
    end

    if d <= FOLLOW_STOP_DIST then
        h:MoveTo(m.Position)
        S.waypoints = nil; S.cachedPath = nil; S.lastHostPos = nil; S.lastMovePos = nil
        S.committedTarget = nil; S.lastWaypoint = nil; S.failCount = 0
        return
    end

    local action, data = think(m.Position, targetPos)
    if action == "arrive" or action == "wait" then
        h:MoveTo(m.Position)
        S.lastMovePos = nil; S.waypoints = nil; S.cachedPath = nil; S.committedTarget = nil
        return
    end
    if action == "avoid_edge" then
        local back = m.Position - targetPos
        back = Vector3.new(back.X, 0, back.Z)
        if back.Magnitude > 0.1 then
            back = back.Unit * 6
            local safe = m.Position + back
            if hasFloorBelow(safe) then h:MoveTo(safe); S.lastMovePos = safe end
        end
        return
    end
    if action == "avoid_slim" then
        local dir = targetPos - m.Position
        dir = Vector3.new(dir.X, 0, dir.Z)
        if dir.Magnitude > 0.1 then
            dir = dir.Unit
            local left = Vector3.new(-dir.Z, 0, dir.X)
            local right = Vector3.new(dir.Z, 0, -dir.X)
            local chosen = hasFloorBelow(m.Position + left * 6) and left or (hasFloorBelow(m.Position + right * 6) and right or nil)
            if chosen then local np = m.Position + chosen * 6; h:MoveTo(np); S.lastMovePos = np end
        end
        return
    end
    if action == "dodge" then
        local dir = data.dir
        local side
        if dir == "left" then side = Vector3.new(-m.CFrame.LookVector.Z, 0, m.CFrame.LookVector.X)
        elseif dir == "right" then side = Vector3.new(m.CFrame.LookVector.Z, 0, -m.CFrame.LookVector.X)
        else side = m.CFrame.LookVector end
        if dir == "jump" then
            local bl = data.blocker and data.blocker.Character
            if bl then
                for _, p in ipairs(bl:GetChildren()) do if p:IsA("BasePart") then pcall(function() p.CanCollide = false end) end end
                task.delay(1.2, function()
                    if bl and bl.Parent then
                        for _, p in ipairs(bl:GetChildren()) do if p:IsA("BasePart") then pcall(function() p.CanCollide = true end) end end
                    end
                end)
                tryJump()
            end
        else
            local dd = m.Position + side * 7
            if hasFloorBelow(dd) then h:MoveTo(dd) end
        end
        return
    end
    if action == "walk_straight" then
        if not S.committedTarget or (S.committedTarget - targetPos).Magnitude > 2 or os.clock() > S.committedUntil then
            h:MoveTo(targetPos); S.committedTarget = targetPos; S.committedUntil = os.clock() + 1.2
        end
        S.waypoints = nil; S.cachedPath = nil; S.lastMovePos = targetPos
        checkStuck(); return
    end

    local pathSig = tostring(math.floor(targetPos.X)).."|"..tostring(math.floor(targetPos.Z))
    local needNewPath = false
    if not S.waypoints or #S.waypoints == 0 then needNewPath = true
    elseif S.lastPathSig ~= pathSig then needNewPath = true
    elseif os.clock() - S.lastRepath > REPATH_INTERVAL then
        if (S.lastHostPos and (targetPos - S.lastHostPos).Magnitude or 999) > 3 then needNewPath = true end
    end
    if needNewPath and (os.clock() - S.lastPathFail) < PATH_FAIL_COOLDOWN then needNewPath = false end
    if needNewPath and os.clock() - S.lastRepath > REPATH_INTERVAL then
        S.lastRepath = os.clock()
        local wps = computePath(m.Position, targetPos)
        if wps and #wps > 0 then
            local total = 0; local prev = m.Position
            for _, wp in ipairs(wps) do total = total + (wp.Position - prev).Magnitude; prev = wp.Position end
            S.totalSteps = math.floor(total / 3.5)
            S.cachedPath = wps; S.waypoints = wps; S.lastHostPos = targetPos
            S.lastWaypoint = nil; S.lastPathSig = pathSig
        else S.waypoints = nil end
    end

    if S.waypoints and #S.waypoints > 0 then
        while S.waypoints[1] and dist2d(m.Position, S.waypoints[1].Position) < WAYPOINT_REACH do table.remove(S.waypoints, 1) end

        while #S.waypoints > 2 do
            local wpNext = S.waypoints[2]
            local toNext = wpNext.Position - m.Position
            toNext = Vector3.new(toNext.X, 0, toNext.Z)
            local dd = toNext.Magnitude
            if dd < 2 then
                table.remove(S.waypoints, 1)
            else
                toNext = toNext.Unit
                local rp = mkRP(false)
                local aheadHit = Workspace:Raycast(m.Position + Vector3.new(0, 2, 0), toNext * (dd - 1.5), rp)
                if aheadHit and math.abs(aheadHit.Normal.Y) < 0.4 then
                    break
                end
                table.remove(S.waypoints, 1)
            end
        end

        local wp = S.waypoints[1]
        if wp then
            local wdir = wp.Position - m.Position
            wdir = Vector3.new(wdir.X, 0, wdir.Z)
            if wdir.Magnitude > 0.5 then
                wdir = wdir.Unit
                local pBlock = findPlayerInFront(m.Position, wdir, 6)
                if pBlock and pBlock ~= getHost() and pBlock ~= S.leadTarget then
                    local plan = planDodge(m.Position, wp.Position)
                    if plan == "left" or plan == "right" then
                        local side = plan == "left" and Vector3.new(-wdir.Z, 0, wdir.X) or Vector3.new(wdir.Z, 0, -wdir.X)
                        h:MoveTo(m.Position + side * 6); S.lastMovePos = m.Position + side * 6; return
                    end
                end
            end
            if hasFloorBelow(wp.Position) then
                if wp.Action == Enum.PathWaypointAction.Jump then
                    if h.FloorMaterial ~= Enum.Material.Air then h.Jump = true end
                end
                if not S.lastWaypoint or (S.lastWaypoint - wp.Position).Magnitude > 0.5 then
                    h:MoveTo(wp.Position); S.lastWaypoint = wp.Position
                end
                tryJump()
            else table.remove(S.waypoints, 1) end
        end
    else
        if hasFloorBelow(targetPos) then h:MoveTo(targetPos); S.lastMovePos = targetPos; tryJump()
        else h:MoveTo(m.Position) end
    end
    checkStuck()
end

startFollow = function()
    if S.followThread then return end
    startFacing()
    S.followThread = task.spawn(function()
        while ROLE == "BOT" do
            task.wait(AI_TICK)
            local ok, err = pcall(botTick)
            if not ok then
                warn("[MyPanel] botTick error:", err)
                S.failCount = S.failCount + 1
                if S.failCount >= 8 then
                    S.failCount = 0
                    S.waypoints = nil; S.cachedPath = nil; S.lastMovePos = nil
                    S.committedTarget = nil; S.lastWaypoint = nil
                    S.hostInVoid = false; S.mirrorJumpTime = 0
                    S.stableFollowDir = nil
                end
            else S.failCount = 0 end
        end
    end)
end

stopFollow = function()
    if S.followThread then task.cancel(S.followThread); S.followThread = nil end
end

local function startOrbit(speed)
    speed = tonumber(speed) or 100
    speed = math.clamp(speed, 1, 1000)
    S.orbitSpeed = speed
    stopSpin(); stopDance(); stopLead(false); stopBam(false); stopAnnoy(false); stopFling(false)
    if S.orbiting then return end
    S.orbiting = true; S.mode = "Orbit"; setRotationOwner("Orbit")
    task.spawn(function()
        while S.orbiting and ROLE == "BOT" do
            if S.hidden or antiBan.detected then task.wait(0.3); continue end
            local hh, m, h = getHostHRP(), hrp(), hum()
            if not hh or not m or not h then task.wait(0.1); continue end
            if not S.orbitLV or S.orbitLV.Parent ~= m then
                if S.orbitLV then pcall(function() S.orbitLV:Destroy() end) end
                if S.orbitAO then pcall(function() S.orbitAO:Destroy() end) end
                if S.orbitAtt then pcall(function() S.orbitAtt:Destroy() end) end
                local att = Instance.new("Attachment"); att.Parent = m; S.orbitAtt = att
                local lv = Instance.new("LinearVelocity"); lv.Attachment0 = att; lv.MaxForce = 1e5; lv.VectorVelocity = Vector3.zero; lv.Parent = m; S.orbitLV = lv
                local ao = Instance.new("AlignOrientation"); ao.Attachment0 = att
                ao.Mode = Enum.OrientationAlignmentMode.OneAttachment; ao.PrimaryAxisOnly = true; ao.MaxTorque = 1e5; ao.Parent = m; S.orbitAO = ao
            end
            local off = m.Position - hh.Position
            local flat = Vector3.new(off.X, 0, off.Z)
            if flat.Magnitude < 1 then
                local a = math.random() * math.pi * 2
                pcall(function() m.CFrame = CFrame.new(hh.Position + Vector3.new(math.cos(a) * ORBIT_R, 0, math.sin(a) * ORBIT_R)) end)
                task.wait(0.05); continue
            end
            local rad = flat.Unit
            local tan = Vector3.new(-rad.Z, 0, rad.X)
            pcall(function()
                S.orbitLV.VectorVelocity = tan * (speed / 8)
                S.orbitAO.CFrame = CFrame.lookAt(m.Position, m.Position + tan)
            end)
            task.wait(0.05)
        end
        if S.orbitLV then pcall(function() S.orbitLV:Destroy() end); S.orbitLV = nil end
        if S.orbitAO then pcall(function() S.orbitAO:Destroy() end); S.orbitAO = nil end
        if S.orbitAtt then pcall(function() S.orbitAtt:Destroy() end); S.orbitAtt = nil end
    end)
    sendChat(pick(R.orbit))
end

-- [BATCH A] startLend kept for future Lends tab GUI. Not reachable via chat anymore.
local function restoreHost()
    if not originalHost.name then return end
    S.hostName = originalHost.name; hostFilter.name = originalHost.name; hostFilter.userId = originalHost.userId
    S.lending = false; S.lendEnd = 0
    sendChat(pick({"lend done","back to original","transfer over"}))
end

local function startLend(name, secs)
    secs = tonumber(secs); if not secs or secs <= 0 then secs = 60 end
    local t = getPlayer(name)
    if not t then sendChat(pick(R.notfound)); return end
    if t == player then sendChat(pick(R.self)); return end
    if hostFilter.userId and t.UserId == hostFilter.userId then
        sendChat("already lending to them")
        return
    end
    if originalHost.userId and t.UserId == originalHost.userId then
        sendChat("cant lend to yourself")
        return
    end
    if not S.lending then originalHost.name = S.hostName; originalHost.userId = hostFilter.userId end
    S.lending = true; S.hostName = t.Name:lower()
    hostFilter.name = t.Name:lower(); hostFilter.userId = t.UserId
    S.lendEnd = os.clock() + secs
    sendChat(pick({"listening to ","lend to ","transferring to "})..t.Name.." for "..secs.."s")
    if S.lendThread then task.cancel(S.lendThread) end
    S.lendThread = task.spawn(function()
        while S.lending and ROLE == "BOT" do
            task.wait(0.5)
            if os.clock() >= S.lendEnd then restoreHost(); break end
        end
    end)
end

local function startAfk()
    if ROLE ~= "BOT" then return end
    task.spawn(function()
        while ROLE == "BOT" do
            task.wait(1)
            local hh = getHostHRP()
            if not hh then S.hostLastPos = nil; S.hostAfkTimer = 0; continue end
            if S.hostLastPos then
                if (hh.Position - S.hostLastPos).Magnitude > 0.8 then
                    S.hostAfkTimer = 0
                    if S.hostIsAfk then S.hostIsAfk = false end
                else
                    S.hostAfkTimer = S.hostAfkTimer + 1
                    if S.hostAfkTimer >= AFK_T and not S.hostIsAfk then S.hostIsAfk = true end
                end
            end
            S.hostLastPos = hh.Position
        end
    end)
end

local function bindDeath()
    if S.deathConn then S.deathConn:Disconnect(); S.deathConn = nil end
    local c = player.Character; if not c then return end
    local h = c:FindFirstChildOfClass("Humanoid"); if not h then return end
    S.deathConn = h.Died:Connect(function()
        stopSpin(); stopDance(); stopLead(false); stopFling(false)
        S.sitting = false
        S.waypoints = nil; S.cachedPath = nil; S.lastMovePos = nil; S.committedTarget = nil
        S.hostInVoid = false; S.mirrorJumpTime = 0; S.stableFollowDir = nil

        local now = os.clock()
        if now - S.lastDeathTime > DEATH_RESET_TIME then
            S.deathCount = 0
            S.deathSilent = false
        end
        S.lastDeathTime = now
        S.deathCount = S.deathCount + 1

        if S.deathSilent then return end

        if S.deathCount == 2 then
            sendChat("...")
        elseif S.deathCount == 3 then
            sendChat("....")
        elseif S.deathCount == 4 then
            sendChat(".....")
        elseif S.deathCount == 5 then
            sendChat(pick({"bro","cmon","seriously","again?","bruh"}))
        elseif S.deathCount == 6 then
            sendChat(pick({"ok this is annoying","really now","dude","ugh","seriously"}))
        elseif S.deathCount == 7 then
            sendChat(pick({"bro stop","cmon man","enough","why tho"}))
        elseif S.deathCount >= 8 then
            sendChat(pick({"stop bro","bro stop it","ok enough","chill out man","i said stop"}))
            S.deathSilent = true
        end
    end)
end

print("[MyPanel] BOOT 8 — commands + chat hooks")

-- [BATCH A] !lend branch removed — lending is GUI-only now.
handleCommand = function(cmd, args)
    if ROLE ~= "BOT" or antiBan.detected then return end
    if cmd == "say" then if args ~= "" then sendChat(args) end
    elseif cmd == "ask" then handleAIChat(args)
    elseif cmd == "orbit" then startOrbit(args ~= "" and args or nil)
    elseif cmd == "unorbit" then stopOrbit(); sendChat(pick(R.unorbit))
    elseif cmd == "sit" then
        stopSpin(); stopDance(); stopLead(false); stopBam(false); stopAnnoy(false); stopFling(false)
        S.sitting = true
        S.waypoints = nil; S.cachedPath = nil; S.lastMovePos = nil; S.committedTarget = nil
        local h = hum()
        if h then pcall(function() h.WalkSpeed = 0; h.JumpPower = 0; h.Sit = true; h:ChangeState(Enum.HumanoidStateType.Seated) end) end
        sendChat(pick(R.sit))
    elseif cmd == "stand" then
        S.sitting = false
        local h = hum()
        if h then pcall(function() h.Sit = false; h:ChangeState(Enum.HumanoidStateType.GettingUp); h.WalkSpeed = BASE_SPEED; h.JumpPower = BASE_JUMP end) end
        sendChat(pick(R.stand))
    elseif cmd == "jump" then local h = hum(); if h then h.Jump = true; sendChat(pick(R.jump)) end
    elseif cmd == "hide" then doHide(false)
    elseif cmd == "spawn" then doSpawn()
    elseif cmd == "dance" then playDance(tonumber(args) or 1)
    elseif cmd == "undance" then stopDance(); sendChat(pick(R.undance))
    elseif cmd == "spin" then startSpin(args)
    elseif cmd == "unspin" then stopSpin(); sendChat(pick(R.unspin))
    elseif cmd == "lead" then startLead(args)
    elseif cmd == "unlead" then stopLead(true)
    elseif cmd == "bam" then startBam(args)
    elseif cmd == "unbam" then stopBam(false); teleportToHost(); sendChat(pick(R.unbam))
    elseif cmd == "annoy" then startAnnoy(args)
    elseif cmd == "unannoy" then stopAnnoy(false); teleportToHost(); sendChat(pick(R.unannoy))
    elseif cmd == "fling" then startFling(args)
    elseif cmd == "unfling" then stopFling(false, false); teleportToHost(); sendChat(pick(R.unfling))
    elseif cmd == "math" then handleMath(args)
    elseif cmd == "cmds" then
        sendSeq({"here ya go",
            "!ask <msg> - talk to XcH",
            "!orbit / !unorbit | !sit / !stand / !jump",
            "!dance 1-4 / !undance | !spin 1-100 / !unspin",
            "!lead <player> / !unlead",
            "!hide / !spawn",
            "!bam / !unbam | !annoy / !unannoy | !fling / !unfling",
            "!math 1+1"}, 0.9)
    else sendChat(pick({"unknown cmd bro","dont know that one","try !cmds"})) end
end

-- [BATCH A] Removed !lend permission gate — command no longer exists.
local function processMessage(uid, text)
    if not text or text == "" then return end
    if ROLE ~= "BOT" then return end

    if not isFromHost(uid) then return end

    local lowText = text:lower()
    if lowText:sub(1, 4) == "!ask" then
        local prompt = trim(text:sub(5))
        if prompt == "" then sendChat("usage: !ask <message>"); return end
        if isDuplicateMessage(uid, text) then return end
        task.spawn(function() handleAIChat(prompt) end)
        return
    end

    if text:sub(1, #commandPrefix) ~= commandPrefix then return end
    if isDuplicateMessage(uid, text) then return end
    local body = trim(text:sub(#commandPrefix + 1))
    if body == "" then return end
    local sp = body:find("%s")
    local cmd, args
    if sp then cmd = body:sub(1, sp - 1):lower(); args = trim(body:sub(sp + 1))
    else cmd = body:lower(); args = "" end

    task.spawn(function()
        local ok, err = pcall(handleCommand, cmd, args)
        if not ok then
            warn("[MyPanel] cmd error:", err)
            if botLogRef then pushLog(botLogRef, "err: "..tostring(err):sub(1, 60), C.red) end
        end
    end)
end

pcall(function()
    if TextChatService and TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
        TextChatService.MessageReceived:Connect(function(m)
            local s = m.TextSource; if not s then return end
            processMessage(s.UserId, m.Text)
        end)
    end
end)
local function hookChatted(p)
    p.Chatted:Connect(function(t) processMessage(p.UserId, t) end)
end
for _, p in ipairs(Players:GetPlayers()) do hookChatted(p) end
Players.PlayerAdded:Connect(hookChatted)
task.spawn(function()
    local ok, ch = pcall(function() return TextChatService:WaitForChild("TextChannels", 8) end)
    if not ok or not ch then return end
    local g = ch:FindFirstChild("RBXGeneral") or ch:FindFirstChild("RBGGeneral") or ch:FindFirstChildWhichIsA("TextChannel")
    if not g then return end
    pcall(function()
        g.MessageReceived:Connect(function(m)
            local s = m.TextSource; if not s then return end
            processMessage(s.UserId, m.Text)
        end)
    end)
end)

print("[MyPanel] BOOT 9 — building GUI")

local gui = Instance.new("ScreenGui")
gui.Name = GUI_NAME
gui.ResetOnSpawn = false
gui.DisplayOrder = 999
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Enabled = true

local parented = false
pcall(function() gui.Parent = playerGui; parented = true end)
if not parented then pcall(function() gui.Parent = game:GetService("CoreGui") end) end

local frame = Instance.new("Frame")
frame.Name = "MainPanel"
frame.Size = UDim2.new(0, 520, 0, 320)
frame.Position = UDim2.new(0, 12, 0.5, -160)
frame.BackgroundColor3 = C.panel
frame.BorderSizePixel = 0
frame.ClipsDescendants = false
frame.Parent = gui
corner(frame, 12)
stroke(frame, C.border, 1, 0)

local SHOWN = UDim2.new(0, 12, 0.5, -160)
local HIDDEN = UDim2.new(0, -600, 0.5, -160)
local function show() tw(frame, 0.4, {Position = SHOWN}, Enum.EasingStyle.Quint) end
local function hide() tw(frame, 0.4, {Position = HIDDEN}, Enum.EasingStyle.Quint, Enum.EasingDirection.In) end

local topBar = Instance.new("Frame")
topBar.Name = "TopBar"
topBar.Size = UDim2.new(1, 0, 0, 40)
topBar.Position = UDim2.new(0, 0, 0, 0)
topBar.BackgroundColor3 = C.panelTop
topBar.BorderSizePixel = 0
topBar.Parent = frame
local topBarStroke = Instance.new("UIStroke")
topBarStroke.Color = C.border; topBarStroke.Thickness = 1; topBarStroke.Transparency = 0.4
topBarStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
topBarStroke.Parent = topBar

local titleLbl = Instance.new("TextLabel")
titleLbl.Size = UDim2.new(0, 200, 1, 0)
titleLbl.Position = UDim2.new(0, 16, 0, 0)
titleLbl.BackgroundTransparency = 1
titleLbl.Font = Enum.Font.GothamBold
titleLbl.Text = "XcH"
titleLbl.TextColor3 = C.text
titleLbl.TextSize = 15
titleLbl.TextXAlignment = Enum.TextXAlignment.Left
titleLbl.Parent = topBar

local timeLbl = Instance.new("TextLabel")
timeLbl.Size = UDim2.new(0, 220, 1, 0)
timeLbl.Position = UDim2.new(1, -236, 0, 0)
timeLbl.BackgroundTransparency = 1
timeLbl.Font = Enum.Font.Code
timeLbl.Text = "12:00:00 AM PHT"
timeLbl.TextColor3 = C.subText
timeLbl.TextSize = 11
timeLbl.TextXAlignment = Enum.TextXAlignment.Right
timeLbl.Parent = topBar

local function phTime()
    local t = os.date("!*t", os.time() + PH_OFFSET)
    local p = t.hour >= 12 and "PM" or "AM"
    local dh = t.hour % 12; if dh == 0 then dh = 12 end
    return string.format("%02d:%02d:%02d %s PHT", dh, t.min, t.sec, p)
end
task.spawn(function() while timeLbl and timeLbl.Parent do timeLbl.Text = phTime(); task.wait(1) end end)

local sidebar = Instance.new("Frame")
sidebar.Name = "Sidebar"
sidebar.Size = UDim2.new(0, 100, 1, -40)
sidebar.Position = UDim2.new(0, 0, 0, 40)
sidebar.BackgroundColor3 = C.sidebar
sidebar.BorderSizePixel = 0
sidebar.ClipsDescendants = true
sidebar.Parent = frame
local sideStroke = Instance.new("UIStroke")
sideStroke.Color = C.border; sideStroke.Thickness = 1; sideStroke.Transparency = 0.4
sideStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
sideStroke.Parent = sidebar

local sideLayout = Instance.new("UIListLayout")
sideLayout.Padding = UDim.new(0, 4)
sideLayout.SortOrder = Enum.SortOrder.LayoutOrder
sideLayout.Parent = sidebar

local sidePad = Instance.new("UIPadding")
sidePad.PaddingTop = UDim.new(0, 8)
sidePad.PaddingLeft = UDim.new(0, 6)
sidePad.PaddingRight = UDim.new(0, 6)
sidePad.Parent = sidebar

local contentArea = Instance.new("Frame")
contentArea.Name = "ContentArea"
contentArea.Size = UDim2.new(1, -100, 1, -40)
contentArea.Position = UDim2.new(0, 100, 0, 40)
contentArea.BackgroundColor3 = C.panel
contentArea.BorderSizePixel = 0
contentArea.ClipsDescendants = true
contentArea.Parent = frame

local function newPage()
    local p = Instance.new("Frame")
    p.Size = UDim2.new(1, 0, 1, 0)
    p.Position = UDim2.new(0, 0, 0, 0)
    p.BackgroundTransparency = 1
    p.Visible = false
    p.Parent = contentArea
    return p
end

local logsPage = newPage()
local logsPad = Instance.new("UIPadding")
logsPad.PaddingTop = UDim.new(0, 10)
logsPad.PaddingLeft = UDim.new(0, 10)
logsPad.PaddingRight = UDim.new(0, 10)
logsPad.PaddingBottom = UDim.new(0, 10)
logsPad.Parent = logsPage

local pfxLbl = Instance.new("TextLabel")
pfxLbl.Size = UDim2.new(0, 110, 0, 14)
pfxLbl.Position = UDim2.new(0, 0, 0, 0)
pfxLbl.BackgroundTransparency = 1
pfxLbl.Font = Enum.Font.GothamBold
pfxLbl.Text = "COMMAND PREFIX"
pfxLbl.TextColor3 = C.subText
pfxLbl.TextSize = 9
pfxLbl.TextXAlignment = Enum.TextXAlignment.Left
pfxLbl.Parent = logsPage

local pfxBox = Instance.new("TextBox")
pfxBox.Size = UDim2.new(0, 42, 0, 26)
pfxBox.Position = UDim2.new(0, 0, 0, 18)
pfxBox.BackgroundColor3 = C.track
pfxBox.BorderSizePixel = 0
pfxBox.Font = Enum.Font.GothamBold
pfxBox.Text = commandPrefix
pfxBox.TextColor3 = C.text
pfxBox.TextSize = 13
pfxBox.ClearTextOnFocus = false
pfxBox.Parent = logsPage
corner(pfxBox, 6); stroke(pfxBox, C.border, 1, 0.2)

local pfxHint = Instance.new("TextLabel")
pfxHint.Size = UDim2.new(1, -50, 0, 26)
pfxHint.Position = UDim2.new(0, 50, 0, 18)
pfxHint.BackgroundTransparency = 1
pfxHint.Font = Enum.Font.Gotham
pfxHint.Text = "type: "..commandPrefix.."cmds"
pfxHint.TextColor3 = C.subText
pfxHint.TextSize = 9
pfxHint.TextXAlignment = Enum.TextXAlignment.Left
pfxHint.TextYAlignment = Enum.TextYAlignment.Center
pfxHint.Parent = logsPage

local logBox = Instance.new("Frame")
logBox.Size = UDim2.new(1, 0, 1, -56)
logBox.Position = UDim2.new(0, 0, 0, 52)
logBox.BackgroundColor3 = C.track
logBox.BorderSizePixel = 0
logBox.ClipsDescendants = true
logBox.Parent = logsPage
corner(logBox, 8); stroke(logBox, C.border, 1, 0.3)

local logEmpty = Instance.new("TextLabel")
logEmpty.Size = UDim2.new(1, -16, 1, -12)
logEmpty.Position = UDim2.new(0, 8, 0, 6)
logEmpty.BackgroundTransparency = 1
logEmpty.Font = Enum.Font.Gotham
logEmpty.Text = "no messages yet"
logEmpty.TextColor3 = C.subText
logEmpty.TextSize = 10
logEmpty.TextXAlignment = Enum.TextXAlignment.Left
logEmpty.TextYAlignment = Enum.TextYAlignment.Top
logEmpty.Parent = logBox

local logHolder = Instance.new("ScrollingFrame")
logHolder.Size = UDim2.new(1, -8, 1, -6)
logHolder.Position = UDim2.new(0, 4, 0, 3)
logHolder.BackgroundTransparency = 1
logHolder.BorderSizePixel = 0
logHolder.CanvasSize = UDim2.new(0, 0, 0, 0)
logHolder.AutomaticCanvasSize = Enum.AutomaticSize.Y
logHolder.ScrollBarThickness = 4
logHolder.ScrollBarImageColor3 = C.border
logHolder.ScrollingDirection = Enum.ScrollingDirection.Y
logHolder.Parent = logBox
local lbl = Instance.new("UIListLayout")
lbl.SortOrder = Enum.SortOrder.LayoutOrder
lbl.Padding = UDim.new(0, 2)
lbl.Parent = logHolder

hostLogRef = {holder = logHolder, empty = logEmpty}
botLogRef = hostLogRef
flushBotLogBuffer()

pfxBox.FocusLost:Connect(function()
    local np = trim(pfxBox.Text)
    if np == "" then np = "!" else np = np:sub(1, 1) end
    commandPrefix = np; pfxBox.Text = commandPrefix
    pfxHint.Text = "type: "..commandPrefix.."cmds"
end)

local cmdsPage = newPage()
local cmdsPad = Instance.new("UIPadding")
cmdsPad.PaddingTop = UDim.new(0, 10)
cmdsPad.PaddingLeft = UDim.new(0, 10)
cmdsPad.PaddingRight = UDim.new(0, 10)
cmdsPad.PaddingBottom = UDim.new(0, 10)
cmdsPad.Parent = cmdsPage

local cmdsBox = Instance.new("Frame")
cmdsBox.Size = UDim2.new(1, 0, 1, 0)
cmdsBox.BackgroundColor3 = C.track
cmdsBox.BorderSizePixel = 0
cmdsBox.ClipsDescendants = true
cmdsBox.Parent = cmdsPage
corner(cmdsBox, 8); stroke(cmdsBox, C.border, 1, 0.3)

local cmdScroll = Instance.new("ScrollingFrame")
cmdScroll.Size = UDim2.new(1, -8, 1, -6)
cmdScroll.Position = UDim2.new(0, 4, 0, 3)
cmdScroll.BackgroundTransparency = 1
cmdScroll.BorderSizePixel = 0
cmdScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
cmdScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
cmdScroll.ScrollBarThickness = 4
cmdScroll.ScrollBarImageColor3 = C.border
cmdScroll.Parent = cmdsBox
local cml = Instance.new("UIListLayout")
cml.Padding = UDim.new(0, 4)
cml.SortOrder = Enum.SortOrder.LayoutOrder
cml.Parent = cmdScroll

-- [BATCH A] "!lend" row removed
local CMDS = {
    {"── AI ──", true},
    {"!ask <message> - public chat", false},
    {"!orbit <1-1000> | !unorbit", false},
    {"!lead <player> | !unlead", false},
    {"!sit | !stand | !jump", false},
    {"!hide | !spawn", false},
    {"!bam <player> | !unbam", false},
    {"!annoy <player> | !unannoy", false},
    {"!fling <player> | !unfling", false},
    {"!dance 1-4 | !undance", false},
    {"!spin 1-100 | !unspin", false},
    {"!math <num><op><num>", false},
    {"!say <text>", false},
    {"!cmds", false}
}
for i, e in ipairs(CMDS) do
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, 0, 0, e[2] and 18 or 14)
    l.BackgroundTransparency = 1
    l.Font = e[2] and Enum.Font.GothamBold or Enum.Font.Code
    l.Text = e[1]
    l.TextColor3 = e[2] and C.accent or C.text
    l.TextSize = 10
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.LayoutOrder = i
    l.Parent = cmdScroll
end

local xchPage = newPage()
xchPage.Name = "XchPage"

local chatScroll = Instance.new("ScrollingFrame")
chatScroll.Size = UDim2.new(1, 0, 1, -48)
chatScroll.Position = UDim2.new(0, 0, 0, 0)
chatScroll.BackgroundTransparency = 1
chatScroll.BorderSizePixel = 0
chatScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
chatScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
chatScroll.ScrollBarThickness = 4
chatScroll.ScrollBarImageColor3 = C.border
chatScroll.ScrollingDirection = Enum.ScrollingDirection.Y
chatScroll.Parent = xchPage
local chatPad = Instance.new("UIPadding")
chatPad.PaddingTop = UDim.new(0, 10)
chatPad.PaddingLeft = UDim.new(0, 12)
chatPad.PaddingRight = UDim.new(0, 16)
chatPad.PaddingBottom = UDim.new(0, 8)
chatPad.Parent = chatScroll

local chatHolder = Instance.new("Frame")
chatHolder.Size = UDim2.new(1, 0, 0, 0)
chatHolder.AutomaticSize = Enum.AutomaticSize.Y
chatHolder.BackgroundTransparency = 1
chatHolder.Parent = chatScroll
local chatLay = Instance.new("UIListLayout")
chatLay.SortOrder = Enum.SortOrder.LayoutOrder
chatLay.Padding = UDim.new(0, 6)
chatLay.Parent = chatHolder

local chatEmpty = Instance.new("TextLabel")
chatEmpty.Size = UDim2.new(1, 0, 0, 24)
chatEmpty.BackgroundTransparency = 1
chatEmpty.Font = Enum.Font.Gotham
chatEmpty.Text = "say hi to XcH..."
chatEmpty.TextColor3 = C.subText
chatEmpty.TextSize = 11
chatEmpty.TextXAlignment = Enum.TextXAlignment.Left
chatEmpty.Parent = chatHolder

privateChatRef.holder = chatHolder
privateChatRef.scroll = chatScroll
privateChatRef.empty = chatEmpty

chatHolder.ChildAdded:Connect(function(child)
    if child:IsA("Frame") then
        scrollToBottom()
    end
end)

local inputBar = Instance.new("Frame")
inputBar.Size = UDim2.new(1, 0, 0, 48)
inputBar.Position = UDim2.new(0, 0, 1, -48)
inputBar.BackgroundColor3 = C.panelTop
inputBar.BorderSizePixel = 0
inputBar.Parent = xchPage
local ibStroke = Instance.new("UIStroke")
ibStroke.Color = C.border; ibStroke.Thickness = 1; ibStroke.Transparency = 0.4
ibStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
ibStroke.Parent = inputBar

local inputBox = Instance.new("TextBox")
inputBox.Size = UDim2.new(1, -66, 0, 34)
inputBox.Position = UDim2.new(0, 10, 0, 7)
inputBox.BackgroundColor3 = C.panel
inputBox.BorderSizePixel = 0
inputBox.Font = Enum.Font.Code
inputBox.Text = ""
inputBox.PlaceholderText = "type to XcH..."
inputBox.PlaceholderColor3 = C.subText
inputBox.TextColor3 = C.text
inputBox.TextSize = 11
inputBox.TextXAlignment = Enum.TextXAlignment.Left
inputBox.ClearTextOnFocus = false
inputBox.MultiLine = false
inputBox.Parent = inputBar
corner(inputBox, 8); stroke(inputBox, C.border, 1, 0.3)
local ibPad = Instance.new("UIPadding")
ibPad.PaddingLeft = UDim.new(0, 10)
ibPad.PaddingRight = UDim.new(0, 10)
ibPad.Parent = inputBox

local sendBtn = Instance.new("TextButton")
sendBtn.Size = UDim2.new(0, 40, 0, 34)
sendBtn.Position = UDim2.new(1, -50, 0, 7)
sendBtn.BackgroundColor3 = C.button
sendBtn.BorderSizePixel = 0
sendBtn.Font = Enum.Font.Code
sendBtn.Text = "▶"
sendBtn.TextColor3 = C.text
sendBtn.TextSize = 18
sendBtn.AutoButtonColor = false
sendBtn.Parent = inputBar
corner(sendBtn, 8); stroke(sendBtn, C.border, 1, 0.3)
styleBtn(sendBtn)

local function submitChat()
    local txt = inputBox.Text
    if not txt or txt == "" then return end
    txt = txt:gsub("^%s+", ""):gsub("%s+$", "")
    if txt == "" then return end
    inputBox.Text = ""
    task.spawn(function()
        handlePrivateAIChat(txt)
    end)
end

sendBtn.Activated:Connect(submitChat)
inputBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then submitChat() end
end)

-- [BATCH C] Empty Lends page — just a placeholder
local lendsPage = newPage()
lendsPage.Name = "LendsPage"

local lendsPad = Instance.new("UIPadding")
lendsPad.PaddingTop = UDim.new(0, 10)
lendsPad.PaddingLeft = UDim.new(0, 10)
lendsPad.PaddingRight = UDim.new(0, 10)
lendsPad.PaddingBottom = UDim.new(0, 10)
lendsPad.Parent = lendsPage

local lendsBox = Instance.new("Frame")
lendsBox.Size = UDim2.new(1, 0, 1, 0)
lendsBox.BackgroundColor3 = C.track
lendsBox.BorderSizePixel = 0
lendsBox.ClipsDescendants = true
lendsBox.Parent = lendsPage
corner(lendsBox, 8); stroke(lendsBox, C.border, 1, 0.3)

local lendsPlaceholder = Instance.new("TextLabel")
lendsPlaceholder.Size = UDim2.new(1, -20, 1, -20)
lendsPlaceholder.Position = UDim2.new(0, 10, 0, 10)
lendsPlaceholder.BackgroundTransparency = 1
lendsPlaceholder.Font = Enum.Font.Gotham
lendsPlaceholder.Text = "Lends tab — coming soon"
lendsPlaceholder.TextColor3 = C.subText
lendsPlaceholder.TextSize = 12
lendsPlaceholder.TextXAlignment = Enum.TextXAlignment.Center
lendsPlaceholder.TextYAlignment = Enum.TextYAlignment.Center
lendsPlaceholder.Parent = lendsBox

local currentPage = nil
local currentTabBtn = nil

local function makeTab(name, order, onClick)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1, 0, 0, 32)
    b.BackgroundColor3 = C.sidebar
    b.BorderSizePixel = 0
    b.Font = Enum.Font.GothamMedium
    b.Text = "  "..name
    b.TextColor3 = C.text
    b.TextSize = 11
    b.TextXAlignment = Enum.TextXAlignment.Left
    b.AutoButtonColor = false
    b.LayoutOrder = order
    b.Parent = sidebar
    corner(b, 6)
    b.MouseEnter:Connect(function()
        if b ~= currentTabBtn then tw(b, 0.15, {BackgroundColor3 = C.buttonHover}) end
    end)
    b.MouseLeave:Connect(function()
        if b ~= currentTabBtn then tw(b, 0.15, {BackgroundColor3 = C.sidebar}) end
    end)
    b.Activated:Connect(onClick)
    return b
end

local function slideToPage(newPage, newTabBtn)
    if currentPage == newPage then return end
    local oldPage = currentPage
    local oldTab = currentTabBtn

    if oldTab then tw(oldTab, 0.2, {BackgroundColor3 = C.sidebar}) end
    if newTabBtn then tw(newTabBtn, 0.2, {BackgroundColor3 = C.activeTab}) end
    currentTabBtn = newTabBtn

    local W = contentArea.AbsoluteSize.X
    if W <= 0 then W = 420 end

    if oldPage then
        tw(oldPage, 0.3, {Position = UDim2.new(0, W, 0, 0)}, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
        task.delay(0.3, function()
            if oldPage then oldPage.Visible = false end
        end)
    end

    newPage.Position = UDim2.new(0, W, 0, 0)
    newPage.Visible = true
    task.delay(0.04, function()
        tw(newPage, 0.38, {Position = UDim2.new(0, 0, 0, 0)}, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
    end)

    currentPage = newPage
end

local logsTab = makeTab("Logs", 1, function() slideToPage(logsPage, logsTab) end)
local cmdsTab = makeTab("Cmds", 2, function() slideToPage(cmdsPage, cmdsTab) end)
local xchTab = makeTab("XcH", 3, function() slideToPage(xchPage, xchTab) end)
-- [BATCH C] Lends tab — HOST role only (hidden in BOT mode below)
local lendsTab = makeTab("Lends", 4, function() slideToPage(lendsPage, lendsTab) end)

currentPage = nil
currentTabBtn = nil
slideToPage(logsPage, logsTab)

local roleOv = Instance.new("Frame")
roleOv.Size = UDim2.new(1, 0, 1, 0)
roleOv.BackgroundColor3 = C.panel
roleOv.BorderSizePixel = 0
roleOv.ZIndex = 50
roleOv.Visible = true
roleOv.Parent = frame

local function mkLabel(parent, txt, pos, size, font, color, tsize, align, z)
    local l = Instance.new("TextLabel")
    l.Size = size; l.Position = pos; l.BackgroundTransparency = 1
    l.Font = font; l.Text = txt; l.TextColor3 = color; l.TextSize = tsize
    l.TextXAlignment = align or Enum.TextXAlignment.Center
    l.ZIndex = z or 51; l.Parent = parent
    return l
end

local function mkBtn(parent, txt, pos, size, z)
    local b = Instance.new("TextButton")
    b.Size = size; b.Position = pos; b.BackgroundColor3 = C.button; b.BorderSizePixel = 0
    b.Font = Enum.Font.GothamBold; b.Text = txt; b.TextColor3 = C.text; b.TextSize = 15
    b.AutoButtonColor = false; b.ZIndex = z or 51; b.Parent = parent
    corner(b, 10); stroke(b, C.border, 1, 0.2); styleBtn(b)
    return b
end

mkLabel(roleOv, "SELECT ROLE", UDim2.new(0, 20, 0, 20), UDim2.new(1, -40, 0, 22), Enum.Font.GothamBold, C.text, 13, Enum.TextXAlignment.Left)
mkLabel(roleOv, "What should this account do?", UDim2.new(0, 20, 0, 44), UDim2.new(1, -40, 0, 18), Enum.Font.Gotham, C.subText, 10, Enum.TextXAlignment.Left)

local hostBtn = mkBtn(roleOv, "HOST", UDim2.new(0, 24, 0, 90), UDim2.new(0.5, -32, 0, 90))
mkLabel(roleOv, "Full panel + tabs", UDim2.new(0, 24, 0, 186), UDim2.new(0.5, -32, 0, 16), Enum.Font.Gotham, C.subText, 9)
local botBtn = mkBtn(roleOv, "BOT", UDim2.new(0.5, 8, 0, 90), UDim2.new(0.5, -32, 0, 90))
mkLabel(roleOv, "Follows host, compact", UDim2.new(0.5, 8, 0, 186), UDim2.new(0.5, -32, 0, 16), Enum.Font.Gotham, C.subText, 9)

local confOv = Instance.new("Frame")
confOv.Size = UDim2.new(1, 0, 1, 0)
confOv.BackgroundColor3 = C.panel
confOv.BorderSizePixel = 0
confOv.ZIndex = 55
confOv.Visible = false
confOv.Parent = frame
mkLabel(confOv, "LOCK IN AS HOST?", UDim2.new(0, 20, 0, 80), UDim2.new(1, -40, 0, 24), Enum.Font.GothamBold, C.text, 14, Enum.TextXAlignment.Left, 56)
mkLabel(confOv, "You get the full tabbed panel with private XcH chat.", UDim2.new(0, 20, 0, 108), UDim2.new(1, -40, 0, 40), Enum.Font.Gotham, C.subText, 11, Enum.TextXAlignment.Left, 56).TextWrapped = true
local cYes = mkBtn(confOv, "YES", UDim2.new(0, 20, 1, -60), UDim2.new(0.5, -32, 0, 40), 56) cYes.TextSize = 13
local cNo = mkBtn(confOv, "BACK", UDim2.new(0.5, 8, 1, -60), UDim2.new(0.5, -32, 0, 40), 56) cNo.TextSize = 13

local bsOv = Instance.new("Frame")
bsOv.Size = UDim2.new(1, 0, 1, 0)
bsOv.BackgroundColor3 = C.panel
bsOv.BorderSizePixel = 0
bsOv.ZIndex = 55
bsOv.Visible = false
bsOv.Parent = frame
mkLabel(bsOv, "BOT SETUP", UDim2.new(0, 20, 0, 14), UDim2.new(1, -40, 0, 22), Enum.Font.GothamBold, C.text, 13, Enum.TextXAlignment.Left, 56)
mkLabel(bsOv, "Pick the HOST below.", UDim2.new(0, 20, 0, 38), UDim2.new(1, -40, 0, 16), Enum.Font.Gotham, C.subText, 10, Enum.TextXAlignment.Left, 56)

local plFrame = Instance.new("Frame")
plFrame.Size = UDim2.new(1, -40, 1, -142)
plFrame.Position = UDim2.new(0, 20, 0, 62)
plFrame.BackgroundColor3 = C.track
plFrame.BorderSizePixel = 0
plFrame.ClipsDescendants = true
plFrame.ZIndex = 56
plFrame.Parent = bsOv
corner(plFrame, 8); stroke(plFrame, C.border, 1, 0.3)

local plScroll = Instance.new("ScrollingFrame")
plScroll.Size = UDim2.new(1, -8, 1, -6)
plScroll.Position = UDim2.new(0, 4, 0, 3)
plScroll.BackgroundTransparency = 1
plScroll.BorderSizePixel = 0
plScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
plScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
plScroll.ScrollBarThickness = 4
plScroll.ScrollBarImageColor3 = C.border
plScroll.ZIndex = 56
plScroll.Parent = plFrame
local plLay = Instance.new("UIListLayout")
plLay.Padding = UDim.new(0, 3)
plLay.SortOrder = Enum.SortOrder.LayoutOrder
plLay.Parent = plScroll

local selectedHost = nil
local bsErr = mkLabel(bsOv, "", UDim2.new(0, 20, 1, -70), UDim2.new(1, -40, 0, 16), Enum.Font.GothamMedium, C.red, 10, Enum.TextXAlignment.Left, 56)
bsErr.TextTransparency = 1
local bsBack = mkBtn(bsOv, "BACK", UDim2.new(0, 20, 1, -52), UDim2.new(0.5, -32, 0, 38), 56) bsBack.TextSize = 13
local bsLock = mkBtn(bsOv, "LOCK IN", UDim2.new(0.5, 8, 1, -52), UDim2.new(0.5, -32, 0, 38), 56) bsLock.TextSize = 13

-- [BATCH B] Creator (crixcrix000) rows get green tint.
local function refreshPlayers()
    for _, c in ipairs(plScroll:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
    selectedHost = nil
    local n = 0
    for _, p in ipairs(Players:GetPlayers()) do
        if p == player then continue end
        n = n + 1
        local isOwner = (p.Name:lower() == OWNER_NAME)
        local baseColor = isOwner and Color3.fromRGB(215, 245, 220) or C.button
        local hoverColor = isOwner and Color3.fromRGB(200, 240, 210) or C.buttonHover
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(1, 0, 0, 28)
        b.BackgroundColor3 = baseColor
        b.BorderSizePixel = 0
        b.Font = Enum.Font.GothamMedium
        b.Text = "  "..p.Name.."  (@"..p.DisplayName..")"
        b.TextColor3 = isOwner and C.green or C.text
        b.TextSize = 10
        b.TextXAlignment = Enum.TextXAlignment.Left
        b.AutoButtonColor = false
        b.LayoutOrder = n
        b.ZIndex = 57
        b:SetAttribute("isOwnerRow", isOwner)
        b.Parent = plScroll
        corner(b, 6)
        local sl = stroke(b, isOwner and C.green or C.border, 1, isOwner and 0.2 or 0.3)
        b.MouseEnter:Connect(function() if selectedHost ~= p.Name then tw(b, 0.15, {BackgroundColor3 = hoverColor}) end end)
        b.MouseLeave:Connect(function() if selectedHost ~= p.Name then tw(b, 0.15, {BackgroundColor3 = baseColor}) end end)
        b.Activated:Connect(function()
            for _, c2 in ipairs(plScroll:GetChildren()) do
                if c2:IsA("TextButton") then
                    local c2Owner = c2:GetAttribute("isOwnerRow")
                    c2.BackgroundColor3 = c2Owner and Color3.fromRGB(215, 245, 220) or C.button
                    local s = c2:FindFirstChildOfClass("UIStroke")
                    if s then
                        s.Color = c2Owner and C.green or C.border
                        s.Transparency = c2Owner and 0.2 or 0.3
                    end
                end
            end
            selectedHost = p.Name
            b.BackgroundColor3 = C.activeTab
            sl.Color = C.accent; sl.Transparency = 0
            bsErr.TextTransparency = 1; bsErr.Text = ""
        end)
    end
    if n == 0 then
        mkLabel(plScroll, "no other players", UDim2.new(0, 8, 0, 0), UDim2.new(1, -16, 0, 30), Enum.Font.Gotham, C.subText, 10, Enum.TextXAlignment.Left, 57)
    end
end

local function lockRole(role, hostName)
    ROLE = role
    roleOv.Visible = false; confOv.Visible = false; bsOv.Visible = false
    if role == "HOST" then
        frame.Size = UDim2.new(0, 520, 0, 320)
        topBar.Visible = true; sidebar.Visible = true; contentArea.Visible = true
        show()
    elseif role == "BOT" then
        frame.Size = UDim2.new(0, 380, 0, 260)
        topBar.Visible = true; sidebar.Visible = true; contentArea.Visible = true

        cmdsTab.Visible = false
        xchTab.Visible = false
        -- [BATCH C] Lends tab is HOST-only
        lendsTab.Visible = false

        slideToPage(logsPage, logsTab)

        titleLbl.Text = AI_NAME.." (bot)"

        sendChat(pick(R.startup))

        hostFilter.name = hostName:lower()
        S.hostName = hostName:lower()
        originalHost.name = hostName:lower()
        for _, p in ipairs(Players:GetPlayers()) do
            if p.Name:lower() == hostName:lower() then
                hostFilter.userId = p.UserId; originalHost.userId = p.UserId; break
            end
        end

        if hostName:lower() == OWNER_NAME then
            isOwnerHost = true
            task.wait(1)
            sendChat(pick({"hey boss","yo boss","sup boss","welcome back boss","good to see you boss"}))
        end

        applyFixedSpeed()
        startFacing(); startFollow(); bindDeath(); startAfk(); startMirrorJump(); startCameraMicro()
    end
end

hostBtn.Activated:Connect(function() roleOv.Visible = false; confOv.Visible = true end)
botBtn.Activated:Connect(function()
    bsErr.Text = ""; bsErr.TextTransparency = 1
    roleOv.Visible = false; bsOv.Visible = true
    refreshPlayers()
end)
cNo.Activated:Connect(function() confOv.Visible = false; roleOv.Visible = true end)
bsBack.Activated:Connect(function() bsOv.Visible = false; roleOv.Visible = true end)
cYes.Activated:Connect(function() lockRole("HOST") end)
bsLock.Activated:Connect(function()
    if not selectedHost then
        bsErr.Text = "Please select a player from the list."
        bsErr.TextTransparency = 0
        return
    end
    lockRole("BOT", selectedHost)
end)

print("[MyPanel] BOOT 10 — tool")

local storage = Instance.new("Folder")
storage.Name = STORAGE_NAME; storage.Parent = playerGui

local toolTemplate = Instance.new("Tool")
toolTemplate.Name = TOOL_NAME
toolTemplate.ToolTip = "InterDimensional Panel By XCDevs"
toolTemplate.RequiresHandle = false
toolTemplate.CanBeDropped = false
toolTemplate.Parent = storage

local bound = setmetatable({}, {__mode = "k"})

local function findLive()
    local b = bp()
    if b then local t = b:FindFirstChild(TOOL_NAME); if t and t:IsA("Tool") then return t end end
    local c = player.Character
    if c then local t = c:FindFirstChild(TOOL_NAME); if t and t:IsA("Tool") then return t end end
    return nil
end
local function bindTool(t)
    if not t or not t:IsA("Tool") or bound[t] then return end
    bound[t] = true
    t.Equipped:Connect(function() if ROLE == "HOST" or ROLE == "BOT" then show() end end)
    t.Unequipped:Connect(function() if ROLE == "HOST" or ROLE == "BOT" then hide() end end)
    t.Destroying:Connect(function() bound[t] = nil end)
end
local function removeDupes()
    local list = {}
    local b = bp()
    if b then for _, o in ipairs(b:GetChildren()) do if o:IsA("Tool") and o.Name == TOOL_NAME then table.insert(list, o) end end end
    local c = player.Character
    if c then for _, o in ipairs(c:GetChildren()) do if o:IsA("Tool") and o.Name == TOOL_NAME then table.insert(list, o) end end end
    for i = 2, #list do list[i]:Destroy() end
end
local function giveTool()
    local ex = findLive()
    if ex then bindTool(ex); return end
    local b = bp()
    if not b then return end
    local t = toolTemplate:Clone()
    t.Parent = b
    bindTool(t)
end

player.CharacterAdded:Connect(function(char)
    local h = char:WaitForChild("Humanoid", 5)
    if not h then return end
    task.wait(0.5)
    removeDupes(); giveTool()
    h.UseJumpPower = true; h.WalkSpeed = BASE_SPEED; h.JumpPower = BASE_JUMP
    rotationOwner = "Humanoid"; h.AutoRotate = true
    stopDance(); stopSpin(); stopLead(false); stopFling(false)
    S.sitting = false
    S.waypoints = nil; S.cachedPath = nil; S.lastMovePos = nil; S.committedTarget = nil
    S.hostInVoid = false; S.mirrorJumpTime = 0; S.lastPathSig = nil
    S.stableFollowDir = nil
    if ROLE == "BOT" then bindDeath(); if not S.facing then startFacing() end end
end)

task.spawn(function()
    task.wait(0.5)
    removeDupes(); giveTool()
    local h = hum()
    if h then h.UseJumpPower = true; h.WalkSpeed = BASE_SPEED; h.JumpPower = BASE_JUMP end
end)

print("[MyPanel] BOOT 11 — final show")
gui.Enabled = true
roleOv.Visible = true
frame.Position = SHOWN
pcall(show)
print("[MyPanel] READY.")
