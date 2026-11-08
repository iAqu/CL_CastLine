-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local GuiService = game:GetService("GuiService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

require(ReplicatedStorage.Packages.Trove)

local t1 = {
    0.3333333333333333, 0.6666666666666666, 1
}
local v1 = NumberRange.new(0.03, 0.05)
local v2 = NumberRange.new(0.4, 0.7)
local v3 = Random.new()
local t2 = { false, false, false, false }

local function quadrantPoint(p1, p2) -- line: 40
    -- upvalues: v3 (copy)
    local AbsoluteSize = p1.AbsoluteSize
    local v4 = if p2 == 1 or p2 == 2 then v3:NextNumber(AbsoluteSize.X / 2, AbsoluteSize.X) else v3:NextNumber(1, AbsoluteSize.X / 2)
    local v5 = if p2 == 1 or p2 == 4 then v3:NextNumber(1, AbsoluteSize.Y / 2) else v3:NextNumber(AbsoluteSize.Y / 2, AbsoluteSize.Y)

    return Vector2.new(v4, v5)
end

local function nextQuadrant() -- line: 47
    -- upvalues: v3 (copy), t2 (ref)
    local v6 = v3:NextInteger(1, 4)

    if t2[v6] then
        if t2[1] then
            if t2[2] then
                if t2[3] then
                    if t2[4] then
                        t2 = { false, false, false, false }

                        local v7 = v3:NextInteger(1, 4)
                        local t3 = t2

                        t3[v7] = true

                        return v7
                    end

                    t2[4] = true

                    return 4
                end

                t2[3] = true

                return 3
            end

            t2[2] = true

            return 2
        end

        t2[1] = true

        return 1
    end

    local t4 = t2

    t4[v6] = true

    return v6
end

local function edgePosition(p3) -- line: 66
    -- upvalues: v3 (copy), quadrantPoint (copy), nextQuadrant (copy)
    local AbsoluteSize = p3.AbsoluteSize
    local v8 = quadrantPoint(p3, (nextQuadrant())) - Vector2.new(0.001, 0.001)
    local v9 = if v3:NextInteger(0, 1) == 0 then -0.07 else 1.07

    if v3:NextInteger(1, 2) == 1 then
        return UDim2.fromScale(v8.X / AbsoluteSize.X, v9)
    end

    return UDim2.fromScale(v9, v8.Y / AbsoluteSize.Y)
end

local function rotationToward(p4) -- line: 77
    local v10 = p4.X.Scale - 0.5
    local v11 = 0.5 - p4.Y.Scale
    local v13 = math.sqrt(v10 * v10 + v11 * v11)
    local v14 = if p4.X.Scale > 0.5 and p4.Y.Scale < 0.5 then 1
        elseif p4.X.Scale < 0.5 and p4.Y.Scale < 0.5 then 4
        elseif not (p4.X.Scale < 0.5 and p4.Y.Scale > 0.5) then 2
        else 3

    if v14 ~= 1 and v14 ~= 3 then
        v10 = v11
    end

    if v14 == 1 or v14 == 4 then
        return math.deg((math.asin(v10 / v13))) + (v14 - 1) * 90
    end

    return math.deg(-math.asin(v10 / v13)) + (v14 - 1) * 90
end

local function spawnLine(p5, p6, p7, p8, p9) -- line: 92
    -- upvalues: TweenService (copy), v1 (copy), v2 (copy), v3 (copy)
    local clone = p6:Clone()

    clone.Name = "Line"
    clone.Visible = true
    clone.Position = p7
    clone.Rotation = p8
    clone.ImageTransparency = 1
    clone.Size = UDim2.fromScale(v3:NextNumber(v1.Min, v1.Max), v3:NextNumber(v2.Min, v2.Max))
    clone.Parent = p5
    TweenService:Create(clone, TweenInfo.new(0.4), {
        ImageTransparency = 1 - p9
    }):Play()
    task.delay(0.2, function() -- line: 102
        -- upvalues: clone (copy), TweenService (copy)
        local tween = TweenService:Create(clone, TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {
            ImageTransparency = 1
        })

        tween:Play()
        tween.Completed:Wait()
        clone:Destroy()
    end)
end

return {
    Run = function(p10, p11, p12) -- Run | line: 115
        -- upvalues: GuiService (copy), RunService (copy), t1 (copy), edgePosition (copy), rotationToward (copy), spawnLine (copy)
        local Template = p11:FindFirstChild("Template")

        assert(Template ~= nil and Template:IsA("ImageLabel"), (("%* needs an ImageLabel named Template"):format((p11:GetFullName()))))

        local ScreenGui = p11:FindFirstAncestorOfClass("ScreenGui")

        assert(ScreenGui ~= nil, (("%* is not in a ScreenGui"):format((p11:GetFullName()))))

        if not ScreenGui.IgnoreGuiInset then
            local function coverInset() -- line: 122
                -- upvalues: p11 (copy), GuiService (copy)
                local GuiInset, GuiInset2 = GuiService:GetGuiInset()

                p11.Position = UDim2.fromOffset(-GuiInset.X, -GuiInset.Y)
                p11.Size = UDim2.new(1, GuiInset.X + GuiInset2.X, 1, GuiInset.Y + GuiInset2.Y)
            end

            coverInset()
            p10:Connect(GuiService:GetPropertyChangedSignal("TopbarInset"), coverInset)
        end

        p10:Connect(RunService.Heartbeat, function() -- line: 130
            -- upvalues: p11 (copy), p12 (copy), Template (copy), t1 (copy), edgePosition (copy), rotationToward (copy), spawnLine (copy)
            local v24 = math.clamp(p12(), 0, 1)

            if v24 <= 0.13333333333333333 then
                return
            end

            local v25 = edgePosition(p11)
            local v26 = rotationToward(v25)

            spawnLine(p11, Template, v25, v26, v24)

            for _, v27 in t1 do
                if v27 <= v24 then
                    spawnLine(p11, Template, v25, v26, v24)
                end
            end
        end)
        p10:Add(function() -- line: 144
            -- upvalues: p11 (copy)
            for _, child in p11:GetChildren() do
                if child.Name == "Line" then
                    child:Destroy()
                end
            end
        end)
    end
}
