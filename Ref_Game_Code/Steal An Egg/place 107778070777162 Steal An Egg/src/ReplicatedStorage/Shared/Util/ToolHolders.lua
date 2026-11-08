-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Player = require(ReplicatedStorage.Shared.Player)
local t1 = {}

function t1.FromTool(p1) -- line: 20
    -- upvalues: Players (copy)
    assert(typeof(p1) == "Instance" and p1:IsA("Tool"), "FromTool expects a Tool")

    local Parent = p1.Parent

    if Parent ~= nil then
        if Parent:IsA("Player") then
            return Parent
        end

        if Parent:IsA("Model") then
            return (Players:GetPlayerFromCharacter(Parent))
        end
    end

    return nil
end

local function riderRise(p2) -- line: 32
    local PetMountSession = p2:FindFirstChild("PetMountSession")
    local HeightIncrease = PetMountSession and PetMountSession:GetAttribute("HeightIncrease")

    if typeof(HeightIncrease) == "number" and HeightIncrease > 0 then
        return HeightIncrease
    end

    return 0
end

local function reachDistance(p3, p4, p5) -- line: 38
    local Magnitude = (p4 - p3).Magnitude

    if p5 <= 0 then
        return Magnitude
    end

    return (math.min(Magnitude, (p4 - Vector3.new(0, p5, 0) - p3).Magnitude))
end

local function survey(p6, p7, p8) -- line: 46
    -- upvalues: Players (copy), Player (copy)
    local t2 = {}

    for _, player in Players:GetPlayers() do
        if player ~= p6 then
            local v2 = Player.FindRootPart(player)

            if v2 ~= nil then
                local v3 = v2.Position - p7
                local v4 = Player.FindCharacter(player)
                local Position = v2.Position
                local v5

                if v4 then
                    local PetMountSession = v4:FindFirstChild("PetMountSession")

                    v5 = PetMountSession and PetMountSession:GetAttribute("HeightIncrease")

                    if typeof(v5) ~= "number" or not (v5 > 0) then
                        v5 = 0
                    end
                else
                    v5 = 0
                end

                local Magnitude = (Position - p7).Magnitude

                if not (v5 <= 0) then
                    Magnitude = math.min(Magnitude, (Position - Vector3.new(0, v5, 0) - p7).Magnitude)
                end

                if Magnitude <= p8 then
                    table.insert(t2, {
                        player = player,
                        delta = v3,
                        distance = Magnitude
                    })
                end
            end
        end
    end

    table.sort(t2, function(p9, p10) -- line: 63
        return p9.distance < p10.distance
    end)

    return t2
end

function t1.NearestWithin(p11, p12, p13) -- line: 71
    -- upvalues: Player (copy), survey (copy)
    assert(typeof(p11) == "Instance" and p11:IsA("Player"), "NearestWithin expects a Player")
    assert(type(p12) == "number", "NearestWithin expects a numeric range")

    local v8 = Player.FindRootPart(p11)

    if v8 == nil then
        return nil, (Vector3.new(1, 0, 0))
    end

    local v9 = survey(p11, v8.Position, p12)
    local v10 = if p13 == nil then 1 else math.max(0, (math.floor(p13)))

    if v10 > 1 then
        return table.move(v9, 1, math.min(v10, #v9), 1, {})
    end

    local v13 = v9[1]

    if v13 == nil then
        return nil, (Vector3.new(1, 0, 0))
    end

    return v13.player, v13.delta
end

return table.freeze(t1)
