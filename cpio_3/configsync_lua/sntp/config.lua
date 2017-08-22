local utils = require('utils')
local tostring = tostring

local objdomin = "InternetGatewayDevice.Time."
local maps = {
    enable="Enable",     
}

function SetObjParamInputs(domain, data, maps)
    local inputs = {}
    for	k, v in	pairs(maps) do
	local param = {}
		if nil ~= data and nil ~= data[k] then
			param["key"] = v      
			param["value"] = data[k]
			table.insert(inputs, param)
		end
    end
    return inputs
end

local posixTimezone = {}
posixTimezone[0]  = "SDT-14" -- 圣诞岛
posixTimezone[1]  = "NZDT-13" -- 新西兰夏时制
posixTimezone[2]  = "NZST-12" -- 新西兰标准时间
posixTimezone[3]  = "AESST-11" -- 澳大利亚东部标准夏时制 （俄罗斯马加丹时区） 东边（俄罗斯彼得罗巴甫洛夫斯克时区）
posixTimezone[4]  = "AEST-10" -- 澳大利亚东部标准时间
posixTimezone[5]  = "CAST-9:30" -- 中澳大利亚标准时间
posixTimezone[6]  = "JST-9" -- 日本标准时间，（俄罗斯雅库茨克时区）
posixTimezone[7]  = "MT-8:30" -- 平壤
posixTimezone[8]  = "CST-8" -- 中国标准时间（俄罗斯伊尔库茨克时区）
posixTimezone[9]  = "CXT-7" -- 澳大利亚圣诞岛时间
posixTimezone[10]  = "MMT-6:30" -- 缅甸时间
posixTimezone[11]  = "ALMT-6" -- 哈萨克斯坦阿拉木图 时间（俄罗斯鄂木斯克时区）
posixTimezone[12]  = "GMT-5:45" -- 家德满都时间
posixTimezone[13]  = "GMT-5:30" -- 马达拉斯、加尔各答、孟买、新德里时间
posixTimezone[14]  = "MVT-5" -- 马尔代夫时间
posixTimezone[15]  = "AFT-4:30" -- 阿富汗时间
posixTimezone[16]  = "EAST-4" -- 马达加斯加塔那那利佛时间 （俄罗斯萨马拉时区）
posixTimezone[17]  = "IRT-3:30" -- 伊朗时间
posixTimezone[18]  = "EAT-3" -- 科摩罗时间
posixTimezone[19]  = "EET-2" -- 东欧（俄罗斯加里宁格勒时区）
posixTimezone[20]  = "CET-1" -- 中欧时间
posixTimezone[21]  = "GMT+0" -- 格林尼治标准时间
posixTimezone[22]  = "WAT+1" -- 西非时间
posixTimezone[23]  = "FNT+2" -- 巴西费尔南多·迪诺罗尼亚岛时间
posixTimezone[24]  = "BRT+3" -- 巴西利亚时间
posixTimezone[25]  = "NFT+3:30" -- 纽芬兰时间 
posixTimezone[26]  = "AST+4" -- 大西洋标准时间（加拿大）
posixTimezone[27]  = "JLT+4:30" -- 加拉加斯
posixTimezone[28]  = "EST+5" -- 东部标准时间
posixTimezone[29]  = "CST+6" -- 中部标准时间
posixTimezone[30]  = "MST+7" --  山地标准时间
posixTimezone[31]  = "PST+8" -- 太平洋标准时间
posixTimezone[32]  = "AKST+9" -- 阿拉斯加标准时间
posixTimezone[33]  = "CAT+10" -- 中阿拉斯加时间
posixTimezone[34]  = "NTE+11" -- 阿拉斯加诺姆时间（Nome Time）
posixTimezone[35]  = "IDLW+12" -- 国际日期变更线，西边

