-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local out = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib")).import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out")
local useBindingState, useViewport = out.useBindingState, out.useViewport

local function isScreenSizeSmallerOrEqual(p1, p2) -- line: 13
    if p1 == "sm" then
        return p2 == "sm"
    end

    if p1 == "md" then
        if p2 == "sm" then
            return true
        end

        return p2 == "md"
    end

    if p1 == "lg" then
        return true
    end

    return p1
end

local function checkIsScreenSizeMobile(p3) -- line: 30
    -- upvalues: isScreenSizeSmallerOrEqual (copy)
    return isScreenSizeSmallerOrEqual("md", p3)
end

local function useScreenSize() -- line: 33
    -- upvalues: useViewport (copy)
    return (useViewport():map(function(p4) -- line: 35
        if p4.X < 812 then
            return "sm"
        end

        if p4.X < 1366 then
            return "md"
        end

        return "lg"
    end))
end

return {
    isScreenSizeSmallerOrEqual = isScreenSizeSmallerOrEqual,
    checkIsScreenSizeMobile = checkIsScreenSizeMobile,
    useScreenSize = useScreenSize,
    useScreenSizeState = function() -- useScreenSizeState | line: 46
        -- upvalues: useBindingState (copy), useViewport (copy)
        return useBindingState((useViewport():map(function(p5) -- line: 35
            if p5.X < 812 then
                return "sm"
            end

            if p5.X < 1366 then
                return "md"
            end

            return "lg"
        end)))
    end
}
