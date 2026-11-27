-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Config = require(ReplicatedStorage.Shared.Config)
local UIUtil = require(script.Parent.Parent.UI.UIUtil)
local Settings = require(script.Parent.Parent.UI.Settings)
local Kit = require(script.Parent.Parent.MiniGames.Kit)
local Style = require(script.Parent.Parent.Shop.Style)
local LocalPlayer = Players.LocalPlayer
local v1 = Color3.fromRGB(120, 128, 145)
local v2 = Color3.fromRGB(150, 150, 160)

return {
    init = function() -- init | line: 27
        -- upvalues: Config (copy), UIUtil (copy), Settings (copy), Kit (copy), Style (copy), LocalPlayer (copy), v1 (copy), v2 (copy)
        local LeftButtons = UIUtil.gui("HUD"):WaitForChild("LeftButtons")
        local ExitButton = LeftButtons:WaitForChild("ExitButton")
        local TextButton = Instance.new("TextButton")

        TextButton.Name = "KeepFishing"
        TextButton.Text = ""
        TextButton.AutoButtonColor = false
        TextButton.BackgroundTransparency = 1
        TextButton.AnchorPoint = Vector2.new(0.5, 0)
        TextButton.Position = UDim2.new(0.5, 0, 1, 12)
        TextButton.Size = UDim2.fromOffset(190, 196)
        TextButton.Visible = false
        TextButton.Parent = LeftButtons

        local ImageLabel = Instance.new("ImageLabel")

        ImageLabel.Name = "Icon"
        ImageLabel.BackgroundTransparency = 1
        ImageLabel.AnchorPoint = Vector2.new(0.5, 0)
        ImageLabel.Position = UDim2.fromScale(0.5, 0)
        ImageLabel.Size = UDim2.fromOffset(92, 92)
        ImageLabel.ScaleType = Enum.ScaleType.Fit
        ImageLabel.Image = "rbxassetid://137221184201264"
        ImageLabel.Parent = TextButton
        Style.text(TextButton, "KEEP FISHING", {
            Name = "Label",
            StrokeThickness = 4,
            AnchorPoint = Vector2.new(0.5, 0),
            Position = UDim2.fromOffset(95, 94),
            Size = UDim2.fromOffset(190, 40)
        })

        local function flip() -- line: 61
            -- upvalues: UIUtil (copy), Settings (copy)
            Settings.set("KeepFishing", not Settings.get("KeepFishing"))
            UIUtil.sound("Click", 0.6)
        end

        local v3 = Kit.button(TextButton, "", v1, {
            Name = "Switch",
            ZIndex = 2,
            AnchorPoint = Vector2.new(0.5, 0),
            Position = UDim2.fromOffset(95, 140),
            Size = UDim2.fromOffset(130, 54)
        }, flip)

        v3.Label.ZIndex = 3
        UIUtil.bindButton(TextButton, flip, ImageLabel)

        local n1 = 0

        Settings.onChanged("KeepFishing", function(p1) -- line: 76
            -- upvalues: TextButton (copy), ImageLabel (copy), v3 (copy), n1 (ref), UIUtil (copy), Style (copy), v1 (copy), v2 (copy)
            v3.BackgroundColor3 = if p1 then Style.BUY else v1
            v3.Label.Text = p1 and "ON" or "OFF"
            ImageLabel.ImageColor3 = if p1 then Color3.new(1, 1, 1) else v2

            if TextButton.Visible then
                UIUtil.pop(v3, 1.08)

                if p1 then
                    n1 += 360
                    UIUtil.tween(ImageLabel, 0.45, {
                        Rotation = n1
                    }, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
                end
            end
        end)

        local function refresh() -- line: 90
            -- upvalues: ExitButton (copy), TextButton (copy), Config (copy), UIUtil (copy), LocalPlayer (copy)
            local Character = LocalPlayer.Character
            local Tutorial = LocalPlayer:GetAttribute("Tutorial")
            local Visible = ExitButton.Visible and Character ~= nil and Character:GetAttribute("Fishing") == true and Tutorial ~= nil and Config.TutorialDone <= Tutorial

            if not Visible or TextButton.Visible then
                if not Visible then
                    TextButton.Visible = false
                end
            else
                TextButton.Visible = true
                UIUtil.pop(TextButton, 0.6)
            end
        end

        task.spawn(function() -- line: 105
            -- upvalues: TextButton (copy), ImageLabel (copy), n1 (ref), UIUtil (copy), Settings (copy)
            while true do
                task.wait(3.5)

                if TextButton.Visible and not Settings.get("KeepFishing") then
                    for _, v6 in { -16, 14, -10, 7, -3, 0 } do
                        UIUtil.tween(ImageLabel, 0.07, {
                            Rotation = n1 + v6
                        })
                        task.wait(0.07)
                    end
                end
            end
        end)
        ExitButton:GetPropertyChangedSignal("Visible"):Connect(refresh)
        LocalPlayer:GetAttributeChangedSignal("Tutorial"):Connect(refresh)

        local function watch(p2) -- line: 118
            -- upvalues: refresh (copy)
            p2:GetAttributeChangedSignal("Fishing"):Connect(refresh)
            refresh()
        end

        LocalPlayer.CharacterAdded:Connect(watch)

        if LocalPlayer.Character then
            LocalPlayer.Character:GetAttributeChangedSignal("Fishing"):Connect(refresh)
            refresh()
        end
    end
}
