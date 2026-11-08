-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Debris = game:GetService("Debris")
local GuiService = game:GetService("GuiService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")

game:GetService("StarterGui")

local TweenService = game:GetService("TweenService")
local Audio = require(ReplicatedStorage.Shared.Audio)
local GUI = require(ReplicatedStorage.Client.GUI)

require(ReplicatedStorage.Packages.Trove)

local BeanstalkEvent = ReplicatedStorage.Assets.Sounds.BeanstalkEvent
local v1 = Color3.fromRGB(255, 60, 80)
local v2 = Color3.fromRGB(70, 70, 82)
local v3 = Color3.new(1, 1, 1)
local t1 = {}
local n1 = 0
local n2 = 0
local n3 = 0
local v4, v5

local function card() -- line: 53
    -- upvalues: GUI (copy), v4 (ref)
    return v4 or GUI.BeanstalkEventUI().WhaleProgress
end

local function tween(p1, p2, p3, p4, p5) -- line: 61
    -- upvalues: TweenService (copy)
    local tween = TweenService:Create(p1, TweenInfo.new(p2, p4 or Enum.EasingStyle.Quad, p5 or Enum.EasingDirection.Out), p3)

    tween:Play()

    return tween
end

local function scaleOf(p6) -- line: 81
    local UIScale = p6:FindFirstChildOfClass("UIScale")

    if not UIScale then
        UIScale = Instance.new("UIScale")
        UIScale.Parent = p6
    end

    return UIScale
end

local function play(p7, p8) -- line: 90
    -- upvalues: Debris (copy), SoundService (copy), Audio (copy), v4 (ref), v5 (ref)
    if v4 then
        local v6 = Audio.Play(p7, SoundService, {
            SoundGroup = "SFX",
            PlaybackSpeed = p8 or p7.PlaybackSpeed
        })

        if v6 and v5 then
            v5:Add(v6)
        end
    elseif p8 ~= nil then
        local clone = p7:Clone()

        clone.PlaybackSpeed = p8
        clone.Parent = SoundService
        clone:Play()
        Debris:AddItem(clone, clone.TimeLength / p8 + 0.5)
    else
        SoundService:PlayLocalSound(p7)
    end
end

local function setFull(p9, p10) -- line: 109
    -- upvalues: v1 (copy), v2 (copy)
    if p10 then
        p9.ImageColor3 = v1
    else
        p9.ImageColor3 = v2
    end

    p9.ImageTransparency = p10 and 0 or 0.25
end

