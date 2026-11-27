-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local FishDisplay = require(ReplicatedStorage:WaitForChild("Modules"):WaitForChild("FishDisplay"))
local LocalPlayer = Players.LocalPlayer
local t1 = {}
local t2 = {
    VS_AT = 0.12,
    VS_FROM = 2.4,
    LINE_AT = 0.3,
    FISH_AT = 0.5,
    FAN_STEP = 0.42,
    FAN_TILT = 7,
    EASE = 10,
    JUMP = 0.035,
    JUMP_POP = 1.25,
    SECOND_AT = 0.12,
    SECOND_HOLD = 1.2,
    HEAD_POP = TweenInfo.new(0.32, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    VS_POP = TweenInfo.new(0.34, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    LINE_GROW = TweenInfo.new(0.28, Enum.EasingStyle.Quart, Enum.EasingDirection.Out),
    FISH_POP = TweenInfo.new(0.34, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    BOT_COLOR = Color3.fromRGB(255, 70, 200),
    SECOND_POP = TweenInfo.new(0.34, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
    SECOND_OUT = TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.In)
}
local n1 = 0
local v1 = false
local v2
local n2 = 0.5
local n3 = 0.5
local connection
local t3 = {}
local t4 = {}

local function placeTug(p1) -- line: 53
    -- upvalues: v2 (ref)
    local Line = v2.Line
    local v3 = Line:GetAttribute("FullWidth") or 0.68

    v2.Fish.Position = UDim2.fromScale(0.5 - v3 / 2 + v3 * p1, v2.Fish.Position.Y.Scale)
    Line.Mine.Size = UDim2.fromScale(p1, 1)
    Line.Theirs.Size = UDim2.fromScale(1 - p1, 1)
end

local function popIn(p2, p3, p4, p5) -- line: 60
    -- upvalues: TweenService (copy)
    local Pop = p2:FindFirstChild("Pop")

    if Pop then
        Pop.Scale = p5 or 0
        TweenService:Create(Pop, TweenInfo.new(p3.Time, p3.EasingStyle, p3.EasingDirection, 0, false, p4 or 0), {
            Scale = 1
        }):Play()
    end
end

local function dressHead(p6, p7) -- line: 66
    -- upvalues: t2 (copy)
    if not (p7 and p7 > 0) then
        p6.Face.Image = ""
        p6.Face.BackgroundColor3 = t2.BOT_COLOR
        p6.Word.Text = "BOT"
    else
        p6.Face.Image = ("rbxthumb://type=AvatarHeadShot&id=%d&w=150&h=150"):format(p7)
        p6.Face.BackgroundColor3 = Color3.fromRGB(205, 232, 250)
        p6.Word.Text = ""
    end
end

local function buildRivals(p8) -- line: 77
    -- upvalues: t2 (copy), v2 (ref), popIn (copy), dressHead (copy)
    local Rivals = v2.Rivals

    for _, child in ipairs(Rivals:GetChildren()) do
        if child:IsA("Frame") and child.Name ~= "HeadTemplate" then
            child:Destroy()
        end
    end

    for v4, v5 in ipairs(p8 or {}) do
        local clone = Rivals.HeadTemplate:Clone()

        clone.Name = "Rival" .. v4
        clone.Visible = true
        clone.Position = UDim2.fromScale(0.5 + (v4 - 1) * t2.FAN_STEP, 0.5)
        clone.Rotation = (v4 - 1) * t2.FAN_TILT

        local v6 = 30 - v4 * 3

        clone.ZIndex = v6

        local Face, Word = clone.Face, clone.Word
        local v7 = v6 + 1
        local v8 = v6 + 2

        Face.ZIndex = v7
        Word.ZIndex = v8
        dressHead(clone, v5)
        clone.Parent = Rivals
        popIn(clone, t2.HEAD_POP, (v4 - 1) * 0.05)
    end
end

local function unfade() -- line: 99
    -- upvalues: t3 (copy), t4 (copy)
    for _, v9 in ipairs(t4) do
        v9:Cancel()
    end

    table.clear(t4)

    for _, v10 in ipairs(t3) do
        if v10[1].Parent then
            v10[1][v10[2]] = v10[3]
        end
    end

    table.clear(t3)
end

function t1.Show(p9, p10) -- line: 109
    -- upvalues: RunService (copy), TweenService (copy), FishDisplay (copy), LocalPlayer (copy), t1 (copy), t2 (copy), v1 (ref), v2 (ref), n2 (ref), n3 (ref), connection (ref), placeTug (copy), popIn (copy), dressHead (copy), buildRivals (copy), unfade (copy)
    local v11 = p9 and p9.Circle:FindFirstChild("Versus")

    if not v11 then
        return
    end

    v11.Visible = true

    if v1 and v2 == v11 then
        if p10.action == "start" then
            buildRivals(p10.rivals)
        end
    else
        unfade()
        v1 = true
        v2 = v11
        dressHead(v2.Me, LocalPlayer.UserId)

        local v12 = p10.fish and FishDisplay[p10.fish]

        v2.Fish.Image = v12 and v12.icon or ""
        buildRivals(p10.rivals)

        local tug = p10.tug
        local v13, v14

        if type(tug) == "number" and p10.tug == p10.tug then
            local v15 = math.clamp(p10.tug, 0, 1)

            if v15 then
                v13 = v15
                v14 = true
            else
                v14 = false
            end
        else
            v14 = false
        end

        if not v14 then
            v13 = 0.5
        end

        n2 = v13
        n3 = v13
        placeTug(v13)
        popIn(v2.Me, t2.HEAD_POP, 0)
        popIn(v2.VS, t2.VS_POP, t2.VS_AT, t2.VS_FROM)
        v2.VS.TextTransparency = 1
        v2.VS.UIStroke.Transparency = 1

        local v16 = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, 0, false, t2.VS_AT)

        TweenService:Create(v2.VS, v16, {
            TextTransparency = 0
        }):Play()
        TweenService:Create(v2.VS.UIStroke, v16, {
            Transparency = 0
        }):Play()

        local v17 = v2.Line:GetAttribute("FullWidth") or 0.68
        local Scale = v2.Line.Size.Y.Scale

        v2.Line.Size = UDim2.fromScale(0, Scale)
        TweenService:Create(v2.Line, TweenInfo.new(t2.LINE_GROW.Time, t2.LINE_GROW.EasingStyle, t2.LINE_GROW.EasingDirection, 0, false, t2.LINE_AT), {
            Size = UDim2.fromScale(v17, Scale)
        }):Play()
        popIn(v2.Fish, t2.FISH_POP, t2.FISH_AT)

        if connection then
            connection:Disconnect()
        end

        connection = RunService.RenderStepped:Connect(function(p11) -- line: 144
            -- upvalues: t1 (copy), t2 (copy), v2 (ref), n2 (ref), n3 (ref), placeTug (copy)
            if not (v2 and v2.Parent) then
                t1.Stop()
            else
                n3 += (n2 - n3) * math.min(1, p11 * t2.EASE)
                placeTug(n3)
            end
        end)
    end
end

function t1.Hide(p12) -- line: 152
    local v21 = p12 and p12.Circle:FindFirstChild("Versus")

    if v21 then
        v21.Visible = false
    end
end

function t1.Finish(p13) -- line: 161
    -- upvalues: TweenService (copy), v1 (ref), v2 (ref), t3 (copy), t4 (copy)
    if not v1 or not v2 then
        return
    end

    v1 = false

    for _, descendant in ipairs(v2:GetDescendants()) do
        local t5 = if descendant:IsA("ImageLabel") then { "ImageTransparency", "BackgroundTransparency" }
            elseif descendant:IsA("TextLabel") then { "TextTransparency", "BackgroundTransparency" }
            elseif descendant:IsA("Frame") then { "BackgroundTransparency" }
            elseif descendant:IsA("UIStroke") then { "Transparency" }
            else nil

        for _, v22 in ipairs(t5 or {}) do
            if descendant[v22] < 1 then
                t3[#t3 + 1] = {
                    descendant,
                    v22,
                    descendant[v22]
                }

                local tween = TweenService:Create(descendant, p13, {
                    [v22] = 1
                })

                t4[#t4 + 1] = tween
                tween:Play()
            end
        end
    end
end

function t1.Stop() -- line: 187
    -- upvalues: n1 (ref), v1 (ref), v2 (ref), connection (ref)
    v1 = false
    n1 += 1

    local v23 = v2 and v2.Parent and v2.Parent:FindFirstChild("SecondChance")

    if v23 then
        v23.Visible = false
    end

    if connection then
        connection:Disconnect()
        connection = nil
    end
end

function t1.SecondChance(p14, p15) -- line: 197
    -- upvalues: TweenService (copy), t2 (copy), n1 (ref)
    local v24 = p14 and p14.Circle:FindFirstChild(p15 or "SecondChance")

    if not v24 then
        return
    end

    n1 += 1

    local v25 = n1

    v24.Visible = true
    v24.Pop.Scale = 0
    TweenService:Create(v24.Pop, TweenInfo.new(t2.SECOND_POP.Time, t2.SECOND_POP.EasingStyle, t2.SECOND_POP.EasingDirection, 0, false, t2.SECOND_AT), {
        Scale = 1
    }):Play()
    task.delay(t2.SECOND_AT + t2.SECOND_POP.Time + t2.SECOND_HOLD, function() -- line: 206
        -- upvalues: v24 (copy), v25 (copy), TweenService (copy), t2 (copy), n1 (ref)
        if v25 == n1 and v24.Parent then
            TweenService:Create(v24.Pop, t2.SECOND_OUT, {
                Scale = 0
            }):Play()
            task.delay(t2.SECOND_OUT.Time, function() -- line: 209
                -- upvalues: v24 (copy), v25 (copy), n1 (ref)
                if v25 == n1 and v24.Parent then
                    v24.Visible = false
                end
            end)
        end
    end)
end

ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("ContestTug").OnClientEvent:Connect(function(p16) -- line: 215
    -- upvalues: TweenService (copy), t2 (copy), v1 (ref), v2 (ref), n2 (ref)
    if v1 and v2 and type(p16) == "number" and p16 == p16 then
        local v26 = math.clamp(p16, 0, 1)

        if math.abs(v26 - n2) > t2.JUMP then
            local Pop = v2.Fish:FindFirstChild("Pop")

            if Pop then
                Pop.Scale = t2.JUMP_POP
                TweenService:Create(Pop, TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                    Scale = 1
                }):Play()
            end
        end

        n2 = v26
    end
end)

return t1
