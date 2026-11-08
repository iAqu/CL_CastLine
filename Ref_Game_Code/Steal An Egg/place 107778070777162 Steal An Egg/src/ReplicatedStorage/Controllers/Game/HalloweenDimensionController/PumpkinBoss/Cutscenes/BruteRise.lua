-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local CutsceneHelperFunctions = require(ReplicatedStorage.Controllers.Game.AdminAbuseClientController.CutsceneHelperFunctions)
local HiddenUIHandler = require(ReplicatedStorage.Client.HiddenUIHandler)
local PumpkinBossState = require(ReplicatedStorage.Shared.Util.PumpkinBossState)
local Trove = require(ReplicatedStorage.Packages.Trove)
local MoonScene = require(script.Parent.MoonScene)

require(script.Parent.Parent.Scenes)

local Transition = require(script.Parent.Parent.Transition)
local t1 = {
    { 0, 10 },
    { 23, 10.32 },
    { 49, 11.35 },
    { 80, 13.28 },
    { 127, 17.03 },
    { 181, 21.43 },
    { 213, 23.49 },
    { 239, 24.6 },
    { 262, 24.99 },
    { 265, 25 },
    { 266, 15 },
    { 282, 15.31 },
    { 301, 16.33 },
    { 326, 18.41 },
    { 373, 22.83 },
    { 394, 24.29 },
    { 411, 24.92 },
    { 419, 25 },
    { 420, 15 },
    { 930, 15 }
}

for _, v1 in t1 do
    v1[2] = math.clamp(v1[2] * 1.5, 1, 120)
end

