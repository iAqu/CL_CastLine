-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local KeyConfig = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("KeyConfig"))
local PotionConfig = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("PotionConfig"))
local Format = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Format"))
local t1 = {
    XP_ICON = { "rbxassetid://137513422393347", 61, 85, 902, 844 },
    FAT_ICON = "rbxassetid://135825676122341"
}

local function commas(p1) -- line: 17
    local v2 = tostring((math.floor(p1)))

    repeat
        local v3

        v2, v3 = v2:gsub("^(%d+)(%d%d%d)", "%1,%2")
    until v3 == 0

    return v2
end

function t1.KeyArt(p2, p3) -- line: 27
    -- upvalues: KeyConfig (copy)
    local v4 = KeyConfig.KEYS[p3]

    if not v4 then
        return
    end

    p2.Image = v4.image
    p2.ImageRectOffset = Vector2.new(v4.rect[1], v4.rect[2])
    p2.ImageRectSize = Vector2.new(v4.rect[3] - v4.rect[1], v4.rect[4] - v4.rect[2])
end

function t1.Card(p4) -- line: 36
    -- upvalues: PotionConfig (copy), Format (copy), t1 (copy), commas (copy)
    return {
        setup = function(p5) -- setup | line: 38
            -- upvalues: p4 (copy), PotionConfig (copy), Format (copy), t1 (copy), commas (copy)
            local Icon = p5.Main.Icon

            if p4.xp then
                local XP_ICON = t1.XP_ICON

                Icon.Image = XP_ICON[1]
                Icon.ImageRectOffset = Vector2.new(XP_ICON[2], XP_ICON[3])
                Icon.ImageRectSize = Vector2.new(XP_ICON[4], XP_ICON[5])
                p5.Main.Title.Text = "XP"
                p5.Main.Rarity.Text = "+" .. commas(p4.xp)
            elseif p4.key then
                t1.KeyArt(Icon, p4.key)
                p5.Main.Title.Text = p4.key .. " Key"
                p5.Main.Rarity.Text = "x" .. p4.count
            elseif p4.potion then
                local v5 = PotionConfig.Get(p4.potion)
                local v6 = PotionConfig.Kind(p4.potion)

                Icon.Image = v5 and v5.icon or ""

                local zero, zero2 = Vector2.zero, Vector2.zero

                Icon.ImageRectOffset = zero
                Icon.ImageRectSize = zero2
                p5.Main.Title.Text = v6 and v6.name or "Potion"
                p5.Main.Rarity.Text = "x" .. p4.count
            elseif p4.fat then
                Icon.Image = t1.FAT_ICON

                local zero, zero2 = Vector2.zero, Vector2.zero

                Icon.ImageRectOffset = zero
                Icon.ImageRectSize = zero2
                p5.Main.Title.Text = "Fat"
                p5.Main.Rarity.Text = "+" .. Format.short(p4.fat)
            end
        end
    }
end

return t1
