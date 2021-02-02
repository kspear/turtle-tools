-- Configuration
local github_repo = "kspear/turtle-tools"
local branch = "master"

local dependencies = {
    {
        name="jsonlua",
        repo="rxi/json.lua",
        files={
            "json.lua"
        }
    }
}

function spit(filename, data)
    local file = fs.open(filename, "w")
    file.write(data)
    file.close()    
    response.close()
end

function slurp(filename)
    local file = fs.open(filename, "r")
    local data = file.readAll()
    file.close()
    return data
end

function download(repo, branch, filename)
    local url = "http://raw.githubusercontent.com/"..repo.."/"..branch.."/"..filename 
    local response = http.get(url)
    local filename = filename
    write(filename.." ... ")
    local data = response.readAll()
    if fs.exists(filename) then
        fs.delete(filename)
    end
    spit(filename, data)
    write("Done\n")
end

-- Bootstrap
function dependency()
    for i1=1,#dependencies do
        local dependency = dependencies[i1]
        print(dependency["name"])
        local files = dependency["files"]
        for i2=1,#dependency["files"] do
            download(
                dependency["repo"],
                dependency["branch"],
                files[i2]
            )
        end
    end
end

-- Install
-- local manifest = {
--     "main.lua",
--     "inventory.lua",
--     "startup.lua"
-- }

function manifest()
    print("[Downloading manifest]")
    download(github_repo, branch, "manifest.json")
    json = require("json")
    local raw = slurp("manifest.json")
    return json.decode(raw)
end

function install()
    local manifest = manifest()
    print("[Installing files]")
    for f=1,#manifest do
        download(github_repo, branch, manifest[f])
    end
end

function main()
    dependency()
    install()
    print("[Installation Complete]")
end

main()