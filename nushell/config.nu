$env.PATH = ($env.PATH | prepend "/opt/homebrew/bin")

mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")
