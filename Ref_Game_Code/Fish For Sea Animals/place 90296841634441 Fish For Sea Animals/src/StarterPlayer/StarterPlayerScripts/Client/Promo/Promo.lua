-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService("StarterGui")
local UIUtil = require(script.Parent.Parent.UI.UIUtil)
local Hud = require(script.Parent.Parent.UI.Hud)
local Backpack = require(script.Parent.Parent.UI.Backpack)
local Menus = require(script.Parent.Parent.UI.Menus)
local Controls = require(script.Parent.Parent.Character.Controls)
local Effects = require(script.Parent.Parent.Fishing.Effects)
local Shots = require(script.Parent.Shots)
local LocalPlayer = Players.LocalPlayer
local t1 = {}
local t2 = {
    "hook",
    "cast",
    "plot",
    "workout",
    "biomes",
    "logo"
}
local t3 = {
    Cutscene = true,
    HUD = true
}
local t4 = {
    Enum.CoreGuiType.Chat,
    Enum.CoreGuiType.PlayerList,
    Enum.CoreGuiType.Backpack,
    Enum.CoreGuiType.EmotesMenu,
    Enum.CoreGuiType.Health
}
local v1 = false

local function v2() -- line: 33
    return false
end

function t1.isActive() -- line: 37
    -- upvalues: v1 (ref)
    return v1
end

function t1.setBusyCheck(p1) -- line: 41
    -- upvalues: v2 (ref)
    v2 = p1
end

local function hideOtherUi() -- line: 47
    -- upvalues: RunService (copy), StarterGui (copy), UIUtil (copy), LocalPlayer (copy), t3 (copy), t4 (copy)
    local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
    local t5 = {}

    local function sweep() -- line: 50
        -- upvalues: PlayerGui (copy), t5 (copy), t3 (copy)
        for _, child in PlayerGui:GetChildren() do
            if child:IsA("ScreenGui") and child.Enabled and not t3[child.Name] then
                t5[child] = true
                child.Enabled = false
            end
        end
    end

    sweep()

    local connection = RunService.Heartbeat:Connect(sweep)
    local t6 = {}

    for _, v3 in t4 do
        t6[v3] = StarterGui:GetCoreGuiEnabled(v3)

        local SetCoreGuiEnabled = StarterGui.SetCoreGuiEnabled

        pcall(SetCoreGuiEnabled, StarterGui, v3, false)
    end

    local Toasts = UIUtil.gui("HUD"):FindFirstChild("Toasts")

    if Toasts then
        Toasts.Visible = false
    end

    return function() -- line: 69
        -- upvalues: t5 (copy), connection (copy), t6 (copy), Toasts (copy), StarterGui (copy)
        connection:Disconnect()

        for v4 in t5 do
            if v4.Parent then
                v4.Enabled = true
            end
        end

        for v5, v6 in t6 do
            local SetCoreGuiEnabled = StarterGui.SetCoreGuiEnabled

            pcall(SetCoreGuiEnabled, StarterGui, v5, v6)
        end

        if Toasts then
            Toasts.Visible = true
        end
    end
end

local function resetCamera() -- line: 85
    -- upvalues: LocalPlayer (copy)
    local CurrentCamera = workspace.CurrentCamera
    local v7 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")

    CurrentCamera.CameraType = Enum.CameraType.Custom
    CurrentCamera.FieldOfView = 70

    if v7 then
        CurrentCamera.CameraSubject = v7
    end
end

function t1.play() -- line: 95
    -- upvalues: UIUtil (copy), Hud (copy), Backpack (copy), Menus (copy), Controls (copy), Effects (copy), Shots (copy), LocalPlayer (copy), t2 (copy), v1 (ref), v2 (ref), hideOtherUi (copy)
    if v1 then
        return
    end

    if v2() then
        UIUtil.toast("Leave the dock / lift first!", "error")
    else
        v1 = true
        Menus.closeAll()
        Hud.setVisible(false)
        Backpack.setVisible(false)
        Controls.lock("Promo")

        local Cutscene = UIUtil.gui("Cutscene")

        Effects.fade(Cutscene, true, 0.4)

        local v8 = hideOtherUi()

        workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable

        for _, v9 in t2 do
            local v10 = Shots[v9]
            local ok, result = pcall(v10, Cutscene)

            if not ok then
                warn((("Promo shot \"%*\" failed: %*"):format(v9, result)))
                Shots.tidy(Cutscene)
            end

            Cutscene.Enabled = true
            Cutscene.Fade.BackgroundTransparency = 0
            task.wait(1)
        end

        local finish = Shots.finish

        pcall(finish)
        v8()

        local CurrentCamera = workspace.CurrentCamera
        local v11 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")

        CurrentCamera.CameraType = Enum.CameraType.Custom
        CurrentCamera.FieldOfView = 70

        if v11 then
            CurrentCamera.CameraSubject = v11
        end

        Controls.unlock("Promo")
        Hud.setVisible(true)
        Backpack.setVisible(true)
        v1 = false
        Effects.fade(Cutscene, false, 0.5)
        Cutscene.Enabled = false
    end
end

return t1
