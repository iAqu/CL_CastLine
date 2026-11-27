-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local UIUtil = require(script.Parent.Parent.UI.UIUtil)
local Settings = require(script.Parent.Parent.UI.Settings)
local Poses = require(script.Parent.Parent.Character.Poses)
local HullRig = require(script.Parent.Parent.Boss.HullRig)
local TripUi = require(script.Parent.TripUi)
local TripSet = require(script.Parent.TripSet)
local TripDizzy = require(script.Parent.TripDizzy)
local TripShots = require(script.Parent.TripShots)
local t1 = {}

local function lerp(p1, p2, p3) -- line: 21
    return p1 + (p2 - p1) * p3
end

local function loop(p4, p5, p6) -- line: 26
    -- upvalues: UIUtil (copy)
    local v1 = UIUtil.sound(p4, p5, p6, 300)

    if v1 then
        v1.Looped = true
    end

    return v1
end

local function waitFor(p7, p8, p9) -- line: 35
    -- upvalues: RunService (copy)
    while p8() < p9 and not p7.skipped() do
        RunService.RenderStepped:Wait()
    end
end

function t1.play(p10) -- line: 41
    -- upvalues: RunService (copy), Lighting (copy), UIUtil (copy), Settings (copy), Poses (copy), HullRig (copy), TripUi (copy), TripSet (copy), TripDizzy (copy), TripShots (copy), waitFor (copy)
    local folder = p10.folder

    TripSet.build(folder)

    local v2 = TripSet.monster(folder)
    local v3 = TripSet.snow(folder)

    p10.ungrade = TripSet.grade()

    local camera, sub, root, character = p10.camera, p10.sub, p10.root, p10.character
    local Head = character:FindFirstChild("Head")
    local v4 = TripShots.paths(p10)
    local n1 = -2.8
    local n2 = 0

    local function clock() -- line: 55
        -- upvalues: n1 (ref)
        return n1
    end

    local t2 = {}

    local function at(p11, p12, p13) -- line: 59
        -- upvalues: n1 (ref), t2 (copy)
        if p11 <= n1 and not t2[p12] then
            t2[p12] = true
            p13()
        end
    end

    local v5 = UIUtil.sound("BubbleSwell", 0.35, 0.8, 300)

    if v5 then
        v5.Looped = true
    end

    local v6 = UIUtil.sound("Reel", 0.12, 0.3, 300)

    if v6 then
        v6.Looped = true
    end

    local v7 = UIUtil.sound("LuckHeartbeat", 0, 1, 300)

    if v7 then
        v7.Looped = true
    end

    local t3 = {
        shake = 0,
        glowWas = {}
    }
    local v8 = TripDizzy.stars(folder, 5)
    local v9 = TripDizzy.birds(folder, 3)

    TripDizzy.showBirds(v9, false)

    for _, v10 in v8 do
        v10.Parent = nil
    end

    local n3 = 0
    local v11
    local n4 = 0
    local DepthOfFieldEffect = Instance.new("DepthOfFieldEffect")

    DepthOfFieldEffect.FarIntensity = 0
    DepthOfFieldEffect.NearIntensity = 0
    DepthOfFieldEffect.FocusDistance = 50
    DepthOfFieldEffect.InFocusRadius = 30
    DepthOfFieldEffect.Parent = Lighting
    p10.dof = DepthOfFieldEffect

    local Atmosphere = Lighting:FindFirstChildOfClass("Atmosphere")

    if Atmosphere then
        local t4 = {
            Density = Atmosphere.Density,
            Offset = Atmosphere.Offset,
            Haze = Atmosphere.Haze,
            Color = Atmosphere.Color,
            Decay = Atmosphere.Decay,
            Glare = Atmosphere.Glare
        }

        p10.unfog = function() -- line: 88
            -- upvalues: Atmosphere (copy), t4 (copy)
            for v12, v13 in t4 do
                Atmosphere[v12] = v13
            end
        end
    end

    TripUi.letterbox(true, 0.01)
    root.Anchored = true
    Poses.play("Doze")

    local v14 = TripSet.bubble(Head, "Zzz", Color3.fromRGB(200, 220, 255), 2.2, (Vector3.new(1.5, 2, 0)))
    local connection = RunService.RenderStepped:Connect(function(p14) -- line: 99
        -- upvalues: p10 (copy), folder (copy), v2 (copy), v3 (copy), camera (copy), sub (copy), root (copy), character (copy), Head (copy), v4 (copy), n1 (ref), n2 (ref), t2 (copy), v5 (copy), v6 (copy), v7 (copy), t3 (copy), v8 (copy), v9 (copy), n3 (ref), v11 (ref), n4 (ref), DepthOfFieldEffect (copy), Atmosphere (copy), v14 (copy), UIUtil (copy), Settings (copy), Poses (copy), HullRig (copy), TripUi (copy), TripSet (copy), TripDizzy (copy), TripShots (copy)
        if n2 > 0 then
            n2 -= p14
        else
            n1 += p14

            local v15 = v4.sub(n1)

            p10.subCF = v15
            n4 += v4.spinRate(n1) * p14
            TripSet.placeSub(sub, v15, n4, 0)

            if sub.bubbles then
                sub.bubbles.Rate = v4.spinRate(n1) * 8
            end

            root.CFrame = TripSet.seat(sub, v15) * CFrame.new(0, p10.sitAbove, 0)

            local v18, v19 = v4.monster(n1)

            if v2 then
                HullRig.pose(v2.rig, v18, n1, v19)
            end

            v3.CFrame = camera.CFrame

            local v20, v21, v22 = TripShots.camera(n1, p10, v15, v18, Head.Position)

            t3.shake = math.max(0, t3.shake - p14 * 2.5)

            if t3.shake > 0 and Settings.get("Shake") then
                v20 *= CFrame.new((math.random() - 0.5) * t3.shake, (math.random() - 0.5) * t3.shake, 0) * CFrame.Angles(0, 0, (math.random() - 0.5) * t3.shake * 0.02)
            end

            camera.CFrame = v20
            camera.Focus = v20
            camera.FieldOfView = v21

            if v22 then
                DepthOfFieldEffect.FarIntensity = 0.35
                DepthOfFieldEffect.FocusDistance = v22
            else
                DepthOfFieldEffect.FarIntensity = 0
            end

            if n1 > 33.8 and v2 and v2.head then
                local v24 = (v18 * CFrame.new(0, TripShots.CENTER_UP, 40)).Position + Vector3.new(0, 58, 0)

                for v25, v26 in v8 do
                    local v27 = n1 * 2.4 + v25 * (6.283185307179586 / #v8)

                    v26.CFrame = CFrame.new(v24 + Vector3.new(math.cos(v27) * 26, math.sin(v27 * 2) * 3, math.sin(v27) * 26))
                    v26.Parent = folder
                end

                for v32, v33 in v9 do
                    local v34 = -n1 * 1.9 + v32 * (6.283185307179586 / #v9) + 0.5
                    local v39 = v24 + Vector3.new(math.cos(v34) * 24, math.sin(v34 * 3) * 3 + 4, math.sin(v34) * 24)
                    local v44 = v24 + Vector3.new(math.cos(v34 - 0.2) * 24, 4, math.sin(v34 - 0.2) * 24)

                    TripDizzy.placeBird(v33, CFrame.lookAt(v39, v44), n1 + v32)
                end

                if not t2.birds then
                    t2.birds = true
                    TripDizzy.showBirds(v9, true)
                end

                n3 -= p14

                if n3 <= 0 then
                    n3 = 0.45
                    UIUtil.sound("LuckTick", 0.25, 1.8 + math.random() * 0.4)
                end
            end

            if v11 then
                v11(p14)
            end

            if v7 then
                local v45 = if n1 < 11 then 0
                    elseif n1 < 14.5 then 2
                    elseif n1 < 15.1 then 0
                    elseif n1 < 33.2 then 4
                    else math.max(0, 4 - (n1 - 33.2) * 3.5)
                local Volume = v7.Volume
                local v48 = 1 - math.exp(-p14 * 4)

                v7.Volume = Volume + (v45 - Volume) * v48
                v7.PlaybackSpeed = if n1 < 22 then 1 else math.clamp((n1 - 22.6) / 10, 0, 1) * 0.9 + 1
            end

            local v51 = if not (n1 > 14.5 and n1 < 15.1) then 0.35 else 0

            if v5 then
                local Volume = v5.Volume
                local v53 = 1 - math.exp(-p14 * 12)

                v5.Volume = Volume + (v51 - Volume) * v53
            end

            if v6 then
                v6.Volume = if not (n1 > 14.5 and n1 < 15.1) then 0.12 + v4.spinRate(n1) / 120 else 0
                v6.PlaybackSpeed = 0.3 + v4.spinRate(n1) / 60
            end

            local v55 = n1 > 15.4 and n1 < 33.2

            for _, v56 in sub.pieces do
                if v56.name:find("Glow") then
                    local part = v56.part

                    if t3.glowWas[part] == nil then
                        t3.glowWas[part] = part.Color
                    end

                    if v55 and n1 * 3 % 1 < 0.5 then
                        part.Color = Color3.fromRGB(255, 40, 40)
                    else
                        part.Color = t3.glowWas[part]
                    end
                end
            end

            local function v57() -- line: 193
                -- upvalues: TripUi (copy)
                task.spawn(TripUi.fade, false, 1.4)
            end

            if n1 >= 0 and not t2["fade in"] then
                t2["fade in"] = true
                task.spawn(TripUi.fade, false, 1.4)
            end

            local function v58() -- line: 196
                -- upvalues: UIUtil (copy)
                UIUtil.sound("Snore", 0.6)
            end

            if n1 >= 0.6 and not t2.snore1 then
                t2.snore1 = true
                UIUtil.sound("Snore", 0.6)
            end

            local function v59() -- line: 199
                -- upvalues: UIUtil (copy)
                UIUtil.sound("Snore", 0.55, 0.95)
            end

            if n1 >= 4.6 and not t2.snore2 then
                t2.snore2 = true
                UIUtil.sound("Snore", 0.55, 0.95)
            end

            local function v60() -- line: 202
                -- upvalues: UIUtil (copy)
                UIUtil.sound("Snore", 0.5, 0.95)
            end

            if n1 >= 7.2 and not t2.snore3 then
                t2.snore3 = true
                UIUtil.sound("Snore", 0.5, 0.95)
            end

            local function v61() -- line: 205
                -- upvalues: UIUtil (copy)
                UIUtil.sound("BossGrowl", 0.5, 0.4)
                UIUtil.sound("Rumble", 0.5, 0.5)
            end

            if n1 >= 8.6 and not t2.shape then
                t2.shape = true
                UIUtil.sound("BossGrowl", 0.5, 0.4)
                UIUtil.sound("Rumble", 0.5, 0.5)
            end

            local function v62() -- line: 209
                -- upvalues: UIUtil (copy)
                UIUtil.sound("TripJumpscare", 1)
            end

            if n1 >= 9.4 and not t2["first sight"] then
                t2["first sight"] = true
                UIUtil.sound("TripJumpscare", 1)
            end

            if n1 >= 12 and not t2.shadow then
                t2.shadow = true
                TripUi.shadowSweep(1.9)
                UIUtil.sound("Rumble", 0.7, 0.4)
                task.spawn(function() -- line: 218
                    -- upvalues: sub (copy)
                    for i = 1, 6 do
                        for _, v63 in sub.beams do
                            v63.Enabled = i % 2 == 0
                        end

                        task.wait(0.08 + math.random() * 0.12)
                    end

                    for _, v64 in sub.beams do
                        v64.Enabled = false
                    end
                end)
            end

            if n1 >= 13.6 and not t2.snore4 then
                t2.snore4 = true

                for _, v65 in sub.beams do
                    v65.Enabled = true
                end

                UIUtil.sound("Snore", 0.55, 0.9)
            end

            local function v66() -- line: 236
                -- upvalues: Head (copy), t3 (copy), v14 (copy), UIUtil (copy), Poses (copy), TripSet (copy)
                if v14 then
                    v14:Destroy()
                end

                Poses.play("Startle")
                UIUtil.sound("TripGasp", 1)
                TripSet.bubble(Head, "!", Color3.fromRGB(255, 80, 80), 2.6, (Vector3.new(0, 2.6, 0)))
                t3.shake = 0.6
            end

            if n1 >= 15.1 and not t2.wake then
                t2.wake = true
                v66()
            end

            local function v67() -- line: 246
                -- upvalues: UIUtil (copy)
                UIUtil.sound("TripShocked", 1)
            end

            if n1 >= 15.6 and not t2.shocked then
                t2.shocked = true
                UIUtil.sound("TripShocked", 1)
            end

            local function v68() -- line: 249
                -- upvalues: UIUtil (copy)
                UIUtil.sound("Rumble", 0.8, 0.6)
            end

            if n1 >= 16.6 and not t2.rise then
                t2.rise = true
                UIUtil.sound("Rumble", 0.8, 0.6)
            end

            if n1 >= 17 and not t2.roar then
                t2.roar = true
                UIUtil.sound("BossFirstRoar", 1, 0.8, 10)
                t3.shake = 1.4
            end

            local function v69() -- line: 256
                -- upvalues: Head (copy), UIUtil (copy), Poses (copy)
                for _, child in Head:GetChildren() do
                    if child:IsA("BillboardGui") then
                        child:Destroy()
                    end
                end

                Poses.play("Steer")
                UIUtil.sound("MetalClang", 0.6, 1.3)
                UIUtil.sound("Whoosh", 0.5, 0.8)
            end

            if n1 >= 19.8 and not t2.scramble then
                t2.scramble = true
                v69()
            end

            local function v70() -- line: 266
                -- upvalues: UIUtil (copy)
                UIUtil.sound("LuckTick", 0.5, 1.2)
                UIUtil.sound("LuckTick", 0.4, 1.6)
            end

            if n1 >= 21.2 and not t2.spot then
                t2.spot = true
                UIUtil.sound("LuckTick", 0.5, 1.2)
                UIUtil.sound("LuckTick", 0.4, 1.6)
            end

            local function v71() -- line: 270
                -- upvalues: UIUtil (copy)
                UIUtil.sound("SubBoom", 0.8, 0.7)
                UIUtil.sound("BossRoar", 0.8, 0.9)
            end

            if n1 >= 22.6 and not t2.go then
                t2.go = true
                UIUtil.sound("SubBoom", 0.8, 0.7)
                UIUtil.sound("BossRoar", 0.8, 0.9)
            end

            for v72, v73 in TripShots.CHASE_CUTS do
                local v74 = "cut" .. v72;

                ({})[1] = v72

                if v73 <= n1 and not t2[v74] then
                    t2[v74] = true
                    UIUtil.sound("Whoosh", 0.25 + v72 * 0.03, 0.9 + v72 * 0.05)

                    if v72 % 2 == 0 then
                        UIUtil.sound("BossGrowl", 0.35, 0.8 + v72 * 0.04)
                    end
                end
            end

            if n1 >= 26.9 and not t2["roar mid-chase"] then
                t2["roar mid-chase"] = true
                UIUtil.sound("BossRoar", 1, 0.85, 10)
                t3.shake = 1
            end

            if n1 >= 31.2 and not t2.jaws then
                t2.jaws = true
                UIUtil.sound("BossRoar", 1, 0.75, 10)
                t3.shake = 0.8
            end

            local function v75() -- line: 292
                -- upvalues: folder (copy), n2 (ref), t3 (copy), v11 (ref), UIUtil (copy), TripUi (copy), TripSet (copy)
                n2 = 0.14
                TripUi.flash(Color3.new(1, 1, 1), 0.35, 0.1)
                UIUtil.sound("TripBonk", 1.5)
                UIUtil.sound("SubBoom", 0.7, 0.6)
                UIUtil.sound("BossExplosion", 0.4, 0.8)
                t3.shake = 2
                v11 = TripSet.debris(folder, Vector3.new(TripSet.CLIFF_X - 4, -1050, TripSet.CRACK_Z), Vector3.new(-1, 0, 0), 26)
            end

            if n1 >= 33.2 and not t2.crash then
                t2.crash = true
                v75()
            end

            local function v77() -- line: 302
                -- upvalues: UIUtil (copy)
                UIUtil.sound("TripDizzy", 1)
            end

            if n1 >= 33.8 and not t2.dizzy then
                t2.dizzy = true
                UIUtil.sound("TripDizzy", 1)
            end

            local LAUGH = TripShots.LAUGH

            local function v78() -- line: 306
                -- upvalues: UIUtil (copy), Poses (copy)
                Poses.play("Laugh")
                UIUtil.sound("Laugh", 0.8, 1)
            end

            if LAUGH <= n1 and not t2.laugh then
                t2.laugh = true
                Poses.play("Laugh")
                UIUtil.sound("Laugh", 0.8, 1)
            end

            if TripShots.CALL <= n1 and not t2.call then
                t2.call = true

                local v79 = UIUtil.sound("TripCall", 0.6, 1, 300)

                p10.call = v79

                if v79 then
                    v79.Ended:Once(function() -- line: 316
                        -- upvalues: v79 (copy), p10 (copy), UIUtil (copy)
                        if p10.call ~= v79 then
                            return
                        end

                        local Volume = v79.Volume
                        local v80 = UIUtil.sound("TripCall2", Volume, 1, 300)

                        if v80 then
                            v80.Looped = true
                        end

                        p10.call = v80
                    end)
                end
            end

            local TURN = TripShots.TURN

            local function v81() -- line: 325
                -- upvalues: Atmosphere (copy), UIUtil (copy), Poses (copy)
                Poses.play("LookAhead")

                if Atmosphere then
                    UIUtil.tween(Atmosphere, 3, {
                        Density = 0.6,
                        Offset = 0,
                        Haze = 2.4
                    }, Enum.EasingStyle.Sine)
                end
            end

            if TURN <= n1 and not t2.turn then
                t2.turn = true
                v81()
            end

            local WORRY = TripShots.WORRY

            local function v82() -- line: 332
                -- upvalues: p10 (copy), character (copy), Head (copy), UIUtil (copy), TripSet (copy), TripDizzy (copy)
                p10.unworry = TripDizzy.worried(character)
                TripSet.bubble(Head, "?", Color3.fromRGB(255, 230, 90), 2.8, (Vector3.new(0, 2.8, 0)))
                UIUtil.sound("LuckTick", 0.4, 0.7)
            end

            if WORRY <= n1 and not t2.worry then
                t2.worry = true
                v82()
            end

            local DRIVE = TripShots.DRIVE

            local function v83() -- line: 338
                -- upvalues: Head (copy), UIUtil (copy), Poses (copy)
                for _, child in Head:GetChildren() do
                    if child:IsA("BillboardGui") then
                        child:Destroy()
                    end
                end

                Poses.play("Drive")
                UIUtil.sound("SubBoom", 0.4, 0.6)
            end

            if DRIVE <= n1 and not t2.drive then
                t2.drive = true
                v83()
            end

            local EXIT = TripShots.EXIT

            local function v84() -- line: 348
                -- upvalues: Atmosphere (copy), UIUtil (copy), TripUi (copy), TripShots (copy)
                if Atmosphere then
                    UIUtil.tween(Atmosphere, TripShots.END - TripShots.EXIT, {
                        Density = 0.45,
                        Glare = 1,
                        Color = Color3.fromRGB(190, 230, 255),
                        Decay = Color3.fromRGB(150, 210, 255)
                    }, Enum.EasingStyle.Sine)
                end

                UIUtil.sound("Whoosh", 0.6, 0.7)
                UIUtil.sound("BubbleSwell", 0.5, 1.1)
                task.spawn(TripUi.wash, true, TripShots.END - TripShots.EXIT)
            end

            if EXIT <= n1 and not t2.exit then
                t2.exit = true
                v84()
            end
        end
    end)

    waitFor(p10, clock, TripShots.END)
    connection:Disconnect()

    for _, v85 in { v5, v6, v7 } do
        if v85 then
            v85:Destroy()
        end
    end

    for v86, v87 in t3.glowWas do
        v86.Color = v87
    end

    if p10.unfog then
        p10.unfog()
        p10.unfog = nil
    end

    for _, child in Head:GetChildren() do
        if child:IsA("BillboardGui") then
            child:Destroy()
        end
    end

    for _, child in folder:GetChildren() do
        if child ~= sub.model then
            child:Destroy()
        end
    end

    if v2 then
        v2.model:Destroy()
    end
end

return t1
