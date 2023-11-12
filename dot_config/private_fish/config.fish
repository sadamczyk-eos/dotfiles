if status is-interactive
    # General abbreviations
    abbr -a -- cm chezmoi
    abbr -a -- conf cd ~/.config/
    abbr -a -- diff delta
    abbr -a -- e hx
    abbr -a -- g git
    abbr -a -- gs git status -sb
    abbr -a -- lg lazygit
    abbr -a -- vi nvim
    abbr -a -- vim nvim

    ## Docker
    abbr -a -- d docker
    abbr -a -- dc docker compose
    abbr -a -- dcb 'docker compose build'
    abbr -a -- dcd 'docker compose down'
    abbr -a -- dcu 'docker compose up -d'
    abbr -a -- dcub 'docker compose up --build -d'
    abbr -a -- dps 'docker ps'

    # Color theme
    fish_config theme choose Bay\ Cruise

    # Exports
    # -i for smartcase search, -R for color, -x4 for tabs = 4 spaces
    set -gx LESS "-iRx4"
end

export EDITOR="hx"
export PATH="$HOME/.scripts:/usr/local/bin:$PATH"
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# https://rsteube.github.io/carapace-bin/setup.html
mkdir -p ~/.config/fish/completions
carapace --list | awk '{print $1}' | xargs -I{} touch ~/.config/fish/completions/{}.fish # disable auto-loaded completions (#185)
carapace _carapace | source

# https://starship.rs/
starship init fish | source

# Load additional config not tracked by chezmoi
test -e ~/.config/fish/local_config.fish && source ~/.config/fish/local_config.fish

