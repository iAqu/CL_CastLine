-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local UserInputService = game:GetService("UserInputService")
local UIUtil = require(script.Parent.Parent.UI.UIUtil)
local t1 = {}
local v1 = false
local connection, Skip, v2

local function getLabel(p1) -- line: 19
    local Skip = p1:FindFirstChild("Skip")

    if Skip then
        return Skip
    end

    local clone = p1.Continue:Clone()

    clone.Name = "Skip"
    clone.Visible = false
    clone.Parent = p1

    return clone
end

function t1.requested() -- line: 32
    -- upvalues: v1 (ref)
    return v1
end

function t1.start(p2, p3) -- line: 36
    -- upvalues: UserInputService (copy), UIUtil (copy), t1 (copy), v1 (ref), connection (ref), Skip (ref), v2 (ref)
    t1.stop()
    v1 = false

    if not p3 then
        return
    end

    local Skip2 = p2:FindFirstChild("Skip")

    if not Skip2 then
        Skip2 = p2.Continue:Clone()
        Skip2.Name = "Skip"
        Skip2.Visible = false
        Skip2.Parent = p2
    end

    Skip = Skip2

    local v3 = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled

    Skip.Text = v3 and "Tap to skip" or "Click to skip"
    Skip.TextTransparency = 0
    Skip.Visible = true

    local Skip4 = Skip

    v2 = task.spawn(function() -- line: 48
        -- upvalues: Skip4 (copy), UIUtil (copy)
        while true do
            UIUtil.tween(Skip4, 0.8, {
                TextTransparency = 0.45
            }, Enum.EasingStyle.Sine)
            task.wait(0.8)
            UIUtil.tween(Skip4, 0.8, {
                TextTransparency = 0
            }, Enum.EasingStyle.Sine)
            task.wait(0.8)
        end
    end)

    local elapsed = os.clock()

    connection = UserInputService.InputBegan:Connect(function(p4) -- line: 57
        -- upvalues: elapsed (copy), UIUtil (copy), t1 (copy), v1 (ref)
        if os.clock() - elapsed < 0.3 then
            return
        end

        local UserInputType = p4.UserInputType

        if UserInputType == Enum.UserInputType.MouseButton1 or UserInputType == Enum.UserInputType.Touch or p4.KeyCode == Enum.KeyCode.Space or p4.KeyCode == Enum.KeyCode.ButtonA then
            v1 = true
            UIUtil.sound("Click", 0.5, 1.2)
            t1.stop()
        end
    end)
end

function t1.stop() -- line: 71
    -- upvalues: connection (ref), Skip (ref), v2 (ref)
    if connection then
        connection:Disconnect()
        connection = nil
    end

    if v2 then
        task.cancel(v2)
        v2 = nil
    end

    if not Skip then
        return
    end

    Skip.Visible = false
    Skip = nil
end

return t1
