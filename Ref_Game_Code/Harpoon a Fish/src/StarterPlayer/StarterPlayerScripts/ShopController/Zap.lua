-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local TweenService = game:GetService("TweenService")
local t1 = {}
local t2 = {
    START = 0.3,
    DIP = 0.55,
    HOLD = 0.06,
    OUT = 0.18,
    FLARE = 0.4,
    FLARE_OUT = 0.35,
    POOL = 8,
    FLASHES = 4,
    Z = 7,
    EVERY = { 0.14, 0.32 },
    STORM_EVERY = { 1.6, 2.6 },
    STORM = { 3, 5 },
    SIZE = { 0.75, 1.05 },
    FLASH = { 0.22, 0.34 },
    FLICKER = { 0.03, 0.04, 0.05 }
}
local v1 = Random.new()

local function range(p1) -- line: 44
    -- upvalues: v1 (copy)
    return v1:NextNumber(p1[1], p1[2])
end

local function sprite(p2, p3, p4) -- line: 46
    -- upvalues: t2 (copy)
    local ImageLabel = Instance.new("ImageLabel")

    ImageLabel.BackgroundTransparency = 1
    ImageLabel.Image = p4.sheet or "rbxassetid://123415582755900"
    ImageLabel.ImageRectSize = Vector2.new(341, 341)
    ImageLabel.ImageRectOffset = Vector2.new((p3 - 1) % 3 * 341, (p3 - 1) // 3 * 341)
    ImageLabel.AnchorPoint = Vector2.new(0.5, 0.5)
    ImageLabel.ImageTransparency = 1
    ImageLabel.Visible = false
    ImageLabel.ZIndex = p4.z or t2.Z

    local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")

    UIAspectRatioConstraint.AspectRatio = 1
    UIAspectRatioConstraint.DominantAxis = Enum.DominantAxis.Height
    UIAspectRatioConstraint.Parent = ImageLabel
    ImageLabel.Parent = p2

    return ImageLabel
end

function t1.Run(p5, p6, p7, p8, p9) -- line: 65
    -- upvalues: TweenService (copy), t2 (copy), v1 (copy), sprite (copy)
    local v2 = p9

    p9 = p9 or {}
    v2 = p9

    local t3 = {}
    local t4 = {}

    for i = 1, t2.POOL do
        t3[i] = {
            busy = false,
            gui = sprite(p5, 1, p9)
        }
    end

    for i = 1, t2.FLASHES do
        t4[i] = {
            busy = false,
            gui = sprite(p5, 9, p9)
        }
    end

    local v4 = p7 and p7.ImageTransparency

    local function free(p10) -- line: 71
        for _, v5 in ipairs(p10) do
            if not v5.busy then
                return v5
            end
        end
    end

    local function startPoint() -- line: 74
        -- upvalues: p5 (copy), p6 (copy), t2 (copy), v1 (copy)
        local AbsolutePosition, AbsoluteSize = p5.AbsolutePosition, p5.AbsoluteSize
        local v6 = p6.AbsolutePosition + p6.AbsoluteSize / 2 - AbsolutePosition
        local v7 = p6.AbsoluteSize / 2
        local v8 = v6 + Vector2.new(v1:NextNumber(-1, 1) * v7.X, v1:NextNumber(-1, 1) * v7.Y) * t2.START

        return UDim2.fromScale(v8.X / AbsoluteSize.X, v8.Y / AbsoluteSize.Y)
    end

    local function show(p11, p12, p13, p14) -- line: 81
        -- upvalues: TweenService (copy), t2 (copy)
        local gui = p11.gui

        p11.busy = true
        gui.Size = UDim2.fromScale(1, p12)
        gui.Rotation = p13
        gui.ImageTransparency = 1
        gui.Visible = true

        local FLICKER = t2.FLICKER

        TweenService:Create(gui, TweenInfo.new(FLICKER[1]), {
            ImageTransparency = p14
        }):Play()
        task.delay(FLICKER[1], function() -- line: 90
            -- upvalues: p14 (copy), gui (copy), FLICKER (copy), TweenService (copy), t2 (copy)
            gui.ImageTransparency = math.max(p14, t2.DIP)
            TweenService:Create(gui, TweenInfo.new(FLICKER[3]), {
                ImageTransparency = p14
            }):Play()
        end)
        task.delay(FLICKER[1] + FLICKER[2] + FLICKER[3] + t2.HOLD, function() -- line: 94
            -- upvalues: p11 (copy), gui (copy), TweenService (copy), t2 (copy)
            local tween = TweenService:Create(gui, TweenInfo.new(t2.OUT, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                ImageTransparency = 1
            })

            tween.Completed:Once(function() -- line: 96
                -- upvalues: p11 (copy), gui (copy)
                gui.Visible = false
                p11.busy = false
            end)
            tween:Play()
        end)
    end

    local function strike() -- line: 100
        -- upvalues: p5 (copy), p7 (copy), t3 (copy), t4 (copy), startPoint (copy), show (copy), v4 (copy), TweenService (copy), t2 (copy), v1 (copy)
        if p5.AbsoluteSize.Y < 2 then
            return
        end

        local v10 = false
        local v11

        for _, v12 in ipairs(t3) do
            if not v12.busy then
                v11 = v12
                v10 = true
                break
            end
        end

        if not v10 then
            v11 = nil
        end

        if not v11 then
            return
        end

        local v13 = startPoint()
        local v14 = v1:NextInteger(1, 8)

        v11.gui.ImageRectOffset = Vector2.new((v14 - 1) % 3 * 341, (v14 - 1) // 3 * 341)
        v11.gui.Position = v13

        local SIZE = t2.SIZE

        show(v11, v1:NextNumber(SIZE[1], SIZE[2]), v1:NextNumber(0, 360), 0)

        local v15 = false
        local v16

        for _, v17 in ipairs(t4) do
            if not v17.busy then
                v16 = v17
                v15 = true
                break
            end
        end

        if not v15 then
            v16 = nil
        end

        if v16 then
            v16.gui.Position = v13

            local FLASH = t2.FLASH

            show(v16, v1:NextNumber(FLASH[1], FLASH[2]), 0, 0.15)
        end

        if p7 then
            p7.ImageTransparency = math.max(0, v4 - t2.FLARE)
            TweenService:Create(p7, TweenInfo.new(t2.FLARE_OUT, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                ImageTransparency = v4
            }):Play()
        end
    end

    local v19 = p9.pace or 1
    local v20 = p9.storm or t2.STORM

    task.spawn(function() -- line: 123
        -- upvalues: v2 (ref), p5 (copy), p7 (copy), p8 (copy), t3 (copy), t4 (copy), strike (copy), v4 (copy), v19 (copy), v20 (copy), t2 (copy), v1 (copy)
        local elapsed = os.clock()
        local STORM_EVERY = t2.STORM_EVERY
        local v21 = elapsed + v1:NextNumber(STORM_EVERY[1], STORM_EVERY[2]) * v19

        while p8() do
            local v22 = v21

            if p5.Visible and (not v2.shown or v2.shown()) then
                if v21 <= os.clock() then
                    for _ = 1, v1:NextInteger(v20[1], v20[2]) do
                        strike()
                    end

                    local elapsed = os.clock()
                    local STORM_EVERY = t2.STORM_EVERY

                    v22 = elapsed + v1:NextNumber(STORM_EVERY[1], STORM_EVERY[2]) * v19
                else
                    strike()
                end
            end

            v21 = v22

            local wait = task.wait
            local EVERY = t2.EVERY

            wait(v1:NextNumber(EVERY[1], EVERY[2]) * v19)
        end

        for _, v24 in ipairs(t3) do
            v24.gui:Destroy()
        end

        for _, v25 in ipairs(t4) do
            v25.gui:Destroy()
        end

        if p7 then
            p7.ImageTransparency = v4
        end
    end)
end

return t1
