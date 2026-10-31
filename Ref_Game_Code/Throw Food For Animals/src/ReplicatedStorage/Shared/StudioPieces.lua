-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local v1 = game:GetService("RunService"):IsServer()
local t1 = {
    Key = function(p1, p2) -- Key | line: 38
        return p2 and p1 .. "|" .. p2 or p1
    end
}

function t1.WantedKey(p3) -- line: 43
    -- upvalues: t1 (copy)
    return t1.Key(p3:GetAttribute("AnimalName") or p3.Name, p3:GetAttribute("Mutation"))
end

function t1.Count(p4) -- line: 49
    local PrimaryPart = p4.PrimaryPart
    local n1 = 0
    local n2 = 0

    for _, descendant in ipairs(p4:GetDescendants()) do
        if descendant:IsA("BasePart") then
            if descendant ~= PrimaryPart and descendant.Parent == p4 and descendant.Name ~= "Bounds" then
                n1 += 1
            end
        elseif descendant:IsA("JointInstance") or descendant:IsA("WeldConstraint") then
            n2 += 1
        elseif (descendant:IsA("Attachment") or descendant:IsA("ParticleEmitter")) and (not PrimaryPart or not descendant:IsDescendantOf(PrimaryPart)) then
            n2 += 1
        end
    end

    return n1, n2
end

function t1.IsComplete(p5) -- line: 65
    -- upvalues: t1 (copy)
    local Pieces = p5:GetAttribute("Pieces")

    if not Pieces then
        return false
    end

    local v2, v3 = t1.Count(p5)

    if Pieces <= v2 then
        return (p5:GetAttribute("Links") or 0) <= v3
    end

    return false
end

local function source(p6) -- line: 72
    -- upvalues: Players (copy), v1 (copy), t1 (copy)
    if v1 then
        local StudioAnimalPieces = game:GetService("ServerStorage"):FindFirstChild("StudioAnimalPieces")

        return StudioAnimalPieces and StudioAnimalPieces:FindFirstChild(p6)
    end

    local v4 = Players.LocalPlayer and Players.LocalPlayer:FindFirstChild("PlayerGui")
    local StudioAnimals = v4 and v4:FindFirstChild("StudioAnimals")
    local v5 = StudioAnimals and StudioAnimals:FindFirstChild(p6)

    return if v5 and t1.IsComplete(v5) then v5 else nil
end

local t2 = {}

function t1.Request(p7) -- line: 85
    -- upvalues: Players (copy), ReplicatedStorage (copy), v1 (copy), t2 (copy)
    local elapsed = os.clock()

    if t2[p7] and elapsed - t2[p7] < 8 then
        return
    end

    t2[p7] = elapsed
    task.spawn(function() -- line: 89
        -- upvalues: p7 (copy), Players (copy), ReplicatedStorage (copy), v1 (copy)
        if not v1 then
            local v6 = Players.LocalPlayer and Players.LocalPlayer:FindFirstChild("PlayerGui")
            local StudioAnimals = v6 and v6:FindFirstChild("StudioAnimals")
            local Request = StudioAnimals and StudioAnimals:FindFirstChild("Request")

            if Request and Request:IsA("RemoteEvent") then
                Request:FireServer(p7)

                return
            end
        end

        local v7 = ReplicatedStorage:WaitForChild("StudioMutations", 30)

        if v7 then
            if v1 then
                v7:WaitForChild("RequestServer"):Fire(p7)
            else
                v7:WaitForChild("Request"):FireServer(p7)
            end
        end
    end)
end

local function removePieces(p8) -- line: 113
    local PrimaryPart = p8.PrimaryPart
    local Bounds = p8:FindFirstChild("Bounds")

    for _, child in ipairs(PrimaryPart:GetChildren()) do
        if (child:IsA("JointInstance") or child:IsA("WeldConstraint")) and child.Part1 ~= PrimaryPart and child.Part1 ~= Bounds or child:IsA("Attachment") and child.Name:sub(1, 8) == "Mutation" then
            child:Destroy()
        end
    end

    for _, child in ipairs(p8:GetChildren()) do
        if child:IsA("BasePart") and child ~= PrimaryPart and child ~= Bounds then
            child:Destroy()
        end
    end
end

