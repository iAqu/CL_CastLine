-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Flamework = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Flamework
local subscribe = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "charm").subscribe
local out = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "pretty-react-hooks", "out")
local useBindingState, useViewport = out.useBindingState, out.useViewport
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local useEffect, useRef, useState = react.useEffect, react.useRef, react.useState
local mountFishPreviewItemNameAtom = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "mount-fish-preview-atom").mountFishPreviewItemNameAtom
local attemptStorePurchase = RuntimeLib.import(script, script.Parent.Parent.Parent.Parent, "store-purchase-utils").attemptStorePurchase
local default = RuntimeLib.import(script, script.Parent.Parent.Parent, "common", "brainrot-style", "popout-button").default
local default2 = RuntimeLib.import(script, script.Parent.Parent, "exclusive-shop", "exclusive-shop-buy-button").default
local getMountFishData = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "mount-fish").getMountFishData
local images = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images").images

local function MountFishPreviewCloseButton(p1) -- line: 19
    -- upvalues: react (copy), default (copy), images (copy)
    return react.createElement(default, {
        cornerRadius = 0.22,
        zIndex = 1E+05,
        anchorPoint = Vector2.new(0.5, 0.5),
        color = Color3.fromRGB(235, 66, 76),
        onClick = p1.onClose,
        popoutColor = Color3.fromRGB(120, 24, 32),
        position = UDim2.new(1, -42, 0, 42),
        size = UDim2.fromOffset(62, 62),
        strokeColor = Color3.new(1, 1, 1)
    }, react.createElement("imagelabel", {
        BackgroundTransparency = 1,
        ZIndex = 100003,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Image = images.crossIcon,
        Position = UDim2.fromScale(0.5, 0.5),
        ScaleType = Enum.ScaleType.Fit,
        Size = UDim2.fromScale(0.48, 0.48)
    }))
end

local function MountFishPreviewBuyButton(p2) -- line: 40
    -- upvalues: useBindingState (copy), useViewport (copy), react (copy), default2 (copy)
    local v1 = useBindingState(useViewport())
    local v2 = v1.X < 1000 and v1.Y < 600
    local v3 = if v2 then math.clamp(math.floor(v1.Y * 0.13), 52, 64) else 92
    local v7 = math.round(v3 * 3.4782608695652173)

    return react.createElement(default2, {
        zIndex = 1E+05,
        anchorPoint = Vector2.new(0.5, 1),
        frameSize = UDim2.fromOffset(v7, v3),
        onClick = p2.onClick,
        position = UDim2.new(0.5, 0, 1, v2 and -22 or -36),
        price = p2.price,
        productId = p2.productId
    })
end

return {
    MountFishPreviewCloseButton = MountFishPreviewCloseButton,
    MountFishPreviewBuyButton = MountFishPreviewBuyButton,
    default = function() -- MountFishPreviewOverlay | line: 55
        -- upvalues: Flamework (copy), subscribe (copy), react (copy), useEffect (copy), useRef (copy), useState (copy), mountFishPreviewItemNameAtom (copy), attemptStorePurchase (copy), getMountFishData (copy), MountFishPreviewCloseButton (copy), MountFishPreviewBuyButton (copy)
        local v8, v9 = useState(mountFishPreviewItemNameAtom())
        local v10 = useRef()
        local v11 = if v8 == nil then nil else getMountFishData(v8)

        useEffect(function() -- line: 59
            -- upvalues: v9 (copy), subscribe (copy), mountFishPreviewItemNameAtom (copy)
            return subscribe(mountFishPreviewItemNameAtom, v9)
        end, {})
        useEffect(function() -- line: 62
            -- upvalues: v10 (copy)
            if v10.current ~= nil then
                v10.current.Name = "MountFishPreviewOverlay"
            end
        end, {})

        return react.createElement("screengui", {
            DisplayOrder = 1E+05,
            IgnoreGuiInset = true,
            ResetOnSpawn = false,
            Enabled = v8 ~= nil,
            ScreenInsets = Enum.ScreenInsets.None,
            ZIndexBehavior = Enum.ZIndexBehavior.Global,
            ref = v10
        }, react.createElement(MountFishPreviewCloseButton, {
            onClose = function() -- onClose | line: 76
                -- upvalues: Flamework (copy)
                return Flamework.resolveDependency("client/controllers/mount-fish-preview-controller@MountFishPreviewController"):closePreview()
            end
        }), if v11 ~= nil and v11.productId > 0 then react.createElement(MountFishPreviewBuyButton, {
            onClick = function() -- onClick | line: 80
                -- upvalues: v11 (copy), Flamework (copy), attemptStorePurchase (copy)
                Flamework.resolveDependency("client/controllers/mount-fish-preview-controller@MountFishPreviewController"):closePreview()
                task.defer(function() -- line: 82
                    -- upvalues: v11 (copy), attemptStorePurchase (copy)
                    return attemptStorePurchase(v11.productId)
                end)
            end,
            price = v11.priceRobux,
            productId = v11.productId
        }) else nil)
    end
}
