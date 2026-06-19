$env.PATH = ($env.PATH | prepend "/opt/homebrew/bin")
$env.config.show_banner = false
$env.NVM_DIR = $"($env.HOME)/.nvm"

mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")

