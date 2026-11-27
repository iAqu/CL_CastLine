-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RunService = game:GetService("RunService")
local UIKit = require(script.Parent.UIKit)
local HUD = require(script.Parent.HUD)
local fromRGB = Color3.fromRGB
local t1 = {}

t1.Colors = {
    [2] = {
        fromRGB(130, 240, 90),
        fromRGB(40, 170, 50)
    },
    [4] = {
        fromRGB(90, 180, 255),
        fromRGB(40, 100, 230)
    },
    [8] = {
        fromRGB(190, 120, 255),
        fromRGB(120, 60, 220)
    },
    [16] = {
        fromRGB(255, 210, 70),
        fromRGB(240, 140, 20)
    },
    [32] = {
        fromRGB(255, 110, 200),
        fromRGB(200, 50, 160)
    }
}

function t1.Current() -- line: 20
    local ServerLuck = workspace:GetAttribute("ServerLuck")
    local ServerLuckEnds = workspace:GetAttribute("ServerLuckEnds")

    if type(ServerLuck) == "number" and ServerLuck > 1 and type(ServerLuckEnds) == "number" then
        local v1 = ServerLuckEnds - workspace:GetServerTimeNow()

        if v1 > 0 then
            return ServerLuck, v1
        end
    end

    return 1, 0
end

function t1.Clock(p1) -- line: 33
    local v3 = math.max(0, (math.floor(p1)))
    local v5 = math.floor(v3 / 3600)
    local v7 = math.floor(v3 / 60) % 60
    local v8 = v3 % 60

    if v5 > 0 then
        return string.format("%d:%02d:%02d", v5, v7, v8)
    end

    return string.format("%d:%02d", v7, v8)
end

function t1.Init() -- line: 42
    -- upvalues: RunService (copy), UIKit (copy), HUD (copy), t1 (copy), fromRGB (copy)
    local v9 = UIKit.screenGui("ServerLuck", 4)
    local TextButton = Instance.new("TextButton")

    TextButton.Name = "Pill"
    TextButton.Text = ""
    TextButton.BackgroundTransparency = 1
    TextButton.Size = UDim2.fromOffset(440, 62)
    TextButton.AnchorPoint = Vector2.new(0.5, 0)
    TextButton.Position = UDim2.new(0.5, 0, 0, 10)
    TextButton.Visible = false
    TextButton.Parent = v9

    local v10 = UIKit.frame(TextButton, {
        Name = "Body",
        Corner = 31,
        Stroke = 5,
        Color = fromRGB(130, 240, 90),
        Color2 = fromRGB(40, 170, 50)
    })
    local UIGradient = v10:FindFirstChildOfClass("UIGradient")

    UIKit.clover(v10, 64, {
        ZIndex = 3,
        Position = UDim2.new(0, 2, 0.5, 0),
        AnchorPoint = Vector2.new(0, 0.5)
    })

    local v11 = UIKit.text(v10, {
        Name = "Title",
        Text = "SERVER LUCK",
        TextSize = 32,
        Stroke = 4,
        ZIndex = 3,
        Size = UDim2.new(1, -196, 1, 0),
        Position = UDim2.fromOffset(70, 0),
        XAlign = Enum.TextXAlignment.Left
    })
    local v12 = UIKit.frame(v10, {
        Name = "Time",
        Transparency = 0.15,
        Corner = 22,
        ZIndex = 3,
        Size = UDim2.fromOffset(112, 44),
        Position = UDim2.new(1, -9, 0.5, 0),
        AnchorPoint = Vector2.new(1, 0.5),
        Color = fromRGB(20, 22, 36)
    })
    local v13 = UIKit.text(v12, {
        Name = "Label",
        Text = "",
        TextSize = 28,
        Stroke = 3,
        ZIndex = 4,
        Color = fromRGB(255, 240, 150)
    })

    UIKit.bindPress(TextButton, function() -- line: 59
        -- upvalues: UIKit (copy)
        local Windows = UIKit.Windows
        local v14 = Windows and Windows.Shop

        if v14 then
            v14.Open()
            task.delay(0.15, function() -- line: 64
                local _require = require
                local ShopWindow = script.Parent.ShopWindow
                local ok, result = pcall(_require, ShopWindow)

                if ok and result.ScrollToServerLuck then
                    result.ScrollToServerLuck()
                end
            end)
        end
    end)

    local v15, v16, v17

    local function place() -- line: 77
        -- upvalues: v9 (copy), TextButton (copy), v15 (ref), v16 (ref), v17 (ref)
        local PlayerGui = game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")
        local EventHUD = PlayerGui and PlayerGui:FindFirstChild("EventHUD")

        v15 = v15 or EventHUD and EventHUD:FindFirstChild("Banner")

        local CosmicEvent = PlayerGui and PlayerGui:FindFirstChild("CosmicEvent")

        v16 = v16 or CosmicEvent and CosmicEvent:FindFirstChild("Banner")
        v17 = v17 or CosmicEvent and CosmicEvent:FindFirstChild("FightBars")

        local v18

        for _, v19 in ipairs({ v17, v16, v15 }) do
            if v19 and v19.Visible then
                v18 = v19
                break
            end
        end

        if not v18 then
            TextButton.AnchorPoint = Vector2.new(0.5, 0)
            TextButton.Position = UDim2.new(0.5, 0, 0, 10)

            return
        end

        local FitScale = v9:FindFirstChild("FitScale")
        local v20 = workspace.CurrentCamera.ViewportSize.X / (if not (FitScale and FitScale.Scale > 0) then 1 else FitScale.Scale) / 2
        local v21 = v18.Size.X.Offset / 2 + 12

        if v21 + TextButton.Size.X.Offset + 16 <= v20 then
            TextButton.AnchorPoint = Vector2.new(0, 0)
            TextButton.Position = UDim2.new(0.5, v21, 0, v18.Position.Y.Offset)
        else
            TextButton.AnchorPoint = Vector2.new(0.5, 0)
            TextButton.Position = UDim2.new(0.5, 0, 0, v18 == v17 and 112 or 108)
        end
    end

    t1.Pill = TextButton

    local n1 = 1
    local n2 = 0

    RunService.Heartbeat:Connect(function(p2) -- line: 111
        -- upvalues: TextButton (copy), v10 (copy), UIGradient (copy), v11 (copy), v13 (copy), place (copy), n1 (ref), n2 (ref), UIKit (copy), HUD (copy), t1 (copy)
        n2 += p2

        if n2 < 0.2 then
            return
        end

        n2 = 0

        local v22, v23 = t1.Current()

        TextButton.Visible = v22 > 1 and HUD.GetMode() ~= "cutscene"
        place()

        if v22 > 1 then
            v11.Text = "SERVER LUCK x" .. v22
            v13.Text = t1.Clock(v23)

            local v25

            if v22 ~= n1 then
                v25 = t1.Colors[v22] or t1.Colors[2]
                UIGradient.Color = ColorSequence.new(v25[1], v25[2])

                if n1 < v22 then
                    UIKit.pop(v10, 1.3)
                end
            end
        end

        n1 = v22
    end)
end

return t1
