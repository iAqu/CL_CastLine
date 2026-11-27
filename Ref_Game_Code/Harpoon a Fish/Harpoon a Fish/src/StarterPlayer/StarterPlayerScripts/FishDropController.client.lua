-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local ContentProvider = game:GetService("ContentProvider")
local Modules = ReplicatedStorage:WaitForChild("Modules")
local FishDisplay = require(Modules:WaitForChild("FishDisplay"))
local RarityDisplay = require(Modules:WaitForChild("RarityDisplay"))
local Toast = require(Modules:WaitForChild("Toast"))
local Zones = require(Modules:WaitForChild("Zones"))
local Loc = require(Modules:WaitForChild("Loc"))
local t1 = {
    Legendary = {
        id = "rbxassetid://116393804286896",
        volume = 0.5
    },
    Secret = {
        id = "rbxassetid://107995736347803",
        volume = 0.5
    },
    Celestial = {
        id = "rbxassetid://113424989079552",
        volume = 0.5
    },
    Apex = {
        id = "rbxassetid://140736832198483",
        volume = 0.5
    },
    Exotic = {
        id = "rbxassetid://102667229507403",
        volume = 0.6
    },
    Mythic = {
        id = "rbxassetid://124296558925921",
        volume = 1
    }
}
local t2 = {}

for v1, v2 in pairs(t1) do
    local Sound = Instance.new("Sound")

    Sound.Name = "FishDrop_" .. v1
    Sound.SoundId = v2.id
    Sound.Volume = v2.volume
    t2[v1] = Sound
end

task.spawn(function() -- line: 50
    -- upvalues: ContentProvider (copy), t2 (copy)
    local t3 = {}

    for _, v3 in pairs(t2) do
        t3[#t3 + 1] = v3
    end

    ContentProvider:PreloadAsync(t3)
end)

local _ = {
    VOLUME = 0.35,
    LINES = 3
}
local t4 = {}

local function playSound(p1, p2) -- line: 60
    -- upvalues: SoundService (copy), t2 (copy)
    local v4 = t2[p1]

    if not v4 then
        return
    end

    local clone = v4:Clone()

    clone.Volume *= p2 or 1
    clone.Parent = SoundService
    clone.Ended:Once(function() -- line: 66
        -- upvalues: clone (copy)
        clone:Destroy()
    end)
    clone:Play()
end

ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("FishDrop").OnClientEvent:Connect(function(p3, p4, p5) -- line: 72
    -- upvalues: FishDisplay (copy), RarityDisplay (copy), Toast (copy), Zones (copy), Loc (copy), t4 (copy), playSound (copy)
    local v5 = type(p4) == "number" and math.max(0, p4 - workspace:GetServerTimeNow()) or 0

    for v7, v8 in ipairs(p3) do
        local v9 = FishDisplay[v8.species]
        local v10 = v9 and RarityDisplay[v9.shown or v9.rarity]
        local display = if v9 then v9.display or v8.species else v8.species
        local v11 = v10 and v10.display or ""

        task.delay(v5 + (if p5 then 0 else (v7 - 1) * 0.15), function() -- line: 79
            -- upvalues: p5 (copy), v8 (copy), v9 (copy), display (copy), v7 (copy), v10 (copy), v11 (copy), Toast (copy), Zones (copy), Loc (copy), t4 (copy), playSound (copy)
            if game:GetService("Players").LocalPlayer:GetAttribute("TitanRiding") or game:GetService("Players").LocalPlayer:GetAttribute("TurkeyRun") ~= nil then
                return
            end

            if p5 then
                if v7 == 1 then
                    playSound(v9 and v9.rarity, 0.35)
                end
            else
                playSound(v9 and v9.rarity)
            end

            local v14 = v11 == "" and Loc.T(display) or Loc.F("fish.with_rarity", "{rarity} {fish}", {
                rarity = Loc.T(v11),
                fish = Loc.T(display)
            })
            local v15 = Zones.NAMES[v8.zone]
            local v16 = if v15 then Loc.T(Zones.NAMES[v8.zone]) else nil

            if not v15 or not v16 then
                v16 = Loc.F("zone.n", "Zone {n}", {
                    n = tostring(v8.zone)
                })
            end

            local v17 = v11:match("^[AEIOUaeiou]") and Loc.F("drop.spawned_an", "An {what} spawned in {zone}!", {
                what = v14,
                zone = v16
            }) or Loc.F("drop.spawned_a", "A {what} spawned in {zone}!", {
                what = v14,
                zone = v16
            })
            local v18 = Toast.ShowCenter(v17, v10 and v10.color, v8.zone)

            if p5 and v18 then
                table.insert(t4, v18)

                while #t4 > 3 do
                    local v19 = table.remove(t4, 1)

                    if v19.Parent then
                        v19:Destroy()
                    end
                end
            end
        end)
    end
end)
