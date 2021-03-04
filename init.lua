-- TurtleTools (tt) entrypoint
-- Provides useful core functions, and, chiefly, bootstraps tt installation/updates

-- Core functions

-- spit
-- given a filename and a string, write to that file
function spit(filename, data, mode)
    mode = mode or "w"
    local file = fs.open(filename, mode)
    file.write(data)
    file.close()
end

function slurp(filename)
    local file = fs.open(filename, "r")
    local data = file.readAll()
    file.close()
    return data
end

function github_download_raw(repo, branch, filename)
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

function log(message)
    print("[" .. message .. "]")
end


-- function count_disks()
--     local sides = {"top", "bottom", "left", "right", "front", "back"}
--     local total = 0

--     for i=1,#sides do
--         local side = sides[i]
--         if disk.isPresent(side) and disk.hasData(side) then
--             total = total + 1
--         end
--     end

--     return total
-- end


-- local script = shell.getRunningProgram()
-- print("Script is "..script)

-- local run_from_disk = "no"
-- if (count_disks() == 1) and (fs.getDir(script) == "disk") then
--     run_from_disk = "yes"
-- else
--     run_from_disk = "no"
-- end

-- print("Run from disk? "..run_from_disk)

local repo = {
    name = "kspear/turtle-tools",
    ref = "HEAD"
}

function get_manifest()
    log("Downloading manifest")
    github_download_raw(repo["name"], repo["ref"], "manifest.json")
    local raw = slurp("manifest.json")
    return textutils.unserializeJSON(raw)
end

function install(path, force)
    local path = path or ""
    local force = force or false
    local manifest = get_manifest()

    local install_path = path .. "/tt"
    
    if fs.isDir(install_path) then
        log("Install path (".. install_path ..") already exists.")
        if force == true then
            log("Overwriting")
            fs.delete(install_path)
        else
            log("force not set, aborting installation")
            exit()
        end
    end

    fs.makeDir(install_path)
    log("Installing to ".. install_path)

    shell.setDir(install_path)

    for f=1,#manifest do
        local filename = manifest[f]
        local file_path = install_path .. "/" .. filename
        github_download_raw(repo["name"], repo["ref"], filename)
    end

    -- Install startup
    if fs.exists(path.."/startup.lua") then
        fs.delete(path.."/startup.lua")
    end

    fs.copy(install_path.."/startup.lua", path.."/startup.lua")
    fs.delete(path.."/install.lua")

    log("Installation to "..install_path.." finished.")
    os.reboot()
end

function init()
    if not fs.isDir("/tt") then
        install("", true)
    else
        require("tt/main")
        main.startup("it works!")
    end
end

init()