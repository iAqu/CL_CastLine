-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Log = require(ReplicatedStorage.Packages.Log)
local t = require(ReplicatedStorage.Packages.t)
local _ = {
    fromScale = 0.9,
    toScale = 1.15,
    restScale = 1,
    sharedScaleAttribute = "PressScaleOwner"
}
local v1 = Log.new()

return {
    Start = function(p1, p2, p3) -- beginPulse | line: 18
        -- upvalues: TweenService (copy), t (copy), v1 (copy)
        t.strict(t.instanceIsA("GuiButton"))(p1)
        t.strict(t.Color3)(p2)
        t.strict(t.TweenInfo)(p3)

        local ImageColor3 = p1.ImageColor3
        local UIScale = Instance.new("UIScale")

        UIScale.Parent = p1
        UIScale.Scale = 0.9

        local t1 = {
            TweenService:Create(UIScale, p3, {
                Scale = 1.15
            }),
            TweenService:Create(p1, p3, {
                ImageColor3 = p2
            })
        }

        for _, v2 in t1 do
            v2:Play()
        end

        v1:AtTrace():Log("image pulse running")

        local v3 = false

        local function settle() -- line: 40
            -- upvalues: p1 (copy), ImageColor3 (copy), UIScale (copy), t1 (copy), v3 (ref), v1 (copy)
            if v3 then
                return
            end

            v3 = true

            for _, v4 in t1 do
                v4:Cancel()
            end

            p1.ImageColor3 = ImageColor3
            UIScale.Scale = 1

            if not UIScale:GetAttribute("PressScaleOwner") then
                UIScale:Destroy()
            end

            v1:AtTrace():Log("image pulse stopped")
        end

        return settle
    end
}
