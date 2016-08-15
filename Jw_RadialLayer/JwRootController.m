//
//  JwRootController.m
//  Jw_ RadialLayer
//
//  Created by chenJw on 16/8/8.
//  Copyright © 2016年 chenJw. All rights reserved.
//

#import "JwRootController.h"
#import <pop/POP.h>
#import "UIView+Extension.h"

@interface JwRootController ()

@property (nonatomic, strong) UIView *aview;

@property (nonatomic, strong) UIButton *button;
@property (nonatomic, assign) BOOL isFrist;
@property (nonatomic, strong) UILabel *lable;

@property (nonatomic, strong) CAShapeLayer *shapeLayer;

@end

@implementation JwRootController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupView2];
    [self setupShapeLayer];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //[self group];
    //[self setupAnimShape];
}

- (void)setupAnimShape{
    
    POPBasicAnimation *shapeAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPShapeLayerStrokeEnd];
    [shapeAnim setCompletionBlock:^(POPAnimation *anim, BOOL finish) {

        if (finish) {
            
            POPBasicAnimation *startAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPShapeLayerStrokeEnd];
            startAnim.toValue = @(1.0);
            startAnim.duration = 1;
            startAnim.removedOnCompletion = NO;
            [self.shapeLayer pop_addAnimation:startAnim forKey:@"startAnim"];
        }
    }];
    shapeAnim.toValue = @(0.0);
    shapeAnim.duration = 1;
    shapeAnim.removedOnCompletion = NO;
    [self.shapeLayer pop_addAnimation:shapeAnim forKey:@"shapeAnim"];
    
}

//通过CAShapeLayer画圈
- (void)setupShapeLayer{
    
    self.shapeLayer = [CAShapeLayer layer];
    CGFloat lineWidth = 2.0f;
    CGFloat radius = self.view.jw_width/2 - lineWidth;
    CGRect rect = CGRectMake(lineWidth/2, lineWidth/2, radius * 2, radius *2);
    UIBezierPath *bez = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius];
    
    self.shapeLayer.strokeColor = [UIColor blueColor].CGColor;
    self.shapeLayer.path = bez.CGPath;
    self.shapeLayer.fillColor = nil;
    self.shapeLayer.lineJoin = kCALineJoinRound;
    self.shapeLayer.lineCap = kCALineCapRound;
    self.shapeLayer.lineWidth = lineWidth;
    
    CAShapeLayer * bgCircle = [CAShapeLayer layer];
    bgCircle.lineWidth = 1.0f;
    bgCircle.strokeStart = 0.0f;
    bgCircle.strokeEnd = 1.0f;
    bgCircle.strokeColor = [UIColor grayColor].CGColor;
    bgCircle.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(lineWidth-1, lineWidth-1, radius*2, radius*2) cornerRadius:radius-lineWidth+1].CGPath;
    bgCircle.lineCap = kCALineCapRound;
    bgCircle.lineJoin = kCALineJoinRound;
    bgCircle.fillColor = nil;
    [self.view.layer addSublayer:bgCircle];

    
    [self.view.layer addSublayer:self.shapeLayer];
}

- (void)setupView2{
    
    self.button = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.button.jw_size = CGSizeMake(200, 40);
    self.button.center = CGPointMake(self.view.jw_centerX, self.view.jw_centerY + 100);
    self.button.layer.cornerRadius = self.button.jw_height/2;
    self.button.layer.masksToBounds = YES;
    self.button.backgroundColor = [UIColor redColor];
    [self.button setTitle:@"anim" forState:(UIControlStateNormal)];
    [self.button addTarget:self action:@selector(buttonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:self.button];
    
    self.lable = [[UILabel alloc] initWithFrame:(CGRectMake(0, 0, 200, 40))];
    self.lable.jw_centerX = self.button.jw_centerX;
    self.lable.jw_bottom = self.button.jw_y - 50;
    self.lable.textAlignment = NSTextAlignmentCenter;
    self.lable.textColor = [UIColor blackColor];
    [self.view addSubview:self.lable];
    
}

- (void)setupView1{
    self.aview = [[UIView alloc] initWithFrame:(CGRectMake(100, 100, 100, 100))];
    self.aview.backgroundColor = [UIColor brownColor];
    [self.view addSubview:self.aview];
    
}

- (void)buttonAction:(UIButton *)button{
    
    //ShapeLayer动画
    [self setupAnimShape];
    
    //button动画
    POPBasicAnimation *butBAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewSize];
    butBAnim.duration = 0.4f;
    butBAnim.toValue = [NSValue valueWithCGSize:(CGSizeMake(40, 40))];
    [butBAnim setCompletionBlock:^(POPAnimation *anim, BOOL finish) {
        
        if (finish) {
            
            POPBasicAnimation *butBAnimf = [POPBasicAnimation animationWithPropertyNamed:kPOPViewSize];
            butBAnimf.duration = 0.4f;
            butBAnimf.toValue = [NSValue valueWithCGSize:(CGSizeMake(200, 40))];
            [self.button pop_addAnimation:butBAnimf forKey:@"butBAnimf"];
        }
    }];
    [self.button pop_addAnimation:butBAnim forKey:@"butBAnim"];
    
    POPBasicAnimation *butCAnim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewBackgroundColor];
    butCAnim.duration = 0.8f;
    if (self.isFrist) {
        butCAnim.toValue = [UIColor redColor];
        self.isFrist = NO;
    }else{
        butCAnim.toValue = [UIColor brownColor];
        self.isFrist = YES;
    }
    [self.button pop_addAnimation:butCAnim forKey:@"butCAnim"];
    
    
    //lable动画
    POPBasicAnimation *labAnim = [POPBasicAnimation animation];
    labAnim.duration = 1;
    POPAnimatableProperty *labProp = [POPAnimatableProperty propertyWithName:@"count" initializer:^(POPMutableAnimatableProperty *prop) {
       
        [prop setReadBlock:^(id obj, CGFloat values[]) {
            values[0] = [[obj description] floatValue];
        }];
        [prop setWriteBlock:^(id obj, const CGFloat values[]) {
            NSString *str = [NSString stringWithFormat:@"%.2f", values[0]];
            [obj setText:[NSString stringWithFormat:@"%@%%", str]];
        }];
        prop.threshold = 0.01;
    }];
    labAnim.property = labProp;
    labAnim.fromValue = @(0.0);
    labAnim.toValue = @(100.0);
    [self.lable pop_addAnimation:labAnim forKey:@"labAnim"];
    
}

