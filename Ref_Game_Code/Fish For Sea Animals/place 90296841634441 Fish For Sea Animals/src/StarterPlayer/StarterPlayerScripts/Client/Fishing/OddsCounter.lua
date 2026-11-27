-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Format = require(ReplicatedStorage.Shared.Format)
local UIUtil = require(script.Parent.Parent.UI.UIUtil)
local LuckBadge = require(script.Parent.LuckBadge)
local t1 = {}
local v1 = Color3.new(1, 1, 1)

local function oddsText(p1) -- line: 16
    -- upvalues: Format (copy)
    return "1 in " .. (if p1 < 1000 then tostring((math.floor(p1))) else Format.short(p1))
end

local function reset(p2) -- line: 21
    p2.Visible = false
    p2.Position = p2:GetAttribute("HomePosition") or p2.Position
    p2.Size = p2:GetAttribute("HomeSize") or p2.Size
end

function t1.start(p3, p4, p5) -- line: 29
    -- upvalues: Format (copy), UIUtil (copy), LuckBadge (copy), v1 (copy)
    local Odds = p3.Odds

    if Odds:GetAttribute("HomePosition") == nil then
        UIUtil.centre(Odds)
        Odds:SetAttribute("HomePosition", Odds.Position)
        Odds:SetAttribute("HomeSize", Odds.Size)
    end

    Odds.Visible = false
    Odds.Position = Odds:GetAttribute("HomePosition") or Odds.Position
    Odds.Size = Odds:GetAttribute("HomeSize") or Odds.Size

    local v4 = math.max(1, p4)
    local n1 = 1

    Odds.Text = "1 in " .. tostring(1)
    Odds.TextColor3 = v1
    Odds.TextTransparency = 0
    Odds.UIStroke.Transparency = 0
    Odds.Visible = true
    UIUtil.pop(Odds, 0.6)

    local v5 = if p5 then UIUtil.sound("OddsRise", 0.8, 8.36 / p5, p5 + 1) else nil

    if v5 and p5 then
        local function fit() -- line: 48
            -- upvalues: p5 (copy), v5 (copy)
            if v5.TimeLength > 0 then
                v5.PlaybackSpeed = v5.TimeLength / p5
            end
        end

        if v5.IsLoaded then
            if v5.TimeLength > 0 then
                v5.PlaybackSpeed = v5.TimeLength / p5
            end
        else
            v5.Loaded:Once(fit)
        end
    end

    local n2 = 1

    return {
        update = function(p6) -- update | line: 64
            -- upvalues: Odds (copy), v4 (copy), n1 (ref), n2 (ref), Format (copy), UIUtil (copy)
            local v8 = math.floor(v4 ^ math.min(p6 / 0.95, 1))

            if v8 ~= n1 then
                n1 = v8
                Odds.Text = "1 in " .. (if v8 < 1000 then tostring((math.floor(v8))) else Format.short(v8))

                local v11 = #tostring(v8)

                if n2 < v11 then
                    n2 = v11

                    if v8 < 1000 then
                        UIUtil.pop(Odds, 1.12)
                        UIUtil.sound("Tick", 0.45, n2 * 0.15 + 0.9)
                    end
                end
            end

            return n1
        end,
        finish = function(p7) -- finish | line: 84
            -- upvalues: p3 (copy), Odds (copy), v4 (copy), v5 (copy), Format (copy), UIUtil (copy), LuckBadge (copy)
            if v5 then
                v5:Destroy()
            end

            Odds.Text = "1 in " .. (if v4 < 1000 then tostring((math.floor(v4))) else Format.short(v4))
            Odds.TextColor3 = p7
            UIUtil.pop(Odds, 1.5)
            LuckBadge.land(p3, p7)

            local HomeSize = Odds:GetAttribute("HomeSize")
            local v14 = HomeSize.Y.Offset * 0.62
            local Banner = p3.Banner

            UIUtil.tween(Odds, 0.35, {
                Position = UDim2.new(0.5, 0, Banner.Position.Y.Scale, Banner.Position.Y.Offset + (Banner.Size.Y.Offset + 6 + v14 / 2) * UIUtil.scale),
                Size = UDim2.new(HomeSize.X, UDim.new(0, v14))
            }, Enum.EasingStyle.Back)
        end,
        reset = function() -- reset | line: 102
            -- upvalues: Odds (copy), v5 (copy)
            if v5 then
                v5:Destroy()
            end

            Odds.Visible = false
            Odds.Position = Odds:GetAttribute("HomePosition") or Odds.Position
            Odds.Size = Odds:GetAttribute("HomeSize") or Odds.Size
        end
    }
end

return t1
