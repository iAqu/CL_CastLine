-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AreaNotificationTracker = require(script.Parent.Parent.Game.GuardAreasController.AreaNotificationTracker)

require(ReplicatedStorage.Data.Areas)

local GUI = require(ReplicatedStorage.Client.GUI)
local SwapGradient = require(ReplicatedStorage.Shared.Utils.SwapGradient)
local GuiTransitionGroup = require(ReplicatedStorage.Client.UI.VFX.GuiTransitionGroup)
local SubBiomeCycle = require(ReplicatedStorage.Shared.Util.SubBiomeCycle)
local v1 = TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local v2 = TweenInfo.new(0.24, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
local v3

return {
    Show = function(p1, p2, p3) -- Show | line: 41
        -- upvalues: v3 (ref)
        local v4 = v3

        assert(v4 ~= nil, "AreaGuiController must be started before Show")
        v4(p1, p2, p3)
    end,
    Start = function() -- Start | line: 47
        -- upvalues: AreaNotificationTracker (copy), GUI (copy), SwapGradient (copy), GuiTransitionGroup (copy), SubBiomeCycle (copy), v1 (copy), v2 (copy), v3 (ref)
        local v6 = GUI.AreaGui()
        local Frame = v6.Frame
        local Main, Emoji = Frame.Texts.Main, Frame.Texts.Emoji
        local UIGradient = Instance.new("UIGradient")

        UIGradient.Rotation = 22

        local t2 = {}
        local n1 = 0
        local v7

        local function applyAreaGradient(p4, p5) -- line: 66
            -- upvalues: Main (copy), UIGradient (copy), SwapGradient (copy)
            local Gradient = if p5 == nil then nil else p5.Gradient

            if Gradient ~= nil then
                UIGradient.Color = Gradient
                SwapGradient(Main, UIGradient)
            else
                SwapGradient(Main, p4.ZoneGradient or p4.Rarity.RarityGradient)
            end
        end

        local function renderArea(p6, p7) -- line: 80
            -- upvalues: Main (copy), Emoji (copy), UIGradient (copy), SwapGradient (copy), SubBiomeCycle (copy)
            local v8 = SubBiomeCycle.Active(p7)

            if v8 ~= nil then
                Main.Text = ("%*"):format(v8.DisplayName)
                Emoji.Text = ("%*"):format(v8.Emoji or p6.Emoji)
            else
                Main.Text = ("%*"):format(p6.DisplayName)
                Emoji.Text = ("%*"):format(p6.Emoji)
            end

            local Gradient = if v8 == nil then nil else v8.Gradient

            if Gradient ~= nil then
                UIGradient.Color = Gradient
                SwapGradient(Main, UIGradient)
            else
                SwapGradient(Main, p6.ZoneGradient or p6.Rarity.RarityGradient)
            end
        end

        local function animate(p8) -- line: 92
            -- upvalues: v6 (copy), n1 (ref), v7 (ref), v1 (copy), v2 (copy)
            n1 += 1

            local v10 = n1
            local v11 = v7

            assert(v11 ~= nil, "AreaGui transition group must be initialized before show")
            v11:Halt()
            p8()
            v11:SnapHidden()
            v6.Enabled = true
            v11:Reveal(v1)
            task.delay(1, function() -- line: 107
                -- upvalues: v10 (copy), v11 (copy), v6 (copy), n1 (ref), v2 (copy)
                if v10 ~= n1 then
                    return
                end

                v11:Halt()
                v11:Conceal(v2)
                task.delay(v2.Time, function() -- line: 115
                    -- upvalues: v10 (copy), v11 (copy), v6 (copy), n1 (ref)
                    if v10 == n1 then
                        v6.Enabled = false
                        v11:Rehome()
                    end
                end)
            end)
        end

        local function showArea(p9, p10) -- line: 126
            -- upvalues: n1 (ref), renderArea (copy), animate (copy)
            if workspace:GetAttribute("Event_DragonEggEvent") then
                n1 += 1
            else
                animate(function() -- line: 132
                    -- upvalues: p9 (copy), p10 (copy), renderArea (copy)
                    renderArea(p9, p10)
                end)
            end
        end

        v3 = function(p11, p12, p13) -- line: 137
            -- upvalues: Main (copy), Emoji (copy), animate (copy), SwapGradient (copy)
            animate(function() -- line: 138
                -- upvalues: p11 (copy), p12 (copy), p13 (copy), Main (copy), Emoji (copy), SwapGradient (copy)
                Main.Text = p11
                Emoji.Text = p12
                SwapGradient(Main, p13)
            end)
        end

        local function start() -- line: 145
            -- upvalues: v6 (copy), v7 (ref), showArea (copy), AreaNotificationTracker (copy), GuiTransitionGroup (copy)
            v7 = GuiTransitionGroup.new(v6, v6, 0.02)
            v6.Enabled = false
            AreaNotificationTracker.Start(showArea)
        end

        function t2.Start() -- line: 155
            -- upvalues: v6 (copy), v7 (ref), showArea (copy), AreaNotificationTracker (copy), GuiTransitionGroup (copy)
            v7 = GuiTransitionGroup.new(v6, v6, 0.02)
            v6.Enabled = false
            AreaNotificationTracker.Start(showArea)
        end

        t2.Start()
    end
}
