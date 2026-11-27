-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ContentProvider = game:GetService("ContentProvider")
local Debris = game:GetService("Debris")
local Plots = workspace:WaitForChild("Plots")
local TableUpgrade = ReplicatedStorage:WaitForChild("VFX"):WaitForChild("TableUpgrade")
local FoodPop = ReplicatedStorage.VFX:WaitForChild("FoodPop")
local Explosion = ReplicatedStorage.VFX:WaitForChild("Explosion")
local TableDisplay = require(ReplicatedStorage.Modules:WaitForChild("TableDisplay"))
local TweenService = game:GetService("TweenService")

local function scaleSeq(p1, p2) -- line: 33
    local t1 = {}

    for v1, v2 in ipairs(p1.Keypoints) do
        t1[v1] = NumberSequenceKeypoint.new(v2.Time, v2.Value * p2, v2.Envelope * p2)
    end

    return NumberSequence.new(t1)
end

local function emit(p3) -- line: 40
    local v3 = p3:GetAttribute("EmitCount") or 0
    local v4 = p3:GetAttribute("EmitDelay") or 0

    if not (v3 <= 0) then
        if v4 > 0 then
            task.delay(v4, function() -- line: 45
                -- upvalues: p3 (copy), v3 (copy)
                if p3.Parent then
                    p3:Emit(v3)
                end
            end)
        else
            p3:Emit(v3)
        end
    end
end

local function play(p4) -- line: 51
    -- upvalues: Debris (copy), TableUpgrade (copy), TableDisplay (copy), scaleSeq (copy), emit (copy)
    local v5 = p4.PrimaryPart or p4:WaitForChild("Root", 5)

    if not v5 then
        return
    end

    local v7 = tonumber((p4:GetAttribute("Tier") or ""):match("%d+")) or 1
    local v8 = TableDisplay.Color(v7)
    local clone = TableUpgrade:Clone()

    clone.CFrame = v5.CFrame * CFrame.new(0, 1.5, 0)
    clone.Parent = workspace
    Debris:AddItem(clone, 6)

    for _, descendant in ipairs(clone:GetDescendants()) do
        if descendant:IsA("ParticleEmitter") then
            descendant.Enabled = false
            descendant.Size = scaleSeq(descendant.Size, 0.16)
            descendant.Speed = NumberRange.new(descendant.Speed.Min * 0.16, descendant.Speed.Max * 0.16)

            local Acceleration = descendant.Acceleration

            descendant.Acceleration = Vector3.new(Acceleration.X * 0.16, Acceleration.Y * 0.16, Acceleration.Z * 0.16)

            local Value = descendant.Color.Keypoints[1].Value
            local v12 = Value.R > 0.97 and Value.G > 0.97 and Value.B > 0.97

            if not descendant:GetAttribute("NoColor") and not v12 then
                descendant.Color = ColorSequence.new(v8)
            end

            emit(descendant)
        end
    end
end

local function explode(p5) -- line: 79
    -- upvalues: Debris (copy), Explosion (copy), scaleSeq (copy), emit (copy)
    local v13 = p5:FindFirstChild("Water") or p5:WaitForChild("Water", 5)

    if not v13 then
        return
    end

    local clone = Explosion:Clone()

    clone.Anchored = true
    clone.CanCollide = false
    clone.CanQuery = false
    clone.Transparency = 1
    clone.CFrame = v13.CFrame
    clone.Parent = workspace
    Debris:AddItem(clone, 6)

    for _, descendant in ipairs(clone:GetDescendants()) do
        if descendant:IsA("ParticleEmitter") then
            descendant.Enabled = false
            descendant.Size = scaleSeq(descendant.Size, 6)
            descendant.Speed = NumberRange.new(descendant.Speed.Min * 6, descendant.Speed.Max * 6)
            descendant.Acceleration *= 6
            emit(descendant)
        end
    end
end

local UserId = Players.LocalPlayer.UserId

local function foodPopAt(p6) -- line: 106
    -- upvalues: Debris (copy), Plots (copy), FoodPop (copy), scaleSeq (copy), emit (copy), UserId (copy)
    local v14 = p6

    while v14 and v14.Parent ~= Plots do
        v14 = v14.Parent
    end

    if v14 and v14:GetAttribute("OwnerUserId") == UserId then
        local clone = FoodPop:Clone()

        clone.CFrame = p6.CFrame
        clone.Parent = workspace
        Debris:AddItem(clone, 6)

        for _, descendant in ipairs(clone:GetDescendants()) do
            if descendant:IsA("ParticleEmitter") then
                descendant.Enabled = false
                descendant.Size = scaleSeq(descendant.Size, 0.5)
                descendant.Speed = NumberRange.new(descendant.Speed.Min * 0.5, descendant.Speed.Max * 0.5)
                emit(descendant)
            end
        end
    end
