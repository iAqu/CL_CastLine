-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local UserInputService = game:GetService("UserInputService")
local v1 = false
local n1 = 0
local t1 = {
    isDragging = function() -- isDragging | line: 25
        -- upvalues: v1 (ref)
        return v1
    end,
    justDropped = function() -- justDropped | line: 30
        -- upvalues: n1 (ref)
        return os.clock() < n1
    end,
    over = function(p1, p2) -- over | line: 35
        if not p1.Visible then
            return false
        end

        local AbsolutePosition, AbsoluteSize = p1.AbsolutePosition, p1.AbsoluteSize

        if p2.X >= AbsolutePosition.X and p2.X <= AbsolutePosition.X + AbsoluteSize.X and p2.Y >= AbsolutePosition.Y then
            return p2.Y <= AbsolutePosition.Y + AbsoluteSize.Y
        end

        return false
    end
}

local function makeGhost(p3, p4) -- line: 43
    local Frame = Instance.new("Frame")

    Frame.Name = "DragGhost"
    Frame.BackgroundTransparency = 1
    Frame.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame.Size = UDim2.fromOffset(p3.AbsoluteSize.X * 1.1, p3.AbsoluteSize.Y * 1.1)
    Frame.ZIndex = 50

    local Viewport = p3:FindFirstChild("Viewport")

    if Viewport then
        local clone = Viewport:Clone()

        clone.AnchorPoint = Vector2.new(0.5, 0.5)
        clone.Position = UDim2.fromScale(0.5, 0.5)
        clone.Size = UDim2.fromScale(1, 1)
        clone.ZIndex = 51
        clone.Parent = Frame
    end

    Frame.Parent = p4

    return Frame
end

local function place(p5, p6, p7) -- line: 63
    local AbsolutePosition = p6.AbsolutePosition

    p5.Position = UDim2.fromOffset(p7.X - AbsolutePosition.X, p7.Y - AbsolutePosition.Y)
end

function t1.attach(p8, p9) -- line: 68
    -- upvalues: UserInputService (copy), v1 (ref), n1 (ref), makeGhost (copy)
    p8.InputBegan:Connect(function(p10) -- line: 69
        -- upvalues: p8 (copy), p9 (copy), UserInputService (copy), v1 (ref), n1 (ref), makeGhost (copy)
        local UserInputType = p10.UserInputType
        local v2 = UserInputType == Enum.UserInputType.Touch

        if not v1 and (UserInputType == Enum.UserInputType.MouseButton1 or v2) and p9.canStart() then
            local v3 = Vector2.new(p10.Position.X, p10.Position.Y)
            local elapsed = os.clock()
            local v4 = v3
            local v5
            local v6 = false
            local t2 = {}

            local function finish(p11) -- line: 94
                -- upvalues: v4 (ref), v5 (ref), t2 (copy), p9 (copy), v1 (ref), n1 (ref)
                for _, v7 in t2 do
                    v7:Disconnect()
                end

                if p9.scroller then
                    p9.scroller.ScrollingEnabled = true
                end

                if v5 then
                    v5:Destroy()
                    v5 = nil
                    v1 = false
                    n1 = os.clock() + 0.15

                    if p11 then
                        p9.onDrop(v4)
                    end
                end
            end

            table.insert(t2, UserInputService.InputChanged:Connect(function(p12) -- line: 112
                -- upvalues: p10 (copy), v3 (copy), v4 (ref), v5 (ref), v6 (ref), t2 (copy), v2 (copy), p8 (copy), p9 (copy), v1 (ref), n1 (ref), makeGhost (copy)
                if not (if v2 then p12 == p10 else p12.UserInputType == Enum.UserInputType.MouseMovement) then
                    return
                end

                v4 = Vector2.new(p12.Position.X, p12.Position.Y)

                if v5 then
                    local v9 = v5
                    local gui = p9.gui
                    local v10 = v4
                    local AbsolutePosition = gui.AbsolutePosition

                    v9.Position = UDim2.fromOffset(v10.X - AbsolutePosition.X, v10.Y - AbsolutePosition.Y)
                elseif v2 then
                    if (v4 - v3).Magnitude > 12 then
                        v6 = true

                        for _, v11 in t2 do
                            v11:Disconnect()
                        end

                        if p9.scroller then
                            p9.scroller.ScrollingEnabled = true
                        end

                        if v5 then
                            v5:Destroy()
                            v5 = nil
                            v1 = false
                            n1 = os.clock() + 0.15
                        end
                    end
                elseif (v4 - v3).Magnitude >= 10 and not v5 and not v6 then
                    if not p9.canStart() then
                        return
                    end

                    v1 = true
                    v5 = makeGhost(p8, p9.gui)

                    local v12 = v5
                    local gui = p9.gui
                    local v13 = v4
                    local AbsolutePosition = gui.AbsolutePosition

                    v12.Position = UDim2.fromOffset(v13.X - AbsolutePosition.X, v13.Y - AbsolutePosition.Y)

                    if p9.scroller then
                        p9.scroller.ScrollingEnabled = false
                    end
                end
            end))
            table.insert(t2, UserInputService.InputEnded:Connect(function(p13) -- line: 130
                -- upvalues: p10 (copy), finish (copy), v2 (copy)
                if p13 == p10 or not v2 and p13.UserInputType == Enum.UserInputType.MouseButton1 then
                    finish(true)
                end
            end))

            if v2 then
                task.delay(0.3, function() -- line: 136
                    -- upvalues: p10 (copy), elapsed (copy), v4 (ref), v5 (ref), v6 (ref), p8 (copy), p9 (copy), v1 (ref), makeGhost (copy)
                    if v6
                        or not (os.clock() - elapsed >= 0.3)
                        or p10.UserInputState == Enum.UserInputState.End
                        or v5
                        or v6
                        or not p9.canStart() then
                        return
                    end

                    v1 = true
                    v5 = makeGhost(p8, p9.gui)

                    local v15 = v5
                    local gui = p9.gui
                    local v16 = v4
                    local AbsolutePosition = gui.AbsolutePosition

                    v15.Position = UDim2.fromOffset(v16.X - AbsolutePosition.X, v16.Y - AbsolutePosition.Y)

                    if p9.scroller then
                        p9.scroller.ScrollingEnabled = false
                    end
                end)
            end
        end
    end)
end

return t1
