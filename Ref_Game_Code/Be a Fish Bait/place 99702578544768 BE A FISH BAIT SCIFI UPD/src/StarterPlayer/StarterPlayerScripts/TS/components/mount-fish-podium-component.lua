-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect
local t = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "t", "lib", "ts").t
local out = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "components", "out")
local BaseComponent, Component = out.BaseComponent, out.Component
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local Players, RunService = services.Players, services.RunService
local subscribe = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "charm").subscribe
local getMountFishDataByPodiumFolderName = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "mount-fish").getMountFishDataByPodiumFolderName
local v1 = Vector2.new(0, -50)
local self = setmetatable({}, {
    __tostring = function() -- __tostring | line: 22
        return "MountFishPodiumComponent"
    end,
    __index = BaseComponent
})

self.__index = self

function self.new(...) -- line: 28
    -- upvalues: self (copy)
    local self2 = setmetatable({}, self)

    return self2:constructor(...) or self2
end

function self.constructor(p1, p2, p3) -- line: 32
    -- upvalues: BaseComponent (copy)
    BaseComponent.constructor(p1)
    p1._previewController = p2
    p1._productPriceController = p3
end

function self.onStart(p4) -- line: 37
    -- upvalues: RunService (copy), getMountFishDataByPodiumFolderName (copy)
    local Name = p4.instance.Name
    local v4 = getMountFishDataByPodiumFolderName(Name)

    if v4 == nil then
        if RunService:IsStudio() then
            warn("[src/client/components/mount-fish-podium-component.ts:40]", (("MountFishPodiumComponent: no MountFishData found for podium \"%*\" (expected podiumFolderName to match an entry in mountFishData)"):format(Name)))
        end

        return nil
    end

    p4:_createPreviewPrompt(p4.instance.ProximityPart, v4.displayName, v4.itemName)
    p4:_syncBuyPromptPrice(p4.instance.ProximityPart, v4)
end

function self._syncBuyPromptPrice(p5, p6, p7) -- line: 49
    -- upvalues: Players (copy), subscribe (copy)
    if p7.productId <= 0 then
        return nil
    end

    local Product = Enum.InfoType.Product
    local v5

    local function v6() -- line: 57
        -- upvalues: p6 (copy), v5 (ref), Players (copy)
        local BuyPrompt = p6:FindFirstChild("BuyPrompt")

        if not (if BuyPrompt == nil then BuyPrompt else BuyPrompt:IsA("ProximityPrompt")) then
            return nil
        end

        if Players.LocalPlayer:GetAttribute("QaFreePurchaseModeEnabled") == true then
            BuyPrompt.ActionText = "FREE"

            return nil
        end

        if v5 ~= nil then
            BuyPrompt.ActionText = ("Buy R$%*"):format(v5)
        end
    end

    local v7 = p5._productPriceController:getPrice(p7.productId, Product)

    if v7 ~= nil then
        v5 = v7
        v6()
    end

    p5._productPriceController:requestPrice(p7.productId, Product)
    subscribe(p5._productPriceController.priceCache, function() -- line: 83
        -- upvalues: p5 (copy), p7 (copy), Product (copy), v5 (ref), v6 (copy)
        local v8 = p5._productPriceController:getPrice(p7.productId, Product)

        if v8 ~= nil then
            v5 = v8
            v6()
        end
    end)
    Players.LocalPlayer:GetAttributeChangedSignal("QaFreePurchaseModeEnabled"):Connect(v6)
end

function self._createPreviewPrompt(p8, p9, p10, p11) -- line: 88
    -- upvalues: Players (copy), v1 (copy)
    local PreviewPrompt = p9:FindFirstChild("PreviewPrompt")

    if PreviewPrompt == nil then
        PreviewPrompt = Instance.new("ProximityPrompt")
        PreviewPrompt.Name = "PreviewPrompt"
        PreviewPrompt.Parent = p9
    end

    if not PreviewPrompt:IsA("ProximityPrompt") then
        return nil
    end

    PreviewPrompt.ActionText = "Preview"
    PreviewPrompt.ObjectText = p10
    PreviewPrompt.HoldDuration = 0
    PreviewPrompt.KeyboardKeyCode = Enum.KeyCode.Q
    PreviewPrompt.MaxActivationDistance = 20
    PreviewPrompt.RequiresLineOfSight = false
    PreviewPrompt.UIOffset = v1
    PreviewPrompt.Triggered:Connect(function(p12) -- line: 105
        -- upvalues: p8 (copy), p11 (copy), Players (copy)
        if p12 == Players.LocalPlayer then
            p8._previewController:startPreview(p11)
        end
    end)
end

Reflect.defineMetadata(self, "identifier", "client/components/mount-fish-podium-component@MountFishPodiumComponent")
Reflect.defineMetadata(self, "flamework:parameters", { "client/controllers/mount-fish-preview-controller@MountFishPreviewController", "client/controllers/product-price-controller@ProductPriceController" })
Reflect.defineMetadata(self, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(self, "$c:components@Component", Component, {
    {
        tag = "MountFishPodium",
        attributes = {},
        instanceGuard = t.intersection(t.instanceIsA("Model"), t.children({
            ProximityPart = t.instanceIsA("BasePart")
        }))
    }
})

return {
    MountFishPodiumComponent = self
}
