#
# Protocol KML addon
#
# Slawek Mikula, December 2019

var main = func( addon ) {
    var root = addon.basePath;
    var myAddonId  = addon.id;
    var mySettingsRootPath = "/addons/by-id/" ~ myAddonId;
    var protocolInitialized = 0;

    var enabledNode = props.globals.getNode(mySettingsRootPath ~ "/enabled", 1);
    enabledNode.setAttribute("userarchive", "y");
    if (enabledNode.getValue() == nil) {
      enabledNode.setValue("1");
    }

    var refreshRateNode = props.globals.getNode(mySettingsRootPath ~ "/refresh-rate", 1);
    refreshRateNode.setAttribute("userarchive", "y");
    if (refreshRateNode.getValue() == nil) {
      refreshRateNode.setValue("10");
    }

    var pathNode = props.globals.getNode(mySettingsRootPath ~ "/export-path", 1);
    pathNode.setAttribute("userarchive", "y");
    if (pathNode.getValue() == nil) {
      pathNode.setValue("~/export.kml");
    }

    var initProtocol = func() {
      if (protocolInitialized == 0) {
        var enabled = getprop(mySettingsRootPath ~ "/enabled") or "1";
        var refresh = getprop(mySettingsRootPath ~ "/refresh-rate") or "10";
        var path = getprop(mySettingsRootPath ~ "/export-path") or "~/export.kml";

        if (enabled == 1) {
          var protocolstring = "generic,file,out," ~ refresh ~ "," ~ path ~",kml";
          fgcommand("add-io-channel", props.Node.new({
            "config": protocolstring,
            "name":"kml"
          }));
          protocolInitialized = 1;
        }
      }
    }

    var shutdownProtocol = func() {
        if (protocolInitialized == 1) {
            fgcommand("remove-io-channel",
              props.Node.new({
                  "name" : "kml"
              })
            );
            protocolInitialized = 0;
        }
    }

    var init = _setlistener(mySettingsRootPath ~ "/enabled", func() {
        if (getprop(mySettingsRootPath ~ "/enabled") == 1) {
            initProtocol();
        } else {
            shutdownProtocol();
        }
    });

    var init = setlistener("/sim/signals/fdm-initialized", func() {
        removelistener(init); # only call once
        if (getprop(mySettingsRootPath ~ "/enabled") == 1) {
            initProtocol();
        }
    });

    var reinit_listener = _setlistener("/sim/signals/reinit", func {
        removelistener(reinit_listener); # only call once
        if (getprop(mySettingsRootPath ~ "/enabled") == 1) {
            initProtocol();
        }
    });

    var exit = setlistener("/sim/signals/exit", func() {
      removelistener(exit); # only call once
      if (getprop(mySettingsRootPath ~ "/enabled") == 1) {
        shutdownProtocol();
      }
    });
}