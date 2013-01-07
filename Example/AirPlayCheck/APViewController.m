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

#import "APViewController.h"

#import "TMAirPlayAdditions.h"
#import "APView.h"
#import <MediaPlayer/MediaPlayer.h>

@interface APViewController () {
  
  MPVolumeView *_volumeView;
}

- (void)airPlayDeviceConnected;
- (void)airPlayDeviceDisconnected;

@end

@implementation APViewController

#pragma mark -
#pragma mark Lifetime cycle

- (id)init {
  
  self = [super init];
  if ( self ) {
    
    [TMAirPlayAdditions initSharedInstance];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(airPlayDeviceConnected) name:kAirPlayDeviceConnectedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(airPlayDeviceDisconnected) name:kAirPlayDeviceDisconnectedNotification object:nil];
  }
  return self;
}

- (void)loadView {
  
  [super loadView];
  
  self.view = [[APView alloc] init];
}

- (void)dealloc {
  
  [[NSNotificationCenter defaultCenter] removeObserver:self name:kAirPlayDeviceConnectedNotification object:nil];
  [[NSNotificationCenter defaultCenter] removeObserver:self name:kAirPlayDeviceDisconnectedNotification object:nil];
}

#pragma mark -
#pragma mark AirPlay device event handling

- (void)airPlayDeviceConnected {
  
  [[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"AirPlay", @"")
                            message:NSLocalizedString(@"An AirPlay device connected", @"")
                           delegate:nil
                  cancelButtonTitle:NSLocalizedString(@"Dismiss", @"")
                  otherButtonTitles:nil] show];
}

- (void)airPlayDeviceDisconnected {
  
  [[[UIAlertView alloc]initWithTitle:NSLocalizedString(@"AirPlay", @"")
                             message:NSLocalizedString(@"An AirPlay device disconnected", @"")
                            delegate:nil
                   cancelButtonTitle:NSLocalizedString(@"Dismiss", @"")
                   otherButtonTitles:nil] show];
}

@end
