-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ReleaseConfig = require(ReplicatedStorage.Config.ReleaseConfig)
local AnimalTemplates = require(ReplicatedStorage.Shared.AnimalTemplates)
local Mutations = require(ReplicatedStorage.Shared.Mutations)
local t1 = {}
local LocalPlayer = Players.LocalPlayer
local n1 = 0

local function readyShells() -- line: 33
    -- upvalues: LocalPlayer (copy)
    local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")
    local StudioAnimals = PlayerGui and PlayerGui:FindFirstChild("StudioAnimals")
    local Shells = StudioAnimals and StudioAnimals:FindFirstChild("Shells")

    if not Shells then
        return nil
    end

    local Count = Shells:GetAttribute("Count")

    if type(Count) ~= "number" or #Shells:GetChildren() < Count then
        return nil
    end

    return Shells, StudioAnimals
end

local function update() -- line: 43
    -- upvalues: AnimalTemplates (copy), Mutations (copy), LocalPlayer (copy), n1 (ref), readyShells (copy), update (copy)
    n1 += 1

    local v1 = n1

    if LocalPlayer:GetAttribute("SeeNewAnimals") ~= true then
        AnimalTemplates.SetOverride(nil)

        return
    end

    local v2 = os.clock() + 30
    local v3, v4, v5

    repeat
        v4, v5 = readyShells()
        v3 = v4

        if not v4 then
            task.wait(0.2)
        end
    until v4 or v2 < os.clock() or n1 ~= v1

    if n1 == v1 and v4 and LocalPlayer:GetAttribute("SeeNewAnimals") == true then
        local MutationFX = v5:FindFirstChild("MutationFX")

        if MutationFX then
            Mutations.UseRainbowFX(MutationFX)
        end

        AnimalTemplates.SetOverride(function(p1) -- line: 59
            -- upvalues: v3 (ref)
            if v3.Parent then
                return v3:FindFirstChild(p1)
            end

            return nil
        end)
        v3.AncestryChanged:Connect(function() -- line: 64
            -- upvalues: v3 (ref), v1 (copy), n1 (ref), update (copy)
            if not v3:IsDescendantOf(game) and n1 == v1 then
                task.spawn(update)
            end
        end)
    end
end

function t1.IsOn() -- line: 69
    -- upvalues: AnimalTemplates (copy)
    return AnimalTemplates.HasOverride()
end

function t1.Init() -- line: 73
    -- upvalues: ReleaseConfig (copy), LocalPlayer (copy), update (copy)
    if ReleaseConfig.IsDeveloper(LocalPlayer) then
        LocalPlayer:GetAttributeChangedSignal("SeeNewAnimals"):Connect(function() -- line: 75
            -- upvalues: update (copy)
            task.spawn(update)
        end)

        if LocalPlayer:GetAttribute("SeeNewAnimals") == true then
            task.spawn(update)
        end
    end
end

return t1
