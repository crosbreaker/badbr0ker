### badbr0ker
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
### I have a usb, what now?
Complete [sh1ttyOOBE](https://github.com/crosbreaker/sh1ttyOOBE), then enter developer mode and recover to your usb
### [PREBUILTS](https://dl.fanqyxl.net/Crosbreaker/badbr0ker)
### Credits:
[BinBashBanana](https://github.com/binbashbanana) - original br0ker, badrecovery
