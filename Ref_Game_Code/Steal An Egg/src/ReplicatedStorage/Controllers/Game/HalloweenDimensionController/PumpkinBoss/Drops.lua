-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local HalloweenTokens = require(ReplicatedStorage.Data.Currency.Configs.HalloweenTokens)
local Notifications = require(ReplicatedStorage.Client.Notifications)
local ScramblePickupMotion = require(ReplicatedStorage.Shared.Util.ScramblePickupMotion)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local Kit = require(script.Parent.Kit)
local DisplayName = HalloweenTokens.DisplayName
local LocalPlayer = Players.LocalPlayer

local function now() -- line: 54
    -- upvalues: Workspace (copy)
    return Workspace:GetServerTimeNow()
end

local function rootOf(p1) -- line: 58
    local v1 = p1 and p1.Character
    local HumanoidRootPart = v1 and v1:FindFirstChild("HumanoidRootPart")

    return if HumanoidRootPart and HumanoidRootPart:IsA("BasePart") then HumanoidRootPart else nil
end

local function build(p2) -- line: 64
    -- upvalues: Kit (copy)
    local v2 = Kit.Part({
        Name = "PumpkinPickup",
        Size = Vector3.new(2.16, 1.8, 2.16),
        Shape = Enum.PartType.Ball,
        Material = Enum.Material.SmoothPlastic,
        Color = Kit.Orange
    })
    local v3 = Kit.Part({
        Name = "Stem",
        Size = Vector3.new(0.3, 0.6, 0.3),
        Material = Enum.Material.SmoothPlastic,
        Color = Color3.fromRGB(70, 130, 30),
        CFrame = v2.CFrame * CFrame.new(0, 1.1, 0)
    })
    local WeldConstraint = Instance.new("WeldConstraint")

    WeldConstraint.Part0 = v2
    WeldConstraint.Part1 = v3
    WeldConstraint.Parent = v3
    v3.Anchored = false
    v3.Parent = v2
    v2.Parent = p2

    return v2
end

local function valid(p3) -- line: 89
    if type(p3) ~= "table"
        or type(p3.Id) ~= "string"
        or type(p3.OwnerUserId) ~= "number"
        or type(p3.Amount) ~= "number"
        or typeof(p3.Origin) ~= "Vector3"
        or typeof(p3.Position) ~= "Vector3"
        or type(p3.CreatedAt) ~= "number"
        or type(p3.CollectAfter) ~= "number"
        or type(p3.ExpiresAt) ~= "number" then
        return false
    end

    return type(p3.Radius) == "number"
end

local t1 = {}

t1.__index = t1

function t1.new(p4) -- line: 105
    -- upvalues: RunService (copy), Remotes (copy), Kit (copy), t1 (copy)
    local Folder = Instance.new("Folder")

    Folder.Name = "PumpkinPickups"
    Folder.Parent = Kit.Debris()
    p4:Add(Folder)

    local v4 = setmetatable({
        NextSend = 0,
        Folder = Folder,
        Drops = {},
        Pending = {}
    }, t1)

    p4:Connect(Remotes.PumpkinBoss.Drops.OnClientEvent, function(p5) -- line: 118
        -- upvalues: v4 (copy)
        v4:Add(p5)
    end)
    p4:Connect(Remotes.PumpkinBoss.RemoveDrops.OnClientEvent, function(p6) -- line: 121
        -- upvalues: v4 (copy)
        v4:Remove(p6)
    end)
    p4:Connect(RunService.RenderStepped, function() -- line: 124
        -- upvalues: v4 (copy)
        v4:Step()
    end)

    return v4
end

function t1.Add(p7, p8) -- line: 131
    -- upvalues: build (copy), valid (copy)
    if type(p8) ~= "table" then
        return
    end

    for _, v5 in p8 do
        if valid(v5) and p7.Drops[v5.Id] == nil then
            local t3 = {
                RequestedAt = nil,
                Id = v5.Id,
                OwnerUserId = v5.OwnerUserId,
                Amount = v5.Amount,
                Origin = v5.Origin,
                Position = v5.Position,
                CreatedAt = v5.CreatedAt,
                MagnetAt = if type(v5.MagnetAt) == "number" then v5.MagnetAt else nil,
                CollectAfter = v5.CollectAfter,
                ExpiresAt = v5.ExpiresAt,
                Radius = v5.Radius,
                Part = build(p7.Folder)
            }

            t3.Part.CFrame = CFrame.new(t3.Origin)
            p7.Drops[t3.Id] = t3
        end
    end
