-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local ArrowPointer3D = require(ReplicatedStorage.Client.WorldFX.ArrowPointer3D)
local LocalPlayer = Players.LocalPlayer
local AnchorForZone = require(ReplicatedStorage.Shared.Remotes).ZoneProbe.AnchorForZone
local v1, v2
local n1 = 0
local v3, v4

return {
    Start = function() -- Start | line: 25
        -- upvalues: CollectionService (copy), Workspace (copy), ArrowPointer3D (copy), LocalPlayer (copy), AnchorForZone (copy), v1 (ref), v2 (ref), n1 (ref), v3 (ref), v4 (ref)
        local function resolveTargetPart(p1) -- line: 26
            if p1:IsA("BasePart") then
                return p1
            end

            if not p1:IsA("Model") then
                return nil
            end

            if p1.PrimaryPart == nil then
                return p1:FindFirstChildWhichIsA("BasePart", true)
            end

            return p1.PrimaryPart
        end

        local function findTaggedTargetPart(p2) -- line: 39
            -- upvalues: CollectionService (copy), Workspace (copy)
            for _, v5 in ipairs(CollectionService:GetTagged(p2)) do
                if v5:IsDescendantOf(Workspace) then
                    local v6 = if v5:IsA("BasePart") then v5
                        elseif not v5:IsA("Model") then nil
                        elseif v5.PrimaryPart ~= nil then v5.PrimaryPart
                        else v5:FindFirstChildWhichIsA("BasePart", true)

                    if v6 ~= nil then
                        return v6
                    end
                end
            end

            return nil
        end

        local function getCharacterRoot() -- line: 51
            -- upvalues: LocalPlayer (copy)
            local Character = LocalPlayer.Character

            if Character == nil then
                return nil
            end

            local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

            return if HumanoidRootPart ~= nil and HumanoidRootPart:IsA("BasePart") then HumanoidRootPart else nil
        end

        local function destroyArrow() -- line: 63
            -- upvalues: v3 (ref), v4 (ref)
            if v3 ~= nil then
                v3:Destroy()
                v3 = nil
            end

            v4 = nil
        end

        local function pointArrowAt(p3) -- line: 71
            -- upvalues: ArrowPointer3D (copy), LocalPlayer (copy), v3 (ref), v4 (ref)
            local Character = LocalPlayer.Character
            local HumanoidRootPart

            if Character ~= nil then
                HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

                if HumanoidRootPart == nil or not HumanoidRootPart:IsA("BasePart") then
                    HumanoidRootPart = nil
                end
            end

            if HumanoidRootPart ~= nil then
                if v3 == nil or v4 ~= p3 then
                    if v3 ~= nil then
                        v3:Destroy()
                        v3 = nil
                    end

                    v4 = nil

                    local v7 = ArrowPointer3D.new(p3, HumanoidRootPart)

                    v7:Start()
                    v3 = v7
                    v4 = p3
                else
                    v3:PointFrom(HumanoidRootPart)
                end
            end
        end

        local function isPlayerInZone(p4) -- line: 89
            -- upvalues: LocalPlayer (copy)
            return LocalPlayer:GetAttribute("AreaId") == p4
        end

        local function runZoneLoop(p5, p6, p7) -- line: 93
            -- upvalues: findTaggedTargetPart (copy), pointArrowAt (copy), LocalPlayer (copy), v1 (ref), v2 (ref), n1 (ref), v3 (ref), v4 (ref)
            while v1 == p5 and v2 == p6 and n1 == p7 do
                local v8 = false
                local v9 = false
                local v10 = false
                local v11 = false
                local v12 = false

                if LocalPlayer:GetAttribute("AreaId") == p5 then
                    v9 = true
                else
                    v8 = true
                end

                if v8 then
                    if v3 ~= nil then
                        v10 = true
                    else
                        v11 = true
                    end
                end

                v8 = false

                if v10 then
                    v3:Destroy()
                    v3 = nil
                    v11 = true
                end

                v10 = false

                if v11 then
                    v4 = nil
                    v12 = false
                end

                v11 = false

                local v13, Character

                if v9 then
                    v13 = findTaggedTargetPart(p6)
                    Character = LocalPlayer.Character

                    if Character ~= nil then
                        v11 = true
                    else
                        v10 = true
                    end
                end

                v9 = false

                local HumanoidRootPart

                if v11 then
                    HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

                    if HumanoidRootPart ~= nil then
                        v9 = true
                    else
                        v8 = true
                    end
                end

                v11 = false

                if v9 then
                    if HumanoidRootPart:IsA("BasePart") then
                        v11 = true
                    else
                        v8 = true
                    end
                end

                v9 = false

                if v8 then
                    v9 = true
                end

                v8 = false

                local HumanoidRootPart2

                if v11 then
                    HumanoidRootPart2 = HumanoidRootPart
                    v9 = true
                end

                v11 = false

                if v10 then
                    HumanoidRootPart2 = nil
                    v9 = true
                end

                if v9 then
                    if v13 ~= nil then
                        v11 = true
                    else
                        v8 = true
                    end
                end

                v9 = false

                if v11 then
                    if HumanoidRootPart2 ~= nil then
                        v9 = true
                    else
                        v8 = true
                    end
                end

                v11 = false

                if v9 then
                    if (HumanoidRootPart2.Position - v13.Position).Magnitude <= 25 then
                        v12 = true
                    else
                        v8 = true
                    end
                end

                v9 = false

                if v8 then
                    if v13 ~= nil then
                        v9 = true
                    else
                        v11 = true
                    end
                end

                v8 = false

                if v9 then
                    v12 = false
                    pointArrowAt(v13)
                end

                v9 = false

                if v11 then
                    if v3 ~= nil then
                        v9 = true
                    else
                        v8 = true
                    end
                end

                if v9 then
                    v3:Destroy()
                    v3 = nil
                    v8 = true
                end

                if v8 then
                    v4 = nil
                    v12 = false
                end

                if v12 then
                    break
                end

                task.wait(0.25)
            end

            if v3 ~= nil then
                v3:Destroy()
                v3 = nil
            end

            v4 = nil

            if n1 == p7 then
                v1 = nil
                v2 = nil
            end
        end

        local function setZone(p8, p9) -- line: 122
            -- upvalues: runZoneLoop (copy), v1 (ref), v2 (ref), n1 (ref), v3 (ref), v4 (ref)
            n1 += 1
            v1 = p8
            v2 = p9

            if v3 ~= nil then
                v3:Destroy()
                v3 = nil
            end

            v4 = nil

            if p8 ~= nil and p9 ~= nil then
                task.spawn(runZoneLoop, p8, p9, n1)
            end
        end

        AnchorForZone.OnClientEvent:Connect(function(p10, p11) -- line: 135
            -- upvalues: runZoneLoop (copy), v1 (ref), v2 (ref), n1 (ref), v3 (ref), v4 (ref)
            if not ((p10 == nil or typeof(p10) == "string") and (p11 == nil or typeof(p11) == "string")) then
                return
            end

            n1 += 1
            v1 = p10
            v2 = p11

            if v3 ~= nil then
                v3:Destroy()
                v3 = nil
            end

            v4 = nil

            if p10 ~= nil then
                if p11 == nil then
                    return
                end

                task.spawn(runZoneLoop, p10, p11, n1)
            end
        end)
    end
}
