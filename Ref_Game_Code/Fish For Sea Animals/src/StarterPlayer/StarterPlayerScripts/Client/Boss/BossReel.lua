-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local Economy = require(ReplicatedStorage.Shared.Economy)
local Remotes = require(ReplicatedStorage.Shared.Remotes)
local UIUtil = require(script.Parent.Parent.UI.UIUtil)
local Settings = require(script.Parent.Parent.UI.Settings)
local Kit = require(script.Parent.Parent.MiniGames.Kit)
local Poses = require(script.Parent.Parent.Character.Poses)
local ReelBar = require(script.Parent.Parent.Fishing.ReelBar)
local ReelClick = require(script.Parent.Parent.Fishing.ReelClick)
local BossHud = require(script.Parent.BossHud)
local BossMonsterFx = require(script.Parent.BossMonsterFx)
local BossSkin = require(script.Parent.BossSkin)
local BossJuice = require(script.Parent.BossJuice)
local LocalPlayer = Players.LocalPlayer
local t1 = {}
local Boss = Economy.Boss
local t2 = {
    0.17, 0.21, 0.26
}
local t3 = {
    {
        3,
        Color3.new(1, 1, 1)
    },
    {
        10,
        ReelBar.GOLD
    },
    {
        20,
        Color3.fromRGB(255, 150, 50)
    },
    {
        30,
        Color3.fromRGB(255, 90, 200)
    }
}
local GREEN, RED, GOLD = ReelBar.GREEN, ReelBar.RED, ReelBar.GOLD
local v1 = Color3.new(1, 1, 1)
local WIDTH = ReelBar.WIDTH
local v2, v3, v4
local v5 = false
local t4 = {
    p = 0.4,
    shown = 0.4,
    vel = 0,
    kick = 0,
    taps = 0,
    combo = 0,
    lastTap = 0,
    surgeAt = 0,
    surgeUntil = 0,
    pullFrom = 0,
    warned = false,
    lastBeat = 0,
    recent = {}
}
local t5 = {
    again = "Knocked it off the hook: cast again!",
    pose = "Reel"
}

function t5.send(p1) -- line: 54
    -- upvalues: Remotes (copy)
    Remotes.Boss:FireServer(p1)
end

function t5.monster() -- line: 57
    -- upvalues: BossSkin (copy)
    return if workspace:FindFirstChild("BossArena") then BossSkin.monster() else nil
end

t5.template = BossSkin.template

function t5.announce(p2, p3) -- line: 63
    -- upvalues: BossHud (copy)
    BossHud.announce(p2, p3)
end

function t5.phase() -- line: 66
    return workspace:GetAttribute("BossPhase") or 1
end

t5.reelHit = BossMonsterFx.reelHit
t5.surge = BossMonsterFx.surge
t5.bigHit = BossMonsterFx.bigHit

local v6 = t5
local v7

local function boss() -- line: 78
    -- upvalues: v6 (ref)
    return v6.monster()
end

local function touch() -- line: 82
    -- upvalues: UserInputService (copy)
    return UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
end

local function shake(p4) -- line: 86
    -- upvalues: Settings (copy), LocalPlayer (copy)
    local v8 = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")

    if not (v8 and Settings.get("Shake")) then
        return
    end

    task.spawn(function() -- line: 91
        -- upvalues: p4 (copy), v8 (copy)
        for i = 1, 6 do
            v8.CameraOffset = Vector3.new(math.random() - 0.5, math.random() - 0.5, 0) * p4 * (1 - i / 7)
            task.wait(0.03)
        end

        v8.CameraOffset = Vector3.new(0, 0, 0)
    end)
end

