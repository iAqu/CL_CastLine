-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Canyon = require(ReplicatedStorage.Shared.Canyon)
local Animals = require(ReplicatedStorage.Shared.Animals)
local UIUtil = require(script.Parent.Parent.UI.UIUtil)
local Hud = require(script.Parent.Parent.UI.Hud)
local Backpack = require(script.Parent.Parent.UI.Backpack)
local Menus = require(script.Parent.Parent.UI.Menus)
local Controls = require(script.Parent.Parent.Character.Controls)
local CastFlight = require(script.Parent.CastFlight)
local Reveal = require(script.Parent.Reveal)
local Effects = require(script.Parent.Effects)
local LocalPlayer = Players.LocalPlayer
local t1 = {}
local v1 = Random.new()
local v2 = false

local function v3() -- line: 24
    return false
end

local function pick(p1) -- line: 30
    -- upvalues: Animals (copy)
    local v4 = 10 ^ (p1 + 2) * 3
    local n1 = 1e999
    local v5

    for v6 in Animals.ById do
        local v9 = math.abs(math.log10((Animals.odds(v6))) - math.log10(v4))

        if v9 < n1 then
            n1 = v9
            v5 = Animals.get(v6)
        end
    end

    return v5, v4
end

local function resetCamera() -- line: 42
    -- upvalues: LocalPlayer (copy)
    local CurrentCamera = workspace.CurrentCamera
    local v10 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")

    CurrentCamera.CameraType = Enum.CameraType.Custom
    CurrentCamera.FieldOfView = 70

    if v10 then
        CurrentCamera.CameraSubject = v10
    end
end

function t1.isActive() -- line: 52
    -- upvalues: v2 (ref)
    return v2
end

function t1.setBusyCheck(p2) -- line: 56
    -- upvalues: v3 (ref)
    v3 = p2
end

function t1.play(p3) -- line: 60
    -- upvalues: Canyon (copy), Animals (copy), UIUtil (copy), Hud (copy), Backpack (copy), Menus (copy), Controls (copy), CastFlight (copy), Reveal (copy), Effects (copy), LocalPlayer (copy), v1 (copy), v2 (ref), v3 (ref), pick (copy)
    if v2 then
        return
    end

    if v3() then
        UIUtil.toast("Leave the dock / lift first!", "error")
    else
        local v11, v12 = pick(p3)

        if v11 then
            v2 = true
            Menus.closeAll()
            Hud.setVisible(false)
            Backpack.setVisible(false)
            Controls.lock("Preview")

            local Cutscene = UIUtil.gui("Cutscene")

            Effects.fade(Cutscene, true, 0.3)

            local v13 = Canyon.middle(v11.Biome)
            local v14 = Effects.liquidAt(v13)
            local v15 = Canyon.surface(v13)
            local v18 = Vector3.new(v1:NextNumber(-20, 20), v15, -v13)
            local v19, v20 = CastFlight.makeBobber()

            CastFlight.moveBobber(v19, v20, v18)

            local t2 = {
                landing = v18,
                surfaceY = v15,
                liquid = v14,
                color = if v14 then v14.Color else Color3.fromRGB(80, 170, 230),
                bobber = v19,
                cap = v20
            }
            local t3 = {
                Preview = true,
                Id = v11.Id,
                Weight = Animals.rollWeight(v11.Id, v1),
                Odds = v12
            }

            workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable
            Effects.letterbox(Cutscene, true)
            Effects.fade(Cutscene, false, 0.3)

            local show = Reveal.show
            local ok, result = pcall(show, t2, t3, Cutscene)

            if not ok then
                warn("Reveal preview error: " .. tostring(result))
                Reveal.cleanup()

                for _, v21 in { "Bobber", "Reveal" } do
                    local v22 = workspace:FindFirstChild(v21)

                    if v22 then
                        v22:Destroy()
                    end
                end
            end

            Effects.fade(Cutscene, true, 0.3)
            Effects.letterbox(Cutscene, false)

            for _, v23 in { "Banner", "Continue", "Odds", "LuckTitle" } do
                local v24 = Cutscene:FindFirstChild(v23)

                if v24 then
                    v24.Visible = false
                end
            end

            local CurrentCamera = workspace.CurrentCamera
            local v25 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")

            CurrentCamera.CameraType = Enum.CameraType.Custom
            CurrentCamera.FieldOfView = 70

            if v25 then
                CurrentCamera.CameraSubject = v25
            end

            Controls.unlock("Preview")
            Hud.setVisible(true)
            Backpack.setVisible(true)
            Effects.fade(Cutscene, false, 0.35)
            Cutscene.Enabled = false
            v2 = false
        end
    end
end

return t1
