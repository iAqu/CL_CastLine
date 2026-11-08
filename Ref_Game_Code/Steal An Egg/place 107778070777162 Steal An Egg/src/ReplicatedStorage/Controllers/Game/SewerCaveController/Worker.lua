-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Log = require(ReplicatedStorage.Packages.Log)
local Player = require(ReplicatedStorage.Shared.Player)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local Rig = require(script.Parent.Parent.GhostDogQuestController.Rig)
local Save = require(ReplicatedStorage.Shared.Save)
local SewerCave = require(ReplicatedStorage.Shared.Util.SewerCave)
local Speech = require(script.Parent.Parent.GhostDogQuestController.Speech)

require(ReplicatedStorage.Packages.Trove)

local LocalPlayer = Players.LocalPlayer
local Worker, Markers = SewerCave.Worker, SewerCave.Markers
local t1 = {
    "Assets",
    "SewerCave",
    "ManorWorker"
}
local t2 = {
    "Assets",
    "ShootingStar",
    "Sounds",
    "BuddyChatter2"
}
local Warning = Log.new():LimitUnderLevel("Warning")
local t3 = {}

local function clip(p1, p2, p3) -- line: 48
    return {
        Animation = p1,
        Speed = p2,
        Looped = p3
    }
end

local v1 = table.freeze({
    Clips = {
        Idle = {
            Animation = "Idle",
            Speed = 1,
            Looped = true
        },
        Talk = {
            Animation = "Idle",
            Speed = 1,
            Looped = true
        }
    },
    Body = function() -- Body | line: 57
        return CFrame.identity
    end
})

local function findChild(p4, p5) -- line: 62
    for _, v3 in p5 do
        p4 = if p4 then p4:FindFirstChild(v3) else nil
    end

    return p4
end

local function template() -- line: 70
    -- upvalues: ReplicatedStorage (copy), t1 (copy)
    local v4 = ReplicatedStorage

    for _, v5 in t1 do
        v4 = if v4 then v4:FindFirstChild(v5) else nil
    end

    return if v4 ~= nil and v4:IsA("Model") then v4 else nil
end

local function voice() -- line: 75
    -- upvalues: ReplicatedStorage (copy), t2 (copy)
    local v6 = ReplicatedStorage

    for _, v7 in t2 do
        v6 = if v6 then v6:FindFirstChild(v7) else nil
    end

    if v6 == nil or not v6:IsA("Sound") then
        return {}
    end

    return { v6 }
end

local function planted(p6, p7) -- line: 80
    -- upvalues: Workspace (copy)
    local v8 = RaycastParams.new()

    v8.FilterType = Enum.RaycastFilterType.Exclude
    v8.FilterDescendantsInstances = { p6, p7 }
    v8.RespectCanCollide = true

    local _CFrame = p7.CFrame
    local v9 = Workspace:Raycast(_CFrame.Position + Vector3.new(0, 6, 0), Vector3.new(0, -36, 0), v8)
    local v10 = Vector3.new(_CFrame.LookVector.X, 0, _CFrame.LookVector.Z)
    local v11 = if v10.Magnitude > 0.01 then v10.Unit else Vector3.new(0, 0, 1)
    local v12 = if v9 then v9.Position.Y else _CFrame.Position.Y - p7.Size.Y / 2
    local v13 = Vector3.new(_CFrame.Position.X, v12, _CFrame.Position.Z)

    return CFrame.lookAt(v13, v13 + v11)
end

local function headOf(p8) -- line: 98
    local Head = p8:FindFirstChild("Head")

    if not (Head and Head:IsA("BasePart")) then
        return p8.PrimaryPart
    end

    return Head
end

local function hasKey() -- line: 106
    -- upvalues: Save (copy)
    local v14 = Save.Peek()

    if v14 == nil then
        return false
    end

    local HalloweenDimension = v14.HalloweenDimension
    local v15 = HalloweenDimension and HalloweenDimension.Manor
    local GearInventory = v14.GearInventory
    local v16, v17

    if v15 ~= nil then
        if v15.KeyClaimed == true or v15.GateUnlocked == true then
            v16 = true
            v17 = true
        else
            v17 = false
        end
    else
        v17 = false
    end

    if not v17 then
        v16 = GearInventory ~= nil and (GearInventory["Manor Key"] or 0) > 0
    end

    return v16
end

local function turn(p9, p10) -- line: 118
    local Root = p9.Root
    local elapsed = os.clock()

    while os.clock() - elapsed < 0.35 do
        p9:SetRoot(Root:Lerp(p10, 1 - (1 - (os.clock() - elapsed) / 0.35) ^ 2))
        task.wait()
    end

    p9:SetRoot(p10)
end

local function facePlayer(p11) -- line: 129
    -- upvalues: Player (copy), LocalPlayer (copy), turn (copy)
    local v18 = Player.FindRootPart(LocalPlayer)

    if v18 == nil then
        return
    end

    local RootPosition = p11.Root.Position
    local v19 = Vector3.new(v18.Position.X, RootPosition.Y, v18.Position.Z)

    if not ((v19 - RootPosition).Magnitude < 0.5) then
        turn(p11, CFrame.lookAt(RootPosition, v19))
    end
end

