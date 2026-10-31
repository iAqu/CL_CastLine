-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local useBindingState = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out").useBindingState
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local StrictMode, useBinding = react.StrictMode, react.useBinding
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react-roblox")
local createPortal, createRoot = v1.createPortal, v1.createRoot
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local StarterGui, Workspace = services.StarterGui, services.Workspace

local function setOtherScreenGuisEnabled(p1) -- line: 14
    -- upvalues: StarterGui (copy)
    for _, child in StarterGui:GetChildren() do
        if child:IsA("ScreenGui") and child ~= StarterGui.StoryScreenGui then
            child.Enabled = p1
        end
    end
end

local function storyForScreenGui(p2, p3) -- line: 21
    -- upvalues: react (copy), StrictMode (copy), createRoot (copy), StarterGui (copy), setOtherScreenGuisEnabled (copy)
    local v2 = p3

    if p3 == nil then
        v2 = {
            disableOtherScreenGuis = true
        }
    end

    return function() -- line: 27
        -- upvalues: v2 (ref), p2 (copy), react (copy), StrictMode (copy), createRoot (copy), StarterGui (copy), setOtherScreenGuisEnabled (copy)
        StarterGui.StoryScreenGui:ClearAllChildren()
        StarterGui.StoryScreenGui.Enabled = true

        local ZIndexBehavior = StarterGui.StoryScreenGui.ZIndexBehavior

        if v2.zIndexBehavior ~= nil then
            StarterGui.StoryScreenGui.ZIndexBehavior = v2.zIndexBehavior
        end

        local v3 = createRoot(StarterGui.StoryScreenGui)

        task.defer(function() -- line: 35
            -- upvalues: v3 (copy), v2 (ref), p2 (copy), react (copy), StrictMode (copy), setOtherScreenGuisEnabled (copy)
            v3:render(react.createElement(StrictMode, nil, p2))

            if v2.disableOtherScreenGuis ~= false then
                setOtherScreenGuisEnabled(false)
            end
        end)

        return function() -- line: 41
            -- upvalues: ZIndexBehavior (copy), v3 (copy), v2 (ref), StarterGui (copy), setOtherScreenGuisEnabled (copy)
            v3:unmount()
            StarterGui.StoryScreenGui.ZIndexBehavior = ZIndexBehavior

            if v2.disableOtherScreenGuis ~= false then
                setOtherScreenGuisEnabled(true)
            end
        end
    end
end

local function PartWithRef(p4) -- line: 51
    -- upvalues: useBindingState (copy), react (copy), useBinding (copy), createPortal (copy), StarterGui (copy)
    local v4, v5 = useBinding(nil)
    local v6 = useBindingState(v4)

    return react.createElement("part", {
        Anchored = true,
        Position = Vector3.new(0, 15, 0),
        Size = p4.partSize,
        ref = function(p5) -- ref | line: 58
            -- upvalues: v4 (copy), v5 (copy)
            if not v4:getValue() then
                v5(p5)
            end
        end
    }, v6 and createPortal(p4.render(v6), StarterGui))
end

local function ModelAndPartWithRef(p6) -- line: 65
    -- upvalues: useBindingState (copy), react (copy), useBinding (copy), createPortal (copy), StarterGui (copy)
    local v7, v8 = useBinding(nil)
    local v9 = useBindingState(v7)

    return react.createElement("model", {
        ref = function(p7) -- ref | line: 69
            -- upvalues: v7 (copy), v8 (copy)
            if not v7:getValue() then
                v8(p7)
            end
        end
    }, v9 and createPortal(p6.render(v9), StarterGui), react.createElement("part", {
        Anchored = true,
        Position = Vector3.new(0, 15, 0),
        key = "stable",
        Size = p6.partSize
    }))
end