local v3 = t1[#t1][1] / 60

local function fieldOfViewAt(p1) -- line: 58
    -- upvalues: t1 (copy)
    local v4 = t1[1]

    for i = 2, #t1 do
        local v5 = t1[i]

        if p1 <= v5[1] then
            local v7 = math.clamp((p1 - v4[1]) / (v5[1] - v4[1]), 0, 1)

            return v4[2] + (v5[2] - v4[2]) * v7
        end

        v4 = v5
    end

    return v4[2]
end

local function findAssets() -- line: 71
    -- upvalues: ReplicatedStorage (copy)
    local Assets = ReplicatedStorage:FindFirstChild("Assets")
    local HalloweenDimension = Assets and Assets:FindFirstChild("HalloweenDimension")

    return HalloweenDimension and HalloweenDimension:FindFirstChild("PumpkinBoss")
end

local function play(p2) -- line: 77
    -- upvalues: ReplicatedStorage (copy), RunService (copy), Workspace (copy), CutsceneHelperFunctions (copy), HiddenUIHandler (copy), PumpkinBossState (copy), Trove (copy), MoonScene (copy), Transition (copy), v3 (copy), fieldOfViewAt (copy)
    local Attribute = p2.Arena:GetAttribute(PumpkinBossState.Attributes.Center)
    local Assets = ReplicatedStorage:FindFirstChild("Assets")
    local HalloweenDimension = Assets and Assets:FindFirstChild("HalloweenDimension")
    local PumpkinBoss = HalloweenDimension and HalloweenDimension:FindFirstChild("PumpkinBoss")

    if typeof(Attribute) ~= "Vector3" or PumpkinBoss == nil then
        warn("[PumpkinBoss] BruteRise can't find the arena centre or Assets.HalloweenDimension.PumpkinBoss")
    else
        local v8 = Trove.new()
        local v9 = v8:Add(Instance.new("Folder"))

        v9.Name = "PumpkinBossBruteRise"
        v9.Parent = Workspace

        local v10 = CFrame.new(Attribute - Vector3.new(-42.83, 121.89, 980.7))
        local LoadAnimationIntoRig = CutsceneHelperFunctions.GetHelperFunctions(v8).LoadAnimationIntoRig
        local t2 = {}
        local Torso, v11, Torso2, v12

        for _, v13 in { "IntroCinematic_PumpkinBoss", "IntroCinematic_HumanoidCameraRig" } do
            local v14 = PumpkinBoss:FindFirstChild(v13)
            local Animation = v14 and v14:FindFirstChildOfClass("Animation")

            if v14 == nil or not v14:IsA("Model") or Animation == nil then
                warn((("[PumpkinBoss] BruteRise needs %* with an Animation child"):format(v13)))
                v8:Destroy()

                return nil
            end

            local clone = v14:Clone()

            clone:PivotTo(v10 * clone:GetPivot())
            clone.Parent = v9

            local v15 = LoadAnimationIntoRig(clone, Animation.AnimationId)

            table.insert(t2, v15)

            if v13 == "IntroCinematic_HumanoidCameraRig" then
                v12 = v15

                local Torso3 = clone:FindFirstChild("Torso")

                if Torso3 and Torso3:IsA("BasePart") then
                    Torso2 = Torso3
                    Torso = Torso3
                else
                    Torso = nil
                    Torso2 = nil
                end

                v11 = v15
            end
        end

        if Torso2 ~= nil and v12 ~= nil then
            local v16 = p2.At + 0.7 - Workspace:GetServerTimeNow()
            local v18 = math.max(-v16, 0)
            local v19 = false
            local v20 = false

            if v16 > 0 then
                v19 = true
                v20 = true
                Transition.Cover(false, 1.7, 0.35)
            end

            local CurrentCamera = Workspace.CurrentCamera
            local FieldOfView = CurrentCamera.FieldOfView

            v8:Add(HiddenUIHandler.Acquire())

            local v21 = v8:Extend()

            v21:Add(function() -- line: 135
                -- upvalues: p2 (copy), CurrentCamera (copy), FieldOfView (copy), RunService (copy)
                RunService:UnbindFromRenderStep("PumpkinBossBruteRise")
                CurrentCamera.CameraType = Enum.CameraType.Custom
                CurrentCamera.FieldOfView = FieldOfView

                local Character = p2.Player.Character

                CurrentCamera.CameraSubject = if Character then Character:FindFirstChildOfClass("Humanoid") else nil
            end)

            local function begin() -- line: 143
                -- upvalues: p2 (copy), t2 (copy), Torso (ref), v11 (ref), v18 (copy), v19 (ref), v20 (ref), CurrentCamera (copy), v21 (copy), RunService (copy), MoonScene (copy), Transition (copy), fieldOfViewAt (copy)
                MoonScene.HidePlayers(v21, p2.Name)

                local v22 = os.clock() - v18

                for _, v23 in t2 do
                    v23:Play(0)
                    v23.TimePosition = v18
                end

                RunService:BindToRenderStep("PumpkinBossBruteRise", Enum.RenderPriority.Camera.Value + 1, function() -- line: 152
                    -- upvalues: v22 (copy), t2 (copy), Torso (ref), v11 (ref), v19 (ref), v20 (ref), CurrentCamera (copy), Transition (copy), fieldOfViewAt (copy)
                    local v25 = os.clock() - v22

                    for _, v26 in t2 do
                        if v26.IsPlaying and v26.Length > 0 and math.abs(v26.TimePosition - v25) > 0.4 then
                            v26.TimePosition = math.min(v25, v26.Length)
                        end
                    end

                    if v11.Length <= 0 then
                        return
                    end

                    local CFrame = Torso.CFrame

                    CurrentCamera.CameraType = Enum.CameraType.Scriptable
                    CurrentCamera.CFrame = CFrame
                    CurrentCamera.Focus = CFrame
                    CurrentCamera.FieldOfView = fieldOfViewAt(v25 * 60)

                    if not v20 then
                        return
                    end

                    v20 = false
                    v19 = false
                    Transition.Reveal(0.5)
                end)
            end

            if v16 > 0 then
                v8:Add(task.delay(v16, begin))
            else
                begin()
            end

            local v28 = v16 + v3 - 1.2

            v8:Add(task.delay(math.max(v28, 0), function() -- line: 182
                -- upvalues: p2 (copy), v19 (ref), v20 (ref), v28 (copy), Transition (copy), v3 (copy)
                v20 = false
                v19 = true
                Transition.Cover(v28 <= 0, p2.Seconds - 0.7 - v3 + 1.2)
            end))
            v8:Add(task.delay(math.max(v16 + v3, 0), function() -- line: 187
                -- upvalues: v8 (copy), v21 (copy)
                v8:Remove(v21)
            end))

            local v33 = false

            local function stop() -- line: 192
                -- upvalues: v8 (copy), v19 (ref), v33 (ref), Transition (copy)
                if v33 then
                    return
                end

                v33 = true
                v8:Destroy()

                if v19 then
                    Transition.Reveal()
                end
            end

            task.delay(math.max(v16 + p2.Seconds - 0.7, 0), stop)

            return {
                Stop = stop
            }
        end

        warn("[PumpkinBoss] BruteRise camera rig has no Torso")
        v8:Destroy()
    end

    return nil
end

return table.freeze({
    Play = play
})
