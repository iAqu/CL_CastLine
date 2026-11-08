-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local GuiService = game:GetService("GuiService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Trove = require(ReplicatedStorage.Packages.Trove)
local CorruptedPlate = ReplicatedStorage.Assets.UI.Notifs.CorruptedPlate
local t1 = {
    {
        Drift = -1,
        Color = Color3.fromRGB(115, 255, 77)
    },
    {
        Drift = 1,
        Color = Color3.fromRGB(179, 58, 255)
    }
}
local t2 = {}

local function startsWith(p1, p2) -- line: 47
    return string.sub(p1, 1, #p2) == p2
end

local function makeGhost(p3, p4, p5, p6) -- line: 51
    local clone = p3:Clone(p4)

    clone.Name = "SignalGhost"
    clone.ZIndex = p4.ZIndex - 1

    for _, descendant in clone:GetDescendants() do
        if descendant:IsA("UIStroke") then
            descendant.Enabled = false
        elseif descendant:IsA("ImageLabel") then
            descendant.ImageTransparency = 1
        end
    end

    local t3 = {}

    for _, child in p4:GetChildren() do
        local v2 = clone:FindFirstChild(child.Name)

        if child:IsA("TextLabel") and v2 ~= nil and v2:IsA("TextLabel") then
            v2.RichText = false
            v2.Text = child.ContentText
            v2.TextColor3 = p5
            v2.TextStrokeTransparency = 1
            v2.TextTransparency = 1
            t3[child] = v2
        end
    end

    clone.Parent = p4.Parent

    return {
        Row = clone,
        Drift = p6,
        Labels = t3
    }
end

function t2.Attach(p7, p8) -- line: 82
    -- upvalues: GuiService (copy), RunService (copy), Trove (copy), CorruptedPlate (copy), t1 (copy), makeGhost (copy)
    local v3 = Trove.new()

    v3:AttachToInstance(p7)

    local clone = v3:Clone(CorruptedPlate)

    clone.ZIndex = p8.ZIndex - 2
    clone.Parent = p7

    local function stop() -- line: 90
        -- upvalues: v3 (copy)
        v3:Clean()
    end

    local Scale = clone.Size.Y.Scale

    local function fitWidth() -- line: 95
        -- upvalues: p7 (copy), p8 (copy), clone (copy), Scale (copy)
        local X = p7.AbsoluteSize.X

        if X <= 0 then
            return
        end

        local n1 = 0

        for _, child in p8:GetChildren() do
            if child:IsA("TextLabel") and child.Visible then
                n1 += child.AbsoluteSize.X
            end
        end

        local v5 = math.clamp(n1 / X + 0.2, 0.3, 1)

        clone.Size = UDim2.fromScale(v5, Scale)
    end

    fitWidth()

    if GuiService.ReducedMotionEnabled then
        v3:Connect(RunService.RenderStepped, fitWidth)
    else
        local t4 = {}
        local t5 = {}
        local t6 = {}

        for _, child in clone:GetChildren() do
            if string.sub(child.Name, 1, 9) == "ChargeArc" and child:IsA("ImageLabel") then
                table.insert(t4, child)
            elseif string.sub(child.Name, 1, 10) == "ChargeGlow" and child:IsA("ImageLabel") then
                table.insert(t5, child)
            elseif string.sub(child.Name, 1, 10) == "SignalTear" and child:IsA("GuiObject") then
                table.insert(t6, {
                    Frame = child,
                    Position = child.Position
                })
            end
        end

        local t8 = {}

        for _, v6 in t1 do
            table.insert(t8, (makeGhost(v3, p8, v6.Color, v6.Drift)))
        end

        local Scan = clone:FindFirstChild("Scan")
        local v8 = if Scan == nil then 0 else Scan.Position.Y.Scale
        local v9 = 1 - v8 * 2
        local Position = p8.Position
        local n2 = 0
        local n3 = -1

        v3:Connect(RunService.RenderStepped, function(p9) -- line: 144
            -- upvalues: fitWidth (copy), t4 (copy), t5 (copy), t6 (copy), t8 (copy), Scan (copy), v8 (copy), v9 (copy), Position (copy), n2 (ref), n3 (ref)
            n2 += p9
            fitWidth()

            local v11 = math.floor(n2 * 14)

            if v11 ~= n3 then
                n3 = v11

                for _, v12 in t4 do
                    local Cells = v12:GetAttribute("Cells")

                    if typeof(Cells) == "Vector2" and Cells.X > 0 and Cells.Y > 0 then
                        local v13 = v11 + (v12:GetAttribute("Phase") or 0) * 5

                        v12.ImageRectOffset = Vector2.new(v12.ImageRectSize.X * (v13 % Cells.X), v12.ImageRectSize.Y * (math.floor(v13 / Cells.X) % Cells.Y))
                    end
                end
            end

            local v16 = n2 % 1.45
            local v17 = if v16 < 0.23 then 1 - v16 / 0.23 else 0
            local v19 = math.sin(n2 * 173) * v17

            for _, v20 in t8 do
                local v21 = v20.Drift * (math.abs(v19) * 0.007 + 0.004)

                v20.Row.Position = Position + UDim2.fromScale(v21, 0)

                for v22, v23 in v20.Labels do
                    if v23.Text ~= v22.ContentText then
                        v23.Text = v22.ContentText
                    end

                    v23.TextSize = v22.TextSize
                    v23.TextScaled = v22.TextScaled
                    v23.TextWrapped = v22.TextWrapped
                    v23.TextTransparency = 1 - v17 * 0.53
                end
            end

            for _, v24 in t6 do
                local v25 = v24.Frame:GetAttribute("Drift") or 1
                local v26 = v24.Frame:GetAttribute("Phase") or 0

                v24.Frame.Position = v24.Position + UDim2.fromScale(v19 * 0.017 * v25, 0)
                v24.Frame.BackgroundTransparency = 0.67 - v17 * 0.43 + math.sin(n2 * 2 + v26) * 0.12
            end

            for _, v29 in t5 do
                local v30 = v29:GetAttribute("Phase") or 0

                v29.ImageTransparency = math.sin(n2 * 2.2 + v30) * 0.035 + 0.9
            end

            if Scan ~= nil then
                Scan.Position = UDim2.fromScale(Scan.Position.X.Scale, v8 + n2 * 0.45 % 1 * v9)
            end
        end)
    end

    return stop
end

return table.freeze(t2)
