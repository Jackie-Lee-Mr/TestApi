//
//  ViewController.m
//  TestAPi
//
//  Created by jackie on 2018/3/18.
//  Copyright © 2018年 jackie. All rights reserved.
//
 #import "ViewController.h"
#import "YYFPSLabel.h"
@interface ViewController (){
    
    YYFPSLabel*  _fpsLabel;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _fpsLabel = [YYFPSLabel new];
    [_fpsLabel sizeToFit];
    _fpsLabel.backgroundColor = [UIColor redColor];
    
    _fpsLabel.alpha = 1;
    [self.view addSubview:_fpsLabel];
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicator.size = CGSizeMake(80, 80);
    indicator.center = CGPointMake(self.view.width / 2, self.view.height / 2);
    indicator.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.670];
    indicator.clipsToBounds = YES;
    indicator.layer.cornerRadius = 6;
    [indicator startAnimating];
    [self.view addSubview:indicator];
    
    dispatch_async(dispatch_queue_create("LoadingRequest", DISPATCH_QUEUE_CONCURRENT), ^{
       
        [NSThread sleepForTimeInterval:20];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [indicator removeFromSuperview];
        });
        
        
    }); 
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
    UITouch *touch = [touches anyObject];
    
    if ([touch.view isEqual:self.view]) {
        NSOperationTestVC *operationVC = [[NSOperationTestVC alloc] init];
        
        [self.navigationController pushViewController:operationVC animated:YES];
    }
    
    
//    GCDTestVC *gcdVC = [[GCDTestVC alloc]init];
  
    
}

@end
