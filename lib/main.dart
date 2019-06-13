import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wifi_sharing_app/common/utils/wifi_iot.dart';

const String STA_DEFAULT_SSID = "WUST_Wireless";
const NetworkSecurity STA_DEFAULT_SECURITY = NetworkSecurity.NONE;

const String AP_DEFAULT_SSID = "WUST_Wireless";

void main() => runApp(new MyApp());

enum ClientDialogAction {
  cancel,
  ok,
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isWiFiAPEnabled = false;
  WIFI_AP_STATE _wifi_ap_state = WIFI_AP_STATE.WIFI_AP_STATE_DISABLED;
  List<APClient> _htResultClient;
  bool _isWiFiAPSSIDHidden = false;
  String _sAPSSID = "";
  String _sPreSharedKey = "";
  String _sPreviousAPSSID = "";
  String _sPreviousPreSharedKey = "";

  List<WifiNetwork> _htResultNetwork;
  bool _isEnabled = false;
  bool _isConnected = false;
  Map<String, bool> _htIsNetworkRegistered = new Map();
  String _sSSID = "";
  String _sBSSID = "";
  int _iCurrentSignalStrength = 0;
  int _iFrequency = 0;
  String _sIP = "";

  @override
  void initState() {
    super.initState();
  }

  storeAndConnect(String psSSID, String psKey) async {
    await storeAPInfos();
    await WiFiForIoTPlugin.setWiFiAPSSID(psSSID);
    await WiFiForIoTPlugin.setWiFiAPPreSharedKey(psKey);
  }

