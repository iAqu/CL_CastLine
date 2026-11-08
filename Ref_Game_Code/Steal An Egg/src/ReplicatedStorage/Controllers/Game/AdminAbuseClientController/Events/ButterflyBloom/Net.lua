-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

game:GetService("Workspace")

local AnimationAssets = require(ReplicatedStorage.Shared.Utils.AnimationAssets)
local ButterflyCatalog = require(ReplicatedStorage.Shared.Modules.ButterflyCatalog)
local ButterflyFlags = require(ReplicatedStorage.Shared.Flags.ButterflyFlags)
local CatchFX = require(script.Parent.CatchFX)
local Player = require(ReplicatedStorage.Shared.Player)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local Swarm = require(script.Parent.Swarm)
local Trove = require(ReplicatedStorage.Packages.Trove)
local LocalPlayer = Players.LocalPlayer
local Butterflies = ReplicatedStorage:WaitForChild("Assets"):WaitForChild("VFX"):WaitForChild("Butterflies")
local v1 = Trove.new()
local v2 = Trove.new()
local v3 = nil
local v4
local n1 = 0
local clone, v5, UIStroke, v6
local v7 = false
local t1 = {}

local function hoopOf(p1) -- line: 48
    local v8 = p1:FindFirstChild("Hoop", true)

    if v8 and v8:IsA("BasePart") then
        return v8
    end

    local Handle = p1:FindFirstChild("Handle")

    return if Handle and Handle:IsA("BasePart") then Handle else nil
end

local function trackFor() -- line: 57
    -- upvalues: AnimationAssets (copy), Player (copy), LocalPlayer (copy), v4 (ref)
    if v4 and v4.Parent then
        return v4
    end

    local v9 = Player.FindAnimator(LocalPlayer)

    if v9 == nil then
        return nil
    end

    local track = v9:LoadAnimation(AnimationAssets.Get("rbxassetid://79127239282844"))

    track.Priority = Enum.AnimationPriority.Action2
    track.Looped = false
    v4 = track

    return track
end

local function reticle() -- line: 72
    -- upvalues: LocalPlayer (copy), Butterflies (copy), clone (ref), v5 (ref), UIStroke (ref)
    if clone and clone.Parent then
        return clone
    end

    local Reticle = Butterflies:FindFirstChild("Reticle")
    local clone2, UIStroke2, v10

    if Reticle ~= nil then
        if Reticle:IsA("BillboardGui") then
            clone2 = Reticle:Clone()
            clone2.Enabled = false
            clone2.Parent = LocalPlayer:WaitForChild("PlayerGui")

            local v11 = clone2:FindFirstChild("Ring", true)

            clone = clone2
            v5 = clone2:FindFirstChildWhichIsA("UIScale", true)

            if v11 then
                UIStroke2 = v11:FindFirstChildOfClass("UIStroke")
            end

            v10 = false
        else
            v10 = true
        end
    else
        v10 = true
    end

    if v10 then
        return nil
    end

    UIStroke = UIStroke2

    return clone2
end

local function hideReticle() -- line: 90
    -- upvalues: clone (ref), v6 (ref)
    v6 = nil

    if not clone then
        return
    end

    clone.Enabled = false
    clone.Adornee = nil
end

local function targetFrom(p2) -- line: 98
    -- upvalues: ButterflyFlags (copy), Swarm (copy), v7 (ref)
    if v7 then
        return Swarm.Nearest(p2.Position, p2.CFrame.LookVector, ButterflyFlags.NetReach:Get())
    end

    return nil
end

local function swing() -- line: 105
    -- upvalues: AnimationAssets (copy), ButterflyCatalog (copy), ButterflyFlags (copy), CatchFX (copy), Player (copy), Remotes (copy), Swarm (copy), LocalPlayer (copy), v3 (ref), v4 (ref), n1 (ref), v7 (ref)
    local v12 = v3

    if v12 ~= nil then
        local elapsed = os.clock()

        if not (elapsed - n1 < ButterflyFlags.SwingCooldownSeconds:Get()) then
            n1 = elapsed

            local v13 = Player.FindRootPart(LocalPlayer)

            if v13 ~= nil then
                local v14

                if not (v4 and v4.Parent) then
                    local v15 = Player.FindAnimator(LocalPlayer)

                    if v15 ~= nil then
                        v14 = v15:LoadAnimation(AnimationAssets.Get("rbxassetid://79127239282844"))
                        v14.Priority = Enum.AnimationPriority.Action2
                        v14.Looped = false
                        v4 = v14
                    end
                else
                    v14 = v4
                end

                if v14 then
                    v14:Play(0.05, 1, 1.25)
                end

                CatchFX.Swing(v13)

                local v16 = if v7 then Swarm.Nearest(v13.Position, v13.CFrame.LookVector, ButterflyFlags.NetReach:Get()) else nil

                if v16 ~= nil then
                    local Id, Tier = v16.Flight.Id, v16.Flight.Tier

                    task.delay(0.09, function() -- line: 130
                        -- upvalues: Id (copy), CatchFX (copy), Swarm (copy)
                        local v17 = Swarm.Get(Id)

                        if v17 then
                            CatchFX.Contact(v17)
                        end
                    end)

                    local spawn = task.spawn
                    local v18 = v14

                    spawn(function() -- line: 136
                        -- upvalues: v12 (copy), Id (copy), Tier (copy), v18 (copy), ButterflyCatalog (copy), CatchFX (copy), Remotes (copy), Swarm (copy)
                        local function v19() -- line: 137
                            -- upvalues: Id (copy), Remotes (copy)
                            return Remotes.Butterflies.AskSwing:InvokeServer(Id)
                        end

                        local v20, v21, v22, v23 = pcall(v19)

                        if not v20 then
                            return
                        end

                        local v24 = v12:FindFirstChild("Hoop", true)

                        if not (v24 and v24:IsA("BasePart")) then
                            v24 = v12:FindFirstChild("Handle")

                            if not (v24 and v24:IsA("BasePart")) then
                                v24 = nil
                            end
                        end

                        local v25 = v22 or Tier

                        if v21 == "Caught" then
                            local v26 = Swarm.Take(Id)

                            CatchFX.Snag(v26, v25, v24, true)

                            local delay = task.delay
                            local SnagSeconds = ButterflyCatalog.SnagSeconds
                            local v27 = v24

                            delay(SnagSeconds, function() -- line: 148
                                -- upvalues: v23 (copy), v26 (copy), v27 (copy), v25 (copy), v18 (copy), CatchFX (copy)
                                CatchFX.Caught(v26, v25, v23, v18, v27)
                            end)
                        elseif v21 == "Escaped" then
                            if v24 then
                                Swarm.Pin(Id, v24.Position, ButterflyCatalog.SnagSeconds)
                            end

                            CatchFX.Snag(Swarm.Get(Id), v25, v24, false)
                            task.delay(ButterflyCatalog.SnagSeconds, function() -- line: 156
                                -- upvalues: v25 (copy), Id (copy), CatchFX (copy), Swarm (copy)
                                CatchFX.Escaped(Swarm.Get(Id), v25)
                            end)
                        elseif v21 == "Gone" then
                            Swarm.Remove(Id)
                        end
                    end)
                end
            end
        end
    end
