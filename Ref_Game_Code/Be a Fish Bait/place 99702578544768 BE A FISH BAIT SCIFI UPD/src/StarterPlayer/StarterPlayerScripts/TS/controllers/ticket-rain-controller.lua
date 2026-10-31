-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local Reflect, Controller = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Reflect, RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@flamework", "core", "out").Controller
local services = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "services")
local HttpService, Players, ReplicatedStorage, Workspace = services.HttpService, services.Players, services.ReplicatedStorage, services.Workspace
local functions = RuntimeLib.import(script, script.Parent.Parent, "network").functions
local localPlayerUserId = RuntimeLib.import(script, script.Parent.Parent, "utils").localPlayerUserId
local selectCurrentTickets = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "current-tickets.selectors").selectCurrentTickets
local selectPlayerTicketCapProgress = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "slices", "player-data", "selectors").selectPlayerTicketCapProgress
local v1 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "data", "ticket-sources")
local formatCapResetCountdown, ticketSourceDisplayName = v1.formatCapResetCountdown, v1.ticketSourceDisplayName
local hueForElapsed = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "hue-cycle-utils").hueForElapsed
local v2 = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "utils", "ticket-rain-utils")
local ticketFadeOutSeconds, ticketLifespanSeconds = v2.ticketFadeOutSeconds, v2.ticketLifespanSeconds
local images = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "TS", "images").images
local v3 = Color3.fromRGB(255, 221, 51)
local t1 = {
    Enum.NormalId.Front,
    Enum.NormalId.Back
}

local function createComboPitchTracker(p1) -- line: 44
    local n1 = 1
    local v4, v5
    local Volume = nil

    return function(p2) -- line: 49
        -- upvalues: p1 (copy), n1 (ref), v4 (ref), v5 (ref), Volume (ref)
        if v4 ~= nil then
            task.cancel(v4)
        end

        if Volume == nil then
            Volume = p2.Volume
        end

        v5 = p2
        n1 = math.min(n1 + 0.2, 2.2)

        local v7 = (n1 - 1) / 1.2000000000000002
        local Volume2 = Volume

        p2.Volume = Volume2 * (v7 * 2 + 1)

        local PitchShiftSoundEffect = p2:FindFirstChildOfClass("PitchShiftSoundEffect")

        if PitchShiftSoundEffect ~= nil then
            PitchShiftSoundEffect:Destroy()
        end

        local PitchShiftSoundEffect2 = Instance.new("PitchShiftSoundEffect")

        PitchShiftSoundEffect2.Octave = n1
        PitchShiftSoundEffect2.Parent = p2
        v4 = task.delay(p1, function() -- line: 68
            -- upvalues: n1 (ref), v4 (ref), v5 (ref), Volume (ref)
            n1 = 1
            v4 = nil

            if v5 == nil or Volume == nil then
                return
            end

            v5.Volume = Volume

            local PitchShiftSoundEffect = v5:FindFirstChildOfClass("PitchShiftSoundEffect")

            if PitchShiftSoundEffect ~= nil then
                PitchShiftSoundEffect:Destroy()
            end

            v5 = nil
        end)
    end
end

local n2 = 1
local v8, v9
local Volume = nil
local n3 = 1

