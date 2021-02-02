-- Install
local github_repo = "kspear/turtle-tools"
local branch = "master"
local manifest = {
    "main.lua",
    "inventory.lua"
}

function download(filename)
    local url = "http://raw.githubusercontent.com/"..github_repo.."/"..branch.."/"..filename 
    local response = http.get(url)
    print(filename.." ... ")
    local data = response.readAll()
    local file = fs.open(filename, "w")
    file.write(data)
    file.close()    
    response.close()
    write("Done\n")
end

print("Installing files")
for f=1,#manifest do
    download(manifest[f])
end