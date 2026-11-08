-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local elapsed = os.clock()

if not game:IsLoaded() then
    game.Loaded:Wait()
end

local OnboardingTiming = require(ReplicatedStorage.Shared.Util.OnboardingTiming)

OnboardingTiming.Mark("GameLoaded", nil, os.clock() - elapsed)
task.spawn(function() -- line: 16
    require(script.Parent:WaitForChild("PlayerModule"))
end)
require(ReplicatedStorage.Shared.Flags.GameFlags)

local Log = require(ReplicatedStorage.Packages.Log)
local Controllers = ReplicatedStorage:WaitForChild("Controllers")
local t1 = {
    Controllers:WaitForChild("GUI"),
    Controllers:WaitForChild("Game")
}
local t2 = {
    ReplicatedStorage.Client.PlatformController,
    ReplicatedStorage.Client.HiddenUIHandler,
    ReplicatedStorage.Client.ForbiddenIslandController,
    ReplicatedStorage.Client.DecorationScale,
    ReplicatedStorage.Client.ClientObservers,
    ReplicatedStorage.Client.MusicDirector,
    ReplicatedStorage.Client.Notifications,
    ReplicatedStorage.Client.PlotState,
    ReplicatedStorage.Client.FuseMachineMotion,
    ReplicatedStorage.Client.ShrineFusionController,
    ReplicatedStorage.Client.SystemChat,
    ReplicatedStorage.Client.ChatDecorations,
    ReplicatedStorage.Shared.Save
}
local v1 = Log.new()
local LocalPlayer = Players.LocalPlayer

local function collectControllers(p1, p2) -- line: 55
    -- upvalues: collectControllers (copy)
    for _, child in p1:GetChildren() do
        if child:IsA("Folder") then
            collectControllers(child, p2)
        elseif child:IsA("ModuleScript") and not child:GetAttribute("SkipAutoload") then
            table.insert(p2, child)
        end
    end

    return p2
end

local function byFullName(p3, p4) -- line: 66
    return p3:GetFullName() < p4:GetFullName()
end

local function runStage(p5, p6, p7) -- line: 70
    -- upvalues: OnboardingTiming (copy), v1 (copy)
    local elapsed = os.clock()
    local ok, result = pcall(p7)

    if ok and (p5.Name == "GuardAreasController" or p5.Name == "AreaEggsController") then
        OnboardingTiming.Mark(p5.Name .. "." .. p6, nil, os.clock() - elapsed)
    end

    if not ok then
        v1:AtError():Log((("[Kernel] %* failed in %*: %*"):format(p5:GetFullName(), p6, result)))
    end

    return ok
end

local function bootController(p8) -- line: 82
    -- upvalues: RunService (copy), v1 (copy), runStage (copy)
    local elapsed = os.clock()
    local _require = require
    local ok, result = pcall(_require, p8)

    if not ok then
        v1:AtError():Log((("[Kernel] %* failed while loading: %*"):format(p8:GetFullName(), result)))

        return
    end

    local v2 = os.clock() - elapsed

    if RunService:IsStudio() and v2 > 0.04 then
        v1:AtWarning():Log((("[Kernel] %* took %* ms to load"):format(p8.Name, (string.format("%.0f", v2 * 1000)))))
    end

    if type(result) ~= "table" then
        v1:AtWarning():Log((("[Kernel] %* did not return a controller table; tag it SkipAutoload if it is a library"):format((p8:GetFullName()))))

        return
    end

    local Init, Start = result.Init, result.Start

    if type(Init) == "function" or type(Start) == "function" then
        if (type(Init) ~= "function" or runStage(p8, "Init", Init)) and type(Start) == "function" then
            runStage(p8, "Start", Start)
        end
    else
        v1:AtWarning():Log((("[Kernel] %* exposes neither Init nor Start; tag it SkipAutoload if it is a library"):format((p8:GetFullName()))))
    end
end

for _, v3 in t2 do
    task.spawn(function() -- line: 113
        -- upvalues: v1 (copy), v3 (copy)
        local _require = require
        local ok, result = pcall(_require, v3)

        if not ok then
            v1:AtError():Log((("[Kernel] client startup module %* failed: %*"):format(v3:GetFullName(), result)))
        end
    end)
end

LocalPlayer:WaitForChild("PlayerGui")

local t3 = {}

for _, v4 in t1 do
    collectControllers(v4, t3)
end

table.sort(t3, byFullName)

for _, v5 in t3 do
    task.spawn(bootController, v5)
end

v1:AtInfo():Log((`[Kernel] launched {#t3} controllers`))
