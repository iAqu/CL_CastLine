-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return function(p1, p2) -- line: 5
    local fightHooked, attr = p2.fightHooked, p2.attr

    p1.AnglerGulp = {
        CLOSE = 0.26,
        GULP_T = 0.22,
        CLOSE_EASE = 30,
        OPEN_EASE = 5,
        BREATH = 0.03,
        STRIKE_E = 1.3,
        TWITCH_KICK = 3,
        GULP_CHANCE = 0.35,
        GAPE_BACK = 10,
        SWAY_RATE = 1.4,
        SWAY_P = 0.25,
        TWITCH = { 1.2, 2.6 },
        register = function(p3) -- register | line: 33
            -- upvalues: p1 (copy), attr (copy)
            local v1 = (p3:FindFirstChild("Lantern", true) and p1.LanternSwim or p1.AnglerSwim).register(p3)

            if not v1 then
                return nil
            end

            local v2 = v1.mesh:FindFirstChild("Jaw", true)

            if not v2 then
                return nil
            end

            local CFrame = v1.mesh.CFrame
            local nose = v1.nose
            local Unit = nose:Cross((Vector3.new(0, 1, 0) - nose * nose.Y).Unit).Unit

            v1.jaw = {
                bone = v2,
                right = CFrame:ToObjectSpace(v2.WorldCFrame):VectorToObjectSpace(Unit)
            }
            v1.close = 0
            v1.gulpT = 99
            v1.lastE = 0

            local v3 = 1 + math.random() * 1.5
            local v4 = math.random() * 6.28

            v1.twitchT = v3
            v1.fin = v4
            v1.gape = attr(p3, "JawGape")
            v1.sway = attr(p3, "LureSway")

            if v1.sway then
                v1.swayT = math.random() * 10
            end

            return v1
        end,
        update = function(p4, p5, p6) -- update | line: 50
            -- upvalues: p1 (copy), fightHooked (copy), attr (copy)
            local AnglerGulp = p1.AnglerGulp

            if p4.sway then
                p4.swayT += p5
                p4.sweepY = p4.sway * math.sin(AnglerGulp.SWAY_RATE * p4.swayT)
                p4.sweepP = AnglerGulp.SWAY_P * p4.sway * math.sin(2 * AnglerGulp.SWAY_RATE * p4.swayT + 0.5)
            end

            if p4.lan then
                p1.LanternSwim.update(p4, p5, p6)
            else
                p1.AnglerSwim.update(p4, p5, p6)
            end

            local model = p4.model
            local v8 = fightHooked(model)

            p4.fin += p5
            p4.twitchT -= p5

            if p4.twitchT <= 0 then
                p4.twitchT = AnglerGulp.TWITCH[1] + math.random() * (AnglerGulp.TWITCH[2] - AnglerGulp.TWITCH[1])
                p4.lpv += (math.random() < 0.5 and -1 or 1) * AnglerGulp.TWITCH_KICK
                p4.lyv += (math.random() * 2 - 1) * AnglerGulp.TWITCH_KICK

                if math.random() < AnglerGulp.GULP_CHANCE then
                    p4.gulpT = -0.25
                end
            end

            local n1 = 0.6

            if attr(model, "StrokeAt") then
                n1 = if v8 then 0.6 else (attr(model, "StrokeRate") or 0) / math.max(attr(model, "StrokeCruise") or 1, 0.001)
            end

            if AnglerGulp.STRIKE_E < n1 and p4.lastE <= AnglerGulp.STRIKE_E then
                p4.gulpT = 0
            end

            local Gulp = attr(model, "Gulp")

            if Gulp and Gulp ~= p4.lastGulp then
                p4.lastGulp = Gulp
                p4.gulpT = 0
            end

            p4.lastE = n1
            p4.gulpT += p5

            local CLOSE = AnglerGulp.CLOSE
            local n2 = 1

            if p4.gape then
                n2 = -1
                CLOSE = p4.gape
            end

            local v11 = if v8 then n2 * CLOSE * (math.sin(p6 * 8) * 0.5 + 0.5) elseif not (p4.gulpT >= 0 and p4.gulpT < AnglerGulp.GULP_T) then n2 * AnglerGulp.BREATH * (math.sin(1.1 * p4.fin) * 0.5 + 0.5) else n2 * CLOSE
            local CLOSE_EASE = if p4.gape then math.abs(v11) > math.abs(p4.close) and AnglerGulp.CLOSE_EASE or AnglerGulp.GAPE_BACK else p4.close < v11 and AnglerGulp.CLOSE_EASE or AnglerGulp.OPEN_EASE

            p4.close = p4.close + (v11 - p4.close) * math.min(1, p5 * CLOSE_EASE)
            p4.jaw.bone.Transform = CFrame.fromAxisAngle(p4.jaw.right, p4.close)
        end
    }
end
