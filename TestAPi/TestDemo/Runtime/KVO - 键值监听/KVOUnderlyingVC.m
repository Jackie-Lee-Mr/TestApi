//
//  KVOUnderlyingVC.m
//  TestAPi
//
//  Created by jackie on 2018/5/9.
//  Copyright © 2018年 jackie. All rights reserved.
//

#import "KVOUnderlyingVC.h"

#import "KVO_PeopleModel.h"

@interface KVOUnderlyingVC ()

@end

@implementation KVOUnderlyingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    KVO_PeopleModel *model = [KVO_PeopleModel  new];
    
    model.name = @"jackie";
    
    [model addObserver:self forKeyPath:@"name" options:(NSKeyValueObservingOptionOld|NSKeyValueObservingOptionNew ) context:nil ];
    
    
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    
    
    
    
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
