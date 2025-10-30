{pkgs, config, lib, ...}: let
  inherit (config.lib.stylix) colors;
in {
  home.packages = with pkgs; [
    # GJS runtime for Astal
    gjs

    # Astal core and modules
    astal.gjs
    astal.io
    astal.astal3
    astal.astal4
    astal.apps
    astal.battery
    astal.bluetooth
    astal.network
    astal.wireplumber
    astal.tray
    astal.notifd
    astal.mpris
    astal.hyprland
  ];

  home.file.".config/astal/App.ts".text = ''
import { App } from "astal/gtk3"
import style from "./style.scss"
import Bar from "./widget/Bar"

App.start({
    css: style,
    instanceName: "js",
    requestHandler(request, res) {
        print(request)
        res("ok")
    },
    main: () => App.get_monitors().map(Bar),
})
'';

  home.file.".config/astal/widget/Bar.tsx".text = ''
import { Window, Label, Box, Center, Button, Revealer, Icon } from "astal/gtk3/widget"
import { Variable, bind } from "astal/variable"
import { App } from "astal/gtk3"
import { Hyprland } from "astal/hyprland"

const time = Variable("").poll(1000, () =>
    Date.now().toString()
)

const date = Variable("").poll(1000, () =>
    new Date().toLocaleDateString()
)

const workspaces = bind(Hyprland.get().workspaces)

function Workspaces() {
    return <box className="workspaces">
        {workspaces.as(ws => ws.map(({ id, name }) => (
            <button
                className={workspaces.as(ws => ws.find(w => w.id === id) ? "focused" : "")}
                onClicked={() => Hyprland.get().focusWorkspace(id)}
            >
                {name}
            </button>
        ))}
    </box>
}

export default function Bar(monitor) {
    return <window
        className="Bar"
        exclusivity="EXCLUSIVE"
        screen={monitor}
        anchor={{ top: true, left: true, right: true }}
        layer="TOP"
    >
        <center>
            <box className="bar">
                <box hexpand>
                    <Workspaces />
                </box>
                <box>
                    <label label={bind(date)} />
                    <label label={bind(time)} />
                </box>
            </box>
        </center>
    </window>
}
'';

  home.file.".config/astal/style.scss".text = ''
* {
    all: unset;
    font-family: "SF Pro";
    font-size: 16px;
    transition: 200ms;
}

.Bar {
    background-color: rgba(0, 0, 0, 0.7);
    border-radius: 12px;
    margin: 8px;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.3);
}

.bar {
    background-color: rgba(30, 30, 30, 0.9);
    border-radius: 8px;
    padding: 8px 16px;
    margin: 4px;
    color: white;
}

.workspaces {
    spacing: 8px;
}

.workspaces button {
    background-color: rgba(255, 255, 255, 0.1);
    border: 1px solid rgba(255, 255, 255, 0.2);
    border-radius: 6px;
    padding: 6px 12px;
    color: rgba(255, 255, 255, 0.8);
    font-weight: 500;
    min-width: 32px;
    min-height: 32px;
}

.workspaces button:hover {
    background-color: rgba(255, 255, 255, 0.2);
    border-color: rgba(255, 255, 255, 0.4);
    color: white;
}

.workspaces button.focused {
    background-color: rgba(100, 149, 237, 0.8);
    border-color: rgba(100, 149, 237, 1);
    color: white;
}

label {
    color: rgba(255, 255, 255, 0.9);
    font-weight: 400;
    margin: 0 8px;
}
'';

  # Autostart Astal
  systemd.user.services.astal = {
    Unit = {
      Description = "Astal Status Bar";
      PartOf = ["graphical-session.target"];
      After = ["graphical-session.target"];
    };
    Service = {
      ExecStart = "${pkgs.gjs}/bin/gjs --module %h/.config/astal/App.ts";
      Restart = "on-failure";
      Environment = [
        "GI_TYPELIB_PATH=${pkgs.astal.gjs}/share/astal/gjs:${pkgs.astal.astal3}/share/astal/gjs:${pkgs.gtk3}/lib/girepository-1.0"
        "GJS_PATH=${pkgs.astal.gjs}/share/astal/gjs:${pkgs.astal.astal3}/share/astal/gjs"
      ];
    };
    Install.WantedBy = ["graphical-session.target"];
  };
}
