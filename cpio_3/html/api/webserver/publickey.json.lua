local n,e = web.getrsakey()

local enc = {}
enc.encpubkeye = e
enc.encpubkeyn = n

sys.print(json.xmlencode(enc))