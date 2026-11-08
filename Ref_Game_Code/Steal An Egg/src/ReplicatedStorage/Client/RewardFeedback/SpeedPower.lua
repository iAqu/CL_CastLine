-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Reward = require(ReplicatedStorage.Client.Notifications.Reward)
local Rain = require(ReplicatedStorage.Client.UI.VFX.Rain)
local t1 = { 0.9, 1.1 }

local function showerRecipe() -- line: 15
    -- upvalues: t1 (copy)
    return {
        Seconds = 1,
        Ambience = {
            Volume = 1.3,
            PlaybackSpeed = t1,
            Sounds = { "rbxassetid://78590382571227" }
        },
        Sheets = {
            {
                SizeMultiplier = 3,
                Texture = "rbxassetid://78137530993637"
            }
        }
    }
end

local v1 = table.freeze((showerRecipe()))

return {
    Announce = function(p1) -- Announce | line: 36
        -- upvalues: Reward (copy), Rain (copy), v1 (copy)
        assert(type(p1) == "number" and p1 > 0, "a speed power announcement needs a positive amount")
        Rain.Fall(v1)
        Reward.Show({
            Item = {
                Kind = "SpeedPower",
                Amount = math.round(p1)
            }
        })
    end
}