return {
    storyForBillboardGuiKey = "StoryPartForBillboardGui",
    storyForSurfaceGuiKey = "StoryPartForSurfaceGui",
    storyForWorkspaceKey = "StoryFolderForWorkspace",
    storyForScreenGui = storyForScreenGui,
    storyForBillboardGui = function(p8, p9) -- storyForBillboardGui | line: 81
        -- upvalues: react (copy), StrictMode (copy), createPortal (copy), createRoot (copy), StarterGui (copy), Workspace (copy), setOtherScreenGuisEnabled (copy), PartWithRef (copy)
        local v10 = p9

        if p9 == nil then
            v10 = Vector3.new(1, 1, 1)
        end

        return function() -- line: 85
            -- upvalues: v10 (ref), p8 (copy), react (copy), StrictMode (copy), createPortal (copy), createRoot (copy), StarterGui (copy), Workspace (copy), setOtherScreenGuisEnabled (copy), PartWithRef (copy)
            local StoryPartForBillboardGui = Workspace:FindFirstChild("StoryPartForBillboardGui")

            if StoryPartForBillboardGui ~= nil then
                StoryPartForBillboardGui:Destroy()
            end

            local StoryPartForBillboardGui2 = StarterGui:FindFirstChild("StoryPartForBillboardGui")

            if StoryPartForBillboardGui2 ~= nil then
                StoryPartForBillboardGui2:Destroy()
            end

            StarterGui.StoryScreenGui:ClearAllChildren()
            StarterGui.StoryScreenGui.Enabled = true
            setOtherScreenGuisEnabled(false)

            local v11 = react.createElement(PartWithRef, {
                key = "StoryPartForBillboardGui",
                partSize = v10,
                render = p8
            })
            local v12 = createRoot(Instance.new("Folder"))

            v12:render(react.createElement(StrictMode, nil, createPortal(v11, Workspace)))

            return function() -- line: 104
                -- upvalues: v12 (copy), setOtherScreenGuisEnabled (copy)
                v12:unmount()
                setOtherScreenGuisEnabled(true)
            end
        end
    end,
    storyForBillboardGuiWithModel = function(p10, p11) -- storyForBillboardGuiWithModel | line: 110
        -- upvalues: react (copy), StrictMode (copy), createPortal (copy), createRoot (copy), StarterGui (copy), Workspace (copy), ModelAndPartWithRef (copy)
        local v13 = p11

        if p11 == nil then
            v13 = Vector3.new(1, 1, 1)
        end

        return function() -- line: 114
            -- upvalues: v13 (ref), p10 (copy), react (copy), StrictMode (copy), createPortal (copy), createRoot (copy), StarterGui (copy), Workspace (copy), ModelAndPartWithRef (copy)
            local StoryPartForBillboardGui = Workspace:FindFirstChild("StoryPartForBillboardGui")

            if StoryPartForBillboardGui ~= nil then
                StoryPartForBillboardGui:Destroy()
            end

            local StoryPartForBillboardGui2 = StarterGui:FindFirstChild("StoryPartForBillboardGui")

            if StoryPartForBillboardGui2 ~= nil then
                StoryPartForBillboardGui2:Destroy()
            end

            local v14 = react.createElement(ModelAndPartWithRef, {
                key = "StoryPartForBillboardGui",
                partSize = v13,
                render = p10
            })
            local v15 = createRoot(Instance.new("Folder"))

            v15:render(react.createElement(StrictMode, nil, createPortal(v14, Workspace)))

            return function() -- line: 130
                -- upvalues: v15 (copy)
                v15:unmount()
            end
        end
    end,
    StoryScreenGui = function(p12) -- StoryScreenGui | line: 135
        -- upvalues: createPortal (copy), StarterGui (copy)
        return createPortal(p12.children, StarterGui.StoryScreenGui)
    end,
    storyForSurfaceGui = function(p13, p14) -- storyForSurfaceGui | line: 140
        -- upvalues: react (copy), StrictMode (copy), createPortal (copy), createRoot (copy), StarterGui (copy), Workspace (copy), PartWithRef (copy)
        local v16 = p14

        if p14 == nil then
            v16 = Vector3.new(10, 10, 1)
        end

        return function() -- line: 144
            -- upvalues: v16 (ref), p13 (copy), react (copy), StrictMode (copy), createPortal (copy), createRoot (copy), StarterGui (copy), Workspace (copy), PartWithRef (copy)
            local StoryPartForSurfaceGui = StarterGui:FindFirstChild("StoryPartForSurfaceGui")

            if StoryPartForSurfaceGui ~= nil then
                StoryPartForSurfaceGui:Destroy()
            end

            local StoryPartForSurfaceGui2 = Workspace:FindFirstChild("StoryPartForSurfaceGui")

            if StoryPartForSurfaceGui2 ~= nil then
                StoryPartForSurfaceGui2:Destroy()
            end

            local v17 = react.createElement(PartWithRef, {
                key = "StoryPartForSurfaceGui",
                partSize = v16,
                render = p13
            })
            local v18 = createRoot(Instance.new("Folder"))

            v18:render(react.createElement(StrictMode, nil, createPortal(v17, Workspace)))

            return function() -- line: 160
                -- upvalues: v18 (copy)
                v18:unmount()
            end
        end
    end,
    storyForWorkspace = function(p15) -- storyForWorkspace | line: 166
        -- upvalues: react (copy), StrictMode (copy), createPortal (copy), createRoot (copy), Workspace (copy)
        return function() -- line: 167
            -- upvalues: p15 (copy), react (copy), StrictMode (copy), createPortal (copy), createRoot (copy), Workspace (copy)
            local StoryFolderForWorkspace = Workspace:FindFirstChild("StoryFolderForWorkspace")

            if StoryFolderForWorkspace ~= nil then
                StoryFolderForWorkspace:Destroy()
            end

            local v19 = react.createElement("folder", {
                key = "StoryFolderForWorkspace"
            }, p15)
            local v20 = createRoot(Instance.new("Folder"))

            v20:render(react.createElement(StrictMode, nil, createPortal(v19, Workspace)))

            return function() -- line: 177
                -- upvalues: v20 (copy)
                v20:unmount()
            end
        end
    end,
    storyForWorkspaceWithScreenGui = function(p16) -- storyForWorkspaceWithScreenGui | line: 182
        -- upvalues: react (copy), StrictMode (copy), createPortal (copy), createRoot (copy), StarterGui (copy), Workspace (copy), setOtherScreenGuisEnabled (copy)
        return function() -- line: 183
            -- upvalues: p16 (copy), react (copy), StrictMode (copy), createPortal (copy), createRoot (copy), StarterGui (copy), Workspace (copy), setOtherScreenGuisEnabled (copy)
            local workspace = p16.workspace
            local v24 = (function() -- line: 167
                -- upvalues: workspace (copy), react (copy), StrictMode (copy), createPortal (copy), createRoot (copy), Workspace (copy)
                local StoryFolderForWorkspace = Workspace:FindFirstChild("StoryFolderForWorkspace")

                if StoryFolderForWorkspace ~= nil then
                    StoryFolderForWorkspace:Destroy()
                end

                local v22 = react.createElement("folder", {
                    key = "StoryFolderForWorkspace"
                }, workspace)
                local v23 = createRoot(Instance.new("Folder"))

                v23:render(react.createElement(StrictMode, nil, createPortal(v22, Workspace)))

                return function() -- line: 177
                    -- upvalues: v23 (copy)
                    v23:unmount()
                end
            end)()
            local screenGui = p16.screenGui
            local t3 = {
                disableOtherScreenGuis = true
            }
            local v27 = (function() -- line: 27
                -- upvalues: screenGui (copy), t3 (copy), react (copy), StrictMode (copy), createRoot (copy), StarterGui (copy), setOtherScreenGuisEnabled (copy)
                StarterGui.StoryScreenGui:ClearAllChildren()
                StarterGui.StoryScreenGui.Enabled = true

                local ZIndexBehavior = StarterGui.StoryScreenGui.ZIndexBehavior

                if t3.zIndexBehavior ~= nil then
                    StarterGui.StoryScreenGui.ZIndexBehavior = t3.zIndexBehavior
                end

                local v26 = createRoot(StarterGui.StoryScreenGui)

                task.defer(function() -- line: 35
                    -- upvalues: screenGui (copy), t3 (copy), react (copy), StrictMode (copy), setOtherScreenGuisEnabled (copy), v26 (copy)
                    v26:render(react.createElement(StrictMode, nil, screenGui))

                    if t3.disableOtherScreenGuis ~= false then
                        setOtherScreenGuisEnabled(false)
                    end
                end)

                return function() -- line: 41
                    -- upvalues: t3 (copy), StarterGui (copy), setOtherScreenGuisEnabled (copy), ZIndexBehavior (copy), v26 (copy)
                    v26:unmount()
                    StarterGui.StoryScreenGui.ZIndexBehavior = ZIndexBehavior

                    if t3.disableOtherScreenGuis ~= false then
                        setOtherScreenGuisEnabled(true)
                    end
                end
            end)()

            return function() -- line: 186
                -- upvalues: v24 (copy), v27 (copy)
                v24()
                v27()
            end
        end
    end,
    storyForHoarcekatWindow = function(p17) -- storyForHoarcekatWindow | line: 192
        -- upvalues: react (copy), StrictMode (copy), createRoot (copy)
        return function(p18) -- line: 193
            -- upvalues: p17 (copy), react (copy), StrictMode (copy), createRoot (copy)
            local v28 = createRoot(p18)

            v28:render(react.createElement(StrictMode, nil, p17))

            return function() -- line: 196
                -- upvalues: v28 (copy)
                v28:unmount()
            end
        end
    end
}
