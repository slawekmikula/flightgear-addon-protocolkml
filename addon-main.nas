#
# Protocol KML addon
#
# Slawek Mikula, December 2019

var main = func( addon ) {
    var fdm_init_listener = _setlistener("/sim/signals/fdm-initialized", func {
        removelistener(fdm_init_listener);

        fgcommand("add-io-channel", props.Node.new({
            "config": "generic,file,out,1,/home/zorba/test.kml,kml",
            "name":"kml"
        }));
    });

}
