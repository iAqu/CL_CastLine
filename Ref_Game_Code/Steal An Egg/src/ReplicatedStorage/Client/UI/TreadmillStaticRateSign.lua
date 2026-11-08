-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AddCommas = require(ReplicatedStorage.Shared.Utils.Numbers).AddCommas
local t = require(ReplicatedStorage.Packages.t)

return {
    Apply = function(p1, p2, p3) -- Apply | line: 30
        -- upvalues: AddCommas (copy), t (copy)
        t.strict(t.Instance)(p1)
        t.strict(t.Color3)(p2)
        t.strict(t.number)(p3)

        local SpeedPerSecond = p1.SpeedPerSecond

        assert(SpeedPerSecond:IsA("BasePart"), (("Treadmill \"%*\" SpeedPerSecond must be a BasePart"):format(p1.Name)))

        local BillboardGui = SpeedPerSecond.BillboardGui

        assert(BillboardGui:IsA("BillboardGui"), (("Treadmill \"%*\" SpeedPerSecond.BillboardGui must be a BillboardGui"):format(p1.Name)))

        local TextLabel = BillboardGui.Frame.TextLabel

        assert(TextLabel:IsA("TextLabel"), (("Treadmill \"%*\" SpeedPerSecond.BillboardGui.Frame.TextLabel must be a TextLabel"):format(p1.Name)))
        TextLabel.TextColor3 = p2
        TextLabel.Text = ("+%*/step"):format((AddCommas(p3)))

        return BillboardGui
    end
}
