-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MicroprofileCapture = require(ReplicatedStorage.UserGenerated.Analytics.MicroprofileCapture)
local RunService = game:GetService("RunService")
local LogService = game:GetService("LogService")
local Stats = game:GetService("Stats")
local GuiService = game:GetService("GuiService")
local Workspace = game:GetService("Workspace")
local DeviceForm = require(ReplicatedStorage.UserGenerated.Roblox.DeviceForm)
local MicroProfilerConfig = require(ReplicatedStorage.UserGenerated.Analytics.MicroProfilerConfig)
local DataModel = require(ReplicatedStorage.UserGenerated.DataModel)
local LocalPlayer = Players.LocalPlayer

local function diag(...) -- line: 52
end

local function diagWarn(...) -- line: 57
end

diag("script running; userId =", LocalPlayer.UserId)

local function WaitRemote(p1) -- line: 70
    -- upvalues: diag (copy), diagWarn (copy)
    local v1 = script.Parent:WaitForChild(p1, 10)

    if v1 then
        diag("resolved remote:", p1, (("(%*)"):format(v1.ClassName)))
    else
        diagWarn("MISSING remote (WaitForChild timed out after 10s):", p1)
    end

    return v1
end

local v2 = script.Parent:WaitForChild("Fps", 10)

if v2 then
    diag("resolved remote:", "Fps", (("(%*)"):format(v2.ClassName)))
else
    diagWarn("MISSING remote (WaitForChild timed out after 10s):", "Fps")
end

local v3 = script.Parent:WaitForChild("LibMPDevice", 10)

if v3 then
    diag("resolved remote:", "LibMPDevice", (("(%*)"):format(v3.ClassName)))
else
    diagWarn("MISSING remote (WaitForChild timed out after 10s):", "LibMPDevice")
end

local v4 = script.Parent:WaitForChild("LibMPRequiring", 10)

if v4 then
    diag("resolved remote:", "LibMPRequiring", (("(%*)"):format(v4.ClassName)))
else
    diagWarn("MISSING remote (WaitForChild timed out after 10s):", "LibMPRequiring")
end

local v5 = script.Parent:WaitForChild("LibMPRequired", 10)

if v5 then
    diag("resolved remote:", "LibMPRequired", (("(%*)"):format(v5.ClassName)))
else
    diagWarn("MISSING remote (WaitForChild timed out after 10s):", "LibMPRequired")
end

local v6 = script.Parent:WaitForChild("LibMPFrame", 10)

if v6 then
    diag("resolved remote:", "LibMPFrame", (("(%*)"):format(v6.ClassName)))
else
    diagWarn("MISSING remote (WaitForChild timed out after 10s):", "LibMPFrame")
end

local v7 = script.Parent:WaitForChild("LiveRequest", 10)

if v7 then
    diag("resolved remote:", "LiveRequest", (("(%*)"):format(v7.ClassName)))
else
    diagWarn("MISSING remote (WaitForChild timed out after 10s):", "LiveRequest")
end

local v8 = script.Parent:WaitForChild("LiveResponse", 10)

if v8 then
    diag("resolved remote:", "LiveResponse", (("(%*)"):format(v8.ClassName)))
else
    diagWarn("MISSING remote (WaitForChild timed out after 10s):", "LiveResponse")
end

local result, Control
local v9 = table.create(60, 0)
local v10 = table.create(60, 0)
local n1 = -1

RunService.RenderStepped:Connect(function(p2) -- line: 100
    -- upvalues: v9 (copy), v10 (copy), n1 (ref)
    local v11 = math.floor((os.clock())) % 60 + 1

    if v11 ~= n1 then
        v9[v11] = 0
        v10[v11] = 0
        n1 = v11
    end

    v9[v11] += 1
    v10[v11] += p2
end)

local function getRecentAvgFps() -- line: 110
    -- upvalues: v9 (copy), v10 (copy)
    local n2 = 0
    local n3 = 0

    for i = 1, 60 do
        n2 += v9[i]
        n3 += v10[i]
    end

    if n3 <= 0 then
        return 0
    end

    return n2 / n3
end

local t1 = {}

local function GetBucket(p3) -- line: 147
    -- upvalues: t1 (copy)
    local v12 = t1[p3]

    if not v12 then
        v12 = {
            Frames = 0,
            Time = 0,
            Spikes = 0
        }
        t1[p3] = v12
    end

    return v12
