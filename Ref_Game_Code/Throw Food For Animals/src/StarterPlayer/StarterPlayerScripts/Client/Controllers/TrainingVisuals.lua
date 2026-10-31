-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local CollectionService = game:GetService("CollectionService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GameConfig = require(ReplicatedStorage.Config.GameConfig)
local AnimationLibrary = require(ReplicatedStorage.Shared.AnimationLibrary)
local t1 = {}
local TapBonus = GameConfig.Training.TapBonus
local t2 = {}

local function syncedPosition(p1) -- line: 29
    return (workspace:GetServerTimeNow() - p1.StartTime) * p1.Speed % p1.Length
end

local function attach(p2) -- line: 33
    -- upvalues: GameConfig (copy), AnimationLibrary (copy), t2 (copy)
    if t2[p2] then
        return
    end

    local v1 = p2:WaitForChild("HumanoidRootPart", 5)
    local v2 = p2:WaitForChild("LeftHand", 5)
    local v3 = p2:WaitForChild("RightHand", 5)
    local v4 = p2:WaitForChild("Humanoid", 5)

    if v1 and v2 and v3 and v4 then
        local BarPosition = p2:GetAttribute("BarPosition")
        local v5 = AnimationLibrary.GetPullUpLength()
        local v6 = v5 / GameConfig.Training.RepInterval
        local v7 = AnimationLibrary.Play(p2, AnimationLibrary.GetPullUpId(), {
            Looped = true,
            FadeTime = 0,
            Speed = v6,
            Priority = Enum.AnimationPriority.Action
        })
        local StartTime = p2:GetAttribute("StartTime")

        if v7 and StartTime then
            v7.TimePosition = (workspace:GetServerTimeNow() - StartTime) * v6 % v5
        end

        local t3 = {
            Track = v7,
            Bar = BarPosition,
            Left = v2,
            Right = v3,
            Root = v1,
            Speed = v6,
            Length = v5,
            StartTime = StartTime
        }

        t3.Conn = p2:GetAttributeChangedSignal("DoubleRepAt"):Connect(function() -- line: 53
            -- upvalues: p2 (copy), t3 (copy)
            t3.DoubleAt = p2:GetAttribute("DoubleRepAt")
        end)
        t2[p2] = t3
    end
end

local function updateDouble(p3) -- line: 60
    -- upvalues: GameConfig (copy), TapBonus (copy)
    local Track = p3.Track

    if not Track then
        p3.DoubleAt = nil

        return
    end

    if workspace:GetServerTimeNow() - p3.DoubleAt < GameConfig.Training.RepInterval then
        if not p3.Doubling then
            p3.Doubling = true
            Track:AdjustSpeed(p3.Speed * (1 + TapBonus.ExtraReps))
        end
    else
        p3.DoubleAt = nil
        p3.Doubling = false
        Track:AdjustSpeed(p3.Speed)

        if p3.StartTime then
            Track.TimePosition = (workspace:GetServerTimeNow() - p3.StartTime) * p3.Speed % p3.Length
        end
    end
end

local function detach(p4) -- line: 82
    -- upvalues: t2 (copy)
    local v8 = t2[p4]

    if not v8 then
        return
    end

    t2[p4] = nil

    if v8.Conn then
        v8.Conn:Disconnect()
    end

    if v8.Track then
        v8.Track:Stop(0)
    end
end

local function step() -- line: 90
    -- upvalues: GameConfig (copy), t2 (copy), updateDouble (copy)
    local KeepHandsOnBar = GameConfig.Training.KeepHandsOnBar

    for v9, v10 in pairs(t2) do
        if v9.Parent then
            if v10.DoubleAt then
                updateDouble(v10)
            end
        else
            t2[v9] = nil

            if v10.Conn then
                v10.Conn:Disconnect()
            end
        end

        if v9.Parent and KeepHandsOnBar and v10.Bar then
            if not v10.Left.Parent then
                v10.Left = v9:FindFirstChild("LeftHand") or v10.Left
            end

            if not v10.Right.Parent then
                v10.Right = v9:FindFirstChild("RightHand") or v10.Right
            end

            if not v10.Root.Parent then
                v10.Root = v9:FindFirstChild("HumanoidRootPart") or v10.Root
            end

            local v11 = (v10.Left.Position + v10.Right.Position) / 2
            local v12 = v10.Bar - v11

            if v12.Magnitude > 0.001 then
                v10.Root.CFrame = v10.Root.CFrame + v12
            end
        end
    end
end

function t1.Init() -- line: 112
    -- upvalues: CollectionService (copy), RunService (copy), attach (copy), detach (copy), step (copy)
    for _, v13 in ipairs(CollectionService:GetTagged("TrainingRig")) do
        task.spawn(attach, v13)
    end

    CollectionService:GetInstanceAddedSignal("TrainingRig"):Connect(function(p5) -- line: 116
        -- upvalues: attach (copy)
        task.spawn(attach, p5)
    end)
    CollectionService:GetInstanceRemovedSignal("TrainingRig"):Connect(detach)
    RunService.Heartbeat:Connect(step)
end

return t1
