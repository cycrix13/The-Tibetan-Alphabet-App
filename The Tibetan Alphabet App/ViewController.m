//
//  ViewController.m
//  The Tibetan Alphabet App
//
//  Created by cycrix on 9/10/14.
//  Copyright (c) 2014 cycrix. All rights reserved.
//

#import "ViewController.h"
#import "CharController.h"

@interface ViewController ()

@end

@implementation ViewController {
    
    
    __weak IBOutlet UIScrollView *_scrollView;
    
    CGSize _imageSize;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImage *image = [UIImage imageNamed:@"alphabet.png"];
    UIImageView * imageView = [[UIImageView alloc] initWithImage:image];
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    _imageSize = CGSizeMake(screenBound.size.width, screenBound.size.width * 1986 / 640);
    imageView.frame = CGRectMake(0, 0, _imageSize.width, _imageSize.height);
    [_scrollView addSubview: imageView];
    
    int butWidth = _imageSize.width / 4;
    int butHeight = _imageSize.height / 8;
    for (int i = 0; i < 30; i++) {
        int cols = i % 4;
        int rows = i / 4;
        UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(butWidth * cols, butHeight * rows, butWidth, butHeight)];
        [button addTarget:self action:@selector(onCharClick:) forControlEvents:UIControlEventTouchUpInside];
        [button setTag:i];
        [_scrollView addSubview:button];
    }
    
    UIButton * btnAbout = [[UIButton alloc] initWithFrame:CGRectMake(0, _imageSize.height, screenBound.size.width, 48)];
    [btnAbout addTarget:self action:@selector(onAboutClick:) forControlEvents:UIControlEventTouchUpInside];
    [btnAbout setTitle:@"About" forState:UIControlStateNormal];
    [btnAbout setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    [_scrollView addSubview: btnAbout];
    
    /*UIButton * btnQuiz = [[UIButton alloc] initWithFrame:CGRectMake(0, _imageSize.height + 48, screenBound.size.width, 48)];
    [btnQuiz addTarget:self action:@selector(onQuizClick:) forControlEvents:UIControlEventTouchUpInside];
    [btnQuiz setTitle:@"Quiz" forState:UIControlStateNormal];
    [btnQuiz setTitleColor:[UIColor darkTextColor] forState:UIControlStateNormal];
    [_scrollView addSubview: btnQuiz];*/
    
    _scrollView.contentSize = CGSizeMake(_imageSize.width, _imageSize.height + 96);
}

- (void) onCharClick:(id)sender {

    CharController * controller = [self.storyboard instantiateViewControllerWithIdentifier:@"CharController"];
    [controller setChar: ((UIButton *) sender).tag];
    [self presentViewController:controller animated:YES completion:nil];
}

- (void) onAboutClick:(id)sender {
    
}
- (IBAction)onQuizClick:(id)sender {
    UIViewController * controller = [self.storyboard instantiateViewControllerWithIdentifier:@"QuizControllerViewController"];
    [self.navigationController pushViewController:controller animated:YES];
}

@end
