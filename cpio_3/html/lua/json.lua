-----------------------------------------------------------------------------
-- Imports and dependencies
-----------------------------------------------------------------------------
local math = require('math')
local string = require("string")
local table = require("table")
local print = print
local xml = require('xml')

local base = _G
local type = base.type

-----------------------------------------------------------------------------
-- Module declaration
-----------------------------------------------------------------------------
module("json")

-- Public functions

-- Private functions
local createXmlNode
local arrayEncode
local multiObjectEncode
local recursiveEncode
local xmlisArray
local xmlisEncodable
local toString

-----------------------------------------------------------------------------
-- PUBLIC FUNCTIONS
-----------------------------------------------------------------------------
--- Encodes an arbitrary Lua object / variable.
-- @param v The Lua object / variable to be XML encoded.
-- @param root The xml root name to be XML encoded.
-- @return String containing the XML encoding in internal Lua string format (i.e. not unicode)
function xmlencode(v, root)
  root = root and root or "response"
  local s = '<?xml version="1.0" encoding="UTF-8"?>'
  -- Handle nil values
  if v==nil then
    return ""
  end
  s = s .. recursiveEncode(root, v, false)
  return s
end

--- Encodes an arbitrary Lua object / variable.
-- @param v The Lua object / variable to be XML encoded.
-- @param root The xml root name to be XML encoded.
-- @return String containing the XML encoding in internal Lua string format (i.e. not unicode)
function xmlencodex(v, root)
  root = root and root or "response"
  local s = '<?xml version="1.0" encoding="UTF-8"?>'
  -- Handle nil values
  if v==nil then
    return ""
  end
  s = s .. recursiveEncode(root, v, true)
  return s
end

--- Decodes a XML string and returns the decoded value as a Lua data structure / value.
-- @param s The string to XML.
-- @return Lua object
function xmldecode(s)
  -- Handle nil values
  if nil == s or '' == s then
    return nil
  end
  return xml.decode(s)
end
-----------------------------------------------------------------------------
-- Internal, PRIVATE functions.
-- Following a Python-like convention, I have prefixed all these 'PRIVATE'
-- functions with an underscore.
-----------------------------------------------------------------------------

--- create xml node
-- @param nodeName The xml node key string.
-- @param nodeValue The xml node value string.
-- @return xml node string.

function xmlencodeString(s)
  --s = string.gsub(s,'\\','\\\\')
  --s = string.gsub(s,'"','\\"')
  --s = string.gsub(s,"'","\\'")
  s = string.gsub(s,'\n','\\n')
  s = string.gsub(s,'\t','\\t')
  s = string.gsub(s,'\r','\\r')
  s = string.gsub(s, "\&", "\&amp;")
  s = string.gsub(s, "\<", "\&lt;")
  s = string.gsub(s, "\>", "\&gt;")
  s = string.gsub(s, "\"", "\&quot;")
  s = string.gsub(s, "\'", "\&#x27;")
  s = string.gsub(s, "\/", "\&#x2F;")
  s = string.gsub(s, "%(", "\&#40;")
  s = string.gsub(s, "%)", "\&#41;")
  --print("encode s"..s)
  return s 
end

function createXmlNode(nodeName, nodeValue)
  return '<' .. nodeName .. '>' .. xmlencodeString(toString(nodeValue)) .. '</' .. nodeName .. '>';
end

function toString(var)
	if base.type(var) == "boolean" then
		if false == var then
			return '0'
		else
			return '1'
		end
	else
		return var
	end
end

---encode Lua Table / Object.
-- Returns XML String encoded.
-- @param obj Lua multi object to be encoded.
-- @param name XML node root name.
function multiObjectEncode(name, obj)
  local s = ''
  s = s .. '<' .. name .. '>'
  if 'table' ~= base.type(obj) then
    s = s .. obj
  else
      for k,v in base.pairs(obj) do
        s = s .. createXmlNode(k,v)
      end
  end
  s = s .. '</' .. name .. '>'
  return s;
end


--- recursive encode Lua Table / Object.
-- Returns XML String encoded.
-- @param obj Lua Array to be encoded
-- @param name XML node root name.
function arrayEncode(name, obj)
  local s = ''
  local subname = string.sub(name, 0, -2)
  s = s .. '<' .. name .. '>'
  for k,v in base.pairs(obj) do
    s = s .. multiObjectEncode(subname, v)
  end
  s = s .. '</' .. name .. '>'
  return s;
end
--- recursive encode Lua Table / Object.
-- Returns XML String encoded.
-- @param obj Lua Array to be encoded
-- @param name XML node root name.
function arrayEncodex(name, obj)
  local s = ''
  for k,v in base.pairs(obj) do
    s = s .. multiObjectEncode(name, v)
  end
  return s;
end


--- recursive encode Lua Table / Object.
-- Returns XML String encoded.
-- @param obj Lua common Table / Object to be encoded.
-- @param name XML node root name.
function recursiveEncode(name,obj,ex)
  local s = ''
  local t = base.type(obj)
    if t=='string' or t=='boolean' or t=='number' then
    s = createXmlNode(name, obj)
  elseif xmlisArray(obj) then
    if ex then 
      s = s .. arrayEncodex(name, obj)
    else
      s = s .. arrayEncode(name, obj)
    end
  elseif type(obj) == 'table' then
    s = s .. '<' .. name .. '>'
    for k, v in base.pairs(obj)do
      s = s .. recursiveEncode(k, v, ex)
    end
    s = s .. '</' .. name .. '>'
  end
  return s;
end


function xmlisArray(t)
  for k,v in base.pairs(t) do
    if (base.type(k)=='number' and 1<=k) then  -- k,v is an indexed pair
      if (not xmlisEncodable(v)) then return false end -- All array elements must be encodable
    else
      if (k=='n') then
        if v ~= table.getn(t) then return false end  -- False if n does not hold the number of elements
      else -- Else of (k=='n')
        if xmlisEncodable(v) then return false end
      end  -- End of (k=='n')
    end -- End of k,v not an indexed pair
  end  -- End of loop across all pairs
  return true
end

function xmlisEncodable(o)
  local t = base.type(o)
  return (t=='string' or t=='number' or t=='table' or t=='boolean') 
end

