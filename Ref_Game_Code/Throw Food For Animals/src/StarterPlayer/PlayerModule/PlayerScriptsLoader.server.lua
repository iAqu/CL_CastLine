-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert

if require(script.Parent:WaitForChild("CommonUtils")).get("FlagUtil").getUserFlag("UserControlModuleEnabledAPI") then
    require(script.Parent:WaitForChild("PlayerModuleInternal")).new():start()
else
    require(script.Parent)
end
