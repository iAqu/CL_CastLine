-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMbDFRvZ2dsZVNwcmludApBZGRLZXlCaW5kBnRvZ2dsZQtJc1NwcmludGluZwRob2xkCkRhdGFDbGllbnQPRVZfRklSU1RfVVBEQVRFB0Nvbm5lY3QLTG9jYWxQbGF5ZXIVQ2FtZXJhTWF4Wm9vbURpc3RhbmNlCUtuaXRTdGFydApHZXRTZXJ2aWNlDVNwcmludFNlcnZpY2UNR2V0Q29udHJvbGxlcg9Tb3VuZENvbnRyb2xsZXIIS25pdEluaXQEZ2FtZQdQbGF5ZXJzEVJlcGxpY2F0ZWRTdG9yYWdlEFVzZXJJbnB1dFNlcnZpY2UHcmVxdWlyZQhQYWNrYWdlcwRLbml0EENyZWF0ZUNvbnRyb2xsZXIETmFtZRBTcHJpbnRDb250cm9sbGVyBlBsYXllcgAHAgIAAAAAAYIAAQAAABYBARgAFwAAAAABAQAAAAABggABAAAAIgIBGAAjAAAAAAIBAAAAAANNAQDMAAAAAIIBAgABAwMAQQQBGAAAAEIAAAAAAgABAAAABfsAAAC8AADqAAAAAJ8AAgGCAAEAAQMCAEoAARgAAAAAAUsAAAAABAEBAAAAFqkBAAAwAQDMAAAAAKkBAAAwAQAqAQAAAE0BAEoCAAAATQEBhQMAAADZAwAAEgAAALwBAccEAAAAnwEDAfsBAABNAQExBQAAAIwCHgAwAgGkBgAAAIIAAQAHAwMDBQMGAwcDCAMJAwoBA0YLARgAAAABAAACAAAAAAAAAAAEAAAAAAABRwAAAAADAQEAAAAW+wEAAE0BARYAAAAAbwIBAJ8BAgIwAQBvAQAAAPsBAABNAQHXAgAAAG8CAwCfAQICMAEASgMAAAD7AQAATQEB1wIAAABvAgQAnwECAjABANQEAAAAggABAAUDDAMNAw4DBgMPAFEQARgAAAAAAAAAAQAAAAAAAAEAAAAAAAABUgAAAAAHAAABAgAyowAAAKQAAQAAAABAbwICALwAABYDAAAAnwADAqQBAQAAAABAbwMEALwBARYDAAAAnwEDAqQCAQAAAABAbwQFALwCAhYDAAAAnwIDAqQDBwAAAGBATQQB5ggAAABNBARxCQAAAJ8DAgJNBAMPCgAAAOIFDQCfBAICTQUD+Q4AAADABg8AMAYEdRAAAADABhEAMAYE6hIAAADABhMAMAYEoRQAAADABhUAEgAAADAGBJkWAAAAwAYXABIAAwAwBgTGGAAAAIIEAgAZAxEEAAAAQAMSAwwDEwMUAxUEAABgQAMWAxcDGAMZAxoIAQsMAAAAAxsGAAMBBgEDAgYCAwQGBAMLBgUDEAUAAQIEBQEAARgACQAAAAAAAQAAAAAAAQAAAAAAAgAAAAAAAAIAAAAEAAIAAAwAAB8AAAUAAAALAAAABgEAAAAABlOuBTrlYKi7wKlhgthKDsQjthJOYWpvOw==

-- https://lua.expert/
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

game:GetService("UserInputService")

local Knit = require(ReplicatedStorage.Packages.Knit)
local v1 = Knit.CreateController({
	Name = "SprintController"
})
local Player = Knit.Player

function v1.ToggleSprint(p1, p2) --[[ ToggleSprint | Line: 22 ]] end
function v1.AddKeyBind(p1) --[[ AddKeyBind | Line: 34 ]] end
function v1.IsSprinting(p1) --[[ IsSprinting | Line: 65 ]]
	return p1.toggle
end
function v1.KnitStart(p1) --[[ KnitStart | Line: 70 | Upvalues: Players (copy) ]]
	p1.toggle = false
	p1.hold = false
	p1.DataClient.EV_FIRST_UPDATE:Connect(function() --[[ Line: 74 | Upvalues: p1 (copy) ]]
		p1:AddKeyBind()
	end)
	Players.LocalPlayer.CameraMaxZoomDistance = 30
end
function v1.KnitInit(p1) --[[ KnitInit | Line: 81 | Upvalues: Knit (copy) ]]
	p1.SprintService = Knit.GetService("SprintService")
	p1.DataClient = Knit.GetController("DataClient")
	p1.SoundController = Knit.GetController("SoundController")
end

return v1