end

function t1.Remove(p9, p10) -- line: 158
    -- upvalues: Kit (copy), LocalPlayer (copy)
    if type(p10) ~= "table" then
        return
    end

    for _, v6 in p10 do
        local v7 = if type(v6) == "string" then p9.Drops[v6] else nil

        if v7 then
            if v7.OwnerUserId == LocalPlayer.UserId and v7.RequestedAt then
                Kit.Sound("Pickup", nil, 0.5, 1 + math.random() * 0.15)
            end

            v7.Part:Destroy()
            p9.Drops[v6] = nil
        end
    end
end

function t1.Request(p11, p12, p13) -- line: 175
    if p12.RequestedAt and p13 - p12.RequestedAt < 2 then
        return
    end

    p12.RequestedAt = p13
    table.insert(p11.Pending, p12.Id)
end

function t1.Flush(p14, p15) -- line: 183
    -- upvalues: Remotes (copy)
    if #p14.Pending == 0 or p15 < p14.NextSend then
        return
    end

    p14.NextSend = p15 + 0.2

    local t4 = {}

    while #t4 < 8 and #p14.Pending > 0 do
        table.insert(t4, table.remove(p14.Pending, 1))
    end

    Remotes.PumpkinBoss.Collect:FireServer(t4)
end

function t1.Step(p16) -- line: 196
    -- upvalues: Players (copy), Workspace (copy), ScramblePickupMotion (copy), LocalPlayer (copy)
    local ServerTimeNow = Workspace:GetServerTimeNow()
    local v8 = LocalPlayer and LocalPlayer.Character
    local HumanoidRootPart = v8 and v8:FindFirstChild("HumanoidRootPart")

    if not (HumanoidRootPart and HumanoidRootPart:IsA("BasePart")) then
        HumanoidRootPart = nil
    end

    local v9 = CFrame.Angles(0, os.clock() * 2.5, 0)

    for v10, v11 in p16.Drops do
        if v11.ExpiresAt < ServerTimeNow then
            v11.Part:Destroy()
            p16.Drops[v10] = nil
        else
            local v12 = v11.OwnerUserId == LocalPlayer.UserId
            local v13 = ServerTimeNow - v11.CreatedAt
            local v14 = ScramblePickupMotion.GroundPosition(v11.Origin, v11.Position, v13)
            local MagnetAt = v11.MagnetAt

            if MagnetAt and MagnetAt <= ServerTimeNow then
                local PlayerByUserId = Players:GetPlayerByUserId(v11.OwnerUserId)
                local v15 = PlayerByUserId and PlayerByUserId.Character
                local HumanoidRootPart = v15 and v15:FindFirstChild("HumanoidRootPart")

                if not (HumanoidRootPart and HumanoidRootPart:IsA("BasePart")) then
                    HumanoidRootPart = nil
                end

                if HumanoidRootPart then
                    local v16 = (ServerTimeNow - MagnetAt) / ScramblePickupMotion.MagnetSeconds

                    v14 = ScramblePickupMotion.MagnetPosition(v11.Position, HumanoidRootPart.Position, v16)

                    if v16 >= 1 then
                        v11.Part.Transparency = 1
                    end
                end
            end

            local v17 = HumanoidRootPart ~= nil and (v14 - HumanoidRootPart.Position).Magnitude > 300

            v11.Part.LocalTransparencyModifier = v17 and 1 or 0
            v11.Part.CFrame = CFrame.new(v14) * v9

            if v12 and HumanoidRootPart and v11.CollectAfter <= ServerTimeNow and (MagnetAt or (HumanoidRootPart.Position - v11.Position).Magnitude <= v11.Radius) then
                p16:Request(v11, ServerTimeNow)
            end
        end
    end

    p16:Flush(ServerTimeNow)
end

function t1.ShowCurrency(p17) -- line: 238
    -- upvalues: Notifications (copy), Kit (copy), DisplayName (copy)
    Notifications.Toast.Show({
        Lane = "Feed",
        Seconds = 1.6,
        Text = ("+%* %*"):format(p17, DisplayName)
    })
    Kit.Sound("Pickup", nil, 0.6, 1.1)
end

return t1
