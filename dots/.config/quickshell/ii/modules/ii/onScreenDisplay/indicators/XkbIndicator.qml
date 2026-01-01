import qs.services
import QtQuick
import qs.modules.ii.onScreenDisplay

OsdValueIndicator {
    id: osdValues
    value: -1
    icon: "keyboard"
    name: HyprlandXkb.currentLayoutName
}
