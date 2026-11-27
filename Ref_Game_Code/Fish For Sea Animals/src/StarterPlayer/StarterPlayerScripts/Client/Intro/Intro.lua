-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ContentProvider = game:GetService("ContentProvider")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local Config = require(ReplicatedStorage.Shared.Config)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local Controls = require(script.Parent.Parent.Character.Controls)
local Cutscene = require(script.Parent.Cutscene)
local AnimeFX = require(script.Parent.AnimeFX)
local LocalPlayer = Players.LocalPlayer
local t1 = {}
local v1 = false
local v2 = false
local t2 = {
    IntroFX = true,
    Loading = true
}

local function waitForAttribute(p1, p2) -- line: 27
    -- upvalues: LocalPlayer (copy)
    local v3 = os.clock() + p2

    while LocalPlayer:GetAttribute(p1) == nil and os.clock() < v3 do
        task.wait(0.05)
    end

    return LocalPlayer:GetAttribute(p1)
end

local function hideUi() -- line: 36
    -- upvalues: StarterGui (copy), LocalPlayer (copy), t2 (copy)
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
    local t3 = {}

    for _, child in PlayerGui:GetChildren() do
        if child:IsA("ScreenGui") and child.Enabled and not t2[child.Name] then
            child.Enabled = false
            table.insert(t3, child)
        end
    end

    local connection = PlayerGui.ChildAdded:Connect(function(p3) -- line: 46
        -- upvalues: t3 (copy), t2 (copy)
        if p3:IsA("ScreenGui") and p3.Enabled and not t2[p3.Name] then
            p3.Enabled = false
            table.insert(t3, p3)
        end
    end)
    local t4 = {}

    for _, v4 in {
            Enum.CoreGuiType.PlayerList,
            Enum.CoreGuiType.Chat,
            Enum.CoreGuiType.EmotesMenu,
            Enum.CoreGuiType.Health
        } do
        local GetCoreGuiEnabled = StarterGui.GetCoreGuiEnabled
        local ok, result = pcall(GetCoreGuiEnabled, StarterGui, v4)

        if ok and result then
            local SetCoreGuiEnabled = StarterGui.SetCoreGuiEnabled

            pcall(SetCoreGuiEnabled, StarterGui, v4, false)
            table.insert(t4, v4)
        end
    end

    return function() -- line: 60
        -- upvalues: t3 (copy), connection (copy), t4 (copy), StarterGui (copy)
        connection:Disconnect()

        for _, v5 in t3 do
            v5.Enabled = true
        end

        for _, v6 in t4 do
            local SetCoreGuiEnabled = StarterGui.SetCoreGuiEnabled

            pcall(SetCoreGuiEnabled, StarterGui, v6, true)
        end
    end
end

local function hideCharacter() -- line: 72
    -- upvalues: RunService (copy), LocalPlayer (copy)
    local connection = RunService.RenderStepped:Connect(function() -- line: 73
        -- upvalues: LocalPlayer (copy)
        local Character = LocalPlayer.Character

        if Character then
            for _, descendant in Character:GetDescendants() do
                if descendant:IsA("BasePart") or descendant:IsA("Decal") then
                    descendant.LocalTransparencyModifier = 1
                end
            end
        end
    end)

    return function() -- line: 83
        -- upvalues: connection (copy), LocalPlayer (copy)
        connection:Disconnect()

        local Character = LocalPlayer.Character

        if Character then
            for _, descendant in Character:GetDescendants() do
                if descendant:IsA("BasePart") or descendant:IsA("Decal") then
                    descendant.LocalTransparencyModifier = 0
                end
            end
        end
    end
end

local function play(p4) -- line: 97
    -- upvalues: ContentProvider (copy), RunService (copy), Remotes (copy), Controls (copy), Cutscene (copy), AnimeFX (copy), LocalPlayer (copy), v1 (ref), hideUi (copy)
    v1 = true

    local v7 = hideUi()
    local connection = RunService.RenderStepped:Connect(function() -- line: 73
        -- upvalues: LocalPlayer (copy)
        local Character = LocalPlayer.Character

        if Character then
            for _, descendant in Character:GetDescendants() do
                if descendant:IsA("BasePart") or descendant:IsA("Decal") then
                    descendant.LocalTransparencyModifier = 1
                end
            end
        end
    end)

    local function v8() -- line: 83
        -- upvalues: connection (copy), LocalPlayer (copy)
        connection:Disconnect()

        local Character = LocalPlayer.Character

        if Character then
            for _, descendant in Character:GetDescendants() do
                if descendant:IsA("BasePart") or descendant:IsA("Decal") then
                    descendant.LocalTransparencyModifier = 0
                end
            end
        end
    end

    Controls.lock("Intro")
    Cutscene.setup()

    if not p4 then
        Remotes.Tutorial:FireServer("CutsceneStarted")
        LocalPlayer:SetAttribute("IntroReady", true)
        task.spawn(function() -- line: 107
            -- upvalues: ContentProvider (copy), LocalPlayer (copy)
            local PreloadAsync = ContentProvider.PreloadAsync
            local t5 = { LocalPlayer:WaitForChild("PlayerGui") }

            pcall(PreloadAsync, ContentProvider, t5)
        end)
    end

    local v9 = AnimeFX.skipButton(Cutscene.skip)
    local play = Cutscene.play
    local ok, result = pcall(play)

    v9:Destroy()

    if not ok then
        warn("Intro cutscene error: " .. tostring(result))
    end

    if not p4 then
        Remotes.Tutorial:FireServer("Cutscene")
    end

    local CurrentCamera = workspace.CurrentCamera
    local v10 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    local v11 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

    CurrentCamera.CameraType = Enum.CameraType.Custom
    CurrentCamera.FieldOfView = 70

    if v11 then
        CurrentCamera.CFrame = CFrame.lookAt((v11.CFrame * CFrame.new(0, 4, 12)).Position, v11.Position + Vector3.new(0, 1.5, 0))
    end

    if v10 then
        CurrentCamera.CameraSubject = v10
    end

    v8()
    Controls.unlock("Intro")
    v7()
    v1 = false
    AnimeFX.cover(false, 0.8)
    Cutscene.cleanup()
end

local function run() -- line: 141
    -- upvalues: Config (copy), Remotes (copy), LocalPlayer (copy), v2 (ref), waitForAttribute (copy), play (copy)
    if not waitForAttribute("Loaded", 120) and not game:IsLoaded() then
        game.Loaded:Wait()
    end

    Remotes.Tutorial:FireServer("Loaded")

    local v12 = waitForAttribute("Tutorial", 30)

    if not (v12 ~= nil and v12 < Config.TutorialDone and LocalPlayer:GetAttribute("CutsceneSeen") == false and LocalPlayer.Character) then
        LocalPlayer:SetAttribute("IntroReady", true)
    else
        play()
    end

    v2 = true
end

function t1.isPlaying() -- line: 156
    -- upvalues: v1 (ref)
    return v1
end

function t1.isDone() -- line: 161
    -- upvalues: v2 (ref)
    return v2
end

function t1.replay() -- line: 167
    -- upvalues: LocalPlayer (copy), v1 (ref), v2 (ref), play (copy)
    if not v1 and v2 and LocalPlayer.Character then
        play(true)
    end
end

function t1.init() -- line: 174
    -- upvalues: run (copy)
    task.spawn(run)
end

return t1
