-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GameConfig = require(ReplicatedStorage.Config.GameConfig)
local t1 = {}
local LocalPlayer = Players.LocalPlayer
local v1 = false
local t2, result
local v2 = false

local function getControls() -- line: 22
    -- upvalues: LocalPlayer (copy), result (ref), v2 (ref)
    if v2 then
        return result
    end

    v2 = true

    local function v3() -- line: 25
        -- upvalues: LocalPlayer (copy)
        local v4 = LocalPlayer:WaitForChild("PlayerScripts", 2)
        local PlayerModule = v4 and v4:FindFirstChild("PlayerModule")

        if PlayerModule then
            return require(PlayerModule):GetControls()
        end

        return nil
    end

    local ok, result2 = pcall(v3)

    if ok then
        result = result2
    end

    return result
end

function t1.Lock() -- line: 35
    -- upvalues: UserInputService (copy), LocalPlayer (copy), v1 (ref), t2 (ref), result (ref), v2 (ref)
    if v1 then
        return
    end

    v1 = true

    if not v2 then
        v2 = true

        local function v5() -- line: 25
            -- upvalues: LocalPlayer (copy)
            local v6 = LocalPlayer:WaitForChild("PlayerScripts", 2)
            local PlayerModule = v6 and v6:FindFirstChild("PlayerModule")

            if PlayerModule then
                return require(PlayerModule):GetControls()
            end

            return nil
        end

        local ok, result2 = pcall(v5)

        if ok then
            result = result2
        end
    end

    local result2 = result

    if result2 then
        local function v7() -- line: 39
            -- upvalues: result2 (copy)
            result2:Disable()
        end

        pcall(v7)
    end

    local Character = LocalPlayer.Character
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

    if Humanoid then
        t2 = {
            WalkSpeed = Humanoid.WalkSpeed,
            JumpPower = Humanoid.JumpPower,
            JumpHeight = Humanoid.JumpHeight,
            AutoRotate = Humanoid.AutoRotate
        }
        Humanoid.WalkSpeed = 0
        Humanoid.JumpPower = 0
        Humanoid.JumpHeight = 0
        Humanoid.AutoRotate = false
    end

    local function v8() -- line: 49
        -- upvalues: UserInputService (copy)
        UserInputService.ModalEnabled = true
    end

    pcall(v8)
end

function t1.Unlock() -- line: 52
    -- upvalues: UserInputService (copy), GameConfig (copy), LocalPlayer (copy), v1 (ref), t2 (ref), result (ref), v2 (ref)
    if not v1 then
        return
    end

    v1 = false

    if not v2 then
        v2 = true

        local function v9() -- line: 25
            -- upvalues: LocalPlayer (copy)
            local v10 = LocalPlayer:WaitForChild("PlayerScripts", 2)
            local PlayerModule = v10 and v10:FindFirstChild("PlayerModule")

            if PlayerModule then
                return require(PlayerModule):GetControls()
            end

            return nil
        end

        local ok, result2 = pcall(v9)

        if ok then
            result = result2
        end
    end

    local result2 = result

    if result2 then
        local function v11() -- line: 56
            -- upvalues: result2 (copy)
            result2:Enable()
        end

        pcall(v11)
    end

    local Character = LocalPlayer.Character
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")

    if Humanoid then
        Humanoid.WalkSpeed = t2 and t2.WalkSpeed and t2.WalkSpeed > 0 and t2.WalkSpeed or GameConfig.WalkSpeed or 16
        Humanoid.JumpPower = t2 and t2.JumpPower or 50
        Humanoid.JumpHeight = t2 and t2.JumpHeight or 7.2
        Humanoid.AutoRotate = true
    end

    t2 = nil

    local function v12() -- line: 66
        -- upvalues: UserInputService (copy)
        UserInputService.ModalEnabled = false
    end

    pcall(v12)
end

function t1.IsLocked() -- line: 69
    -- upvalues: v1 (ref)
    return v1
end

return t1
