-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

return {
    Name = "currentTreadmillMedia",
    Description = "Print the media key and asset IDs of the treadmill or phone media currently playing for you",
    Group = "Moderator",
    Aliases = { "curVid", "curVideo" },
    Args = {},
    ClientRun = function(_) -- ClientRun | line: 8
        local Players = game:GetService("Players")
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local TreadmillVideoController = require(ReplicatedStorage.Shared.TreadmillVideoController)
        local TreadmillMediaIdentity = require(ReplicatedStorage.Shared.Modules.TreadmillMediaIdentity)

        local function findPhoneVideoAssetId() -- line: 19
            -- upvalues: Players (copy)
            local PlayerGui = Players.LocalPlayer:FindFirstChildOfClass("PlayerGui")
            local PhoneVideoUI = if PlayerGui == nil then nil else PlayerGui:FindFirstChild("PhoneVideoUI")
            local v1, v2

            if PhoneVideoUI ~= nil then
                if PhoneVideoUI:IsA("ScreenGui") and PhoneVideoUI.Enabled then
                    local Phone = PhoneVideoUI:FindFirstChild("Phone")

                    if Phone ~= nil then
                        v1 = Phone:FindFirstChild("MainVideo", true)
                    end

                    v2 = false
                else
                    v2 = true
                end
            else
                v2 = true
            end

            if v2 then
                return nil
            end

            if v1 ~= nil and v1:IsA("VideoFrame") and v1.Video ~= "" then
                return string.match(v1.Video, "%d+")
            end

            return nil
        end

        local v3 = TreadmillVideoController.GetActiveMediaEntry()
        local v4

        if v3 ~= nil then
            v4 = "Treadmill"
        else
            local v5 = findPhoneVideoAssetId()

            if v5 ~= nil then
                v3 = TreadmillVideoController.GetMediaEntryByKey((("Video:%*"):format(v5)))

                if v3 == nil then
                    local v6 = ("Video: %* (Phone, no matching media entry)"):format(v5)

                    print((("[currentTreadmillMedia] %*"):format(v6)))

                    return v6
                end

                v4 = "Phone"
            else
                v4 = "Treadmill"
            end
        end

        if v3 == nil then
            return "No media is currently playing (run on a treadmill or open the phone first)"
        end

        local t1 = {
            ("Key: %* (%*)"):format(TreadmillMediaIdentity.GetMediaKey(v3), v4),
            (("Kind: %* | Bucket: %* | Release: %*"):format(v3.Kind, v3.BucketType, v3.ReleaseVersion))
        }

        if v3.Kind == "Video" then
            table.insert(t1, (("Video: %*"):format(v3.Video)))
            table.insert(t1, (("Cover: %*"):format(v3.CoverImage or "(none)")))

            local Music = v3.Music

            if Music ~= nil then
                table.insert(t1, (("Music: %*"):format(Music.SoundId)))
            end
        else
            table.insert(t1, (("Image: %*"):format(v3.Image)))
            table.insert(t1, (("Sound: %*"):format(v3.SoundId)))
        end

        local v12 = table.concat(t1, "\n")

        print((("[currentTreadmillMedia]\n%*"):format(v12)))

        return v12
    end
}
