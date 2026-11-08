-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local TrainRailPath = require(ReplicatedStorage.Shared.Modules.TrainRailPath)
local TrainWheels = require(ReplicatedStorage.Shared.Modules.TrainWheels)
local Audio = require(ReplicatedStorage.Shared.Audio)
local t1 = {}
local v1 = false
local t2 = {}
local t3 = nil
local t4 = {
    Departing = {
        Id = 129023065050025,
        Volume = 0.8,
        MaxDistance = 600
    },
    Whistle = {
        Id = 138461336141917,
        Volume = 0.6,
        MaxDistance = 1500
    }
}

local function playSound(p1, p2) -- line: 20
    -- upvalues: Audio (copy)
    return Audio.Play(p1.Id, p2, {
        Volume = p1.Volume,
        MaxDistance = p1.MaxDistance
    })
end

function t1.EndRide(p3) -- line: 24
    -- upvalues: RunService (copy), t2 (copy), t3 (ref)
    local t5 = t3

    if not t5 or p3 and p3 ~= t5.Id then
        return
    end

    t3 = nil
    RunService:UnbindFromRenderStep("TrainPrivateMotion")

    if t2[t5.Source] == t5.Id then
        t2[t5.Source] = nil
    end

    for v2, v3 in t5.CharacterParts do
        if v2.Parent then
            v2.LocalTransparencyModifier = v3
        end
    end

    t5.Clone:Destroy()
end

