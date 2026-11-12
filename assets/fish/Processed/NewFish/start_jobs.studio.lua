--# selene: allow(global_usage, multiple_statements)
local h=game.HttpService
assert(not game:GetService("RunService"):IsRunning(),"Edit mode required")
local manifest=h:JSONDecode(h:GetAsync("http://127.0.0.1:18775/source-manifest.json"))
assert(#h:GetAsync("http://127.0.0.1:18775/drip-surface-points.json")>0,"Drip inputs missing")
assert(#h:GetAsync("http://127.0.0.1:18775/animation-bounds.json")>0,"Animation bounds missing")
local publishFish=assert(loadstring(h:GetAsync("http://127.0.0.1:18775/publish_fish.studio.lua")))()
local publishAnimation=assert(loadstring(h:GetAsync("http://127.0.0.1:18775/publish_animations.studio.lua")))()
local job={done=false,results={},errors={}};_G.NewFishMeshJob=job
local anim={done=false,results={},errors={}};_G.NewFishAnimationJob=anim
local cacheOk,cache=pcall(function()return h:JSONDecode(h:GetAsync("http://127.0.0.1:18775/mesh-cache.json"))end)
if cacheOk then _G.NewFishMeshCache=cache end
local function save(file,data)h:PostAsync("http://127.0.0.1:18775/"..file..".json",h:JSONEncode(data),Enum.HttpContentType.ApplicationJson)end
task.spawn(function()
 local order={26,1,35,36,37,47,6,7,2,10};local seen={}
 for _,i in order do seen[i]=true end
 for i=1,#manifest.fish do if not seen[i] then table.insert(order,i) end end
 for _,i in order do
  local key=manifest.fish[i].exportKey;job.current=key;job.part=0
  local stage=workspace:FindFirstChild("_FishNewFish_Staging");local already=stage and stage:FindFirstChild(manifest.fish[i].name)
  if already then table.insert(job.results,{name=already.Name,key=key,resumed=true});continue end
  local ok,r=xpcall(function()return publishFish(key)end,debug.traceback)
  if ok then table.insert(job.results,r) else table.insert(job.errors,{key=key,error=r})end
  save("mesh-publication",job);task.wait()
 end
 job.done=true;save("mesh-publication",job)
end)
task.spawn(function()
 for _,family in {"standard","dolphin","seahorse","turtle","lobster","fins","jellyfish","longbody","axolotl"} do
  local variant="new_"..family;anim.current=variant
  local library=game.ReplicatedStorage.Animation.Fishing:FindFirstChild("NewFishVariants")
  if library and library:FindFirstChild(variant) then table.insert(anim.results,{variant=variant,resumed=true});continue end
  local ok,r=xpcall(function()return publishAnimation(variant)end,debug.traceback)
  if ok then table.insert(anim.results,r) else table.insert(anim.errors,{variant=variant,error=r})end
  save("animation-publication",anim);task.wait(4)
 end
 anim.done=true;save("animation-publication",anim)
end)
return "Started resumable mesh and animation publication"
