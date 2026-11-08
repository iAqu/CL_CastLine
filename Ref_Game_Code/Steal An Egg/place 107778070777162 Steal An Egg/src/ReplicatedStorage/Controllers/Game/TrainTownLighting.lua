-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LightingController = require(script.Parent.LightingController)
local LocalPlayer = Players.LocalPlayer
local t1 = {}
local v1 = false
local v2 = false
local LightingSettings
local t2 = {}

local function clear() -- line: 14
    -- upvalues: LightingController (copy), v2 (ref), LightingSettings (ref)
    if v2 then
        LightingController.ClearLayer("TrainForgottenTown", 0)
    end

    v2 = false
    LightingSettings = nil
end

local function config() -- line: 18
    -- upvalues: ReplicatedStorage (copy)
    local TrainEvent = ReplicatedStorage.Assets:FindFirstChild("TrainEvent")

    return TrainEvent and TrainEvent:FindFirstChild("LightingSettings")
end

local function sync() -- line: 22
    -- upvalues: ReplicatedStorage (copy), LightingController (copy), LocalPlayer (copy), v2 (ref), LightingSettings (ref)
    local Character = LocalPlayer.Character
    local LightingSettings2, v3

    if Character then
        local Humanoid = Character:FindFirstChildOfClass("Humanoid")

        if not Humanoid or Humanoid.Health <= 0 then
            v3 = true
        elseif Character:GetAttribute("TrainEventInForgottenTown") == true then
            local TrainEvent = ReplicatedStorage.Assets:FindFirstChild("TrainEvent")

            LightingSettings2 = TrainEvent and TrainEvent:FindFirstChild("LightingSettings")
            v3 = false
        else
            v3 = true
        end
    else
        v3 = true
    end

    if not v3 and LightingSettings2 then
        if not v2 or LightingSettings ~= LightingSettings2 then
            local SetAuthoredLayer = LightingController.SetAuthoredLayer
            local ok, result = pcall(SetAuthoredLayer, "TrainForgottenTown", LightingSettings2, 160, 0)

            if ok then
                v2 = true
                LightingSettings = LightingSettings2
            else
                if v2 then
                    LightingController.ClearLayer("TrainForgottenTown", 0)
                end

                v2 = false
                LightingSettings = nil
                warn("[TrainEvent] Invalid town lighting:", result)
            end
        end
    else
        if v2 then
            LightingController.ClearLayer("TrainForgottenTown", 0)
        end

        v2 = false
        LightingSettings = nil
    end
end

local function watch(p1) -- line: 32
    -- upvalues: LightingController (copy), LocalPlayer (copy), v2 (ref), LightingSettings (ref), t2 (copy), clear (copy), sync (copy)
    for _, v4 in t2 do
        v4:Disconnect()
    end

    table.clear(t2)

    if v2 then
        LightingController.ClearLayer("TrainForgottenTown", 0)
    end

    v2 = false
    LightingSettings = nil
    table.insert(t2, p1:GetAttributeChangedSignal("TrainEventInForgottenTown"):Connect(sync))

    local function attachHumanoid(p2) -- line: 37
        -- upvalues: t2 (copy), clear (copy), sync (copy)
        table.insert(t2, p2.Died:Connect(clear))
        sync()
    end

    local Humanoid = p1:FindFirstChildOfClass("Humanoid")

    if Humanoid then
        table.insert(t2, Humanoid.Died:Connect(clear))
        sync()
    else
        task.spawn(function() -- line: 42
            -- upvalues: p1 (copy), LocalPlayer (copy), t2 (copy), clear (copy), sync (copy)
            local v5 = p1:WaitForChild("Humanoid", 10)

            if v5 and LocalPlayer.Character == p1 then
                table.insert(t2, v5.Died:Connect(clear))
                sync()
            end
        end)
    end

    sync()
end

function t1.Start() -- line: 49
    -- upvalues: ReplicatedStorage (copy), LightingController (copy), LocalPlayer (copy), v1 (ref), v2 (ref), LightingSettings (ref), t2 (copy), clear (copy), sync (copy), watch (copy)
    if v1 then
        return
    end

    v1 = true
    LocalPlayer.CharacterAdded:Connect(watch)
    LocalPlayer.CharacterRemoving:Connect(function() -- line: 52
        -- upvalues: LightingController (copy), v2 (ref), LightingSettings (ref), t2 (copy)
        for _, v6 in t2 do
            v6:Disconnect()
        end

        table.clear(t2)

        if v2 then
            LightingController.ClearLayer("TrainForgottenTown", 0)
        end

        v2 = false
        LightingSettings = nil
    end)
    ReplicatedStorage.Assets.DescendantAdded:Connect(function(p3) -- line: 56
        -- upvalues: sync (copy)
        if p3.Name == "LightingSettings" then
            task.defer(sync)
        end
    end)
    ReplicatedStorage.Assets.DescendantRemoving:Connect(function(p4) -- line: 59
        -- upvalues: LightingSettings (ref), sync (copy)
        if p4 == LightingSettings then
            task.defer(function() -- line: 60
                -- upvalues: LightingSettings (ref), sync (copy)
                LightingSettings = nil
                sync()
            end)
        end
    end)
    script.Destroying:Connect(clear)

    if LocalPlayer.Character then
        watch(LocalPlayer.Character)
    end
end

return t1