end

local n4 = 0
local n5 = 0
local n6 = 0
local v13 = false
local v14 = table.create(60, 0)
local n7 = 0
local n8 = 0
local v15 = table.create(60, 0)

local function GetMedian() -- line: 167
    -- upvalues: v14 (copy), n7 (ref), v15 (copy)
    if n7 < 60 then
        return 0
    end

    for i = 1, 60 do
        v15[i] = v14[i]
    end

    table.sort(v15)

    return (v15[30] + v15[31]) * 0.5
end

local function ReportBucket(p4) -- line: 180
    -- upvalues: diag (copy), v2 (copy), t1 (copy)
    local v16 = t1[p4]

    if not v16 or v16.Time <= 0 then
        return
    end

    local v17 = v16.Frames / v16.Time

    v2:FireServer(p4, v17, v16.Spikes)
    diag("fired Fps: minute", p4, "avgFps", math.round(v17), "spikes", v16.Spikes)
end

local connection

connection = RunService.RenderStepped:Connect(function(p5) -- line: 191
    -- upvalues: diag (copy), v2 (copy), t1 (copy), n4 (ref), n5 (ref), n6 (ref), v13 (ref), v14 (copy), n7 (ref), n8 (ref), GetMedian (copy), connection (ref)
    local v18 = GetMedian()

    if v18 > 0 then
        if v18 * 3 < p5 then
            if not v13 then
                local v19 = n5
                local v20 = t1[v19]

                if not v20 then
                    v20 = {
                        Frames = 0,
                        Time = 0,
                        Spikes = 0
                    }
                    t1[v19] = v20
                end

                v20.Spikes += 1
                v13 = true
            end
        else
            v13 = false
        end
    end

    n8 = n8 % 60 + 1
    v14[n8] = p5

    if n7 < 60 then
        n7 += 1
    end

    local v21 = n5
    local v22 = t1[v21]

    if not v22 then
        v22 = {
            Frames = 0,
            Time = 0,
            Spikes = 0
        }
        t1[v21] = v22
    end

    v22.Frames += 1
    v22.Time += p5
    n4 += p5

    local v24 = math.floor(n4 / 60)

    if v24 ~= n5 then
        for i = n5, math.min(v24, 300) - 1 do
            local v26 = t1[i]

            if v26 and not (v26.Time <= 0) then
                local v27 = v26.Frames / v26.Time

                v2:FireServer(i, v27, v26.Spikes)
                diag("fired Fps: minute", i, "avgFps", math.round(v27), "spikes", v26.Spikes)
            end
        end

        n5 = v24
        n6 = 0
    end

    if n5 >= 300 then
        if connection then
            connection:Disconnect()
            connection = nil
        end
    else
        n6 += p5

        if n6 >= 15 then
            n6 = 0

            local v28 = n5
            local v29 = t1[v28]

            if v29 then
                if v29.Time <= 0 then
                    return
                end

                local v30 = v29.Frames / v29.Time

                v2:FireServer(v28, v30, v29.Spikes)
                diag("fired Fps: minute", v28, "avgFps", math.round(v30), "spikes", v29.Spikes)
            end
        end
    end
end)
task.spawn(function() -- line: 255
    -- upvalues: DeviceForm (copy), diag (copy), diagWarn (copy), v3 (copy)
    for i = 1, 5 do
        local v31 = DeviceForm.Get()

        diag("device report attempt", i, "->", if v31 then v31.Name else "nil")

        if v31 then
            v3:FireServer(v31)
            diag("fired LibMPDevice:", v31.Name)

            return
        end

        task.wait(1)
    end

    diagWarn("device never resolved after 5 attempts; LibMPDevice was NOT fired")
end)

local v33 = false