  storeAPInfos() async {
    String sAPSSID;
    String sPreSharedKey;
    try {
      sAPSSID = await WiFiForIoTPlugin.getWiFiAPSSID();
    } on PlatformException {
      sAPSSID = "";
    }
    try {
      sPreSharedKey = await WiFiForIoTPlugin.getWiFiAPPreSharedKey();
    } on PlatformException {
      sPreSharedKey = "";
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _sPreviousAPSSID = sAPSSID;
      _sPreviousPreSharedKey = sPreSharedKey;
    });
  }

  restoreAPInfos() async {
    WiFiForIoTPlugin.setWiFiAPSSID(_sPreviousAPSSID);
    WiFiForIoTPlugin.setWiFiAPPreSharedKey(_sPreviousPreSharedKey);
  }

  getWiFiAPInfos() async {
    String sAPSSID;
    String sPreSharedKey;
    try {
      sAPSSID = await WiFiForIoTPlugin.getWiFiAPSSID();
    } on PlatformException {
      sAPSSID = "";
    }

    try {
      sPreSharedKey = await WiFiForIoTPlugin.getWiFiAPPreSharedKey();
    } on PlatformException {
      sPreSharedKey = "";
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _sAPSSID = sAPSSID;
      _sPreSharedKey = sPreSharedKey;
    });
  }

  isWiFiAPSSIDHidden() async {
    bool isWiFiAPSSIDHidden;
    try {
      isWiFiAPSSIDHidden = await WiFiForIoTPlugin.isWiFiAPSSIDHidden();
    } on PlatformException {
      isWiFiAPSSIDHidden = false;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _isWiFiAPSSIDHidden = isWiFiAPSSIDHidden;
    });
  }

  isWiFiAPEnabled() async {
    bool isWiFiAPEnabled;
    try {
      isWiFiAPEnabled = await WiFiForIoTPlugin.isWiFiAPEnabled();
    } on PlatformException {
      isWiFiAPEnabled = false;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _isWiFiAPEnabled = isWiFiAPEnabled;
    });
  }

  getWiFiAPState() async {
    int iWiFiState;
    try {
      iWiFiState = await WiFiForIoTPlugin.getWiFiAPState();
    } on PlatformException {
      iWiFiState = WIFI_AP_STATE.WIFI_AP_STATE_FAILED.index;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      if (iWiFiState == WIFI_AP_STATE.WIFI_AP_STATE_DISABLING.index) {
        _wifi_ap_state = WIFI_AP_STATE.WIFI_AP_STATE_DISABLING;
      } else if (iWiFiState == WIFI_AP_STATE.WIFI_AP_STATE_DISABLED.index) {
        _wifi_ap_state = WIFI_AP_STATE.WIFI_AP_STATE_DISABLED;
      } else if (iWiFiState == WIFI_AP_STATE.WIFI_AP_STATE_ENABLING.index) {
        _wifi_ap_state = WIFI_AP_STATE.WIFI_AP_STATE_ENABLING;
      } else if (iWiFiState == WIFI_AP_STATE.WIFI_AP_STATE_ENABLED.index) {
        _wifi_ap_state = WIFI_AP_STATE.WIFI_AP_STATE_ENABLED;
      } else if (iWiFiState == WIFI_AP_STATE.WIFI_AP_STATE_FAILED.index) {
        _wifi_ap_state = WIFI_AP_STATE.WIFI_AP_STATE_FAILED;
      }
    });
  }

  getClientList(bool onlyReachables, int reachableTimeout) async {
    List<APClient> htResultClient;
    try {
      htResultClient = await WiFiForIoTPlugin.getClientList(
          onlyReachables, reachableTimeout);
    } on PlatformException {
      htResultClient = new List<APClient>();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _htResultClient = htResultClient;
    });
  }

  loadWifiList() async {
    List<WifiNetwork> htResultNetwork;
    try {
      htResultNetwork = await WiFiForIoTPlugin.loadWifiList();
    } on PlatformException {
      htResultNetwork = new List<WifiNetwork>();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _htResultNetwork = htResultNetwork;
    });
  }

  isEnabled() async {
    bool isEnabled;
    try {
      isEnabled = await WiFiForIoTPlugin.isEnabled();
    } on PlatformException {
      isEnabled = false;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _isEnabled = isEnabled;
    });
  }

  isConnected() async {
    bool isConnected;
    try {
      isConnected = await WiFiForIoTPlugin.isConnected();
    } on PlatformException {
      isConnected = false;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _isConnected = isConnected;
    });
  }

  getSSID() async {
    String ssid;
    try {
      ssid = await WiFiForIoTPlugin.getSSID();
    } on PlatformException {
      ssid = "";
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _sSSID = ssid;
    });
  }

  getBSSID() async {
    String bssid;
    try {
      bssid = await WiFiForIoTPlugin.getBSSID();
    } on PlatformException {
      bssid = "";
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _sBSSID = bssid;
    });
  }

  getCurrentSignalStrength() async {
    int iCurrentSignalStrength;
    try {
      iCurrentSignalStrength =
          await WiFiForIoTPlugin.getCurrentSignalStrength();
    } on PlatformException {
      iCurrentSignalStrength = 0;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _iCurrentSignalStrength = iCurrentSignalStrength;
    });
  }

  getFrequency() async {
    int iFrequency;
    try {
      iFrequency = await WiFiForIoTPlugin.getFrequency();
    } on PlatformException {
      iFrequency = 0;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _iFrequency = iFrequency;
    });
  }

  getIP() async {
    String sIP;
    try {
      sIP = await WiFiForIoTPlugin.getIP();
    } on PlatformException {
      sIP = "";
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _sIP = sIP;
    });
  }

  isRegisteredWifiNetwork(String ssid) async {
    bool bIsRegistered;
    try {
      bIsRegistered = await WiFiForIoTPlugin.isRegisteredWifiNetwork(ssid);
    } on PlatformException {
      bIsRegistered = false;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _htIsNetworkRegistered[ssid] = bIsRegistered;
    });
  }

  void showClientList() async {
    /// Refresh the list
    await getClientList(false, 300);

    /// Show in console
    if (_htResultClient != null && _htResultClient.length > 0) {
      _htResultClient.forEach((oClient) {
        print("************************");
        print("Client :");
        print("ipAddr = '${oClient.ipAddr}'");
        print("hwAddr = '${oClient.hwAddr}'");
        print("device = '${oClient.device}'");
        print("isReachable = '${oClient.isReachable}'");
      });
      print("************************");
    }
  }

  List<Widget> getActionsForiOS() {
    List<Widget> htActions = List();

    if (_isConnected) {}
    return htActions;
  }

  Widget getWidgetsForiOS() {
    isConnected();

    return SingleChildScrollView(
      child: SafeArea(
        top: false,
        bottom: false,
        child: Column(
          children: getButtonWidgetsForiOS(),
        ),
      ),
    );
  }

  List<Widget> getButtonWidgetsForiOS() {
    List<Widget> htPrimaryWidgets = new List();

    isEnabled();

    if (_isEnabled != null && _isEnabled) {
      htPrimaryWidgets.add(Text("Wifi Enabled"));
      isConnected();
      if (_isConnected != null && _isConnected) {
        getSSID();
        htPrimaryWidgets.addAll(<Widget>[
          Text("Connected"),
          Text("SSID: $_sSSID"),
        ]);

        if (_sSSID == STA_DEFAULT_SSID) {
          htPrimaryWidgets.addAll(<Widget>[
            RaisedButton(
              child: Text("Disconnect"),
              onPressed: () {
                WiFiForIoTPlugin.disconnect();
              },
            ),
          ]);
        } else {
          htPrimaryWidgets.addAll(<Widget>[
            RaisedButton(
              child: Text("Connect to '$AP_DEFAULT_SSID'"),
              onPressed: () {
                WiFiForIoTPlugin.connect(STA_DEFAULT_SSID,
                    joinOnce: true, security: NetworkSecurity.NONE);
              },
            ),
          ]);
        }
      } else {
        htPrimaryWidgets.addAll(<Widget>[
          Text("Disconnected"),
          RaisedButton(
            child: Text("Connect to '$AP_DEFAULT_SSID'"),
            onPressed: () {
              WiFiForIoTPlugin.connect(STA_DEFAULT_SSID,
                  joinOnce: true, security: NetworkSecurity.NONE);
            },
          ),
        ]);
      }
    } else {
      htPrimaryWidgets.addAll(<Widget>[
        Text("Wifi Disabled ?"),
        RaisedButton(
          child: Text("Connect to '$AP_DEFAULT_SSID'"),
          onPressed: () {
            WiFiForIoTPlugin.connect(STA_DEFAULT_SSID,
                joinOnce: true, security: NetworkSecurity.NONE);
          },
        ),
      ]);
    }
    htPrimaryWidgets.add(Divider(
      height: 32.0,
    ));

    return htPrimaryWidgets;
  }

  @override
  Widget build(BuildContext my_context) {
    final defaultTheme = Theme.of(context);
    if (defaultTheme.platform == TargetPlatform.iOS) {
      return MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: Text("WUST WiFI Connector"),
            actions: getActionsForiOS(),
          ),
          body: getWidgetsForiOS(),
        ),
      );
    }
    return Container();
  }
}

class PopupCommand {
  String command;
  String argument;

  PopupCommand(this.command, this.argument) {
    ///
  }
}
