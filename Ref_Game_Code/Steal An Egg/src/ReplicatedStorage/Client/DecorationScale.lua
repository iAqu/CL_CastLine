-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ViewportSize = require(ReplicatedStorage.Client.ViewportSize)
local t1 = {
    LeftControls = true,
    RightButtons = true
}
local t2 = {
    Chat = true,
    TouchGui = true
}
local t3 = {
    ImageButton = {
        Property = "SliceScale",
        Baseline = "AuthoredSliceScale",
        Applies = function(p1) -- Applies | line: 39
            return p1.ScaleType == Enum.ScaleType.Slice
        end
    },
    ImageLabel = {
        Property = "SliceScale",
        Baseline = "AuthoredSliceScale",
        Applies = function(p2) -- Applies | line: 46
            return p2.ScaleType == Enum.ScaleType.Slice
        end
    },
    UIStroke = {
        Property = "Thickness",
        Baseline = "AuthoredThickness",
        Applies = function(p3) -- Applies | line: 53
            return p3.StrokeSizingMode == Enum.StrokeSizingMode.FixedSize
        end
    }
}
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local n1 = 1

local function isScaledScreen(p4) -- line: 62
    -- upvalues: t2 (copy)
    return p4:IsA("LayerCollector") and t2[p4.Name] ~= true and p4:GetAttribute("ScaledDecoration") ~= false
end

local function screenOf(p5) -- line: 68
    -- upvalues: PlayerGui (copy)
    while p5 ~= nil and p5.Parent ~= PlayerGui do
        p5 = p5.Parent
    end

    return p5
end

local function pinned(p6, p7, p8) -- line: 76
    local Attribute = p6:GetAttribute(p7)

    if type(Attribute) == "number" then
        return Attribute
    end

    p6:SetAttribute(p7, p8)

    return p8
end

local function scaleDecoration(p9) -- line: 85
    -- upvalues: t3 (copy), n1 (ref)
    local v2 = t3[p9.ClassName]
    local Property, Attribute

    if v2 ~= nil and v2.Applies(p9) then
        Property = v2.Property

        local Baseline = v2.Baseline
        local v3 = p9[v2.Property]

        Attribute = p9:GetAttribute(Baseline)

        if type(Attribute) ~= "number" then
            Attribute = v3
            p9:SetAttribute(Baseline, v3)
        end

        p9[Property] = Attribute * n1
    end
end

local function refit(p10) -- line: 94
    -- upvalues: t2 (copy), t3 (copy), PlayerGui (copy), n1 (ref)
    n1 = math.lerp(1, p10, 0.45)

    for _, child in PlayerGui:GetChildren() do
        local LayerCollector = child:IsA("LayerCollector") and t2[child.Name] ~= true and child:GetAttribute("ScaledDecoration") ~= false

        if LayerCollector then
            for _, descendant in child:GetDescendants() do
                local v4 = t3[descendant.ClassName]

                if v4 ~= nil and v4.Applies(descendant) then
                    local Property, Baseline = v4.Property, v4.Baseline
                    local v5 = descendant[v4.Property]
                    local Attribute = descendant:GetAttribute(Baseline)

                    if type(Attribute) ~= "number" then
                        Attribute = v5
                        descendant:SetAttribute(Baseline, v5)
                    end

                    descendant[Property] = Attribute * n1
                end
            end
        end
    end
end

local function adoptLater(p11) -- line: 106
    -- upvalues: t2 (copy), t3 (copy), PlayerGui (copy), n1 (ref)
    task.defer(function() -- line: 107
        -- upvalues: p11 (copy), t2 (copy), t3 (copy), PlayerGui (copy), n1 (ref)
        local v6 = p11

        while v6 ~= nil and v6.Parent ~= PlayerGui do
            v6 = v6.Parent
        end

        if v6 == nil then
            return
        end

        local LayerCollector = v6:IsA("LayerCollector") and t2[v6.Name] ~= true and v6:GetAttribute("ScaledDecoration") ~= false

        if LayerCollector then
            local v7 = t3[p11.ClassName]

            if v7 ~= nil then
                if not v7.Applies(p11) then
                    return
                end

                local Property, Baseline = v7.Property, v7.Baseline
                local v8 = p11[v7.Property]
                local Attribute = p11:GetAttribute(Baseline)

                if type(Attribute) ~= "number" then
                    Attribute = v8
                    p11:SetAttribute(Baseline, v8)
                end

                p11[Property] = Attribute * n1
            end
        end
    end)
end

PlayerGui.DescendantAdded:Connect(function(p12) -- line: 115
    -- upvalues: t2 (copy), t3 (copy), PlayerGui (copy), n1 (ref)
    if t3[p12.ClassName] ~= nil then
        task.defer(function() -- line: 107
            -- upvalues: p12 (copy), t2 (copy), t3 (copy), PlayerGui (copy), n1 (ref)
            local v9 = p12

            while v9 ~= nil and v9.Parent ~= PlayerGui do
                v9 = v9.Parent
            end

            if v9 == nil then
                return
            end

            local LayerCollector = v9:IsA("LayerCollector") and t2[v9.Name] ~= true and v9:GetAttribute("ScaledDecoration") ~= false

            if LayerCollector then
                local v10 = t3[p12.ClassName]

                if v10 ~= nil then
                    if not v10.Applies(p12) then
                        return
                    end

                    local Property, Baseline = v10.Property, v10.Baseline
                    local v11 = p12[v10.Property]
                    local Attribute = p12:GetAttribute(Baseline)

                    if type(Attribute) ~= "number" then
                        Attribute = v11
                        p12:SetAttribute(Baseline, v11)
                    end

                    p12[Property] = Attribute * n1
                end
            end
        end)
    end
end)
ViewportSize.Observe(function(_, p14) -- line: 121
    -- upvalues: refit (copy)
    refit(p14)
end)
task.spawn(function() -- line: 128
    -- upvalues: ReplicatedStorage (copy), ViewportSize (copy), t1 (copy)
    local Hud = require(ReplicatedStorage.Client.Hud)
    local t4 = {}

    for _, v12 in { "Game", "Treadmill" } do
        for _, child in Hud.Frame(v12):GetChildren() do
            if child:IsA("Frame") and t1[child.Name] == true then
                local UIScale = Instance.new("UIScale")

                UIScale.Name = "HudFitScale"
                UIScale.Parent = child
                table.insert(t4, UIScale)
            end
        end
    end

    ViewportSize.Observe(function(_, p16) -- line: 144
        -- upvalues: t4 (copy)
        local v13 = (1 + 0.1 / p16) / 1.1

        for _, v14 in t4 do
            v14.Scale = v13
        end
    end)
end)

return table.freeze({})
