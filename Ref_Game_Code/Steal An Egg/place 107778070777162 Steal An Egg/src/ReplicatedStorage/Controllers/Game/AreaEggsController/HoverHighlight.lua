-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local t = require(ReplicatedStorage.Packages.t)

require(ReplicatedStorage.Packages.Trove)

local t1 = {}

local function showHighlight(p1) -- line: 19
    local Highlight = Instance.new("Highlight")

    Highlight.Name = "AreaEggHover"
    Highlight.FillTransparency = 1
    Highlight.OutlineTransparency = 1
    Highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    Highlight.DepthMode = Enum.HighlightDepthMode.Occluded
    Highlight.Adornee = p1
    Highlight.Parent = p1

    return Highlight
end

function t1.Bind(p2, p3, p4) -- line: 35
    -- upvalues: TweenService (copy), t (copy)
    t.strict(t.instanceIsA("Model"))(p2)
    t.strict(t.Instance)(p3)

    local Highlight

    p4:Connect(p3.PromptShown, function() -- line: 40
        -- upvalues: p2 (copy), Highlight (ref), TweenService (copy)
        if Highlight ~= nil then
            Highlight:Destroy()
        end

        local Highlight2 = Instance.new("Highlight")

        Highlight2.Name = "AreaEggHover"
        Highlight2.FillTransparency = 1
        Highlight2.OutlineTransparency = 1
        Highlight2.OutlineColor = Color3.fromRGB(255, 255, 255)
        Highlight2.DepthMode = Enum.HighlightDepthMode.Occluded
        Highlight2.Adornee = p2
        Highlight2.Parent = p2
        Highlight = Highlight2
        TweenService:Create(Highlight, TweenInfo.new(0.15), {
            OutlineTransparency = 0
        }):Play()
    end)
    p4:Connect(p3.PromptHidden, function() -- line: 47
        -- upvalues: Highlight (ref), TweenService (copy)
        local Highlight2 = Highlight

        Highlight = nil

        if Highlight2 == nil then
            return
        end

        local tween = TweenService:Create(Highlight2, TweenInfo.new(0.12), {
            OutlineTransparency = 1
        })

        tween.Completed:Once(function() -- line: 54
            -- upvalues: Highlight2 (copy)
            Highlight2:Destroy()
        end)
        tween:Play()
    end)
end

return t1
