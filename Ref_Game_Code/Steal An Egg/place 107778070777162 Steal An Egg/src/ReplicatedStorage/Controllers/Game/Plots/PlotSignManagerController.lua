-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Player = require(ReplicatedStorage.Shared.Player)
local PlotState = require(ReplicatedStorage.Client.PlotState)

require(ReplicatedStorage.Shared.Types.Plots)

local Streamable = require(ReplicatedStorage.Packages.Streamable).Streamable
local PlotSignHomeButtonFade = require(script.Parent.Parent.Parent.GUI.PlotSignHomeButtonFade)
local Trove = require(ReplicatedStorage.Packages.Trove)
local LocalPlayer = Players.LocalPlayer
local v1 = Trove.new()
local t1 = {}
local t3 = {}

return {
    Start = function() -- Start | line: 34
        -- upvalues: Players (copy), RunService (copy), Player (copy), PlotState (copy), Streamable (copy), PlotSignHomeButtonFade (copy), Trove (copy), LocalPlayer (copy), v1 (copy), t1 (copy), t3 (copy)
        local function clearRemotePlotSignBinding(p1) -- line: 39
            -- upvalues: t3 (copy)
            local v2 = t3[p1]

            if v2 ~= nil then
                v2:Destroy()
            end
        end

        local function bindRemotePlotSign(p2, p3) -- line: 48
            -- upvalues: Players (copy), PlotState (copy), Streamable (copy), Trove (copy), LocalPlayer (copy), t1 (copy), t3 (copy)
            local v3 = t3[p2]

            if v3 ~= nil then
                v3:Destroy()
            end

            if p3 ~= nil and p3 ~= LocalPlayer.UserId then
                local PlayerByUserId = Players:GetPlayerByUserId(p3)

                if PlayerByUserId ~= nil then
                    local v4 = PlotState.ResolvePlot(PlayerByUserId)

                    if v4 ~= nil then
                        local v5 = Trove.new()

                        t3[p2] = v5
                        v5:Add(function() -- line: 67
                            -- upvalues: p2 (copy), v5 (copy), t3 (copy)
                            if t3[p2] == v5 then
                                t3[p2] = nil
                            end
                        end)

                        local PlotSign = Streamable.new(v4.PlotFolder, "PlotSign")

                        v5:Add(function() -- line: 74
                            -- upvalues: PlotSign (copy)
                            PlotSign:Destroy()
                        end)
                        v5:Add(PlotSign:Observe(function(p4, p5) -- line: 75
                            -- upvalues: p2 (copy), v4 (copy), Streamable (copy), t1 (copy)
                            local PlayerPlotSign = Streamable.new(p4, "PlayerPlotSign")

                            p5:Add(function() -- line: 77
                                -- upvalues: PlayerPlotSign (copy)
                                PlayerPlotSign:Destroy()
                            end)
                            p5:Add(PlayerPlotSign:Observe(function(p6) -- line: 78
                                -- upvalues: p2 (copy), v4 (copy), t1 (copy)
                                assert(p6:IsA("BillboardGui"), "PlayerPlotSign must be a BillboardGui")

                                local t4 = {
                                    PetArea = v4.PetArea,
                                    PlayerPlotSign = p6
                                }

                                t1[p2] = t4

                                return function() -- line: 87
                                    -- upvalues: p6 (copy), t4 (copy), p2 (copy), t1 (copy)
                                    if t1[p2] == t4 then
                                        t1[p2] = nil
                                    end

                                    if p6.Parent ~= nil then
                                        p6.AlwaysOnTop = false
                                    end
                                end
                            end))
                        end))
                    end
                end
            end
        end

        local function rebindAllRemotePlotSigns() -- line: 99
            -- upvalues: bindRemotePlotSign (copy), PlotState (copy), t3 (copy)
            local t5 = {}

            for v6 in pairs(t3) do
                t5[#t5 + 1] = v6
            end

            for _, v7 in ipairs(t5) do
                local v8 = t3[v7]

                if v8 ~= nil then
                    v8:Destroy()
                end
            end

            for v9, v10 in pairs(PlotState.ReadOwners()) do
                bindRemotePlotSign(v9, v10)
            end
        end

        local function updateRemotePlotSigns() -- line: 113
            -- upvalues: Player (copy), LocalPlayer (copy), t1 (copy)
            local v11 = Player.FindRootPart(LocalPlayer)
            local Position = if v11 == nil then nil else v11.Position

            for _, v12 in pairs(t1) do
                local PlayerPlotSign = v12.PlayerPlotSign

                if PlayerPlotSign.Parent ~= nil then
                    local PetArea = v12.PetArea
                    local v13

                    if Position == nil or PetArea.Parent == nil then
                        v13 = false
                    else
                        local v14 = PetArea.CFrame:PointToObjectSpace(Position)
                        local v15 = PetArea.Size * 0.5

                        v13 = math.abs(v14.X) <= v15.X and math.abs(v14.Z) <= v15.Z
                    end

                    if PlayerPlotSign.AlwaysOnTop ~= v13 then
                        PlayerPlotSign.AlwaysOnTop = v13
                    end
                end
            end
        end

        local function updateYourBaseTracker(p7) -- line: 136
            -- upvalues: RunService (copy), Streamable (copy), PlotSignHomeButtonFade (copy), LocalPlayer (copy), v1 (copy)
            v1:Clean()

            if not p7 then
                return
            end

            local CenterPoint = p7.CenterPoint
            local PlotSign = Streamable.new(p7.PlotFolder, "PlotSign")

            v1:Add(function() -- line: 144
                -- upvalues: PlotSign (copy)
                PlotSign:Destroy()
            end)
            v1:Add(PlotSign:Observe(function(p8, p9) -- line: 145
                -- upvalues: CenterPoint (copy), RunService (copy), Streamable (copy), PlotSignHomeButtonFade (copy), LocalPlayer (copy)
                local SignUI = Streamable.new(p8, "SignUI")

                p9:Add(function() -- line: 147
                    -- upvalues: SignUI (copy)
                    SignUI:Destroy()
                end)
                p9:Add(SignUI:Observe(function(p10) -- line: 148
                    assert(p10:IsA("BillboardGui"), "SignUI must be a BillboardGui")

                    local Enabled = p10.Enabled

                    p10.Enabled = false

                    return function() -- line: 154
                        -- upvalues: p10 (copy), Enabled (copy)
                        if p10.Parent ~= nil then
                            p10.Enabled = Enabled
                        end
                    end
                end))

                local Attachment = Streamable.new(p8, "Attachment")

                p9:Add(function() -- line: 162
                    -- upvalues: Attachment (copy)
                    Attachment:Destroy()
                end)
                p9:Add(Attachment:Observe(function(p11, p12) -- line: 163
                    -- upvalues: CenterPoint (copy), RunService (copy), Streamable (copy), PlotSignHomeButtonFade (copy), LocalPlayer (copy)
                    local YourBase = Streamable.new(p11, "YourBase")

                    p12:Add(function() -- line: 165
                        -- upvalues: YourBase (copy)
                        YourBase:Destroy()
                    end)
                    p12:Add(YourBase:Observe(function(p13) -- line: 166
                        -- upvalues: p12 (copy), CenterPoint (copy), RunService (copy), PlotSignHomeButtonFade (copy), LocalPlayer (copy)
                        assert(p13:IsA("BillboardGui"), "YourBase must be a BillboardGui")

                        local v16 = PlotSignHomeButtonFade.new(p13)

                        p12:Add(function() -- line: 169
                            -- upvalues: v16 (copy)
                            v16:Destroy()
                        end)

                        local function updateDistance() -- line: 171
                            -- upvalues: p13 (copy), v16 (copy), CenterPoint (copy), LocalPlayer (copy)
                            local Character = LocalPlayer.Character
                            local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

                            if not HumanoidRootPart or not HumanoidRootPart:IsA("BasePart") then
                                v16:SetVisible(false)

                                return
                            end

                            p13.MaxDistance = 300
                            v16:SetVisible((HumanoidRootPart.Position - CenterPoint.Position).Magnitude > 50)
                        end

                        updateDistance()

                        return RunService.Heartbeat:Connect(updateDistance)
                    end))
                end))
            end))
        end

        updateYourBaseTracker(PlotState.ResolvePlot())
        PlotState.LocalPlotChanged:Connect(function() -- line: 193
            -- upvalues: updateYourBaseTracker (copy), PlotState (copy)
            updateYourBaseTracker(PlotState.ResolvePlot())
        end)
        rebindAllRemotePlotSigns()
        PlotState.PlotChanged:Connect(bindRemotePlotSign)
        PlotState.FolderChanged:Connect(rebindAllRemotePlotSigns)
        Players.PlayerAdded:Connect(rebindAllRemotePlotSigns)
        Players.PlayerRemoving:Connect(function(p14) -- line: 199
            -- upvalues: PlotState (copy), t3 (copy)
            for v18, v19 in pairs(PlotState.ReadOwners()) do
                if v19 == p14.UserId then
                    local v20 = t3[v18]

                    if v20 ~= nil then
                        v20:Destroy()
                    end
                end
            end
        end)
        RunService.Heartbeat:Connect(updateRemotePlotSigns)
    end
}
