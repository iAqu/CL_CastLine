--# selene: allow(global_usage)
local http = game:GetService("HttpService")
local base = "http://127.0.0.1:18776/"
local install = assert(loadstring(http:GetAsync(base .. "install_surface_bindings.studio.lua")))
local job = { done = false, prepared = 0, errors = {} }
_G.RigV2SurfaceWorker = job
task.spawn(function()
	local visited = {}
	while true do
		local audit = _G.RigV2Audit
		for name in audit.results do
			if name == "HaiGui_01_00" or visited[name] then
				continue
			end
			visited[name] = true
			job.current = name
			local ok, result = pcall(install, { [name] = true })
			if ok and result.fish == 1 and result.points == 24 then
				job.prepared += 1
			else
				job.errors[name] = if ok then result.errors[name] else tostring(result)
			end
		end
		http:PostAsync(
			base .. "surface-progress-final.json",
			http:JSONEncode(job),
			Enum.HttpContentType.ApplicationJson
		)
		if audit.done then
			break
		end
		task.wait(3)
	end
	job.done = true
	http:PostAsync(base .. "surface-progress-final.json", http:JSONEncode(job), Enum.HttpContentType.ApplicationJson)
end)
return "Started matching staged fish drip points to their published mesh weights"
