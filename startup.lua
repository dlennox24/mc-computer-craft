--config
local USER = "dlennox24"
local REPO = "mc-computer-craft"
local BRANCH = "main"

-- The GitHub API URL to list files in the repo
local api_url = "https://api.github.com/repos/"..USER.."/"..REPO.."/git/trees/"..BRANCH.."?recursive=1"

print("Fetching file list from GitHub...")
local response = http.get(api_url)

if not response then
    error("Could not connect to GitHub. Is HTTP enabled in config?")
end

local data = textutils.unserializeJSON(response.readAll())
response.close()

for _, file in ipairs(data.tree) do
    -- 'blob' means it's a file, not a directory
    if file.type == "blob" then
        local raw_url = "https://raw.githubusercontent.com/"..USER.."/"..REPO.."/"..BRANCH.."/"..file.path
        
        print("Downloading: " .. file.path)
        
        local res = http.get(raw_url)
        if res then
            local content = res.readAll()
            res.close()
            
            -- Create folders if they don't exist
            local dir = fs.getDir(file.path)
            if not fs.exists(dir) then fs.makeDir(dir) end
            
            -- Save the file
            local f = fs.open(file.path, "w")
            f.write(content)
            f.close()
        else
            print("Failed to download: " .. file.path)
        end
    end
end

print("Sync Complete!")