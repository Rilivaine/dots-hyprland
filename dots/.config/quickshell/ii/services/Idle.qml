pragma Singleton
import qs.modules.common
import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Wayland

/**
 * Idle inhibition ("Keep system awake").
 * Uses a Wayland idle inhibitor plus a logind inhibitor as a fallback for hypridle.
 */
Singleton {
    id: root

    property alias inhibit: idleInhibitor.enabled
    inhibit: false

    function applyPersistedInhibit() {
        if (!Persistent.ready)
            return;

        if (Persistent.isNewHyprlandInstance) {
            root.inhibit = false;
            Persistent.states.idle.inhibit = false;
            return;
        }

        root.inhibit = Persistent.states.idle.inhibit;
    }

    Component.onCompleted: applyPersistedInhibit()

    Connections {
        target: Persistent
        function onReadyChanged() {
            root.applyPersistedInhibit();
        }
    }

    Connections {
        target: Persistent.states.idle
        function onInhibitChanged() {
            if (!Persistent.ready || Persistent.isNewHyprlandInstance)
                return;
            if (root.inhibit !== Persistent.states.idle.inhibit)
                root.inhibit = Persistent.states.idle.inhibit;
        }
    }

    function toggleInhibit(active = null) {
        if (active !== null) {
            root.inhibit = active;
        } else {
            root.inhibit = !root.inhibit;
        }
        Persistent.states.idle.inhibit = root.inhibit;
    }

    // hypridle also respects logind idle inhibitors; keep this as a fallback when
    // the Wayland surface is not considered visible enough to honor zwp_idle_inhibit.
    Process {
        running: root.inhibit
        command: ["systemd-inhibit", "--what=idle:sleep", "--who=quickshell", "--why=Keep system awake", "--mode=block", "sleep", "infinity"]
    }

    IdleInhibitor {
        id: idleInhibitor
        window: PanelWindow {
            visible: true
            implicitWidth: 1
            implicitHeight: 1
            color: "transparent"
            exclusionMode: ExclusionMode.Ignore
            exclusiveZone: 0
            WlrLayershell.namespace: "quickshell:idleInhibitor"
            WlrLayershell.layer: WlrLayer.Overlay
            anchors {
                right: true
                bottom: true
            }
            mask: Region {
                item: null
            }
        }
    }
}
