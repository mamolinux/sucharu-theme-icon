# [Sucharu Icons](https://hsbasu.github.io/sucharu-theme-icon)

<!-- <p align="center">
	<img src="#?sanitize=true" height="128" alt="Logo">
</p> -->

<p align="center">
	<a href="https://github.com/mamolinux/sucharu-theme-icon/blob/master/LICENSE">
		<img src="https://img.shields.io/github/license/mamolinux/sucharu-theme-icon?label=License" alt="License">
	</a>
	<a href="#">
		<img src="https://img.shields.io/github/repo-size/mamolinux/sucharu-theme-icon?label=Repo%20size" alt="GitHub repo size">
	</a>
	<a href="https://github.com/mamolinux/sucharu-theme-icon/issues" target="_blank">
		<img src="https://img.shields.io/github/issues/mamolinux/sucharu-theme-icon?label=Issues" alt="Open Issues">
	</a>
	<a href="https://github.com/mamolinux/sucharu-theme-icon/pulls" target="_blank">
		<img src="https://img.shields.io/github/issues-pr/mamolinux/sucharu-theme-icon?label=PR" alt="Open PRs">
	</a>
	<a href="https://github.com/mamolinux/sucharu-theme-icon/releases/latest">
		<img src="https://img.shields.io/github/v/release/mamolinux/sucharu-theme-icon?label=Latest%20Stable%20Release" alt="GitHub release (latest by date)">
	</a>
	<a href="#download-latest-version">
		<img src="https://img.shields.io/github/downloads/mamolinux/sucharu-theme-icon/total?label=Downloads" alt="Downloads">
	</a>
	<a href="https://github.com/mamolinux/sucharu-theme-icon/releases/download/0.0.9/sucharu-theme-icon_0.0.9_all.deb">
		<img src="https://img.shields.io/github/downloads/mamolinux/sucharu-theme-icon/0.0.9/sucharu-theme-icon_0.0.9_all.deb?color=blue&label=Downloads%40Latest%20Binary" alt="GitHub release (latest by date and asset)">
	</a>
</p>

