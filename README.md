# gentoo-b3-overlay
Gentoo overlay for the Excito B3 miniserver.

## List of ebuilds

<img src="https://raw.githubusercontent.com/sakaki-/resources/master/excito/b3/Excito_b3.jpg" alt="Excito B3" width="250px" align="right"/>

* **dev-libs/lzo** [upstream](http://www.oberhumer.com/opensource/lzo/download/)
 * At the time of writing, the Gentoo tree contains only version <= 2.08 of this dev-libs/lzo. Unfortunately, there is a serious alignment bug ([#757037 on Debian](https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=757037#32)) with this library on armv5tel, preventing it working correctly (and inhibiting the use of certain client apps, such as openvpn). The problem is fixed in version 2.09 of the library, for which a placeholder ebuild is provided here.
* **sys-kernel/buildkernel-b3** [source](https://github.com/sakaki-/buildkernel-b3)
 * Provides a script (**buildkernel-b3**(8)) to build a bootable Gentoo Linux kernel for the Excito B3, targeting either HDD or USB deployment. Can be used on the B3 directly, or on a Gentoo PC (when cross-compiling via `crossdev`). A manpage is included.
* **sys-apps/b3-init-scripts** [source](https://github.com/sakaki-/gentoo-b3-overlay/tree/master/sys-apps/b3-init-scripts/files)
 * Provides a set of simple init scripts for the B3 (to turn on the LED on boot, copy across network settings when booting etc.).

## Installation

**gentoo-b3-overlay** is best installed (on Gentoo) via **layman**(8); it supplies a repository named **gentoo-b3**.

The following are short form instructions. If you haven't already installed **layman**(8), do so first:

    emerge --ask --verbose app-portage/layman
    echo 'source "/var/lib/layman/make.conf"' >> /etc/portage/make.conf

Make sure the `git` USE flag is set for the **app-portage/layman** package (it should be by default).

Next, create a custom layman entry for the **gentoo-b3** overlay, so **layman**(8) can find it on GitHub. Fire up your favourite editor:

    nano -w /etc/layman/overlays/gentoo-b3.xml

and put the following text in the file:

    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE repositories SYSTEM "/dtd/repositories.dtd">
    <repositories xmlns="" version="1.0">
        <repo priority="50" quality="experimental" status="unofficial">
    	    <name>gentoo-b3</name>
    	    <description>Gentoo overlay for the Excito B3 miniserver.</description>
    	    <homepage>https://github.com/sakaki-/gentoo-b3-overlay</homepage>
    	    <owner>
    		    <email>sakaki@deciban.com</email>
    		    <name>sakaki</name>
            </owner>
    	    <source type="git">https://github.com/sakaki-/gentoo-b3-overlay.git</source>
        </repo>
    </repositories>


Then run:

    layman --sync-all
    layman --add="gentoo-b3"

If you are running on the stable branch by default, allow **~arm** keyword files from this repository:

    echo '*/*::gentoo-b3 ~arm' >> /etc/portage/package.accept_keywords
    
Now you can install packages from the overlay. For example:

    emerge --ask --verbose sys-kernel/buildkernel-b3

## Maintainers

* [sakaki](mailto:sakaki@deciban.com)
