---------------------
---- MY PROGRAMS ----
---------------------

MainMod = "SUPER" -- Sets "Windows" key as main modifier

-- General
File_manager = "alacritty -e $SHELL -c 'yazi; $SHELL' & disown"
App_launcher = "rofi -show combi"
Window_switcher = "rofi -show window"
Terminal = "alacritty"
Terminal_preffix = "alacritty -e $SHELL -c '"
Terminal_suffix = "; $SHELL'"
Terminal_middlefix = "-e $SHELL -c '"
Idle_handler = "hypridle"
Browser = "zen-browser"
Task_manager = "btop"
Note_taker = "obsidian"
Note_vault = "~/Documents/obsidian/main-vault/"
Code_editor = "nvim"
Email = "betterbird"
Email_suffix = "--headless"
Color_picker = "hyprpicker"
Emoji_picker = "smile"
Background_video_class = "bg"
-- Background_video_title = "[Pp]icture[- ][Ii]n[- ][Pp]icture"
Background_video_title = "Picture-in-Picture"
-- Background_video_title = "Picture in picture"
Music_player = "youtube-music"

-- Screenshots
Shot_region = "grimblast --freeze --notify --openparentdir copysave area"
Shot_window = "grimblast --freeze --notify --openparentdir copysave active"
Shot_screen = "grimblast --freeze --notify --openparentdir copysave output"

-- Commands
Sync_obsidian = "rclone bisync --create-empty-src-dirs --compare size,modtime,checksum --slow-hash-sync-only --resilient -MvP --drive-skip-gdocs --fix-case --transfers 16 --checkers 16 "
	.. " google-drive:99-sync-anchor/obsidian/main-vault/ /home/thiago/remote-sync/obsidian/main-vault/"
Sync_eclesyart = "rclone bisync --create-empty-src-dirs --compare size,modtime,checksum --slow-hash-sync-only --resilient -MvP --drive-skip-gdocs --fix-case --transfers 16 --checkers 16 "
	.. " google-drive:99-sync-anchor/eclesyart/ /home/thiago/remote-sync/eclesyart/"
Sync_game_saves = "rclone bisync --create-empty-src-dirs --compare size,modtime,checksum --slow-hash-sync-only --resilient -MvP --drive-skip-gdocs --fix-case --transfers 16 --checkers 16 "
	.. " google-drive:99-sync-anchor/game-saves/ /home/thiago/remote-sync/game-saves/"
Sync_all_remotes = "$sync-game-saves &; $sync-obsidian &; $sync-eclesyart &"

Start_docker = "systemctl start docker"
Start_mariadb = "systemctl start mariadb"
Start_all_services = "$start-docker; $start-mariadb"

-- docker exec -it frappe_docker-backend-1 bench backup --verbose --with-files --compress && docker container cp frappe_docker-backend-1:/home/frappe/frappe-bench/sites/frontend/private/backups ~/repos/third-party/frappe_docker
-- docker container exec -it frappe_docker-backend-1 /bin/bash

Start_dolibarr = "docker start dolibarr-mariadb-1  dolibarr-web-1"
Start_all_docker = "$start-dolibarr"
Wob_path = "/tmp/" .. os.getenv("HYPRLAND_INSTANCE_SIGNATURE") .. ".wob"
