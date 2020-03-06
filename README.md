```ascii
                 ▄▄               ▄
                ██             ▄▄ █ ▄▄
               ██               █████
 ▄███▄▄▄█     ██               ▀▀ █ ▀▀
 ▀   ▀▀▀     ▄█▀                  ▀
            ▄█▀         ██
           ▄█▀          ▀▀
```

Dotfiles
========

## Dependencies
* GNU Stow
* exa

```bash
# Create symlinks in $HOME
make stow

# Remove symlinks
make unstow
```

You can override the stow target by passing `-e TARGET=/tmp/some/path` to the make command
```bash
make -e TARGET=/home/foousr install
```
