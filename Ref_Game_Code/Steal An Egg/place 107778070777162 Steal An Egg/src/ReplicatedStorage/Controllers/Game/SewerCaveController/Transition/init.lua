-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local CollectionService = game:GetService("CollectionService")
local ContentProvider = game:GetService("ContentProvider")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Drain = require(script.Drain)
local Flush = require(script.Flush)
local Transition = require(script.Parent.Parent.HalloweenDimensionController.Transition)
local SewerCave = require(ReplicatedStorage.Shared.Util.SewerCave)
local Stage = require(script.Stage)
local LocalPlayer = Players.LocalPlayer
local v1 = false
local t1 = {}

local function whirlpoolDistance() -- line: 37
    -- upvalues: CollectionService (copy), Workspace (copy), SewerCave (copy), LocalPlayer (copy)
    local Character = LocalPlayer.Character
    local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

    if HumanoidRootPart == nil or not HumanoidRootPart:IsA("BasePart") then
        return 1e999
    end

    local n1 = 1e999

    for _, v2 in CollectionService:GetTagged(SewerCave.WhirlpoolTag) do
        if v2:IsA("Model") and v2:IsDescendantOf(Workspace) then
            n1 = math.min(n1, (v2:GetPivot().Position - HumanoidRootPart.Position).Magnitude)
        end
    end

    return n1
end

local function watch() -- line: 52
    -- upvalues: Drain (copy), whirlpoolDistance (copy)
    local v3

    while true do
        task.wait(0.5)

        local v4 = whirlpoolDistance()

        if v4 < 80 then
            v3 = nil
            Drain.Prewarm()
        elseif v4 > 140 then
            v3 = v3 or os.clock()

            if os.clock() - v3 > 20 then
                Drain.Release()
            end
        end
    end
end

local function preload() -- line: 70
    -- upvalues: ContentProvider (copy)
    local Assets = script:FindFirstChild("Assets")

    if Assets ~= nil then
        local function v6() -- line: 73
            -- upvalues: Assets (copy), ContentProvider (copy)
            ContentProvider:PreloadAsync({
                Assets
            })
        end

        pcall(v6)
    end
end

function t1.Start() -- line: 83
    -- upvalues: Drain (copy), v1 (ref), watch (copy), preload (copy)
    if v1 then
        return
    end

    v1 = true
    Drain.Warm()
    task.spawn(preload)
    task.spawn(watch)
end

function t1.Enter(p1) -- line: 93
    -- upvalues: Drain (copy), t1 (copy)
    t1.Start()

    return Drain.Run(p1)
end

function t1.Exit(p2) -- line: 98
    -- upvalues: Flush (copy), t1 (copy)
    t1.Start()

    return Flush.Run(p2)
end

function t1.Abort() -- line: 103
    -- upvalues: Transition (copy), Stage (copy)
    local v7 = Stage.Active()

    if v7 ~= nil then
        Stage.Bail(v7)
    else
        Transition.Reveal()
    end
end

function t1.Cover() -- line: 112
    -- upvalues: Transition (copy), Stage (copy)
    Transition.Cover(Stage.Palette, Stage.CoverTimeout)
end

function t1.Reveal() -- line: 116
    -- upvalues: Transition (copy)
    Transition.Reveal()
end

task.defer(t1.Start)

return table.freeze(t1)
