-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ContentProvider = game:GetService("ContentProvider")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local CutsceneHelperFunctions = require(script.Parent.Parent.Parent.Parent.CutsceneHelperFunctions)
local HiddenUIHandler = require(ReplicatedStorage.Client.HiddenUIHandler)
local LightingController = require(ReplicatedStorage.Controllers.Game.LightingController)
local Tabs = require(ReplicatedStorage.Client.Tabs)

require(ReplicatedStorage.Packages.Trove)

local OutroCutscene1 = ReplicatedStorage.CutsceneAssets.ScrambleBossCutsceneAssets.OutroCutscene1
local t1 = {
    Enum.CoreGuiType.Backpack,
    Enum.CoreGuiType.Chat,
    Enum.CoreGuiType.PlayerList,
    Enum.CoreGuiType.Health,
    Enum.CoreGuiType.EmotesMenu
}
local t2 = {
    "Sky",
    "Atmosphere"
}
local CurrentCamera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer
local v1, t3, v2, t4
local t5 = {}

local function restoreCamera() -- line: 50
    -- upvalues: TweenService (copy), CurrentCamera (copy), LocalPlayer (copy)
    TweenService:Create(CurrentCamera, TweenInfo.new(0), {
        FieldOfView = 70
    }):Play()
    CurrentCamera.FieldOfView = 70
    CurrentCamera.CameraType = Enum.CameraType.Custom
    CurrentCamera.CameraSubject = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") or nil
    LocalPlayer.ReplicationFocus = nil
end

local function hideAllUi() -- line: 60
    -- upvalues: StarterGui (copy), Tabs (copy), t1 (copy), LocalPlayer (copy), t3 (ref), v2 (ref), t4 (ref)
    if t3 ~= nil then
        return
    end

    local t6 = {}

    v2 = Tabs.Active()

    for _, child in LocalPlayer:WaitForChild("PlayerGui"):GetChildren() do
        if child:IsA("ScreenGui") and child.Name ~= "CutsceneUI" and child.Enabled then
            t6[child] = true
            child.Enabled = false
        end
    end

    t3 = t6

    local function v3() -- line: 75
        -- upvalues: LocalPlayer (copy)
        LocalPlayer.PlayerGui.BottomUI.BottomFrame.Holder.List.Visible = false
    end

    pcall(v3)

    local t7 = {}

    for _, v4 in t1 do
        t7[v4] = StarterGui:GetCoreGuiEnabled(v4)
        StarterGui:SetCoreGuiEnabled(v4, false)
    end

    t4 = t7
end

local function restoreAllUi() -- line: 85
    -- upvalues: StarterGui (copy), LocalPlayer (copy), t3 (ref), v2 (ref), t4 (ref)
    local t8 = t3
    local v5 = v2

    t3 = nil
    v2 = nil

    if t8 ~= nil then
        for v6 in t8 do
            if v6.Parent ~= nil and v6.Name ~= v5 then
                v6.Enabled = true
            end
        end
    end

    local function v7() -- line: 98
        -- upvalues: LocalPlayer (copy)
        LocalPlayer.PlayerGui.BottomUI.BottomFrame.Holder.List.Visible = true
    end

    pcall(v7)

    local t9 = t4

    t4 = nil

    if t9 ~= nil then
        for v8, v9 in t9 do
            StarterGui:SetCoreGuiEnabled(v8, v9)
        end
    end

    return v5
end

local function hideCutsceneUi() -- line: 110
    -- upvalues: HiddenUIHandler (copy), v1 (ref), hideAllUi (copy)
    if v1 == nil then
        v1 = HiddenUIHandler.Acquire()
    end

    hideAllUi()
end

local function restoreCutsceneUi() -- line: 117
    -- upvalues: Tabs (copy), v1 (ref), restoreAllUi (copy)
    local v10 = restoreAllUi()
    local v11 = v1

    v1 = nil

    if v11 ~= nil then
        v11()
    end

    if v10 ~= nil then
        Tabs.Activate(v10, {
            instant = true
        })
    end
end

local function setTransparency(p1, p2) -- line: 129
    for _, v12 in p1 do
        if v12:IsA("BasePart") then
            if not v12:GetAttribute("OriginalTransparency") then
                v12:SetAttribute("OriginalTransparency", v12.Transparency)
            end

            v12.Transparency = p2 or v12:GetAttribute("OriginalTransparency")
        end
    end
