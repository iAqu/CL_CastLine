-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local Workspace = game:GetService("Workspace")
local t1 = {
    FolderName = "TrainEventAssets",
    CaveName = "SewerCave",
    MarkersName = "Markers",
    AmbienceName = "Ambience",
    LightingPresetName = "LightingPreset",
    WhirlpoolName = "Steal an Egg Whirlpool",
    WhirlpoolTag = "SewerCaveWhirlpool",
    ExitMarkerName = "SewerPipeExit",
    LightingPreset = "SewerCave",
    Markers = table.freeze({
        Spawn = "Spawn",
        Surface = "Surface",
        Npc = "Npc",
        Pipe = "Pipe",
        Bounds = "Bounds"
    }),
    Attributes = table.freeze({
        Inside = "InSewerCave",
        TriggerRadius = "TriggerRadius",
        TriggerHeight = "TriggerHeight"
    }),
    Worker = table.freeze({
        Name = "Gus",
        PipeLine = 5,
        KeyPipeLine = 2,
        Lines = table.freeze({ "AHH! WHO'S THERE?! Oh... you're not one of them. How did you even get down here?!", "I used to work at that old manor... until I accidentally dropped the Manor Key into this water!", "The owners are gonna KILL ME if they find out! I've been hiding down here ever since!", "Please! If you can fish that key out, you can keep it! Just don't tell them I lost it!", "Oh, and there's a pipe over there that leads back to the manor... but I'm NOT going back!" }),
        KeyLines = table.freeze({ "You FOUND it?! ...shh, you didn't get it from me!", "Take it to the manor door. The pipe over there goes right to it... I'm staying put!" })
    }),
    Messages = table.freeze({
        KeyCaught = "You fished up the Manor Key!",
        Ragdolled = "Wait until you recover first!",
        Mounted = "Get off your mount first!",
        Fallback = "The pipe spat you out back in the lobby!"
    }),
    Cave = function() -- Cave | line: 62
        -- upvalues: Workspace (copy)
        local TrainEventAssets = Workspace:FindFirstChild("TrainEventAssets")
        local SewerCave = TrainEventAssets and TrainEventAssets:FindFirstChild("SewerCave")

        return if SewerCave ~= nil and SewerCave:IsA("Model") then SewerCave else nil
    end
}

function t1.Marker(p1) -- line: 68
    -- upvalues: t1 (copy)
    local v1 = t1.Cave()
    local Markers = v1 and v1:FindFirstChild("Markers")
    local v2 = Markers and Markers:FindFirstChild(p1)

    return if v2 ~= nil and v2:IsA("BasePart") then v2 else nil
end

function t1.Within(p2, p3, p4) -- line: 75
    local v3 = p2.CFrame:PointToObjectSpace(p3)
    local v4 = p2.Size / 2 + Vector3.new(1, 1, 1) * p4

    if math.abs(v3.X) <= v4.X then
        if not (math.abs(v3.Y) <= v4.Y) then
            return false
        end

        return math.abs(v3.Z) <= v4.Z
    end

    return false
end

return table.freeze(t1)
