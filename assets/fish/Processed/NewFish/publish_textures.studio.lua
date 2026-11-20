--# selene: allow(global_usage, multiple_statements)
assert(game.PlaceId==84106335829275 and game.CreatorId==598797612,"Wrong place")
local h=game.HttpService
local manifest=h:JSONDecode(h:GetAsync("http://127.0.0.1:18775/texture-manifest.json"))
local job={done=false,results={},errors={}}
_G.NewFishTextureJob=job
local okCache,cache=pcall(function()return h:JSONDecode(h:GetAsync("http://127.0.0.1:18775/texture-publication.json")) end)
if okCache then job.results=cache.results end
local known={}
for _,r in job.results do known[r.key]=true end
local function save()h:PostAsync("http://127.0.0.1:18775/texture-publication.json",h:JSONEncode(job),Enum.HttpContentType.ApplicationJson)end
task.spawn(function()
 for _,spec in manifest.uploads do
  if known[spec.key] then continue end
  job.current=spec.key
  local ok,result=xpcall(function()
   local image=assert(game.AssetService:CreateEditableImage({Size=Vector2.new(spec.width,spec.height)}),"Image allocation failed")
   local success,value=xpcall(function()
    local raw=h:GetAsync("http://127.0.0.1:18775/textures/"..spec.key..".rgba")
    assert(#raw==spec.width*spec.height*4,"Pixel byte count mismatch")
    image:WritePixelsBuffer(Vector2.zero,Vector2.new(spec.width,spec.height),buffer.fromstring(raw))
    for attempt=1,10 do
     local uploaded,status,id=pcall(function()return game.AssetService:CreateAssetAsync(image,Enum.AssetType.Image,{CreatorId=game.CreatorId,CreatorType=Enum.AssetCreatorType.Group,Name="CastLine NewFish "..spec.key,Description="Original fish texture with numeric saturation and contrast grading; UV and alpha preserved."})end)
     if uploaded and status==Enum.CreateAssetResult.Success then return {key=spec.key,id=id,width=spec.width,height=spec.height} end
     local message=tostring(status)..":"..tostring(id)
     assert(message:find("429") or message:find("5%d%d") or message:lower():find("timeout"),message)
     job.waiting={attempt=attempt,error=message};save();task.wait(math.min(60,10*2^(attempt-1)))
    end
    error("Texture retries exhausted")
   end,debug.traceback)
   image:Destroy();assert(success,value);return value
  end,debug.traceback)
  if ok then table.insert(job.results,result) else table.insert(job.errors,{key=spec.key,error=result}) end
  job.waiting=nil;save();task.wait(5)
 end
 job.done=true;save()
end)
return "Publishing 30 graded textures to M101 Crew"
