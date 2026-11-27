-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local Debris = game:GetService("Debris")
local ContentProvider = game:GetService("ContentProvider")
local LocalPlayer = Players.LocalPlayer
local MutationDisplay = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("MutationDisplay"))
local SpearHooked = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("SpearHooked")
local MutationCrack = ReplicatedStorage:WaitForChild("VFX"):WaitForChild("MutationCrack")

task.spawn(function() -- line: 20
    -- upvalues: ContentProvider (copy), MutationCrack (copy)
    local t1 = {}

    for _, descendant in ipairs(MutationCrack:GetDescendants()) do
        if descendant:IsA("ParticleEmitter") then
            t1[#t1 + 1] = descendant
        end
    end

    ContentProvider:PreloadAsync(t1)
end)

local function crack(p1, p2) -- line: 28
    -- upvalues: SoundService (copy), Debris (copy), MutationDisplay (copy), MutationCrack (copy)
    if not p1 or not p1.Parent or not p2 or p2 == "None" or p1:GetAttribute("Cracked") then
        return
    end

    local v1 = p1.PrimaryPart or p1:FindFirstChildWhichIsA("BasePart")

    if v1 then
        p1:SetAttribute("Cracked", true)

        local v2 = MutationDisplay[p2]
        local Attachment = Instance.new("Attachment")

        Attachment.Name = "CrackFX"
        Attachment.Parent = v1

        for _, descendant in ipairs(MutationCrack:GetDescendants()) do
            if descendant:IsA("ParticleEmitter") then
                local clone = descendant:Clone()

                if v2 and not v2.cycle then
                    clone.Color = ColorSequence.new(v2.color)
                end

                clone.Parent = Attachment
                clone:Emit(clone:GetAttribute("EmitCount") or 1)
            end
        end

        Debris:AddItem(Attachment, 3)

        local HarpoonSFX = SoundService:FindFirstChild("HarpoonSFX")
        local v3 = HarpoonSFX and HarpoonSFX:FindFirstChild(v2 and v2.sound or "MutationSound")

        if v3 then
            v3:Play()
        end

        v2 = HarpoonSFX and v2 and v2.soundAlso and HarpoonSFX:FindFirstChild(v2.soundAlso)

        if v2 then
            v2:Play()
        end
    end
end

local t2 = {}

SpearHooked.OnClientEvent:Connect(function(p3, p4, p5) -- line: 59
    -- upvalues: LocalPlayer (copy), crack (copy), t2 (copy)
    if p3 and p5 then
        if not p4 or p4:GetAttribute("OccupantUserId") ~= LocalPlayer.UserId then
            crack(p3, p5)
        else
            t2[p3] = p5
        end
    end
end)
task.spawn(function() -- line: 68
    -- upvalues: crack (copy), t2 (copy)
    local Fish = workspace:WaitForChild("Fish")

    local function watch(p6) -- line: 70
        -- upvalues: crack (copy), t2 (copy)
        p6:GetAttributeChangedSignal("LocalHit"):Connect(function() -- line: 71
            -- upvalues: p6 (copy), crack (copy), t2 (copy)
            local v4 = t2[p6]

            if not v4 then
                return
            end

            t2[p6] = nil
            crack(p6, v4)
        end)
    end

    for _, child in ipairs(Fish:GetChildren()) do
        child:GetAttributeChangedSignal("LocalHit"):Connect(function() -- line: 71
            -- upvalues: child (copy), crack (copy), t2 (copy)
            local v5 = t2[child]

            if not v5 then
                return
            end

            t2[child] = nil
            crack(child, v5)
        end)
    end

    Fish.ChildAdded:Connect(watch)
    Fish.ChildRemoved:Connect(function(p7) -- line: 81
        -- upvalues: t2 (copy)
        t2[p7] = nil
    end)
end)
