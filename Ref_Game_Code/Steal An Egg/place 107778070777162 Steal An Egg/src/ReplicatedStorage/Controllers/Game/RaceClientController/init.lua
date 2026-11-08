-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local Workspace = game:GetService("Workspace")
local BoostPad = require(script.Components.BoostPad)
local HeatVisibility = require(script.HeatVisibility)
local HiddenUIHandler = require(ReplicatedStorage.Client.HiddenUIHandler)
local Jump = require(script.Components.Jump)
local LoopTheLoop = require(script.Components.LoopTheLoop)
local MountAnimator = require(script.MountAnimator)
local MountController = require(script.MountController)
local MountRace = require(ReplicatedStorage.Data.MountRace)
local PowerUpController = require(script.PowerUpController)
local PowerUpSpawn = require(script.Components.PowerUpSpawn)
local RaceBoard = require(script.RaceBoard)
local RaceCamera = require(script.RaceCamera)
local RaceHud = require(script.RaceHud)
local RaceMusic = require(script.RaceMusic)
local RaceTrackPath = require(ReplicatedStorage.Shared.Modules.RaceTrackPath)
local Respawner = require(script.Respawner)
local Scenery = require(script.Scenery)
local SlowPad = require(script.Components.SlowPad)
local Trove = require(ReplicatedStorage.Packages.Trove)
local WrongWay = require(script.WrongWay)
local LocalPlayer = Players.LocalPlayer
local PlayerAttributes = MountRace.PlayerAttributes
local t1 = {
    [MountRace.ComponentTags.BoostPad] = BoostPad,
    [MountRace.ComponentTags.SlowPad] = SlowPad,
    [MountRace.ComponentTags.Jump] = Jump,
    [MountRace.ComponentTags.LoopTheLoop] = LoopTheLoop,
    [MountRace.ComponentTags.PowerUpSpawn] = PowerUpSpawn
}
local v1

local function findTrack(p1) -- line: 66
    -- upvalues: CollectionService (copy), MountRace (copy)
    for _, v2 in CollectionService:GetTagged(MountRace.TrackTag) do
        if v2.Name == p1 then
            return v2
        end
    end

    error((("No race track named %*"):format(p1)))
end

local function waitForGo(p2) -- line: 75
    -- upvalues: Workspace (copy), MountRace (copy)
    while true and type(p2:GetAttribute(MountRace.TrackAttributes.GoAt)) ~= "number" do
        p2:GetAttributeChangedSignal(MountRace.TrackAttributes.GoAt):Wait()
    end

    local Attribute = p2:GetAttribute(MountRace.TrackAttributes.GoAt)

    while Workspace:GetServerTimeNow() < Attribute do
        task.wait()
    end
end

local function bindComponents(p3, p4, p5, p6) -- line: 85
    -- upvalues: CollectionService (copy), t1 (copy)
    for v3, v4 in t1 do
        local t2 = {}

        local function bind(p7) -- line: 93
            -- upvalues: p3 (copy), p4 (copy), p5 (copy), p6 (copy), t2 (copy), v3 (copy), v4 (copy)
            if not t2[p7] and p7:IsDescendantOf(p4) then
                assert(p7:IsA("Model"), (("%* is tagged %* but is not a Model"):format(p7:GetFullName(), v3)))
                t2[p7] = true
                v4.Bind(p3, p7, p5, p6)
            end
        end

        for _, v6 in CollectionService:GetTagged(v3) do
            bind(v6)
        end

        p3:Connect(CollectionService:GetInstanceAddedSignal(v3), bind)
    end
end

