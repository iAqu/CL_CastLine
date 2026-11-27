-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t2 = {}

return {
    Holder = function(p1) -- Holder | line: 16
        -- upvalues: t2 (copy)
        local v1 = t2[p1]

        return v1 and v1.at or p1
    end,
    Watch = function(p2) -- Watch | line: 21
        -- upvalues: t2 (copy)
        if t2[p2] then
            return
        end

        local Frame = Instance.new("Frame")

        Frame.Name = p2.Name .. "Rest"
        Frame.BackgroundTransparency = 1
        Frame.BorderSizePixel = 0
        Frame.ClipsDescendants = true

        local AnchorPoint, Position, Size = p2.AnchorPoint, p2.Position, p2.Size

        Frame.AnchorPoint = AnchorPoint
        Frame.Position = Position
        Frame.Size = Size

        local ZIndex, LayoutOrder, Visible = p2.ZIndex, p2.LayoutOrder, p2.Visible

        Frame.ZIndex = ZIndex
        Frame.LayoutOrder = LayoutOrder
        Frame.Visible = Visible
        Frame.Parent = p2.Parent

        local t3 = {
            at = p2
        }

        t2[p2] = t3

        local t4 = {}
        local Parent = p2.Parent

        while Parent and Parent:IsA("GuiObject") do
            t4[#t4 + 1] = Parent
            Parent = Parent.Parent
        end

        local function move(p3) -- line: 39
            -- upvalues: t3 (copy)
            if t3.at == p3 then
                return
            end

            for _, child in ipairs(t3.at:GetChildren()) do
                child.Parent = p3
            end

            t3.at = p3
        end

        local function check() -- line: 44
            -- upvalues: p2 (copy), Frame (copy), t3 (copy), t4 (copy)
            for _, v2 in ipairs(t4) do
                if v2.Rotation ~= 0 then
                    if t3.at ~= p2 then
                        for _, child in ipairs(t3.at:GetChildren()) do
                            child.Parent = p2
                        end

                        t3.at = p2
                    end

                    return
                end
            end

            if t3.at ~= Frame then
                for _, child in ipairs(t3.at:GetChildren()) do
                    child.Parent = Frame
                end

                t3.at = Frame
            end
        end

        for _, v3 in ipairs(t4) do
            v3:GetPropertyChangedSignal("Rotation"):Connect(check)
        end

        p2:GetPropertyChangedSignal("Visible"):Connect(function() -- line: 51
            -- upvalues: p2 (copy), Frame (copy)
            Frame.Visible = p2.Visible
        end)

        for _, v4 in ipairs({ "Position", "Size", "AnchorPoint" }) do
            p2:GetPropertyChangedSignal(v4):Connect(function() -- line: 53
                -- upvalues: p2 (copy), Frame (copy), v4 (copy)
                Frame[v4] = p2[v4]
            end)
        end

        check()
    end
}