function t3.Start(p12) -- line: 146
    -- upvalues: ReplicatedStorage (copy), RunService (copy), Workspace (copy), Remotes (copy), Rig (copy), Save (copy), SewerCave (copy), Speech (copy), Worker (copy), Markers (copy), t1 (copy), Warning (copy), v1 (copy), voice (copy), planted (copy), turn (copy), facePlayer (copy)
    local v20 = SewerCave.Marker(Markers.Npc)
    local v21 = ReplicatedStorage

    for _, v22 in t1 do
        v21 = if v21 then v21:FindFirstChild(v22) else nil
    end

    if v21 == nil or not v21:IsA("Model") then
        v21 = nil
    end

    if v20 == nil or v21 == nil then
        Warning:AtWarning():Log("[SewerCave] manor worker template or Npc marker is missing")
    else
        local v23 = p12:Extend()
        local clone = v23:Clone(v21)

        if clone.PrimaryPart ~= nil then
            local v24 = planted(clone, v20)

            clone:PivotTo(v24)
            clone.Parent = Workspace

            local v25 = Rig.new(clone, v1)

            v23:Add(function() -- line: 164
                -- upvalues: v25 (copy)
                v25:Destroy()
            end)
            v25:SetRoot(v24)

            local Head = clone:FindFirstChild("Head")

            if not (Head and Head:IsA("BasePart")) then
                Head = clone.PrimaryPart
            end

            local v26 = clone:FindFirstChild("TalkPrompt", true)
            local v27 = clone:FindFirstChild("QuestMarker", true)
            local v28 = clone:FindFirstChildWhichIsA("PointLight", true)
            local v29 = if v28 then v28.Brightness else 0
            local v30 = voice()
            local v31 = true
            local v32 = false

            v23:Add(function() -- line: 177
                -- upvalues: v31 (ref), v32 (ref), Speech (copy)
                v31 = false

                if v32 then
                    Speech.Stop()
                end
            end)

            local function talk() -- line: 184
                -- upvalues: clone (copy), v24 (copy), v25 (copy), Head (ref), v27 (copy), v30 (copy), v31 (ref), v32 (ref), Remotes (copy), Save (copy), Speech (copy), Worker (copy), turn (copy), facePlayer (copy)
                local v33 = true

                if v32 then
                elseif v31 then
                    v32 = true
                    Remotes.SewerCave.MetWorker:FireServer()

                    if v27 and v27:IsA("BillboardGui") then
                        v27.Enabled = false
                    end

                    v33 = false
                end

                if v33 then
                    return
                end

                local v34 = Save.Peek()
                local v35

                if v34 ~= nil then
                    local HalloweenDimension = v34.HalloweenDimension
                    local v36 = HalloweenDimension and HalloweenDimension.Manor
                    local GearInventory = v34.GearInventory
                    local v37 = false

                    if v36 ~= nil then
                        if v36.KeyClaimed == true or v36.GateUnlocked == true then
                            v35 = true
                            v37 = true
                        end
                    end

                    if not v37 then
                        v35 = GearInventory ~= nil and (GearInventory["Manor Key"] or 0) > 0
                    end
                else
                    v35 = false
                end

                local v38 = if v35 then Worker.KeyLines else Worker.Lines

                v25:SetMood("Talk")
                facePlayer(v25)
                Speech.Say(clone, Head, v38, {
                    WalkAway = 40,
                    Voice = v30
                })

                if not v31 then
                    return
                end

                v25:SetMood("Idle")
                turn(v25, v24)
                v32 = false
            end

            if v26 and v26:IsA("ProximityPrompt") then
                v26.ActionText = "Talk"
                v26.ObjectText = Worker.Name
                v26.Style = Enum.ProximityPromptStyle.Custom
                v26.HoldDuration = 0
                v26.RequiresLineOfSight = false
                v26.MaxActivationDistance = 12
                v26.Enabled = true
                v23:Connect(v26.Triggered, function() -- line: 217
                    -- upvalues: talk (copy)
                    task.spawn(talk)
                end)
            end

            if v27 and v27:IsA("BillboardGui") then
                local v39 = Save.Peek()
                local v40 = false

                if v39 ~= nil then
                    local HalloweenDimension = v39.HalloweenDimension
                    local v41 = HalloweenDimension and HalloweenDimension.Manor
                    local GearInventory = v39.GearInventory

                    v40 = if v41 ~= nil then v41.KeyClaimed == true or v41.GateUnlocked == true or GearInventory ~= nil and (GearInventory["Manor Key"] or 0) > 0 else GearInventory ~= nil and (GearInventory["Manor Key"] or 0) > 0
                end

                v27.Enabled = not v40
            end

            v23:Connect(RunService.RenderStepped, function(p13) -- line: 225
                -- upvalues: v25 (copy), v26 (copy), v27 (copy), v28 (copy), v32 (ref), v29 (copy)
                v25:Step(p13)

                if v26 and v26:IsA("ProximityPrompt") then
                    v26.Enabled = not v32
                end

                if v28 then
                    v28.Brightness = v29 * (1 + math.noise(os.clock() * 6, 0.5) * 0.18)
                end

                if not (v27 and v27:IsA("BillboardGui") and v27.Enabled) then
                    return
                end

                v27.StudsOffset = Vector3.new(0, math.sin(os.clock() * 4) * 0.3 + 3.4, 0)
            end)
        else
            Warning:AtWarning():Log("[SewerCave] manor worker template has no PrimaryPart")
            v23:Destroy()
        end
    end
end

return table.freeze(t3)
