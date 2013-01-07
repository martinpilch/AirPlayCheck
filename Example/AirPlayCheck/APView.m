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

#import "APView.h"
#import <MediaPlayer/MediaPlayer.h>

@interface APView () {
  MPVolumeView *_volumeView;
}

@end

@implementation APView

- (id)init
{
  self = [super init];
  if (self) {
    _volumeView = [[MPVolumeView alloc] init];
    _volumeView.showsVolumeSlider = NO;
    [self addSubview:_volumeView];
  }
  return self;
}

- (void)layoutSubviews {
  
  [super layoutSubviews];
  
  CGRect frame;
  frame.size = CGSizeMake(100, 100);
  frame.origin = CGPointMake((CGRectGetWidth(self.bounds) - CGRectGetWidth(frame)) / 2,
                             (CGRectGetHeight(self.bounds) - CGRectGetHeight(frame)) / 2);
  if (!CGRectEqualToRect(_volumeView.frame, frame)) {
    _volumeView.frame = frame;
  }
}

@end
