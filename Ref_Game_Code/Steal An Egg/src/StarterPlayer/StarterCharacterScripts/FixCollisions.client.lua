-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local t1 = {
    "UpperTorso",
    "LowerTorso"
}

local function processDescendant(p1) -- line: 10
    -- upvalues: t1 (copy)
    if p1:IsA("BasePart") and table.find(t1, p1.Name) then
        p1.CanCollide = false
    end
end

local function disableCollisions(p2) -- line: 16
    -- upvalues: t1 (copy)
    for _, descendant in ipairs(p2:GetDescendants()) do
        if descendant:IsA("BasePart") and table.find(t1, descendant.Name) then
            descendant.CanCollide = false
        end
    end
end

while task.wait(0.4) do
    local Parent = script.Parent

    for _, descendant in ipairs(Parent:GetDescendants()) do
        if descendant:IsA("BasePart") and table.find(t1, descendant.Name) then
            descendant.CanCollide = false
        end
    end
end
