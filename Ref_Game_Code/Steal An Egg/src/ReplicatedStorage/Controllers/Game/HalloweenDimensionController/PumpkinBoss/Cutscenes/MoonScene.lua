-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ContentProvider = game:GetService("ContentProvider")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local CutsceneHelperFunctions = require(ReplicatedStorage.Controllers.Game.AdminAbuseClientController.CutsceneHelperFunctions)
local HiddenUIHandler = require(ReplicatedStorage.Client.HiddenUIHandler)
local LightingController = require(ReplicatedStorage.Controllers.Game.LightingController)
local MusicDirector = require(ReplicatedStorage.Client.MusicDirector)
local Trove = require(ReplicatedStorage.Packages.Trove)

require(script.Parent.Parent.Scenes)

local Transition = require(script.Parent.Parent.Transition)
local v1 = Color3.new(0, 0, 0)

local function settle(p1, p2) -- line: 75
    -- upvalues: TweenService (copy)
    TweenService:Create(p1, TweenInfo.new(0), p2):Play()

    for v2, v3 in p2 do
        p1[v2] = v3
    end
end

local function setEmitting(p3, p4) -- line: 82
    for _, descendant in p3:GetDescendants() do
        if descendant:IsA("ParticleEmitter") or descendant:IsA("Trail") or descendant:IsA("Beam") then
            descendant.Enabled = p4
        end
    end
end

local function emit(p5) -- line: 91
    for _, descendant in p5:GetDescendants() do
        if descendant:IsA("ParticleEmitter") then
            local EmitCount = descendant:GetAttribute("EmitCount")
            local EmitDuration = descendant:GetAttribute("EmitDuration")
            local EmitDelay = descendant:GetAttribute("EmitDelay")
            local delay = task.delay

            if type(EmitDelay) ~= "number" then
                EmitDelay = 0
            end

            delay(EmitDelay, function() -- line: 100
                -- upvalues: descendant (copy), EmitCount (copy), EmitDuration (copy)
                if type(EmitCount) == "number" and EmitCount > 0 then
                    descendant:Emit(EmitCount)
                end

                if type(EmitDuration) == "number" and EmitDuration > 0 then
                    descendant.Enabled = true
                    task.delay(EmitDuration, function() -- line: 106
                        -- upvalues: descendant (copy)
                        descendant.Enabled = false
                    end)
                end
            end)
        end
    end
end

local function hidePlayers(p6, p7) -- line: 115
    -- upvalues: Players (copy), RunService (copy)
    local v4 = ("PumpkinBossMoonSceneHide%*"):format(p7)
    local t1 = {}
    local t2 = {}
    local t3 = {}

    local function hide() -- line: 121
        -- upvalues: t1 (copy), t2 (copy), t3 (copy), Players (copy)
        for _, player in Players:GetPlayers() do
            local Character = player.Character

            if Character ~= nil then
                for _, descendant in Character:GetDescendants() do
                    if descendant:IsA("BasePart") or descendant:IsA("Decal") then
                        if t1[descendant] == nil then
                            t1[descendant] = descendant.LocalTransparencyModifier
                        end

                        descendant.LocalTransparencyModifier = 1
                    elseif descendant:IsA("BillboardGui") and t2[descendant] == nil then
                        t2[descendant] = descendant.Enabled
                        descendant.Enabled = false
                    elseif descendant:IsA("Humanoid") and t3[descendant] == nil then
                        t3[descendant] = descendant.DisplayDistanceType
                        descendant.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
                    end
                end
            end
        end
    end

    hide()
    RunService:BindToRenderStep(v4, Enum.RenderPriority.Camera.Value + 1, hide)
    p6:Add(function() -- line: 146
        -- upvalues: v4 (copy), t1 (copy), t2 (copy), t3 (copy), RunService (copy)
        RunService:UnbindFromRenderStep(v4)

        for v5, v6 in t1 do
            v5.LocalTransparencyModifier = v6
        end

        for v7, v8 in t2 do
            v7.Enabled = v8
        end

        for v9, v10 in t3 do
            v9.DisplayDistanceType = v10
        end
    end)
end

