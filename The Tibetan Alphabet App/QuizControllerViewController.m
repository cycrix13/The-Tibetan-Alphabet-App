//
//  QuizControllerViewController.m
//  The Tibetan Alphabet App
//
//  Created by cycrix on 9/12/14.
//  Copyright (c) 2014 cycrix. All rights reserved.
//

#import "QuizControllerViewController.h"

@interface QuizControllerViewController ()

@end

@implementation QuizControllerViewController {
    
    __weak IBOutlet UILabel *_txtStep;
    __weak IBOutlet UILabel *_txtCorrect;
    __weak IBOutlet UIImageView *_imgChar;
    __weak IBOutlet UIButton *_btn1;
    __weak IBOutlet UIButton *_btn2;
    __weak IBOutlet UIButton *_btn3;
    __weak IBOutlet UIButton *_btn4;
    
    int _answered;
    int _correct;
    NSSet * _askedQuestion;
    
    NSMutableArray * _charNameList;
    int currentAnswer[4];
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _answered = 0;
        _correct = 0;
        _askedQuestion = [[NSSet alloc] init];
        
        _charNameList = [[NSMutableArray alloc] initWithArray:
        @[@"KA", @"KHA", @"GA", @"NGA",
          @"CHA", @"CHHA", @"JA", @"NYA",
          @"TA", @"THA", @"DA", @"NA",
          @"PA", @"PHA", @"BA", @"MA",
          @"TSA", @"TSHA", @"DZA", @"WA",
          @"ZHA", @"ZA", @"AH", @"YA",
          @"RA", @"LA", @"SHA", @"SA",
          @"HA", @"A"]];
        [self scramble];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self updateImage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onAnswer1Click:(id)sender {
    [self onAnswerClick:0];
}

- (IBAction)onAnswer2Click:(id)sender {
    [self onAnswerClick:1];
}

- (IBAction)onAnswer3Click:(id)sender {
    [self onAnswerClick:2];
}

- (IBAction)onAnswer4Click:(id)sender {
    [self onAnswerClick:3];
}

- (void) onAnswerClick:(int)index {
    
    //_answered++;
    
    UIImageView * img;
    UIButton * btnArr[4] = {_btn1, _btn2, _btn3, _btn4};
    if (currentAnswer[index] == _answered) {
        UIImage * image = [UIImage imageNamed:@"right.png"];
        img = [[UIImageView alloc] initWithImage:image];
        img.center = btnArr[index].center;
        [self.view addSubview:img];
        _correct++;
    } else {
        UIImage * image = [UIImage imageNamed:@"wrong.png"];
        img = [[UIImageView alloc] initWithImage:image];
        img.center = btnArr[index].center;
        [self.view addSubview:img];
    }
    
    for (int i = 0; i < 4; i++)
        [btnArr[i] setEnabled:NO];
    
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
        _answered++;
        
        
        if (_answered < 30) {
            [img removeFromSuperview];
            UIButton * btnArr[4] = {_btn1, _btn2, _btn3, _btn4};
            for (int i = 0; i < 4; i++)
                [btnArr[i] setEnabled:YES];
            [self updateImage];
        } else {
            NSString * message = [NSString stringWithFormat:@"Your score: %d/30", _correct];
            UIAlertView * dlg = [[UIAlertView alloc] initWithTitle:@"Finish!"
                                                           message:message
                                                          delegate:self
                                                 cancelButtonTitle:@"OK"
                                                 otherButtonTitles:nil];
            [dlg show];
        }
    });
    
    [_txtCorrect setText:[NSString stringWithFormat:@"Correct: %d", _correct]];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) updateImage {
    NSString * quizImageName = [[[_charNameList objectAtIndex:_answered] lowercaseString] stringByAppendingString:@"_quiz.png"];
    UIImage * quizImage = [UIImage imageNamed:quizImageName];
    _imgChar.image = quizImage;
    
    currentAnswer[0] = _answered;
    for (int i = 1; i < 4; ) {
        currentAnswer[i] = arc4random() % _charNameList.count;
        
        BOOL flag = YES;
        for (int j = 0; j < i; j++) {
            if (currentAnswer[j] == currentAnswer[i]) {
                flag = NO;
                break;
            }
        }
        
        if (flag)
            i++;
    }
    
    for (int i = 0; i < 100; i++) {
        int pos1 = arc4random() % 4;
        int pos2 = arc4random() % 4;
        int temp = currentAnswer[pos1];
        currentAnswer[pos1] = currentAnswer[pos2];
        currentAnswer[pos2] = temp;
    }
    
    NSString * prefix[4] = {@"A", @"B", @"C", @"D"};
    UIButton * btnArr[4] = {_btn1, _btn2, _btn3, _btn4};
    for (int i = 0; i < 4; i++) {
        NSString * title = [NSString stringWithFormat:@"%@. %@", prefix[i], [_charNameList objectAtIndex:currentAnswer[i]]];
        [btnArr[i] setTitle:title forState: UIControlStateNormal];
    }
    
    [_txtStep setText:[NSString stringWithFormat:@"%d/30", _answered + 1]];
    [_txtCorrect setText:[NSString stringWithFormat:@"Correct: %d", _correct]];
}

- (void) scramble {
    for (int i = 0; i < 100; i++) {
        int pos1 = arc4random() % _charNameList.count;
        int pos2 = arc4random() % _charNameList.count;
        NSString * temp = [_charNameList objectAtIndex:pos1];
        [_charNameList setObject:[_charNameList objectAtIndex:pos2] atIndexedSubscript:pos1];
        [_charNameList setObject:temp atIndexedSubscript:pos2];
    }
}

@end
