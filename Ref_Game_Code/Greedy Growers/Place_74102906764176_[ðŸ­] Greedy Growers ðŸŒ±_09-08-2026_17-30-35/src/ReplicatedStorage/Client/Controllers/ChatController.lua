-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMpBFRleHQGc3RyaW5nA3N1YgEhCEluc3RhbmNlA25ldxlUZXh0Q2hhdE1lc3NhZ2VQcm9wZXJ0aWVzASAKVGV4dFNvdXJjZQZVc2VySWQRR2V0UGxheWVyQnlVc2VySWQDVklQDEdldEF0dHJpYnV0ZQZmb3JtYXQoPGZvbnQgY29sb3I9J3JnYigyNTUsIDIwMCwgMCknPiVzPC9mb250PgZbVklQXSALRGlzcGxheU5hbWUKUHJlZml4VGV4dCo8Zm9udCBjb2xvcj0ncmdiKDE4MCwgMTgwLCAxODApJz4lczwvZm9udD4RT25JbmNvbWluZ01lc3NhZ2UJS25pdFN0YXJ0DUdldENvbnRyb2xsZXIKRGF0YUNsaWVudAhLbml0SW5pdARnYW1lEVJlcGxpY2F0ZWRTdG9yYWdlCkdldFNlcnZpY2UPVGV4dENoYXRTZXJ2aWNlB1BsYXllcnMHcmVxdWlyZQhQYWNrYWdlcwRLbml0BlNpZ25hbAZTaGFyZWQMV2FpdEZvckNoaWxkBEluZm8KQ3VzdG9tRW51bQtMb2NhbFBsYXllchBDcmVhdGVDb250cm9sbGVyBE5hbWUOQ2hhdENvbnRyb2xsZXIABAcBAQAABgMAAAUBBzVNAgD1AAAAAIwDAQCMBAEATC0AAqQBAwAACBCAnwEEAvABCQAEAACApAEHAAAYUIBvAggAnwECAm8CCQAwAgH1AAAAAIIBAgD7AQAATQQAVAsAAABNBATmDAAAAJADBAq8AQFhDQAAAJ8BAwIOARgAbwQOALwCARIPAAAAnwIDAg4CCwCkAhEAAEAQgG8DEgBvBRMATQYBVxQAAABzBAUGnwIDAjACAKEVAAAAggABAKQCEQAAQBCAbwMWAE0EAVcUAAAAnwIDAjACAKEVAAAAggABABcDAQMCAwMEAAgQgAMEAwUDBgQAGFCAAwcDCAIAAAAAAAAAAAMJAwoDCwMMAw0DDgQAQBCAAw8DEAMRAxIDEwATAAEYAAAAAAAAAAAAAAEAAAABAAABAwAAAAAAAAAAAgEAAAAAAQAAAAAAAAAAAAACAAAAAAAAAAMUAAAAAAMBAgAAAAb7AQAAwAIAABICAQAwAgE6AQAAAIIAAQACBgADFAEAERUBGAAAAAAAERMAAAAAAwEBAAAACPsBAABNAQHXAAAAAG8CAQCfAQICMAEASgEAAACCAAEAAgMWAxcAJhgBGAAAAAAAAAABJwAAAAAJAAABAgBAowAAAKQAAQAAAABAbwICALwAABYDAAAAnwADAqQBAQAAAABAbwMEALwBARYDAAAAnwEDAqQCAQAAAABAbwQFALwCAhYDAAAAnwIDAqQDBwAAAGBATQQA5ggAAABNBARxCQAAAJ8DAgKkBAcAAABgQE0FAOYIAAAATQUFHwoAAACfBAICpAUHAAAAYEBvCAsAvAYA0wwAAACfBgMCbwgNALwGBtMMAAAAnwYDAm8IDgC8BgbTDAAAAJ8GAwCfBQACTQYCMQ8AAABNBwMPEAAAAOIIEwCfBwICwAgUABIAAQASAAIAMAgHmRUAAADACBYAEgADADAIB8YXAAAAggcCABgDGQQAAABAAxoDGwMcAx0DHgQAAGBAAx8DIAMhAyIDIwMkAyUDJgMnAygDKQgBERIAAAAGAQMVBgIDGAIBAgEAARgAAAAAAAAAAQAAAAAAAQAAAAAAAgAAAAAAAAEAAAAAAAACAAAAAAAAAAAAAAAAAAACAAIAAAAFAAAAABUAAAAEAQAAAAADicF0QCM415UZJBf0z9zcmvnZYzS7BR5B

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TextChatService = game:GetService("TextChatService")
local Players = game:GetService("Players")
local Knit = require(ReplicatedStorage.Packages.Knit)

require(ReplicatedStorage.Packages.Signal)
require(ReplicatedStorage:WaitForChild("Shared"):WaitForChild("Info"):WaitForChild("CustomEnum"))

local LocalPlayer = Players.LocalPlayer
local v1 = Knit.CreateController({
	Name = "ChatController"
})

function v1.KnitStart(p1) --[[ KnitStart | Line: 17 | Upvalues: TextChatService (copy), Players (copy) ]]
	function TextChatService.OnIncomingMessage(p1) --[[ Line: 19 | Upvalues: Players (ref) ]]
		if string.sub(p1.Text, 1, 1) == "!" then
			local TextChatMessageProperties = Instance.new("TextChatMessageProperties")

			TextChatMessageProperties.Text = " "

			return TextChatMessageProperties
		end

		local v1 = Players:GetPlayerByUserId(p1.TextSource.UserId or 0)

		if not v1 then
			return
		end

		if v1:GetAttribute("VIP") then
			p1.PrefixText = string.format("<font color=\'rgb(255, 200, 0)\'>%s</font>", "[VIP] " .. v1.DisplayName)

			return
		end

		p1.PrefixText = string.format("<font color=\'rgb(180, 180, 180)\'>%s</font>", v1.DisplayName)
	end
end
function v1.KnitInit(p1) --[[ KnitInit | Line: 38 | Upvalues: Knit (copy) ]]
	p1.DataClient = Knit.GetController("DataClient")
end

return v1