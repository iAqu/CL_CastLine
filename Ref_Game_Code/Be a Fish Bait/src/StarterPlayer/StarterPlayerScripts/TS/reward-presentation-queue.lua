-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local RuntimeLib = require(game:GetService("ReplicatedStorage"):WaitForChild("rbxts_include"):WaitForChild("RuntimeLib"))
local subscribe = RuntimeLib.import(script, game:GetService("ReplicatedStorage"), "rbxts_include", "node_modules", "@rbxts", "charm").subscribe
local catchSticksActiveAtom = RuntimeLib.import(script, script.Parent, "catch-sticks-active-atom").catchSticksActiveAtom
local secretFrostwyrmActiveAtom = RuntimeLib.import(script, script.Parent, "secret-frostwyrm-active-atom").secretFrostwyrmActiveAtom
local rglActiveAtom = RuntimeLib.import(script, script.Parent, "rgl-active-atom").rglActiveAtom
local clientProducer = RuntimeLib.import(script, script.Parent, "reflex", "producer").clientProducer
local aquariumCrateRewardAtom = RuntimeLib.import(script, script.Parent, "aquarium-crate-reward-atom").aquariumCrateRewardAtom
local t1 = {}
local v1
local t2 = {}

local function isSafeToPresent() -- line: 12
    -- upvalues: catchSticksActiveAtom (copy), secretFrostwyrmActiveAtom (copy), rglActiveAtom (copy)
    return not catchSticksActiveAtom() and not secretFrostwyrmActiveAtom() and not rglActiveAtom()
end

local function openUsingExistingSystem(p1) -- line: 15
    -- upvalues: clientProducer (copy), aquariumCrateRewardAtom (copy)
    if p1.kind == "aquariumCrate" then
        aquariumCrateRewardAtom(p1.reveal)
    elseif p1.kind == "rgl" then
        clientProducer.rglRewardReceived({
            id = p1.id,
            reward = p1.reward
        })
    elseif p1.kind == "pinataBoss" then
        clientProducer.pinataBossRewardReceived({
            id = p1.id,
            reward = p1.reward
        })
    elseif p1.kind == "celebrationDaily" then
        clientProducer.celebrationRewardReceived({
            id = p1.id,
            reward = p1.reward
        })
    else
        clientProducer.minigameRewardReceived({
            id = p1.id,
            reward = p1.reward
        })
    end
end

local function pump() -- line: 40
    -- upvalues: catchSticksActiveAtom (copy), secretFrostwyrmActiveAtom (copy), rglActiveAtom (copy), t1 (copy), v1 (ref), openUsingExistingSystem (copy)
    if v1 ~= nil or catchSticksActiveAtom() or secretFrostwyrmActiveAtom() or rglActiveAtom() then
        return nil
    end

    local v2 = table.remove(t1, 1)

    if v2 == nil then
        return nil
    end

    v1 = v2
    openUsingExistingSystem(v2)
end

local t3 = {
    enqueue = function(_, p3) -- enqueue | line: 52
        -- upvalues: catchSticksActiveAtom (copy), secretFrostwyrmActiveAtom (copy), rglActiveAtom (copy), t1 (copy), v1 (ref), t2 (copy), openUsingExistingSystem (copy)
        if t2[p3.id] ~= nil then
            return nil
        end

        t2[p3.id] = true
        table.insert(t1, p3)

        if v1 ~= nil then
            return
        end

        if not catchSticksActiveAtom() and not secretFrostwyrmActiveAtom() and not rglActiveAtom() then
            local v3 = table.remove(t1, 1)

            if v3 == nil then
                return
            end

            v1 = v3
            openUsingExistingSystem(v3)
        end
    end,
    presentationFinished = function(_, p5) -- presentationFinished | line: 63
        -- upvalues: catchSticksActiveAtom (copy), secretFrostwyrmActiveAtom (copy), rglActiveAtom (copy), t1 (copy), v1 (ref), t2 (copy), openUsingExistingSystem (copy)
        local v4 = v1

        if v4 ~= nil then
            v4 = v4.id
        end

        if v4 ~= p5 then
            return nil
        end

        t2[p5] = nil
        v1 = nil

        if v1 ~= nil then
            return
        end

        if not catchSticksActiveAtom() and not secretFrostwyrmActiveAtom() and not rglActiveAtom() then
            local v5 = table.remove(t1, 1)

            if v5 == nil then
                return
            end

            v1 = v5
            openUsingExistingSystem(v5)
        end
    end
}

subscribe(catchSticksActiveAtom, function() -- line: 77
    -- upvalues: pump (copy)
    return pump()
end)
subscribe(secretFrostwyrmActiveAtom, function() -- line: 80
    -- upvalues: pump (copy)
    return pump()
end)
subscribe(rglActiveAtom, function() -- line: 83
    -- upvalues: pump (copy)
    return pump()
end)

return {
    rewardPresentationQueue = t3
}
