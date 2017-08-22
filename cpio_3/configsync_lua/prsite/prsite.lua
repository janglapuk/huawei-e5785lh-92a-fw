local objdomin = "InternetGatewayDevice.X_Config.Prsite."

if nil == data then
        print("prsite data error")
        return 
end


if nil ~= data["EnablePriorityBits"] then
local parasEnablePriorityBits = {{"EnablePriorityBits", data["EnablePriorityBits"]}} 
local errcode, paramErrs = dm.SetObjToDB(objdomin,parasEnablePriorityBits)
print("prsite error = "..errcode)
end

if nil ~= data["ResumePriorityBits"] then
local parasResumePriorityBits = {{"ResumePriorityBits", data["ResumePriorityBits"]}}
local errcode, paramErrs = dm.SetObjToDB(objdomin,parasResumePriorityBits)
print("prsite error = "..errcode)
end
  
if nil ~= data["HomePagePrsiteUrl"] then
local parasHomePagePrsiteUrl = {{"HomePagePrsiteUrl", string.sub(data["HomePagePrsiteUrl"],1,255)}}
local errcode, paramErrs = dm.SetObjToDB(objdomin,parasHomePagePrsiteUrl)
print("prsite error = "..errcode)
end

if nil ~= data["multiuser"] then
local parasEnableMultiuser = {{"EnableMultiuser", data["multiuser"]}} 
local errcode, paramErrs = dm.SetObjToDB(objdomin,parasEnableMultiuser)
print("prsite error = "..errcode)
end

return errcode, paramErrs