//弹性动画
- (void)spring{
    
    POPSpringAnimation *framePOP = [POPSpringAnimation animationWithPropertyNamed:kPOPViewBackgroundColor];
    framePOP.springSpeed = 10.f;
    framePOP.springBounciness = 4.f;
    framePOP.toValue = [UIColor greenColor];
    [framePOP setCompletionBlock:^(POPAnimation *anim, BOOL finsih) {
        if (finsih) {
            NSLog(@"view.fram = %@", NSStringFromCGRect(self.aview.frame));
        }
    }];
    [self.aview pop_addAnimation:framePOP forKey:@"spring"];
    
}

//减缓动画
- (void)decay{
    
    POPDecayAnimation *decay = [POPDecayAnimation animationWithPropertyNamed:kPOPViewFrame];
    decay.velocity = [NSValue valueWithCGRect:(CGRectMake(200, 200, 200, 200))];
    [self.aview pop_addAnimation:decay forKey:@"decay"];
}

//基本动画
- (void)basic{
    
    POPBasicAnimation *basic = [POPBasicAnimation animationWithPropertyNamed:kPOPViewFrame];
    
    basic.toValue = [NSValue valueWithCGRect:(CGRectMake(200, 200, 200, 200))];
    basic.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    //basic.duration = 3.f;
    [basic setCompletionBlock:^(POPAnimation *anim, BOOL finsih) {
       
        if (finsih) {
            NSLog(@"view.frame = %@", NSStringFromCGRect(self.aview.frame));
        }
    }];
    [self.aview pop_addAnimation:basic forKey:@"basic"];
}

//组合动画
- (void)group{
    
    self.aview.transform = CGAffineTransformMakeRotation(M_PI_2/3);
    
    POPBasicAnimation* spring = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    spring.beginTime = CACurrentMediaTime();
    spring.duration = .4f;
    spring.fromValue = [NSNumber numberWithFloat:-100.f];
    spring.toValue = [NSNumber numberWithFloat:CGRectGetMinY(self.aview.frame) + 80];
    [spring setCompletionBlock:^(POPAnimation * ani, BOOL fin) {
    }];
    
    
    POPBasicAnimation* basic = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerRotation];
    basic.beginTime = CACurrentMediaTime();
    basic.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    basic.toValue = [NSNumber numberWithFloat:-M_PI_4];
    basic.duration = .4f;
    
    
    
    POPBasicAnimation* rotation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerRotation];
    rotation.beginTime = CACurrentMediaTime() + .4f;
    rotation.toValue = [NSNumber numberWithFloat:0.f];
    rotation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    rotation.duration = .25f;
    
    
    POPBasicAnimation* donw = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    donw.beginTime = CACurrentMediaTime() + 0.4f;
    donw.toValue = [NSNumber numberWithFloat:CGRectGetMinY(self.aview.frame)];
    donw.duration = .25f;
    donw.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    
    [self.aview.layer pop_addAnimation:spring forKey:@"spring"];
    [self.aview.layer pop_addAnimation:basic forKey:@"basic"];
    [self.aview.layer pop_addAnimation:donw forKey:@"down"];
    [self.aview.layer pop_addAnimation:rotation forKey:@"rotation"];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
