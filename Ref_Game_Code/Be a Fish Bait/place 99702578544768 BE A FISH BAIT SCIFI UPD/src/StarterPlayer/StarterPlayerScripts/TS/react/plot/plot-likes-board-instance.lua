-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local memo, useCallback, useState = react.memo, react.useCallback, react.useState
local createPortal = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react-roblox").createPortal
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local Players, ReplicatedStorage = services.Players, services.ReplicatedStorage
local default = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "react", "prefab").default
local useChild = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "react", "hooks", "use-child").useChild
local default2 = RuntimeLib.import(script, script.Parent, "plot-likes-board-gui").default
local functions = RuntimeLib.import(script, script.Parent.Parent.Parent, "network").functions
local HttpService = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").HttpService
local clientProducer = RuntimeLib.import(script, script.Parent.Parent.Parent, "reflex", "producer").clientProducer

return {
    default = memo(function(p1) -- PlotLikesBoardInstance | line: 18
        -- upvalues: RuntimeLib (copy), react (copy), useCallback (copy), useState (copy), createPortal (copy), Players (copy), ReplicatedStorage (copy), default (copy), useChild (copy), default2 (copy), functions (copy), HttpService (copy), clientProducer (copy)
        local ownerUserId, plotInstance = p1.ownerUserId, p1.plotInstance
        local v1, v2 = useState(nil)
        local Attachment = useChild(plotInstance, "PrestigeBoardPos", "Attachment")
        local Attachment2 = useChild(plotInstance, "PrestigeBoardLookAtPos", "Attachment")
        local v3 = useCallback(function() -- line: 25
            -- upvalues: ReplicatedStorage (copy)
            local PlotLikes = ReplicatedStorage:FindFirstChild("PlotLikes")

            if PlotLikes then
                return PlotLikes
            end

            warn("PlotLikes prefab not found in ReplicatedStorage")

            return nil
        end, {})
        local v4 = useCallback(function(p2) -- line: 33
            -- upvalues: v2 (copy), Attachment (copy), Attachment2 (copy)
            if not Attachment then
                return nil
            end

            if Attachment2 then
                local v6 = Attachment.WorldPosition + Vector3.new(0, p2:GetExtentsSize().Y / 2, 0)
                local WorldPosition2 = Attachment2.WorldPosition
                local v8 = Vector3.new(0, p2:GetExtentsSize().Y / 2, 0)

                p2:PivotTo((CFrame.lookAt(v6, WorldPosition2 + v8)))
            else
                p2:PivotTo(Attachment.WorldCFrame)
            end

            for _, descendant in p2:GetDescendants() do
                if descendant:IsA("BasePart") then
                    descendant.Anchored = true
                end
            end

            v2(p2)
        end, { Attachment, Attachment2 })
        local BasePart = useChild(v1, "Board", "BasePart")
        local v9 = useCallback(function(_, p4) -- line: 56
            -- upvalues: ownerUserId (copy), RuntimeLib (copy), Players (copy), functions (copy), HttpService (copy), clientProducer (copy)
            if p4 ~= Players.LocalPlayer then
                return nil
            end

            local v10 = tostring(ownerUserId)

            if v10 == tostring(Players.LocalPlayer.UserId) then
                clientProducer.onScreenFeedbackAdded({
                    message = "You can't like your own plot!",
                    type = "error",
                    id = HttpService:GenerateGUID(false)
                })

                return nil
            end

            task.spawn(RuntimeLib.async(function() -- line: 69
                -- upvalues: v10 (copy), RuntimeLib (copy), functions (copy), HttpService (copy), clientProducer (copy)
                if RuntimeLib.await(functions.likePlot(v10)) == false then
                    clientProducer.onScreenFeedbackAdded({
                        message = "Could not like (already liked today or invalid).",
                        type = "error",
                        id = HttpService:GenerateGUID(false)
                    })
                end
            end))
        end, { ownerUserId })

        if not plotInstance.Parent then
            return nil
        end

        return react.createElement(react.Fragment, nil, createPortal(react.createElement(default, {
            getPrefabInstance = v3,
            onPrefabInstantiated = v4
        }), plotInstance), v1 and BasePart and createPortal(react.createElement(react.Fragment, nil, react.createElement(default2, {
            boardInstance = v1,
            boardPart = BasePart,
            ownerUserId = ownerUserId
        }), react.createElement("proximityprompt", {
            ActionText = "Like",
            HoldDuration = 0.3,
            MaxActivationDistance = 8,
            ObjectText = "Plot",
            RequiresLineOfSight = false,
            Event = {
                Triggered = v9
            },
            GamepadKeyCode = Enum.KeyCode.ButtonA
        })), BasePart))
    end)
}
