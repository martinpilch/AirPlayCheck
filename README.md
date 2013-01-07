AirPlayCheck
============

Simple library to get notified if iOS device connected to any AirPlay device

You can add AirPlay device connection support in few easy steps:

1. Add the `TMAirPlayAdditions.h` and `TMAirPlayAdditions.m` files to your project.
2. Add `AVFoundation` and `AudioToolbox` frameworks to your project.
3. Import `TMAirPlayAdditions.h`
4. Init the class using `[TMAirPlayAdditions initSharedInstance];`
5. Add observers for `kAirPlayDeviceConnectedNotification` and `kAirPlayDeviceDisconnectedNotification` notifications