local function StartCapture(p6) -- line: 270
    -- upvalues: MicroprofileCapture (copy), RunService (copy), MicroProfilerConfig (copy), diag (copy), diagWarn (copy), v4 (copy), v5 (copy), v6 (copy), result (ref), Control (ref), v33 (ref)
    if v33 then
        return
    end

    v33 = true
    diag("StartCapture: module delivered ->", p6:GetFullName())
    v4:FireServer()
    diag("fired LibMPRequiring")

    local _require = require
    local ok, result2 = pcall(_require, p6)

    if not ok or type(result2) ~= "table" then
        diagWarn("require(LibMP) failed:", result2)
    else
        diag("require(LibMP) ok")
        v5:FireServer()
        diag("fired LibMPRequired")

        local v34 = MicroProfilerConfig.FramesBefore:Get()
        local v35 = MicroProfilerConfig.FramesAfter:Get()
        local Control2 = result2.Control
        local elapsed = os.clock()

        while not Control2:IsBackendReady() do
            if os.clock() - elapsed > 30 then
                diagWarn("LibMP backend not ready after 30s; capture disabled")

                return
            end

            task.wait()
        end

        local function v36() -- line: 311
            -- upvalues: v34 (copy), v35 (copy), Control2 (copy)
            Control2:SetFrameLimit(v34 + v35 + 1)
            Control2:EnableProfiler(true)
            Control2:EnableCapture(true)
        end

        local ok, result3 = pcall(v36)

        if ok then
            Control = Control2
            result = result2
            diag("LibMP capture armed; window =", v34, "+1+", v35)

            local t2 = {}

            t2[1] = 0

            local n9 = (-1e999)
            local n10 = 0
            local TickStartCpu, FrameAbsoluteId

            task.spawn(function() -- line: 341
                -- upvalues: result2 (copy), v35 (copy), Control2 (copy), t2 (copy), n9 (ref), n10 (ref), TickStartCpu (ref), FrameAbsoluteId (ref), MicroprofileCapture (copy), RunService (copy), MicroProfilerConfig (copy), diag (copy), diagWarn (copy), v6 (copy)
                task.wait(2)

                local v37 = result2.Session.OpenFromLiveData()

                if v37 and v37:IsValid() then
                    while t2[1] < MicroProfilerConfig.MaxFramesPerSession:Get() do
                        task.wait(0.03)

                        local function v38() -- line: 355
                            -- upvalues: v37 (copy), result2 (copy), v35 (copy), Control2 (copy), t2 (copy), n9 (ref), n10 (ref), TickStartCpu (ref), FrameAbsoluteId (ref), MicroprofileCapture (copy), RunService (copy), MicroProfilerConfig (copy), diag (copy), diagWarn (copy), v6 (copy)
                            v37:SetSyncRequired()

                            local v39 = v37:FetchGlobalDesc()
                            local TickToMsCpu, TickToMsGpu = v39.TickToMsCpu, v39.TickToMsGpu
                            local FrameIdMin = v37:GetFrameIdMin()
                            local FrameIdMax = v37:GetFrameIdMax()

                            if FrameIdMax ~= 0 and type(TickToMsCpu) == "number" and not (TickToMsCpu <= 0) then
                                local v41 = math.max(FrameIdMin, n10 + 1)
                                local n11 = 0
                                local n12 = 0
                                local n13 = 0
                                local n14 = 0
                                local n15 = 0
                                local n16 = 0
                                local n17 = 0

                                for i = v41, FrameIdMax do
                                    local v42 = v37:FetchFrameDesc(i)
                                    local v43 = n16
                                    local v44 = n12
                                    local v45 = n13
                                    local v46 = n14
                                    local v47 = n15
                                    local v48 = n17

                                    if v42 then
                                        local FrameAbsoluteId2 = v42.FrameAbsoluteId

                                        if FrameAbsoluteId then
                                            local _ = FrameAbsoluteId2 - FrameAbsoluteId
                                        end

                                        if not v42.IsPaused then
                                            local v49 = (v42.TickEndCpu - v42.TickStartCpu) * TickToMsCpu
                                            local v50 = if type(TickToMsGpu) == "number" and TickToMsGpu > 0 then math.max((v42.TickEndGpu - v42.TickStartGpu) * TickToMsGpu, 0) else 0

                                            v43 = if TickStartCpu ~= nil and FrameAbsoluteId ~= nil and FrameAbsoluteId2 == FrameAbsoluteId + 1 and TickStartCpu then (v42.TickStartCpu - TickStartCpu) * TickToMsCpu else 0
                                            TickStartCpu = v42.TickStartCpu
                                            FrameAbsoluteId = FrameAbsoluteId2
                                            v44 = math.max(v49, v43)

                                            if n12 < v44 then
                                                v48 = FrameAbsoluteId2
                                                n11 = i
                                                v45 = i
                                                v46 = v49
                                                v47 = v50
                                            else
                                                v44 = n12
                                                v43 = n16
                                            end
                                        end
                                    end

                                    n17 = v48
                                    n12 = v44
                                    n13 = v45
                                    n14 = v46
                                    n15 = v47
                                    n16 = v43
                                end

                                if v41 <= FrameIdMax then
                                    n10 = FrameIdMax
                                end

                                if MicroProfilerConfig.LaggyFrameMs:Get() <= n12 then
                                    diag("laggy frame", n13, "abs", n17, "peakMs", string.format("%.2f", n12), "[ cpu", string.format("%.2f", n14), "gpu", string.format("%.2f", n15), "interval", string.format("%.2f", n16), "]")

                                    if os.clock() - n9 >= MicroProfilerConfig.MinFrameInterval:Get() then
                                        for _ = 1, v35 do
                                            RunService.RenderStepped:Wait()
                                        end

                                        local v52, v53 = MicroprofileCapture.Run(function() -- line: 461
                                            -- upvalues: n11 (ref), result2 (copy), Control2 (copy), MicroprofileCapture (copy), MicroProfilerConfig (copy)
                                            return MicroprofileCapture.Export(result2, Control2:CaptureToBufferSync(), n11, MicroProfilerConfig.MaxDumpBytes:Get())
                                        end)

                                        if v52 then
                                            t2[1] += 1
                                            n9 = os.clock()
                                            v6:FireServer(v52, n12)
                                        else
                                            diagWarn("export rejected:", v53)
                                        end
                                    end
                                end
                            end
                        end

                        pcall(v38)
                    end

                    v37:Dispose()
                else
                    diagWarn("OpenFromLiveData failed; client laggy-frame capture disabled")

                    if v37 then
                        v37:Dispose()
                    end
                end
            end)
        else
            diagWarn("LibMP setup failed:", result3)
        end
    end
