-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local Constants = require(ReplicatedStorage.Shared.Globals.Constants)
local GuardAreaGeometry = require(ReplicatedStorage.Shared.Util.GuardAreaGeometry)
local Player = require(ReplicatedStorage.Shared.Player)
local v1 = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local v2 = Color3.fromRGB(255, 255, 255)
local PLACED_TRAP = Constants.TAGS_MAP.Traps.PLACED_TRAP
local LocalPlayer = Players.LocalPlayer

return {
    Start = function() -- Start | line: 46
        -- upvalues: CollectionService (copy), RunService (copy), TweenService (copy), Workspace (copy), GuardAreaGeometry (copy), Player (copy), v1 (copy), v2 (copy), PLACED_TRAP (copy), LocalPlayer (copy)
        local World = Workspace.World

        assert(World:IsA("Folder"), "Workspace.World must be a Folder")

        local Areas = World.Areas

        assert(Areas:IsA("Folder"), "Workspace.World.Areas must be a Folder")

        local SeparationLine = Areas.SeparationLine

        assert(SeparationLine:IsA("BasePart"), "Workspace.World.Areas.SeparationLine must be a BasePart")

        local t2 = {}
        local Position
        local v3 = false

        local function getOrCreateState(p1) -- line: 65
            -- upvalues: t2 (copy)
            local v4 = t2[p1]

            if v4 then
                return v4
            end

            local t3 = {
                Highlight = nil,
                Tween = nil,
                FadeOutVersion = 0
            }

            t2[p1] = t3

            return t3
        end

        local function cancelTween(p2) -- line: 80
            local Tween = p2.Tween

            if Tween then
                p2.Tween = nil
                Tween:Cancel()
            end
        end

        local function isOwnedTrap(p3) -- line: 88
            -- upvalues: LocalPlayer (copy)
            return p3:GetAttribute("Owner") == LocalPlayer.Name
        end

        local function showTrapHighlight(p4) -- line: 92
            -- upvalues: t2 (copy), TweenService (copy), v1 (copy), v2 (copy), LocalPlayer (copy)
            if p4:GetAttribute("Owner") ~= LocalPlayer.Name then
                return
            end

            local v5 = t2[p4]

            if not v5 then
                v5 = {
                    Highlight = nil,
                    Tween = nil,
                    FadeOutVersion = 0
                }
                t2[p4] = v5
            end

            v5.FadeOutVersion += 1

            local Tween = v5.Tween

            if Tween then
                v5.Tween = nil
                Tween:Cancel()
            end

            local TrapGameplayHighlight = p4:FindFirstChild("TrapGameplayHighlight")

            if not (TrapGameplayHighlight and TrapGameplayHighlight:IsA("Highlight")) then
                TrapGameplayHighlight = Instance.new("Highlight")
                TrapGameplayHighlight.Name = "TrapGameplayHighlight"
                TrapGameplayHighlight.Parent = p4
            end

            TrapGameplayHighlight.Adornee = p4
            TrapGameplayHighlight.DepthMode = Enum.HighlightDepthMode.Occluded
            TrapGameplayHighlight.FillColor = v2
            TrapGameplayHighlight.FillTransparency = 1
            TrapGameplayHighlight.OutlineColor = v2
            TrapGameplayHighlight.OutlineTransparency = 1
            v5.Highlight = TrapGameplayHighlight

            local tween = TweenService:Create(TrapGameplayHighlight, v1, {
                OutlineTransparency = 0.3
            })

            v5.Tween = tween
            tween:Play()
        end

        local function hideTrapHighlight(p5) -- line: 123
            -- upvalues: t2 (copy), TweenService (copy), v1 (copy)
            local v6 = t2[p5]

            if v6 then
                local Highlight = v6.Highlight

                if Highlight then
                    v6.FadeOutVersion += 1

                    local FadeOutVersion, Tween = v6.FadeOutVersion, v6.Tween

                    if Tween then
                        v6.Tween = nil
                        Tween:Cancel()
                    end

                    local tween = TweenService:Create(Highlight, v1, {
                        OutlineTransparency = 1
                    })

                    tween:Play()
                    v6.Tween = tween
                    tween.Completed:Once(function(p6) -- line: 140
                        -- upvalues: v6 (copy), Highlight (copy), FadeOutVersion (copy)
                        if p6 ~= Enum.PlaybackState.Completed or v6.FadeOutVersion ~= FadeOutVersion then
                            return
                        end

                        if Highlight.Parent then
                            Highlight:Destroy()
                        end

                        v6.Highlight = nil
                        v6.Tween = nil
                    end)
                end
            end
        end

        local function setTrapHighlightsVisible(p7) -- line: 153
            -- upvalues: t2 (copy), showTrapHighlight (copy), hideTrapHighlight (copy)
            for v7 in pairs(t2) do
                if p7 then
                    showTrapHighlight(v7)
                else
                    hideTrapHighlight(v7)
                end
            end
        end

        local function cleanupTrap(p8) -- line: 163
            -- upvalues: t2 (copy)
            local v8 = t2[p8]

            if not v8 then
                return
            end

            local Tween = v8.Tween

            if Tween then
                v8.Tween = nil
                Tween:Cancel()
            end

            local Highlight = v8.Highlight

            if Highlight and Highlight.Parent then
                Highlight:Destroy()
            end

            t2[p8] = nil
        end

        local function trackTrap(p9) -- line: 177
            -- upvalues: t2 (copy), v3 (ref), showTrapHighlight (copy), LocalPlayer (copy)
            if not p9:IsA("BasePart") or p9:GetAttribute("Owner") ~= LocalPlayer.Name then
                return
            end

            if not t2[p9] then
                t2[p9] = {
                    Highlight = nil,
                    Tween = nil,
                    FadeOutVersion = 0
                }
            end

            if v3 then
                showTrapHighlight(p9)
            end

            p9.Destroying:Once(function() -- line: 190
                -- upvalues: p9 (copy), t2 (copy)
                local v9 = t2[p9]

                if not v9 then
                    return
                end

                local Tween = v9.Tween

                if Tween then
                    v9.Tween = nil
                    Tween:Cancel()
                end

                local Highlight = v9.Highlight

                if Highlight and Highlight.Parent then
                    Highlight:Destroy()
                end

                t2[p9] = nil
            end)
        end

        local function untrackTrap(p10) -- line: 193
            -- upvalues: t2 (copy), v3 (ref), hideTrapHighlight (copy)
            if p10:IsA("BasePart") then
                if v3 then
                    hideTrapHighlight(p10)
                else
                    local v10 = t2[p10]

                    if v10 then
                        local Tween = v10.Tween

                        if Tween then
                            v10.Tween = nil
                            Tween:Cancel()
                        end

                        local Highlight = v10.Highlight

                        if Highlight and Highlight.Parent then
                            Highlight:Destroy()
                        end

                        t2[p10] = nil
                    end
                end
            end
        end

        for _, v11 in ipairs(CollectionService:GetTagged(PLACED_TRAP)) do
            trackTrap(v11)
        end

        CollectionService:GetInstanceAddedSignal(PLACED_TRAP):Connect(trackTrap)
        CollectionService:GetInstanceRemovedSignal(PLACED_TRAP):Connect(untrackTrap)
        RunService.PreRender:Connect(function() -- line: 212
            -- upvalues: SeparationLine (copy), t2 (copy), Position (ref), v3 (ref), showTrapHighlight (copy), hideTrapHighlight (copy), GuardAreaGeometry (copy), Player (copy), LocalPlayer (copy)
            local v12 = Player.FindRootPart(LocalPlayer)

            if v12 == nil or not v12:IsA("BasePart") then
                return
            end

            local Position2 = v12.Position
            local Position3 = Position

            Position = Position2

            if Position3 ~= nil then
                if GuardAreaGeometry.CrossedLineInward(SeparationLine, Position3, Position2) then
                    v3 = true

                    for v14 in pairs(t2) do
                        showTrapHighlight(v14)
                    end
                elseif GuardAreaGeometry.CrossedLineOutward(SeparationLine, Position3, Position2) then
                    v3 = false

                    for v15 in pairs(t2) do
                        hideTrapHighlight(v15)
                    end
                end
            else
                v3 = GuardAreaGeometry.IsPastLine(SeparationLine, Position2)

                if v3 then
                    for v13 in pairs(t2) do
                        showTrapHighlight(v13)
                    end
                end
            end
        end)
    end
}
