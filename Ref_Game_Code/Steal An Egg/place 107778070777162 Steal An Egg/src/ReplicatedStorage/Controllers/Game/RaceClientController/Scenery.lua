-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local LightingController = require(ReplicatedStorage.Controllers.Game.LightingController)
local MountRace = require(ReplicatedStorage.Data.MountRace)
local LocalPlayer = Players.LocalPlayer

local function trackNamed(p1) -- line: 41
    -- upvalues: CollectionService (copy), Workspace (copy), MountRace (copy)
    for _, v1 in CollectionService:GetTagged(MountRace.TrackTag) do
        if v1.Name == p1 and v1:IsDescendantOf(Workspace) then
            return v1
        end
    end

    return nil
end

local function boundsOf(p2) -- line: 50
    local AttachmentTrack = p2:FindFirstChild("AttachmentTrack")

    if AttachmentTrack == nil then
        return nil
    end

    local v2 = Vector3.new(1, 1, 1) * 1e999
    local v3 = Vector3.new(-1, -1, -1) * 1e999

    for _, child in AttachmentTrack:GetChildren() do
        if child:IsA("Attachment") then
            v2 = v2:Min(child.WorldPosition)
            v3 = v3:Max(child.WorldPosition)
        end
    end

    return if v2.X ~= 1e999 then {
        Min = v2 - Vector3.new(600, 600, 600),
        Max = v3 + Vector3.new(600, 600, 600)
    } else nil
end

local function within(p3, p4) -- line: 69
    if p3 == p3:Max(p4.Min) then
        return p3 == p3:Min(p4.Max)
    end

    return false
end

local t1 = {
    Start = function() -- Start | line: 77
        -- upvalues: RunService (copy), Workspace (copy), LightingController (copy), LocalPlayer (copy), trackNamed (copy), boundsOf (copy)
        local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
        local Folder = Instance.new("Folder")

        Folder.Name = "RaceScenery"
        Folder.Parent = Workspace

        local t2 = {}

        local function watchHolder(p5) -- line: 84
            -- upvalues: t2 (copy)
            local function add(p6) -- line: 85
                -- upvalues: p5 (copy), t2 (copy)
                if t2[p6] == nil then
                    t2[p6] = {
                        Bounds = nil,
                        Shown = false,
                        Lighting = nil,
                        Holder = p5
                    }
                end
            end

            p5.ChildAdded:Connect(add)

            for _, child in p5:GetChildren() do
                if t2[child] == nil then
                    t2[child] = {
                        Bounds = nil,
                        Shown = false,
                        Lighting = nil,
                        Holder = p5
                    }
                end
            end
        end

        local function show(p7, p8) -- line: 96
            -- upvalues: Folder (copy), LightingController (copy)
            p8.Shown = true

            if p8.Lighting == nil then
                local LightingSettings = p7:FindFirstChild("LightingSettings")

                if LightingSettings ~= nil then
                    LightingSettings.Parent = nil
                    p8.Lighting = LightingSettings
                end
            end

            p7.Parent = Folder

            local Lighting = p8.Lighting

            if Lighting ~= nil then
                LightingController.SetAuthoredLayer("RaceScenery", Lighting, 150, 1)
            end
        end

        local function hide(p9, p10) -- line: 112
            -- upvalues: LightingController (copy)
            p10.Shown = false
            LightingController.ClearLayer("RaceScenery", 1)

            if p9.Parent ~= nil then
                p9.Parent = p10.Holder
            end
        end

        local function sync() -- line: 120
            -- upvalues: Folder (copy), t2 (copy), LightingController (copy), LocalPlayer (copy), trackNamed (copy), boundsOf (copy)
            local Character = LocalPlayer.Character
            local HumanoidRootPart = if Character == nil then nil else Character:FindFirstChild("HumanoidRootPart")

            for v4, v5 in t2 do
                if v4.Parent ~= nil then
                    if v5.Bounds == nil then
                        local v6 = trackNamed(v4.Name)

                        if v6 ~= nil then
                            v5.Bounds = boundsOf(v6)
                        else
                            v5.Bounds = nil
                        end
                    end

                    local Bounds = v5.Bounds
                    local BasePart

                    if HumanoidRootPart ~= nil then
                        BasePart = HumanoidRootPart:IsA("BasePart")

                        if BasePart then
                            if Bounds ~= nil then
                                local Position = HumanoidRootPart.Position

                                BasePart = Position == Position:Max(Bounds.Min) and Position == Position:Min(Bounds.Max)
                            else
                                BasePart = false
                            end
                        end
                    else
                        BasePart = false
                    end

                    if BasePart then
                        if not v5.Shown then
                            v5.Shown = true

                            if v5.Lighting == nil then
                                local LightingSettings = v4:FindFirstChild("LightingSettings")

                                if LightingSettings ~= nil then
                                    LightingSettings.Parent = nil
                                    v5.Lighting = LightingSettings
                                end
                            end

                            v4.Parent = Folder

                            local Lighting = v5.Lighting

                            if Lighting ~= nil then
                                LightingController.SetAuthoredLayer("RaceScenery", Lighting, 150, 1)
                            end
                        end
                    elseif v5.Shown then
                        v5.Shown = false
                        LightingController.ClearLayer("RaceScenery", 1)

                        if v4.Parent ~= nil then
                            v4.Parent = v5.Holder
                        end
                    end
                else
                    t2[v4] = nil

                    if v5.Shown then
                        v5.Shown = false
                        LightingController.ClearLayer("RaceScenery", 1)
                    end
                end
            end
        end

        PlayerGui.ChildAdded:Connect(function(p11) -- line: 147
            -- upvalues: watchHolder (copy)
            if p11.Name == "RaceScenery" then
                watchHolder(p11)
            end
        end)

        local RaceScenery = PlayerGui:FindFirstChild("RaceScenery")

        if RaceScenery ~= nil then
            watchHolder(RaceScenery)
        end

        local n1 = 0

        RunService.Heartbeat:Connect(function(p12) -- line: 158
            -- upvalues: sync (copy), n1 (ref)
            n1 += p12

            if n1 < 0.25 then
                return
            end

            n1 = 0

            local ok, result = pcall(sync)

            if not ok then
                warn((("[RaceScenery] %*"):format(result)))
            end
        end)
    end
}

return table.freeze(t1)