local gmtTimevalue = {}
gmtTimevalue[0]  = "+14:00" -- 圣诞岛
gmtTimevalue[1]  = "+13:00" -- 新西兰夏时制
gmtTimevalue[2]  = "+12:00" -- 新西兰标准时间
gmtTimevalue[3]  = "+11:00" -- 澳大利亚东部标准夏时制 （俄罗斯马加丹时区） 东边（俄罗斯彼得罗巴甫洛夫斯克时区）
gmtTimevalue[4]  = "+10:00" -- 澳大利亚东部标准时间
gmtTimevalue[5]  = "+09:30" -- 中澳大利亚标准时间
gmtTimevalue[6]  = "+09:00" -- 日本标准时间，（俄罗斯雅库茨克时区）
gmtTimevalue[7]  = "+08:30" -- 平壤
gmtTimevalue[8]  = "+08:00" -- 中国标准时间（俄罗斯伊尔库茨克时区）
gmtTimevalue[9]  = "+07:00" -- 澳大利亚圣诞岛时间
gmtTimevalue[10]  = "+06:30" -- 缅甸时间
gmtTimevalue[11]  = "+06:00" -- 哈萨克斯坦阿拉木图 时间（俄罗斯鄂木斯克时区）
gmtTimevalue[12]  = "+05:45" -- 家德满都时间
gmtTimevalue[13]  = "+05:30" -- 马达拉斯、加尔各答、孟买、新德里时间
gmtTimevalue[14]  = "+05:00" -- 马尔代夫时间
gmtTimevalue[15]  = "+04:30" -- 阿富汗时间
gmtTimevalue[16]  = "+04:00" -- 马达加斯加塔那那利佛时间 （俄罗斯萨马拉时区）
gmtTimevalue[17]  = "+03:30" -- 伊朗时间
gmtTimevalue[18]  = "+03:00" -- 科摩罗时间
gmtTimevalue[19]  = "+02:00" -- 东欧（俄罗斯加里宁格勒时区）
gmtTimevalue[20]  = "+01:00" -- 中欧时间        
gmtTimevalue[21]  = "+00:00" -- 格林尼治标准时间
gmtTimevalue[22]  = "-01:00" -- 西非时间             
gmtTimevalue[23]  = "-02:00" -- 巴西费尔南多·迪诺罗尼亚岛时间             
gmtTimevalue[24]  = "-03:00" -- 巴西利亚时间   
gmtTimevalue[25]  = "-03:30" -- 纽芬兰时间     
gmtTimevalue[26]  = "-04:00" -- 大西洋标准时间（加拿大） 
gmtTimevalue[27]  = "-04:30" -- 加拉加斯            
gmtTimevalue[28]  = "-05:00" -- 东部标准时间             
gmtTimevalue[29]  = "-06:00" -- 中部标准时间             
gmtTimevalue[30]  = "-07:00" --  山地标准时间             
gmtTimevalue[31]  = "-08:00" -- 太平洋标准时间             
gmtTimevalue[32]  = "-09:00" -- 阿拉斯加标准时间             
gmtTimevalue[33]  = "-10:00" -- 中阿拉斯加时间             
gmtTimevalue[34]  = "-11:00" -- 阿拉斯加诺姆时间（Nome Time）             
gmtTimevalue[35]  = "-12:00" -- 国际日期变更线，西边
  

function getLocalTimeZone()
    -- body
    local timevalue  = string.sub(data["timezone"]["timezone"], 4)
	
	print("sntp timevalue = ", timevalue)
	
     for i=0, 35 do
        if gmtTimevalue[i] == timevalue then
			print("sntp gmtTimevalue i = ", i)
            return i
        end
    end
end

function getKeyTimezone()
    -- body
	if data["timezone"] == nil or data["timezone"]["timezone"] == nil then
		return ""
	end
	if data["timezone"]["timezone"] == "" then
		return ""
	end

	local keyTimezone = getLocalTimeZone()
    print("sntp keyTimezone = ", keyTimezone)
    return posixTimezone[keyTimezone]
end

local SntpSuccessIntervalValue = 1
if nil ~= data["updateintervals"] and nil ~= data["updateintervals"]["sntpupdateintervals"] then
	if data["updateintervals"]["sntpupdateintervals"] == "" then
		SntpSuccessIntervalValue = 0
	else
		SntpSuccessIntervalValue = data["updateintervals"]["sntpupdateintervals"]
	end
end

local SntpFailIntervalValue = 1
if nil ~= data["swinterval"] and nil ~= data["swinterval"]["sntpfailedinterval"] then
	if data["swinterval"]["sntpfailedinterval"] == "" then
		SntpFailIntervalValue = 0
	else
		SntpFailIntervalValue = data["swinterval"]["sntpfailedinterval"]
	end
end

local timezoneidx = 0
if nil ~= data["timezone"] and nil ~= data["timezone"]["timezoneidx"] then
	if data["timezone"]["timezoneidx"] == "" then
		timezoneidx = 0
	else
		timezoneidx = data["timezone"]["timezoneidx"]
	end
end

