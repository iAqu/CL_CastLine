-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect, Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect, RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react-roblox")
local createPortal, createRoot = v1.createPortal, v1.createRoot
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local Players, StarterGui = services.Players, services.StarterGui
local clientProducer = RuntimeLib.import(script, script.Parent.Parent, "reflex", "producer").clientProducer
local default = RuntimeLib.import(script, script.Parent.Parent, "react", "app").default
local react = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react")
local StrictMode = react.StrictMode
local ReflexProvider = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "react-reflex").ReflexProvider
local v2 = RuntimeLib.import(script, script.Parent.Parent, "react", "context", "theme-context")
local defaultTheme, ThemeContext = v2.defaultTheme, v2.ThemeContext
local ConfigProvider = RuntimeLib.import(script, script.Parent.Parent, "react", "context", "config-context").ConfigProvider
local ProductPriceContext = RuntimeLib.import(script, script.Parent.Parent, "react", "context", "product-price-context").ProductPriceContext
local subscribe = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "charm").subscribe
local self = setmetatable({}, {
    __tostring = function() -- __tostring | line: 26
        return "ReactController"
    end
})

self.__index = self

function self.new(...) -- line: 31
    -- upvalues: self (copy)
    local self2 = setmetatable({}, self)

    return self2:constructor(...) or self2
end

function self.constructor(p1, p2, p3, p4, p5, p6, p7, p8, p9) -- line: 35
    p1._animationController = p2
    p1._areaTeleportController = p3
    p1._characterController = p4
    p1._communityRewardsController = p5
    p1._freeRewardsController = p6
    p1._productPriceController = p7
    p1._slapWeaponController = p8
    p1._soundController = p9
end

function self.onInit(_) -- line: 45
end

function self.onStart(p11) -- line: 47
    -- upvalues: createPortal (copy), createRoot (copy), Players (copy), StarterGui (copy), clientProducer (copy), default (copy), react (copy), StrictMode (copy), ReflexProvider (copy), defaultTheme (copy), ThemeContext (copy), ConfigProvider (copy), ProductPriceContext (copy), subscribe (copy)
    StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Backpack, false)

    local t4 = {
        disableMovement = function() -- disableMovement | line: 50
            -- upvalues: p11 (copy)
            p11._characterController:_disableMovement()
        end,
        enableMovement = function() -- enableMovement | line: 53
            -- upvalues: p11 (copy)
            p11._characterController:_enableMovement()
        end,
        playAnimation = function(p12, p13) -- playAnimation | line: 56
            -- upvalues: p11 (copy)
            return p11._animationController:playAnimation(p12, p13)
        end,
        stopAllAnimations = function() -- stopAllAnimations | line: 59
            -- upvalues: p11 (copy)
            p11._animationController:stopAllAnimations()
        end,
        getSound = function(p14) -- getSound | line: 62
            -- upvalues: p11 (copy)
            return p11._soundController:getSound(p14)
        end,
        handleWeaponUsed = function() -- handleWeaponUsed | line: 65
            -- upvalues: p11 (copy)
            p11._slapWeaponController:activateSlap()
        end,
        getSoundGroup = function(p15) -- getSoundGroup | line: 68
            -- upvalues: p11 (copy)
            return p11._soundController:getSoundGroup(p15)
        end,
        promptToFavoriteGame = function() -- promptToFavoriteGame | line: 71
            -- upvalues: p11 (copy)
            p11._communityRewardsController:promptToFavoriteGame()
        end,
        promptToJoinCommunity = function() -- promptToJoinCommunity | line: 74
            -- upvalues: p11 (copy)
            return p11._communityRewardsController:promptToJoinCommunity()
        end,
        promptToJoinGroup = function() -- promptToJoinGroup | line: 77
            -- upvalues: p11 (copy)
            p11._freeRewardsController:promptToJoinGroup()
        end,
        teleportToHome = function() -- teleportToHome | line: 80
            -- upvalues: p11 (copy)
            p11._areaTeleportController:teleportToHome()
        end
    }
    local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
    local v5 = createRoot(Instance.new("Folder"))
    local t5 = {
        getPrice = function(p16, p17) -- getPrice | line: 88
            -- upvalues: p11 (copy)
            return p11._productPriceController:getPrice(p16, p17)
        end,
        requestPrice = function(p18, p19) -- requestPrice | line: 91
            -- upvalues: p11 (copy)
            return p11._productPriceController:requestPrice(p18, p19)
        end,
        subscribe = function(p20) -- subscribe | line: 94
            -- upvalues: p11 (copy), subscribe (copy)
            return subscribe(p11._productPriceController.priceCache, p20)
        end
    }

    v5:render(react.createElement(StrictMode, nil, react.createElement(ReflexProvider, {
        producer = clientProducer
    }, react.createElement(ConfigProvider, {
        configValue = t4
    }, createPortal(react.createElement(ThemeContext.Provider, {
        value = defaultTheme
    }, react.createElement(ProductPriceContext.Provider, {
        value = t5
    }, react.createElement(default))), PlayerGui)))))
end

Reflect.defineMetadata(self, "identifier", "client/controllers/react-controller@ReactController")
Reflect.defineMetadata(self, "flamework:parameters", { "client/controllers/custom-animation-controller@CustomAnimationController", "client/controllers/area-teleport-controller@AreaTeleportController", "client/controllers/character-controller@CharacterController", "client/controllers/community-rewards-controller@CommunityRewardsController", "client/controllers/free-rewards-controller@FreeRewardsController", "client/controllers/product-price-controller@ProductPriceController", "client/controllers/slap-weapon-controller@SlapWeaponController", "client/controllers/sound-controller@SoundController" })
Reflect.defineMetadata(self, "flamework:implements", { "$:flamework@OnStart", "$:flamework@OnInit" })
Reflect.decorate(self, "$:flamework@Controller", Controller, {})

return {
    ReactController = self
}
