-- Configuration
local filename = "core.lua"
local url = "http://raw.githubusercontent.com/kspear/turtle-tools/master/" .. filename

-- Download
if fs.exists(filename) then
    fs.delete(filename)
end

local response = http.get(url)
local data = response.readAll()
response.close()
local file = fs.open(filename, mode)
file.write(data)
file.close()
shell.run(filename)