local cityValue = ""
if nil ~= data["timeset"] and nil ~= data["timeset"]["setcity"] then
	if data["timeset"]["setcity"] == "" then
		cityValue = ""
	else
		cityValue = data["timeset"]["setcity"]
	end
end

function sntpsucctime()	
print("set sntp sntpsucctime com in") 		  
    local map = {	
					{"X_RefreshInterval", SntpSuccessIntervalValue},		
				}				  
	local errcode, param = dm.SetObjToDB(objdomin,map)
	if 0 ~= errcode then  
	    print("sntpsucctime error = ", errcode)
	end			
end 

function sntpfailtime()
print("set sntpfailtime com in") 		  
    local map = {
                    {"X_SntpFailInterval", SntpFailIntervalValue},
				}				  
	local errcode, param = dm.SetObjToDB(objdomin,map)
	if 0 ~= errcode then  
	    print("set sntpfailtime error = ", errcode)
	end		
end

function sntpcity()
print("set sntp sntpcity com in") 		  
    local map = {
                    {"X_TimeManualSetCity", cityValue},
				}				  
	local errcode, param = dm.SetObjToDB(objdomin,map)
	if 0 ~= errcode then  
	    print("SetCity error = ", errcode)
	end		
end

function sntpmanu()
print("set sntp sntpmanu com in") 
if nil ~= data["timeset"] then				  
    local map = {  
                    timesetswitch = "X_TimeManualSetEnable",
                    setzone = "X_TimeManualSetZone"
				}				  

	local timemanual = SetObjParamInputs(objdomin,data["timeset"],map)	
	local errcode, param = dm.SetObjToDB(objdomin,timemanual)
	if 0 ~= errcode then  
	    print("timemanual error = ", errcode)
	end		
end	
end


function sntpswitchs()
print("set sntp sntpswitchs com in") 
if nil ~= data["switch"] then				  
    local map = {
                    sntpswitch = "Enable",
                    timediffswitch = "X_TimeDiffCalcEnable"
				}				  

	local switchs = SetObjParamInputs(objdomin,data["switch"],map)	
	local errcode, param = dm.SetObjToDB(objdomin,switchs)
	if 0 ~= errcode then  
	    print("switchs error = ", errcode)
	end		
end	  
end

function sntptimezone()
print("set sntp sntptimezone com in") 		  
    local map = {
                    {"LocalTimeZoneName", getKeyTimezone()},
				}				  
	local errcode, param = dm.SetObjToDB(objdomin,map)
	if 0 ~= errcode then  
	    print("tzone error = ", errcode)
	end		
end


function sntptimezoneidx()
print("set sntp sntptimezoneidx com in") 			  
    local map = {
                    {"X_Label",timezoneidx},
				}				  	
	local errcode, param = dm.SetObjToDB(objdomin,map)
	if 0 ~= errcode then  
	    print("tzoneidx error = ", errcode)
	end			
end

function sntpservers() 
print("set sntp sntpservers com in") 
 if nil ~= data["server"] then
     local map = {
                    sntpserveraddress0 = "NTPServer1",
                    sntpserveraddress1 = "NTPServer2",
                    sntpserveraddress2 = "NTPServer3",
                    sntpserveraddress3 = "NTPServer4",
                    sntpserveraddress4 = "NTPServer5"
				 }		
 	local sntpserver = SetObjParamInputs(objdomin,data["server"],map)	
	local errcode, param = dm.SetObjToDB(objdomin,sntpserver)
	if 0 ~= errcode then  
	    print("sntpserver error = ", errcode)
	end		
 end	  
end   
   
   
function displaytime() 
print("set sntp displaytime com in")  
if nil ~= data then				  
    local dstvalue = {
                        timeserverdisplay_enable = "X_TimeServerDisplay_Enabled",
                        sntpdisplay_enable = "X_SntpDisplay_Enabled",
                        dstdisplay_enable = "X_DstDisplay_Enabled",
			timemanualsetdisplay_enable = "X_TimeManualSetDisplay_Enabled"
				     }				  

	local display = SetObjParamInputs(objdomin,data,dstvalue)	
	local errcode, param = dm.SetObjToDB(objdomin,display)
	if 0 ~= errcode then  
	    print("display error = ", errcode)
	end		
end	
end

 displaytime() 			  
 sntpservers() 
 sntptimezoneidx()
 sntpswitchs()
 sntpmanu()
 sntpfailtime()
 sntpcity()
 sntptimezone()
 sntpsucctime()


