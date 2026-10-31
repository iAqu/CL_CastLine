-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect, Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect, RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller
local atom = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "charm").atom
local HttpService = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services").HttpService
local events = RuntimeLib.import(script, script.Parent.Parent, "network").events
local rewardPresentationQueue = RuntimeLib.import(script, script.Parent.Parent, "reward-presentation-queue").rewardPresentationQueue
local v1 = atom(0)
local v2 = atom(0)
local v3 = atom(0)
local self = setmetatable({}, {
    __tostring = function() -- __tostring | line: 23
        return "CelebrationEventController"
    end
})

self.__index = self

function self.new(...) -- line: 28
    -- upvalues: self (copy)
    local self2 = setmetatable({}, self)

    return self2:constructor(...) or self2
end

function self.constructor(_) -- line: 32
end

function self.onStart(_) -- line: 34
    -- upvalues: HttpService (copy), events (copy), rewardPresentationQueue (copy), v1 (copy), v2 (copy)
    events.celebrationEventRegisteredCountUpdated:connect(function(p3) -- line: 35
        -- upvalues: v1 (copy)
        v1(p3)
    end)
    events.celebrationChallengeTicketsUpdated:connect(function(p4) -- line: 38
        -- upvalues: v2 (copy)
        v2(p4)
    end)
    events.celebrationRewardGranted:connect(function(p5) -- line: 41
        -- upvalues: HttpService (copy), rewardPresentationQueue (copy)
        rewardPresentationQueue:enqueue({
            kind = "celebrationDaily",
            id = HttpService:GenerateGUID(false),
            reward = p5
        })
    end)
    events.celebrationMinigameRewardGranted:connect(function(p6) -- line: 48
        -- upvalues: HttpService (copy), rewardPresentationQueue (copy)
        rewardPresentationQueue:enqueue({
            kind = "minigameTickets",
            id = HttpService:GenerateGUID(false),
            reward = p6
        })
    end)
end

Reflect.defineMetadata(self, "identifier", "client/controllers/celebration-event-controller@CelebrationEventController")
Reflect.defineMetadata(self, "flamework:implements", { "$:flamework@OnStart" })
Reflect.decorate(self, "$:flamework@Controller", Controller, {})

return {
    celebrationEventRegisteredCountAtom = v1,
    celebrationChallengeTicketsAtom = v2,
    farewellRewardClaimRequestedAtom = v3,
    CelebrationEventController = self
}
