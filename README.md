### badbr0ker
> **Note:** [badsh1mmer](https://github.com/crosbreaker/badsh1mmer) has this, as well as many other utilities. It is advised to go use that.
# Support
If you need any kind of support, please join our [discord server](https://discord.gg/nrMVY29MUb) for help
### If you would like the script to do everything for you:
```bash
git clone https://github.com/crosbreaker/badbr0ker
cd badbr0ker
bash buildfull_badbr0ker.sh <board>
```
### If you would like to use a local recovery image:
```bash
git clone https://github.com/crosbreaker/badbr0ker
cd badbr0ker
bash update_downloader.sh <board>
sudo ./build_badrecovery.sh -i image.bin -t unverified
```
### What is this?
badbr0ker is br0ker injected into badrecovery unverified, allowing for unenrollment on keyrolled kv5 ChromeOS devices.
### If you are on a [BadApple](https://github.com/applefritter-inc/BadApple) vulnernable device
Simply run the following in the shell, while connected to wifi:
```bash
curl -LO https://ba.crosbreaker.dev/br0ker.sh && sh br0ker.sh
```
### How do I make a usb?
Download a prebuilt from the [prebuilts section](#prebuilts), or build an image yourself with the above commands.  Flash it using the [Chromebook Recovery Utility](https://chromewebstore.google.com/detail/chromebook-recovery-utili/pocpnlppkickgojjlmhdmidojbmbodfm), or anything else that etches disk images to USB drives. Such as [balenaEtcher](https://etcher.balena.io/), [dd](https://wiki.archlinux.org/title/Dd) or [rufus](https://rufus.ie/en/)
### I have a usb, what now?
Complete [sh1ttyOOBE](https://github.com/crosbreaker/sh1ttyOOBE), then enter developer mode and recover to your usb
### Prebuilts

[GitHub actions](https://nightly.link/crosbreaker/badbr0ker/actions/runs/19093185999)
### Credits:
[HarryTarryJarry](https://github.com/HarryTarryJarry) - All badbr0ker development 

[BinBashBanana](https://github.com/binbashbanana) - original br0ker, badrecovery

[Lxrd](https://github.com/SPIRAME) - Sh1ttyOOBE

[Crossjbly](https://github.com/crossjbly) - Fixing a few things

[codenerd](https://github.com/codenerd87) - adding more board support (everything but nissa, dedede and corsola)
