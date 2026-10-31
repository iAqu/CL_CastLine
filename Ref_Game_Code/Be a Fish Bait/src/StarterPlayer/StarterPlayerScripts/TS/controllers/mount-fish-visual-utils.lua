-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local v1 = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib")).import(script, game:GetService("ReplicatedStorage"), "TS", "data", "mount-fish")
local findMountFishModel, getMountFishData = v1.findMountFishModel, v1.getMountFishData

local function ensurePrimaryPart(p1) -- line: 6
    if p1.PrimaryPart ~= nil then
        return p1.PrimaryPart
    end

    for _, descendant in p1:GetDescendants() do
        if descendant:IsA("BasePart") then
            p1.PrimaryPart = descendant

            return descendant
        end
    end

    return nil
end

local function cloneMountFishVisual(p2) -- line: 19
    -- upvalues: findMountFishModel (copy), getMountFishData (copy), ensurePrimaryPart (copy)
    local v2 = getMountFishData(p2)
    local v3 = findMountFishModel(p2)

    if v2 == nil or v3 == nil then
        return nil
    end

    local clone = v3:Clone()
    local v4 = ensurePrimaryPart(clone)

    if v4 == nil then
        clone:Destroy()

        return nil
    end

    clone.Name = ("%*Mount"):format(p2)
    clone:SetAttribute("mountFishName", p2)

    local v5 = clone:FindFirstChild("SitAttachment", true)

    return {
        config = v2,
        model = clone,
        primaryPart = v4,
        seatOffset = if (if v5 == nil then v5 else v5:IsA("Attachment")) == true then clone:GetPivot():ToObjectSpace(v5.WorldCFrame) else v2.seatOffset
    }
end

return {
    cloneMountFishVisual = cloneMountFishVisual,
    attachMountFishVisual = function(p3, p4, p5, p6) -- attachMountFishVisual | line: 46
        -- upvalues: cloneMountFishVisual (copy)
        local v6 = if p6 == nil then {} else p6
        local v7 = cloneMountFishVisual(p4)
        local HumanoidRootPart = p3:FindFirstChild("HumanoidRootPart")
        local v8 = v7 == nil

        if not v8 then
            v8 = (if HumanoidRootPart == nil then HumanoidRootPart else HumanoidRootPart:IsA("BasePart")) ~= true
        end

        if v8 then
            if v7 ~= nil then
                v7.model:Destroy()
            end

            return nil
        end

        local weldToCharacter = v6.weldToCharacter

        if weldToCharacter == nil then
            weldToCharacter = true
        end

        for _, descendant in v7.model:GetDescendants() do
            if descendant:IsA("BasePart") then
                descendant.Anchored = not weldToCharacter
                descendant.CanCollide = false
                descendant.CanQuery = false
                descendant.CanTouch = false
                descendant.Massless = true
            end
        end

        local v9 = if v6.reverseFacing then CFrame.Angles(0, 3.141592653589793, 0) else CFrame.new()

        v7.model:PivotTo(HumanoidRootPart.CFrame * v9 * v7.seatOffset:Inverse())
        v7.model.Parent = p5

        if weldToCharacter then
            local WeldConstraint = Instance.new("WeldConstraint")

            WeldConstraint.Name = "MountFishCharacterWeld"
            WeldConstraint.Part0 = HumanoidRootPart
            WeldConstraint.Part1 = v7.primaryPart
            WeldConstraint.Parent = v7.primaryPart
        end

        return v7
    end
}
