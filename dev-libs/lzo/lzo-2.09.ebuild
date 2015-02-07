# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/lzo/lzo-2.08-r1.ebuild,v 1.1 2014/07/02 14:09:50 ssuominen Exp $

EAPI=5

inherit eutils multilib-minimal toolchain-funcs

DESCRIPTION="An extremely fast compression and decompression library"
HOMEPAGE="http://www.oberhumer.com/opensource/lzo/"
SRC_URI="http://www.oberhumer.com/opensource/lzo/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="2"
KEYWORDS="~arm"
IUSE="examples static-libs"

RDEPEND="abi_x86_32? (
		!<=app-emulation/emul-linux-x86-baselibs-20131008-r19
		!app-emulation/emul-linux-x86-baselibs[-abi_x86_32]
	)"

DOCS="BUGS ChangeLog README THANKS doc/*"

multilib_src_configure() {
	ECONF_SOURCE=${S} \
	econf \
		--docdir="${EPREFIX}"/usr/share/doc/${PF} \
		--enable-shared \
		$(use_enable static-libs static)
}

multilib_src_install() {
	emake DESTDIR="${D}" install
	multilib_is_native_abi && gen_usr_ldscript -a lzo2
}

multilib_src_install_all() {
	einstalldocs
	rm -f "${ED}"/usr/share/doc/${PF}/COPYING

	if use examples; then
		docinto examples
		dodoc examples/*.{c,h}
	fi

	prune_libtool_files
}
