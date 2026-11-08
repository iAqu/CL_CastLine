-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local v1 = Color3.fromRGB(255, 111, 102)

return {
    new = function(p1, p2) -- new | line: 7
        -- upvalues: v1 (copy)
        local t2 = {}
        local t3 = {}
        local t4 = {}
        local ScreenGui = Instance.new("ScreenGui")

        ScreenGui.Name = "ScrambleDamageFeedback"
        ScreenGui.IgnoreGuiInset = true
        ScreenGui.ResetOnSpawn = false
        ScreenGui.DisplayOrder = 5
        ScreenGui.Parent = p1

        local self = setmetatable({}, {
            __mode = "k"
        })

        local function remove(p3) -- line: 16
            -- upvalues: t3 (copy)
            t3[p3].Text:Destroy()
            table.remove(t3, p3)
        end

        function t2.Hit(p4, p5, p6) -- line: 20
            -- upvalues: p2 (copy), t3 (copy), t4 (copy), ScreenGui (copy), self (copy)
            local v3

            if not p4.Parent or p6 <= 0 then
                return
            else
                v3 = t4[p4]

                if not v3 then
                    local Highlight = Instance.new("Highlight")

                    Highlight.Name = "ScrambleDamageFlash"
                    Highlight.Adornee = p4
                    Highlight.FillColor = Color3.fromRGB(255, 70, 63)
                    Highlight.OutlineColor = Color3.fromRGB(255, 166, 142)
                    Highlight.DepthMode = Enum.HighlightDepthMode.Occluded
                    Highlight.Parent = p4
                    v3 = {
                        Age = 0,
                        Highlight = Highlight
                    }
                    t4[p4] = v3
                end
            end

            v3.Age = 0
            v3.Highlight.FillTransparency = 0.62
            v3.Highlight.OutlineTransparency = 0.15

            while #t3 >= 20 do
                t3[1].Text:Destroy()
                table.remove(t3, 1)
            end

            local clone = p2:Clone()

            clone.Name = "Amount"
            clone.AnchorPoint = Vector2.new(0.5, 0.5)

            local v5 = UDim2.fromScale(0.5, 0.5)
            local v6 = UDim2.fromOffset(150, 64)

            clone.Position = v5
            clone.Size = v6
            clone.AutomaticSize = Enum.AutomaticSize.None
            clone.TextScaled = false
            clone.TextWrapped = false
            clone.RichText = false
            clone.TextSize = 48
            clone.Text = "-" .. tostring((math.round(p6)))
            clone.TextColor3 = Color3.fromRGB(255, 243, 226)
            clone.TextTransparency = 0
            clone.BackgroundTransparency = 1
            clone.TextStrokeTransparency = 1
            clone.Visible = true
            clone.Parent = ScreenGui

            local v8 = clone:FindFirstChildOfClass("UIScale") or Instance.new("UIScale")

            v8.Scale = 0.78
            v8.Parent = clone

            local t7 = {}

            for _, descendant in clone:GetDescendants() do
                if descendant:IsA("UIStroke") then
                    descendant.StrokeSizingMode = Enum.StrokeSizingMode.FixedSize
                    descendant.Thickness = 2.5
                    descendant.Color = Color3.fromRGB(30, 13, 16)
                    descendant.Transparency = 0
                    table.insert(t7, descendant)
                elseif descendant:IsA("UITextSizeConstraint") then
                    descendant:Destroy()
                end
            end

            local v9 = -(self[p4] or -1)

            self[p4] = v9

            local CurrentCamera = workspace.CurrentCamera
            local v10, v11

            if CurrentCamera then
                v10, v11 = CurrentCamera:WorldToViewportPoint(p5)
            else
                v10 = Vector3.new(0, 0, 0)
                v11 = false
            end

            clone.Position = UDim2.fromOffset(v10.X + v9 * 14, v10.Y - 5)

            if CurrentCamera ~= nil then
                clone.Visible = v11 and (CurrentCamera.CFrame.Position - p5).Magnitude <= 120
            else
                clone.Visible = false
            end

            table.insert(t3, {
                Age = 0,
                Origin = p5,
                Text = clone,
                Scale = v8,
                Strokes = t7,
                Side = v9
            })
        end

        function t2.Step(p7) -- line: 76
            -- upvalues: t3 (copy), t4 (copy), v1 (copy)
            for v12, v13 in t4 do
                v13.Age += p7

                if not v12.Parent or v13.Age >= 0.6 then
                    v13.Highlight:Destroy()
                    t4[v12] = nil
                else
                    local v15 = math.clamp((v13.Age - 0.08) / 0.52, 0, 1)
                    local v16 = v15 * v15 * (3 - v15 * 2)

                    v13.Highlight.FillTransparency = v16 * 0.38 + 0.62
                    v13.Highlight.OutlineTransparency = v16 * 0.85 + 0.15
                end
            end

            for i = #t3, 1, -1 do
                local v17 = t3[i]

                v17.Age += p7

                local Age = v17.Age

                if Age >= 0.95 then
                    t3[i].Text:Destroy()
                    table.remove(t3, i)
                else
                    local v19 = 1 - math.exp(-4 * Age)
                    local CurrentCamera = workspace.CurrentCamera
                    local v20, v21

                    if CurrentCamera then
                        v20, v21 = CurrentCamera:WorldToViewportPoint(v17.Origin)
                    else
                        v20 = Vector3.new(0, 0, 0)
                        v21 = false
                    end

                    local Text = v17.Text

                    if CurrentCamera ~= nil then
                        Text.Visible = v21 and (CurrentCamera.CFrame.Position - v17.Origin).Magnitude <= 120
                    else
                        Text.Visible = false
                    end

                    v17.Text.Position = UDim2.fromOffset(v20.X + v17.Side * (v19 * 38 + 14), v20.Y - 5 - 76 * Age + 28 * Age * Age)
                    v17.Scale.Scale = 1 - math.exp(-14 * Age) * 0.22 * math.cos(24 * Age)
                    v17.Text.Rotation = v17.Side * 12 * math.sin(math.min(Age / 0.7, 1) * 3.141592653589793 / 2)
                    v17.Text.TextColor3 = Color3.fromRGB(255, 243, 226):Lerp(v1, (math.clamp(Age / 0.16, 0, 1)))

                    local v31 = math.clamp((Age - 0.55) / 0.4, 0, 1)

                    v17.Text.TextTransparency = v31

                    for _, v32 in v17.Strokes do
                        v32.Transparency = v31
                    end
                end
            end
        end

        function t2.Destroy() -- line: 109
            -- upvalues: t3 (copy), t4 (copy), ScreenGui (copy)
            for i = #t3, 1, -1 do
                t3[i].Text:Destroy()
                table.remove(t3, i)
            end

            for v33, v34 in t4 do
                v34.Highlight:Destroy()
                t4[v33] = nil
            end

            ScreenGui:Destroy()
        end

        return t2
    end
}
