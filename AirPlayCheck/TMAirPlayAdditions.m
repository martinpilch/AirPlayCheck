/*
  Copyright (c) 2012 Martin Pilch ( http://martinpilch.com/ )
                                   
  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the "Software"), to deal
  in the Software without restriction, including without limitation the rights
  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:

  The above copyright notice and this permission notice shall be included in
  all copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
  THE SOFTWARE.
 */

#import "TMAirPlayAdditions.h"
#import <AVFoundation/AVFoundation.h>

void RouteChangePropertyListener (
                         void                      *inClientData,
                         AudioSessionPropertyID    inID,
                         UInt32                    inDataSize,
                         const void                *inData
                         ) {
  TMAirPlayAdditions *additions = (__bridge TMAirPlayAdditions *)inClientData;
  
  [additions isAirPlayVideoAvailable];
  [additions isAirPlayConnected];
  
  if ( additions.airPlayConnected ) {
    [[NSNotificationCenter defaultCenter] postNotificationName:kAirPlayDeviceConnectedNotification object:nil];
  } else {
    [[NSNotificationCenter defaultCenter] postNotificationName:kAirPlayDeviceDisconnectedNotification object:nil];
  }
}

@implementation TMAirPlayAdditions

- (id)init {
  self = [super init];
  if ( self ) {
    
    AudioSessionAddPropertyListener(kAudioSessionProperty_AudioRouteChange, RouteChangePropertyListener, (__bridge void *)self);
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(handleScreenDidConnectNotification:)
                   name:UIScreenDidConnectNotification object:nil];
    [center addObserver:self selector:@selector(handleScreenDidDisconnectNotification:)
                   name:UIScreenDidDisconnectNotification object:nil];
    
    [self isAirPlayVideoAvailable];
    [self isAirPlayConnected];
  }
  return self;
}

- (void)dealloc {
  
  AudioSessionRemovePropertyListenerWithUserData(kAudioSessionProperty_AudioRouteChange, RouteChangePropertyListener, (__bridge void *)self);
  
  NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
  [center removeObserver:self name:UIScreenDidConnectNotification object:nil];
  [center removeObserver:self name:UIScreenDidDisconnectNotification object:nil];
  
}

#pragma mark -
#pragma mark Handlers

- (void)handleScreenDidConnectNotification:(NSNotification*)aNotification {
  
  [self isAirPlayVideoAvailable];
  [self isAirPlayConnected];
}

- (void)handleScreenDidDisconnectNotification:(NSNotification*)aNotification {
  
  [self isAirPlayVideoAvailable];
  [self isAirPlayConnected];
}

#pragma mark -
#pragma mark Public

- (BOOL)isAirPlayVideoAvailable {
  
  _airPlayVideoAvailable = ([UIScreen screens].count > 1);
  return self.airPlayVideoAvailable;
}

- (BOOL)isAirPlayConnected {
  
  //get audio route properties
  CFDictionaryRef dict;
  UInt32 propertySize = sizeof(dict);
  AudioSessionGetProperty(kAudioSessionProperty_AudioRouteDescription, &propertySize, &dict);
  
  NSDictionary *params = (__bridge NSDictionary*)dict;
  NSArray *outputs = params[ (NSString*)kAudioSession_AudioRouteKey_Outputs ];
  if ( outputs.count > 0 ) {
    //get audio output
    NSDictionary *output = outputs.lastObject;
#ifdef DEBUG
    NSLog(@"\n\n Device: %@ \n\n", output[ (NSString*)kAudioSession_AudioRouteKey_Type ]);
#endif
    if ( [output[ (NSString*)kAudioSession_AudioRouteKey_Type ] isEqualToString:(NSString *)kAudioSessionOutputRoute_AirPlay]) {
      _airPlayConnected = YES;
      CFRelease(dict);
      return YES;
    }
  }
  _airPlayConnected = NO;
  
  CFRelease(dict);
  return NO;
}

#pragma mark -
#pragma mark Singleton

+ (TMAirPlayAdditions*)sharedInstance; {
  
  static dispatch_once_t pred;
  static TMAirPlayAdditions *sharedInstance = nil;
  
  dispatch_once(&pred, ^{
    sharedInstance = [[TMAirPlayAdditions alloc] init];
  });
  return sharedInstance;
}

@end
