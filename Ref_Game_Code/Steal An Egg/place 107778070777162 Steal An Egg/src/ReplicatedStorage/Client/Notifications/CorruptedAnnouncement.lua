-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local SammyPortrait = require(script.Parent.SammyPortrait)
local SammyNotif = ReplicatedStorage.Assets.UI.Notifs.SammyNotif
local t1 = {}

local function startsWith(p1, p2) -- line: 30
    return string.sub(p1, 1, #p2) == p2
end

function t1.Create(p3, p4) -- line: 34
    -- upvalues: RunService (copy), SammyPortrait (copy), SammyNotif (copy)
    local v2 = (utf8.len(p3) or #p3) > 56
    local clone = SammyNotif:Clone()
    local Main, Portrait = clone.Main, clone.Portrait
    local SammyName, Dialogue = Main.SammyName, Main.Dialogue
    local UIAspectRatioConstraint = clone:FindFirstChildOfClass("UIAspectRatioConstraint")

    if UIAspectRatioConstraint then
        UIAspectRatioConstraint.AspectRatio = clone:GetAttribute(v2 and "AspectLong" or "AspectShort") or UIAspectRatioConstraint.AspectRatio
    end

    local Attribute = clone:GetAttribute(if v2 then "TitleLongY" else "TitleShortY")

    if Attribute then
        SammyName.Position = UDim2.fromScale(SammyName.Position.X.Scale, Attribute)
    end

    SammyName.Text = p4
    Dialogue.Text = p3

    local t2 = {}
    local t3 = {}
    local t4 = {}
    local t5 = {}
    local Scan = Main.Scan

    for _, child in Main:GetChildren() do
        if string.sub(child.Name, 1, 9) == "ChargeArc" then
            table.insert(t2, child)
        elseif string.sub(child.Name, 1, 10) == "ChargeGlow" then
            table.insert(t3, child)
        elseif string.sub(child.Name, 1, 10) == "SignalTear" then
            table.insert(t4, {
                Frame = child,
                Position = child.Position
            })
        elseif string.sub(child.Name, 1, 11) == "SignalGhost" then
            child.Text = p4
            table.insert(t5, {
                Label = child
            })
        end
    end

    local v5, v6, disconnect

    local function stop() -- line: 78
        -- upvalues: v6 (ref), disconnect (ref)
        if v6 then
            v6()
            v6 = nil
        end

        if disconnect then
            disconnect()
            disconnect = nil
        end
    end

    local v7 = false

    return clone, function() -- line: 92
        -- upvalues: clone (copy), Portrait (copy), SammyName (copy), Dialogue (copy), t2 (copy), t3 (copy), t4 (copy), t5 (copy), Scan (copy), v5 (ref), v6 (ref), disconnect (ref), stop (copy), v7 (ref), RunService (copy), SammyPortrait (copy)
        if v7 or clone.Parent == nil then
            return
        end

        v7 = true
        v5, v6 = SammyPortrait.Mount(Portrait)

        local n1 = 0
        local n2 = -1
        local connection, connection2

        function disconnect() -- line: 102
            -- upvalues: connection (ref), connection2 (ref)
            if connection then
                connection:Disconnect()
                connection = nil
            end

            if connection2 then
                connection2:Disconnect()
                connection2 = nil
            end
        end

        connection2 = clone.Destroying:Connect(stop)
        connection = RunService.RenderStepped:Connect(function(p5) -- line: 114
            -- upvalues: n1 (ref), n2 (ref), clone (copy), SammyName (copy), Dialogue (copy), t2 (copy), t3 (copy), t4 (copy), t5 (copy), Scan (copy), v5 (ref), v6 (ref), disconnect (ref)
            if clone.Parent ~= nil then
                n1 += p5

                if v5 then
                    v5(n1)
                end

                local v9 = math.floor(n1 * 14)

                if v9 ~= n2 then
                    n2 = v9

                    for _, v10 in t2 do
                        local Cells = v10:GetAttribute("Cells")

                        if typeof(Cells) == "Vector2" and Cells.X > 0 and Cells.Y > 0 then
                            local v11 = v9 + (v10:GetAttribute("Phase") or 0) * 5

                            v10.ImageRectOffset = Vector2.new(v10.ImageRectSize.X * (v11 % Cells.X), v10.ImageRectSize.Y * (math.floor(v11 / Cells.X) % Cells.Y))
                        end
                    end
                end

                local v14 = n1 % 2.9
                local v15 = if v14 < 0.23 then 1 - v14 / 0.23 else 0
                local v17 = math.sin(n1 * 173) * v15

                for _, v18 in t5 do
                    local v19 = v18.Label:GetAttribute("Drift") or 1

                    v18.Label.Position = SammyName.Position + UDim2.fromScale(v19 * (math.abs(v17) * 0.007 + 0.004), 0)
                    v18.Label.TextTransparency = 1 - v15 * 0.53
                end

                for _, v20 in t4 do
                    local v21 = v20.Frame:GetAttribute("Drift") or 1
                    local v22 = v20.Frame:GetAttribute("Phase") or 0

                    v20.Frame.Position = v20.Position + UDim2.fromScale(v17 * 0.017 * v21, 0)
                    v20.Frame.BackgroundTransparency = 0.67 - v15 * 0.43 + math.sin(n1 * 2 + v22) * 0.12
                end

                for _, v25 in t3 do
                    local v26 = v25:GetAttribute("Phase") or 0

                    v25.ImageTransparency = math.sin(n1 * 2.2 + v26) * 0.035 + 0.9
                end

                Scan.Position = UDim2.fromScale(0.12, n1 * 0.19 % 1 * 0.8 + 0.1)
                Dialogue.TextTransparency = 0
            else
                if v6 then
                    v6()
                    v6 = nil
                end

                if disconnect then
                    disconnect()
                    disconnect = nil
                end
            end
        end)
    end, stop
end

return t1
