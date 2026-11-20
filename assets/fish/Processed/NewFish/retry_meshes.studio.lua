--# selene: allow(global_usage)
local h=game.HttpService
local job=assert(_G.NewFishMeshJob,"Publication job missing")
assert(job.done,"Wait for publication worker")
local pending=job.errors
job.errors={}
job.done=false
local publish=assert(loadstring(h:GetAsync("http://127.0.0.1:18775/publish_fish.studio.lua")))()
task.spawn(function()
 for _,failure in pending do
  job.current=failure.key
  local ok,result=xpcall(function()
   return publish(failure.key)
  end,debug.traceback)
  if ok then
   table.insert(job.results,result)
  else
   table.insert(job.errors,{key=failure.key,error=result})
  end
  h:PostAsync("http://127.0.0.1:18775/mesh-publication.json",h:JSONEncode(job),Enum.HttpContentType.ApplicationJson)
  task.wait()
 end
 job.done=true
 h:PostAsync("http://127.0.0.1:18775/mesh-publication.json",h:JSONEncode(job),Enum.HttpContentType.ApplicationJson)
end)
return "Retrying corrected mesh partitions and shortened asset names"
