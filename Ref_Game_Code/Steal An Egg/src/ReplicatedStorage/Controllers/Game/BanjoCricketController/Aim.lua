-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local BanjoCricketFlags = require(ReplicatedStorage.Shared.Flags.BanjoCricketFlags)
local Gears = require(ReplicatedStorage.Data.Gears)
local Mushrooms = require(script.Parent.Mushrooms)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local ToolGameplayGuard = require(ReplicatedStorage.Client.ToolGameplayGuard)
local Trove = require(ReplicatedStorage.Packages.Trove)
local LocalPlayer = Players.LocalPlayer
local v1, v2
local n1 = 0
local t1 = {}

local function distanceToBox(p1, p2) -- line: 41
    local v3 = p1.CFrame:PointToObjectSpace(p2)
    local v4 = p1.Size / 2

    return (v3 - v3:Max(-v4):Min(v4)).Magnitude
end

local function canHit(p3) -- line: 47
    -- upvalues: Gears (copy)
    if p3:GetAttribute("IsBat") == true then
        return true
    end

    local GearName = p3:GetAttribute("GearName")
    local v5 = if typeof(GearName) == "string" then Gears.Directory[GearName] else nil

    return v5 ~= nil and v5.ToolController == "Slap"
end

local function pick(p4) -- line: 58
    -- upvalues: Mushrooms (copy), v1 (ref)
    local v6 = p4.CFrame.LookVector * Vector3.new(1, 0, 1)

    if v6.Magnitude < 0.001 then
        return nil
    end

    local Unit = v6.Unit
    local n2 = 1e999
    local Index

    for _, v7 in Mushrooms.Targets() do
        local Anchor = v7.Anchor
        local Position = p4.Position
        local v8 = Anchor.CFrame:PointToObjectSpace(Position)
        local v9 = Anchor.Size / 2
        local Magnitude = (v8 - v8:Max(-v9):Min(v9)).Magnitude

        if not (Magnitude > 13) then
            local v10 = (v7.Anchor.Position - p4.Position) * Vector3.new(1, 0, 1)
            local v11 = if v10.Magnitude > 0.001 then Unit:Dot(v10.Unit) else 1

            if not (v11 < 0.1 and Magnitude > 4) then
                local Index2 = v7.Index
                local v12 = v1
                local v13 = if Index2 == v12 then 1 else 0
                local v14 = Magnitude - v11 * 3 - v13

                if v14 < n2 then
                    n2 = v14
                    Index = v7.Index
                end
            end
        end
    end

    return Index
end

local function nominate(p5) -- line: 89
    -- upvalues: Mushrooms (copy), Remotes (copy), v1 (ref)
    if p5 == v1 then
        return
    end

    v1 = p5
    Mushrooms.ShowAim(p5)
    Remotes.BanjoCricket.Aim:FireServer(p5 or 0)
end

local function update() -- line: 98
    -- upvalues: BanjoCricketFlags (copy), Mushrooms (copy), Remotes (copy), LocalPlayer (copy), v1 (ref), v2 (ref), pick (copy)
    local v15 = v2
    local Character = LocalPlayer.Character
    local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

    if v15 ~= nil and v15.Parent == Character and HumanoidRootPart ~= nil and HumanoidRootPart:IsA("BasePart") and BanjoCricketFlags.Enabled:Get() then
        local v16 = pick(HumanoidRootPart)

        if v16 ~= v1 then
            v1 = v16
            Mushrooms.ShowAim(v16)
            Remotes.BanjoCricket.Aim:FireServer(v16 or 0)
        end
    else
        if v1 == nil then
            return
        end

        v1 = nil
        Mushrooms.ShowAim(nil)
        Remotes.BanjoCricket.Aim:FireServer(0)
    end
end

local function isRagdolled() -- line: 115
    -- upvalues: Workspace (copy), LocalPlayer (copy)
    local RagdollEndTime = LocalPlayer:GetAttribute("RagdollEndTime")

    if typeof(RagdollEndTime) == "number" then
        return Workspace:GetServerTimeNow() < RagdollEndTime
    end

    return false
end

local function isCoolingDown(p6) -- line: 120
    -- upvalues: Workspace (copy)
    local CooldownEndTime = p6:GetAttribute("CooldownEndTime")

    if p6:GetAttribute("CooldownActive") == true and typeof(CooldownEndTime) == "number" then
        return Workspace:GetServerTimeNow() < CooldownEndTime
    end

    return false
end

local function watchCharacter(p7, p8, p9) -- line: 127
    -- upvalues: Workspace (copy), Gears (copy), ToolGameplayGuard (copy), LocalPlayer (copy), v1 (ref), v2 (ref), n1 (ref)
    local v17 = p8:Extend()

    local function equip(p10) -- line: 133
        -- upvalues: p9 (copy), v17 (copy), Workspace (copy), Gears (copy), ToolGameplayGuard (copy), LocalPlayer (copy), v1 (ref), v2 (ref), n1 (ref)
        if not p10:IsA("Tool") then
            return
        end

        local v18 = false

        if p10:GetAttribute("IsBat") == true then
            v18 = true
        else
            local GearName = p10:GetAttribute("GearName")

            if typeof(GearName) == "string" then
                local v19 = Gears.Directory[GearName]

                v18 = v19 ~= nil and v19.ToolController == "Slap"
            end
        end

        if v18 then
            v17:Clean()
            v2 = p10
            v17:Connect(p10.Activated, function() -- line: 140
                -- upvalues: p10 (copy), p9 (copy), Workspace (copy), ToolGameplayGuard (copy), LocalPlayer (copy), v1 (ref), n1 (ref)
                local elapsed = os.clock()

                if not (elapsed - n1 < 0.7) then
                    local CooldownEndTime = p10:GetAttribute("CooldownEndTime")

                    if p10:GetAttribute("CooldownActive") ~= true or typeof(CooldownEndTime) ~= "number" or not (Workspace:GetServerTimeNow() < CooldownEndTime) then
                        local RagdollEndTime = LocalPlayer:GetAttribute("RagdollEndTime")

                        if (typeof(RagdollEndTime) ~= "number" or not (Workspace:GetServerTimeNow() < RagdollEndTime)) and ToolGameplayGuard.AllowsLocalUse(p10) and p10:GetAttribute("BanjoBridgePlaying") ~= true then
                            n1 = elapsed

                            local v20 = v1

                            if v20 then
                                p9(v20)
                            end
                        end
                    end
                end
            end)
        end
    end

    p8:Connect(p7.ChildAdded, equip)
    p8:Connect(p7.ChildRemoved, function(p11) -- line: 159
        -- upvalues: v17 (copy), v2 (ref)
        if p11 == v2 then
            v2 = nil
            v17:Clean()
        end
    end)

    for _, child in p7:GetChildren() do
        equip(child)
    end
end

function t1.Start(p12) -- line: 170
    -- upvalues: RunService (copy), Trove (copy), LocalPlayer (copy), v2 (ref), update (copy), watchCharacter (copy)
    local v21 = Trove.new()

    local function onCharacter(p13) -- line: 172
        -- upvalues: p12 (copy), v21 (copy), v2 (ref), watchCharacter (copy)
        v21:Clean()
        v2 = nil
        watchCharacter(p13, v21, p12)
    end

    LocalPlayer.CharacterAdded:Connect(onCharacter)

    local Character = LocalPlayer.Character

    if Character then
        v21:Clean()
        v2 = nil
        watchCharacter(Character, v21, p12)
    end

    RunService.PreRender:Connect(update)
end

return table.freeze(t1)