end

local function restoreGuard(p3, p4) -- line: 142
    -- upvalues: t5 (copy)
    t5[p3] = nil

    local Guard = p4:FindFirstChild("Guard")

    if Guard == nil or Guard == p3 then
        p3.Parent = p4
    end
end

local function hideAllGuardsAndNests(p5) -- line: 151
    -- upvalues: t5 (copy), setTransparency (copy)
    for _, child in (game.Workspace.World.Areas.GuardAreas:GetChildren()) do
        local Guard = child.Guard

        t5[Guard] = child
        Guard.Parent = nil

        local Nests = child:FindFirstChild("Nests")
        local v13 = Nests and Nests:GetDescendants()

        if v13 then
            setTransparency(v13, 1)
        end

        p5:Add(function() -- line: 165
            -- upvalues: child (copy), Guard (copy), Nests (copy), v13 (copy), t5 (copy), setTransparency (copy)
            t5[Guard] = nil

            local Guard2 = child:FindFirstChild("Guard")

            if Guard2 == nil or Guard2 == Guard then
                Guard.Parent = child
            end

            if Nests then
                setTransparency(v13)
            end
        end)
    end
end

local function restoreAllGuardsAndNests() -- line: 174
    -- upvalues: t5 (copy), setTransparency (copy)
    for v14, v15 in t5 do
        t5[v14] = nil

        local Guard = v15:FindFirstChild("Guard")

        if Guard == nil or Guard == v14 then
            v14.Parent = v15
        end

        local Nests = v15:FindFirstChild("Nests")
        local v16 = Nests and Nests:GetDescendants()

        if v16 then
            setTransparency(v16)
        end
    end
end

local function setEmitting(p6, p7) -- line: 186
    for _, descendant in p6:GetDescendants() do
        if descendant:IsA("ParticleEmitter") or descendant:IsA("Trail") or descendant:IsA("Beam") then
            descendant.Enabled = p7
        end
    end
end

local function emitBurst(p8) -- line: 194
    for _, descendant in p8:GetDescendants() do
        if descendant:IsA("ParticleEmitter") then
            local EmitCount = descendant:GetAttribute("EmitCount")
            local EmitDuration = descendant:GetAttribute("EmitDuration")

            if type(EmitCount) == "number" and EmitCount ~= 0 then
                descendant:Emit(EmitCount)
            end

            if type(EmitDuration) == "number" and EmitDuration ~= 0 then
                descendant.Enabled = true
                task.delay(EmitDuration, function() -- line: 207
                    -- upvalues: descendant (copy)
                    descendant.Enabled = false
                end)
            end
        end
    end
end

