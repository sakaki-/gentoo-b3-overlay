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
	>=virtual/udev-215
	>=sys-power/bubba-buttond-1.4-r3"

src_install() {
	newinitd "${FILESDIR}/bootled-initd-3" "bootled"
	newinitd "${FILESDIR}/copynetsetup-initd-2" "copynetsetup"
	newinitd "${FILESDIR}/setethermac-initd-2" "setethermac"
	newsbin "${FILESDIR}/poweroff-b3-1" "poweroff-b3"
	insinto "/etc/udev/rules.d"
	newins "${FILESDIR}/marvell-tso-udev-1" "50-marvell-fix-tso.rules"
	exeinto "/usr/local/sbin"
	newexe "${FILESDIR}/install_on_sda.sh-2" "install_on_sda.sh"
	newexe "${FILESDIR}/install_on_sda_gpt.sh-2" "install_on_sda_gpt.sh"
}

fix_old_install_scripts_if_present() {
	if [[ -x "${ROOT}/root/install_on_sda.sh" && ! -L "${ROOT}/root/install_on_sda.sh" ]]; then
		ewarn "Replacing /root/install_on_sda.sh script with symlink..."
		rm -f "${ROOT}/root/install_on_sda.sh"
		ln -s "${ROOT}/usr/local/sbin/install_on_sda.sh" "${ROOT}/root/install_on_sda.sh"
	fi
	if [[ -x "${ROOT}/root/install_on_sda_gpt.sh" && ! -L "${ROOT}/root/install_on_sda_gpt.sh" ]]; then
		ewarn "Replacing /root/install_on_sda_gpt.sh script with symlink..."
		rm -f "${ROOT}/root/install_on_sda_gpt.sh"
		ln -s "${ROOT}/usr/local/sbin/install_on_sda_gpt.sh" "${ROOT}/root/install_on_sda_gpt.sh"
	fi
}

pkg_postinst() {
	elog "You can now issue:"
	elog " rc-update add bootled default"
	elog " rc-update add copynetsetup default"
	elog " rc-update add setethermac default"
	elog "to have these scripts run at boot time"
	elog "However, please note that:"
	elog " setethermac is needed _only_ when kexec-booting"
	elog " copynetsetup is deprecated, you can safely leave it disabled"
	fix_old_install_scripts_if_present
}

