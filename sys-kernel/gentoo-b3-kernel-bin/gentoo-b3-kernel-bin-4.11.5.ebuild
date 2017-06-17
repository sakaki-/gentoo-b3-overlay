# Copyright (c) 2017 sakaki <sakaki@deciban.com>
# Distributed under the terms of the GNU General Public License v2
# $Header$

EAPI="6"

inherit eutils autotools

DESCRIPTION="Binary kernel package for the B3 miniserver, from gentoo-sources"
HOMEPAGE="https://github.com/sakaki-/gentoo-b3-kernel"

SRC_URI="${HOMEPAGE}/releases/download/${PVR}/gentoo-b3-kernel-${PVR}.tar.xz -> ${PF}.tar.xz"

LICENSE="GPL-2 freedist"
SLOT="0"
KEYWORDS="~arm"
IUSE="+checkboot firmware"

RESTRICT="mirror"

DEPEND=""
RDEPEND="${DEPEND}"

QA_PREBUILT="*"

S="${WORKDIR}"

# ebuild function overrides

pkg_pretend() {
	# check /boot directory is mounted, provided $ROOT is /
	if use checkboot && [[ "${ROOT%/}" == "" ]]; then
		if ! grep -q "^/boot$" <(cut -d " " -f 2 "/proc/mounts") &>/dev/null; then
			die "Your /boot directory does not appear to be mounted"
		fi
	else
		ewarn 'Installing into non-default $ROOT'
		ewarn "Not checking whether /boot is mounted"
	fi
}

src_install() {
	local RELEASE_NAME

	# copy tarball contents into temporary install root
	insinto /boot
	doins -r "${S%/}/boot"/*
	insinto /lib/modules
	doins -r "${S%/}/lib/modules"/*

	if use firmware; then
		# NB may cause collisions if linux-firmware installed
		insinto /lib/firmware
		doins -r "${S%/}/lib/firmware"/*
	fi

	# note that we installed the libraries, for future cleanup
	RELEASE_NAME=$(head -n1 <(ls -t1d "${S}/lib/modules"/*))
	RELEASE_NAME="${RELEASE_NAME##*/}"
	echo "${PF}" > "${D%/}/lib/modules/${RELEASE_NAME}/owning_binpkg"
}

pkg_postinst() {
	elog "Your new kernel has been installed."
	elog "Reboot your system to start using it."
}

pkg_postrm() {
	# it is possible that if the kernel originally installed by this ebuild
	# is currently running, then its /lib/modules/<release_name> directory
	# will still be present, due to some of the module files therein having
	# been marked as "in use", leading Portage deline to delete them during
	# the default uninstall phase
	# detect if this has happened and, if so, forcibly (and recursively)
	# delete /lib/modules/<release_name>, and print a warning
	local MDIR OWNING_BINPKG

	shopt -s nullglob
	for MDIR in "${ROOT%/}/lib/modules"/*; do
		# was this kernel installed by a binary package?
		if [[ -s "${MDIR}/owning_binpkg" ]]; then
			OWNING_BINPKG="$(<"${MDIR}/owning_binpkg")"
			# was it us?
			if [[ "${PF}" == "${OWNING_BINPKG}" ]]; then
				# yes, we installed it, we need to remove it
				ewarn "Forcibly deleting kernel module directory ${MDIR}"
				rm -rf "${MDIR}"
				# warn user if this is a 'pure' uninstall,
				# rather than an upgrade
				if [[ -z "${REPLACED_BY_VERSION}" ]]; then
					ewarn "Please ensure you have a valid kernel and module set"
					ewarn "in place, before rebooting."
				fi
			fi
		fi
	done
	shopt -u nullglob
}