end

local function watchFood(p7) -- line: 124
    -- upvalues: foodPopAt (copy)
    local Parent = p7.Parent

    if p7:IsA("BasePart") and Parent and Parent.Name == "Food" then
        p7:GetAttributeChangedSignal("Regrown"):Connect(function() -- line: 128
            -- upvalues: p7 (copy), foodPopAt (copy)
            foodPopAt(p7)
        end)
    end
end

for _, descendant in ipairs(Plots:GetDescendants()) do
    watchFood(descendant)
end

Plots.DescendantAdded:Connect(watchFood)

local _ = {
    PEAK = 1.2,
    UP = 0.08,
    DOWN = 0.25
}
local v15 = TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local v16 = TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local t2 = {}

local function watchRate(p8) -- line: 138
    -- upvalues: TweenService (copy), v15 (copy), v16 (copy), t2 (copy)
    if t2[p8] then
        return
    end

    t2[p8] = true
    p8.Destroying:Once(function() -- line: 141
        -- upvalues: p8 (copy), t2 (copy)
        t2[p8] = nil
    end)
    task.spawn(function() -- line: 142
        -- upvalues: p8 (copy), TweenService (copy), v15 (copy), v16 (copy)
        local v17 = p8:WaitForChild("Gui", 10)
        local v18 = v17 and v17:WaitForChild("Label", 10)

        if not v18 then
            return
        end

        v18.AnchorPoint = Vector2.new(0.5, 0.5)
        v18.Position = UDim2.fromScale(0.5, 0.5)

        local UIScale = Instance.new("UIScale")

        UIScale.Parent = v18

        local v19 = nil

        v18:GetPropertyChangedSignal("Text"):Connect(function() -- line: 152
            -- upvalues: UIScale (copy), v19 (ref), TweenService (copy), v15 (copy), v16 (copy)
            if v19 then
                v19:Cancel()
            end

            local tween = TweenService:Create(UIScale, v15, {
                Scale = 1.2
            })

            v19 = tween
            tween.Completed:Once(function(p9) -- line: 156
                -- upvalues: tween (copy), UIScale (copy), v19 (ref), TweenService (copy), v16 (copy)
                if p9 ~= Enum.PlaybackState.Completed or v19 ~= tween then
                    return
                end

                v19 = TweenService:Create(UIScale, v16, {
                    Scale = 1
                })
                v19:Play()
            end)
            tween:Play()
        end)
    end)
end

local function watchPlot(p10) -- line: 166
    -- upvalues: play (copy), explode (copy), watchRate (copy)
    p10.ChildAdded:Connect(function(p11) -- line: 167
        -- upvalues: play (copy), explode (copy), watchRate (copy)
        if p11.Name == "Table" and p11:GetAttribute("Popped") then
            play(p11)
        elseif p11.Name ~= "Aquarium" or not p11:GetAttribute("Popped") then
            if p11.Name == "RateSign" then
                watchRate(p11)
            end
        else
            explode(p11)
        end
    end)

    local RateSign = p10:FindFirstChild("RateSign")

    if RateSign then
        watchRate(RateSign)
    end
end

for _, child in ipairs(Plots:GetChildren()) do
    child.ChildAdded:Connect(function(p12) -- line: 167
        -- upvalues: play (copy), explode (copy), watchRate (copy)
        if p12.Name == "Table" and p12:GetAttribute("Popped") then
            play(p12)
        elseif p12.Name ~= "Aquarium" or not p12:GetAttribute("Popped") then
            if p12.Name == "RateSign" then
                watchRate(p12)
            end
        else
            explode(p12)
        end
    end)

    local RateSign = child:FindFirstChild("RateSign")

    if RateSign then
        watchRate(RateSign)
    end
end

Plots.ChildAdded:Connect(watchPlot)
task.spawn(function() -- line: 183
    -- upvalues: ContentProvider (copy), TableUpgrade (copy), FoodPop (copy), Explosion (copy)
    local t3 = {}

    for _, descendant in ipairs(TableUpgrade:GetDescendants()) do
        if descendant:IsA("ParticleEmitter") then
            table.insert(t3, descendant)
        end
    end

    for _, descendant in ipairs(FoodPop:GetDescendants()) do
        if descendant:IsA("ParticleEmitter") then
            table.insert(t3, descendant)
        end
    end

    for _, descendant in ipairs(Explosion:GetDescendants()) do
        if descendant:IsA("ParticleEmitter") then
            table.insert(t3, descendant)
        end
    end

    local function v20() -- line: 188
        -- upvalues: t3 (copy), ContentProvider (copy)
        ContentProvider:PreloadAsync(t3)
    end

    pcall(v20)
end)