local function runSession(p8, p9, p10) -- line: 108
    -- upvalues: CollectionService (copy), SoundService (copy), HeatVisibility (copy), HiddenUIHandler (copy), MountController (copy), MountRace (copy), PowerUpController (copy), RaceBoard (copy), RaceCamera (copy), RaceHud (copy), RaceMusic (copy), RaceTrackPath (copy), Respawner (copy), WrongWay (copy), LocalPlayer (copy), PlayerAttributes (copy), waitForGo (copy), bindComponents (copy)
    while LocalPlayer:GetAttribute(MountRace.CutsceneAttribute) == true do
        LocalPlayer:GetAttributeChangedSignal(MountRace.CutsceneAttribute):Wait()
    end

    local v7 = false
    local v8

    for _, v9 in CollectionService:GetTagged(MountRace.TrackTag) do
        if v9.Name == p9 then
            v8 = v9
            v7 = true
            break
        end
    end

    if not v7 then
        v8 = nil
        error((("No race track named %*"):format(p9)))
    end

    local v10 = MountRace.HeatOf(LocalPlayer)

    if v10 ~= nil then
        HeatVisibility.Run(p8, p9, v10)
    end

    local v11 = MountRace.StateOf(v8, v10)

    assert(v11 ~= nil, (("%* has no state for heat %*"):format(v8:GetFullName(), v10)))

    local Humanoid = p10:WaitForChild("Humanoid")
    local HumanoidRootPart = p10:WaitForChild("HumanoidRootPart")
    local v14 = p10:WaitForChild(MountRace.MountName, 10)

    assert(v14 ~= nil, (("%* has RaceId but no %*"):format(p10:GetFullName(), MountRace.MountName)))

    local t3 = {
        Character = p10,
        Humanoid = Humanoid,
        Root = HumanoidRootPart,
        Mount = v14
    }
    local v17 = RaceTrackPath.new(v8.AttachmentTrack)

    p8:Add(HiddenUIHandler.Acquire())

    local v18 = MountController.new(p8, t3, v8)
    local Attribute = LocalPlayer:GetAttribute(PlayerAttributes.GridFrame)

    assert(typeof(Attribute) == "CFrame", (("%* has RaceId but no %*"):format(LocalPlayer.Name, PlayerAttributes.GridFrame)))

    local v21 = p8:Add(task.spawn(function() -- line: 132
        -- upvalues: HumanoidRootPart (copy), v18 (copy), Attribute (copy)
        v18:Place(Attribute)

        while true do
            task.wait(1)

            local CFrame = HumanoidRootPart.CFrame

            if Vector3.new(CFrame.X - Attribute.X, 0, CFrame.Z - Attribute.Z).Magnitude > 3 or CFrame.LookVector:Dot(Attribute.LookVector) < 0.94 then
                v18:Place(Attribute)
            end
        end
    end))

    v18:SetHold("Grid", true)

    local v24 = RaceCamera.Run(p8, v18, t3)
    local v25 = RaceMusic.Run(p8, v8)

    Respawner.Run(p8, v18, t3, v8, v17)
    RaceHud.Run(p8, v8, v11, v18, v24, v25)
    RaceBoard.Run(p8, v8, v11, p9)
    bindComponents(p8, v8, v18, v24)
    PowerUpController.Run(p8, v8, v18, v24, v17)
    WrongWay.Run(p8, v18, t3, v17)
    p8:Connect(v18.WallHit, function(p11) -- line: 154
        -- upvalues: v24 (copy), SoundService (copy), MountRace (copy)
        v24:Shake(p11 * 0.04)
        SoundService:PlayLocalSound(MountRace.Sounds.WallHit)
    end)
    waitForGo(v11)
    p8:Remove(v21)
    v18:SetHold("Grid", false)
end

local function showCompletedOffTrack() -- line: 165
    -- upvalues: RaceHud (copy), LocalPlayer (copy), PlayerAttributes (copy)
    local Attribute = LocalPlayer:GetAttribute(PlayerAttributes.FinishPlace)

    if type(Attribute) == "number" and LocalPlayer:GetAttribute(PlayerAttributes.RaceId) == nil then
        RaceHud.ShowCompleted(Attribute)
    end
end

local function refreshSession() -- line: 172
    -- upvalues: RaceHud (copy), Trove (copy), LocalPlayer (copy), PlayerAttributes (copy), v1 (ref), runSession (copy)
    local v26 = v1

    if v26 ~= nil then
        v1 = nil
        v26:Destroy()
    end

    local Attribute = LocalPlayer:GetAttribute(PlayerAttributes.RaceId)
    local Character = LocalPlayer.Character

    if type(Attribute) == "string" and Character ~= nil then
        local v27 = Trove.new()

        v27:Add(task.spawn(runSession, v27, Attribute, Character))
        v1 = v27
    else
        local Attribute = LocalPlayer:GetAttribute(PlayerAttributes.FinishPlace)

        if type(Attribute) == "number" and LocalPlayer:GetAttribute(PlayerAttributes.RaceId) == nil then
            RaceHud.ShowCompleted(Attribute)
        end
    end
end

return {
    Start = function() -- Start | line: 193
        -- upvalues: MountAnimator (copy), Scenery (copy), LocalPlayer (copy), PlayerAttributes (copy), showCompletedOffTrack (copy), refreshSession (copy)
        MountAnimator.Start()
        Scenery.Start()
        LocalPlayer:GetAttributeChangedSignal(PlayerAttributes.RaceId):Connect(refreshSession)
        LocalPlayer:GetAttributeChangedSignal(PlayerAttributes.FinishPlace):Connect(showCompletedOffTrack)
        LocalPlayer.CharacterAdded:Connect(refreshSession)
        refreshSession()
    end
}
