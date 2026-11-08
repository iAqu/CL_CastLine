-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local Asserts = require(ReplicatedStorage.UserGenerated.Lang.Asserts)
local CameraShaker = require(ReplicatedStorage.Packages.CameraShaker)
local t1 = {}
local _CFrame, _CFrame2, connection

local function advance(p1, p2) -- line: 38
    -- upvalues: Asserts (copy)
    local v1 = math.min(p2, 1)
    local v4 = math.max(math.ceil(v1 / 0.02), 1)
    local v5 = CFrame.identity

    for _ = 1, v4 do
        v5 = p1:Update(v1 / v4)
    end

    if Asserts.IsCFrameFinite(v5) then
        return v5
    end

    return CFrame.identity
end

local function apply(p3) -- line: 50
    -- upvalues: Workspace (copy), _CFrame (ref), _CFrame2 (ref)
    local CurrentCamera = Workspace.CurrentCamera

    if CurrentCamera == nil or p3 == CFrame.identity then
        return
    end

    local _CFrame3 = CurrentCamera.CFrame

    if _CFrame3 ~= _CFrame then
        _CFrame2 = _CFrame3
    end

    CurrentCamera.CFrame = _CFrame3 * p3
    _CFrame = CurrentCamera.CFrame
end

local function unwind() -- line: 68
    -- upvalues: Workspace (copy), _CFrame (ref), _CFrame2 (ref)
    local CurrentCamera = Workspace.CurrentCamera
    local CFrame3 = _CFrame
    local CFrame4 = _CFrame2

    _CFrame = nil
    _CFrame2 = nil

    if CurrentCamera ~= nil and CFrame3 ~= nil and CFrame4 ~= nil and CurrentCamera.CFrame == CFrame3 then
        CurrentCamera.CFrame = CFrame4
    end
end

local t2 = {
    Advance = advance,
    Start = function(p4, p5) -- Start | line: 88
        -- upvalues: RunService (copy), Workspace (copy), CameraShaker (copy), t1 (copy), _CFrame (ref), _CFrame2 (ref), connection (ref), advance (copy), unwind (copy)
        if t1[p4] ~= nil then
            return
        end

        if connection == nil then
            connection = RunService.PostSimulation:Connect(unwind)
        end

        local v6 = ("CameraShakerDriver%*"):format((CameraShaker.NextRenderName()))

        t1[p4] = v6
        RunService:BindToRenderStep(v6, p5, function(p6) -- line: 98
            -- upvalues: p4 (copy), Workspace (copy), _CFrame (ref), _CFrame2 (ref), advance (copy)
            local v7 = advance(p4, p6)
            local CurrentCamera = Workspace.CurrentCamera

            if CurrentCamera == nil or v7 == CFrame.identity then
                return
            end

            local _CFrame3 = CurrentCamera.CFrame

            if _CFrame3 ~= _CFrame then
                _CFrame2 = _CFrame3
            end

            CurrentCamera.CFrame = _CFrame3 * v7
            _CFrame = CurrentCamera.CFrame
        end)
    end,
    Stop = function(p7) -- Stop | line: 103
        -- upvalues: RunService (copy), t1 (copy)
        local v8 = t1[p7]

        if v8 ~= nil then
            t1[p7] = nil
            RunService:UnbindFromRenderStep(v8)
        end
    end
}

return table.freeze(t2)
