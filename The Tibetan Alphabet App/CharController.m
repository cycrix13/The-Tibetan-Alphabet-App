//
//  CharController.m
//  The Tibetan Alphabet App
//
//  Created by cycrix on 9/11/14.
//  Copyright (c) 2014 cycrix. All rights reserved.
//

#import "CharController.h"
#import <AudioToolbox/AudioToolbox.h>
#import "CanvasImage.h"

@interface CharController ()

@end

@implementation CharController {
    
    UIButton *_btnHome;
    UIButton *_btnEraser;
    UIButton *_btnPlay;
    UIButton *_btnPrev;
    UIButton *_btnNext;
    __weak IBOutlet UIImageView *_topBar;
    __weak IBOutlet UIImageView *_bottomBar;
    UIImageView * _imgWrite;
    UIImageView * _imgCanvas;
    CanvasImage * _canvas;
    
    int _charIndex;
    NSArray * _charNameList;
    SystemSoundID _soundIdArr[30];
    
    BOOL _layouted;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _layouted = NO;
        _charNameList =
        @[@"KA", @"KHA", @"GA", @"NGA",
          @"CHA", @"CHHA", @"JA", @"NYA",
          @"TA", @"THA", @"DA", @"NA",
          @"PA", @"PHA", @"BA", @"MA",
          @"TSA", @"TSHA", @"DZA", @"WA",
          @"ZHA", @"ZA", @"AH", @"YA",
          @"RA", @"LA", @"SHA", @"SA",
          @"HA", @"A"];
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

    }
    return self;
}

- (void) setChar:(int) charIndex {
    _charIndex = charIndex;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    for (int i = 0; i < 30; i++) {
        NSString * soundName = [[_charNameList objectAtIndex:i] lowercaseString];
        NSString *soundPath = [[NSBundle mainBundle] pathForResource: soundName ofType:@"mp3"];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath: soundPath], &_soundIdArr[i]);
    }
}

- (void) dealloc
{
    for (int i = 0; i < 30; i++) {
        AudioServicesDisposeSystemSoundID(_soundIdArr[i]);
    }
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void) viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if (_layouted)
        return;
    
    _layouted = YES;
    
    CGRect topBound = _topBar.frame;
    CGRect bottomBound = _bottomBar.frame;
    
    _btnHome = [[UIButton alloc] initWithFrame:
                CGRectMake(0, bottomBound.origin.y, bottomBound.size.width / 3, bottomBound.size.height)];
    [_btnHome addTarget:self action:@selector(onHomeClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnHome];
    
    _btnEraser = [[UIButton alloc] initWithFrame:
                  CGRectMake(bottomBound.size.width / 3, bottomBound.origin.y,
                             bottomBound.size.width / 3, bottomBound.size.height)];
    [_btnEraser addTarget:self action:@selector(onEraserClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnEraser];
    
    _btnPlay = [[UIButton alloc] initWithFrame:
                  CGRectMake(bottomBound.size.width * 2 / 3, bottomBound.origin.y,
                             bottomBound.size.width / 3, bottomBound.size.height)];
    [_btnPlay addTarget:self action:@selector(onPlayClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnPlay];
    
    _btnPrev = [[UIButton alloc] initWithFrame:
                CGRectMake(0, 0,
                           topBound.size.height, topBound.size.height)];
    [_btnPrev addTarget:self action:@selector(onPrevClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnPrev];
    
    _btnNext = [[UIButton alloc] initWithFrame:
                CGRectMake(topBound.size.width - topBound.size.height, 0,
                           topBound.size.height, topBound.size.height)];
    [_btnNext addTarget:self action:@selector(onNextClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_btnNext];
    
    _imgWrite = [[UIImageView alloc] initWithFrame: topBound];
    [_imgWrite setContentMode:UIViewContentModeCenter];
    [self.view addSubview:_imgWrite];
    
    CGRect canvasFrame;
    canvasFrame.origin.x = 0;
    canvasFrame.origin.y = topBound.origin.y + topBound.size.height;
    canvasFrame.size.width = topBound.size.width;
    canvasFrame.size.height = bottomBound.origin.y - canvasFrame.origin.y;
    _imgCanvas = [[UIImageView alloc] initWithFrame:canvasFrame];
    [_imgCanvas setContentMode:UIViewContentModeScaleToFill];
    [self.view addSubview:_imgCanvas];
    
    _canvas = [[CanvasImage alloc] initWithFrame:canvasFrame];
    [_canvas setContentMode:UIViewContentModeScaleToFill];
    [self.view addSubview:_canvas];
    [_canvas setUserInteractionEnabled: YES];
    
    [self updateImage];
    
    [self.view layoutSubviews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onHomeClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onEraserClick:(id)sender {
    [_canvas clear];
}

- (IBAction)onPlayClick:(id)sender {
    AudioServicesPlaySystemSound (_soundIdArr[_charIndex]);
}

- (IBAction)onPrevClick:(id)sender {
    
    if (_charIndex > 0) {
        _charIndex--;
        [self updateImage];
        [_canvas clear];
    }
}

- (IBAction)onNextClick:(id)sender {
    
    if (_charIndex < 29) {
        _charIndex++;
        [self updateImage];
        [_canvas clear];
    }
}

- (void) updateImage {
    
    NSString * writeImageName = [[[_charNameList objectAtIndex:_charIndex] lowercaseString] stringByAppendingString:@"_write.jpg"];
    UIImage * writeImage = [UIImage imageNamed:writeImageName];
    [_imgWrite setImage:writeImage];
    
    NSString * canvasImageName = [[[_charNameList objectAtIndex:_charIndex] lowercaseString] stringByAppendingString:@".jpg"];
    UIImage * canvasImage = [UIImage imageNamed:canvasImageName];
    [_imgCanvas setImage:canvasImage];
}

@end
