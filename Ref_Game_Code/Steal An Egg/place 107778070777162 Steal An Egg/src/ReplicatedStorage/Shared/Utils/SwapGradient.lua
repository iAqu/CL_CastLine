-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    "Color",
    "Enabled",
    "Name",
    "Offset",
    "Rotation",
    "Transparency"
}

local function gradientsUnder(p1) -- line: 5
    local t2 = {}

    for _, child in p1:GetChildren() do
        if child:IsA("UIGradient") then
            table.insert(t2, child)
        end
    end

    return t2
end

local function paint(p2, p3) -- line: 15
    -- upvalues: t1 (copy)
    for _, v1 in t1 do
        p2[v1] = p3[v1]
    end

    for v2, v3 in p3:GetAttributes() do
        p2:SetAttribute(v2, v3)
    end
end

return function(p4, p5) -- line: 28
    -- upvalues: gradientsUnder (copy), paint (copy)
    local v4 = gradientsUnder(p4)

    if p5 == nil then
        for _, v5 in v4 do
            v5:Destroy()
        end

        return nil
    end

    local v6 = table.remove(v4, 1)

    for _, v7 in v4 do
        v7:Destroy()
    end

    if v6 == nil then
        local clone = p5:Clone()

        clone.Parent = p4

        return clone
    end

    paint(v6, p5)

    return v6
end
