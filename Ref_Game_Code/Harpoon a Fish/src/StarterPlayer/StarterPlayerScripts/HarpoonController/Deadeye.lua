-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Modules = game:GetService("ReplicatedStorage"):WaitForChild("Modules")
local AchievementConfig = require(Modules:WaitForChild("AchievementConfig"))
local Loc = require(Modules:WaitForChild("Loc"))
local LocalPlayer = Players.LocalPlayer
local t1 = {}
local color = AchievementConfig.TRACKS.Deadeye.color
local t2 = {
    SPINS = 2,
    BAND = 0.13,
    FLASH = 0.28,
    PASS_PAD = 20,
    DRAIN = 0.35,
    LOST_HOLD = 1.1,
    SHAKE_STEP = 0.05,
    BRIGHT = color:Lerp(Color3.new(1, 1, 1), 0.35),
    BREATH = { 0.9, 1.8, 3 },
    TAG_POP = TweenInfo.new(0.32, Enum.EasingStyle.Back, Enum.EasingDirection.Out, 0, false, 0.15),
    LOST_GREY = Color3.fromRGB(175, 175, 185),
    LOST_INK = Color3.fromRGB(40, 40, 46),
    SHAKE = { -9, 8, -6, 4, -2, 0 }
}
local v2, v3
local v4 = false
local v5 = false
local elapsed, elapsed2, elapsed3, v6
local n1 = 0

local function rimOf() -- line: 52
    -- upvalues: v3 (ref)
    return v3 and v3:FindFirstChild("Circle") and v3.Circle:FindFirstChild("DeadeyeRim")
end

local function tagOf() -- line: 53
    -- upvalues: v3 (ref)
    return v3 and v3:FindFirstChild("Circle") and v3.Circle:FindFirstChild("DeadeyeTag")
end

local function rimFrac() -- line: 54
    -- upvalues: v3 (ref)
    local v7 = v3 and v3:FindFirstChild("Circle") and v3.Circle:FindFirstChild("DeadeyeRim")

    return v7 and v7:GetAttribute("ThicknessFrac") or 0.195
end

local v8

local function ensureLoop() -- line: 60
    -- upvalues: RunService (copy), v6 (ref), v8 (ref)
    v6 = v6 or RunService.RenderStepped:Connect(function() -- line: 62
        -- upvalues: v8 (ref)
        v8()
    end)
end

local function stopLoop() -- line: 64
    -- upvalues: v6 (ref)
    if v6 then
        v6:Disconnect()
        v6 = nil
    end
end

local function tagIn() -- line: 69
    -- upvalues: TweenService (copy), AchievementConfig (copy), LocalPlayer (copy), color (copy), t2 (copy), v3 (ref), n1 (ref)
    local v9 = v3 and v3:FindFirstChild("Circle") and v3.Circle:FindFirstChild("DeadeyeTag")

    if not v9 then
        return
    end

    n1 += 1

    local Ach_Deadeye = LocalPlayer:GetAttribute("Ach_Deadeye")
    local TitleText = AchievementConfig.TitleText

    if type(Ach_Deadeye) ~= "number" or not Ach_Deadeye then
        Ach_Deadeye = 1
    end

    v9.Text = TitleText("Deadeye", Ach_Deadeye)
    v9.TextColor3 = color
    v9.UIStroke.Color = Color3.fromRGB(50, 0, 0)

    local UIStroke = v9.UIStroke

    v9.TextTransparency = 0
    UIStroke.Transparency = 0
    v9.Rotation = 0
    v9.Visible = true
    v9.Pop.Scale = 0
    TweenService:Create(v9.Pop, t2.TAG_POP, {
        Scale = 1
    }):Play()
end

local function tagOut(p1) -- line: 83
    -- upvalues: TweenService (copy), v3 (ref), n1 (ref)
    local v10 = v3 and v3:FindFirstChild("Circle") and v3.Circle:FindFirstChild("DeadeyeTag")

    if not (v10 and v10.Visible) then
        return
    end

    n1 += 1

    local v11 = n1
    local v12 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, p1 or 0)

    TweenService:Create(v10, v12, {
        TextTransparency = 1
    }):Play()
    TweenService:Create(v10.UIStroke, v12, {
        Transparency = 1
    }):Play()
    task.delay((p1 or 0) + 0.27, function() -- line: 91
        -- upvalues: v10 (copy), v11 (copy), n1 (ref)
        if v11 == n1 and v10.Parent then
            v10.Visible = false
        end
    end)
