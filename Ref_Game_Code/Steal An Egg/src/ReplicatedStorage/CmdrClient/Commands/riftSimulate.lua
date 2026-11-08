-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    "EEE",
    "EEM",
    "EEH",
    "EMM",
    "EMH"
}
local t2 = {
    Name = "riftSimulate",
    Description = "Simulates Rift recipe rolls per banner with the live flags and shows the difficulty mix in a panel. Runs on your client.",
    Group = "Admin",
    Aliases = { "riftSim" },
    Args = {
        {
            Type = "string",
            Name = "Banner",
            Description = "Banner id or display name (Verdant/Riftborn, Umbral/Riftbeasts, Radiant/Shattered Rift), or all.",
            Optional = true,
            Default = "all"
        },
        {
            Type = "integer",
            Name = "Runs",
            Description = "Recipes rolled per banner, up to 100000. Defaults to 10000.",
            Optional = true,
            Default = 10000
        }
    }
}
local t3 = {
    Verdant = {
        EEE = 3.1,
        EEM = 32.1,
        EEH = 0.7,
        EMM = 61.1,
        EMH = 2.9,
        Distinct = 818
    },
    Umbral = {
        EEE = 3.5,
        EEM = 32.2,
        EEH = 4.8,
        EMM = 43,
        EMH = 16.4,
        Distinct = 579
    },
    Radiant = {
        EEE = 2.5,
        EEM = 32.4,
        EEH = 1.6,
        EMM = 57.1,
        EMH = 6.3,
        Distinct = 514
    }
}