local function fill(p9, p10, p11, p12) -- line: 130
    -- upvalues: ReplicatedStorage (copy), CollectionService (copy), t1 (copy), removePieces (copy)
    local PrimaryPart = p9.PrimaryPart

    if not (PrimaryPart and p10.PrimaryPart) then
        return false
    end

    local Bounds = p9:FindFirstChild("Bounds")
    local v8

    for _, child in ipairs(p9:GetChildren()) do
        if child:IsA("BasePart") and child ~= PrimaryPart and child ~= Bounds then
            v8 = child
            break
        end
    end

    local v9 = false

    if v8 then
    elseif Bounds then
        v8 = Bounds
        v9 = true
    end

    local t3

    if v8 then
        t3 = {
            Anchored = v8.Anchored,
            Massless = v8.Massless,
            CanCollide = v8.CanCollide
        }
        t3.CanQuery = if v9 then not p9:GetAttribute("Carried") or not v9 else v8.CanQuery
        t3.CanTouch = v8.CanTouch
        t3.CastShadow = v8.CastShadow
        t3.LTM = v8.LocalTransparencyModifier
    end

    local clone = p10:Clone()

    clone:ScaleTo(p9:GetScale())
    clone:PivotTo(PrimaryPart.CFrame * clone.PrimaryPart.CFrame:Inverse() * clone:GetPivot())

    local PrimaryPart2 = clone.PrimaryPart

    removePieces(p9)

    for _, child in ipairs(PrimaryPart2:GetChildren()) do
        if child:IsA("JointInstance") or child:IsA("WeldConstraint") then
            if child.Part0 == PrimaryPart2 then
                child.Part0 = PrimaryPart
            end

            if child.Part1 == PrimaryPart2 then
                child.Part1 = PrimaryPart
            end

            child.Parent = PrimaryPart
        elseif child:IsA("Attachment") then
            local WorldCFrame = child.WorldCFrame

            child.Parent = PrimaryPart
            child.WorldCFrame = WorldCFrame
        end
    end

    for _, child in ipairs(clone:GetChildren()) do
        if child:IsA("BasePart") and child ~= PrimaryPart2 and child.Name ~= "Bounds" then
            if t3 then
                child.Anchored = t3.Anchored
                child.Massless = t3.Massless
                child.CanCollide = t3.CanCollide
                child.CanQuery = t3.CanQuery
                child.CanTouch = t3.CanTouch
                child.LocalTransparencyModifier = t3.LTM

                if child.CastShadow then
                    child.CastShadow = t3.CastShadow
                end
            else
                child.Anchored = false
            end

            child.Parent = p9
        end
    end

    clone:Destroy()

    local MutationHidden = p9:GetAttribute("MutationHidden")

    for _, descendant in ipairs(p9:GetDescendants()) do
        if descendant:IsA("ParticleEmitter") then
            if p12 and p12.Particles == false or p9:GetAttribute("NoParticles") then
                descendant:Destroy()
            else
                descendant:SetAttribute("MutationFX", true)
                descendant:SetAttribute("RestEnabled", descendant.Enabled)

                if MutationHidden then
                    descendant.Enabled = false
                end
            end
        end
    end

    local _, v10 = string.match(p11 or "", "^(.-)|(.+)$")

    p9:SetAttribute("MutationLook", v10)

    if v10 == "Rainbow" then
        CollectionService:AddTag(p9, "RainbowAnimal")
    else
        CollectionService:RemoveTag(p9, "RainbowAnimal")
    end

    if p9:GetAttribute("Silhouette") then
        for _, descendant in ipairs(p9:GetDescendants()) do
            if descendant:IsA("BasePart") then
                if descendant:IsA("PartOperation") then
                    descendant.UsePartColor = true
                end

                descendant.Color = Color3.fromRGB(8, 8, 10)
                descendant.Material = Enum.Material.SmoothPlastic
            elseif descendant:IsA("ParticleEmitter") then
                descendant:Destroy()
            end
        end
    end

    if p9:GetAttribute("Carried") then
        require(ReplicatedStorage.Shared.AnimalUtil).UseCarriedStuds(p9)
    end

    local v11, v12 = t1.Count(p9)

    p9:SetAttribute("Pieces", v11)
    p9:SetAttribute("Links", v12)
    p9:SetAttribute("Look", p11)

    return true
end

local function clear(p13) -- line: 230
    -- upvalues: CollectionService (copy), removePieces (copy)
    if p13.PrimaryPart then
        removePieces(p13)
        p13:SetAttribute("MutationLook", nil)
        CollectionService:RemoveTag(p13, "RainbowAnimal")
        p13:SetAttribute("Look", nil)
        p13:SetAttribute("Pieces", nil)
        p13:SetAttribute("Links", nil)
    end
end

local self = setmetatable({}, {
    __mode = "k"
})

