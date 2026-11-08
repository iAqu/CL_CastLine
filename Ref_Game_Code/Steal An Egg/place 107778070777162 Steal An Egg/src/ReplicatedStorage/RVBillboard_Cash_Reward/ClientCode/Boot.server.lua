-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ParentParent = script.Parent.Parent

if ParentParent and ParentParent:IsA("Model") then
    local v1 = ParentParent:WaitForChild("Remotes", 30)

    if v1 then
        local AdClient = require(script.Parent:WaitForChild("AdClient"))

        AdClient.Init(v1)
        require(script.Parent:WaitForChild("BillboardController")).start(ParentParent, AdClient, v1, false)
    else
        warn("[RVBillboard] Remotes folder never appeared on " .. ParentParent:GetFullName())
    end
end