local function shatter(p11) -- line: 145
    -- upvalues: Debris (copy), TweenService (copy), GUI (copy), v1 (copy), v3 (copy), v4 (ref), v5 (ref)
    local HeartsFx = (v4 or GUI.BeanstalkEventUI().WhaleProgress).HeartsFx
    local HeartBreak, AbsolutePosition, AbsoluteSize = HeartsFx.HeartBreak, HeartsFx.AbsolutePosition, HeartsFx.AbsoluteSize

    if not (AbsoluteSize.X <= 0) and not (AbsoluteSize.Y <= 0) then
        local clone = HeartBreak:Clone()

        clone.Visible = true
        clone.AnchorPoint = Vector2.new(0.5, 0.5)

        local v7 = p11.AbsolutePosition + p11.AbsoluteSize * 0.5 - AbsolutePosition

        clone.Position = UDim2.fromScale(v7.X / AbsoluteSize.X, v7.Y / AbsoluteSize.Y)
        clone.Size = UDim2.fromScale(p11.AbsoluteSize.X / AbsoluteSize.X, p11.AbsoluteSize.Y / AbsoluteSize.Y)
        clone.Parent = HeartsFx

        if v5 then
            v5:Add(clone)
        end

        for _, v8 in {
                clone.Left,
                clone.Right
            } do
            local v9 = if v8 == clone.Left then -1 else 1
            local ImageLabel = v8:FindFirstChildOfClass("ImageLabel")

            ImageLabel.ImageColor3 = v3

            local t3 = {
                ImageColor3 = v1
            }

            TweenService:Create(ImageLabel, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t3):Play()

            local Position = v8.Position
            local v10 = UDim2.fromScale(Position.X.Scale + v9 * 0.55, Position.Y.Scale)
            local t4 = {
                Position = v10,
                Rotation = v9 * 48
            }
            local Quad = Enum.EasingStyle.Quad

            TweenService:Create(v8, TweenInfo.new(0.65, Quad or Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t4):Play()

            local tween = TweenService:Create(v8, TweenInfo.new(0.65, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                Position = UDim2.fromScale(v10.X.Scale, Position.Y.Scale + 1.6)
            })

            task.delay(0.1625, function() -- line: 181
                -- upvalues: v8 (copy), tween (copy)
                if v8.Parent then
                    tween:Play()
                end
            end)

            local t5 = {
                GroupTransparency = 1
            }
            local Quad2 = Enum.EasingStyle.Quad
            local In = Enum.EasingDirection.In

            TweenService:Create(v8, TweenInfo.new(0.65, Quad2 or Enum.EasingStyle.Quad, In or Enum.EasingDirection.Out), t5):Play()
        end

        Debris:AddItem(clone, 0.8450000000000001)
    end
end

return {
    Show = function(p12, p13, p14) -- Show | line: 199
        -- upvalues: TweenService (copy), GUI (copy), v1 (copy), t1 (copy), n1 (ref), n2 (ref), n3 (ref), v4 (ref), v5 (ref)
        n3 += 1

        local v11 = n3

        v4 = p14
        v5 = p12

        local Hearts = (v4 or GUI.BeanstalkEventUI().WhaleProgress).Hearts
        local Heart = Hearts.Heart

        Heart.Visible = false
        n2 += 1

        for _, v12 in t1 do
            local UIScale = v12:FindFirstChildOfClass("UIScale")

            if UIScale then
                UIScale.Scale = 1
            end
        end

        for _, v13 in t1 do
            v13:Destroy()
        end

        table.clear(t1)

        for i = 1, p13 do
            local clone = Heart:Clone()

            clone.Name = ("Heart%*"):format(i)
            clone.LayoutOrder = i
            clone.Visible = true
            clone.ImageColor3 = v1
            clone.ImageTransparency = 0

            local UIScale = clone:FindFirstChildOfClass("UIScale")

            if not UIScale then
                UIScale = Instance.new("UIScale")
                UIScale.Parent = clone
            end

            UIScale.Scale = 0
            clone.Parent = Hearts
            table.insert(t1, clone)
            task.delay((i - 1) * 0.16 * 0.6, function() -- line: 221
                -- upvalues: v11 (copy), clone (copy), TweenService (copy), n3 (ref)
                local UIScale

                if v11 ~= n3 or clone.Parent == nil then
                    return
                else
                    UIScale = clone:FindFirstChildOfClass("UIScale")

                    if not UIScale then
                        UIScale = Instance.new("UIScale")
                        UIScale.Parent = clone
                    end
                end

                local t7 = {
                    Scale = 1
                }
                local Back = Enum.EasingStyle.Back

                TweenService:Create(UIScale, TweenInfo.new(0.35, Back or Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t7):Play()
            end)
        end

        n1 = p13
        p12:Add(function() -- line: 227
            -- upvalues: v11 (copy), t1 (copy), n1 (ref), n2 (ref), n3 (ref), v4 (ref), v5 (ref)
            if v11 ~= n3 then
                return
            end

            n3 += 1
            v4 = nil
            v5 = nil
            n2 += 1

            for _, v15 in t1 do
                local UIScale = v15:FindFirstChildOfClass("UIScale")

                if UIScale then
                    UIScale.Scale = 1
                end
            end

            for _, v16 in t1 do
                v16:Destroy()
            end

            table.clear(t1)
            n1 = 0
        end)
    end,
    Lose = function(p15) -- Lose | line: 241
        -- upvalues: GuiService (copy), SoundService (copy), TweenService (copy), Audio (copy), BeanstalkEvent (copy), v1 (copy), v2 (copy), v3 (copy), t1 (copy), n1 (ref), n2 (ref), n3 (ref), v4 (ref), v5 (ref), shatter (copy)
        local v17 = n3
        local v18 = t1[p15 + 1]

        n1 = p15

        local WhaleHeartBreak = BeanstalkEvent.WhaleHeartBreak

        if v4 then
            local v19 = Audio.Play(WhaleHeartBreak, SoundService, {
                SoundGroup = "SFX",
                PlaybackSpeed = WhaleHeartBreak.PlaybackSpeed
            })

            if v19 and v5 then
                v5:Add(v19)
            end
        else
            SoundService:PlayLocalSound(WhaleHeartBreak)
        end

        if v18 == nil then
            return
        end

        n2 += 1

        for _, v20 in t1 do
            local UIScale = v20:FindFirstChildOfClass("UIScale")

            if UIScale then
                UIScale.Scale = 1
            end
        end

        local ReducedMotionEnabled = GuiService.ReducedMotionEnabled
        local UIScale = v18:FindFirstChildOfClass("UIScale")

        if not UIScale then
            UIScale = Instance.new("UIScale")
            UIScale.Parent = v18
        end

        v18.ImageColor3 = v3
        v18.Rotation = if ReducedMotionEnabled then 0 else (if math.random() < 0.5 then -1 else 1) * 12
        UIScale.Scale = ReducedMotionEnabled and 1 or 1.7
        task.delay(0.07, function() -- line: 255
            -- upvalues: v17 (copy), v18 (copy), ReducedMotionEnabled (copy), UIScale (ref), TweenService (copy), v2 (copy), n3 (ref), shatter (copy)
            if v17 ~= n3 or v18.Parent == nil then
                return
            elseif not ReducedMotionEnabled then
                shatter(v18)
            end

            v18.ImageColor3 = v2
            v18.ImageTransparency = 0.25
            v18.Rotation = 0
            UIScale.Scale = 0.55

            local t8 = {
                Scale = 1
            }
            local Back = Enum.EasingStyle.Back

            TweenService:Create(UIScale, TweenInfo.new(0.4, Back or Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t8):Play()
        end)

        for i = 1, p15 do
            local v23 = t1[i]

            if not ReducedMotionEnabled then
                v23.ImageColor3 = v3

                local t9 = {
                    ImageColor3 = v1
                }

                TweenService:Create(v23, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t9):Play()
                v23.Rotation = (i % 2 == 0 and 1 or -1) * 14

                local t10 = {
                    Rotation = 0
                }
                local Elastic = Enum.EasingStyle.Elastic

                TweenService:Create(v23, TweenInfo.new(0.55, Elastic or Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t10):Play()
            end
        end

        if p15 == 1 then
            task.delay(0.4, function() -- line: 276
                -- upvalues: v17 (copy), GuiService (copy), TweenService (copy), t1 (copy), n1 (ref), n2 (ref), n3 (ref)
                if v17 ~= n3 or n1 ~= 1 or not t1[1] then
                    return
                end

                local v24 = t1[1]

                n2 += 1

                local v25 = n2

                if GuiService.ReducedMotionEnabled then
                    return
                end

                task.spawn(function() -- line: 130
                    -- upvalues: v24 (copy), v25 (copy), TweenService (copy), n2 (ref)
                    if n2 == v25 and v24.Parent ~= nil then
                        local UIScale = v24:FindFirstChildOfClass("UIScale")

                        if not UIScale then
                            UIScale = Instance.new("UIScale")
                            UIScale.Parent = v24
                        end

                        while n2 == v25 and v24.Parent do
                            local t11 = {
                                Scale = 1.2
                            }
                            local Quad = Enum.EasingStyle.Quad

                            TweenService:Create(UIScale, TweenInfo.new(0.11200000000000002, Quad or Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t11):Play()
                            task.wait(0.11200000000000002)

                            if n2 ~= v25 then
                                break
                            end

                            local t12 = {
                                Scale = 1
                            }
                            local Back = Enum.EasingStyle.Back

                            TweenService:Create(UIScale, TweenInfo.new(0.168, Back or Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t12):Play()
                            task.wait(0.388)
                        end
                    end
                end)
            end)
        end
    end,
    Refill = function(p16) -- Refill | line: 284
        -- upvalues: TweenService (copy), BeanstalkEvent (copy), v1 (copy), v3 (copy), t1 (copy), n1 (ref), n2 (ref), n3 (ref), play (copy)
        local v28 = n3

        n2 += 1

        for _, v29 in t1 do
            local UIScale = v29:FindFirstChildOfClass("UIScale")

            if UIScale then
                UIScale.Scale = 1
            end
        end

        n1 = p16

        for v30, v31 in t1 do
            if not (p16 < v30) then
                task.delay((v30 - 1) * 0.16, function() -- line: 292
                    -- upvalues: v28 (copy), v30 (copy), v31 (copy), TweenService (copy), BeanstalkEvent (copy), v1 (copy), v3 (copy), n3 (ref), play (copy)
                    local UIScale

                    if v28 ~= n3 or v31.Parent == nil then
                        return
                    else
                        v31.ImageColor3 = v1
                        v31.ImageTransparency = 0
                        v31.ImageColor3 = v3

                        local t13 = {
                            ImageColor3 = v1
                        }

                        TweenService:Create(v31, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t13):Play()
                        UIScale = v31:FindFirstChildOfClass("UIScale")

                        if not UIScale then
                            UIScale = Instance.new("UIScale")
                            UIScale.Parent = v31
                        end
                    end

                    UIScale.Scale = 0.2
                    v31.Rotation = -20

                    local t14 = {
                        Scale = 1
                    }
                    local Back = Enum.EasingStyle.Back

                    TweenService:Create(UIScale, TweenInfo.new(0.4, Back or Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t14):Play()

                    local t15 = {
                        Rotation = 0
                    }
                    local Elastic = Enum.EasingStyle.Elastic

                    TweenService:Create(v31, TweenInfo.new(0.6, Elastic or Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t15):Play()
                    play(BeanstalkEvent.WhaleHeartRefill, (v30 - 1) * 0.12 + 1)
                end)
            end
        end
    end
}
