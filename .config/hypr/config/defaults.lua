---------------------
---- MY PROGRAMS ----
---------------------

-- General
file_manager = "alacritty -e $SHELL -c 'yazi; $SHELL' & disown"
app_launcher = "rofi -show combi"
window_switcher = "rofi -show window"
terminal = "alacritty"
terminal_preffix = "alacritty -e $SHELL -c '"
terminal_suffix = "; $SHELL'"
terminal_middlefix = "-e $SHELL -c '"
idle_handler = "hypridle"
browser = "zen-browser"
task_manager = "btop"
note_taker = "obsidian"
note_vault = "~/Documents/obsidian/main-vault/"
code_editor = "nvim"
email = "betterbird"
email_suffix = "--headless"
color_picker = "hyprpicker"
emoji_picker = "smile"
background_video_class = "bg"
-- Background_video_title = "[Pp]icture[- ][Ii]n[- ][Pp]icture"
background_video_title = "Picture-in-Picture"
-- Background_video_title = "Picture in picture"
music_player = "youtube-music"

-- # Screenshots
shot_region = "grimblast --freeze --notify --openparentdir copysave area"
shot_window = "grimblast --freeze --notify --openparentdir copysave active"
shot_screen = "grimblast --freeze --notify --openparentdir copysave output"

-- # Commands
sync_obsidian = "rclone bisync --create-empty-src-dirs --compare size,modtime,checksum --slow-hash-sync-only --resilient -MvP --drive-skip-gdocs --fix-case --transfers 16 --checkers 16 "
	.. " google-drive:99-sync-anchor/obsidian/main-vault/ /home/thiago/remote-sync/obsidian/main-vault/"
sync_eclesyart = "rclone bisync --create-empty-src-dirs --compare size,modtime,checksum --slow-hash-sync-only --resilient -MvP --drive-skip-gdocs --fix-case --transfers 16 --checkers 16 "
	.. " google-drive:99-sync-anchor/eclesyart/ /home/thiago/remote-sync/eclesyart/"
sync_game_saves = "rclone bisync --create-empty-src-dirs --compare size,modtime,checksum --slow-hash-sync-only --resilient -MvP --drive-skip-gdocs --fix-case --transfers 16 --checkers 16 "
	.. " google-drive:99-sync-anchor/game-saves/ /home/thiago/remote-sync/game-saves/"
sync_all_remotes = "$sync-game-saves &; $sync-obsidian &; $sync-eclesyart &"

start_docker = "systemctl start docker"
start_mariadb = "systemctl start mariadb"
start_all_services = "$start-docker; $start-mariadb"

-- # docker exec -it frappe_docker-backend-1 bench backup --verbose --with-files --compress && docker container cp frappe_docker-backend-1:/home/frappe/frappe-bench/sites/frontend/private/backups ~/repos/third-party/frappe_docker
-- # docker container exec -it frappe_docker-backend-1 /bin/bash

start_dolibarr = "docker start dolibarr-mariadb-1  dolibarr-web-1"
start_all_docker = "$start-dolibarr"

local function combo(...)
	return table.concat({ ... }, " + ")
end
