# ebuild for b3-init-scripts (misc init for Excito B3)
# Copyright (c) 2015 sakaki <sakaki@deciban.com>
# License: GPL v2
# NO WARRANTY

EAPI=5

KEYWORDS="~arm"

DESCRIPTION="Misc init scripts for the Excito B3 miniserver"
HOMEPAGE="https://github.com/sakaki-/gentoo-on-b3"
SRC_URI=""
LICENSE="GPL-3+"
SLOT="0"
IUSE=""

# required by Portage, as we have no SRC_URI...
S="${WORKDIR}"

DEPEND=""
RDEPEND="${DEPEND}
	>=sys-apps/ethtool-3.12.1
	>=virtual/udev-215"

src_install() {
	newinitd "${FILESDIR}/bootled-initd-1" "bootled"
	newinitd "${FILESDIR}/copynetsetup-initd-1" "copynetsetup"
	insinto "/etc/udev/rules.d"
	newins "${FILESDIR}/marvell-tso-udev-1" "50-marvell-fix-tso.rules"
}

pkg_postinst() {
	elog "You should run:"
	elog " rc-update add bootled default"
	elog " rc-update add copynetsetup default"
	elog "to have these scripts run at boot time"
}
