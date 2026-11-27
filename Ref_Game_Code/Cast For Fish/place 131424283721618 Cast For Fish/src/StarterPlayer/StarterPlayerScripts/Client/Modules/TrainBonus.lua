-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UIKit = require(script.Parent.UIKit)
local fromRGB = Color3.fromRGB
local v1, TextButton, v2, UIStroke, v3, v4
local n1 = 0
local n2 = 1
local n3 = 0
local t1 = {}

t1.Offers = 0
t1.Actives = 0

function t1.IsActive() -- line: 14
    -- upvalues: n3 (ref)
    return os.clock() < n3
end

local function hideButton() -- line: 18
    -- upvalues: TextButton (ref), n1 (ref)
    n1 = 0
    TextButton.Visible = false
end

function t1.Press() -- line: 23
    -- upvalues: ReplicatedStorage (copy), UIKit (copy), TextButton (ref), n1 (ref)
    if TextButton.Visible then
        UIKit.sound("Click")
        ReplicatedStorage.Remotes.TrainBonus:FireServer()
        n1 = 0
        TextButton.Visible = false
    end
end

function t1.Init() -- line: 31
    -- upvalues: RunService (copy), ReplicatedStorage (copy), UIKit (copy), t1 (copy), fromRGB (copy), v1 (ref), TextButton (ref), v2 (ref), UIStroke (ref), v3 (ref), v4 (ref), n1 (ref), n2 (ref), n3 (ref)
    v1 = UIKit.screenGui("TrainBonus", 7)
    TextButton = Instance.new("TextButton")
    TextButton.Name = "Button"
    TextButton.Text = ""
    TextButton.AutoButtonColor = false
    TextButton.Size = UDim2.fromOffset(170, 170)
    TextButton.AnchorPoint = Vector2.new(0.5, 0.5)
    TextButton.BackgroundColor3 = fromRGB(255, 255, 255)
    TextButton.Visible = false
    TextButton.Parent = v1

    local UICorner = Instance.new("UICorner")

    UICorner.CornerRadius = UDim.new(1, 0)
    UICorner.Parent = TextButton

    local UIGradient = Instance.new("UIGradient")

    UIGradient.Rotation = 90
    UIGradient.Color = ColorSequence.new(fromRGB(255, 225, 70), fromRGB(255, 140, 30))
    UIGradient.Parent = TextButton
    UIStroke = Instance.new("UIStroke")
    UIStroke.Thickness = 7
    UIStroke.Color = fromRGB(20, 22, 34)
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UIStroke.Parent = TextButton
    v2 = UIKit.text(TextButton, {
        Name = "Label",
        Text = "2x",
        TextSize = 92,
        Stroke = 8
    })
    v2.Rotation = -8
    TextButton.Activated:Connect(t1.Press)
    v3 = UIKit.frame(v1, {
        Name = "Active",
        Corner = 22,
        Stroke = 6,
        Size = UDim2.fromOffset(360, 70),
        Position = UDim2.new(0.5, 0, 0, 146),
        AnchorPoint = Vector2.new(0.5, 1),
        Color = fromRGB(255, 200, 50),
        Color2 = fromRGB(255, 130, 30)
    })
    v4 = UIKit.text(v3, {
        Name = "Text",
        Text = "",
        TextSize = 44,
        Stroke = 5
    })
    v3.Visible = false
    require(script.Parent.BannerDodge).new(v3)
    ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("TrainBonus").OnClientEvent:Connect(function(p1, p2) -- line: 63
        -- upvalues: UIKit (copy), t1 (copy), TextButton (ref), v3 (ref), n1 (ref), n2 (ref), n3 (ref)
        if p1 == "offer" then
            t1.Offers += 1
            n2 = p2 or 3.5
            n1 = os.clock() + n2

            local v5 = if math.random() < 0.5 then -1 else 1

            TextButton.Position = UDim2.fromScale(0.5 + v5 * (0.16 + math.random() * 0.12), 0.34 + math.random() * 0.26)
            TextButton.Visible = true
            UIKit.pop(TextButton, 0.3)
            UIKit.sound("ZoneChange", 1.3)
        elseif p1 == "active" then
            t1.Actives += 1
            n1 = 0
            TextButton.Visible = false
            n3 = os.clock() + (p2 or 5)
            v3.Visible = true
            UIKit.pop(v3, 0.5)
            UIKit.sound("RevealGood")
        else
            n1 = 0
            TextButton.Visible = false
            n3 = 0
            v3.Visible = false
        end
    end)
    RunService.RenderStepped:Connect(function() -- line: 88
        -- upvalues: TextButton (ref), v2 (ref), UIStroke (ref), v3 (ref), v4 (ref), n1 (ref), n3 (ref)
        local elapsed = os.clock()

        if TextButton.Visible then
            local v6 = n1 - elapsed

            if v6 <= 0 then
                n1 = 0
                TextButton.Visible = false
            else
                local v8 = 1 - math.clamp(v6 / 1.5, 0, 1)

                TextButton.BackgroundTransparency = v8
                UIStroke.Transparency = v8
                v2.TextTransparency = v8

                local UIStroke2 = v2:FindFirstChildOfClass("UIStroke")

                if UIStroke2 then
                    UIStroke2.Transparency = v8
                end

                v2.Rotation = math.sin(elapsed * 9) * 4 + -8
            end
        end

        if v3.Visible then
            local v11 = n3 - elapsed

            if v11 <= 0 then
                v3.Visible = false
            else
                v4.Text = string.format("2x STRENGTH  %.1f", v11)
            end
        end
    end)
end

return t1
