local M = {}

local ext_mime_map = {
	["sisx"] = "x-epoc/x-sisx-app",
}

local function match_mimetype(s)
	local type, subtype = s:match("([-a-z]+/)([+-.a-zA-Z0-9]+)%s*$")
	if string.find("application/audio/biosig/chemical/font/image/inode/message/model/rinex/text/vector/video/x-epoc/", type, 1, true) then
		return type .. subtype
	end
end

function M:preload()
	local mimes = {}
	local unmatch_ext_urls = {}

	for _, file in ipairs(self.files) do
	  local url = tostring(file.url)

	  local ext = tostring(file.name):match("^.+%.(.+)$")
	  if ext then
		ext = ext:lower()
		local ext_mime = ext_mime_map[ext]
		if ext_mime then
		  mimes[url] = ext_mime
		  goto continue
		end
	  end
	  unmatch_ext_urls[#unmatch_ext_urls + 1] = url
	  ::continue::
	end


	if #unmatch_ext_urls then
	  local command = Command("/home/archerr/.config/yazi/scripts/yazi-file"):stdout(Command.PIPED):stderr(Command.PIPED)

	  local i = 1
	  local mime
	  local output = command:args(unmatch_ext_urls):output()
	  for line in output.stdout:gmatch("[^\r\n]+") do
		if i > #unmatch_ext_urls then
		  break
		end

		mime = match_mimetype(line)

		if mime and string.find(line, mime, 1, true) ~= 1 then
			goto continue
		elseif mime then
			mimes[unmatch_ext_urls[i]] = mime
		i = i + 1
		end
		::continue::
	  end
	end

	if #mimes then
	  ya.manager_emit("update_mimetype", {}, mimes)
	  return 3
	end
	return 2
  end
return M
