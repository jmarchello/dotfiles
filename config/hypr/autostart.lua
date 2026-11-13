-- Extra autostart processes.
-- o.launch_on_start("my-service")

local exec_cmd = hl.exec_cmd
hl.exec_cmd = function(command, ...)
  if type(command) == "string" and command:match("herdr server%s*$") then return end
  return exec_cmd(command, ...)
end

local function first_window_to(class, workspace)
  local rule = hl.window_rule({ match = { class = "^" .. class .. "$" }, workspace = workspace .. " silent" })
  local sub
  sub = hl.on("window.open", function(w)
    if w and w.class == class then
      rule:set_enabled(false)
      sub:remove()
    end
  end)
end

hl.on("hyprland.start", function()
  hl.exec_cmd("google-chrome-stable", { workspace = "1 silent" })
  hl.exec_cmd(os.getenv("HOME") .. "/.local/bin/herdr-app", { workspace = "2 silent" })
  hl.exec_cmd("1password", { workspace = "5 silent", tile = true })

  first_window_to("chrome-ompifgpmddkgmclendfeacglnodjjndh-Default", "3")
  first_window_to("chrome-faolnafnngnfdaknnbpnkhgohbobgegn-Default", "3")
  hl.exec_cmd("sleep 3 && google-chrome-stable --profile-directory=Default --app-id=ompifgpmddkgmclendfeacglnodjjndh")
  hl.exec_cmd("sleep 3 && google-chrome-stable --profile-directory=Default --app-id=faolnafnngnfdaknnbpnkhgohbobgegn")

  hl.exec_cmd("omawrite", { workspace = "4 silent" })

  hl.exec_cmd("python3 -I " .. os.getenv("HOME") .. "/.local/share/herdr-sessions/daemon.py")
end)