local function v10(p3) -- line: 49
    -- upvalues: n2 (ref), v8 (ref), v9 (ref), Volume (ref), n3 (copy)
    if v8 ~= nil then
        task.cancel(v8)
    end

    if Volume == nil then
        Volume = p3.Volume
    end

    v9 = p3
    n2 = math.min(n2 + 0.2, 2.2)

    local v12 = (n2 - 1) / 1.2000000000000002
    local Volume2 = Volume

    p3.Volume = Volume2 * (v12 * 2 + 1)

    local PitchShiftSoundEffect = p3:FindFirstChildOfClass("PitchShiftSoundEffect")

    if PitchShiftSoundEffect ~= nil then
        PitchShiftSoundEffect:Destroy()
    end

    local PitchShiftSoundEffect2 = Instance.new("PitchShiftSoundEffect")

    PitchShiftSoundEffect2.Octave = n2
    PitchShiftSoundEffect2.Parent = p3
    v8 = task.delay(n3, function() -- line: 68
        -- upvalues: n2 (ref), v8 (ref), v9 (ref), Volume (ref)
        n2 = 1
        v8 = nil

        if v9 == nil or Volume == nil then
            return
        end

        v9.Volume = Volume

        local PitchShiftSoundEffect = v9:FindFirstChildOfClass("PitchShiftSoundEffect")

        if PitchShiftSoundEffect ~= nil then
            PitchShiftSoundEffect:Destroy()
        end

        v9 = nil
    end)
end

local n4 = 1
local v13, v14
local Volume2 = nil
local n5 = 2

local function v15(p4) -- line: 49
    -- upvalues: n4 (ref), v13 (ref), v14 (ref), Volume2 (ref), n5 (copy)
    if v13 ~= nil then
        task.cancel(v13)
    end

    if Volume2 == nil then
        Volume2 = p4.Volume
    end

    v14 = p4
    n4 = math.min(n4 + 0.2, 2.2)

    local v17 = (n4 - 1) / 1.2000000000000002
    local Volume = Volume2

    p4.Volume = Volume * (v17 * 2 + 1)

    local PitchShiftSoundEffect = p4:FindFirstChildOfClass("PitchShiftSoundEffect")

    if PitchShiftSoundEffect ~= nil then
        PitchShiftSoundEffect:Destroy()
    end

    local PitchShiftSoundEffect2 = Instance.new("PitchShiftSoundEffect")

    PitchShiftSoundEffect2.Octave = n4
    PitchShiftSoundEffect2.Parent = p4
    v13 = task.delay(n5, function() -- line: 68
        -- upvalues: n4 (ref), v13 (ref), v14 (ref), Volume2 (ref)
        n4 = 1
        v13 = nil

        if v14 == nil or Volume2 == nil then
            return
        end

        v14.Volume = Volume2

        local PitchShiftSoundEffect = v14:FindFirstChildOfClass("PitchShiftSoundEffect")

        if PitchShiftSoundEffect ~= nil then
            PitchShiftSoundEffect:Destroy()
        end

        v14 = nil
    end)
end

local self = setmetatable({}, {
    __tostring = function() -- __tostring | line: 87
        return "TicketRainController"
    end
})

self.__index = self

function self.new(...) -- line: 92
    -- upvalues: self (copy)
    local self2 = setmetatable({}, self)

    return self2:constructor(...) or self2
end

function self.constructor(p5, p6, p7) -- line: 96
    p5._reflexController = p6
    p5._soundController = p7
    p5._liveTickets = {}
end

function self.onStart(p8) -- line: 101
    -- upvalues: localPlayerUserId (copy), selectCurrentTickets (copy), selectPlayerTicketCapProgress (copy)
    local v20 = p8._reflexController:getClientProducer()

    v20:subscribe(selectCurrentTickets, function(p9) -- line: 103
        -- upvalues: p8 (copy)
        p8:_syncTickets(p9)
    end)
    v20:subscribe(selectPlayerTicketCapProgress(localPlayerUserId, "TicketRain"), function(p10) -- line: 106
        -- upvalues: p8 (copy)
        p8._ticketRainCapResetsAt = if p10 == nil then p10 else p10.resetsAt
    end)
end

function self._isCappedForTicketRain(p11, p12) -- line: 114
    return p11._ticketRainCapResetsAt ~= nil and p12 < p11._ticketRainCapResetsAt
end

