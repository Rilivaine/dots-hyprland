# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Extended KDE BreezeX cursor theme, installed for illogical-impulse dotfiles"
HOMEPAGE="https://github.com/ful1e5/BreezeX_Cursor"
SRC_URI="https://github.com/ful1e5/BreezeX_Cursor/releases/download/v${PV}/BreezeX.tar.xz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
RESTRICT="strip"

DEPEND=""
RDEPEND=""

S="${WORKDIR}/BreezeX"

src_install() {
	insinto /usr/share/icons
	doins -r "${S}"
}
