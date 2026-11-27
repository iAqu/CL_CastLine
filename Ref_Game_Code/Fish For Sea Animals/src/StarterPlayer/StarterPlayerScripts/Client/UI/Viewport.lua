-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return {
    show = function(p1, p2, p3, p4) -- show | line: 5
        for _, child in p1:GetChildren() do
            if child:IsA("Camera") then
                child:Destroy()
            elseif child:IsA("Model") then
                child:Destroy()
            elseif child:IsA("WorldModel") then
                child:Destroy()
            end
        end

        local Camera = Instance.new("Camera")

        Camera.FieldOfView = 35
        Camera.Parent = p1
        p1.CurrentCamera = Camera
        p2.Parent = p1

        local BoundingBox, BoundingBox2 = p2:GetBoundingBox()
        local v4 = BoundingBox2.Magnitude / 2 / math.tan((math.rad(Camera.FieldOfView / 2))) * (p4 or 1)
        local v6 = math.rad(p3 or 35)
        local Unit = Vector3.new(math.sin(v6), 0.35, (math.cos(v6))).Unit

        Camera.CFrame = CFrame.lookAt(BoundingBox.Position + Unit * v4, BoundingBox.Position)

        return Camera
    end
}
