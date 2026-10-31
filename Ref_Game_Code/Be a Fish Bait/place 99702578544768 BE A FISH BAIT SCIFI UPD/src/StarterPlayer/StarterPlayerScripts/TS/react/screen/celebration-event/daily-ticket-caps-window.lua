-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "br-window").default
local default2 = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-text-two").default
local images = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images").images
local v1 = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 221, 110)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 185, 40)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(230, 140, 10))
})
local v2 = Color3.fromRGB(255, 220, 130)
local v3 = Color3.new(1, 1, 1)
local v4 = Color3.new(0, 0, 0)
local v5 = Color3.fromRGB(255, 220, 150)
local v6 = Color3.fromRGB(90, 60, 0)

local function TicketCapRow(p1) -- line: 22
    -- upvalues: react (copy), default2 (copy), images (copy), v3 (copy), v4 (copy), v5 (copy), v6 (copy)
    local entry, layoutOrder = p1.entry, p1.layoutOrder

    return react.createElement("frame", {
        BackgroundTransparency = 1,
        LayoutOrder = layoutOrder,
        Size = UDim2.fromScale(1, 0.14)
    }, react.createElement(default2, {
        anchorPoint = Vector2.new(0, 0.5),
        color = v3,
        overrideProps = {
            TextScaled = true,
            ZIndex = 5,
            Position = UDim2.fromScale(0, 0.5),
            Size = UDim2.fromScale(0.5, 0.75),
            TextXAlignment = Enum.TextXAlignment.Left
        },
        popoutColor = v4,
        strokeProps = {
            Color = v4
        },
        text = ("%*:"):format(entry.label)
    }), react.createElement("frame", {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1)
    }, react.createElement("uilistlayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        Padding = UDim.new(0.015, 0),
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Center
    }), react.createElement(default2, {
        color = v5,
        overrideProps = {
            LayoutOrder = 1,
            TextScaled = true,
            ZIndex = 5,
            AutomaticSize = Enum.AutomaticSize.X,
            Size = UDim2.fromScale(0, 1),
            TextXAlignment = Enum.TextXAlignment.Left
        },
        popoutColor = v6,
        strokeProps = {
            Color = v6
        },
        text = ("%* / %*"):format(entry.earned, entry.cap)
    }), react.createElement("imagelabel", {
        BackgroundTransparency = 1,
        LayoutOrder = 2,
        ZIndex = 5,
        Image = images.celebrationTicket,
        ScaleType = Enum.ScaleType.Fit,
        Size = UDim2.fromScale(0.055, 0.8)
    }, react.createElement("uiaspectratioconstraint", {
        AspectRatio = 1
    }))))
end

return {
    default = function(p2) -- DailyTicketCapsWindow | line: 79
        -- upvalues: react (copy), default (copy), v1 (copy), v2 (copy), TicketCapRow (copy)
        local entries, onClose = p2.entries, p2.onClose
        local v7 = react.createElement("uilistlayout", {
            FillDirection = Enum.FillDirection.Vertical,
            HorizontalAlignment = Enum.HorizontalAlignment.Left,
            Padding = UDim.new(0.02, 0),
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Center
        })
        local v8 = table.create(#entries)

        local function v9(p3, p4) -- line: 91
            -- upvalues: react (copy), TicketCapRow (copy)
            return react.createElement(TicketCapRow, {
                entry = p3,
                key = p3.label,
                layoutOrder = p4
            })
        end

        for v10, v11 in entries do
            local v12 = v10 - 1

            v8[v10] = react.createElement(TicketCapRow, {
                entry = v11,
                key = v11.label,
                layoutOrder = v12
            })
        end

        return react.createElement(default, {
            aspectRatio = 1.3,
            bodyTransparency = 0.15,
            title = "Daily Ticket Caps",
            bodyBg = v2,
            headerBg = v1,
            onClose = onClose,
            size = UDim2.fromScale(0.5, 0.55)
        }, react.createElement("frame", {
            BackgroundTransparency = 1,
            ZIndex = 2,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(0.85, 0.8)
        }, v7, v8))
    end
}
