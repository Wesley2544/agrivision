import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';

/// Shared connectivity helper.
///
/// `connectivity_plus` only reports which *interface type* Android thinks
/// is active (wifi / mobile / ethernet / none) — it does NOT confirm the
/// interface actually reaches the internet. Android emulators in particular
/// are known to misreport this (see: NAT'd emulator networking), which is
/// why the app can show "No internet connection" even when
/// `adb shell ping 8.8.8.8` succeeds.
///
/// [hasRealInternet] confirms real reachability via a raw TCP connection
/// to a known IP — NOT a hostname DNS lookup. Emulators can have working
/// ICMP/TCP connectivity while `InternetAddress.lookup('google.com')`
/// (hostname resolution) fails or hangs due to emulator DNS resolver
/// quirks, so a hostname-based check is unreliable here even when the
/// network itself is fine.
class NetworkUtils {
  NetworkUtils._();

  static Future<bool> hasRealInternet() async {
    // Fast first-pass: if there's truly no interface, don't bother
    // with a socket connection attempt at all.
    final interfaceResult = await Connectivity().checkConnectivity();
    if (interfaceResult.every((r) => r == ConnectivityResult.none)) {
      return false;
    }

    // Real reachability check — raw TCP connect to Google's public DNS
    // on port 53. Uses an IP directly, so no hostname resolution is
    // involved (avoids emulator DNS resolver quirks).
    try {
      final socket = await Socket.connect(
        '8.8.8.8',
        53,
        timeout: const Duration(seconds: 3),
      );
      socket.destroy();
      return true;
    } on SocketException {
      return false;
    } on TimeoutException {
      return false;
    }
  }

  /// Stream of "is actually online" booleans, for use in initState listeners.
  /// Debounces connectivity_plus's change events through the same real
  /// reachability check so UI doesn't flip on a false reading.
  static Stream<bool> get onRealConnectivityChanged async* {
    await for (final _ in Connectivity().onConnectivityChanged) {
      yield await hasRealInternet();
    }
  }
}