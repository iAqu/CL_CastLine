-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local RunService = game:GetService("RunService")
local SmartProximityPrompt = require(ReplicatedStorage.Client.SmartProximityPrompt)
local HalloweenDimension = require(ReplicatedStorage.Shared.Remotes).HalloweenDimension
local Trove = require(ReplicatedStorage.Packages.Trove)
local LocalPlayer = Players.LocalPlayer
local t1 = {}

local function remove(p1) -- line: 14
    -- upvalues: t1 (copy)
    local v1 = t1[p1]

    if v1 ~= nil then
        t1[p1] = nil
        v1.Trove:Destroy()
    end
end

local function add(p2) -- line: 21
    -- upvalues: SmartProximityPrompt (copy), HalloweenDimension (copy), Trove (copy), LocalPlayer (copy), t1 (copy)
    local v2, v3, v4

    if not p2:IsA("Model") or t1[p2] then
        return
    else
        v2 = Trove.new()
        v3 = v2:Add(Instance.new("ProximityPrompt"))
        v3.Name = "CarryHalloweenEgg"
        v3.ActionText = "Steal"
        v3.ObjectText = "Egg"
        v4 = if workspace:GetAttribute("FastEggPickupTime") then 0.25 else 0.35
    end

    v3.HoldDuration = v4
    v3.KeyboardKeyCode = Enum.KeyCode.E
    v3.Style = Enum.ProximityPromptStyle.Custom
    v2:Add(SmartProximityPrompt.AttachToModel(v3, p2, {
        MaxActivationDistance = 8,
        TrackDistance = 8,
        SurfaceOffset = 0.75
    }))

    local t2 = {
        Busy = false,
        Trove = v2,
        Prompt = v3
    }

    t1[p2] = t2

    local function refresh() -- line: 38
        -- upvalues: p2 (copy), v3 (ref), t2 (copy)
        v3.Enabled = not t2.Busy and p2:GetAttribute("HalloweenEggCanPickUp") == true
    end

    v2:Connect(p2:GetAttributeChangedSignal("HalloweenEggCanPickUp"), refresh)
    v2:Connect(p2.Destroying, function() -- line: 42
        -- upvalues: p2 (copy), t1 (copy)
        local v6 = t1[p2]

        if v6 ~= nil then
            t1[p2] = nil
            v6.Trove:Destroy()
        end
    end)
    v2:Connect(v3.Triggered, function(p3) -- line: 43
        -- upvalues: p2 (copy), v3 (ref), t2 (copy), HalloweenDimension (copy), LocalPlayer (copy)
        if p3 == LocalPlayer and not t2.Busy then
            local HalloweenEggUid = p2:GetAttribute("HalloweenEggUid")

            if typeof(HalloweenEggUid) == "string" then
                t2.Busy = true
                v3.Enabled = not t2.Busy and p2:GetAttribute("HalloweenEggCanPickUp") == true

                local function v7() -- line: 49
                    -- upvalues: HalloweenEggUid (copy), HalloweenDimension (copy)
                    return HalloweenDimension.AskCarryEgg:InvokeServer(HalloweenEggUid)
                end

                local ok, result = pcall(v7)

                t2.Busy = false

                if not ok or not result then
                    v3.Enabled = not t2.Busy and p2:GetAttribute("HalloweenEggCanPickUp") == true
                else
                    v3.Enabled = false
                end
            end
        end
    end)
    v3.Enabled = not t2.Busy and p2:GetAttribute("HalloweenEggCanPickUp") == true
end

for _, v8 in CollectionService:GetTagged("HalloweenWorldEgg") do
    add(v8)
end

CollectionService:GetInstanceAddedSignal("HalloweenWorldEgg"):Connect(add)
CollectionService:GetInstanceRemovedSignal("HalloweenWorldEgg"):Connect(remove)

local n1 = 0

RunService.Heartbeat:Connect(function(p4) -- line: 61
    -- upvalues: LocalPlayer (copy), t1 (copy), n1 (ref)
    n1 += p4

    if n1 < 0.1 then
        return
    end

    n1 = 0

    local Character = LocalPlayer.Character
    local PetMountSession = Character and Character:FindFirstChild("PetMountSession")
    local HeightIncrease = PetMountSession and PetMountSession:GetAttribute("HeightIncrease")
    local v9 = if typeof(HeightIncrease) == "number" and HeightIncrease > 0 and HeightIncrease < 1e999 then math.sqrt(64 + HeightIncrease * HeightIncrease) else 8

    for _, v11 in t1 do
        v11.Prompt.MaxActivationDistance = v9
    end
end)
