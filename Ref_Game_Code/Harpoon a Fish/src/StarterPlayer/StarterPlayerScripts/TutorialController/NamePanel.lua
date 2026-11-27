-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Modules = ReplicatedStorage:WaitForChild("Modules")
local PanelFocus = require(Modules:WaitForChild("PanelFocus"))
local ButtonHover = require(Modules:WaitForChild("ButtonHover"))
local Loc = require(Modules:WaitForChild("Loc"))
local Funnel = require(Modules:WaitForChild("Funnel"))
local PadMenu = require(Modules:WaitForChild("PadMenu"))
local Panel = Players.LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("NameFishGui"):WaitForChild("Panel")
local Scale = Panel:WaitForChild("Scale")
local Box = Panel:WaitForChild("Box")
local Check = Panel:WaitForChild("Check")
local Random = Panel:WaitForChild("Random")
local NoName = Panel:WaitForChild("NoName")
local t1 = {
    "Fishy",
    "Bubbles",
    "Flippers",
    "LittleTim",
    "Jimbo",
    "Pipsqueak",
    "Nibbles",
    "Captain Fin",
    "Sir Splash",
    "Gillbert",
    "Finnegan",
    "Squishy",
    "Noodle",
    "Pickles",
    "Sushi",
    "Bubba",
    "Wiggles",
    "Snapper",
    "Goober",
    "Marshmallow",
    "Biscuit",
    "Pebbles",
    "Sprinkles",
    "Chomper",
    "Waffles",
    "Mr. Scales",
    "Torpedo",
    "Splashy",
    "Doodle",
    "Kevin"
}
local PlaceholderText = Box.PlaceholderText

Box.AutoLocalize = false

for _, v1 in ipairs({ Check, Random, NoName }) do
    ButtonHover.Attach(v1, {
        shine = false,
        highlight = true
    })
end

local t3 = {}

return {
    Open = function(p1, p2) -- Open | line: 50
        -- upvalues: TweenService (copy), PanelFocus (copy), Loc (copy), Funnel (copy), PadMenu (copy), Panel (copy), Scale (copy), Box (copy), Check (copy), Random (copy), NoName (copy), t1 (copy), PlaceholderText (copy), t3 (copy)
        for _, v2 in ipairs(t3) do
            v2:Disconnect()
        end

        table.clear(t3)

        local n1 = 1

        Box.Text = ""
        Box.PlaceholderText = p2 or Loc.T(PlaceholderText)
        Scale.Scale = PanelFocus.FEEL.FROM
        Panel.Visible = true
        Funnel.Report("name_popup")
        PanelFocus.Sound(PanelFocus.FEEL.OPEN_SOUND)
        TweenService:Create(Scale, PanelFocus.popIn, {
            Scale = 1
        }):Play()

        local v3 = false

        local function finish(p3) -- line: 63
            -- upvalues: p1 (copy), v3 (ref), TweenService (copy), PanelFocus (copy), PadMenu (copy), Panel (copy), Scale (copy), Box (copy), t3 (copy)
            if v3 then
                return
            end

            v3 = true
            PadMenu.Close(Panel)

            for _, v4 in ipairs(t3) do
                v4:Disconnect()
            end

            table.clear(t3)
            Box:ReleaseFocus()
            PanelFocus.Sound(PanelFocus.FEEL.CLOSE_SOUND)

            local tween = TweenService:Create(Scale, PanelFocus.popOut, {
                Scale = 0
            })

            tween.Completed:Once(function() -- line: 72
                -- upvalues: v3 (ref), Panel (copy)
                if v3 then
                    Panel.Visible = false
                end
            end)
            tween:Play()
            p1(p3)
        end

        local function lockIn() -- line: 76
            -- upvalues: p2 (copy), finish (copy), Box (copy)
            local v5 = string.gsub(Box.Text, "^%s+", "")
            local v6 = string.gsub(v5, "%s+$", "")

            if v6 == "" then
                if p2 then
                    finish(p2)
                end
            else
                finish(v6)
            end
        end

        table.insert(t3, Box:GetPropertyChangedSignal("Text"):Connect(function() -- line: 86
            -- upvalues: Box (copy)
            if not (utf8.len(Box.Text) and utf8.len(Box.Text) > 20) then
                return
            end

            Box.Text = string.sub(Box.Text, 1, utf8.offset(Box.Text, 21) - 1)
        end))
        table.insert(t3, Random.Activated:Connect(function() -- line: 91
            -- upvalues: n1 (ref), Box (copy), t1 (copy)
            Box.Text = t1[n1]
            n1 = n1 % #t1 + 1
        end))
        table.insert(t3, Check.Activated:Connect(lockIn))
        table.insert(t3, Box.Focused:Connect(function() -- line: 97
            -- upvalues: Box (copy)
            Box.PlaceholderText = ""
        end))
        table.insert(t3, Box.FocusLost:Connect(function(p4) -- line: 98
            -- upvalues: p2 (copy), finish (copy), Loc (copy), Box (copy), PlaceholderText (copy)
            if Box.Text == "" then
                Box.PlaceholderText = p2 or Loc.T(PlaceholderText)
            end

            if not p4 then
                return
            end

            local v14 = string.gsub(Box.Text, "^%s+", "")
            local v15 = string.gsub(v14, "%s+$", "")

            if v15 == "" then
                if p2 then
                    finish(p2)
                end
            else
                finish(v15)
            end
        end))
        table.insert(t3, NoName.Activated:Connect(function() -- line: 102
            -- upvalues: finish (copy)
            finish(nil)
        end))
        PadMenu.Open(Panel, function() -- line: 103
            -- upvalues: finish (copy)
            finish(nil)
        end, {
            first = Check
        })
    end
}
