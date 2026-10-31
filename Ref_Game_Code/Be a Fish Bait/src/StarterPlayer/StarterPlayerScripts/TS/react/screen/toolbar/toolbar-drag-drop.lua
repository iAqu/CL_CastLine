-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {}

local function registerToolbarDropZone(p1) -- line: 3
    -- upvalues: t1 (copy)
    t1[p1] = true

    return function() -- line: 6
        -- upvalues: p1 (copy), t1 (copy)
        local v1 = t1[p1] ~= nil

        t1[p1] = nil

        return v1
    end
end

local function isPointInGuiObject(p2, p3) -- line: 15
    local AbsolutePosition, AbsoluteSize = p3.AbsolutePosition, p3.AbsoluteSize

    if p2.X >= AbsolutePosition.X and p2.X <= AbsolutePosition.X + AbsoluteSize.X and p2.Y >= AbsolutePosition.Y then
        return p2.Y <= AbsolutePosition.Y + AbsoluteSize.Y
    end

    return false
end

return {
    registerToolbarDropZone = registerToolbarDropZone,
    dispatchToolbarDrop = function(p4, p5) -- dispatchToolbarDrop | line: 20
        -- upvalues: t1 (copy)
        for v2 in t1 do
            local v3 = v2.getObject()

            if v3 ~= nil then
                local AbsolutePosition, AbsoluteSize = v3.AbsolutePosition, v3.AbsoluteSize

                if p5.X >= AbsolutePosition.X and p5.X <= AbsolutePosition.X + AbsoluteSize.X and p5.Y >= AbsolutePosition.Y and p5.Y <= AbsolutePosition.Y + AbsoluteSize.Y then
                    v2.onDrop(p4, p5)

                    return true
                end
            end
        end

        return false
    end
}