function t1.BeginRide(p4) -- line: 42
    -- upvalues: RunService (copy), Workspace (copy), TrainRailPath (copy), TrainWheels (copy), Audio (copy), t1 (copy), t2 (copy), t3 (ref), t4 (copy)
    t1.EndRide()

    local Train = p4.Train

    if typeof(Train) ~= "Instance" or not Train:IsA("Model") or not Train:IsDescendantOf(Workspace) or Train:GetAttribute("TrainVisualSource") ~= true then
        return nil
    end

    local RailPath = Train:FindFirstChild("RailPath")

    if RailPath then
        local Children = RailPath:GetChildren()

        table.sort(Children, function(p5, p6) -- line: 58
            return p5.Name < p6.Name
        end)

        local t6 = {}

        for _, v4 in Children do
            if not v4:IsA("Vector3Value") then
                return nil
            end

            table.insert(t6, v4.Value)
        end

        if not (#t6 < 2) and #t6 == Train:GetAttribute("RailNodeCount") then
            local clone = Train:Clone()

            clone.Name = "PrivateTrain_" .. p4.Id
            clone:SetAttribute("TrainVisualSource", nil)

            local n1 = 0

            for _, descendant in clone:GetDescendants() do
                if descendant:IsA("BasePart") then
                    n1 += 1
                    descendant.Anchored = true
                    descendant.CanCollide = false
                    descendant.CanTouch = false
                    descendant.CanQuery = false
                    descendant.LocalTransparencyModifier = 0
                    descendant.Transparency = descendant:GetAttribute("RailAuthoredTransparency") or descendant.Transparency
                elseif descendant:IsA("Decal") then
                    descendant.Transparency = descendant:GetAttribute("RailAuthoredTransparency") or descendant.Transparency
                elseif descendant:IsA("Light") or descendant:IsA("Beam") or descendant:IsA("ParticleEmitter") then
                    descendant.Enabled = true
                end
            end

            if n1 == Train:GetAttribute("RailPartCount") then
                local t7 = {}

                for _, child in clone:GetChildren() do
                    if child:IsA("Model") and child.PrimaryPart and type(child:GetAttribute("TrainCarOffset")) == "number" then
                        table.insert(t7, child)
                    end
                end

                if #t7 == 0 then
                    clone:Destroy()

                    return nil
                end

                table.sort(t7, function(p7, p8) -- line: 108
                    return p7:GetAttribute("TrainCarIndex") < p8:GetAttribute("TrainCarIndex")
                end)
                clone.PrimaryPart = t7[1].PrimaryPart

                local t8 = {
                    Id = p4.Id,
                    Source = Train,
                    Clone = clone,
                    CharacterParts = {}
                }

                for _, descendant in p4.Character:GetDescendants() do
                    if descendant:IsA("BasePart") then
                        t8.CharacterParts[descendant] = descendant.LocalTransparencyModifier
                    end
                end

                local v5 = TrainRailPath.Prepare(t6)
                local v6 = TrainWheels.Bind(t7)

                local function draw() -- line: 120
                    -- upvalues: p4 (copy), t7 (copy), t8 (copy), v5 (copy), v6 (copy), Workspace (copy), TrainRailPath (copy), TrainWheels (copy)
                    local v7 = TrainRailPath.DistanceAt(p4.StartDistance, p4.EndDistance, p4.StartedAt, p4.Duration, Workspace:GetServerTimeNow())

                    for _, v8 in t7 do
                        v8:PivotTo(TrainRailPath.Frame(v5, v7 - v8:GetAttribute("TrainCarOffset")))
                    end

                    TrainWheels.Update(v6, v7)

                    for v9 in t8.CharacterParts do
                        if v9.Parent then
                            v9.LocalTransparencyModifier = 1
                        end
                    end
                end

                draw()
                clone.Parent = Workspace:FindFirstChild("TrainEventVisuals") or Workspace
                t2[Train] = p4.Id
                t3 = t8

                if p4.Mode == "Departure" then
                    local Departing = t4.Departing
                    local PrimaryPart = clone.PrimaryPart

                    Audio.Play(Departing.Id, PrimaryPart, {
                        Volume = Departing.Volume,
                        MaxDistance = Departing.MaxDistance
                    })
                elseif p4.Mode == "Arrival" then
                    local Whistle = t4.Whistle
                    local PrimaryPart = clone.PrimaryPart

                    Audio.Play(Whistle.Id, PrimaryPart, {
                        Volume = Whistle.Volume,
                        MaxDistance = Whistle.MaxDistance
                    })
                end

                RunService:BindToRenderStep("TrainPrivateMotion", Enum.RenderPriority.Camera.Value, function() -- line: 147
                    -- upvalues: p4 (copy), Train (copy), t8 (copy), draw (copy), Workspace (copy), t1 (copy), t3 (ref)
                    if t3 == t8 then
                        if Train.Parent and p4.Character.Parent and not (Workspace:GetServerTimeNow() > p4.StartedAt + p4.Duration + 10) then
                            draw()
                        else
                            t1.EndRide(t8.Id)
                        end
                    end
                end)

                return clone
            end

            clone:Destroy()
        end
    end

    return nil
end

function t1.Start() -- line: 164
    -- upvalues: RunService (copy), Workspace (copy), TrainRailPath (copy), TrainWheels (copy), Audio (copy), t1 (copy), v1 (ref), t2 (copy), t4 (copy)
    if v1 then
        return
    end

    v1 = true

    local Folder = Instance.new("Folder")

    Folder.Name = "TrainEventVisuals"
    Folder.Parent = Workspace

    local t9 = {}
    local n2 = 0

    local function add(p9) -- line: 174
        -- upvalues: Folder (copy), t9 (copy), TrainRailPath (copy), TrainWheels (copy)
        if not t9[p9] and p9:GetAttribute("TrainVisualSource") == true then
            local RailPartCount = p9:GetAttribute("RailPartCount")

            if RailPartCount then
                local n3 = 0

                for _, descendant in ipairs(p9:GetDescendants()) do
                    if descendant:IsA("BasePart") then
                        n3 += 1
                    end
                end

                if n3 == RailPartCount then
                    local RailPath = p9:FindFirstChild("RailPath")

                    if RailPath and #RailPath:GetChildren() == (p9:GetAttribute("RailNodeCount") or 0) then
                        local Children = RailPath:GetChildren()

                        table.sort(Children, function(p10, p11) -- line: 196
                            return p10.Name < p11.Name
                        end)

                        local t10 = {}

                        for _, v10 in ipairs(Children) do
                            table.insert(t10, v10.Value)
                        end

                        if not (#t10 < 2) then
                            local clone = p9:Clone()

                            clone.Name = p9.Name
                            clone:SetAttribute("TrainVisualSource", nil)

                            local t11 = {}
                            local t12 = {}

                            for _, descendant in ipairs(clone:GetDescendants()) do
                                if descendant:IsA("BasePart") then
                                    descendant.LocalTransparencyModifier = 0
                                    descendant.Anchored = true
                                    descendant.CanCollide = false
                                    descendant.CanTouch = false
                                    descendant.CanQuery = false
                                    table.insert(t11, {
                                        descendant,
                                        descendant.Transparency
                                    })
                                elseif descendant:IsA("Decal") then
                                    table.insert(t11, {
                                        descendant,
                                        descendant.Transparency
                                    })
                                elseif descendant:IsA("Light") then
                                    table.insert(t12, descendant)
                                elseif descendant:IsA("Beam") then
                                    table.insert(t12, descendant)
                                elseif descendant:IsA("ParticleEmitter") then
                                    table.insert(t12, descendant)
                                end
                            end

                            local t15 = {}

                            for _, child in ipairs(clone:GetChildren()) do
                                if child:IsA("Model") and child.PrimaryPart then
                                    table.insert(t15, child)
                                end
                            end

                            table.sort(t15, function(p12, p13) -- line: 231
                                return (p12:GetAttribute("TrainCarIndex") or 0) < (p13:GetAttribute("TrainCarIndex") or 0)
                            end)

                            local t16 = {}

                            for _, descendant in ipairs(p9:GetDescendants()) do
                                if descendant:IsA("BasePart") or descendant:IsA("Decal") or descendant:IsA("Light") or descendant:IsA("Beam") or descendant:IsA("ParticleEmitter") then
                                    table.insert(t16, descendant)
                                end
                            end

                            for _, v11 in ipairs(t11) do
                                v11[2] = v11[1]:GetAttribute("RailAuthoredTransparency") or v11[2]
                            end

                            clone.Parent = Folder
                            t9[p9] = {
                                Clone = clone,
                                Path = TrainRailPath.Prepare(t10),
                                Cars = t15,
                                Wheels = TrainWheels.Bind(t15),
                                Parts = t11,
                                Effects = t12,
                                Originals = t16,
                                Shown = p9:GetAttribute("RailVisible") == true
                            }
                        end
                    end
                end
            end
        end
    end

    RunService:BindToRenderStep("TrainVisualMotion", Enum.RenderPriority.Camera.Value - 1, function() -- line: 258
        -- upvalues: t9 (copy), n2 (ref), add (copy), Workspace (copy), TrainRailPath (copy), TrainWheels (copy), Audio (copy), t2 (copy), t4 (copy)
        local ServerTimeNow = Workspace:GetServerTimeNow()

        if n2 <= ServerTimeNow then
            n2 = ServerTimeNow + 0.5

            local TrainEventRuntime = Workspace:FindFirstChild("TrainEventRuntime")

            if TrainEventRuntime then
                for _, child in ipairs(TrainEventRuntime:GetChildren()) do
                    if child:IsA("Model") then
                        add(child)
                    end
                end
            end
        end

        for v13, v14 in t9 do
            if v13.Parent then
                local v15 = v13:GetAttribute("RailVisible") == true
                local v16 = v15 and not v14.Shown and v13.Name == "GhostTrainHalloween"

                v14.Shown = v15

                local v17 = v15 and t2[v13] == nil

                for _, v18 in ipairs(v14.Originals) do
                    if v18.Parent then
                        if v18:IsA("BasePart") then
                            if v18.LocalTransparencyModifier ~= 1 then
                                v18.LocalTransparencyModifier = 1
                            end
                        elseif v18:IsA("Decal") then
                            if v18.Transparency ~= 1 then
                                v18.Transparency = 1
                            end
                        elseif v18.Enabled then
                            v18.Enabled = false
                        end
                    end
                end

                for _, v19 in ipairs(v14.Parts) do
                    local v20 = if v17 then v19[2] else 1

                    if v19[1].Transparency ~= v20 then
                        v19[1].Transparency = v20
                    end
                end

                for _, v21 in ipairs(v14.Effects) do
                    if v21.Enabled ~= v17 then
                        v21.Enabled = v17
                    end
                end

                local v22 = v13:GetAttribute("RailTarget") or 0

                if v13:GetAttribute("RailMoving") then
                    v22 = TrainRailPath.DistanceAt(v13:GetAttribute("RailStart") or v22, v22, v13:GetAttribute("RailStarted") or ServerTimeNow, v13:GetAttribute("RailDuration") or 0, ServerTimeNow)
                end

                for _, v23 in ipairs(v14.Cars) do
                    v23:PivotTo(TrainRailPath.Frame(v14.Path, v22 - (v23:GetAttribute("TrainCarOffset") or 0)))
                end

                TrainWheels.Update(v14.Wheels, v22)

                if v16 and v14.Cars[1] then
                    local Whistle = t4.Whistle
                    local PrimaryPart = v14.Cars[1].PrimaryPart

                    Audio.Play(Whistle.Id, PrimaryPart, {
                        Volume = Whistle.Volume,
                        MaxDistance = Whistle.MaxDistance
                    })
                end
            else
                v14.Clone:Destroy()
                t9[v13] = nil
            end
        end
    end)
    script.Destroying:Connect(function() -- line: 331
        -- upvalues: Folder (copy), t9 (copy), RunService (copy), t1 (copy)
        t1.EndRide()
        RunService:UnbindFromRenderStep("TrainVisualMotion")

        for _, v24 in t9 do
            v24.Clone:Destroy()

            for _, v25 in ipairs(v24.Originals) do
                if v25:IsA("BasePart") and v25.Parent then
                    v25.LocalTransparencyModifier = 0
                end
            end
        end

        Folder:Destroy()
    end)
end

return t1