end

local function lose() -- line: 97
    -- upvalues: RunService (copy), TweenService (copy), Loc (copy), t2 (copy), v3 (ref), v5 (ref), elapsed2 (ref), elapsed3 (ref), v6 (ref), n1 (ref), v8 (ref), tagOut (copy)
    if v5 then
        return
    end

    v5 = true

    local elapsed = os.clock()
    local elapsed4 = os.clock()

    elapsed2 = elapsed
    elapsed3 = elapsed4

    local v13 = v3 and v3:FindFirstChild("Circle") and v3.Circle:FindFirstChild("DeadeyeTag")

    if v13 and v13.Visible then
        n1 += 1
        v13.Text = Loc.F("ach.deadeye_lost", "DEADEYE LOST", {})
        v13.TextColor3 = t2.LOST_GREY
        v13.UIStroke.Color = t2.LOST_INK
        v13.Pop.Scale = 1.25
        TweenService:Create(v13.Pop, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Scale = 1
        }):Play()
        tagOut(t2.LOST_HOLD)
    end

    v6 = v6 or RunService.RenderStepped:Connect(function() -- line: 62
        -- upvalues: v8 (ref)
        v8()
    end)
end

v8 = function() -- line: 114
    -- upvalues: color (copy), t2 (copy), v2 (ref), v3 (ref), v4 (ref), v5 (ref), elapsed (ref), elapsed2 (ref), elapsed3 (ref), v6 (ref), lose (copy)
    local elapsed4 = os.clock()
    local v14 = v3 and v3:FindFirstChild("Circle") and v3.Circle:FindFirstChild("DeadeyeRim")
    local v15 = v2 and v2()
    local v16, v17

    if not v4 or v5 then
        v17 = 0
    elseif v15 and v15.v1 and (v15.ramp or 0) <= 0 then
        v16 = if v15.v1 < 0 then -1 else 1

        local v18 = (v15.arcCenter - v15.angle0) * v16 % 360
        local v21 = math.abs(v15.v1) * math.max(0, workspace:GetServerTimeNow() - v15.time0) - (v18 + v15.arcSize / 2 + t2.PASS_PAD)
        local v22 = v21 > 0
        local v23 = if v22 then math.floor(v21 / 360) + 1 else nil

        v17 = if not v22 or not v23 then 0 else v23

        if t2.SPINS < v17 then
            lose()
        end
    else
        v17 = 0
    end

    if v14 and v14.Visible then
        local X = v3.Circle.AbsoluteSize.X

        if v5 then
            local v25 = elapsed2 and (elapsed4 - elapsed2) / t2.DRAIN or 1

            if v25 >= 1 then
                v14.Visible = false
            else
                local v26 = 1 - (1 - v25) ^ 3

                v14.Color3 = Color3.new(1, 1, 1):Lerp(color, v26)

                local v27 = v3 and v3:FindFirstChild("Circle") and v3.Circle:FindFirstChild("DeadeyeRim")
                local ThicknessFrac = v27 and v27:GetAttribute("ThicknessFrac") or 0.195
                local BAND = t2.BAND
                local v28 = v3 and v3:FindFirstChild("Circle") and v3.Circle:FindFirstChild("DeadeyeRim")

                v14.Thickness = (ThicknessFrac + (BAND - (v28 and v28:GetAttribute("ThicknessFrac") or 0.195)) * v26) * X
            end
        else
            local v31 = color:Lerp(t2.BRIGHT, math.sin(elapsed4 * 3.141592653589793 * 2 * t2.BREATH[math.min(v17, t2.SPINS) + 1]) * 0.5 + 0.5)

            v14.Color3 = if elapsed and elapsed4 - elapsed < t2.FLASH then Color3.new(1, 1, 1):Lerp(v31, (elapsed4 - elapsed) / t2.FLASH) else v31
        end
    end

    local v32 = v3 and v3:FindFirstChild("Circle") and v3.Circle:FindFirstChild("DeadeyeTag")

    if elapsed3 and v32 then
        local v35 = math.max(1, math.floor((elapsed4 - elapsed3) / t2.SHAKE_STEP) + 1)

        if #t2.SHAKE < v35 then
            v32.Rotation = 0
            elapsed3 = nil
        else
            v32.Rotation = t2.SHAKE[v35]
        end
    end

    if not v15 and not v5 then
        v4 = false

        if v14 then
            v14.Visible = false
        end
    end

    if v4 and not v5 or v14 and v14.Visible or elapsed3 or not v6 then
        return
    end

    v6:Disconnect()
    v6 = nil