function t2.ClientRun(_, p2, p3) -- line: 37
    -- upvalues: t1 (copy), t3 (copy)
    local Players = game:GetService("Players")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local Rift = require(ReplicatedStorage.Data.Rift)
    local RiftRecipes = require(ReplicatedStorage.Shared.Modules.RiftRecipes)
    local RiftZoneLadder = require(ReplicatedStorage.Shared.Modules.RiftZoneLadder)
    local v1 = string.lower(p2 or "all")
    local t4 = {}

    for _, v2 in Rift.BannerIds() do
        if v1 == "all" or string.lower(v2) == v1 or string.lower(Rift.GetBannerDisplayName(v2)) == v1 then
            table.insert(t4, v2)
        end
    end

    if #t4 == 0 then
        return (("Unknown banner \"%*\" - use %* or all"):format(p2, (table.concat(Rift.BannerIds(), ", "))))
    end

    local v5 = math.clamp(math.floor(p3 or 10000), 1, 1E+05)
    local t5 = {}

    local function line(p4, p5) -- line: 57
        -- upvalues: t5 (copy)
        table.insert(t5, {
            text = p4,
            color = p5
        })
    end

    local v6 = RiftZoneLadder.Get()
    local t7 = {}

    for v7, v8 in v6 do
        table.insert(t7, (("%*.%*"):format(v7, v8.Id)))
    end

    table.insert(t5, {
        text = ("Zone ladder (by escape speed): %*"):format((table.concat(t7, "  "))),
        color = Color3.fromRGB(180, 180, 200)
    })

    local v10 = RiftRecipes.ResolveConfig()

    table.insert(t5, {
        text = ("Bands: Easy >= %*%%  Medium >= %*%%  Hard >= %*%%  |  HardPenalty %*  ExtendBelow %*  Attempts %*"):format(v10.EasyBand, v10.MediumBand, v10.MinSpawnChance, v10.HardPenalty, v10.ExtendBelow, v10.MaxRecipeAttempts),
        color = Color3.fromRGB(180, 180, 200)
    })
    table.insert(t5, {
        text = "",
        color = nil
    })

    local t11 = {}

    for _, v11 in t4 do
        local v12, v13 = Rift.GetBannerRange(v11)
        local v14 = RiftRecipes.Simulate(v11, v5)

        table.insert(t5, {
            text = ("%* (%*)  %* -> %*"):format(Rift.GetBannerDisplayName(v11), v11, v12, v13),
            color = Color3.fromRGB(255, 220, 120)
        })

        if v14.Error ~= nil then
            table.insert(t5, {
                text = ("  ERROR: %*"):format(v14.Error),
                color = Color3.fromRGB(255, 90, 90)
            })
            table.insert(t5, {
                text = "",
                color = nil
            })
            table.insert(t11, (("%*: ERROR %*"):format(v11, v14.Error)))
        else
            table.insert(t5, {
                color = nil,
                text = ("  pool %* -> %* (%* pets: Easy %*  Medium %*  Hard %*  Excluded %*)"):format(v14.PoolBottom, v14.PoolTop, v14.PoolSize, v14.Bands.Easy, v14.Bands.Medium, v14.Bands.Hard, v14.Bands.Excluded)
            })

            local v15 = v5 - v14.Failures
            local v16 = if v14.Failures > 0 or v14.NonZonePicks > 0 then Color3.fromRGB(255, 90, 90) else Color3.fromRGB(140, 230, 140)

            table.insert(t5, {
                text = ("  runs %*  failed %* (%*%%)  non-zone picks %*  distinct %* (ref %*)"):format(v5, v14.Failures, string.format("%.2f", 100 * v14.Failures / v5), v14.NonZonePicks, v14.Distinct, t3[v11] and t3[v11].Distinct or "-"),
                color = v16
            })
            table.insert(t5, {
                text = "  pattern     sim%     ref%    delta",
                color = nil
            })

            local t16 = {}

            local function patternLine(p6) -- line: 97
                -- upvalues: t5 (copy), v11 (copy), v14 (copy), v15 (copy), t16 (copy), t3 (copy)
                t16[p6] = true

                local v17 = v14.Patterns[p6] or 0
                local v18 = if v15 > 0 then 100 * v17 / v15 else 0
                local v20 = t3[v11] and t3[v11][p6] or nil
                local v21 = if v20 == nil then "     -" else string.format("%6.1f", v20)
                local v22 = if v20 == nil then "      " else string.format("%+6.1f", v18 - v20)
                local v23 = v20 ~= nil and math.abs(v18 - v20) > 1.5

                table.insert(t5, {
                    text = ("  %*   %*  %*  %*"):format(p6, string.format("%7.2f", v18), v21, v22),
                    color = if v23 then Color3.fromRGB(255, 170, 90) else nil
                })
            end

            for _, v25 in t1 do
                patternLine(v25)
            end

            for v26 in v14.Patterns do
                if not t16[v26] then
                    patternLine(v26)
                end
            end

            for v27, v28 in v14.SlotPicks do
                local t18 = {}

                for v29, v30 in v28 do
                    table.insert(t18, {
                        v29,
                        v30
                    })
                end

                table.sort(t18, function(p7, p8) -- line: 123
                    return p7[2] > p8[2]
                end)

                local t20 = {}

                for i = 1, math.min(5, #t18) do
                    local v32 = t18[i]

                    table.insert(t20, (("%* %*%%"):format(v32[1], (string.format("%.1f", 100 * v32[2] / math.max(v15, 1))))))
                end

                table.insert(t5, {
                    text = ("  slot %* top: %*"):format(v27, (table.concat(t20, "  "))),
                    color = Color3.fromRGB(170, 200, 255)
                })
            end

            table.insert(t5, {
                text = "",
                color = nil
            })

            local v34 = if v15 > 0 then 100 * (v14.Patterns.EMH or 0) / v15 else 0

            table.insert(t11, (("%*: EMH %*%%  distinct %*  failed %*  non-zone %*"):format(v11, string.format("%.1f", v34), v14.Distinct, v14.Failures, v14.NonZonePicks)))
        end
    end

    local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
    local RiftSimulatePanel = PlayerGui:FindFirstChild("RiftSimulatePanel")

    if RiftSimulatePanel then
        RiftSimulatePanel:Destroy()
    end

    local ScreenGui = Instance.new("ScreenGui")

    ScreenGui.Name = "RiftSimulatePanel"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.DisplayOrder = 1000
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local Frame = Instance.new("Frame")

    Frame.Name = "Panel"
    Frame.AnchorPoint = Vector2.new(0.5, 0.5)
    Frame.Position = UDim2.fromScale(0.5, 0.5)
    Frame.Size = UDim2.fromScale(0.72, 0.78)
    Frame.BackgroundColor3 = Color3.fromRGB(18, 18, 26)
    Frame.BackgroundTransparency = 0.04
    Frame.BorderSizePixel = 0
    Frame.Parent = ScreenGui

    local UICorner = Instance.new("UICorner")

    UICorner.CornerRadius = UDim.new(0, 10)
    UICorner.Parent = Frame

    local TextLabel = Instance.new("TextLabel")

    TextLabel.Name = "Header"
    TextLabel.Size = UDim2.new(1, -60, 0, 36)
    TextLabel.Position = UDim2.fromOffset(14, 4)
    TextLabel.BackgroundTransparency = 1
    TextLabel.Font = Enum.Font.GothamBold
    TextLabel.TextSize = 18
    TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel.Text = ("Rift recipe simulation - %* runs per banner"):format(v5)
    TextLabel.Parent = Frame

    local TextButton = Instance.new("TextButton")

    TextButton.Name = "RiftSimDismiss"
    TextButton.Size = UDim2.fromOffset(34, 28)
    TextButton.Position = UDim2.new(1, -42, 0, 8)
    TextButton.BackgroundColor3 = Color3.fromRGB(117, 38, 46)
    TextButton.BorderSizePixel = 0
    TextButton.Font = Enum.Font.GothamBold
    TextButton.TextSize = 18
    TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextButton.Text = "X"
    TextButton.Parent = Frame

    local UICorner2 = Instance.new("UICorner")

    UICorner2.CornerRadius = UDim.new(0, 6)
    UICorner2.Parent = TextButton
    TextButton.Activated:Connect(function() -- line: 192
        -- upvalues: ScreenGui (copy)
        ScreenGui:Destroy()
    end)

    local ScrollingFrame = Instance.new("ScrollingFrame")

    ScrollingFrame.Name = "Lines"
    ScrollingFrame.Position = UDim2.fromOffset(14, 44)
    ScrollingFrame.Size = UDim2.new(1, -28, 1, -56)
    ScrollingFrame.BackgroundTransparency = 1
    ScrollingFrame.BorderSizePixel = 0
    ScrollingFrame.ScrollBarThickness = 6
    ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.XY
    ScrollingFrame.CanvasSize = UDim2.new()
    ScrollingFrame.Parent = Frame

    local UIListLayout = Instance.new("UIListLayout")

    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 1)
    UIListLayout.Parent = ScrollingFrame

    local t25 = {}

    for v37, v38 in t5 do
        local TextLabel = Instance.new("TextLabel")

        TextLabel.Name = ("Line%*"):format(v37)
        TextLabel.LayoutOrder = v37
        TextLabel.AutomaticSize = Enum.AutomaticSize.XY
        TextLabel.Size = UDim2.new(1, 0, 0, 16)
        TextLabel.BackgroundTransparency = 1
        TextLabel.Font = Enum.Font.Code
        TextLabel.TextSize = 14
        TextLabel.TextXAlignment = Enum.TextXAlignment.Left
        TextLabel.TextColor3 = v38.color or Color3.fromRGB(230, 230, 235)
        TextLabel.Text = v38.text
        TextLabel.Parent = ScrollingFrame
        table.insert(t25, v38.text)
    end

    ScreenGui.Parent = PlayerGui
    print("[riftSimulate]\n" .. table.concat(t25, "\n"))

    return table.concat(t11, "\n")
end

return t2
