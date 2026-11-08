-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local EncodingService = game:GetService("EncodingService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Observability = require(ReplicatedStorage.UserGenerated.Observability)
local Stream = require(ReplicatedStorage.UserGenerated.Observability.Stream)
local Registry = require(ReplicatedStorage.UserGenerated.Observability.Registry)
local Recorder = require(ReplicatedStorage.UserGenerated.Observability.Recorder)
local WorldRecorder = require(ReplicatedStorage.UserGenerated.Observability.WorldRecorder)
local AnimationRecorder = require(ReplicatedStorage.UserGenerated.Observability.AnimationRecorder)
local SoundRecorder = require(ReplicatedStorage.UserGenerated.Observability.SoundRecorder)
local ParticleRecorder = require(ReplicatedStorage.UserGenerated.Observability.ParticleRecorder)
local Styles = require(ReplicatedStorage.UserGenerated.Observability.Styles)
local InputCapture = require(ReplicatedStorage.UserGenerated.Observability.InputCapture)
local BackpackRecorder = require(ReplicatedStorage.UserGenerated.Observability.BackpackRecorder)
local Uplink = require(ReplicatedStorage.UserGenerated.Observability.Uplink)
local Remotes = Observability.Remotes
local v1 = false
local stop

local function run(p1) -- line: 38
    -- upvalues: EncodingService (copy), RunService (copy), Observability (copy), Stream (copy), Registry (copy), Recorder (copy), WorldRecorder (copy), AnimationRecorder (copy), SoundRecorder (copy), ParticleRecorder (copy), Styles (copy), InputCapture (copy), BackpackRecorder (copy), Uplink (copy), Remotes (copy), stop (ref)
    local elapsed = os.clock()
    local ServerTimeNow = workspace:GetServerTimeNow()

    local function clock() -- line: 41
        -- upvalues: elapsed (copy)
        return (os.clock() - elapsed) * 1000
    end

    local v2 = false
    local v3, v4, v5, v6, v7, v8, v9, v10, connection, v11

    local function stop2(p2, p3) -- line: 48
        -- upvalues: v2 (ref), v3 (ref), v4 (ref), v5 (ref), v6 (ref), v7 (ref), v8 (ref), v9 (ref), v10 (ref), connection (ref), v11 (ref), Observability (copy), Styles (copy), Remotes (copy), stop (ref)
        if v2 then
            return
        end

        v2 = true

        if v11 then
            v11:Destroy()
        end

        stop = nil

        if p3 then
            Remotes.Stop:FireServer(p2)
        end

        if connection then
            connection:Disconnect()
        end

        if v5 then
            v5:Destroy()
        end

        if v6 then
            v6:Destroy()
        end

        if v7 then
            v7:Destroy()
        end

        if v8 then
            v8:Destroy()
        end

        if v9 then
            v9:Destroy()
        end

        Observability.SetEmitSink(nil)

        if v4 then
            v4:Destroy()
        end

        Styles.Clear()

        if v10 then
            v10:Destroy()
        end

        v3.Stopped = true
    end

    stop = stop2
    v3 = Uplink.new(p1, function(p4) -- line: 90
        -- upvalues: Remotes (copy)
        Remotes.Data:FireServer(p4)
    end, function(p5) -- line: 92
        -- upvalues: stop2 (copy)
        stop2(p5, true)
    end)
    connection = RunService.Heartbeat:Connect(function(p6) -- line: 95
        -- upvalues: v3 (ref)
        v3:Step(p6)
    end)
    task.wait((math.max(0, elapsed + p1.CaptureDelay - os.clock())))

    if v2 then
        return
    end

    local v13 = Stream.new(p1.BatchBytes, function(p7, p8) -- line: 104
        -- upvalues: v3 (ref), EncodingService (copy)
        v3:Push(EncodingService:CompressBuffer(p7, Enum.CompressionAlgorithm.Zstd, 3), p8)
    end)

    v10 = InputCapture.new(clock)
    v8 = if p1.Audio == false then nil else SoundRecorder.new(clock)

    if p1.Workspace.Enabled then
        v9 = ParticleRecorder.new(p1.Particles, clock)
        Observability.SetEmitSink(function(p9, p10) -- line: 111
            -- upvalues: v9 (ref)
            v9:Emit(p9, p10)
        end)
    end

    v4 = Registry.new(p1.Manifest, v13, clock)

    if p1.BackpackData == true then
        v11 = BackpackRecorder.new(v4)
    end

    v5 = Recorder.new(v4, p1.PlayerGui.Enabled, false)

    local PlayerGui = v5.PlayerGui
    local PlayerGui2 = p1.PlayerGui

    v4:SetFilter(PlayerGui, PlayerGui2)

    if p1.Workspace.Enabled then
        local _workspace = workspace
        local Workspace = p1.Workspace

        v4:SetFilter(_workspace, Workspace)
    end

    v13.Init = true
    v13:Time((os.clock() - elapsed) * 1000)
    v13:ClockSync(ServerTimeNow)
    v10:WriteViewport(v13, true)

    if v11 then
        v11:Flush()
    end

    local t1 = {
        v5.PlayerGui
    }

    if p1.Workspace.Enabled then
        table.insert(t1, workspace)
    end

    Styles.Build(t1, v4.ClassPropsByName)
    v5:Snapshot()
    v13:Cut()
    v13.Init = false

    if v2 then
        return
    end

    if p1.Workspace.Enabled then
        v7 = AnimationRecorder.new(v4)
        v6 = WorldRecorder.new(v4, function(p11) -- line: 151
            -- upvalues: v5 (ref)
            v5:IdOf(p11)
        end, function(p12) -- line: 153
            -- upvalues: v7 (ref)
            v7:Watch(p12)
        end, p1.MaxWorldInstances or 50000, p1.BakeModels ~= false)
        v5:StartWorld()

        local BurstSeconds = p1.BurstSeconds

        v3:Burst(BurstSeconds)
        v13:Time((os.clock() - elapsed) * 1000)

        local v16 = v6

        v16:WriteCamera()
        v16:Snapshot()
    end

    if v8 then
        v8:Bind(v4)
    end

    if v9 and v6 then
        v9:Bind(v6)
    end

    if not v2 then
        local function idOf(p13) -- line: 172
            -- upvalues: v5 (ref)
            return v5:IdOf(p13)
        end

        local v19 = 1 / p1.TickRate
        local v20 = os.clock()
        local v21 = os.clock() + v19
        local v22 = os.clock()

        while not v2 do
            task.wait((math.max(0, math.min(v21, if v6 then v22 else v21) - os.clock())))

            if v2 then
                break
            end

            local elapsed = os.clock()
            local v25 = v21 <= elapsed
            local v26 = v6 ~= nil and v22 <= elapsed
            local v27, v28, v29, v30, v31

            if v25 then
                v27 = v21 + v19

                if v27 <= elapsed then
                    v27 = elapsed + v19
                end

                v31 = false
            elseif v26 then
                v27 = v21
                v31 = false
            else
                v28 = v20
                v30 = v21
                v29 = v22
                v31 = true
            end

            if not v31 then
                v30 = v27
                v13:BeginStage()

                if v25 then
                    v10:Flush(v13, idOf)

                    if v11 then
                        v11:Flush()
                    end

                    v5:Flush()

                    if v6 then
                        v6:Flush()
                    end

                    if v7 then
                        v7:Flush()
                    end

                    if v8 then
                        v8:Flush()
                    end

                    if v9 then
                        v9:Flush()
                    end
                end

                v29 = if v26 then v6:PollPlayers() else v22
                v13:CommitStage()

                if os.clock() - v20 >= 1 then
                    v28 = os.clock()
                    v13:Cut()
                else
                    v28 = v20
                end
            end

            v22 = v29
            v20 = v28
            v21 = v30
        end
    end
end

Remotes.Start.OnClientEvent:Connect(function(p14) -- line: 230
    -- upvalues: v1 (ref), stop (ref), run (copy)
    if v1 then
        return
    end

    v1 = true
    task.spawn(function() -- line: 235
        -- upvalues: p14 (copy), stop (ref), run (copy)
        local ok, result = pcall(run, p14)

        if not ok then
            warn("[UGUIReplay]", result)

            if stop then
                stop("error", true)
            end
        end
    end)
end)
Remotes.Emit.OnClientEvent:Connect(function(p15, p16) -- line: 248
    -- upvalues: Observability (copy)
    if typeof(p15) == "Instance" and type(p16) == "number" then
        Observability.RecordEmit(p15, p16)
    end
end)
Remotes.Stop.OnClientEvent:Connect(function(p17) -- line: 254
    -- upvalues: stop (ref)
    if stop then
        stop(p17, false)
    end
end)
Players.LocalPlayer.OnTeleport:Connect(function(p18) -- line: 262
    -- upvalues: Remotes (copy), stop (ref)
    if stop then
        if p18 == Enum.TeleportState.Started then
            Remotes.Teleport:FireServer(true)
        elseif p18 == Enum.TeleportState.Failed then
            Remotes.Teleport:FireServer(false)
        end
    end
end)
