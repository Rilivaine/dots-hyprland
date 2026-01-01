import qs.services
import QtQuick
import qs.modules.ii.onScreenDisplay
import qs.modules.ii.bar

OsdValueIndicator {
    id: osdValues
    value: MprisController.activePlayer?.volume
    icon: MprisController.activePlayer?.muted ? "volume_off" : "volume_up"
    name: "Volume"
}
