-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Callouts = require(ReplicatedStorage.Shared.Util.PumpkinBossState).Callouts
local t1 = {
    BruteRise = {
        Speaker = "Pumpkin Brute",
        Text = Callouts.SceneBruteRise
    },
    BruteDecay = {
        Speaker = nil,
        Text = Callouts.SceneBruteDecay
    },
    KingEmerge = {
        Speaker = "Pumpkin King",
        Text = Callouts.SceneKingEmerge
    },
    ShieldUp = {
        Speaker = "Pumpkin King",
        Text = Callouts.SceneShieldUp
    },
    ShieldBreak = {
        Speaker = nil,
        Text = Callouts.SceneShieldBreak
    },
    KingDefeat = {
        Speaker = "Pumpkin King",
        Text = Callouts.SceneKingDefeat
    }
}
local LocalPlayer = Players.LocalPlayer
local Cutscenes = script.Parent:FindFirstChild("Cutscenes")
local t2 = {}
local t3 = {}

local function load(p1) -- line: 55
    -- upvalues: Cutscenes (copy), t3 (copy)
    local v1 = t3[p1]

    if v1 ~= false then
        if v1 ~= nil then
            return v1
        end

        local v2 = Cutscenes and Cutscenes:FindFirstChild(p1)

        if v2 ~= nil and v2:IsA("ModuleScript") then
            local _require = require
            local traceback = debug.traceback
            local v3, v4 = xpcall(_require, traceback, v2)

            if v3 and type(v4) == "table" and type(v4.Play) == "function" then
                t3[p1] = v4

                return v4
            end

            warn((("[PumpkinBoss] Cutscene %* failed to load: %*"):format(p1, v4)))
            t3[p1] = false

            return nil
        end

        t3[p1] = false
    end

    return nil
end

local t4 = {
    Slots = table.freeze({
        "AdminIntro",
        "BruteRise",
        "BruteDecay",
        "KingEmerge",
        "ShieldUp",
        "ShieldBreak",
        "KingDefeat",
        "AdminOutro",
        "AdminOutro2"
    })
}

function t4.Play(p2, p3, p4, p5, p6) -- line: 95
    -- upvalues: Workspace (copy), t1 (copy), LocalPlayer (copy), t2 (copy), load (copy), t4 (copy)
    t4.Stop(p2)

    local v6 = math.max(p4 - (Workspace:GetServerTimeNow() - p5), 0)
    local v7 = load(p2)

    if v7 ~= nil then
        local Play = v7.Play
        local traceback = debug.traceback
        local t5 = {
            Name = p2,
            Arena = p3,
            Seconds = p4,
            At = p5,
            Player = LocalPlayer
        }
        local v9, v10 = xpcall(Play, traceback, t5)

        if v9 then
            if type(v10) == "table" and type(v10.Stop) == "function" then
                t2[p2] = v10
            end
        else
            warn((("[PumpkinBoss] Cutscene %* errored: %*"):format(p2, v10)))
        end
    else
        local v8 = t1[p2]

        if v8 and v6 > 0.2 then
            p6(v8.Text, v8.Speaker, (math.min(v6, 3.5)))
        end
    end
end

function t4.Stop(p7) -- line: 131
    -- upvalues: t2 (copy)
    local v11 = t2[p7]

    t2[p7] = nil

    if not v11 then
        return
    end

    local Stop = v11.Stop
    local traceback = debug.traceback
    local v12, v13 = xpcall(Stop, traceback)

    if not v12 then
        warn((("[PumpkinBoss] Cutscene %* failed to stop: %*"):format(p7, v13)))
    end
end

function t4.StopAll() -- line: 142
    -- upvalues: t2 (copy), t4 (copy)
    for v14 in t2 do
        t4.Stop(v14)
    end
end

return t4