function t1.hide(p5) -- line: 101
    -- upvalues: UIUtil (copy), ReelClick (copy), v2 (ref), v3 (ref), v4 (ref), v5 (ref)
    v5 = false
    ReelClick.stop()

    if v4 then
        v4:Destroy()
        v4 = nil
    end

    if v3.root.Visible then
        task.delay(p5 or 0, function() -- line: 112
            -- upvalues: UIUtil (copy), v2 (ref), v3 (ref), v5 (ref)
            if v5 then
                return
            end

            local root = v3.root

            UIUtil.tween(root, 0.22, {
                Position = UDim2.fromScale(0.5, 1.3)
            }, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
            task.delay(0.22, function() -- line: 118
                -- upvalues: root (copy), v2 (ref), v5 (ref)
                if v5 then
                    return
                end

                root.Visible = false
                v2.Enabled = false
            end)
        end)
    else
        v2.Enabled = false
    end
end

function t1.start() -- line: 128
    -- upvalues: UserInputService (copy), UIUtil (copy), Kit (copy), Poses (copy), ReelBar (copy), ReelClick (copy), BossJuice (copy), GREEN (copy), v1 (copy), WIDTH (copy), v2 (ref), v3 (ref), v4 (ref), v5 (ref), t4 (copy), v6 (ref), shake (copy)
    v5 = true
    t4.p = 0.4
    t4.shown = 0.4
    t4.vel = 0
    t4.kick = 0
    t4.taps = 0
    t4.combo = 0
    t4.warned = false
    table.clear(t4.recent)
    t4.pullFrom = os.clock() + 1
    t4.surgeAt = os.clock() + 1 + math.random() * 2 + 2.5
    t4.surgeUntil = 0
    ReelBar.reset(v3, 0.4, nil, nil, v6.template())
    v3.hand.Visible = true
    v2.Enabled = true
    v3.root.Visible = true
    v3.root.Position = UDim2.fromScale(0.5, 1.3)
    UIUtil.tween(v3.root, 0.3, {
        Position = UDim2.fromScale(0.5, 0.86)
    }, Enum.EasingStyle.Back)
    ReelClick.reset()
    Poses.play(v6.pose or "Reel")
    v4 = UIUtil.sound("Reel", 0.4, 0.8, 60)

    if v4 then
        v4.Looped = true
    end

    UIUtil.sound("Bite", 0.7)
    UIUtil.sound("BossRoar", 0.6, 1)
    UIUtil.sound("GoodCast", 0.6, 0.9)
    BossJuice.fovPunch(4, 0.35)
    BossJuice.impactFrame(GREEN, 0.25, 0.2)
    Kit.floatText(v3.root, Vector2.new((WIDTH + 300) / 2, -40), "HOOKED IT!", GREEN, 56)
    ReelBar.prompt(v3, UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled and "TAP TAP TAP!" or "CLICK FAST!", v1)
    Kit.flash(v3.fish, v1, 0.6)
    shake(1)
end

function t1.tap() -- line: 158
    -- upvalues: UIUtil (copy), Kit (copy), ReelClick (copy), BossJuice (copy), Boss (copy), t3 (copy), GREEN (copy), v1 (copy), WIDTH (copy), v3 (ref), t4 (copy), v6 (ref)
    local elapsed = os.clock()

    if elapsed - t4.lastTap < Boss.ReelGap then
        return
    end

    t4.combo = if elapsed - t4.lastTap <= 0.4 then t4.combo + 1 else 1
    t4.lastTap = elapsed
    t4.taps += 1
    table.insert(t4.recent, elapsed)
    t4.p = math.min(1, t4.p + 0.06)
    t4.vel += 1.6
    t4.kick = 1
    v6.send("Reel")
    BossJuice.fovPunch(math.min(t4.combo, 30) * 0.04 + 0.7, 0.14)
    ReelClick.play()
    UIUtil.pop(v3.me, 1.15)
    Kit.burst(v3.bar, Vector2.new(t4.shown * WIDTH, 20), if math.random() < 0.5 then v1 else GREEN, 4, 55)

    if t4.combo >= 3 then
        local v14 = v1

        for _, v15 in t3 do
            if t4.combo >= v15[1] then
                v14 = v15[2]
            end
        end

        v3.combo.Text = ("x%*"):format(t4.combo)
        v3.combo.TextColor3 = v14
        v3.combo.Visible = true
        UIUtil.pop(v3.combo, 1.45)

        if t4.combo % 10 == 0 then
            UIUtil.sound("GoodCast", 0.5, 1 + t4.combo / 100)
            Kit.ring(v3.root, Vector2.new(65, 125), v14, 220)
            Kit.floatText(v3.root, Vector2.new((WIDTH + 300) / 2, -30), if t4.combo >= 30 then "UNSTOPPABLE!" elseif t4.combo >= 20 then "AMAZING!" else "GREAT!", v14, 48)
            BossJuice.fovPunch(2.5, 0.25)
        end
    end

    if t4.taps >= 5 then
        v3.hand.Visible = false
    end

    v6.reelHit(v6.monster(), t4.taps)
end

local function yank() -- line: 203
    -- upvalues: UIUtil (copy), Kit (copy), BossJuice (copy), t1 (copy), GOLD (copy), v1 (copy), WIDTH (copy), v3 (ref), v6 (ref), shake (copy)
    v6.send("Yank")

    local v16 = Vector2.new(WIDTH + 235, 125)

    Kit.flash(v3.fish, v1, 0.9)
    Kit.burst(v3.root, v16, GOLD, 18, 150)
    Kit.ring(v3.root, v16, v1, 280)
    UIUtil.pop(v3.fish, 1.45)
    t1.hide(0.35)
    UIUtil.sound("SubBoom", 1, 0.9)
    UIUtil.sound("GoodCast", 0.9, 1.1)
    UIUtil.sound("Whoosh", 0.8, 0.8)
    BossJuice.stamp("BIG HIT!", GOLD, 110, 0.32, 1)
    task.delay(0.3, v6.announce, {
        {
            v6.again,
            v1,
            40
        }
    }, 1.6)
    shake(2.5)
    v6.bigHit(v6.monster(), true)
end

local function snap() -- line: 220
    -- upvalues: UIUtil (copy), Kit (copy), t1 (copy), RED (copy), v1 (copy), v3 (ref), v6 (ref)
    v6.send("Snap")
    Kit.flash(v3.bar, RED, 0.9)
    Kit.shake(v3.fish, 14, 0.4)
    t1.hide(0.3)
    UIUtil.sound("Whoosh", 0.8, 1.6)
    task.delay(0.2, UIUtil.sound, "BooWomp", 0.5)
    v6.announce({
        { "LINE SNAPPED!", RED, 90 },
        { "Reel faster when it pulls!", v1, 40 }
    }, 1.6)
end

function t1.update(p6) -- line: 231
    -- upvalues: UserInputService (copy), UIUtil (copy), Kit (copy), ReelBar (copy), t2 (copy), GREEN (copy), RED (copy), GOLD (copy), v1 (copy), WIDTH (copy), v3 (ref), v4 (ref), t4 (copy), v6 (ref), boss (copy), shake (copy), yank (copy), snap (copy)
    local elapsed = os.clock()
    local v17 = v6.phase()
    local v18 = t4.surgeAt <= elapsed and elapsed < t4.surgeUntil

    if not t4.warned and t4.surgeAt - 0.55 <= elapsed and elapsed < t4.surgeAt then
        t4.warned = true
        v3.warn.Visible = true
        UIUtil.pop(v3.warn, 2.2)
        UIUtil.sound("Click", 0.5, 0.6)
    end

    if not (t4.surgeAt <= elapsed and t4.surgeUntil < t4.surgeAt) then
        if t4.surgeUntil > t4.surgeAt and t4.surgeUntil <= elapsed then
            t4.surgeAt = elapsed + math.random() * 2.5 + 2.2
        end
    else
        t4.surgeUntil = elapsed + 0.8
        t4.warned = false
        v3.warn.Visible = false
        t4.vel -= 1.4
        shake(1.2)
        Kit.flash(v3.bar, RED, 0.6)
        Kit.shake(v3.fish, 9, 0.3)
        UIUtil.sound("Splash", 0.7, 0.7)
        UIUtil.sound("BossGrowl", 0.7, 0.9)
        v18 = true
        v6.surge(boss())
    end

    if t4.pullFrom <= elapsed then
        t4.p = t4.p - t2[v17] * (v18 and 3 or 1) * p6
    end

    while t4.recent[1] and elapsed - t4.recent[1] > 1 do
        table.remove(t4.recent, 1)
    end

    if v4 then
        v4.PlaybackSpeed = math.min(#t4.recent, 10) * 0.06 + 0.8
    end

    t4.vel += (t4.p - t4.shown) * 220 * p6
    t4.vel = t4.vel * math.exp(p6 * -16)
    t4.shown += t4.vel * p6

    local v24 = math.clamp(t4.shown, 0, 1)

    ReelBar.place(v3, v24, t4.kick, elapsed)
    v3.spark.Rotation = 45 + elapsed * (#t4.recent * 60 + 200)
    v3.me.Rotation = -t4.kick * 8
    v3.fish.Rotation = math.sin(elapsed * 10) * 7 * ((v18 or t4.warned) and 2.5 or 1)

    if v3.hand.Visible then
        v3.hand.Position = UDim2.fromOffset(150 + v24 * WIDTH, 150 - math.abs((math.sin(elapsed * 7))) * 14)
    end

    t4.kick = math.max(0, t4.kick - p6 * 6)

    if t4.p < 0.2 and t4.pullFrom <= elapsed then
        local v31 = math.sin(elapsed * 18) * 0.5 + 0.5

        v3.mine.BackgroundColor3 = GREEN:Lerp(RED, v31 * 0.5 + 0.4)

        if elapsed - t4.lastBeat > 0.22 + t4.p * 1.2 then
            t4.lastBeat = elapsed
            UIUtil.sound("Tick", 0.45, 0.45)
            Kit.flash(v3.bar, RED, 0.35)
        end

        ReelBar.prompt(v3, "IT'S GETTING AWAY!", RED)
    else
        v3.mine.BackgroundColor3 = GREEN

        local warned = if not v18 then t4.warned else nil

        if v18 or warned then
            ReelBar.prompt(v3, "HOLD ON!", RED)
        elseif t4.p > 0.8 then
            ReelBar.prompt(v3, "ALMOST!", GOLD)
        else
            ReelBar.prompt(v3, UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled and "TAP TAP TAP!" or "CLICK FAST!", v1)
        end
    end

    if not (t4.p >= 0.985 or t4.shown >= 1 and t4.p >= 0.9) then
        if t4.p <= 0 then
            snap()

            return "Snap"
        end

        t4.p = math.min(t4.p, 1)

        return nil
    end

    yank()

    return "Yank"
end

function t1.init(p7) -- line: 311
    -- upvalues: ReelBar (copy), v2 (ref), v3 (ref), v7 (ref)
    v2 = p7
    v7 = p7
    v3 = ReelBar.get(v2)
end

function t1.use(p8, p9) -- line: 320
    -- upvalues: ReelBar (copy), t1 (copy), v2 (ref), v3 (ref), v5 (ref), t5 (copy), v6 (ref), v7 (ref)
    if v5 then
        t1.hide()
    end

    v6 = p8 or t5

    local v33 = if p8 then p9 else v7

    if v33 and v33 ~= v2 then
        v2 = v33
        v3 = ReelBar.get(v2)
    end
end

return t1