end

task.spawn(function() -- line: 488
    -- upvalues: MicroProfilerConfig (copy), LocalPlayer (copy), diag (copy), StartCapture (copy)
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

    diag("waiting for LibMP module:", MicroProfilerConfig.ModuleName)

    local function waitForLibMP(p7) -- line: 492
        -- upvalues: PlayerGui (copy), MicroProfilerConfig (copy), diag (copy), StartCapture (copy)
        local v54 = PlayerGui:WaitForChild(p7, 1e999):WaitForChild(MicroProfilerConfig.ModuleName, 1e999)

        if v54:IsA("ModuleScript") then
            diag("found LibMP module via", p7)
            StartCapture(v54)
        end
    end

    task.spawn(waitForLibMP, MicroProfilerConfig.ContainerName)

    local v55 = PlayerGui:WaitForChild("__UG_LiveLibMPGui", 1e999):WaitForChild(MicroProfilerConfig.ModuleName, 1e999)

    if v55:IsA("ModuleScript") then
        diag("found LibMP module via", "__UG_LiveLibMPGui")
        StartCapture(v55)
    end
end)

local function ensureArmed(p8) -- line: 519
    -- upvalues: Control (ref)
    if Control then
        return Control
    end

    local elapsed = os.clock()

    while not Control and os.clock() - elapsed < p8 do
        task.wait(0.1)
    end

    return Control
end