Sucharu Icons is a [Material Design](https://material.io) theme for GNOME/GTK based desktop environments.

## Download Latest Version

<p align="center">
	<a href="https://github.com/mamolinux/sucharu-theme-icon/zipball/master">Download Source (.zip)</a></br>
	<a href="https://github.com/mamolinux/sucharu-theme-icon/tarball/master">Download Source (.tar.gz)</a></br>
	<a href="https://github.com/mamolinux/sucharu/releases/download/0.0.9/sucharu-theme-icon_0.0.9_all.deb">Download Sucharu Icons Binary (.deb)</a>
</p>

## Features and Screenshots
Coming soon or create a Pull Request.

### Sample Screenshot
<!-- <p align="center">
	<img src="https://github.com/mamolinux/sucharu-theme-icon/raw/gh-pages/screenshots/sample-screenshot.png" alt="Sample Screenshot">
</p> -->

## Contents
- [Download Latest Version](#download-latest-version)
- [Features and Screenshots](#features-and-screenshots)
- [Dependencies](#dependencies)
  - [Debian/Ubuntu based systems](#debianubuntu-based-distro)
  - [Other Linux-based systems](#other-linux-based-distro)
- [Installation](#build-and-install-the-latest-version)
  - [Debian/Ubuntu based systems](#debianubuntu-based-systems)
  - [Other Linux-based systems](#other-linux-based-systems)
  - [For Developers](#for-developers)
- [User Manual](#user-manual)
- [Issue Tracking and Contributing](#issue-tracking-and-contributing)
- [Contributors](#contributors)

## Dependencies
```
debhelper-compat (= 13)
dh-migrations
libglib2.0-dev
meson (>= 0.60)
sassc
python3
```
### Debian/Ubuntu based distro
```
sudo apt install debhelper libglib2.0-dev \
meson sassc python3
```
### Other Linux-based distro
Remove `apt install` and the `debhelper` package in the command given in [Debian/Ubuntu based distros](#debianubuntu-based-distro) and use the command for the package manager of the target system(eg. `yum install`, `dnf install`, `pacman -S` etc.)

**Note**: There might be cases where one or more dependencies might not be available for your system. But that is highly unlikely. In such situations, please [create an issue](#issue-tracking-and-contributing).

## Build and Install the Latest Version
### Debian/Ubuntu based systems
There are two methods, the icon themes can be installed/used on a Debian/Ubuntu based system. First, download and unzip the source package using:
```
wget https://github.com/mamolinux/sucharu-theme-icon/archive/refs/heads/master.zip
unzip master.zip
cd sucharu-theme-icon-master
```

1. **Option 1:** Manually copying necessary files to root (`/`). For that, follow the steps below:
	1. To build the **icon** themes, run meson as:
		```
		rm -rf builddir
		meson builddir
		meson compile -C builddir
		meson install -C builddir
		```
		from the `/path/to/repo` in a terminal. It will install the **icon** themes in `/usr/share/icons` for all users.

	2. To avoid using `sudo` and install the themes for single user:
		```
		rm -rf builddir
		meson -Dprefix=$HOME/.local builddir
		meson compile -C builddir
		meson install -C builddir
		```
		from the `/path/to/repo` in a terminal. It will install the **icon** themes in `/home/{localuser}/.local/share/icons` for the user **localuser**.

2. **Option 2:** Build debian packages and install it. To build a debian package on your own:
	1. from the `/path/to/repo` run:
		```
		dpkg-buildpackage --no-sign
		```
		This will create `sucharu-theme-icon*.deb` packages at `../path/to/repo`.
	2. Install the debian packages using
		```
		sudo dpkg -i *.deb
		sudo apt install -f
		```
	After it is installed, set the themes from your distro's theme manager or use the [**Theme Manager**](https://hsbasu.github.io/theme-manager) to change themes automatically at certain interval.

### Other Linux-based systems
1. Install the [dependencies](#other-linux-based-distro).
2. From instructions for [Debian/Ubuntu based systems](#debianubuntu-based-systems), follow **Option 1**.

### For Developers
1. Scalable icons:
	
	To add a new scalable icon,
	1. put the **svg** in `icons/src/scalable/_variant_/_context_/` directory. Where `_variant_` is either **default** or **dark**.
	2. Run `render-symbolic-icons.sh` from `icons/src/scalable/`
	3. Copy the reduced **svg** from `icons/Sucharu{_variant_}/scalable/_context_/` to `icons/src/scalable/_variant_/_context_/`
	
2. Fullcolor icons:
	
	To add a new Fullcolor icon,
	1. put the **svg** in `icons/src/fullcolor/default/_context_/` directory.
	2. Run `render-bitmaps.py new-icon.svg` from `icons/src/fullcolor/` to generate the **png** files in `icons/Sucharu/PxP/_context_/`.

## User Manual
Coming soon or create a Pull Request.

## Issue Tracking and Contributing
If you are interested to contribute and enrich the code, you are most welcome. You can do it by:
1. If you find a bug, to open a new issue with details: [Click Here](https://github.com/mamolinux/sucharu-theme-icon/issues)
2. If you know how to fix a bug or want to add new feature/documentation to the existing package, please create a [Pull Request](https://github.com/mamolinux/sucharu-theme-icon/compare).

## Contributors

### [Himadri Sekhar Basu](https://hsbasu.github.io)
Current Maintainer.

## Donations
If you like this app and would like to buy me a coffee ( &#9749; ) , you can do so via:

<a href="https://liberapay.com/hsbasu/donate" target="_blank">
	<img src="https://liberapay.com/assets/widgets/donate.svg" alt="Donate using Liberapay">
</a>
<a href="https://paypal.me/hsbasu" target="_blank">
	<img src="https://www.paypalobjects.com/webstatic/i/logo/rebrand/ppcom.svg" alt="Donate using PayPal">
</a>
<a href="https://hsbasu.github.io/images/upi-qr.jpg" target="_blank">
	<img src ="https://hsbasu.github.io/styles/icons/logo/svg/upi-logo.svg" alt="Paytm UPI">
</a>
