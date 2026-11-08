-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local t = require(ReplicatedStorage.Packages.t)
local Completed = Enum.PlaybackState.Completed
local t1 = {
    fadeSeconds = 0.2,
    easing = Enum.EasingStyle.Quad,
    direction = Enum.EasingDirection.Out,
    shown = {
        OutlineTransparency = 0
    },
    hidden = {
        OutlineTransparency = 1
    },
    restingLook = {
        FillTransparency = 1,
        OutlineTransparency = 1,
        DepthMode = Enum.HighlightDepthMode.Occluded,
        FillColor = Color3.fromRGB(255, 255, 255),
        OutlineColor = Color3.fromRGB(255, 255, 255)
    }
}

local function glide(p1, p2, p3) -- line: 25
    -- upvalues: TweenService (copy), t1 (copy)
    local tween = TweenService:Create(p1, TweenInfo.new(p3 or t1.fadeSeconds, t1.easing, t1.direction), p2)

    tween:Play()

    return tween
end

return {
    FadeIn = function(p4, p5, p6) -- raise | line: 33
        -- upvalues: TweenService (copy), t (copy), t1 (copy)
        t.strict(t.instanceIsA("Model"))(p4)
        t.strict(t.string)(p5)
        t.strict(t.optional(t.number))(p6)

        local restingLook = t1.restingLook
        local Highlight = Instance.new("Highlight")

        for v2, v3 in restingLook do
            Highlight[v2] = v3
        end

        Highlight.Adornee = p4
        Highlight.Name = p5
        Highlight.Parent = p4

        local shown = t1.shown

        TweenService:Create(Highlight, TweenInfo.new(p6 or t1.fadeSeconds, t1.easing, t1.direction), shown):Play()

        return Highlight
    end,
    FadeOut = function(p7, p8) -- lower | line: 51
        -- upvalues: TweenService (copy), t (copy), Completed (copy), t1 (copy)
        assert(p7:IsA("Highlight"), "fade-out was handed something that is not a Highlight")
        t.strict(t.optional(t.number))(p8)

        local function reap(p9) -- line: 55
            -- upvalues: p7 (copy), Completed (copy)
            if p9 == Completed then
                p7:Destroy()
            end
        end

        local hidden = t1.hidden
        local tween = TweenService:Create(p7, TweenInfo.new(p8 or t1.fadeSeconds, t1.easing, t1.direction), hidden)

        tween:Play()
        tween.Completed:Once(reap)
    end
}
