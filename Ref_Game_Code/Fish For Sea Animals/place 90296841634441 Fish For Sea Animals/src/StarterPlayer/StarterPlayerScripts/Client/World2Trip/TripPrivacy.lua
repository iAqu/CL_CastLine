-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Trip = require(script.Parent.Trip)
local LocalPlayer = Players.LocalPlayer
local t1 = {}
local t2 = {}

local function inTrip(p1) -- line: 23
    return p1:GetAttribute("InWorld2Trip") == true
end

local function travelling() -- line: 27
    -- upvalues: Trip (copy), LocalPlayer (copy)
    return Trip.isPlaying() or LocalPlayer:GetAttribute("InWorld2Trip") == true
end

function t1.hides(p2) -- line: 32
    -- upvalues: Trip (copy), LocalPlayer (copy)
    if p2 == LocalPlayer then
        return false
    end

    local v1 = Trip.isPlaying() or LocalPlayer:GetAttribute("InWorld2Trip") == true

    if not v1 then
        v1 = p2 ~= nil and p2:GetAttribute("InWorld2Trip") == true
    end

    return v1
end

local function save(p3, p4, p5, p6) -- line: 39
    if p3.saved[p4] == nil then
        p3.saved[p4] = {
            p5,
            p4[p5]
        }
    end

    p4[p5] = p6
end

local function hideOne(p7, p8) -- line: 46
    if p8:IsA("BasePart") or p8:IsA("Decal") then
        p8.LocalTransparencyModifier = 1
        p7.saved[p8] = p7.saved[p8] or { "LocalTransparencyModifier", 0 }
    elseif not p8:IsA("ParticleEmitter") and not p8:IsA("Beam") and not p8:IsA("Trail") and not p8:IsA("Light") and not p8:IsA("LayerCollector") and not p8:IsA("Highlight") and not p8:IsA("Fire") and not p8:IsA("Smoke") and not p8:IsA("Sparkles") then
        if p8:IsA("Sound") then
            if p7.saved[p8] == nil then
                p7.saved[p8] = {
                    "Volume",
                    p8.Volume
                }
            end

            p8.Volume = 0
        elseif p8:IsA("Humanoid") then
            local None = Enum.HumanoidDisplayDistanceType.None

            if p7.saved[p8] == nil then
                p7.saved[p8] = {
                    "DisplayDistanceType",
                    p8.DisplayDistanceType
                }
            end

            p8.DisplayDistanceType = None
        end
    else
        if p7.saved[p8] == nil then
            p7.saved[p8] = {
                "Enabled",
                p8.Enabled
            }
        end

        p8.Enabled = false
    end
end

local function hide(p9) -- line: 59
    -- upvalues: t2 (copy), hideOne (copy)
    if t2[p9] then
        return
    end

    local t3 = {
        saved = {}
    }

    t2[p9] = t3
    hideOne(t3, p9)

    for _, descendant in p9:GetDescendants() do
        hideOne(t3, descendant)
    end

    t3.conn = p9.DescendantAdded:Connect(function(p10) -- line: 69
        -- upvalues: t3 (copy), hideOne (copy)
        hideOne(t3, p10)
    end)
end

local function show(p11) -- line: 74
    -- upvalues: t2 (copy)
    local v2 = t2[p11]

    if not v2 then
        return
    end

    t2[p11] = nil
    v2.conn:Disconnect()

    for v3, v4 in v2.saved do
        if v3.Parent then
            local function v5() -- line: 83
                -- upvalues: v3 (copy), v4 (copy)
                v3[v4[1]] = v4[2]
            end

            pcall(v5)
        end
    end
end

local function update() -- line: 90
    -- upvalues: Players (copy), t1 (copy), t2 (copy), hide (copy), show (copy)
    local t4 = {}

    for _, player in Players:GetPlayers() do
        local Character = player.Character

        if Character and t1.hides(player) then
            t4[Character] = true
            hide(Character)
        end
    end

    for v6 in t2 do
        if not t4[v6] then
            show(v6)
        end
    end
end

function t1.init() -- line: 106
    -- upvalues: Players (copy), RunService (copy), update (copy)
    local n1 = 0

    RunService.Heartbeat:Connect(function(p12) -- line: 108
        -- upvalues: n1 (ref), update (copy)
        n1 += p12

        if not (n1 < 0.15) then
            n1 = 0
            update()
        end
    end)

    local function watch(p13) -- line: 117
        -- upvalues: update (copy)
        p13:GetAttributeChangedSignal("InWorld2Trip"):Connect(update)
    end

    Players.PlayerAdded:Connect(watch)

    for _, player in Players:GetPlayers() do
        player:GetAttributeChangedSignal("InWorld2Trip"):Connect(update)
    end
end

return t1
