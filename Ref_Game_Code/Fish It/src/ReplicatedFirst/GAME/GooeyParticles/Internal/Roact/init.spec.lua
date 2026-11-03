-- Saved by UniversalSynSaveInstance (Join to Copy Games) https://discord.gg/wx4ThpAsmw

-- https://lua.expert/
return function() --[[ Line: 1 ]]
	local v1 = require(script.Parent)
	it("should load with all public APIs", function() --[[ Line: 4 | Upvalues: v1 (copy) ]]
		local tbl = {
			createElement = "function",
			createFragment = "function",
			createRef = "function",
			forwardRef = "function",
			createBinding = "function",
			joinBindings = "function",
			mount = "function",
			unmount = "function",
			update = "function",
			oneChild = "function",
			setGlobalConfig = "function",
			createContext = "function",
			reify = "function",
			teardown = "function",
			reconcile = "function",
			Component = true,
			PureComponent = true,
			Portal = true,
			Children = true,
			Event = true,
			Change = true,
			Ref = true,
			None = true,
			UNSTABLE = true
		}
		expect(v1).to.be.ok()
		for k, v in pairs(tbl) do
			local v12
			v12 = if typeof(v) == "string" then typeof(v1[k]) == v elseif v1[k] == nil then false else true
			if not v12 then
				local v3 = if typeof(v) == "boolean" then "present" else "of type " .. v
				error((("Expected public API member %q to be %s, but instead it was of type %s"):format(tostring(k), v3, (typeof(v1[k])))))
			end
		end
		for k in pairs(v1) do
			if tbl[k] == nil then
				error((("Found unknown public API key %q!"):format((tostring(k)))))
			end
		end
	end)
end