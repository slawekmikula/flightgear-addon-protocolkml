#
# Protocol KML addon
#
# Slawek Mikula, December 2019

var main = func( addon ) {
    var root = addon.basePath;
    var my_addon_id  = "com.slawekmikula.flightgear.ProtocolKml";
    var my_version   = getprop("/addons/by-id/" ~ my_addon_id ~ "/version");
    var my_root_path = getprop("/addons/by-id/" ~ my_addon_id ~ "/path");

    var fdm_init_listener = _setlistener("/sim/signals/fdm-initialized", func {
        removelistener(fdm_init_listener);

        fgcommand("add-io-channel", props.Node.new({
            "config": "generic,file,out,1,/home/zorba/test.kml,[addon=com.slawekmikula.flightgear.ProtocolKml]/Protocol/kml",
            "name":"kml"
        }));
    });

}
