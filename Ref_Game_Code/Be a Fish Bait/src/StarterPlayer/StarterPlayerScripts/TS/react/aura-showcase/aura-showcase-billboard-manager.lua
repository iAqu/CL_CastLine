-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useState = react.useEffect, react.useState
local createPortal = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react-roblox").createPortal
local useFlameworkComponents = RuntimeLib.import(script, script.Parent.Parent, "hooks", "use-flamework-components").useFlameworkComponents
local default = RuntimeLib.import(script, script.Parent.Parent, "common", "styled-text-label").default
local auraShowcaseAuraAttribute = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "bait-aura-showcase").auraShowcaseAuraAttribute
local getBaitAuraConfig = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "bait-aura-utils").getBaitAuraConfig
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "rarity-utils")
local getRarityColor, getRarityDisplayName = v1.getRarityColor, v1.getRarityDisplayName
local v2 = Color3.fromRGB(255, 255, 255)

local function AuraShowcaseBillboard(p1) -- line: 16
    -- upvalues: react (copy), createPortal (copy), default (copy), getBaitAuraConfig (copy), getRarityColor (copy), getRarityDisplayName (copy), v2 (copy)
    local billboard = p1.billboard
    local v3 = getBaitAuraConfig(p1.auraName)

    if v3 == nil then
        return nil
    end

    return createPortal(react.createElement("frame", {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1)
    }, react.createElement("uilistlayout", {
        FillDirection = Enum.FillDirection.Vertical,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Padding = UDim.new(0, 2),
        SortOrder = Enum.SortOrder.LayoutOrder,
        VerticalAlignment = Enum.VerticalAlignment.Center
    }), react.createElement(default, {
        hasStroke = true,
        color = v2,
        overrideProps = {
            BackgroundTransparency = 1,
            LayoutOrder = 1,
            TextScaled = true,
            TextSize = 30,
            Font = Enum.Font.FredokaOne,
            Size = UDim2.fromScale(1, 0.52),
            TextXAlignment = Enum.TextXAlignment.Center
        },
        strokeProps = {
            Thickness = 0.1,
            Color = Color3.fromRGB(0, 0, 0)
        },
        text = v3.displayName
    }), react.createElement(default, {
        hasStroke = true,
        color = getRarityColor(v3.rarity),
        overrideProps = {
            BackgroundTransparency = 1,
            LayoutOrder = 2,
            TextScaled = true,
            TextSize = 20,
            Font = Enum.Font.FredokaOne,
            Size = UDim2.fromScale(1, 0.42),
            TextXAlignment = Enum.TextXAlignment.Center
        },
        strokeProps = {
            Thickness = 0.1,
            Color = Color3.fromRGB(0, 0, 0)
        },
        text = getRarityDisplayName(v3.rarity)
    })), billboard)
end

local function AuraShowcaseBillboardForComponent(p2) -- line: 68
    -- upvalues: react (copy), useEffect (copy), useState (copy), auraShowcaseAuraAttribute (copy), AuraShowcaseBillboard (copy)
    local component = p2.component
    local v4, v5 = useState(function() -- line: 70
        -- upvalues: component (copy), auraShowcaseAuraAttribute (copy)
        local Attribute = component.instance:GetAttribute(auraShowcaseAuraAttribute)

        return if type(Attribute) == "string" then Attribute else nil
    end)

    useEffect(function() -- line: 74
        -- upvalues: component (copy), v5 (copy), auraShowcaseAuraAttribute (copy)
        local connection = component.instance:GetAttributeChangedSignal(auraShowcaseAuraAttribute):Connect(function() -- line: 75
            -- upvalues: component (copy), v5 (copy), auraShowcaseAuraAttribute (copy)
            local Attribute = component.instance:GetAttribute(auraShowcaseAuraAttribute)

            if type(Attribute) ~= "string" then
                Attribute = nil
            end

            v5(Attribute)
        end)

        return function() -- line: 79
            -- upvalues: connection (copy)
            return connection:Disconnect()
        end
    end, { component })

    local v6 = component.instance:FindFirstChild("BillboardAdornee", true)
    local BillboardGui = if (if v6 == nil then v6 else v6:IsA("BasePart")) == true then v6:FindFirstChildOfClass("BillboardGui") else nil

    if BillboardGui == nil then
        return nil
    end

    return react.createElement(AuraShowcaseBillboard, {
        auraName = v4,
        billboard = BillboardGui
    })
end

return {
    AuraShowcaseBillboard = AuraShowcaseBillboard,
    default = function() -- AuraShowcaseBillboardManager | line: 97
        -- upvalues: react (copy), useFlameworkComponents (copy), AuraShowcaseBillboardForComponent (copy)
        local v7 = useFlameworkComponents(function() -- line: 98
            return true
        end, "client/components/aura-showcase-podium-component@AuraShowcasePodiumComponent")
        local v8 = table.create(#v7)

        local function v9(p3) -- line: 103
            -- upvalues: react (copy), AuraShowcaseBillboardForComponent (copy)
            return react.createElement(AuraShowcaseBillboardForComponent, {
                component = p3,
                key = tostring(p3.instance)
            })
        end

        for v10, v11 in v7 do
            local _ = v10 - 1

            v8[v10] = react.createElement(AuraShowcaseBillboardForComponent, {
                component = v11,
                key = tostring(v11.instance)
            })
        end

        return react.createElement(react.Fragment, nil, v8)
    end
}
