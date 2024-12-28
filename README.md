# Personal dotfiles

## Installation

### Nobara

First, run a fix for my older GTX 1070, see https://wiki.nobaraproject.org/graphics/nvidia/supported-gpus

```sh
sudo sed -i -e 's/kernel-open$/kernel/g' /etc/nvidia/kernel.conf
sudo akmods --rebuild
sudo dracut -f
reboot
```

After the reboot continue with the chezmoi initialization as usual.

### Initialize chezmoi

Run this command.
Will require some user action/authentication at the start and the very end
of the installation scripts, but should otherwise run non-interactively.

```sh
sh -c "$(curl -fsLS get.chezmoi.io/lb)" -- init --purge-binary --apply sadamczyk
```
