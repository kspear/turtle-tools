-- Configuration
local github_repo = "kspear/turtle-tools"
local branch = "master"

function spit(filename, data)
    local file = fs.open(filename, "w")
    file.write(data)
    file.close()    
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
    response.close()
    if fs.exists(filename) then
        fs.delete(filename)
    end
    spit(filename, data)
    write("Done\n")
end

-- Bootstrap
function get_dependencies()
    
    local dependencies = {
        {
            name="jsonlua",
            repo="rxi/json.lua",
            branch="master",
            files={
                "json.lua"
            }
        }
    }

    for i1=1,#dependencies do
        local dependency = dependencies[i1]
        print(dependency["name"])
        print(dependency["repo"])
        print(dependency["branch"])
        local files = dependency["files"]
        for i2=1,#dependency["files"] do
            download(
                dependency["repo"],
                dependency["branch"],
                files[i2]
            )
        end
    end
    -- prep for reboot
    download(github_repo, branch, "install.lua")
    fs.move("install.lua", "startup.lua")

    -- create dependency.lock file
    lockfile = fs.open("dependency.lock","w")
    lockfile.flush()
    lockfile.close()
    print("Reboot to continue install in 2 seconds")
    sleep(2)
    os.reboot()
end

function get_manifest()
    print("[Downloading manifest]")
    download(github_repo, branch, "manifest.json")
    json = require("json")
    local raw = slurp("manifest.json")
    return json.decode(raw)
end

function install()
    if fs.exists("dependency.lock") then
        print("dependency.lock file present, continuing")
        fs.delete("dependency.lock")
        fs.move("startup.lua", "install.lua")
    else
        print("dependency.lock file not present, aborting")
        exit()
    end
    local manifest = get_manifest()
    print("[Installing files]")
    for f=1,#manifest do
        download(github_repo, branch, manifest[f])
    end
end

function main()
    -- Get dependencies and reboot; will skip after
    if not (fs.exists("dependency.lock")) then
        get_dependencies()
    else
        install()
    end
end

main()