end

function t1.Shrink(p2) -- line: 174
    -- upvalues: v5 (ref)
    return not v5 and p2.shrink or p2.shrinkBase or 0.964
end

function t1.Miss() -- line: 180
    -- upvalues: v4 (ref), v5 (ref), lose (copy)
    if v4 and not v5 then
        lose()
    end
end

function t1.Init(p3) -- line: 185
    -- upvalues: v2 (ref)
    v2 = p3
end

function t1.Msg(p4, p5, p6) -- line: 190
    -- upvalues: RunService (copy), v3 (ref), v4 (ref), v5 (ref), elapsed2 (ref), elapsed3 (ref), v6 (ref), n1 (ref), v8 (ref), tagIn (copy), lose (copy)
    v3 = p4 or v3

    if p6 then
        v4 = p5.dead == true
        v5 = false
        elapsed2 = nil
        elapsed3 = nil

        if v4 then
            tagIn()
            v6 = v6 or RunService.RenderStepped:Connect(function() -- line: 62
                -- upvalues: v8 (ref)
                v8()
            end)
        else
            local v36 = v3 and v3:FindFirstChild("Circle") and v3.Circle:FindFirstChild("DeadeyeTag")

            if v36 then
                n1 += 1
                v36.Visible = false
            end

            local v37 = v3 and v3:FindFirstChild("Circle") and v3.Circle:FindFirstChild("DeadeyeRim")

            if v37 then
                v37.Visible = false
            end
        end
    elseif v4 and not v5 and p5.dead == false then
        lose()
    end
end

function t1.Arc(p7, p8) -- line: 208
    -- upvalues: RunService (copy), t2 (copy), v3 (ref), v4 (ref), v5 (ref), elapsed (ref), v6 (ref), v8 (ref)
    v3 = p7 or v3

    local v38 = v3 and v3:FindFirstChild("Circle") and v3.Circle:FindFirstChild("DeadeyeRim")

    if not v38 then
        return
    end

    local v39, v40

    if not v4 or v5 then
        if not v5 then
            v38.Visible = false
        end
    else
        v39 = v3.Circle.Arc:GetAttribute("RadiusFrac") or 0.425
        v40 = v3 and v3:FindFirstChild("Circle") and v3.Circle:FindFirstChild("DeadeyeRim")
        v38:SetControlPoints(p8((math.deg(((v40 and v40:GetAttribute("ThicknessFrac") or 0.195) - t2.BAND) / 2 / v39))))

        local v43 = v3 and v3:FindFirstChild("Circle") and v3.Circle:FindFirstChild("DeadeyeRim")

        v38.Thickness = (v43 and v43:GetAttribute("ThicknessFrac") or 0.195) * v3.Circle.AbsoluteSize.X
        v38.Visible = true
        elapsed = os.clock()
        v6 = v6 or RunService.RenderStepped:Connect(function() -- line: 62
            -- upvalues: v8 (ref)
            v8()
        end)
    end
end

function t1.HideArc(p9) -- line: 225
    -- upvalues: v3 (ref)
    v3 = p9 or v3

    local v44 = v3 and v3:FindFirstChild("Circle") and v3.Circle:FindFirstChild("DeadeyeRim")

    if v44 then
        v44.Visible = false
    end
end

function t1.Hide() -- line: 232
    -- upvalues: v3 (ref), v4 (ref), tagOut (copy)
    v4 = false
    tagOut(0)

    local v45 = v3 and v3:FindFirstChild("Circle") and v3.Circle:FindFirstChild("DeadeyeRim")

    if v45 then
        v45.Visible = false
    end
end

return t1
