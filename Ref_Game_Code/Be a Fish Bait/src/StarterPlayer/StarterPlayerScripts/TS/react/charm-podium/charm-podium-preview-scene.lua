-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useRef = react.useEffect, react.useRef
local Workspace = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").Workspace
local startAutoRotatingMeshParts = RuntimeLib.import(script, script.Parent.Parent, "common", "auto-rotate-meshparts").startAutoRotatingMeshParts
local charmTierConfigs = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "charm-attributes").charmTierConfigs
local resolveCharmModelAtPath = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "charms").resolveCharmModelAtPath
local v1 = RuntimeLib.import(script, script.Parent, "charm-podium-camera-focus")
local focusCharmPodium, releaseCharmPodiumFocus = v1.focusCharmPodium, v1.releaseCharmPodiumFocus

return {
    CharmPodiumPreviewScene = function(p1) -- CharmPodiumPreviewScene | line: 20
        -- upvalues: react (copy), useEffect (copy), useRef (copy), Workspace (copy), startAutoRotatingMeshParts (copy), charmTierConfigs (copy), resolveCharmModelAtPath (copy), focusCharmPodium (copy), releaseCharmPodiumFocus (copy)
        local tierId = p1.tierId
        local v2 = useRef()

        useEffect(function() -- line: 23
            -- upvalues: Workspace (copy), startAutoRotatingMeshParts (copy)
            return startAutoRotatingMeshParts(Workspace)
        end, {})
        useEffect(function() -- line: 26
            -- upvalues: tierId (copy), v2 (copy), charmTierConfigs (copy), resolveCharmModelAtPath (copy), focusCharmPodium (copy), releaseCharmPodiumFocus (copy)
            local current = v2.current

            if current == nil then
                return nil
            end

            current.Name = "CharmPodiumPreviewSceneRoot"

            local v3 = charmTierConfigs[tierId]
            local v4 = resolveCharmModelAtPath(v3.podiumModelPath)
            local v5 = resolveCharmModelAtPath(v3.charmModelPath)

            if v4 == nil or v5 == nil then
                warn("Charm podium preview scene requires the configured ReplicatedStorage Charm models.")

                return nil
            end

            local Model = Instance.new("Model")

            Model.Name = "CharmPodiumPreviewScene"
            Model:SetAttribute("CharmTierId", tierId)
            Model.Parent = current

            local Part = Instance.new("Part")

            Part.Anchored = true
            Part.Color = Color3.fromRGB(13, 19, 39)
            Part.Material = Enum.Material.Slate
            Part.Name = "PreviewFloor"
            Part.Position = Vector3.new(0, 0, 0)
            Part.Size = Vector3.new(40, 1, 40)
            Part.Parent = Model

            local Model2 = Instance.new("Model")

            Model2.Name = "CharmPodiumVisual"
            Model2.Parent = Model

            local clone = v4:Clone()

            clone.Name = "PodiumDisplay"
            clone.Parent = Model2

            for _, descendant in clone:GetDescendants() do
                if descendant:IsA("BasePart") then
                    descendant.Anchored = true
                end
            end

            clone:PivotTo(CFrame.new(0, 0.5, 0))

            local v6 = clone:FindFirstChild(v3.charmDisplayAttachmentName, true)

            if if v6 == nil then v6 else v6:IsA("Attachment") then
                local clone = v5:Clone()

                clone.Name = "CharmDisplay"
                clone.Parent = Model2

                for _, descendant in clone:GetDescendants() do
                    if descendant:IsA("BasePart") then
                        descendant.Anchored = true
                        descendant.CanCollide = false
                        descendant.CanQuery = false
                        descendant.CanTouch = false
                    end
                end

                clone:PivotTo(v6.WorldCFrame)
            else
                warn((("Charm podium preview scene could not find Attachment \"%*\"."):format(v3.charmDisplayAttachmentName)))
            end

            local PointLight = Instance.new("PointLight")

            PointLight.Brightness = 2
            PointLight.Color = Color3.fromRGB(164, 108, 255)
            PointLight.Range = 24
            PointLight.Parent = Part
            focusCharmPodium(Model)

            return function() -- line: 91
                -- upvalues: Model (copy), releaseCharmPodiumFocus (copy)
                releaseCharmPodiumFocus()
                Model:Destroy()
            end
        end, { tierId })

        return react.createElement("folder", {
            ref = v2
        })
    end
}
