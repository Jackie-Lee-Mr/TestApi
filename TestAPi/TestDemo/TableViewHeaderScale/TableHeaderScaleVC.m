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
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) NSArray *dataArray;

@property (weak, nonatomic) UILabel *indicatorView;
@property (weak, nonatomic) UIView *scrollIndicator;

@property (nonatomic, assign) CGFloat  tempTableViewContentOffsetY;

@end

//@synchronized
//@dynamic

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    _fpsLabel = [YYFPSLabel new];
    [_fpsLabel sizeToFit];
    _fpsLabel.backgroundColor = [UIColor redColor];
    
    _fpsLabel.alpha = 1;
    [self.view addSubview:_fpsLabel];
    
//    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
//    indicator.size = CGSizeMake(80, 80);
//    indicator.center = CGPointMake(self.view.width / 2, self.view.height / 2);
//    indicator.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.670];
//    indicator.clipsToBounds = YES;
//    indicator.layer.cornerRadius = 6;
//    [indicator startAnimating];
//    [self.view addSubview:indicator];
//
//    dispatch_async(dispatch_queue_create("LoadingRequest", DISPATCH_QUEUE_CONCURRENT), ^{
//
//        dispatch_async(dispatch_get_main_queue(), ^{
//
//            [indicator removeFromSuperview];
//        });
//
//
//    });
    
    [self.tableView registerClass: [UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    self.dataArray = @[@"RouterDemoController",
                       @"KVOUnderlyingVC",
                       @"KVCUnderlyingVC",
                       @"RuntimeVC",
                       @"MessageSendVC",
                       @"DataTaskTestVC",
                       @"NSURLConnectionTestVC",
                       @"NSOperationTestVC",
                       @"GCDTestVC",
                       @"RunLoopVC",
                       @"MVP_VC",
                       @"CrashVC",
                       @"ResponderVC"
                       
                       ];
    
    [self.tableView reloadData];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
 

#pragma mark ****************  tableView delagate method  ************************

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{ 
    
    return self.dataArray.count;
}

-(UITableViewCell* )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    cell.textLabel.text = self.dataArray[indexPath.row];
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *vcName = self.dataArray[indexPath.row];
    
    NSLog(@"%@",vcName);
    
    Class vcClass = NSClassFromString(vcName);
    
    UIViewController *VC = [[vcClass alloc] initWithNibName:vcName bundle:nil];  
 
    [self.navigationController pushViewController:VC animated:YES];
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    UITableView *tableView = (UITableView *)scrollView;

    // 在这里根据_verticalScrollIndicator的中点，来获取对应的cell行号，从而可以获取对应行的数据来进行显示
    self.indicatorView.text = [NSString stringWithFormat:@"%ld", [tableView indexPathForRowAtPoint:self.scrollIndicator.center].row];

//    if (self.tempTableViewContentOffsetY > scrollView.contentOffset.y) {
//
//        [self.navigationController setNavigationBarHidden:YES animated:YES];
//
//    }else{
//
//         [self.navigationController setNavigationBarHidden:NO animated:YES];
//    }
     self.tempTableViewContentOffsetY = scrollView.contentOffset.y;
    
    
    //scrollView已经有拖拽手势，直接拿到scrollView的拖拽手势
//    UIPanGestureRecognizer *pan = scrollView.panGestureRecognizer;
//    //获取到拖拽的速度 >0 向下拖动 <0 向上拖动
//    CGFloat velocity = [pan velocityInView:scrollView].y;
//
//    if (velocity <- 5) {
//        //向上拖动，隐藏导航栏
//        self.tabBarController.tabBar.hidden = YES;
//        [self.navigationController setNavigationBarHidden:YES animated:YES];
//    }else if (velocity > 5) {
//        //向下拖动，显示导航栏
//        self.tabBarController.tabBar.hidden = NO;
//        [self.navigationController setNavigationBarHidden:NO animated:YES];
//    }else if(velocity == 0){
//        //停止拖拽
//    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
 
    if (velocity.y > 0.0) {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    } else if (velocity.y < 0.0){
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
}


//
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    // 这里注意要在点击时获取，如果在view加载完成时设置标签索引的中点，那么获取的_verticalScrollIndicator的frame是不对的
    if (!self.indicatorView) {
        self.scrollIndicator = [self.tableView valueForKey:@"verticalScrollIndicator"];

        UILabel *indicatorView = [[UILabel alloc] initWithFrame:CGRectMake(-50, 0, 50, 20)];
        indicatorView.backgroundColor = [UIColor orangeColor];

        CGPoint center = indicatorView.center;
        center.y = self.scrollIndicator.bounds.size.height * 0.5;
        indicatorView.center = center;

        [self.scrollIndicator addSubview:indicatorView];
        self.indicatorView = indicatorView;
    }

}



@end