return function(p9) -- line: 216
    -- upvalues: ContentProvider (copy), Lighting (copy), ReplicatedStorage (copy), RunService (copy), SoundService (copy), TweenService (copy), Workspace (copy), CutsceneHelperFunctions (copy), LightingController (copy), Tabs (copy), OutroCutscene1 (copy), t2 (copy), CurrentCamera (copy), LocalPlayer (copy), v1 (ref), restoreCamera (copy), restoreAllUi (copy), hideCutsceneUi (copy), hideAllGuardsAndNests (copy), restoreAllGuardsAndNests (copy), setEmitting (copy), emitBurst (copy)
    local v17 = CutsceneHelperFunctions.GetHelperFunctions(p9)
    local SetProperty, TweenProperty, LoadAnimationIntoRig = v17.SetProperty, v17.TweenProperty, v17.LoadAnimationIntoRig
    local CutsceneUI = LocalPlayer.PlayerGui.CutsceneUI
    local Black, Vignette = CutsceneUI.Black, CutsceneUI.Vignette
    local clone
    local t10 = {
        [0] = {
            SetProperty("Workspace.CurrentCamera.CFrame", CFrame.new(-5252.8594, -234.99, 2545.4341, 0.791, 0.1643, -0.5893, -0, 0.9633, 0.2685, 0.6118, -0.2124, 0.762)),
            SetProperty("Workspace.CurrentCamera.FieldOfView", 25),
            function() -- line: 232
                -- upvalues: clone (ref), setEmitting (copy)
                setEmitting(clone.Dizzy, false)
            end,
            SetProperty("Workspace.ScrambleBossOutro1VFX.Flight.CFrame", CFrame.new(2491.416, 264.4008, 1463.5636, 0, 1, 0, 0, 0, -1, -1, 0, 0)),
            TweenProperty("Workspace.ScrambleBossOutro1VFX.Flight.CFrame", TweenInfo.new(2.25, Enum.EasingStyle.Linear), CFrame.new(2491.416, 262.4489, 1466.665, 0, 1, 0, 0.5558, 0, -0.8313, -0.8313, 0, -0.5558)),
            SetProperty("Workspace.ScrambleBossOutro1Rigs.DrScramble.Back.Transparency", 0),
            SetProperty("Workspace.ScrambleBossOutro1Rigs.DrScramble.Body.Transparency", 0),
            SetProperty("Workspace.ScrambleBossOutro1Rigs.DrScramble.Hair.Transparency", 0),
            SetProperty("Workspace.ScrambleBossOutro1Rigs.DrScramble.HeadGrin.Transparency", 1),
            SetProperty("Workspace.ScrambleBossOutro1Rigs.DrScramble.HeadLaugh.Transparency", 0),
            SetProperty("Workspace.ScrambleBossOutro1Rigs.DrScramble.HeadSmile.Transparency", 1),
            SetProperty("Workspace.ScrambleBossOutro1Rigs.BrockkodileHeadRig.BrockHeads.Angry.LeftEye.Transparency", 0),
            SetProperty("Workspace.ScrambleBossOutro1Rigs.BrockkodileHeadRig.BrockHeads.Angry.RightEye.Transparency", 0),
            SetProperty("PlayerGui.CutsceneUI.Black.BackgroundTransparency", 1),
            SetProperty("PlayerGui.CutsceneUI.Black.BackgroundColor3", Color3.new(0, 0, 0)),
            TweenProperty("PlayerGui.CutsceneUI.Black.BackgroundColor3", TweenInfo.new(13.533333333333333, Enum.EasingStyle.Linear), Color3.new(0.465771, 1, 0.223529)),
            SetProperty("Lighting.DepthOfField.Enabled", true),
            SetProperty("Lighting.DepthOfField.InFocusRadius", 10),
            SetProperty("Lighting.DepthOfField.FocusDistance", 0.05),
            SetProperty("Lighting.DepthOfField.NearIntensity", 0.75),
            SetProperty("Workspace.ScrambleBossOutro1VFX.Angry.AngryHead.CFrame", CFrame.new(2474.0251, 255.93, 1386.3206, -0.8877, 0, -0.4605, 0, 1, 0, 0.4605, 0, -0.8877)),
            SetProperty("Workspace.ScrambleBossOutro1VFX.Angry.AngryHead.Transparency", 0),
            SetProperty("Lighting.CutsceneBlur.Enabled", true),
            SetProperty("Lighting.CutsceneBlur.Size", 2),
            SetProperty("PlayerGui.CutsceneUI.Vignette.ImageTransparency", 1),
            SetProperty("PlayerGui.CutsceneUI.Vignette.Visible", true),
            SetProperty("Lighting.Brock.TintColor", Color3.new(1, 1, 1)),
            SetProperty("Lighting.Brock.Enabled", true),
            SetProperty("Lighting.Brock.Saturation", 0),
            SetProperty("Lighting.Brock.Contrast", 0)
        },
        [28] = { TweenProperty("PlayerGui.CutsceneUI.Vignette.ImageTransparency", TweenInfo.new(0.15, Enum.EasingStyle.Linear), 0) },
        [108] = {
            function() -- line: 269
                -- upvalues: clone (ref), emitBurst (copy)
                emitBurst(clone.BatHit)
            end
        },
        [135] = { TweenProperty("Workspace.ScrambleBossOutro1VFX.Flight.CFrame", TweenInfo.new(0.11666666666666667, Enum.EasingStyle.Linear), CFrame.new(2498.4275, 284.1872, 1493.1517, -0, 0.9939, -0.1099, 0.7073, -0.0777, -0.7026, -0.7069, -0.0777, -0.703)) },
        [136] = { TweenProperty("Lighting.DepthOfField.InFocusRadius", TweenInfo.new(1.0333333333333334, Enum.EasingStyle.Linear), 350) },
        [142] = { TweenProperty("Workspace.ScrambleBossOutro1VFX.Flight.CFrame", TweenInfo.new(0.13333333333333333, Enum.EasingStyle.Linear), CFrame.new(2506.4163, 314.5122, 1526.4484, -0.0672, 0.9973, -0.0301, 0.2867, -0.0095, -0.958, -0.9557, -0.073, -0.2853)) },
        [150] = { TweenProperty("Workspace.ScrambleBossOutro1VFX.Flight.CFrame", TweenInfo.new(0.11666666666666667, Enum.EasingStyle.Linear), CFrame.new(2513.6011, 347.2467, 1557.4293, -0.0884, 0.9943, 0.059, -0.1444, 0.0458, -0.9885, -0.9856, -0.0959, 0.1395)) },
        [154] = { TweenProperty("PlayerGui.CutsceneUI.Vignette.ImageTransparency", TweenInfo.new(0.5833333333333334, Enum.EasingStyle.Linear), 1) },
        [157] = { TweenProperty("Workspace.ScrambleBossOutro1VFX.Flight.CFrame", TweenInfo.new(0.08333333333333333, Enum.EasingStyle.Linear), CFrame.new(2516.4177, 403.7317, 1583.1393, -0.1004, 0.9943, 0.035, 0.1082, 0.0458, -0.9931, -0.9891, -0.0959, -0.1121)) },
        [162] = { TweenProperty("Workspace.ScrambleBossOutro1VFX.Flight.CFrame", TweenInfo.new(0.08333333333333333, Enum.EasingStyle.Linear), CFrame.new(2520.0452, 465.6886, 1612.6007, -0.1004, 0.9946, -0.0273, 0.1082, -0.0163, -0.994, -0.9891, -0.1027, -0.1059)) },
        [167] = { TweenProperty("Workspace.ScrambleBossOutro1VFX.Flight.CFrame", TweenInfo.new(0.06666666666666667, Enum.EasingStyle.Linear), CFrame.new(2521.8628, 512.4241, 1635.2535, -0.1004, 0.9946, -0.0273, 0.1082, -0.0163, -0.994, -0.9891, -0.1027, -0.1059)) },
        [171] = { TweenProperty("Workspace.ScrambleBossOutro1VFX.Flight.CFrame", TweenInfo.new(0.11666666666666667, Enum.EasingStyle.Linear), CFrame.new(2526.8145, 595.5174, 1673.1318, -0.1004, 0.9898, -0.1012, 0.1082, -0.0903, -0.99, -0.9891, -0.1103, -0.098)) },
        [178] = { TweenProperty("Workspace.ScrambleBossOutro1VFX.Flight.CFrame", TweenInfo.new(0.55, Enum.EasingStyle.Linear), CFrame.new(2546.7251, 980.5066, 1857.8026, -0.0898, 0.9898, -0.1107, 0.2065, -0.0903, -0.9743, -0.9743, -0.1103, -0.1963)) },
        [198] = { TweenProperty("Lighting.DepthOfField.InFocusRadius", TweenInfo.new(1.7166666666666666, Enum.EasingStyle.Linear), 300) },
        [211] = { TweenProperty("Workspace.ScrambleBossOutro1VFX.Flight.CFrame", TweenInfo.new(0.3, Enum.EasingStyle.Linear), CFrame.new(2556.2241, 1220.0552, 1979.5344, -0.0898, 0.9898, -0.1107, 0.2065, -0.0903, -0.9743, -0.9743, -0.1103, -0.1963)) },
        [229] = { TweenProperty("Workspace.ScrambleBossOutro1VFX.Flight.CFrame", TweenInfo.new(1.2666666666666666, Enum.EasingStyle.Linear), CFrame.new(2586.7708, 1301.2866, 2038.6105, -0.0898, 0.9898, -0.1107, 0.2065, -0.0903, -0.9743, -0.9743, -0.1103, -0.1963)) },
        [230] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.1, Enum.EasingStyle.Linear), 15) },
        [236] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.11666666666666667, Enum.EasingStyle.Linear), 3) },
        [243] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.43333333333333335, Enum.EasingStyle.Linear), 2.98704) },
        [269] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.2, Enum.EasingStyle.Linear), 15) },
        [281] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.25, Enum.EasingStyle.Linear), 2) },
        [301] = { TweenProperty("Lighting.DepthOfField.InFocusRadius", TweenInfo.new(0.75, Enum.EasingStyle.Linear), 206.78572) },
        [308] = {
            TweenProperty("Workspace.ScrambleBossOutro1Rigs.DrScramble.Back.Transparency", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Linear), 1),
            TweenProperty("Workspace.ScrambleBossOutro1Rigs.DrScramble.Body.Transparency", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Linear), 1),
            TweenProperty("Workspace.ScrambleBossOutro1Rigs.DrScramble.Hair.Transparency", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Linear), 1),
            TweenProperty("Workspace.ScrambleBossOutro1Rigs.DrScramble.HeadLaugh.Transparency", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Linear), 1)
        },
        [309] = {
            function() -- line: 358
                -- upvalues: clone (ref), emitBurst (copy)
                emitBurst(clone.Star)
            end
        },
        [346] = { TweenProperty("Lighting.DepthOfField.InFocusRadius", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Linear), 10) },
        [441] = { TweenProperty("Lighting.DepthOfField.InFocusRadius", TweenInfo.new(0.26666666666666666, Enum.EasingStyle.Linear), 45) },
        [453] = { TweenProperty("Lighting.DepthOfField.NearIntensity", TweenInfo.new(0.5166666666666667, Enum.EasingStyle.Linear), 15) },
        [461] = { TweenProperty("Lighting.DepthOfField.FocusDistance", TweenInfo.new(0.38333333333333336, Enum.EasingStyle.Linear), 15) },
        [484] = { TweenProperty("Lighting.DepthOfField.NearIntensity", TweenInfo.new(0.7333333333333333, Enum.EasingStyle.Linear), 1) },
        [528] = {
            TweenProperty("Lighting.DepthOfField.InFocusRadius", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Linear), 5),
            TweenProperty("PlayerGui.CutsceneUI.Vignette.ImageTransparency", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Linear), 0)
        },
        [529] = {
            TweenProperty("Lighting.DepthOfField.InFocusRadius", TweenInfo.new(11.383333333333333, Enum.EasingStyle.Linear), 10),
            TweenProperty("Lighting.Brock.TintColor", TweenInfo.new(1.9166666666666667, Enum.EasingStyle.Linear), Color3.new(0.658419, 1, 0.537255)),
            TweenProperty("Lighting.Brock.Saturation", TweenInfo.new(1.9166666666666667, Enum.EasingStyle.Linear), 3),
            TweenProperty("Lighting.Brock.Contrast", TweenInfo.new(1.9166666666666667, Enum.EasingStyle.Linear), 2)
        },
        [615] = { TweenProperty("Workspace.ScrambleBossOutro1VFX.Angry.AngryHead.Transparency", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Linear), 1) },
        [670] = { TweenProperty("PlayerGui.CutsceneUI.Vignette.ImageTransparency", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Linear), 1) },
        [671] = { SetProperty("Lighting.Brock.Enabled", false) },
        [805] = {
            TweenProperty("Workspace.ScrambleBossOutro1Rigs.BrockkodileHeadRig.BrockHeads.Angry.LeftEye.Transparency", TweenInfo.new(0.11666666666666667, Enum.EasingStyle.Linear), 1),
            TweenProperty("Workspace.ScrambleBossOutro1Rigs.BrockkodileHeadRig.BrockHeads.Angry.RightEye.Transparency", TweenInfo.new(0.11666666666666667, Enum.EasingStyle.Linear), 1)
        },
        [811] = {
            TweenProperty("PlayerGui.CutsceneUI.Black.BackgroundTransparency", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Linear), 0.8),
            TweenProperty("PlayerGui.CutsceneUI.Vignette.ImageTransparency", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Linear), 0)
        },
        [812] = { TweenProperty("PlayerGui.CutsceneUI.Black.BackgroundColor3", TweenInfo.new(24.883333333333333, Enum.EasingStyle.Linear), Color3.new(0, 0, 0)) },
        [849] = {
            TweenProperty("Workspace.ScrambleBossOutro1Rigs.BrockkodileHeadRig.BrockHeads.Angry.LeftEye.Transparency", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Linear), 0),
            TweenProperty("Workspace.ScrambleBossOutro1Rigs.BrockkodileHeadRig.BrockHeads.Angry.RightEye.Transparency", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Linear), 0),
            TweenProperty("PlayerGui.CutsceneUI.Black.BackgroundTransparency", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Linear), 1),
            TweenProperty("PlayerGui.CutsceneUI.Vignette.ImageTransparency", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Linear), 1)
        },
        [860] = {
            function() -- line: 429
                -- upvalues: clone (ref), setEmitting (copy), emitBurst (copy)
                emitBurst(clone.BatHit2)
                setEmitting(clone.Dizzy, true)
            end
        },
        [895] = {
            TweenProperty("Workspace.ScrambleBossOutro1Rigs.BrockkodileHeadRig.BrockHeads.Angry.LeftEye.Transparency", TweenInfo.new(0.05, Enum.EasingStyle.Linear), 1),
            TweenProperty("Workspace.ScrambleBossOutro1Rigs.BrockkodileHeadRig.BrockHeads.Angry.RightEye.Transparency", TweenInfo.new(0.05, Enum.EasingStyle.Linear), 1)
        },
        [1212] = { TweenProperty("Lighting.DepthOfField.InFocusRadius", TweenInfo.new(0.16666666666666666, Enum.EasingStyle.Linear), 45) },
        [1393] = {
            function() -- line: 445
                -- upvalues: clone (ref), setEmitting (copy)
                setEmitting(clone.Dizzy, false)
            end
        },
        [1658] = { TweenProperty("Lighting.DepthOfField.InFocusRadius", TweenInfo.new(0.016666666666666666, Enum.EasingStyle.Linear), 15) },
        [1869] = { TweenProperty("Lighting.DepthOfField.InFocusRadius", TweenInfo.new(0.16666666666666666, Enum.EasingStyle.Linear), 35) },
        [2242] = {
            function() -- line: 459
                -- upvalues: clone (ref), emitBurst (copy)
                emitBurst(clone.Portal)
            end
        },
        [2303] = { TweenProperty("Lighting.CutsceneBlur.Size", TweenInfo.new(0.21666666666666667, Enum.EasingStyle.Linear), 15) },
        [2305] = {
            TweenProperty("PlayerGui.CutsceneUI.Black.BackgroundTransparency", TweenInfo.new(0.25, Enum.EasingStyle.Linear), 0),
            TweenProperty("PlayerGui.CutsceneUI.Black.BackgroundColor3", TweenInfo.new(0.25, Enum.EasingStyle.Linear), Color3.new(0.515866, 1, 0.372549))
        },
        [2320] = { TweenProperty("PlayerGui.CutsceneUI.Black.BackgroundColor3", TweenInfo.new(0.4666666666666667, Enum.EasingStyle.Linear), Color3.new(0, 0, 0)) }
    }

    return {
        Run = function() -- Run | line: 479
            -- upvalues: p9 (copy), LoadAnimationIntoRig (copy), CutsceneUI (copy), Black (copy), Vignette (copy), clone (ref), t10 (copy), ContentProvider (copy), Lighting (copy), ReplicatedStorage (copy), RunService (copy), SoundService (copy), TweenService (copy), Workspace (copy), LightingController (copy), Tabs (copy), OutroCutscene1 (copy), t2 (copy), CurrentCamera (copy), LocalPlayer (copy), v1 (ref), restoreCamera (copy), restoreAllUi (copy), hideCutsceneUi (copy), hideAllGuardsAndNests (copy), restoreAllGuardsAndNests (copy)
            local v18 = false
            local _warn = warn

            xpcall(hideCutsceneUi, _warn)
            p9:Add(function() -- line: 484
                -- upvalues: v18 (ref), Tabs (copy), v1 (ref), restoreAllUi (copy)
                if v18 then
                    return
                end

                local v19 = restoreAllUi()
                local v20 = v1

                v1 = nil

                if v20 ~= nil then
                    v20()
                end

                if v19 ~= nil then
                    Tabs.Activate(v19, {
                        instant = true
                    })
                end

                v18 = true
            end)

            local AreaEggSlotsClient = Workspace:FindFirstChild("AreaEggSlotsClient")

            local function v21() -- line: 492
                -- upvalues: AreaEggSlotsClient (copy), p9 (copy), ReplicatedStorage (copy), Workspace (copy)
                AreaEggSlotsClient.Parent = ReplicatedStorage
                p9:Add(function() -- line: 494
                    -- upvalues: AreaEggSlotsClient (copy), Workspace (copy)
                    AreaEggSlotsClient.Parent = Workspace
                end)
            end

            pcall(v21)
            hideAllGuardsAndNests(p9)
            LightingController.Settle()

            local t12 = {}
            local v22 = false

            for _, v23 in t2 do
                local v24 = Lighting:FindFirstChildOfClass(v23)

                if v24 ~= nil then
                    v24.Parent = nil
                    table.insert(t12, v24)
                    p9:Add(function() -- line: 513
                        -- upvalues: v24 (copy), Lighting (copy)
                        v24.Parent = Lighting
                    end)
                end
            end

            p9:Add(function() -- line: 517
                -- upvalues: v22 (ref), LightingController (copy)
                if not v22 then
                    v22 = true
                    LightingController.Settle()
                end
            end)

            local t13 = {}

            for _, child in OutroCutscene1.LightingAssets:GetChildren() do
                if not Lighting:FindFirstChild(child.Name) then
                    local clone = child:Clone()

                    clone.Parent = Lighting
                    p9:Add(clone)
                    table.insert(t13, clone)
                end
            end

            CutsceneUI.Enabled = true
            Black.BackgroundTransparency = 1
            Black.Visible = true
            Vignette.Visible = false
            p9:Add(function() -- line: 541
                -- upvalues: Vignette (copy)
                Vignette.Visible = false
                Vignette.ImageTransparency = 1
            end)

            local clone2 = OutroCutscene1.ScrambleBossOutro1VFX:Clone()

            clone2.Parent = Workspace
            clone = clone2
            p9:Add(clone2)

            local clone3 = OutroCutscene1.ScrambleBossOutro1WorkspaceAssets:Clone()

            clone3.Parent = Workspace
            p9:Add(clone3)

            local clone4 = OutroCutscene1.CutsceneMusic:Clone()

            clone4.Parent = SoundService
            p9:Add(clone4)
            TweenService:Create(Black, TweenInfo.new(0.1), {
                BackgroundTransparency = 0
            }):Play()
            p9:Add(function() -- line: 560
                -- upvalues: Black (copy)
                Black.BackgroundTransparency = 1
                Black.BackgroundColor3 = Color3.new(0, 0, 0)
                Black.Visible = false
            end)

            local clone5 = OutroCutscene1.ScrambleBossOutro1Rigs:Clone()

            for _, child in clone5:GetChildren() do
                if child:IsA("Model") and child.PrimaryPart then
                    child.PrimaryPart.Anchored = true
                end
            end

            clone5.Parent = Workspace
            p9:Add(clone5)

            local t14 = {}

            for _, child in clone5:GetChildren() do
                local Animation = child:FindFirstChildOfClass("Animation")

                if Animation then
                    table.insert(t14, Animation)
                end
            end

            ContentProvider:PreloadAsync(t14)

            local t15 = {}

            for _, child in clone5:GetChildren() do
                local Animation = child:FindFirstChildOfClass("Animation")

                if Animation then
                    t15[child] = LoadAnimationIntoRig(child, Animation.AnimationId)
                end
            end

            local v25 = true

            p9:Add(function() -- line: 596
                -- upvalues: v25 (ref)
                v25 = false
            end)
            p9:Add(function() -- line: 597
                -- upvalues: v25 (ref), restoreCamera (copy)
                if v25 then
                    restoreCamera()
                end
            end)

            for _, v26 in t15 do
                v26:Play(0)
            end

            local v27 = t15[clone5.HumanoidCameraRig]

            assert(v27, "HumanoidCameraRig needs an Animation")

            local v28 = os.clock() + 2

            while v25 and v27.TimePosition <= 0 and os.clock() < v28 do
                RunService.RenderStepped:Wait()
            end

            clone4:Play()

            local Torso = clone5.HumanoidCameraRig.Torso
            local connection

            connection = RunService.RenderStepped:Connect(function() -- line: 623
                -- upvalues: v25 (ref), Torso (copy), connection (ref), CurrentCamera (copy), LocalPlayer (copy)
                if not v25 then
                    connection:Disconnect()

                    return
                end

                CurrentCamera.CameraType = Enum.CameraType.Scriptable
                LocalPlayer.ReplicationFocus = Torso
                CurrentCamera.Focus = Torso.CFrame
                CurrentCamera.CFrame = Torso.CFrame
            end)

            local t16 = {}
            local n1 = 0
            local n2 = 0.1
            local connection2 = RunService.Heartbeat:Connect(function(p10) -- line: 637
                -- upvalues: clone4 (copy), t15 (copy), t16 (copy), n1 (ref), n2 (ref), t10 (copy)
                n1 += p10
                n2 -= 0.1

                if n2 <= 0 then
                    n2 = 0.1

                    for _, v29 in t15 do
                        if v29.IsPlaying then
                            local v31 = n1

                            if math.abs(v31 - v29.TimePosition) >= 0.4 then
                                local function v32() -- line: 649
                                    -- upvalues: v29 (copy), n1 (ref)
                                    v29.TimePosition = n1
                                end

                                local _warn = warn

                                xpcall(v32, _warn)
                            end
                        end
                    end
                end

                if clone4.TimePosition < n1 - 0.001 then
                    clone4.PlaybackSpeed = 1.01
                elseif clone4.TimePosition > n1 + 0.001 then
                    clone4.PlaybackSpeed = 0.99
                else
                    clone4.PlaybackSpeed = 1
                end

                for i = 0, 9 do
                    local v34 = math.floor(n1 * 60 - i)

                    if t10[v34] and not t16[v34] then
                        t16[v34] = true

                        for _, v35 in t10[v34] do
                            task.spawn(v35)
                        end
                    end
                end
            end)

            p9:Add(connection2)
            TweenService:Create(Black, TweenInfo.new(0.5), {
                BackgroundTransparency = 1
            }):Play()
            task.wait(39.85)
            connection2:Disconnect()

            local function v36() -- line: 681
                -- upvalues: clone2 (copy)
                clone2:Destroy()
            end

            local _warn2 = warn

            xpcall(v36, _warn2)

            local function v37() -- line: 682
                -- upvalues: clone3 (copy)
                clone3:Destroy()
            end

            local _warn3 = warn

            xpcall(v37, _warn3)

            local function v38() -- line: 683
                -- upvalues: clone4 (copy)
                clone4:Destroy()
            end

            local _warn4 = warn

            xpcall(v38, _warn4)
            v25 = false
            Vignette.Visible = false

            local function v39() -- line: 689
                -- upvalues: t12 (copy), v22 (ref), t13 (copy), Lighting (copy), LightingController (copy)
                for _, v40 in t13 do
                    v40:Destroy()
                end

                for _, v41 in t12 do
                    v41.Parent = Lighting
                end

                v22 = true
                LightingController.Settle()
            end

            local _warn5 = warn

            xpcall(v39, _warn5)

            local function v42() -- line: 700
                -- upvalues: clone5 (copy)
                clone5:Destroy()
            end

            local _warn6 = warn

            xpcall(v42, _warn6)

            local _warn7 = warn

            xpcall(restoreCamera, _warn7)
            task.wait(0.5)
            Vignette.Visible = false

            local function v43() -- line: 709
                -- upvalues: AreaEggSlotsClient (copy), Workspace (copy)
                AreaEggSlotsClient.Parent = Workspace
            end

            pcall(v43)

            local function v44() -- line: 713
                -- upvalues: v18 (ref), Tabs (copy), v1 (ref), restoreAllUi (copy)
                local v45 = restoreAllUi()
                local v46 = v1

                v1 = nil

                if v46 ~= nil then
                    v46()
                end

                if v45 ~= nil then
                    Tabs.Activate(v45, {
                        instant = true
                    })
                end

                v18 = true
            end

            local _warn8 = warn

            xpcall(v44, _warn8)
            restoreAllGuardsAndNests()
        end
    }
end
