-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMoBUxldmVsDEdldEF0dHJpYnV0ZQR0YXNrBHdhaXQJTmFtZUxhYmVsA0x2LgMgfCALRGlzcGxheU5hbWUEVGV4dAp1cGRhdGVOYW1lB0Rlc3Ryb3kLUHJpbWFyeVBhcnQEZ2FtZQdQbGF5ZXJzFkdldFBsYXllckZyb21DaGFyYWN0ZXIDbmV3BUNsb25lBlBhcmVudAdBZG9ybmVlB0VuYWJsZWQZR2V0QXR0cmlidXRlQ2hhbmdlZFNpZ25hbAdDb25uZWN0CEdpdmVUYXNrD1BsYXllckNoYXJhY3RlcgZMaXN0ZW4IRGVmZXJyZWQHcmVxdWlyZRFSZXBsaWNhdGVkU3RvcmFnZQhQYWNrYWdlcwRNYWlkBkNsaWVudAdNb2R1bGVzB1V0aWxpdHkRTG9hZERlbG9hZE1hbmFnZXILTG9jYWxQbGF5ZXIJUGxheWVyR3VpBkFzc2V0cwxXYWl0Rm9yQ2hpbGQJQmlsYm9hcmRzB05hbWV0YWcABQcAAgAAAB77AAAAbwIAALwAABIBAAAAnwADAisACwCkAQQAAAwggG8CBQCfAQIB+wEAAG8DAAC8AQESAQAAAJ8BAwJSAAEASAD0//sBAQBNAQFEBgAAAG8DBwBSBAAAbwUIAPsGAABNBgZXCQAAAHMCAwYwAgH1CgAAAIIAAQALAwEDAgMDAwQEAAwggAIAAAAAAADgPwMFAwYDBwMIAwkAJAoBGAAAAAAAAQEAAAABAAAAAAD+BgAAAAAAAAAAAAAAAiUAAAAAAgABAAAAB/sAAAAOAAQA+wAAALwAAFAAAAAAnwACAYIAAQABAwsANAABGAAAAAAAAAE1AAAAAAsBAwAABgMAAAUBBzRNAQCbAAAAACsBAQCCAAEApAICAAAAEEBNAgJQAwAAAFIEAAC8AgKJBAAAAJ8CAwIrAgEAggABAPsDAABNAwPvBQAAAJ8DAQL7BAEAvAQEOgYAAACfBAIC+wUCADAFBCQHAAAAMAEEFAgAAACpBQEAMAUE8AkAAADZBQAAEgACABIABABSBgUAnwYBAW8KCgC8CAIWCwAAAJ8IAwJSCgUAvAgIxwwAAACfCAMAvAYD/Q0AAACfBgAB2QgBABIABAC8BgP9DQAAAJ8GAwGCAwIADgMMAw0EAAAQQAMOAw8DEAMRAxIDEwMUAwEDFQMWAxcCAAEUAAEYAAABAAMAAAAAAAAAAQACAAAAAgAAAAEAAAEAAQAAAwAADAACAAAAAAAAAAAAAAIAAAAABBUAAAAABwEEAAAADPsBAABvAwAAxgQAAMYFAADABgEAEgIBABICAgASAgMAvAEBpwIAAACfAQYBggABAAMDGAYCAxkBAhMaARgAAAAAAAAAAAAAACYUAAAAAAgAAAECAD2jAAAA/wABAAAAAACkAQEAAAAAQKQCAwAAACBATQICPwQAAABNAgLmBQAAAE0CAnYGAAAAnwECAqQCAQAAAABApAMDAAAAIEBNAwM/BAAAAE0DA00HAAAATQMD6AgAAABNAwMPCQAAAE0DAx0KAAAAnwICAqQDAwAAACBATQMDUAsAAABNAwMxDAAAAE0EA5kNAAAApAUDAAAAIEBNBQU/BAAAAG8HDgC8BQXTDwAAAJ8FAwJvBxAAvAUF0w8AAACfBQMCbwcRALwFBdMPAAAAnwUDAsAGEgASAAIAEgABABIABQASAAQAMAYA7hMAAACCAAIAFAMbBAAAAEADDQQAACBAAxwDHQMeAx8DIAMhAyIDDgMjAyQDJQMmAycDKAYDAxoBAwEAARgACAACAAAAAAAAAAAAAAEAAAAAAAAAAAAAAAAAAAIAAAAAAAEAAgAAAAAAAAAAAAAAAAAAAAIAAAAAAAAqAQAAAAAEzhkYZ6cJWJXTw0bff8v8ur4BDxP83XJm

-- https://lua.expert/
local t = {}
local Maid = require(game.ReplicatedStorage.Packages.Maid)
local LoadDeloadManager = require(game.ReplicatedStorage.Client.Modules.Utility.LoadDeloadManager)
local PlayerGui = game.Players.LocalPlayer.PlayerGui
local Nametag = game.ReplicatedStorage:WaitForChild("Assets"):WaitForChild("Bilboards"):WaitForChild("Nametag")

function t.Deferred(p1) --[[ Deferred | Line: 19 | Upvalues: LoadDeloadManager (copy), Maid (copy), Nametag (copy), PlayerGui (copy) ]]
	LoadDeloadManager:Listen("PlayerCharacter", nil, nil, function(p1) --[[ Line: 20 | Upvalues: Maid (ref), Nametag (ref), PlayerGui (ref) ]]
		local PrimaryPart = p1.PrimaryPart

		if not PrimaryPart then
			return
		end

		local v1 = game.Players:GetPlayerFromCharacter(p1)

		if v1 then
			local v2 = Maid.new()
			local v3 = Nametag:Clone()

			v3.Parent = PlayerGui
			v3.Adornee = PrimaryPart
			v3.Enabled = true

			local function updateName() --[[ updateName | Line: 36 | Upvalues: v1 (copy), v3 (copy) ]]
				local v12 = v1:GetAttribute("Level")

				while not v12 do
					task.wait(0.5)
					v12 = v1:GetAttribute("Level")
				end

				v3.NameLabel.Text = "Lv." .. v12 .. " | " .. v1.DisplayName
			end

			updateName()
			v2:GiveTask(v1:GetAttributeChangedSignal("Level"):Connect(updateName))
			v2:GiveTask(function() --[[ Line: 52 | Upvalues: v3 (copy) ]]
				if not v3 then
					return
				end

				v3:Destroy()
			end)

			return v2
		end
	end)
end

return t