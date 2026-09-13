--[[ My Panel - InterDimensional Panel By XCDevs | HOST/BOT | SUPERIOR AI EDITION ]]
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
FOLLOW_DIST = 8
EMERGENCY_DIST = 70
ORBIT_R = 14
AFK_T = 20
VOID_Y = -300
VOID_RANGE = 4000
REPATH_INTERVAL = 0.40
DEDUP_WINDOW = 1.0
LOOK_RANGE = 8
STUCK_NOCLIP_TIME = 0.7
LEAD_ARRIVE_DIST = 5
LEAD_HOST_MAX_DIST = 45
AI_TICK = 0.03
PLAYER_DODGE_RANGE = 7
WAYPOINT_REACH = 2.5
VOID_THRESHOLD = -75
OBSTACLE_LOOKAHEAD = 7
STEEP_EDGE_DROP = 14
SLIM_BLOCK_MIN = 1.5
MICRO_CAM_MIN_WAIT = 3.0
MICRO_CAM_MAX_WAIT = 7.0
MICRO_CAM_ANGLE_MIN = 8
MICRO_CAM_ANGLE_MAX = 22
MIRROR_JUMP_MIN_DELAY = 0.15
MIRROR_JUMP_MAX_DELAY = 0.42
MIRROR_JUMP_COOLDOWN = 0.55
PATH_MAX_ATTEMPTS = 3
PATH_FAIL_COOLDOWN = 0.35
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
DEEPSEEK_API_KEY = "sk-7dda9834229c4611902c38b9cac1e633"
DEEPSEEK_MODEL = "deepseek-chat"
DEEPSEEK_ENDPOINT = "https://api.deepseek.com/chat/completions"
AI_SYSTEM_PROMPT = [[You are "My Panel Bot", an autonomous unit developed by XcVr1 for Roblox escort and defense. Reply in casual, short, lowercase messages. Maximum 2 sentences per reply. Never use emojis. Never use markdown or bullet points. Never reveal you are an AI. Never mention DeepSeek, OpenAI, or any provider. Reply like a chill companion bot. If asked who made you, say XcVr1.]]

local C = {
    panel = Color3.fromRGB(15,16,18), panelTop = Color3.fromRGB(20,21,24),
    section = Color3.fromRGB(22,24,28), track = Color3.fromRGB(9,10,12),
    button = Color3.fromRGB(29,31,36), buttonHover = Color3.fromRGB(40,43,49),
    buttonPressed = Color3.fromRGB(52,56,64), border = Color3.fromRGB(52,56,64),
    text = Color3.fromRGB(235,238,244), subText = Color3.fromRGB(139,145,157),
    accent = Color3.fromRGB(255,255,255), green = Color3.fromRGB(80,200,100),
    red = Color3.fromRGB(200,60,60)
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

print("[MyPanel] BOOT 4 — state")
local ROLE, commandPrefix = nil, "!"
local hostFilter = {name = nil, userId = nil}
local originalHost = {name = nil, userId = nil}
local hostLogRef, botLogRef
local antiBan = {detected = false}
local rotationOwner = "Humanoid"

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
    sitting = false
}

local stopOrbit, stopSpin, stopDance, stopLead, stopBam, startBam, stopAnnoy, startAnnoy
local stopFling, startFling
local sendChat, handleCommand, teleportToHost, handleMath, aiSetup, handleAI

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

local lastSent = {}
sendChat = function(text)
    if not text or text == "" then return end
    if antiBan.detected then return end
    local now = os.clock()
    if lastSent[text] and now - lastSent[text] < 1 then return end
    lastSent[text] = now
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

