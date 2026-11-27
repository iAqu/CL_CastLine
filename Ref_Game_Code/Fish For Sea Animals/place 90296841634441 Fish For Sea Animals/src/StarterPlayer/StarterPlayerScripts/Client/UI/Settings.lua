-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local GameSettings = require(ReplicatedStorage.Shared.GameSettings)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local LocalPlayer = Players.LocalPlayer
local t2 = {}
local t3 = {}
local t4 = {}
local t1 = {}

function t1.get(p1) -- line: 20
    -- upvalues: GameSettings (copy), LocalPlayer (copy), t2 (copy)
    local v1 = t2[p1]

    if v1 == nil then
        return GameSettings.get(LocalPlayer, p1)
    end

    return v1
end

function t1.onChanged(p2, p3) -- line: 29
    -- upvalues: t1 (copy), t3 (copy)
    t3[p2] = t3[p2] or {}
    table.insert(t3[p2], p3)
    task.spawn(p3, t1.get(p2))
end

local function fire(p4) -- line: 35
    -- upvalues: t1 (copy), t3 (copy), t4 (copy)
    t4[p4] = t1.get(p4)

    for _, v3 in t3[p4] or {} do
        task.spawn(v3, t4[p4])
    end
end

function t1.set(p5, p6) -- line: 42
    -- upvalues: GameSettings (copy), Remotes (copy), t1 (copy), t2 (copy), fire (copy)
    if not GameSettings.ByKey[p5] or t1.get(p5) == p6 then
        return
    end

    t2[p5] = p6
    Remotes.SetSetting:FireServer(p5, p6)
    fire(p5)
end

function t1.group(p7) -- line: 52
    -- upvalues: SoundService (copy)
    local v4 = SoundService:FindFirstChild(p7)

    if not v4 then
        v4 = Instance.new("SoundGroup")
        v4.Name = p7
        v4.Volume = 1
        v4.Parent = SoundService
    end

    return v4
end

function t1.init() -- line: 63
    -- upvalues: GameSettings (copy), LocalPlayer (copy), t1 (copy), t2 (copy), t4 (copy), fire (copy)
    for _, v5 in GameSettings.List do
        t4[v5.Key] = t1.get(v5.Key)
        LocalPlayer:GetAttributeChangedSignal(GameSettings.attribute(v5.Key)):Connect(function() -- line: 69
            -- upvalues: v5 (copy), t1 (copy), t2 (copy), t4 (copy), fire (copy)
            t2[v5.Key] = nil

            if t1.get(v5.Key) ~= t4[v5.Key] then
                fire(v5.Key)
            end
        end)
    end

    for _, v6 in { "Music", "Sfx" } do
        t1.onChanged(v6, function(p8) -- line: 77
            -- upvalues: v6 (copy), t1 (copy)
            t1.group(v6).Volume = p8 and 1 or 0
        end)
    end
end

return t1