local function play(p8, p9) -- line: 160
    -- upvalues: ContentProvider (copy), Lighting (copy), RunService (copy), SoundService (copy), TweenService (copy), Workspace (copy), CutsceneHelperFunctions (copy), HiddenUIHandler (copy), LightingController (copy), MusicDirector (copy), Trove (copy), Transition (copy), v1 (copy), setEmitting (copy), emit (copy), hidePlayers (copy)
    local Assets = p9.Assets
    local v11 = Trove.new()
    local v12 = CutsceneHelperFunctions.GetHelperFunctions(v11)
    local CurrentCamera = Workspace.CurrentCamera
    local CutsceneUI = p8.Player.PlayerGui.CutsceneUI
    local Black, Vignette = CutsceneUI.Black, CutsceneUI.Vignette
    local v13 = false

    local function stop() -- line: 170
        -- upvalues: v11 (copy), v13 (ref)
        if not v13 then
            v13 = true
            v11:Destroy()
        end
    end

    v11:Add(HiddenUIHandler.Acquire())

    local v14 = MusicDirector.Suppress()

    v11:Add(function() -- line: 180
        -- upvalues: p9 (copy), v14 (copy)
        if p9.HoldBlack then
            task.delay(3, v14)
        else
            v14()
        end
    end)
    hidePlayers(v11, p8.Name)
    CutsceneUI.Enabled = true
    Black.BackgroundColor3 = v1
    Black.Visible = true
    Vignette.ImageTransparency = 1
    Vignette.Visible = true

    local v15 = p8.At + 0.5 - Workspace:GetServerTimeNow()

    TweenService:Create(Black, TweenInfo.new((math.max(v15, 0))), {
        BackgroundTransparency = 0
    }):Play()
    v11:Add(function() -- line: 196
        -- upvalues: Black (copy), Vignette (copy), TweenService (copy), v1 (copy)
        local t4 = {
            BackgroundTransparency = 1,
            BackgroundColor3 = v1
        }

        TweenService:Create(Black, TweenInfo.new(0), t4):Play()

        for v16, v17 in t4 do
            Black[v16] = v17
        end

        Black.Visible = false

        local t5 = {
            ImageTransparency = 1,
            ImageColor3 = v1
        }

        TweenService:Create(Vignette, TweenInfo.new(0), t5):Play()

        for v18, v19 in t5 do
            Vignette[v18] = v19
        end

        Vignette.Visible = false
    end)

    local clone = v11:Clone(Assets[("%*Rigs"):format(p9.Prefix)])
    local clone2 = v11:Clone(Assets[("%*VFX"):format(p9.Prefix)])
    local clone3 = v11:Clone(Assets[("%*Set"):format(p9.Prefix)])
    local clone4 = Assets.CutsceneMusic:Clone()

    v11:Add(function() -- line: 207
        -- upvalues: clone4 (copy), TweenService (copy)
        if not clone4.IsPlaying then
            clone4:Destroy()

            return
        end

        local tween = TweenService:Create(clone4, TweenInfo.new(0.4), {
            Volume = 0
        })

        tween.Completed:Once(function() -- line: 213
            -- upvalues: clone4 (copy)
            clone4:Destroy()
        end)
        tween:Play()
    end)

    local v20 = clone.CameraRig[p9.CameraPart]
    local v21 = p9.Build({
        Rigs = clone,
        Vfx = clone2,
        Set = clone3,
        SetProperty = v12.SetProperty,
        TweenProperty = v12.TweenProperty,
        Emit = emit,
        SetEmitting = setEmitting
    })
    local t6 = {}

    for v22 in v21 do
        table.insert(t6, v22)
    end

    table.sort(t6)

    local FieldOfView = CurrentCamera.FieldOfView

    v11:Add(function() -- line: 235
        -- upvalues: p8 (copy), CurrentCamera (copy), FieldOfView (copy), RunService (copy), TweenService (copy)
        RunService:UnbindFromRenderStep("PumpkinBossMoonScene")

        local t7 = {
            FieldOfView = FieldOfView
        }

        TweenService:Create(CurrentCamera, TweenInfo.new(0), t7):Play()

        for v23, v24 in t7 do
            CurrentCamera[v23] = v24
        end

        CurrentCamera.CameraType = Enum.CameraType.Custom

        local Character = p8.Player.Character

        CurrentCamera.CameraSubject = if Character then Character:FindFirstChildOfClass("Humanoid") else nil
    end)

    local function finish() -- line: 245
        -- upvalues: p9 (copy), v11 (copy), v13 (ref), Transition (copy)
        if v13 then
            return
        end

        Transition.Cover(true, 3)

        if not v13 then
            v13 = true
            v11:Destroy()
        end

        if not p9.HoldBlack then
            Transition.Reveal(0.5)
        end
    end

    local function begin() -- line: 256
        -- upvalues: p8 (copy), p9 (copy), Assets (copy), v11 (copy), v12 (copy), CurrentCamera (copy), clone (copy), clone4 (copy), v20 (copy), v21 (copy), t6 (copy), finish (copy), Lighting (copy), RunService (copy), SoundService (copy), Workspace (copy), LightingController (copy)
        local v25 = ("PumpkinBoss%*"):format(p8.Name)

        LightingController.SetAuthoredLayer(v25, Assets.SceneLighting, 999, 0)
        v11:Add(function() -- line: 259
            -- upvalues: v25 (copy), LightingController (copy)
            LightingController.ClearLayer(v25, 0)
        end)

        for _, child in Assets.LightingAssets:GetChildren() do
            if Lighting:FindFirstChild(child.Name) == nil then
                v11:Clone(child).Parent = Lighting
            end
        end

        if p9.Setup then
            p9.Setup(v11)
        end

        local t8 = {}
        local v26, v27

        for _, child in clone:GetChildren() do
            local Animation = child:FindFirstChild("Animation")
            local v28 = v12.LoadAnimationIntoRig(child, Animation.AnimationId)

            table.insert(t8, v28)

            if child.Name == "CameraRig" then
                v27 = v28
                v26 = v28
            end
        end

        assert(v27, (("%* has no CameraRig"):format(p8.Name)))

        local v31 = math.max(Workspace:GetServerTimeNow() - p8.At - 0.5, 0)
        local v32 = os.clock() - v31

        for _, v33 in t8 do
            v33:Play(0)
            v33.TimePosition = v31
        end

        clone4.Parent = SoundService
        clone4.TimePosition = v31
        clone4:Play()
        RunService:BindToRenderStep("PumpkinBossMoonScene", Enum.RenderPriority.Camera.Value + 1, function() -- line: 294
            -- upvalues: v26 (ref), CurrentCamera (copy), v20 (copy)
            if v26.Length <= 0 then
                return
            end

            local CFrame = v20.CFrame

            CurrentCamera.CameraType = Enum.CameraType.Scriptable
            CurrentCamera.CFrame = CFrame
            CurrentCamera.Focus = CFrame
        end)

        local t9 = {}

        t9[1] = 1
        v11:Connect(RunService.Heartbeat, function() -- line: 305
            -- upvalues: t8 (copy), v32 (copy), t9 (copy), clone4 (copy), v21 (copy), t6 (copy)
            local v34 = os.clock() - v32

            for _, v35 in t8 do
                if not (v35.Length <= 0) and v35.Speed ~= 0 then
                    local v36 = v35.Length - 0.05

                    if v36 <= v34 then
                        v35.TimePosition = v36
                        v35:AdjustSpeed(0)
                    elseif math.abs(v35.TimePosition - v34) > 0.4 then
                        v35.TimePosition = v34
                    end
                end
            end

            if clone4.IsPlaying and math.abs(clone4.TimePosition - v34) > 0.4 then
                clone4.TimePosition = v34
            end

            local v39 = v34 * 60

            while t9[1] <= #t6 and t6[t9[1]] <= v39 do
                for _, v40 in v21[t6[t9[1]]] do
                    task.spawn(v40)
                end

                t9[1] += 1
            end
        end)
        task.delay(math.max(p9.Frames / 60 - v31, 0), finish)
    end

    v11:Add(task.spawn(function() -- line: 336
        -- upvalues: p8 (copy), clone (copy), clone2 (copy), clone3 (copy), begin (copy), ContentProvider (copy), Workspace (copy)
        clone.Parent = Workspace
        clone2.Parent = Workspace
        clone3.Parent = Workspace

        local t10 = {}

        for _, child in clone:GetChildren() do
            table.insert(t10, (child:FindFirstChild("Animation")))
        end

        ContentProvider:PreloadAsync(t10)

        local v42 = p8.At + 0.5 - Workspace:GetServerTimeNow()

        if v42 > 0 then
            task.wait(v42)
        end

        begin()
    end))

    return {
        Stop = stop
    }
end

return table.freeze({
    Play = play,
    HidePlayers = hidePlayers
})
