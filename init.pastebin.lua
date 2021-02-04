-- Configuration
local filename = "core.lua"
local url = "http://raw.githubusercontent.com/kspear/turtle-tools/HEAD/" .. filename

-- Download
if fs.exists(filename) then
    fs.delete(filename)
end

local response = http.get(url)
local data = response.readAll()
local file = fs.open(filename, "w")
file.write(data)
file.close()
response.close()

shell.run(filename)