function self._showCappedFeedback(p13) -- line: 117
    -- upvalues: HttpService (copy), Workspace (copy), formatCapResetCountdown (copy), ticketSourceDisplayName (copy)
    local elapsed = os.clock()

    if p13._cappedFeedbackCooldownUntilClock ~= nil and elapsed < p13._cappedFeedbackCooldownUntilClock then
        return nil
    end

    p13._cappedFeedbackCooldownUntilClock = elapsed + 10

    local _ticketRainCapResetsAt = p13._ticketRainCapResetsAt
    local v22 = if _ticketRainCapResetsAt == nil then "" else formatCapResetCountdown(_ticketRainCapResetsAt, Workspace:GetServerTimeNow())

    p13._reflexController:getClientProducer().onScreenFeedbackAdded({
        duration = 10,
        type = "neutral",
        id = HttpService:GenerateGUID(false),
        message = ("%* tickets capped, resets in %*"):format(ticketSourceDisplayName("TicketRain"), v22)
    })
end

function self._syncTickets(p14, p15) -- line: 132
    for v23, v24 in p15 do
        if p14._liveTickets[v23] == nil then
            p14:_spawnTicketPart(v23, v24)
        end
    end

    for v25, v26 in p14._liveTickets do
        if p15[v25] == nil then
            p14:_destroyTicketPart(v25, v26)
        end
    end
end

function self._spawnTicketPart(p16, p17, p18) -- line: 146
    -- upvalues: Workspace (copy), images (copy), v3 (copy), t1 (copy)
    local Part = Instance.new("Part")

    Part.Name = ("Ticket_%*"):format(p17)
    Part.Size = Vector3.new(4, 3, 0.3)
    Part.Color = v3
    Part.Material = Enum.Material.Neon
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanTouch = true
    Part.CanQuery = false
    Part.CFrame = CFrame.new(p18.position)
    Part.Parent = Workspace

    local t5 = {}

    for _, v27 in t1 do
        local Decal = Instance.new("Decal")

        Decal.Name = ("TicketDecal_%*"):format(v27.Name)
        Decal.Face = v27
        Decal.Texture = images.celebrationTicket
        Decal.Parent = Part
        table.insert(t5, Decal)
    end

    local v28 = p16:_spawnBeam(p18.position)

    if v28 and not p18.isRainbow then
        p16:_setBeamColor(v28, v3)
    end

    p16._liveTickets[p17] = {
        hasRequestedCollect = false,
        beamPart = v28,
        decals = t5,
        isRainbow = p18.isRainbow,
        part = Part,
        spawnPosition = p18.position,
        spawnTimestamp = p18.spawnTimestamp
    }
end

function self._spawnBeam(_, p20) -- line: 184
    -- upvalues: ReplicatedStorage (copy), Workspace (copy)
    local BeamPart = ReplicatedStorage:FindFirstChild("BeamPart")

    if not BeamPart then
        return nil
    end

    local clone = BeamPart:Clone()

    clone.CFrame = CFrame.new(p20)
    clone.Parent = Workspace

    return clone
end

function self._updateBeamColor(p21, p22, p23) -- line: 194
    p21:_setBeamColor(p22, Color3.fromHSV(p23, 1, 1))
end

function self._setBeamColor(_, p25, p26) -- line: 197
    local Attachment0 = p25:FindFirstChild("Attachment0")

    if Attachment0 ~= nil then
        Attachment0 = Attachment0:FindFirstChildOfClass("Beam")
    end

    if not Attachment0 then
        return nil
    end

    Attachment0.Color = ColorSequence.new(p26)
end

function self._destroyTicketPart(p27, p28, p29) -- line: 208
    local touchConnection = p29.touchConnection

    if touchConnection ~= nil then
        touchConnection:Disconnect()
    end

    local beamPart = p29.beamPart

    if beamPart ~= nil then
        beamPart:Destroy()
    end

    p29.part:Destroy()
    p27._liveTickets[p28] = nil
end

