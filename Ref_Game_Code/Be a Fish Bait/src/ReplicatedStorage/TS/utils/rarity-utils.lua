-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    common = Color3.fromRGB(160, 160, 160),
    uncommon = Color3.fromRGB(69, 255, 69),
    rare = Color3.fromRGB(105, 232, 255),
    epic = Color3.fromRGB(191, 71, 255),
    legendary = Color3.fromRGB(255, 184, 41),
    mythic = Color3.fromRGB(255, 0, 0),
    godly = Color3.fromRGB(255, 207, 59),
    secret = Color3.fromRGB(67, 67, 67),
    hacked = Color3.fromRGB(0, 255, 0),
    cosmic = Color3.fromRGB(255, 0, 255),
    extinct = Color3.fromRGB(205, 133, 63),
    kaijuwu = Color3.fromRGB(0, 255, 210),
    scifi = Color3.fromRGB(65, 184, 255),
    exclusive = Color3.fromRGB(255, 255, 255)
}

local function solidSequence(p1) -- line: 27
    return ColorSequence.new({
        ColorSequenceKeypoint.new(0, p1),
        ColorSequenceKeypoint.new(1, p1)
    })
end

local t2 = {
    common = {
        color = solidSequence(t1.common),
        borderColor = Color3.fromRGB(90, 90, 90)
    },
    uncommon = {
        color = solidSequence(t1.uncommon),
        borderColor = Color3.fromRGB(0, 110, 30)
    },
    rare = {
        color = solidSequence(t1.rare),
        borderColor = Color3.fromRGB(10, 80, 180)
    },
    epic = {
        color = solidSequence(t1.epic),
        borderColor = Color3.fromRGB(80, 0, 140)
    },
    legendary = {
        color = solidSequence(t1.legendary),
        borderColor = Color3.fromRGB(160, 100, 0)
    },
    mythic = {
        color = solidSequence(t1.mythic),
        borderColor = Color3.fromRGB(120, 0, 0)
    },
    godly = {
        color = solidSequence(t1.godly),
        borderColor = Color3.fromRGB(160, 100, 0)
    },
    secret = {
        color = solidSequence(t1.secret),
        borderColor = Color3.fromRGB(0, 0, 0)
    },
    hacked = {
        color = solidSequence(t1.hacked),
        borderColor = Color3.fromRGB(0, 0, 0)
    },
    cosmic = {
        color = solidSequence(t1.cosmic),
        borderColor = Color3.fromRGB(55, 0, 85)
    },
    extinct = {
        color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(84, 56, 28)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(205, 133, 63)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 122, 0))
        }),
        borderColor = Color3.fromRGB(51, 31, 10)
    },
    kaijuwu = {
        color = solidSequence(t1.kaijuwu),
        borderColor = Color3.fromRGB(0, 92, 76)
    },
    scifi = {
        color = solidSequence(t1.scifi),
        borderColor = Color3.fromRGB(12, 67, 148)
    },
    exclusive = {
        color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 55, 55)),
            ColorSequenceKeypoint.new(0.18, Color3.fromRGB(255, 185, 35)),
            ColorSequenceKeypoint.new(0.36, Color3.fromRGB(255, 245, 80)),
            ColorSequenceKeypoint.new(0.54, Color3.fromRGB(60, 235, 95)),
            ColorSequenceKeypoint.new(0.72, Color3.fromRGB(55, 195, 255)),
            ColorSequenceKeypoint.new(0.88, Color3.fromRGB(150, 95, 255)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 75, 210))
        }),
        borderColor = Color3.fromRGB(0, 0, 0)
    }
}

return {
    getRarityColor = function(p2) -- getRarityColor | line: 88
        -- upvalues: t2 (copy)
        return t2[p2].color
    end,
    getRarityBorderColor = function(p3) -- getRarityBorderColor | line: 91
        -- upvalues: t2 (copy)
        return t2[p3].borderColor
    end,
    getRarityDisplayName = function(p4) -- getRarityDisplayName | line: 94
        if p4 == "kaijuwu" then
            return "KaijUwU"
        end

        return string.upper((string.sub(p4, 1, 1))) .. string.sub(p4, 2)
    end,
    getRarityColorInHex = function(p5) -- getRarityColorInHex | line: 100
        if p5 == "common" then
            return "#ffffff"
        end

        if p5 == "uncommon" then
            return "#00ff00"
        end

        if p5 == "rare" then
            return "#00d1ff"
        end

        if p5 == "epic" then
            return "#ab05ab"
        end

        if p5 == "legendary" then
            return "#ffc400"
        end

        if p5 == "mythic" then
            return "#cc0000"
        end

        if p5 == "godly" then
            return "#f1c232"
        end

        if p5 == "secret" then
            return "#434343"
        end

        if p5 == "hacked" then
            return "#00ff00"
        end

        if p5 == "cosmic" then
            return "#ff00ff"
        end

        if p5 == "extinct" then
            return "#cd853f"
        end

        if p5 == "kaijuwu" then
            return "#00ffd2"
        end

        if p5 == "scifi" then
            return "#41b8ff"
        end

        if p5 == "exclusive" then
            return "#ffffff"
        end
    end,
    rarityColors = t1,
    rarityColorGradients = t2
}
