import qs.services
import QtQuick
import qs.modules.ii.onScreenDisplay
import qs.modules.ii.bar
import qs.modules.common.functions

OsdValueIndicator {
    readonly property string cleanedTitle: StringUtils.cleanMusicTitle(MprisController.activePlayer?.trackTitle)

    id: osdValues
    value: -1
    icon: MprisController.activePlayer?.muted ? "volume_off" : "volume_up"
    name: `Now playing ${MprisController.activePlayer?.trackArtist ? `${MprisController.activePlayer.trackArtist} • ${cleanedTitle}` : cleanedTitle}`
    valueIndicatorRightPadding: 40
    valueIndicatorLeftPadding: 10
    scaleIcon: false
}