self._requestCollect = RuntimeLib.async(function(p30, p31, p32) -- line: 222
    -- upvalues: RuntimeLib (copy), functions (copy), v10 (copy), v15 (copy)
    if p32.hasRequestedCollect or p32.retryAfterClock ~= nil and os.clock() < p32.retryAfterClock then
        return nil
    end

    p32.hasRequestedCollect = true

    local touchConnection = p32.touchConnection

    if touchConnection ~= nil then
        touchConnection:Disconnect()
    end

    p32.touchConnection = nil
    p32.part.Transparency = 1
    p32.part.CanTouch = false

    for _, v30 in p32.decals do
        v30.Transparency = 1
    end

    v10((p30._soundController:playSound("MoneyPickup2")))

    if p32.isRainbow then
        v15((p30._soundController:playSound("BonusUpgrade")))
    end

    if RuntimeLib.await(functions.collectTicket(p31)) == false or p30._reflexController:getClientProducer():getState().currentTickets[p31] == nil or p30._liveTickets[p31] == nil then
        return nil
    end

    p32.hasRequestedCollect = false
    p32.retryAfterClock = os.clock() + 1
    p32.part.CanTouch = true
end)

function self.onTick(p33) -- line: 271
    -- upvalues: Players (copy), Workspace (copy), hueForElapsed (copy), ticketFadeOutSeconds (copy), ticketLifespanSeconds (copy)
    local Character = Players.LocalPlayer.Character

    if Character ~= nil then
        Character = Character:FindFirstChild("HumanoidRootPart")
    end

    local ServerTimeNow = Workspace:GetServerTimeNow()

    for v31, v32 in p33._liveTickets do
        if not v32.hasRequestedCollect then
            local v33 = ServerTimeNow - v32.spawnTimestamp
            local v34 = v33 / 10 * 6.283185307179586
            local v36 = math.sin(v33 / 2 * 6.283185307179586) * 1
            local spawnPosition = v32.spawnPosition
            local v37 = Vector3.new(0, v36, 0)
            local v38 = CFrame.new(spawnPosition + v37)
            local v39 = CFrame.Angles(0, v34, 0)

            v32.part.CFrame = v38 * v39

            local v40 = ticketLifespanSeconds - v33
            local v41 = if v40 <= ticketFadeOutSeconds then math.clamp(1 - v40 / ticketFadeOutSeconds, 0, 1) else 0

            v32.part.Transparency = v41

            for _, v43 in v32.decals do
                v43.Transparency = v41
            end

            if v32.isRainbow then
                local v44 = hueForElapsed(v33, 0.6)

                v32.part.Color = Color3.fromHSV(v44, 1, 1)

                if v32.beamPart then
                    p33:_updateBeamColor(v32.beamPart, v44)
                end
            end

            if Character then
                if (Character.Position - v32.part.Position).Magnitude <= 10 then
                    if v32.touchConnection == nil then
                        v32.touchConnection = v32.part.Touched:Connect(function(p34) -- line: 312
                            -- upvalues: p33 (copy), v32 (copy), v31 (copy), Players (copy), Workspace (copy)
                            if p34.Parent ~= Players.LocalPlayer.Character then
                                return nil
                            end

                            if p33:_isCappedForTicketRain(Workspace:GetServerTimeNow()) then
                                p33:_showCappedFeedback()

                                return nil
                            end

                            p33:_requestCollect(v31, v32)
                        end)
                    end
                elseif v32.touchConnection ~= nil then
                    v32.touchConnection:Disconnect()
                    v32.touchConnection = nil
                end
            end
        end
    end
end

Reflect.defineMetadata(self, "identifier", "client/controllers/ticket-rain-controller@TicketRainController")
Reflect.defineMetadata(self, "flamework:parameters", { "client/controllers/reflex-controller@ReflexController", "client/controllers/sound-controller@SoundController" })
Reflect.defineMetadata(self, "flamework:implements", { "$:flamework@OnStart", "$:flamework@OnTick" })
Reflect.decorate(self, "$:flamework@Controller", Controller, { {} })

return {
    TicketRainController = self
}
