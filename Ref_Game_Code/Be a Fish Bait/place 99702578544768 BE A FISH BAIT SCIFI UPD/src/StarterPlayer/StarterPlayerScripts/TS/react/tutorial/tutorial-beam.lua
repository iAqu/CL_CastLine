-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useState = react.useEffect, react.useState
local createPortal = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react-roblox").createPortal
local Players = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").Players
local useCharacter = RuntimeLib.import(script, script.Parent.Parent, "hooks", "use-characters").useCharacter
local images = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images").images

local function findRootRigAttachment(p1) -- line: 11
    local v1 = if p1 == nil then p1 else p1:FindFirstChild("RootRigAttachment", true)

    return if if v1 == nil then v1 else v1:IsA("Attachment") then v1 else nil
end

return {
    default = function(p2) -- TutorialBeam | line: 23
        -- upvalues: react (copy), useEffect (copy), useState (copy), createPortal (copy), Players (copy), useCharacter (copy), images (copy)
        local targetAttachment = p2.targetAttachment
        local v2 = useCharacter(Players.LocalPlayer)
        local v3, v4 = useState(function() -- line: 30
            -- upvalues: v2 (copy)
            local v5 = v2

            if v2 ~= nil then
                v5 = v2:FindFirstChild("RootRigAttachment", true)
            end

            return if if v5 == nil then v5 else v5:IsA("Attachment") then v5 else nil
        end)

        useEffect(function() -- line: 33
            -- upvalues: v2 (copy), v4 (copy)
            local v6 = v2

            if v2 ~= nil then
                v6 = v2:FindFirstChild("RootRigAttachment", true)
            end

            if not (if v6 == nil then v6 else v6:IsA("Attachment")) then
                v6 = nil
            end

            v4(v6)

            if not v2 then
                return nil
            end

            local connection = v2.DescendantAdded:Connect(function(p3) -- line: 38
                -- upvalues: v4 (copy)
                if p3.Name == "RootRigAttachment" and p3:IsA("Attachment") then
                    v4(p3)
                end
            end)

            return function() -- line: 43
                -- upvalues: connection (copy)
                return connection:Disconnect()
            end
        end, { v2 })

        if not v2 or not v3 then
            return nil
        end

        return createPortal(react.createElement("beam", {
            FaceCamera = true,
            LightInfluence = 0.2,
            TextureLength = 7.5,
            TextureSpeed = -2,
            Width0 = 5,
            Width1 = 5,
            ZOffset = 2,
            Attachment0 = targetAttachment,
            Attachment1 = v3,
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
                ColorSequenceKeypoint.new(1, Color3.new(1, 1, 1))
            }),
            Texture = images.arrowBeam,
            TextureMode = Enum.TextureMode.Static,
            Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0),
                NumberSequenceKeypoint.new(1, 0)
            })
        }), v2)
    end
}
