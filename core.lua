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

-- bootstrap
-- Detect current tt install state, with 4 possible scenarios:
-- - First install (i.e. pastebin script pulled this file, renamed it startup.lua and rebooted)
-- - First install reboot (i.e. this script ran once to do first part of installation, so second part of installation required)
-- - Post-install reboot (i.e. after installation, any subsequent reboot)
-- - Post-install update

-- Also important to account for: this program may be installed to a system with a disk
-- If a disk is present, the user should be prompted to select where to install (disk, system or both)
-- If started from a disk, and already installed on that disk, but not on the host, prompt to copy (install)

-- local run_from_disk = (
--     local script_file = shell.getRunningProgram()
--     local drive = 
--     drive ~= "hdd"
-- )

local run_from_disk = "no"

if fs.getDir(shell.getRunningProgram()) ~= "hdd" then
    run_from_disk = "yes"
end

print("Run from disk? "..run_from_disk)