local function collectClientLogs() -- line: 530
    -- upvalues: LogService (copy)
    local LogHistory = LogService:GetLogHistory()
    local t3 = {}

    for i = math.max(1, #LogHistory - 400 + 1), #LogHistory do
        local v57 = LogHistory[i]
        local v58 = tostring(v57.message)

        if #v58 > 1000 then
            v58 = string.sub(v58, 1, 1000) .. "…"
        end

        table.insert(t3, {
            message = v58,
            messageType = if typeof(v57.messageType) == "EnumItem" then v57.messageType.Name else tostring(v57.messageType),
            timestamp = v57.timestamp
        })
    end

    return t3
end

local function captureClientMicroprofiler(p9) -- line: 551
    -- upvalues: MicroprofileCapture (copy), RunService (copy), MicroProfilerConfig (copy), result (ref), ensureArmed (copy)
    return MicroprofileCapture.Run(function() -- line: 552
        -- upvalues: p9 (copy), MicroprofileCapture (copy), RunService (copy), MicroProfilerConfig (copy), result (ref), ensureArmed (copy)
        local v59 = ensureArmed(8)

        assert(v59 and result, "libmp_unavailable")

        local v61 = MicroProfilerConfig.FramesBefore:Get() + MicroProfilerConfig.FramesAfter:Get() + 1

        local function v62() -- line: 556
            -- upvalues: v59 (copy), p9 (copy), MicroprofileCapture (copy), RunService (copy), result (ref)
            v59:SetFrameLimit(p9)
            v59:EnableProfiler(true)
            v59:EnableCapture(true)

            for _ = 1, p9 + 12 do
                RunService.RenderStepped:Wait()
            end

            return MicroprofileCapture.Export(result, v59:CaptureToBufferSync(), nil, 67108864)
        end

        local ok, result2 = pcall(v62)

        local function v63() -- line: 565
            -- upvalues: v59 (copy), v61 (copy)
            v59:SetFrameLimit(v61)
        end

        pcall(v63)

        if not ok then
            error(result2, 0)
        end

        return result2
    end)
end

local Name

local function getDeviceName() -- line: 577
    -- upvalues: DeviceForm (copy), Name (ref)
    if not Name then
        local v64 = DeviceForm.Get()

        if v64 then
            Name = v64.Name
        end
    end

    return Name
end

local function getClientMemoryMb() -- line: 589
    -- upvalues: Stats (copy)
    local function v65() -- line: 590
        -- upvalues: Stats (copy)
        return Stats:GetTotalMemoryUsageMb()
    end

    local ok, result = pcall(v65)

    return if ok and type(result) == "number" then result else nil
end

local function getClientMeta() -- line: 601
    -- upvalues: GuiService (copy), Workspace (copy), DeviceForm (copy), getRecentAvgFps (copy), Name (ref)
    local t5 = {
        avgFps = getRecentAvgFps()
    }

    if not Name then
        local v66 = DeviceForm.Get()

        if v66 then
            Name = v66.Name
        end
    end

    local Name2 = Name

    t5.device = Name2
    t5.engineVersion = version()

    local function v67() -- line: 607
        -- upvalues: t5 (copy), Workspace (copy)
        local CurrentCamera = Workspace.CurrentCamera

        if not CurrentCamera then
            return
        end

        local ViewportSize = CurrentCamera.ViewportSize

        t5.renderResolution = {
            x = math.round(ViewportSize.X),
            y = math.round(ViewportSize.Y)
        }
    end

    pcall(v67)

    local function v68() -- line: 614
        -- upvalues: t5 (copy), GuiService (copy)
        local ViewportDisplaySize = GuiService.ViewportDisplaySize

        t5.displaySize = {
            x = math.round(ViewportDisplaySize.X),
            y = math.round(ViewportDisplaySize.Y)
        }
    end

    pcall(v68)

    local function v69() -- line: 620
        -- upvalues: t5 (copy)
        t5.savedQualityLevel = UserSettings().GameSettings.SavedQualityLevel.Value
    end

    pcall(v69)

    return t5
end

local v70 = false

local function captureDataModelSnapshot(p10) -- line: 632
    -- upvalues: DataModel (copy), getRecentAvgFps (copy)
    if type(p10) ~= "table" then
        return nil, nil
    end

    local v71 = getRecentAvgFps()
    local capture = DataModel.capture
    local v72 = if v71 > 0 then 1 / v71 else nil
    local ok, result = pcall(capture, p10, v72)

    if not ok or type(result) ~= "table" then
        return nil, nil
    end

    if result.TimedOut then
        return {
            TimedOut = true
        }, nil
    end

    if typeof(result.Buffer) ~= "buffer" or buffer.len(result.Buffer) > 67108864 then
        return {
            Truncated = true
        }, nil
    end

    return {
        Classes = result.Classes,
        Props = result.Props,
        Truncated = result.Truncated
    }, result.Buffer
end

v7.OnClientEvent:Connect(function(p11, p12, p13) -- line: 650
    -- upvalues: MicroprofileCapture (copy), RunService (copy), Stats (copy), DeviceForm (copy), MicroProfilerConfig (copy), v8 (copy), result (ref), getRecentAvgFps (copy), ensureArmed (copy), collectClientLogs (copy), Name (ref), getClientMeta (copy), v70 (ref), captureDataModelSnapshot (copy)
    if type(p11) == "string" and type(p12) == "string" then
        task.spawn(function() -- line: 654
            -- upvalues: p11 (copy), p12 (copy), p13 (copy), MicroprofileCapture (copy), RunService (copy), Stats (copy), DeviceForm (copy), MicroProfilerConfig (copy), v8 (copy), result (ref), getRecentAvgFps (copy), ensureArmed (copy), collectClientLogs (copy), Name (ref), getClientMeta (copy), v70 (ref), captureDataModelSnapshot (copy)
            if p12 == "fps" then
                local t8 = {
                    fps = getRecentAvgFps()
                }

                if not Name then
                    local v73 = DeviceForm.Get()

                    if v73 then
                        Name = v73.Name
                    end
                end

                t8.device = Name

                local function v74() -- line: 590
                    -- upvalues: Stats (copy)
                    return Stats:GetTotalMemoryUsageMb()
                end

                local ok, result = pcall(v74)

                t8.memory = if not ok or type(result) ~= "number" then nil else result
                v8:FireServer(p11, t8)
            elseif p12 == "output" then
                v8:FireServer(p11, {
                    logs = collectClientLogs()
                })
            elseif p12 == "microprofiler" then
                if v70 then
                    v8:FireServer(p11, {
                        error = "busy"
                    })
                else
                    v70 = true

                    local t9, v75

                    local function v76() -- line: 670
                        -- upvalues: t9 (ref), v75 (ref), p13 (copy), MicroprofileCapture (copy), RunService (copy), MicroProfilerConfig (copy), result (ref), ensureArmed (copy), getClientMeta (copy), captureDataModelSnapshot (copy)
                        local v77 = type(p13) == "table"
                        local v78 = if v77 then type(p13.frames) == "number" else nil
                        local v81 = math.clamp(math.floor(if not v77 or not v78 then 128 else p13.frames), 8, 256)
                        local dataModel = if type(p13) == "table" then p13.dataModel else nil
                        local v82, v83 = MicroprofileCapture.Run(function() -- line: 552
                            -- upvalues: v81 (copy), MicroprofileCapture (copy), RunService (copy), MicroProfilerConfig (copy), result (ref), ensureArmed (copy)
                            local v84 = ensureArmed(8)

                            assert(v84 and result, "libmp_unavailable")

                            local v86 = MicroProfilerConfig.FramesBefore:Get() + MicroProfilerConfig.FramesAfter:Get() + 1

                            local function v87() -- line: 556
                                -- upvalues: v81 (copy), MicroprofileCapture (copy), RunService (copy), result (ref), v84 (copy)
                                v84:SetFrameLimit(v81)
                                v84:EnableProfiler(true)
                                v84:EnableCapture(true)

                                for _ = 1, v81 + 12 do
                                    RunService.RenderStepped:Wait()
                                end

                                return MicroprofileCapture.Export(result, v84:CaptureToBufferSync(), nil, 67108864)
                            end

                            local ok, result2 = pcall(v87)

                            local function v88() -- line: 565
                                -- upvalues: v84 (copy), v86 (copy)
                                v84:SetFrameLimit(v86)
                            end

                            pcall(v88)

                            if not ok then
                                error(result2, 0)
                            end

                            return result2
                        end)

                        if v82 then
                            if #v82 > 67108864 then
                                t9 = {
                                    error = "Dump size over 64mb. Cannot be retrieved."
                                }
                            else
                                t9 = {
                                    ok = true,
                                    meta = getClientMeta(),
                                    Microprofile = v82
                                }

                                if dataModel then
                                    local v89, v90 = captureDataModelSnapshot(dataModel)

                                    if v89 then
                                        t9.snapshot = v89
                                        v75 = v90
                                    end
                                end
                            end
                        else
                            t9 = {
                                error = v83 or "libmp_unavailable"
                            }
                        end
                    end

                    local ok, result2 = pcall(v76)

                    v70 = false

                    if not ok then
                        t9 = {
                            error = tostring(result2)
                        }
                    end

                    local t10 = t9

                    v8:FireServer(p11, t10, nil, v75)
                end
            end
        end)
    end
end)
