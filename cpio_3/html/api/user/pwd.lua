local utils = require('utils')
local web = require('web')
local response = {}

if nil == data or nil == data['module'] or nil == data['nonce'] then
	print("bad para")
	return
end

local ret,pwd,hash,iter = web.pwd(data['module'], data['nonce'])
if nil == pwd or nil == hash  or nil == iter then
	print("bad result")
end
utils.appendErrorItem('pwd', pwd)
utils.appendErrorItem('hash', hash)
utils.appendErrorItem('iter', iter)
