//
//  ViewController.m
//  UMComMutiStyleTextViewDemo
//
//  Created by umeng on 15-3-11.
//  Copyright (c) 2015年 umeng. All rights reserved.
//

#import "ViewController.h"
#import <CoreText/CoreText.h>

@interface ViewController ()<UITextViewDelegate>

@property (nonatomic, strong)  UMComMutiStyleTextView *mutitextView;
@end

@implementation ViewController
{
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.mutitextView = [[UMComMutiStyleTextView alloc]initWithFrame:self.view.bounds];
    self.mutitextView.backgroundColor = [UIColor whiteColor];
//    mutitextView.text = @"人最宝贵的是生命。生命每个人就只有一次。人的一生应当这样度过--当回忆往事的时候，他不会因为虚度光阴而悔恨，也不会因为碌碌无为而感到羞愧。在临死的时候，他能够说：“我的整个生命和全部精力都已经献给了我最敬爱的亲人、最信任的朋友和最热爱的工作！http://news.baidu.com/ns?cl=2&rn=20&tn=news&word=爱情”这是一个账号：@我是一个人 #你是一条狗#，这是一个电话：18911288212，下面可能有几张图片：[ ][ ]可以看看，好看。这里有一个邮箱";

    [self.mutitextView becomeFirstResponder];
    
    self.mutitextView.delegate = self;
    [self.mutitextView setNeedsDisplayInRect:CGRectMake(20, 100, 280, 200)];
    [self.view addSubview:self.mutitextView];
    
    
    
    NSMutableAttributedString * attributedTextString = [[NSMutableAttributedString alloc] initWithString:@"hahahahhahahahhiuhgilgliuglugugguglgjlgjgjgljgjgjuguyguydgasjgfglsa,g和环境的还是觉得还是计划经济健康来了来了健康哈哈哈哈哈哈"];
    
    //设置的是字的颜色
    [attributedTextString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 5)];
    //设置的是字的背景颜色
    [attributedTextString addAttribute:NSBackgroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(0, 5)];
    
    //设置的时字的字体及大小
    [attributedTextString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial" size:16] range:NSMakeRange(0, 5)];
//   attributedTextString = [UMComMutiStyleTextView createAttributedStringWithText:@"hahahahhahahahhiuhgilgliuglugugguglgjlgjgjgljgjgjuguyguydgasjgfglsa,g和环境的还是觉得还是计划经济健康来了来了健康哈哈哈哈哈哈" font:[UIFont systemFontOfSize:23] lineSpace:12];
    
    UIFont *font = [UIFont systemFontOfSize:23];
    //设置字体
    CTFontRef fontRef = CTFontCreateWithName((__bridge CFStringRef)font.fontName, font.pointSize, NULL);
    [attributedTextString addAttribute:(NSString*)kCTFontAttributeName value:(__bridge id)fontRef range:NSMakeRange(0,attributedTextString.length)];
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc]init];
    style.lineSpacing = 12;
    style.lineBreakMode = NSLineBreakByCharWrapping;
    style.headIndent = 50;
    style.paragraphSpacing = 120;
    [attributedTextString addAttribute:(id)kCTParagraphStyleAttributeName value:style range:NSMakeRange(0, [attributedTextString length])];
     self.mutitextView.attributedText = attributedTextString;
    
    
    // Do any additional setup after loading the view, typically from a nib.
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
//    mutitextView.originString = textView.text;
//    range = textView.selectedRange;
//    textView.selectedRange = NSMakeRange(mutitextView.originString.length, 0);
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    NSLog(@"%@",textView.attributedText.string);
    NSMutableAttributedString *attributedTextString  = [[NSMutableAttributedString alloc]initWithAttributedString:textView.attributedText];
    //设置的是字的背景颜色
    [attributedTextString addAttribute:NSBackgroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(0, attributedTextString.length-12)];
    
    //设置的时字的字体及大小
    [attributedTextString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"Arial" size:11] range:NSMakeRange(0, attributedTextString.length - 20)];
    textView.attributedText = attributedTextString;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