function t1.Sync(p14, p15) -- line: 242
    -- upvalues: Players (copy), ReplicatedStorage (copy), v1 (copy), t1 (copy), source (copy), t2 (copy), fill (copy), clear (copy), self (copy)
    if p15 and p15.Particles == false then
        p14:SetAttribute("NoParticles", true)
    end

    local v14 = t1.WantedKey(p14)

    if p14:GetAttribute("Look") == v14 then
        return true
    end

    local v15 = source(v14)

    if v15 then
        return (fill(p14, v15, v14, p15))
    end

    if p14:GetAttribute("Look") ~= nil and p14.Parent == nil then
        clear(p14)
    end

    local elapsed = os.clock()

    if not (t2[v14] and elapsed - t2[v14] < 8) then
        t2[v14] = elapsed
        task.spawn(function() -- line: 89
            -- upvalues: v14 (copy), Players (copy), ReplicatedStorage (copy), v1 (copy)
            if not v1 then
                local v16 = Players.LocalPlayer and Players.LocalPlayer:FindFirstChild("PlayerGui")
                local StudioAnimals = v16 and v16:FindFirstChild("StudioAnimals")
                local Request = StudioAnimals and StudioAnimals:FindFirstChild("Request")

                if Request and Request:IsA("RemoteEvent") then
                    Request:FireServer(v14)

                    return
                end
            end

            local v17 = ReplicatedStorage:WaitForChild("StudioMutations", 30)

            if v17 then
                if v1 then
                    v17:WaitForChild("RequestServer"):Fire(v14)
                else
                    v17:WaitForChild("Request"):FireServer(v14)
                end
            end
        end)
    end

    local v18 = self[p14]

    if v18 then
        v18.Options = p15 or v18.Options
    else
        local t7 = {
            Options = p15
        }

        self[p14] = t7
        task.spawn(function() -- line: 260
            -- upvalues: p14 (copy), t7 (copy), Players (copy), ReplicatedStorage (copy), v1 (copy), t1 (copy), source (copy), t2 (copy), fill (copy), self (copy)
            local v19 = false
            local connection = p14.Destroying:Connect(function() -- line: 262
                -- upvalues: v19 (ref)
                v19 = true
            end)
            local elapsed = os.clock()
            local v20 = if v1 then 150 else 90
            local v21 = p14.Parent ~= nil
            local v22 = false

            while not v19 do
                local v23

                if p14.Parent ~= nil then
                    v23 = true
                elseif v21 then
                    break
                else
                    v23 = v21
                end

                local v24 = t1.WantedKey(p14)

                if p14:GetAttribute("Look") == v24 then
                    break
                end

                local v25 = source(v24)

                if v25 then
                    fill(p14, v25, v24, t7.Options)
                    break
                end

                local elapsed2 = os.clock()

                if not (t2[v24] and elapsed2 - t2[v24] < 8) then
                    t2[v24] = elapsed2
                    task.spawn(function() -- line: 89
                        -- upvalues: v24 (copy), Players (copy), ReplicatedStorage (copy), v1 (copy)
                        if not v1 then
                            local v26 = Players.LocalPlayer and Players.LocalPlayer:FindFirstChild("PlayerGui")
                            local StudioAnimals = v26 and v26:FindFirstChild("StudioAnimals")
                            local Request = StudioAnimals and StudioAnimals:FindFirstChild("Request")

                            if Request and Request:IsA("RemoteEvent") then
                                Request:FireServer(v24)

                                return
                            end
                        end

                        local v27 = ReplicatedStorage:WaitForChild("StudioMutations", 30)

                        if v27 then
                            if v1 then
                                v27:WaitForChild("RequestServer"):Fire(v24)
                            else
                                v27:WaitForChild("Request"):FireServer(v24)
                            end
                        end
                    end)
                end

                if v20 < os.clock() - elapsed then
                    local v28 = p14:GetAttribute("AnimalName") or p14.Name

                    if v22 or v24 == v28 then
                        break
                    end

                    local v29 = source(v28)

                    if v29 then
                        fill(p14, v29, v28, t7.Options)
                        break
                    end

                    local elapsed2 = os.clock()

                    if not (t2[v28] and elapsed2 - t2[v28] < 8) then
                        t2[v28] = elapsed2
                        task.spawn(function() -- line: 89
                            -- upvalues: v28 (copy), Players (copy), ReplicatedStorage (copy), v1 (copy)
                            if not v1 then
                                local v30 = Players.LocalPlayer and Players.LocalPlayer:FindFirstChild("PlayerGui")
                                local StudioAnimals = v30 and v30:FindFirstChild("StudioAnimals")
                                local Request = StudioAnimals and StudioAnimals:FindFirstChild("Request")

                                if Request and Request:IsA("RemoteEvent") then
                                    Request:FireServer(v28)

                                    return
                                end
                            end

                            local v31 = ReplicatedStorage:WaitForChild("StudioMutations", 30)

                            if v31 then
                                if v1 then
                                    v31:WaitForChild("RequestServer"):Fire(v28)
                                else
                                    v31:WaitForChild("Request"):FireServer(v28)
                                end
                            end
                        end)
                    end

                    elapsed = os.clock() - v20 + 30
                    v22 = true
                end

                v21 = v23
                task.wait(0.15)
            end

            connection:Disconnect()

            if self[p14] == t7 then
                self[p14] = nil
            end
        end)
    end

    return false
end

function t1.IsPending(p16) -- line: 299
    -- upvalues: self (copy)
    return self[p16] ~= nil
end

return t1
