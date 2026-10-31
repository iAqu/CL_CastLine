-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return {
    weldToolsToRigRightHand = function(p1) -- weldToolsToRigRightHand | line: 8
        local v1 = p1:FindFirstChild("RightHand", true)

        if not (v1 and v1:IsA("BasePart")) then
            return nil
        end

        for _, descendant in p1:GetDescendants() do
            if descendant:IsA("Tool") then
                local Handle = descendant:FindFirstChild("Handle")

                if Handle and Handle:IsA("BasePart") then
                    local WeldConstraint = Instance.new("WeldConstraint")

                    WeldConstraint.Part0 = v1
                    WeldConstraint.Part1 = Handle
                    WeldConstraint.Parent = Handle
                end
            end
        end
    end,
    anchorToolPartsInRig = function(p2) -- anchorToolPartsInRig | line: 27
        for _, descendant in p2:GetDescendants() do
            if descendant:IsA("Tool") then
                for _, descendant in descendant:GetDescendants() do
                    if descendant:IsA("BasePart") then
                        descendant.Anchored = true
                    end
                end

                return
            end
        end
    end,
    unanchorToolPartsInRig = function(p3) -- unanchorToolPartsInRig | line: 41
        for _, descendant in p3:GetDescendants() do
            if descendant:IsA("Tool") then
                for _, descendant in descendant:GetDescendants() do
                    if descendant:IsA("BasePart") then
                        descendant.Anchored = false
                    end
                end

                return
            end
        end
    end
}
