-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local CameraShaker = require(ReplicatedStorage.Packages.CameraShaker)
local CameraShakerDriver = require(ReplicatedStorage.Client.CameraShakerDriver)
local LightVsDarknessEventFlags = require(ReplicatedStorage.Shared.Flags.LightVsDarknessEventFlags)
local Player = require(ReplicatedStorage.Shared.Player)
local Remotes = require(ReplicatedStorage.Shared.Remotes)

require(ReplicatedStorage.Packages.Trove)

local v1 = TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local v2 = TweenInfo.new(1.05, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
local v3 = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local LocalPlayer = Players.LocalPlayer
local v4
local v5 = CameraShaker.new()
local n1 = 0
local n2 = 0
local v6
local v7 = CFrame.identity
local tween = nil
local v8

local function settleCameraLead(p1, p2) -- line: 71
    -- upvalues: TweenService (copy), tween (ref)
    local tween2 = tween

    tween = nil

    if tween2 then
        tween2:Cancel()
    end

    if p1.Parent == nil then
        return
    end

    local tween3 = TweenService:Create(p1, p2, {
        CameraOffset = Vector3.new(0, 0, 0)
    })

    tween = tween3
    tween3:Play()
end

local function raiseCameraLead() -- line: 81
    -- upvalues: TweenService (copy), Player (copy), v1 (copy), v2 (copy), LocalPlayer (copy), tween (ref), v8 (ref), settleCameraLead (copy)
    local v9 = Player.FindHumanoid(LocalPlayer)

    if v9 == nil then
        return
    end

    local tween2 = tween

    tween = nil

    if tween2 then
        tween2:Cancel()
    end

    v8 = v9

    local tween3 = TweenService:Create(v9, v1, {
        CameraOffset = Vector3.new(0, 12, 0)
    })

    tween = tween3
    tween3.Completed:Once(function(p3) -- line: 92
        -- upvalues: v9 (copy), tween3 (copy), v2 (copy), tween (ref), settleCameraLead (copy)
        if tween == tween3 and p3 == Enum.PlaybackState.Completed then
            settleCameraLead(v9, v2)
        end
    end)
    tween3:Play()
end

local function isFlying() -- line: 118
    -- upvalues: LocalPlayer (copy)
    return LocalPlayer:GetAttribute("LvdFlying") == true
end

local function rootJointOf(p4) -- line: 123
    local LowerTorso = p4:FindFirstChild("LowerTorso")
    local v10 = if LowerTorso == nil then nil else LowerTorso:FindFirstChild("Root")

    if v10 == nil then
        local HumanoidRootPart = p4:FindFirstChild("HumanoidRootPart")

        v10 = if HumanoidRootPart ~= nil then HumanoidRootPart:FindFirstChild("RootJoint") else nil
    end

    return if v10 ~= nil and v10:IsA("Motor6D") then v10 else nil
end

local function releaseLean() -- line: 135
    -- upvalues: n1 (ref), n2 (ref), v6 (ref), v7 (ref)
    local v11 = v6

    v6 = nil

    if v11 ~= nil and v11.Parent ~= nil then
        v11.C0 = v7
    end

    n1 = 0
    n2 = 0
end

local function stepLean(p5) -- line: 155
    -- upvalues: LightVsDarknessEventFlags (copy), Player (copy), LocalPlayer (copy), n1 (ref), n2 (ref), v6 (ref), v7 (ref), rootJointOf (copy)
    local v12 = Player.FindCharacter(LocalPlayer)
    local v13 = Player.FindHumanoid(LocalPlayer)
    local v14 = Player.FindRootPart(LocalPlayer)
    local v15 = if v12 == nil then nil else rootJointOf(v12)
    local v16 = true

    if v15 == nil or v13 == nil or v14 == nil then
    elseif v14:IsA("BasePart") then
        if v6 ~= v15 then
            local v17 = v6

            v6 = nil

            if v17 ~= nil and v17.Parent ~= nil then
                v17.C0 = v7
            end

            n1 = 0
            n2 = 0
            v6 = v15
            v7 = v15.C0
        end

        v16 = false
    end

    if not v16 then
        local MoveDirection = v13.MoveDirection
        local v18, v19

        if LocalPlayer:GetAttribute("LvdFlying") == true and v13.Health > 0 and MoveDirection.Magnitude > 0.001 and LightVsDarknessEventFlags.FlyingLeanEnabled:Get() then
            local CFrame = v14.CFrame

            v18 = -0.7853981633974483 * CFrame.LookVector:Dot(MoveDirection)
            v19 = -0.2617993877991494 * CFrame.RightVector:Dot(MoveDirection)
        else
            v18 = 0
            v19 = 0
        end

        local v21 = 1 - math.exp(p5 * -8)

        n1 += (v18 - n1) * v21
        n2 += (v19 - n2) * v21

        if not (math.abs(n1) < 0.001 and math.abs(n2) < 0.001) then
            v15.C0 = v7 * CFrame.Angles(n1, 0, n2)
        else
            n1 = 0
            n2 = 0
            v15.C0 = v7
        end
    else
        local v29 = v6

        v6 = nil

        if v29 ~= nil and v29.Parent ~= nil then
            v29.C0 = v7
        end

        n1 = 0
        n2 = 0
    end
end

local function start() -- line: 195
    -- upvalues: RunService (copy), Player (copy), Remotes (copy), v3 (copy), LocalPlayer (copy), v4 (ref), v5 (copy), n1 (ref), n2 (ref), tween (ref), v8 (ref), settleCameraLead (copy), raiseCameraLead (copy), releaseLean (copy), stepLean (copy)
    n1 = 0
    n2 = 0
    v4.AssetTrove:Connect(LocalPlayer:GetAttributeChangedSignal("LvdFlying"), function() -- line: 197
        -- upvalues: Player (copy), v3 (copy), LocalPlayer (copy), tween (ref), v8 (ref), settleCameraLead (copy), raiseCameraLead (copy)
        if LocalPlayer:GetAttribute("LvdFlying") == true then
            raiseCameraLead()
        else
            local v30 = v8 or Player.FindHumanoid(LocalPlayer)

            v8 = nil

            local tween2 = tween

            tween = nil

            if tween2 then
                tween2:Cancel()
            end

            if v30 ~= nil and v30.Parent ~= nil and v30.CameraOffset ~= Vector3.new(0, 0, 0) then
                settleCameraLead(v30, v3)
            end
        end
    end)
    v4.AssetTrove:Connect(RunService.PreRender, stepLean)
    v4.AssetTrove:Add(releaseLean)
    v4.AssetTrove:Connect(Remotes.LightVsDarkness.Struck.OnClientEvent, function() -- line: 203
        -- upvalues: v5 (copy)
        v5:ShakeOnce(3, 12, 0.1, 0.8)
    end)

    if LocalPlayer:GetAttribute("LvdFlying") == true then
        raiseCameraLead()
    else
        local v31 = v8 or Player.FindHumanoid(LocalPlayer)

        v8 = nil

        local tween2 = tween

        tween = nil

        if tween2 then
            tween2:Cancel()
        end

        if v31 ~= nil and v31.Parent ~= nil and v31.CameraOffset ~= Vector3.new(0, 0, 0) then
            settleCameraLead(v31, v3)
        end
    end
end

local function stop() -- line: 209
    -- upvalues: Player (copy), v3 (copy), LocalPlayer (copy), n1 (ref), n2 (ref), v6 (ref), v7 (ref), tween (ref), v8 (ref), settleCameraLead (copy)
    local v32 = v6

    v6 = nil

    if v32 ~= nil and v32.Parent ~= nil then
        v32.C0 = v7
    end

    n1 = 0
    n2 = 0

    local v33 = v8 or Player.FindHumanoid(LocalPlayer)

    v8 = nil

    local tween2 = tween

    tween = nil

    if tween2 then
        tween2:Cancel()
    end

    if v33 ~= nil and v33.Parent ~= nil and v33.CameraOffset ~= Vector3.new(0, 0, 0) then
        settleCameraLead(v33, v3)
    end
end

CameraShakerDriver.Start(v5, Enum.RenderPriority.Camera.Value + 2)

return function(p6) -- line: 218
    -- upvalues: v4 (ref), start (copy), stop (copy)
    v4 = p6

    return {
        Start = start,
        Stop = stop
    }
end
