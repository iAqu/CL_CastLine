-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local function PlaySFX(p1, p2, p3) -- line: 20
    local Attachment = Instance.new("Attachment")

    Attachment.CFrame = p1.CFrame:ToObjectSpace(p2)
    p3.Parent = Attachment
    Attachment.Parent = p1
    p3.Ended:Connect(function() -- line: 25
        -- upvalues: Attachment (copy)
        Attachment:Destroy()
    end)
    p3:Play()
end

return PlaySFX