end

local function autoSwing() -- line: 165
    -- upvalues: ButterflyFlags (copy), n1 (ref), swing (copy)
    if not ButterflyFlags.AutoSwing:Get() then
        return
    end

    if not (math.max(ButterflyFlags.SwingCooldownSeconds:Get(), ButterflyFlags.AutoSwingCooldownSeconds:Get()) > os.clock() - n1) then
        swing()
    end
end

local function bindTool(p3) -- line: 179
    -- upvalues: LocalPlayer (copy), v2 (copy), v3 (ref), clone (ref), v6 (ref), swing (copy)
    v2:Clean()
    v3 = p3
    v2:Connect(p3.Activated, swing)
    v2:Connect(p3.AncestryChanged, function() -- line: 183
        -- upvalues: p3 (copy), LocalPlayer (copy), v2 (copy)
        if p3.Parent ~= LocalPlayer.Character then
            v2:Clean()
        end
    end)
    v2:Add(function() -- line: 188
        -- upvalues: p3 (copy), v3 (ref), clone (ref), v6 (ref)
        if v3 == p3 then
            v3 = nil
        end

        v6 = nil

        if not clone then
            return
        end

        clone.Enabled = false
        clone.Adornee = nil
    end)
end

local function onCharacterChild(p4) -- line: 196
    -- upvalues: bindTool (copy)
    if p4:IsA("Tool") and p4:GetAttribute("ButterflyNet") == true then
        bindTool(p4)
    end
end

local function onCharacter(p5) -- line: 202
    -- upvalues: v1 (copy), v2 (copy), v4 (ref), bindTool (copy), onCharacterChild (copy)
    v1:Clean()
    v2:Clean()
    v4 = nil
    v1:Connect(p5.ChildAdded, onCharacterChild)

    for _, child in p5:GetChildren() do
        if child:IsA("Tool") and child:GetAttribute("ButterflyNet") == true then
            bindTool(child)
        end
    end
end

function t1.SetPresenting(p6) -- line: 216
    -- upvalues: clone (ref), v6 (ref), v7 (ref)
    v7 = p6

    if not p6 then
        v6 = nil

        if clone then
            clone.Enabled = false
            clone.Adornee = nil
        end
    end
end

function t1.Step(p7) -- line: 223
    -- upvalues: ButterflyFlags (copy), Player (copy), Swarm (copy), LocalPlayer (copy), v3 (ref), clone (ref), v5 (ref), UIStroke (ref), v6 (ref), v7 (ref), reticle (copy), autoSwing (copy)
    local v29 = Player.FindRootPart(LocalPlayer)
    local v30, v31

    if v3 == nil or v29 == nil then
        v31 = true
    elseif v7 then
        v30 = Swarm.Nearest(v29.Position, v29.CFrame.LookVector, ButterflyFlags.NetReach:Get())
        v31 = false
    else
        v31 = true
    end

    if not v31 then
        local v32 = reticle()

        if v32 ~= nil then
            if v30 ~= nil then
                if v6 ~= v30 then
                    v6 = v30
                    v32.Adornee = v30.Body

                    if UIStroke then
                        UIStroke.Color = v30.Tier.Color
                    end
                end

                v32.Enabled = true

                local v33 = v5

                if v33 then
                    v33.Scale = math.sin(p7 * 6) * 0.08 + 1
                end

                autoSwing()
            else
                v6 = nil

                if clone then
                    clone.Enabled = false
                    clone.Adornee = nil
                end
            end
        end
    elseif v6 then
        v6 = nil

        if clone then
            clone.Enabled = false
            clone.Adornee = nil
        end
    end
end

function t1.Start() -- line: 255
    -- upvalues: LocalPlayer (copy), onCharacter (copy)
    if LocalPlayer.Character then
        onCharacter(LocalPlayer.Character)
    end

    LocalPlayer.CharacterAdded:Connect(onCharacter)
end

return t1
