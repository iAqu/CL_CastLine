-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useWindowCameraEffects = RuntimeLib.import(script, script.Parent.Parent.Parent, "hooks", "use-window-camera-effects").useWindowCameraEffects
local default = RuntimeLib.import(script, script.Parent, "transition").default
local useTransitionMotion = RuntimeLib.import(script, script.Parent, "use-transition-motion").useTransitionMotion

local function useSlideMotion() -- line: 7
    -- upvalues: useTransitionMotion (copy)
    return useTransitionMotion({
        whenIn = UDim2.fromScale(0.5, 0.5),
        whenOut = UDim2.fromScale(0.5, 1.5)
    }, {
        motionType = "spring",
        springOptions = {
            damping = 0.72,
            frequency = 0.2
        }
    })[1]
end

local function WindowTransitionFrame(p1) -- line: 21
    -- upvalues: react (copy), useSlideMotion (copy)
    local v1 = useSlideMotion()

    return react.createElement("frame", {
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = v1,
        Size = UDim2.fromScale(1, 1)
    }, p1.children)
end

local function WindowTransitionFrameWithEffects(p2) -- line: 30
    -- upvalues: react (copy), useWindowCameraEffects (copy), useSlideMotion (copy)
    local v2 = useSlideMotion()

    useWindowCameraEffects(p2.isIn)

    return react.createElement("frame", {
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = v2,
        Size = UDim2.fromScale(1, 1)
    }, p2.children)
end

return {
    default = function(p3) -- WindowTransition | line: 40
        -- upvalues: react (copy), default (copy), WindowTransitionFrame (copy), WindowTransitionFrameWithEffects (copy)
        return react.createElement(default, {
            doEnterTransitionOnFirstMount = true,
            ["in"] = p3["in"]
        }, if p3.enableCameraEffects then react.createElement(WindowTransitionFrameWithEffects, {
            isIn = p3["in"]
        }, p3.children) else react.createElement(WindowTransitionFrame, nil, p3.children))
    end
}