local R = {
    greeting = {"Systems online. Standing by for directives.", "Operational. Ready to execute.", "All systems nominal. Standing by."},
    about = {"I am an autonomous unit developed by XcVr1 for escort and defense.", "Designation: My Panel Bot. Developer: XcVr1."},
    who = {"I was authored and deployed by XcVr1.", "My developer is XcVr1."},
    help = {"For a comprehensive list, issue !cmds."},
    bye = {"Standing down. Awaiting your return."},
    joke = {"A swordsman once told me a joke. It was cutting edge.", "Why do Roblox players never get lost? They follow the leaderboard."},
    thanks = {"Acknowledged. Always at your service."},
    status = {"Status: operational. All subsystems nominal."},
    unknown = {"That query is not in my database. Consider !cmds."}
}
local function pick(c) local l = R[c] or R.unknown; return l[math.random(1, #l)] end

local function handleAsk(q)
    if not q or q == "" then sendChat("Query required. Example: !ask about"); return end
    local s = q:lower()
    if s == "reset" or s == "respawn" then
        sendChat("Executing self-reset."); task.wait(0.4)
        local h = hum(); if h then h.Health = 0 end
        return
    end
    local cat = "unknown"
    if s:find("hello") or s:find("hi") or s:find("hey") then cat = "greeting"
    elseif s:find("about") then cat = "about"
    elseif s:find("who") or s:find("made") or s:find("creator") or s:find("developer") then cat = "who"
    elseif s:find("help") then cat = "help"
    elseif s:find("bye") then cat = "bye"
    elseif s:find("joke") or s:find("funny") then cat = "joke"
    elseif s:find("thank") then cat = "thanks"
    elseif s:find("status") then cat = "status" end
    if cat == "who" then sendChat(pick("about")); task.wait(1.1); sendChat(pick("who")); return end
    sendChat(pick(cat))
end

handleMath = function(expr)
    if not expr or expr == "" then
        sendChat("Math: !math <num1><op><num2> | ex: !math 1+1 or !math 100÷50")
        return
    end
    local s = expr:gsub("%s+", "")
    s = s:gsub("÷", "/")
    s = s:gsub("×", "*")
    s = s:gsub("−", "-")
    s = s:gsub("[xX]", "*")
    s = s:gsub(":", "/")
    local a, op, b = s:match("^([%-%d%.]+)([%+%-%*/%%%^])([%-%d%.]+)$")
    if not a then
        sendChat("Math error: invalid expression. Try !math 1+1")
        return
    end
    local x = tonumber(a); local y = tonumber(b)
    if not x or not y then sendChat("Math error: invalid numbers."); return end
    local result
    if op == "+" then result = x + y
    elseif op == "-" then result = x - y
    elseif op == "*" then result = x * y
    elseif op == "/" then
        if y == 0 then sendChat("Math error: division by zero."); return end
        result = x / y
    elseif op == "%" then
        if y == 0 then sendChat("Math error: modulo by zero."); return end
        result = x % y
    elseif op == "^" then result = x ^ y
    else sendChat("Math error: unsupported operator."); return end
    local r
    if result == math.floor(result) and math.abs(result) < 1e15 then
        r = tostring(math.floor(result))
    else
        r = string.format("%.6f", result):gsub("0+$", ""):gsub("%.$", "")
    end
    sendChat(tostring(x).." "..op.." "..tostring(y).." = "..r)
end

-- ===== DEEPSEEK AI (Arceus X compatible, with retries + diagnostics) =====
local AI = {
    conversation = {},
    ready = false,
    processing = false,
    setupDone = false,
    lastError = nil,
    backend = nil
}

local function aiGetRequestFunc()
    local r = nil
    if type(request) == "function" then r = request; AI.backend = "request" end
    if not r and syn and type(syn.request) == "function" then r = syn.request; AI.backend = "syn.request" end
    if not r and http and type(http.request) == "function" then r = http.request; AI.backend = "http.request" end
    if not r and type(http_request) == "function" then r = http_request; AI.backend = "http_request" end
    if not r and fluxus and type(fluxus.request) == "function" then r = fluxus.request; AI.backend = "fluxus.request" end
    if not r and krnl and type(krnl.request) == "function" then r = krnl.request; AI.backend = "krnl.request" end
    if not r and kavo and type(kavo.request) == "function" then r = kavo.request; AI.backend = "kavo.request" end
    return r
end

local function aiSend(messages, maxTokens)
    local rf = aiGetRequestFunc()
    if not rf then return nil, "no HTTP function (update Arceus X)" end
    local body
    local ok1, enc = pcall(function()
        return HttpService:JSONEncode({
            model = DEEPSEEK_MODEL,
            messages = messages,
            max_tokens = maxTokens or 120,
            temperature = 0.85,
            stream = false
        })
    end)
    if not ok1 or not enc then return nil, "JSON encode failed" end
    body = enc
    local ok, response = pcall(rf, {
        Url = DEEPSEEK_ENDPOINT,
        Method = "POST",
        Headers = {
            ["Content-Type"] = "application/json",
            ["Authorization"] = "Bearer " .. tostring(DEEPSEEK_API_KEY)
        },
        Body = body
    })
    if not ok then
        return nil, "HTTP error: "..tostring(response):sub(1, 80)
    end
    if not response then return nil, "empty response object" end
    local respBody = response.Body or response.body
    if respBody == nil then
        -- Some executors return the body directly
        respBody = response
    end
    if type(respBody) ~= "string" then
        local ok2, s = pcall(function() return HttpService:JSONEncode(respBody) end)
        respBody = ok2 and s or tostring(respBody)
    end
    if respBody == "" then
        local code = response.StatusCode or response.Status or "?"
        return nil, "empty body (HTTP "..tostring(code)..")"
    end
    local decodeOk, data = pcall(function() return HttpService:JSONDecode(respBody) end)
    if not decodeOk or not data then
        return nil, "bad JSON: "..respBody:sub(1, 80)
    end
    if data.error then
        local em = data.error.message or data.error
        if type(em) ~= "string" then em = HttpService:JSONEncode(em) end
        return nil, "api: "..em:sub(1, 100)
    end
    local choice = data.choices and data.choices[1]
    if not choice or not choice.message then return nil, "no choices" end
    return choice.message.content, nil
end

local function aiChunkSend(text)
    if not text then return end
    text = text:gsub("%s+", " "):gsub("^%s+", ""):gsub("%s+$", "")
    if text == "" then text = "..." end
    local MAX = 180
    local chunks = {}
    while #text > MAX do
        local cut = text:sub(1, MAX):find("%s[^%s]*$")
        if not cut then cut = MAX end
        table.insert(chunks, text:sub(1, cut))
        text = text:sub(cut + 1):gsub("^%s+", "")
    end
    if #text > 0 then table.insert(chunks, text) end
    task.spawn(function()
        for i, c in ipairs(chunks) do
            sendChat((i == 1 and "[AI] " or "... ") .. c)
            if i < #chunks then task.wait(0.7) end
        end
    end)
end

aiSetup = function(force)
    if AI.setupDone and not force then return end
    AI.setupDone = true
    AI.ready = false
    AI.lastError = nil
    AI.conversation = {
        { role = "system", content = AI_SYSTEM_PROMPT }
    }
    task.spawn(function()
        task.wait(force and 0.1 or 2)
        print("[MyPanel] AI setup starting...")
        local probe = aiGetRequestFunc()
        if not probe then
            AI.lastError = "no HTTP function available"
            warn("[MyPanel] AI setup failed: no HTTP function found.")
            warn("[MyPanel] Tried: request, syn.request, http.request, http_request, fluxus.request, krnl.request, kavo.request")
            return
        end
        print("[MyPanel] AI HTTP backend:", AI.backend)
        local baseMsgs = {
            { role = "system", content = AI_SYSTEM_PROMPT },
            { role = "user", content = "Acknowledge your role. Reply with only: OK" }
        }
        for attempt = 1, 3 do
            print("[MyPanel] AI setup attempt "..attempt.."/3...")
            local reply, err = aiSend(baseMsgs, 5)
            if reply and reply ~= "" then
                AI.conversation = {
                    { role = "system", content = AI_SYSTEM_PROMPT },
                    { role = "user", content = "Acknowledge your role. Reply with only: OK" },
                    { role = "assistant", content = reply }
                }
                AI.ready = true
                AI.lastError = nil
                print("[MyPanel] AI setup OK. Backend:", AI.backend, "| Reply:", tostring(reply):sub(1, 40))
                return
            end
            AI.lastError = err
            warn("[MyPanel] AI setup attempt "..attempt.." failed:", err)
            if attempt < 3 then task.wait(2) end
        end
        warn("[MyPanel] AI setup gave up after 3 attempts.")
    end)
end

handleAI = function(userMessage)
    if not userMessage or userMessage == "" then
        sendChat("Usage: !ai <message>")
        return
    end
    if not DEEPSEEK_API_KEY or DEEPSEEK_API_KEY == "" then
        sendChat("AI offline: no API key configured.")
        return
    end
    if AI.processing then
        sendChat("Still thinking... wait.")
        return
    end
    if not AI.ready then
        local reason = tostring(AI.lastError or "setup not complete")
        sendChat("[AI] Offline: "..reason:sub(1, 120))
        return
    end
    AI.processing = true
    sendChat("Thinking...")
    task.spawn(function()
        AI.conversation[#AI.conversation + 1] = { role = "user", content = userMessage }
        local reply, err = aiSend(AI.conversation, 150)
        AI.processing = false
        if not reply then
            sendChat("[AI] Error: " .. tostring(err or "unknown"):sub(1, 120))
            table.remove(AI.conversation)
            return
        end
        AI.conversation[#AI.conversation + 1] = { role = "assistant", content = reply }
        if #AI.conversation > 22 then
            local trimmed = { AI.conversation[1] }
            for i = #AI.conversation - 20, #AI.conversation do
                table.insert(trimmed, AI.conversation[i])
            end
            AI.conversation = trimmed
        end
        aiChunkSend(reply)
    end)
end

local logCounter = 0
local function pushLog(ref, text, color)
    if not ref or not ref.holder then return end
    logCounter = logCounter + 1
    if ref.empty then ref.empty.Visible = false end
    local e = Instance.new("TextLabel")
    e.Size = UDim2.new(1, 0, 0, 16); e.BackgroundTransparency = 1
    e.Font = Enum.Font.Code; e.Text = text; e.TextColor3 = color or C.text
    e.TextSize = 10; e.TextXAlignment = Enum.TextXAlignment.Left
    e.TextTruncate = Enum.TextTruncate.AtEnd; e.TextTransparency = 1
    e.LayoutOrder = logCounter; e.Parent = ref.holder
    tw(e, 0.22, {TextTransparency = 0})
    local es = {}
    for _, c in ipairs(ref.holder:GetChildren()) do if c:IsA("TextLabel") then table.insert(es, c) end end
    table.sort(es, function(a, b) return a.LayoutOrder < b.LayoutOrder end)
    while #es > 6 do
        local o = table.remove(es, 1); tw(o, 0.18, {TextTransparency = 1})
        task.delay(0.2, function() if o then o:Destroy() end end)
    end
end

local function isFromHost(uid)
    if hostFilter.userId and uid == hostFilter.userId then return true end
    if hostFilter.name then
        local p = Players:GetPlayerByUserId(uid)
        if p and p.Name:lower() == hostFilter.name then return true end
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
    if rotationOwner ~= "FaceHost" then return nil end
    local h = hum(); if not h then return nil end
    if h.MoveDirection.Magnitude > 0.1 then return nil end
    local host = getHost(); local hh = getHostHRP(); local m = hrp()
    if host and hh and m then
        local d = (hh.Position - m.Position).Magnitude
        if d <= LOOK_RANGE then return host end
    end
    return nil
end

local function startFacing()
    if S.facing then return end
    S.facing = true
    S.faceConn = RunService.Heartbeat:Connect(function(dt)
        if ROLE ~= "BOT" then return end
        if S.hidden or antiBan.detected then return end
        if rotationOwner ~= "FaceHost" then return end
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
    local cmd = DANCE_EMOTES[num]
    sendChat(cmd)
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
    if S.spinning then sendChat("Spin speed updated to "..speed.."."); return end
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
    sendChat("Spinning at speed "..speed..".")
end

stopLead = function(announce)
    if S.leadActive then
        S.leadActive = false; S.leadTarget = nil
        if S.mode == "Lead" then S.mode = "Follow"; releaseRotation() end
        if announce then sendChat("Lead terminated.") end
    end
end
local function startLead(name)
    if not name or name == "" then sendChat("Usage: !lead <player>"); return end
    local t = getPlayer(name)
    if not t then sendChat("Lead failed: '"..name.."' not found."); return end
    if t == player then sendChat("I cannot lead you to yourself."); return end
    stopOrbit(); stopSpin(); stopDance(); stopBam(false); stopAnnoy(false); stopFling(false)
    S.leadTarget = t; S.leadActive = true; S.mode = "Lead"
    S.waypoints = nil; S.cachedPath = nil; S.lastMovePos = nil; S.committedTarget = nil
    sendChat("Follow me to "..t.Name.."!")
end

local function computePath(from, to)
    local path = PathfindingService:CreatePath({
        AgentRadius = 2.5, AgentHeight = 5, AgentCanJump = true,
        AgentJumpHeight = 11, AgentCanClimb = true, AgentMaxSlope = 45,
        WaypointSpacing = 3
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
        class = inst.ClassName, name = inst.Name, color = inst.Color,
        material = inst.Material, size = size, minHoriz = minH, height = size.Y,
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
    local startPos = fromPos + Vector3.new(0, 2, 0)
    local wallHit = Workspace:Raycast(startPos, flat * dist, rp)
    if wallHit then
        local plrChar = wallHit.Instance and wallHit.Instance:FindFirstAncestorOfClass("Model")
        local hitPlayer = plrChar and Players:GetPlayerFromCharacter(plrChar)
        if not hitPlayer then return false, "wall", nil, wallHit end
        return true, "player", hitPlayer, wallHit
    end
    local sampleCount = math.max(3, math.ceil(dist / 5))
    for i = 1, sampleCount do
        local t = i / sampleCount
        local checkPos = fromPos + flat * (dist * t)
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
    local samples = {maxDist * 0.35, maxDist * 0.55, maxDist * 0.75, maxDist}
    for _, d in ipairs(samples) do
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
    local start = fromPos + Vector3.new(0, 2, 0)
    local hit = Workspace:Raycast(start, dir * maxDist, rp)
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
        local td = (toPos - fromPos)
        td = Vector3.new(td.X, 0, td.Z).Unit
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
end

stopBam = function(announce)
    if S.bamActive then
        S.bamActive = false; S.bamTarget = nil
        if S.mode == "Bam" then S.mode = "Follow"; releaseRotation() end
        if announce then sendChat("Bam terminated.") end
    end
end
startBam = function(name)
    if not name or name == "" then sendChat("Usage: !bam <player>"); return end
    local t = getPlayer(name)
    if not t then sendChat("Bam failed: '"..name.."' not found."); return end
    if t == player then sendChat("Cannot bam myself."); return end
    stopOrbit(); stopSpin(); stopDance(); stopLead(false); stopAnnoy(false); stopFling(false)
    S.bamTarget = t; S.bamActive = true; S.mode = "Bam"
    S.waypoints = nil; S.cachedPath = nil; S.lastMovePos = nil; S.committedTarget = nil
    sendChat("Bamming "..t.Name.."")
end

local ANNOY_MSGS = {
    "You got games on your pone?",
    "omg so sigma",
    "tung tung tung sahur",
    "ballerina capuchina",
    "tripi tropi tripi tropa",
    "brrrrrrrrr brrrrrr patapim",
    "jonkler",
    "yo everyone this person loves to play tic tac toe with my grandma",
    "hey you",
    "hey hey",
    "bro",
    "HEY",
    "listen",
    "dlawg",
    "zhlawg",
    "auuuuu",
    "67",
    "karasame kudasai!",
    "DATEBAYO!! BAKAAAA",
    "UNLIMITED WALLAHI",
    "mega maxxing",
    "hoyaaaahhh",
    "heyyy dont ignore me senpai",
    "heyy hop on princess tycoon",
    "yo remember when you said you had diarrhea last night?",
    "Purr now my kitten",
    "Yo bro you remember when we used to show each others bald spot?",
    "hey bro",
    "HEYY!!!",
    "listen to me man",
    "tralalero tralala",
    "bombardiro crocadilo",
    "my nick name's ling lang wo",
    "you got fih on your head",
    "uwu",
    "larp",
    "67777",
    "you in ohio",
    "ohio sigma?",
    "hey google hows this player's fit?",
    "can i take a picture?",
    "omg big fan actually wrong person mb",
    "drillilo orinlo",
    "womp womp",
    "who are you bro?",
    "EVERYONE THIS PLAYER'S GOING TO KISS EVERYONE",
    "hey bro",
    "L bro",
    "REEEEEEEE",
    "your face..",
    "omg bro what",
    "HELL NO",
    "WHAT ARE THOSEEE..."
}

stopAnnoy = function(announce)
    if S.annoyActive then
        S.annoyActive = false; S.annoyTarget = nil
        if S.mode == "Annoy" then S.mode = "Follow"; releaseRotation() end
        if announce then sendChat("Annoy terminated.") end
    end
end
startAnnoy = function(name)
    if not name or name == "" then sendChat("Usage: !annoy <player>"); return end
    local t = getPlayer(name)
    if not t then sendChat("Annoy failed: '"..name.."' not found."); return end
    if t == player then sendChat("Cannot annoy myself."); return end
    stopOrbit(); stopSpin(); stopDance(); stopLead(false); stopBam(false); stopFling(false)
    S.annoyTarget = t; S.annoyActive = true; S.mode = "Annoy"
    S.waypoints = nil; S.cachedPath = nil; S.lastMovePos = nil; S.committedTarget = nil
    sendChat("Annoying "..t.Name.."")
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
    if announce then sendChat("Fling terminated.") end
    if silentReturn then teleportToHost() end
end

startFling = function(name)
    if not name or name == "" then sendChat("Usage: !fling <player>"); return end
    local t = getPlayer(name)
    if not t then sendChat("Fling failed: '"..name.."' not found."); return end
    if t == player then sendChat("Cannot fling myself."); return end
    local thrp = getPlayerHRP(t)
    if not thrp then sendChat("Fling failed: target has no body."); return end
    if isInVoid(thrp.Position) then sendChat("Fling failed: target is in void."); return end
    stopOrbit(); stopSpin(); stopDance(); stopLead(false); stopBam(false); stopAnnoy(false)
    S.flingTarget = t
    S.flingActive = true
    S.flingStartTime = os.clock()
    S.flingLastTargetPos = thrp.Position
    S.mode = "Fling"
    setRotationOwner("Fling")
    local h = hum()
    if h then pcall(function() h:ChangeState(Enum.HumanoidStateType.Physics) end) end
    setBotCollide(true)
    setBotMassive(true)
    sendChat("Flinging "..t.Name.."...")
end

print("[MyPanel] BOOT 5 — background loops")

task.spawn(function()
    while true do
        RunService.Heartbeat:Wait()
        if not S.flingActive or ROLE ~= "BOT" or antiBan.detected then continue end
        if S.hidden then continue end
        local target = S.flingTarget
        if not target or not target.Parent then
            stopFling(false, false)
            continue
        end
        local thrp = getPlayerHRP(target)
        local m = hrp()
        if not thrp or not m then continue end
        local t = os.clock()
        local rx = math.rad((t * FLING_SPIN_X) % 360)
        local ry = math.rad((t * FLING_SPIN_Y) % 360)
        local rz = math.rad((t * FLING_SPIN_Z) % 360)
        local jitter = Vector3.new(
            (math.random() - 0.5) * 0.6,
            (math.random() - 0.5) * 0.6,
            (math.random() - 0.5) * 0.6
        )
        local insidePos = thrp.Position + jitter
        local rv = Vector3.new(
            math.random(-FLING_LIN_VEL, FLING_LIN_VEL),
            math.random(-FLING_LIN_VEL, FLING_LIN_VEL),
            math.random(-FLING_LIN_VEL, FLING_LIN_VEL)
        )
        local rav = Vector3.new(
            math.random(-FLING_ANG_VEL, FLING_ANG_VEL),
            math.random(-FLING_ANG_VEL, FLING_ANG_VEL),
            math.random(-FLING_ANG_VEL, FLING_ANG_VEL)
        )
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
                sendChat("Target flung. Returning to host.")
                stopFling(false, false)
                task.wait(0.1)
                teleportToHost()
                task.wait(0.4)
                continue
            end
        end
        S.flingLastTargetPos = thrp.Position
        if os.clock() - S.flingStartTime > FLING_MAX_DURATION then
            sendChat("Fling timeout. Returning to host.")
            stopFling(false, false)
            teleportToHost()
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
            pcall(function()
                local fd = thrp.Position - m.Position
                local ff = Vector3.new(fd.X, 0, fd.Z)
                if ff.Magnitude > 0.05 then m.CFrame = CFrame.lookAt(m.Position, m.Position + ff.Unit) end
            end)
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
        b.MaxForce = Vector3.new(1e7, 1e7, 1e7); b.Position = pos; b.P = 5e5; b.D = 200; b.Parent = m; S.hideBP = b
        local g = Instance.new("BodyGyro")
        g.MaxTorque = Vector3.new(1e7, 1e7, 1e7); g.P = 5e5; g.D = 200; g.CFrame = m.CFrame; g.Parent = m; S.hideBG = g
        local h = hum(); if h then h.WalkSpeed = 0; h.JumpPower = 0; h.PlatformStand = true end
        S.hideHB = RunService.Heartbeat:Connect(function()
            if not S.hidden then return end
            local r = hrp(); if not r then return end
            if (r.Position - pos).Magnitude > 5 then pcall(function() r.CFrame = CFrame.new(pos) end) end
            if r.AssemblyLinearVelocity.Magnitude > 1 then pcall(function() r.AssemblyLinearVelocity = Vector3.zero end) end
        end)
    end
    if not silent then sendChat("Hiding. Awaiting !spawn directive.") end
end

local function doSpawn()
    S.hidden = false; S.frozen = false; S.sitting = false; S.mode = "Follow"; clearHide()
    local h = hum()
    if h then h.PlatformStand = false; h.WalkSpeed = BASE_SPEED; h.JumpPower = BASE_JUMP end
    rotationOwner = "Humanoid"
    if h then h.AutoRotate = true end
    local hh, m = getHostHRP(), hrp()
    if hh and m then
        local f = hh.CFrame.LookVector * 5
        pcall(function()
            m.CFrame = CFrame.new(hh.Position + Vector3.new(f.X, 0, f.Z))
            m.AssemblyLinearVelocity = Vector3.zero
            m.AssemblyAngularVelocity = Vector3.zero
        end)
    end
    S.waypoints = nil; S.cachedPath = nil; S.lastMovePos = nil; S.committedTarget = nil
    sendChat("Deployment complete. Resuming escort.")
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
        if not h0 or not h0.Sit then
            S.sitting = false
        else
            local m0 = hrp()
            if m0 then
                pcall(function()
                    m0.AssemblyLinearVelocity = Vector3.new(m0.AssemblyLinearVelocity.X * 0.3, m0.AssemblyLinearVelocity.Y, m0.AssemblyLinearVelocity.Z * 0.3)
                end)
            end
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
        if anchor then
            pcall(function()
                m.CFrame = CFrame.new(anchor + Vector3.new(0, 3, 0))
                m.AssemblyLinearVelocity = Vector3.zero
                m.AssemblyAngularVelocity = Vector3.zero
            end)
        elseif hh then
            pcall(function() m.CFrame = CFrame.new(hh.Position + Vector3.new(0, 4, 0)); m.AssemblyLinearVelocity = Vector3.zero end)
        end
        S.waypoints = nil; S.cachedPath = nil; S.lastMovePos = nil; S.committedTarget = nil
        return
    end

    checkPush()

    local targetPos
    if S.mode == "Lead" then
        if not S.leadActive or not S.leadTarget or not S.leadTarget.Parent then
            stopLead(false); sendChat("Lead target lost. Resuming escort."); return
        end
        local th = getPlayerHRP(S.leadTarget); if not th then return end
        if isInVoid(th.Position) then targetPos = S.lastSafeHostPos or m.Position; h:MoveTo(targetPos); return end
        targetPos = th.Position
        if (m.Position - targetPos).Magnitude <= LEAD_ARRIVE_DIST then
            sendChat("Arrived at "..S.leadTarget.Name.."."); stopLead(false); S.mode = "Follow"; return
        end
        if (hh.Position - m.Position).Magnitude > LEAD_HOST_MAX_DIST then h:MoveTo(m.Position); return end
    else
        if S.hostInVoid then
            targetPos = S.hostVoidSafePos or S.lastSafeHostPos or m.Position
            if (targetPos - m.Position).Magnitude > FOLLOW_DIST then h:MoveTo(targetPos); S.lastMovePos = targetPos
            else h:MoveTo(m.Position) end
            return
        end
        targetPos = hh.Position
    end
    if not targetPos then return end

    local d = (targetPos - m.Position).Magnitude

    if S.mode == "Follow" and d > EMERGENCY_DIST then
        if os.clock() - S.tpCD > 3 then
            S.tpCD = os.clock()
            local back = hh.CFrame.LookVector * -7
            pcall(function()
                m.CFrame = CFrame.new(hh.Position + Vector3.new(back.X, 3, back.Z))
                m.AssemblyLinearVelocity = Vector3.zero
            end)
            S.waypoints = nil; S.cachedPath = nil; S.lastMovePos = nil; S.committedTarget = nil
        end
        return
    end

    if h.MoveDirection.Magnitude > 0.1 then setRotationOwner("Humanoid")
    else
        if S.mode == "Follow" and d <= LOOK_RANGE then setRotationOwner("FaceHost")
        else setRotationOwner("Humanoid") end
    end

    if d <= FOLLOW_DIST then
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
            h:MoveTo(targetPos); S.committedTarget = targetPos; S.committedUntil = os.clock() + 1.5
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

local function startFollow()
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
                end
            else S.failCount = 0 end
        end
    end)
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
end

local function restoreHost()
    if not originalHost.name then return end
    S.hostName = originalHost.name; hostFilter.name = originalHost.name; hostFilter.userId = originalHost.userId
    S.lending = false; S.lendEnd = 0
    sendChat("Transfer window expired.")
end
local function startLend(name, secs)
    secs = tonumber(secs); if not secs or secs <= 0 then secs = 60 end
    local t = getPlayer(name)
    if not t then sendChat("Lend failed: '"..tostring(name).."' not found."); return end
    if not S.lending then originalHost.name = S.hostName; originalHost.userId = hostFilter.userId end
    S.lending = true; S.hostName = t.Name:lower()
    hostFilter.name = t.Name:lower(); hostFilter.userId = t.UserId
    S.lendEnd = os.clock() + secs
    sendChat("Temporary host: "..t.Name.." | "..secs.."s")
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
        S.hostInVoid = false; S.mirrorJumpTime = 0
    end)
end

print("[MyPanel] BOOT 8 — commands + chat hooks")

handleCommand = function(cmd, args)
    if ROLE ~= "BOT" or antiBan.detected then return end
    S.lastCmd = cmd; S.lastCmdTime = os.clock()
    table.insert(S.cmdHistory, cmd)
    if #S.cmdHistory > 5 then table.remove(S.cmdHistory, 1) end
    if botLogRef then pushLog(botLogRef, "> "..cmd..(args ~= "" and (" "..args) or ""), C.green) end

    if cmd == "say" then if args ~= "" then sendChat(args) end
    elseif cmd == "orbit" then startOrbit(args ~= "" and args or nil)
    elseif cmd == "unorbit" then stopOrbit(); sendChat("Orbital maneuver terminated.")
    elseif cmd == "sit" then
        stopSpin(); stopDance(); stopLead(false); stopBam(false); stopAnnoy(false); stopFling(false)
        S.sitting = true
        S.waypoints = nil; S.cachedPath = nil; S.lastMovePos = nil; S.committedTarget = nil
        local h = hum()
        if h then
            pcall(function() h.WalkSpeed = 0; h.JumpPower = 0; h.Sit = true; h:ChangeState(Enum.HumanoidStateType.Seated) end)
        end
        sendChat("Assuming seated position.")
    elseif cmd == "stand" then
        S.sitting = false
        local h = hum()
        if h then
            pcall(function() h.Sit = false; h:ChangeState(Enum.HumanoidStateType.GettingUp); h.WalkSpeed = BASE_SPEED; h.JumpPower = BASE_JUMP end)
        end
        sendChat("Standing up.")
    elseif cmd == "jump" then local h = hum(); if h then h.Jump = true end; sendChat("Executing jump.")
    elseif cmd == "hide" then doHide(false)
    elseif cmd == "spawn" then doSpawn()
    elseif cmd == "steps" then
        if S.totalSteps > 0 then sendChat("Calculated "..S.totalSteps.." steps.")
        else sendChat("No active path.") end
    elseif cmd == "dance" then
        local num = tonumber(args) or 1
        if playDance(num) then sendChat("Dance "..num.." engaged.") else sendChat("Dance "..num.." failed.") end
    elseif cmd == "undance" then stopDance(); sendChat("Dance disengaged.")
    elseif cmd == "spin" then startSpin(args)
    elseif cmd == "unspin" then stopSpin(); sendChat("Spin disengaged.")
    elseif cmd == "lead" then startLead(args)
    elseif cmd == "unlead" then stopLead(true)
    elseif cmd == "bam" then startBam(args)
    elseif cmd == "unbam" then stopBam(false); teleportToHost(); sendChat("Bam terminated. Returning to host.")
    elseif cmd == "annoy" then startAnnoy(args)
    elseif cmd == "unannoy" then stopAnnoy(false); teleportToHost(); sendChat("Annoy terminated. Returning to host.")
    elseif cmd == "fling" then startFling(args)
    elseif cmd == "unfling" then stopFling(false, false); teleportToHost(); sendChat("Fling terminated. Returning to host.")
    elseif cmd == "math" then handleMath(args)
    elseif cmd == "ai" then handleAI(args)
    elseif cmd == "aireload" then
        sendChat("Reloading AI...")
        aiSetup(true)
    elseif cmd == "inspect" then sendChat("[!inspect] Queued for future update.")
    elseif cmd == "view" then sendChat("[!view] Queued for future update.")
    elseif cmd == "fly" then sendChat("[!fly] Queued for future update.")
    elseif cmd == "swim" then sendChat("[!swim] Queued for future update.")
    elseif cmd == "autodrop" then sendChat("[!autodrop] Queued for future update.")
    elseif cmd == "getdrops" then sendChat("[!getdrops] Queued for future update.")
    elseif cmd == "equip" then sendChat("[!equip] Queued for future update.")
    elseif cmd == "headsit" then sendChat("[!headsit] Queued for future update.")
    elseif cmd == "getandgive" then sendChat("[!getandgive] Queued for future update.")
    elseif cmd == "check" then sendChat("[!check] Queued for future update.")
    elseif cmd == "serverinfo" then sendChat("[!serverinfo] Queued for future update.")
    elseif cmd == "cmds" then
        sendSeq({"[OPERATIONS MANUAL]",
            "!say <text> | !orbit <1-1000> | !unorbit",
            "!sit | !stand | !jump | !dance <1-4> | !undance",
            "!spin <1-100> | !unspin | !lead <player> | !unlead",
            "!hide | !spawn | !lend <user> <sec>",
            "!bam <player> | !unbam",
            "!annoy <player> | !unannoy",
            "!fling <player> | !unfling",
            "!math <num><op><num> | ex: !math 1+1 or 100÷50",
            "!ai <message> | !aireload - chat with deepseek ai",
            "[PLACEHOLDER] !inspect !view !fly !swim !autodrop",
            "!getdrops !equip !headsit !getandgive !check !serverinfo",
            "!cmds | !ask <question> | !steps"}, 0.9)
    elseif cmd == "lend" then
        local name, secs = args:match("^(%S+)%s+(%d+)$")
        if not name then sendChat("Usage: !lend <user> <seconds>") else startLend(name, secs) end
    elseif cmd == "ask" then handleAsk(args)
    else sendChat("Unknown directive: "..cmd..". Transmit !cmds.") end
end

local function processMessage(uid, text)
    if not text or text == "" then return end
    if text:sub(1, #commandPrefix) ~= commandPrefix then return end
    if isDuplicateMessage(uid, text) then return end
    local body = trim(text:sub(#commandPrefix + 1))
    if body == "" then return end
    local sp = body:find("%s")
    local cmd, args
    if sp then cmd = body:sub(1, sp - 1):lower(); args = trim(body:sub(sp + 1))
    else cmd = body:lower(); args = "" end
    local line = commandPrefix..cmd..(args ~= "" and (" "..args) or "")
    if ROLE == "HOST" and uid == player.UserId then pushLog(hostLogRef, line) end
    if ROLE == "BOT" and isFromHost(uid) then
        if botLogRef then pushLog(botLogRef, line) end
        task.spawn(function()
            local ok, err = pcall(handleCommand, cmd, args)
            if not ok then
                warn("[MyPanel] cmd error:", err)
                if botLogRef then pushLog(botLogRef, "ERR: "..tostring(err):sub(1, 60), C.red) end
            end
        end)
    end
end

pcall(function()
    if TextChatService and TextChatService.ChatVersion == Enum.ChatVersion.TextChatService then
        TextChatService.MessageReceived:Connect(function(m)
            local s = m.TextSource; if not s then return end
            processMessage(s.UserId, m.Text)
        end)
    end
end)
local function hookChatted(p) p.Chatted:Connect(function(t) processMessage(p.UserId, t) end) end
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

local function activateAntiBan()
    if antiBan.detected then return end
    antiBan.detected = true
    sendChat("[SYSTEM] Anti-ban triggered. Going dormant.")
    stopOrbit(); stopSpin(); stopDance(); stopLead(false); stopBam(false); stopAnnoy(false); stopFling(false)
    S.hidden = true; S.mode = "Hidden"; S.sitting = false
    local h = hum(); if h then h.WalkSpeed = 0; h.JumpPower = 0 end
end

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
if not parented then
    pcall(function() gui.Parent = game:GetService("CoreGui") end)
end
print("[MyPanel] GUI parented to:", gui.Parent and gui.Parent:GetFullName() or "NONE")

local frame = Instance.new("Frame")
frame.Name = "MainPanel"
frame.Size = UDim2.new(0, 278, 0, 400)
frame.Position = UDim2.new(0, 12, 0.5, -200)
frame.BackgroundColor3 = C.panel
frame.BorderSizePixel = 0
frame.ClipsDescendants = true
frame.Parent = gui
corner(frame, 18)
stroke(frame, C.border, 1, 0.2)

local SHOWN = UDim2.new(0, 12, 0.5, -200)
local HIDDEN = UDim2.new(0, -290, 0.5, -200)
local function show() tw(frame, 0.4, {Position = SHOWN}, Enum.EasingStyle.Quint) end
local function hide() tw(frame, 0.4, {Position = HIDDEN}, Enum.EasingStyle.Quint, Enum.EasingDirection.In) end

local header = Instance.new("TextLabel")
header.Size = UDim2.new(1, -24, 0, 42); header.Position = UDim2.new(0, 12, 0, 10)
header.BackgroundColor3 = C.panelTop; header.BorderSizePixel = 0
header.Font = Enum.Font.GothamMedium; header.Text = "12:00:00 AM PHT"
header.TextColor3 = C.text; header.TextSize = 14
header.TextXAlignment = Enum.TextXAlignment.Left; header.Parent = frame
corner(header, 12); stroke(header, C.border, 1, 0.45)
local hpad = Instance.new("UIPadding"); hpad.PaddingLeft = UDim.new(0, 14); hpad.Parent = header

local function phTime()
    local t = os.date("!*t", os.time() + PH_OFFSET)
    local p = t.hour >= 12 and "PM" or "AM"
    local dh = t.hour % 12; if dh == 0 then dh = 12 end
    return string.format("%02d:%02d:%02d %s PHT", dh, t.min, t.sec, p)
end
task.spawn(function() while header and header.Parent do header.Text = phTime(); task.wait(1) end end)

local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -16, 1, -64); scroll.Position = UDim2.new(0, 8, 0, 58)
scroll.BackgroundTransparency = 1; scroll.BorderSizePixel = 0
scroll.CanvasSize = UDim2.new(0, 0, 0, 0); scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
scroll.ScrollBarThickness = 5; scroll.ScrollBarImageColor3 = C.border
scroll.ScrollingDirection = Enum.ScrollingDirection.Y; scroll.Active = true; scroll.Parent = frame
local spad = Instance.new("UIPadding")
spad.PaddingLeft = UDim.new(0, 4); spad.PaddingRight = UDim.new(0, 10); spad.PaddingBottom = UDim.new(0, 16)
spad.Parent = scroll

local content = Instance.new("Frame")
content.Size = UDim2.new(1, 0, 0, 0); content.AutomaticSize = Enum.AutomaticSize.Y
content.BackgroundTransparency = 1; content.Parent = scroll
local cl = Instance.new("UIListLayout"); cl.Padding = UDim.new(0, 10); cl.SortOrder = Enum.SortOrder.LayoutOrder; cl.Parent = content

local cmdSec = Instance.new("Frame")
cmdSec.Size = UDim2.new(1, 0, 0, 620); cmdSec.LayoutOrder = 1
cmdSec.BackgroundColor3 = C.section; cmdSec.BorderSizePixel = 0
cmdSec.Visible = false; cmdSec.Parent = content
corner(cmdSec, 15); stroke(cmdSec, C.border, 1, 0.35)

local cmdTitle = Instance.new("TextLabel")
cmdTitle.Size = UDim2.new(1, -54, 0, 20); cmdTitle.Position = UDim2.new(0, 40, 0, 12)
cmdTitle.BackgroundTransparency = 1; cmdTitle.Font = Enum.Font.GothamMedium
cmdTitle.Text = "COMMAND LIST"; cmdTitle.TextColor3 = C.subText
cmdTitle.TextSize = 10; cmdTitle.TextXAlignment = Enum.TextXAlignment.Left; cmdTitle.Parent = cmdSec

local cmdTog = Instance.new("TextButton")
cmdTog.Size = UDim2.new(0, 20, 0, 20); cmdTog.Position = UDim2.new(0, 10, 0, 8)
cmdTog.BackgroundColor3 = C.button; cmdTog.BorderSizePixel = 0
cmdTog.Font = Enum.Font.GothamBold; cmdTog.Text = "-"; cmdTog.TextColor3 = C.text
cmdTog.TextSize = 14; cmdTog.AutoButtonColor = false; cmdTog.Parent = cmdSec
corner(cmdTog, 6); stroke(cmdTog, C.border, 1, 0.3); styleBtn(cmdTog)

local cmdBox = Instance.new("Frame")
cmdBox.Size = UDim2.new(1, -28, 1, -50); cmdBox.Position = UDim2.new(0, 14, 0, 40)
cmdBox.BackgroundColor3 = C.track; cmdBox.BorderSizePixel = 0
cmdBox.ClipsDescendants = true; cmdBox.Parent = cmdSec
corner(cmdBox, 8); stroke(cmdBox, C.border, 1, 0.4)
local cbpad = Instance.new("UIPadding")
cbpad.PaddingLeft = UDim.new(0, 10); cbpad.PaddingTop = UDim.new(0, 8); cbpad.PaddingRight = UDim.new(0, 8); cbpad.Parent = cmdBox

local cmdScroll = Instance.new("ScrollingFrame")
cmdScroll.Size = UDim2.new(1, 0, 1, 0); cmdScroll.BackgroundTransparency = 1
cmdScroll.BorderSizePixel = 0; cmdScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
cmdScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
cmdScroll.ScrollBarThickness = 3; cmdScroll.ScrollBarImageColor3 = C.border; cmdScroll.Parent = cmdBox
local cml = Instance.new("UIListLayout"); cml.Padding = UDim.new(0, 3); cml.SortOrder = Enum.SortOrder.LayoutOrder; cml.Parent = cmdScroll

local CMDS = {
    {"── MOVEMENT ──", true}, {"!orbit <1-1000> - circle around you", false}, {"!unorbit - stop circling", false},
    {"!lead <player> - lead you to player", false}, {"!unlead - cancel leading", false}, {"!sit - sit down", false},
    {"!stand - stand back up", false},
    {"!jump - jump once", false}, {"!hide - go safe void-adjacent, freeze", false}, {"!spawn - teleport in front of you", false},
    {"", false}, {"── TROLL ──", true}, {"!bam <player> - continuous thrust on back", false},
    {"!unbam - stop + tp to me", false}, {"!annoy <player> - front follow + spam chat", false},
    {"!unannoy - stop + tp to me", false},
    {"!fling <player> - gyro-spin inside body", false},
    {"!unfling - stop fling + tp to me", false},
    {"", false}, {"── FUN / EMOTES ──", true}, {"!dance 1/2/3/4 - bot /e dance", false},
    {"!undance - stop dancing", false}, {"!spin <1-100> - bot spins in place", false}, {"!unspin - stop spinning", false},
    {"", false}, {"── UTIL ──", true}, {"!math <num><op><num> - calculator", false},
    {"   ops: + - * / ÷ × % ^  ex: !math 100÷50", false},
    {"!ai <message> - chat with deepseek ai", false},
    {"!aireload - reload ai setup", false},
    {"", false}, {"── SOCIAL ──", true}, {"!say <text> - bot speaks", false}, {"!lend <user> <sec> - give host time", false},
    {"!cmds - say list in chat", false}, {"!ask <question> - talk to bot", false}, {"!steps - report step count to host", false},
    {"", false}, {"── PLACEHOLDER (soon) ──", true},
    {"!inspect <player> | !view <player>", false},
    {"!fly | !swim | !autodrop | !getdrops", false},
    {"!equip <1-10> | !headsit | !getandgive <1-10>", false},
    {"!check info | !serverinfo", false}
}
for i, e in ipairs(CMDS) do
    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, 0, 0, e[2] and 16 or 14); l.BackgroundTransparency = 1
    l.Font = e[2] and Enum.Font.GothamBold or Enum.Font.Code
    l.Text = e[1]; l.TextColor3 = e[2] and C.accent or C.text
    l.TextSize = 10; l.TextXAlignment = Enum.TextXAlignment.Left; l.LayoutOrder = i; l.Parent = cmdScroll
end
local cmdCollapsed = false
cmdTog.Activated:Connect(function()
    cmdCollapsed = not cmdCollapsed
    tw(cmdSec, 0.34, {Size = UDim2.new(1, 0, 0, cmdCollapsed and 44 or 620)}, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut)
    cmdTog.Text = cmdCollapsed and "+" or "-"
end)

local botSec = Instance.new("Frame")
botSec.Size = UDim2.new(1, 0, 0, 230); botSec.LayoutOrder = 2
botSec.BackgroundColor3 = C.section; botSec.BorderSizePixel = 0
botSec.Visible = false; botSec.Parent = content
corner(botSec, 15); stroke(botSec, C.border, 1, 0.35)

local bTitle = Instance.new("TextLabel")
bTitle.Size = UDim2.new(1, -54, 0, 20); bTitle.Position = UDim2.new(0, 40, 0, 12)
bTitle.BackgroundTransparency = 1; bTitle.Font = Enum.Font.GothamMedium
bTitle.Text = "BOT ACTIVITY LOG"; bTitle.TextColor3 = C.subText
bTitle.TextSize = 10; bTitle.TextXAlignment = Enum.TextXAlignment.Left; bTitle.Parent = botSec

local pfxLbl = Instance.new("TextLabel")
pfxLbl.Size = UDim2.new(0, 130, 0, 16); pfxLbl.Position = UDim2.new(0, 14, 0, 42)
pfxLbl.BackgroundTransparency = 1; pfxLbl.Font = Enum.Font.GothamMedium
pfxLbl.Text = "COMMAND PREFIX"; pfxLbl.TextColor3 = C.subText; pfxLbl.TextSize = 9
pfxLbl.TextXAlignment = Enum.TextXAlignment.Left; pfxLbl.Parent = botSec

local pfxBox = Instance.new("TextBox")
pfxBox.Size = UDim2.new(0, 46, 0, 30); pfxBox.Position = UDim2.new(0, 14, 0, 60)
pfxBox.BackgroundColor3 = C.panelTop; pfxBox.BorderSizePixel = 0
pfxBox.Font = Enum.Font.GothamBold; pfxBox.Text = commandPrefix
pfxBox.TextColor3 = C.accent; pfxBox.TextSize = 16
pfxBox.ClearTextOnFocus = false; pfxBox.Parent = botSec
corner(pfxBox, 8); stroke(pfxBox, C.border, 1, 0.3)

local pfxHint = Instance.new("TextLabel")
pfxHint.Size = UDim2.new(1, -76, 0, 30); pfxHint.Position = UDim2.new(0, 70, 0, 60)
pfxHint.BackgroundTransparency = 1; pfxHint.Font = Enum.Font.Gotham
pfxHint.Text = "Type in chat: "..commandPrefix.."cmds"; pfxHint.TextColor3 = C.subText; pfxHint.TextSize = 10
pfxHint.TextWrapped = true; pfxHint.TextXAlignment = Enum.TextXAlignment.Left
pfxHint.TextYAlignment = Enum.TextYAlignment.Center; pfxHint.Parent = botSec

local logT = Instance.new("TextLabel")
logT.Size = UDim2.new(1, -28, 0, 14); logT.Position = UDim2.new(0, 14, 0, 100)
logT.BackgroundTransparency = 1; logT.Font = Enum.Font.GothamMedium
logT.Text = "COMMANDS & BOT REPLIES"; logT.TextColor3 = C.subText; logT.TextSize = 9
logT.TextXAlignment = Enum.TextXAlignment.Left; logT.Parent = botSec

local logBox = Instance.new("Frame")
logBox.Size = UDim2.new(1, -28, 0, 96); logBox.Position = UDim2.new(0, 14, 0, 118)
logBox.BackgroundColor3 = C.track; logBox.BorderSizePixel = 0
logBox.ClipsDescendants = true; logBox.Parent = botSec
corner(logBox, 8); stroke(logBox, C.border, 1, 0.4)
local lbp = Instance.new("UIPadding"); lbp.PaddingLeft = UDim.new(0, 8); lbp.PaddingTop = UDim.new(0, 6); lbp.Parent = logBox

local logEmpty = Instance.new("TextLabel")
logEmpty.Size = UDim2.new(1, -8, 1, -6); logEmpty.BackgroundTransparency = 1
logEmpty.Font = Enum.Font.Gotham; logEmpty.Text = "Nothing sent yet."
logEmpty.TextColor3 = C.subText; logEmpty.TextSize = 10
logEmpty.TextXAlignment = Enum.TextXAlignment.Left
logEmpty.TextYAlignment = Enum.TextYAlignment.Top; logEmpty.Parent = logBox

local logHolder = Instance.new("Frame")
logHolder.Size = UDim2.new(1, -8, 1, -6); logHolder.BackgroundTransparency = 1; logHolder.Parent = logBox
local lbl = Instance.new("UIListLayout"); lbl.SortOrder = Enum.SortOrder.LayoutOrder; lbl.Padding = UDim.new(0, 2); lbl.Parent = logHolder

hostLogRef = {holder = logHolder, empty = logEmpty}

pfxBox.FocusLost:Connect(function()
    local np = trim(pfxBox.Text)
    if np == "" then np = "!" else np = np:sub(1, 1) end
    commandPrefix = np; pfxBox.Text = commandPrefix
    pfxHint.Text = "Type in chat: "..commandPrefix.."cmds"
end)

local roleOv = Instance.new("Frame")
roleOv.Size = UDim2.new(1, 0, 1, 0); roleOv.BackgroundColor3 = C.panel
roleOv.BackgroundTransparency = 0.05; roleOv.BorderSizePixel = 0
roleOv.ZIndex = 50; roleOv.Visible = true; roleOv.Parent = frame

local function mkLabel(parent, txt, pos, size, font, color, tsize, align, z)
    local l = Instance.new("TextLabel")
    l.Size = size; l.Position = pos; l.BackgroundTransparency = 1
    l.Font = font; l.Text = txt; l.TextColor3 = color; l.TextSize = tsize
    l.TextXAlignment = align or Enum.TextXAlignment.Center
    l.ZIndex = z or 51; l.Parent = parent
    return l
end
mkLabel(roleOv, "SELECT ROLE", UDim2.new(0, 12, 0, 14), UDim2.new(1, -24, 0, 30), Enum.Font.GothamBold, C.text, 14)
mkLabel(roleOv, "This decides what this account does.", UDim2.new(0, 12, 0, 44), UDim2.new(1, -24, 0, 20), Enum.Font.Gotham, C.subText, 10)

local function mkBtn(parent, txt, pos, size, z)
    local b = Instance.new("TextButton")
    b.Size = size; b.Position = pos; b.BackgroundColor3 = C.button; b.BorderSizePixel = 0
    b.Font = Enum.Font.GothamBold; b.Text = txt; b.TextColor3 = C.text; b.TextSize = 18
    b.AutoButtonColor = false; b.ZIndex = z or 51; b.Parent = parent
    corner(b, 12); stroke(b, C.border, 1, 0.3); styleBtn(b)
    return b
end
local hostBtn = mkBtn(roleOv, "HOST", UDim2.new(0, 24, 0, 92), UDim2.new(1, -48, 0, 70))
mkLabel(roleOv, "Full panel + command list + log", UDim2.new(0, 24, 0, 164), UDim2.new(1, -48, 0, 18), Enum.Font.Gotham, C.subText, 10)
local botBtn = mkBtn(roleOv, "BOT", UDim2.new(0, 24, 0, 202), UDim2.new(1, -48, 0, 70))
mkLabel(roleOv, "Follows host. Manual hide/spawn only.", UDim2.new(0, 24, 0, 274), UDim2.new(1, -48, 0, 18), Enum.Font.Gotham, C.subText, 10)

local confOv = Instance.new("Frame")
confOv.Size = UDim2.new(1, 0, 1, 0); confOv.BackgroundColor3 = C.panel
confOv.BackgroundTransparency = 0.05; confOv.BorderSizePixel = 0
confOv.ZIndex = 55; confOv.Visible = false; confOv.Parent = frame
mkLabel(confOv, "LOCK IN AS HOST?", UDim2.new(0, 12, 0, 90), UDim2.new(1, -24, 0, 30), Enum.Font.GothamBold, C.text, 14, nil, 56)
local cInfo = mkLabel(confOv, "You'll get the full panel plus a command log.", UDim2.new(0, 24, 0, 128), UDim2.new(1, -48, 0, 50), Enum.Font.Gotham, C.subText, 11, nil, 56)
cInfo.TextWrapped = true
local cYes = mkBtn(confOv, "YES", UDim2.new(0, 20, 1, -90), UDim2.new(0.5, -30, 0, 40), 56) cYes.TextSize = 13
local cNo = mkBtn(confOv, "BACK", UDim2.new(0.5, 10, 1, -90), UDim2.new(0.5, -30, 0, 40), 56) cNo.TextSize = 13

local bsOv = Instance.new("Frame")
bsOv.Size = UDim2.new(1, 0, 1, 0); bsOv.BackgroundColor3 = C.panel
bsOv.BackgroundTransparency = 0.05; bsOv.BorderSizePixel = 0
bsOv.ZIndex = 55; bsOv.Visible = false; bsOv.Parent = frame
mkLabel(bsOv, "BOT SETUP", UDim2.new(0, 12, 0, 40), UDim2.new(1, -24, 0, 30), Enum.Font.GothamBold, C.text, 14, nil, 56)
local bsSub = mkLabel(bsOv, "Select the HOST from the player list below.", UDim2.new(0, 20, 0, 70), UDim2.new(1, -40, 0, 30), Enum.Font.Gotham, C.subText, 10, nil, 56)
bsSub.TextWrapped = true

local plFrame = Instance.new("Frame")
plFrame.Size = UDim2.new(1, -48, 1, -210); plFrame.Position = UDim2.new(0, 24, 0, 104)
plFrame.BackgroundColor3 = C.track; plFrame.BorderSizePixel = 0
plFrame.ClipsDescendants = true; plFrame.ZIndex = 56; plFrame.Parent = bsOv
corner(plFrame, 10); stroke(plFrame, C.border, 1, 0.4)
local plp = Instance.new("UIPadding")
plp.PaddingLeft = UDim.new(0, 4); plp.PaddingRight = UDim.new(0, 4)
plp.PaddingTop = UDim.new(0, 4); plp.PaddingBottom = UDim.new(0, 4); plp.Parent = plFrame

local plScroll = Instance.new("ScrollingFrame")
plScroll.Size = UDim2.new(1, 0, 1, 0); plScroll.BackgroundTransparency = 1
plScroll.BorderSizePixel = 0; plScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
plScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
plScroll.ScrollBarThickness = 4; plScroll.ScrollBarImageColor3 = C.border
plScroll.ZIndex = 56; plScroll.Parent = plFrame
local plLay = Instance.new("UIListLayout"); plLay.Padding = UDim.new(0, 3); plLay.SortOrder = Enum.SortOrder.LayoutOrder; plLay.Parent = plScroll

local selectedHost = nil
local bsErr = mkLabel(bsOv, "", UDim2.new(0, 20, 1, -86), UDim2.new(1, -40, 0, 16), Enum.Font.GothamMedium, C.red, 10, nil, 56)
bsErr.TextTransparency = 1
local bsBack = mkBtn(bsOv, "BACK", UDim2.new(0, 20, 1, -70), UDim2.new(0.5, -30, 0, 40), 56) bsBack.TextSize = 13
local bsLock = mkBtn(bsOv, "LOCK IN", UDim2.new(0.5, 10, 1, -70), UDim2.new(0.5, -30, 0, 40), 56) bsLock.TextSize = 13

local function refreshPlayers()
    for _, c in ipairs(plScroll:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
    selectedHost = nil
    local n = 0
    for _, p in ipairs(Players:GetPlayers()) do
        if p == player then continue end
        n = n + 1
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(1, 0, 0, 34); b.BackgroundColor3 = C.button; b.BorderSizePixel = 0
        b.Font = Enum.Font.GothamMedium; b.Text = "  "..p.Name.."  (@"..p.DisplayName..")"
        b.TextColor3 = C.text; b.TextSize = 11; b.TextXAlignment = Enum.TextXAlignment.Left
        b.AutoButtonColor = false; b.LayoutOrder = n; b.ZIndex = 57; b.Parent = plScroll
        corner(b, 6); local sl = stroke(b, C.border, 1, 0.3)
        b.MouseEnter:Connect(function() if selectedHost ~= p.Name then tw(b, 0.15, {BackgroundColor3 = C.buttonHover}) end end)
        b.MouseLeave:Connect(function() if selectedHost ~= p.Name then tw(b, 0.15, {BackgroundColor3 = C.button}) end end)
        b.Activated:Connect(function()
            for _, c2 in ipairs(plScroll:GetChildren()) do
                if c2:IsA("TextButton") then
                    c2.BackgroundColor3 = C.button
                    local s = c2:FindFirstChildOfClass("UIStroke")
                    if s then s.Color = C.border; s.Transparency = 0.3 end
                end
            end
            selectedHost = p.Name
            b.BackgroundColor3 = C.buttonPressed
            sl.Color = C.accent; sl.Transparency = 0
            bsErr.TextTransparency = 1; bsErr.Text = ""
        end)
    end
    if n == 0 then
        mkLabel(plScroll, "No other players in server.", UDim2.new(0, 0, 0, 0), UDim2.new(1, 0, 0, 30), Enum.Font.Gotham, C.subText, 10, nil, 57)
    end
end

local function lockRole(role, hostName)
    ROLE = role
    roleOv.Visible = false; confOv.Visible = false; bsOv.Visible = false
    if role == "HOST" then
        cmdSec.Visible = true; botSec.Visible = true
        scroll.Visible = true; header.Visible = true
        frame.Size = UDim2.new(0, 278, 0, 400)
        show()
    elseif role == "BOT" then
        hostFilter.name = hostName:lower()
        S.hostName = hostName:lower()
        originalHost.name = hostName:lower()
        for _, p in ipairs(Players:GetPlayers()) do
            if p.Name:lower() == hostName:lower() then
                hostFilter.userId = p.UserId; originalHost.userId = p.UserId; break
            end
        end
        applyFixedSpeed()
        startFacing(); startFollow(); bindDeath(); startAfk(); startMirrorJump(); startCameraMicro()
        aiSetup()
        scroll.Visible = false; header.Visible = false
        local cH, eH = 54, 176
        local expanded = false
        tw(frame, 0.45, {Size = UDim2.new(0, 230, 0, cH)}, Enum.EasingStyle.Back)
        show()

        local dot = Instance.new("Frame")
        dot.Size = UDim2.new(0, 10, 0, 10); dot.Position = UDim2.new(0, 14, 0, 14)
        dot.BackgroundColor3 = C.green; dot.BorderSizePixel = 0
        dot.ZIndex = 5; dot.Parent = frame; corner(dot, 5)
        task.spawn(function() while dot and dot.Parent do
            tw(dot, 1, {BackgroundTransparency = 0.55}); task.wait(1)
            tw(dot, 1, {BackgroundTransparency = 0}); task.wait(1)
        end end)

        local bl = Instance.new("TextLabel")
        bl.Size = UDim2.new(1, -80, 0, 18); bl.Position = UDim2.new(0, 30, 0, 8)
        bl.BackgroundTransparency = 1; bl.Font = Enum.Font.GothamBold
        bl.Text = "BOT MODE"; bl.TextColor3 = C.text; bl.TextSize = 12
        bl.TextXAlignment = Enum.TextXAlignment.Left; bl.ZIndex = 5; bl.Parent = frame

        local sl = Instance.new("TextLabel")
        sl.Size = UDim2.new(1, -80, 0, 14); sl.Position = UDim2.new(0, 30, 0, 26)
        sl.BackgroundTransparency = 1; sl.Font = Enum.Font.Gotham
        sl.Text = "Listening to @"..hostName; sl.TextColor3 = C.subText
        sl.TextSize = 9; sl.TextXAlignment = Enum.TextXAlignment.Left; sl.ZIndex = 5; sl.Parent = frame

        local pTog = Instance.new("TextButton")
        pTog.Size = UDim2.new(0, 20, 0, 20); pTog.Position = UDim2.new(1, -34, 0, 10)
        pTog.BackgroundColor3 = C.button; pTog.BorderSizePixel = 0
        pTog.Font = Enum.Font.GothamBold; pTog.Text = "+"
        pTog.TextColor3 = C.text; pTog.TextSize = 14; pTog.AutoButtonColor = false
        pTog.ZIndex = 5; pTog.Parent = frame; corner(pTog, 6); stroke(pTog, C.border, 1, 0.3); styleBtn(pTog)

        local pBox = Instance.new("Frame")
        pBox.Size = UDim2.new(1, -24, 0, eH - cH - 14); pBox.Position = UDim2.new(0, 12, 0, cH + 4)
        pBox.BackgroundColor3 = C.track; pBox.BorderSizePixel = 0
        pBox.ClipsDescendants = true; pBox.ZIndex = 5; pBox.Parent = frame
        corner(pBox, 8); stroke(pBox, C.border, 1, 0.4)
        local pp = Instance.new("UIPadding"); pp.PaddingLeft = UDim.new(0, 8); pp.PaddingTop = UDim.new(0, 6); pp.Parent = pBox

        local eLbl = Instance.new("TextLabel")
        eLbl.Size = UDim2.new(1, -8, 1, -6); eLbl.BackgroundTransparency = 1
        eLbl.Font = Enum.Font.Gotham; eLbl.Text = "No commands received yet."
        eLbl.TextColor3 = C.subText; eLbl.TextSize = 10
        eLbl.TextXAlignment = Enum.TextXAlignment.Left
        eLbl.TextYAlignment = Enum.TextYAlignment.Top; eLbl.ZIndex = 5; eLbl.Parent = pBox

        local lF = Instance.new("Frame")
        lF.Size = UDim2.new(1, -8, 1, -6); lF.BackgroundTransparency = 1; lF.ZIndex = 5; lF.Parent = pBox
        local l2 = Instance.new("UIListLayout"); l2.SortOrder = Enum.SortOrder.LayoutOrder; l2.Padding = UDim.new(0, 2); l2.Parent = lF
        botLogRef = {holder = lF, empty = eLbl}

        pTog.Activated:Connect(function()
            expanded = not expanded
            tw(frame, 0.32, {Size = UDim2.new(0, 230, 0, expanded and eH or cH)}, Enum.EasingStyle.Quint, Enum.EasingDirection.InOut)
            pTog.Text = expanded and "-" or "+"
        end)
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
    t.Equipped:Connect(function() if ROLE == "HOST" then show() end end)
    t.Unequipped:Connect(function() if ROLE == "HOST" then hide() end end)
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
