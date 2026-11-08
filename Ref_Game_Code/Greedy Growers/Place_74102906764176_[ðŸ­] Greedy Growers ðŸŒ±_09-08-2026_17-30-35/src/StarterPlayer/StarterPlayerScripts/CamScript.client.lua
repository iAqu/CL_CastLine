-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- Bytecode (Base64):
-- CQMLDUNhbWVyYVN1YmplY3QERW51bQpDYW1lcmFUeXBlBkN1c3RvbQRnYW1lB1BsYXllcnMLTG9jYWxQbGF5ZXIJd29ya3NwYWNlDUN1cnJlbnRDYW1lcmEOQ2hhcmFjdGVyQWRkZWQHQ29ubmVjdAACAwEBAAAGAwAABQEHCfsBAAAwAAGcAAAAAPsBAACkAgQAAwgQwDACASoCAAAAggABAAUDAQMCAwMDBAQDCBDAAAUAARgAAAABAAAAAAEGAAAAAAUAAAECABOjAAAApAABAAAAAEBNAABQAgAAAE0AADEDAAAApAEFAAAAQEBNAQFIBgAAAE0CAJcHAAAAwAQIABIAAQC8AgLHCQAAAJ8CAwGCAAEACgMFBAAAAEADBgMHAwgEAABAQAMJAwoGAAMLAQABAAEYAAAAAAAAAAIAAAACAAAAAAAAAwEAAAAAAcLVXuwtxvXBeX99UAQaWSOyzUmY8BE07Q==

-- https://lua.expert/
local LocalPlayer = game.Players.LocalPlayer
local CurrentCamera = workspace.CurrentCamera

LocalPlayer.CharacterAdded:Connect(function(p1) --[[ Line: 5 | Upvalues: CurrentCamera (copy) ]]
	CurrentCamera.CameraSubject = p1
	CurrentCamera.CameraType = Enum.CameraType.Custom
end)