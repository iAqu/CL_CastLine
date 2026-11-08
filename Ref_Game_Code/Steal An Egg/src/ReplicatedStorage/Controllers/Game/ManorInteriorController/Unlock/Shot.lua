-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local GuiService = game:GetService("GuiService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local Kit = require(script.Parent.Parent.Parent.SewerCaveController.Transition.Kit)
local Trove = require(ReplicatedStorage.Packages.Trove)
local LocalPlayer = Players.LocalPlayer
local v1 = Color3.new(1, 1, 1)
local t1
local t2 = {
    Looks = table.freeze({
        Clear = Kit.Looks.Clear,
        Keyhole = table.freeze({
            Brightness = 0.04,
            Contrast = 0.12,
            Saturation = 0.15,
            Bloom = 1.2,
            Blur = 0,
            Tint = Color3.fromRGB(255, 228, 200)
        }),
        Spill = table.freeze({
            Brightness = -0.04,
            Contrast = 0.16,
            Saturation = 0.1,
            Bloom = 1,
            Blur = 0,
            Tint = Color3.fromRGB(255, 232, 205)
        })
    }),
    White = v1
}

local function cameraModule() -- line: 66
    -- upvalues: LocalPlayer (copy)
    local PlayerScripts = LocalPlayer:FindFirstChild("PlayerScripts")
    local PlayerModule = PlayerScripts and PlayerScripts:FindFirstChild("PlayerModule")

    if PlayerModule == nil or not PlayerModule:IsA("ModuleScript") then
        return nil
    end

    local _require = require
    local ok, result = pcall(_require, PlayerModule)

    return if ok then result:GetCameras() else nil
end

local function hideHud() -- line: 76
    -- upvalues: LocalPlayer (copy)
    local t3 = {}
    local PlayerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")

    if PlayerGui ~= nil then
        for _, child in PlayerGui:GetChildren() do
            if child:IsA("ScreenGui") and child.Enabled then
                child.Enabled = false
                table.insert(t3, child)
            end
        end
    end

    return t3
end

local function restore(p1) -- line: 91
    -- upvalues: t1 (ref), cameraModule (copy)
    p1.Done = true

    if t1 == p1 then
        t1 = nil
    end

    for _, v2 in p1.Hidden do
        if v2.Parent ~= nil then
            v2.Enabled = true
        end
    end

    table.clear(p1.Hidden)

    if p1.Owns then
        local Camera = p1.Camera

        Camera.FieldOfView = p1.FieldOfView

        local HandBack = p1.HandBack

        if HandBack ~= nil then
            Camera.CFrame = HandBack
        end

        local v3 = p1.Commit or HandBack
        local v4 = cameraModule()

        if v3 ~= nil and v4 ~= nil then
            local function v5() -- line: 114
                -- upvalues: v3 (copy), v4 (copy)
                v4:CommitCameraCFrame(v3, Enum.CameraType.Custom)
            end

            pcall(v5)
        end
    end
end

function t2.Take() -- line: 124
    -- upvalues: GuiService (copy), Workspace (copy), Kit (copy), Trove (copy), t1 (ref), t2 (copy), hideHud (copy), restore (copy)
    t2.Drop()

    local CurrentCamera = Workspace.CurrentCamera

    if CurrentCamera == nil then
        return nil
    end

    local v6 = Trove.new()
    local t4 = {
        HandBack = nil,
        Commit = nil,
        Done = false,
        Trove = v6,
        Camera = CurrentCamera,
        FieldOfView = CurrentCamera.FieldOfView,
        Owns = CurrentCamera.CameraType == Enum.CameraType.Custom,
        Calm = GuiService.ReducedMotionEnabled,
        Low = Kit.LowQuality(),
        Grade = Kit.Grade(v6, CurrentCamera),
        Hidden = hideHud()
    }

    v6:Add(function() -- line: 144
        -- upvalues: t4 (copy), restore (copy)
        restore(t4)
    end)
    t1 = t4

    return t4
end

function t2.Release(p2, p3, p4) -- line: 151
    if p2.Done then
        return
    end

    if p3 ~= nil then
        p2.HandBack = p3
    end

    if p4 ~= nil then
        p2.Commit = p4
    end

    p2.Trove:Destroy()
end

function t2.Drop() -- line: 164
    -- upvalues: t1 (ref), t2 (copy)
    local t5 = t1

    t1 = nil

    if t5 ~= nil then
        t2.Release(t5, nil)
    end
end

function t2.Look(p5, p6, p7, p8, p9) -- line: 172
    -- upvalues: Kit (copy)
    Kit.Mix(p5.Grade.Look, p6, p7, p8)
    Kit.Apply(p5.Grade, p9 or 0)
end

function t2.Place(p10, p11, p12) -- line: 177
    if p10.Owns and not p10.Done then
        p10.Camera.CFrame = p11

        if p12 ~= nil then
            p10.Camera.FieldOfView = p12
        end
    end
end

function t2.Reach() -- line: 187
    -- upvalues: Workspace (copy), cameraModule (copy)
    local v7 = cameraModule()
    local v8 = if v7 == nil then nil else v7:GetCameraToSubjectDistance()

    if v8 ~= nil then
        return (math.max(v8, 4))
    end

    local CurrentCamera = Workspace.CurrentCamera

    if CurrentCamera == nil then
        return 12
    end

    return (math.max((CurrentCamera.CFrame.Position - CurrentCamera.Focus.Position).Magnitude, 4))
end

function t2.Pose(p13, p14, p15) -- line: 199
    -- upvalues: cameraModule (copy)
    local v9 = cameraModule()
    local v10 = (if v9 == nil then nil else v9:GetCameraSubjectPosition()) or p13.Position + Vector3.new(0, 1.5, 0)

    return CFrame.lookAt(v10 - p14.Unit * p15, v10)
end

function t2.Face(p16, p17) -- line: 206
    -- upvalues: Workspace (copy), Kit (copy), t2 (copy), cameraModule (copy)
    local CurrentCamera = Workspace.CurrentCamera
    local v11, v12, v13, v14

    if CurrentCamera ~= nil then
        if CurrentCamera.CameraType == Enum.CameraType.Custom then
            v11 = Kit.FlatUnit(p17, p16.CFrame.LookVector)
            v12 = cameraModule()

            if v12 ~= nil then
                v13 = v12:GetCameraSubjectPosition()
            end

            v14 = false
        else
            v14 = true
        end
    else
        v14 = true
    end

    if v14 then
        return
    end

    local v15 = v13 or p16.Position + Vector3.new(0, 1.5, 0)
    local v16 = t2.Reach()
    local v17 = v11 * 0.9781476007338057 + Vector3.new(-0, -0.20791169, -0)
    local v18 = CFrame.lookAt(v15 - v17 * v16, v15)

    CurrentCamera.CFrame = v18

    if v12 ~= nil then
        v12:CommitCameraCFrame(v18, Enum.CameraType.Custom)
    end
end

return table.freeze(t2)
