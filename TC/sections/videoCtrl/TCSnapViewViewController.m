//
//  TCSnapViewViewController.m
//  TC
//
//  Created by guozw on 16/5/9.
//  Copyright © 2016年 rooten. All rights reserved.
//

#import "TCSnapViewViewController.h"
#import <Masonry/Masonry.h>

@interface TCSnapViewViewController ()
@property(nonatomic,strong)NSURL *strUrl;

@end

@implementation TCSnapViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSFileManager *manger=[NSFileManager defaultManager];

    NSURL *url=[[manger URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask]lastObject];
    
    NSLog(@"%@",url);
    NSURL *urlStr=[url URLByAppendingPathComponent:@"fileName.jpg"];
    NSLog(@"%@",urlStr);
    
    
   // NSLog(@"%@",self.strUrl);
    NSData *data=[NSData dataWithContentsOfURL:urlStr];
    
    UIImage *image=[[UIImage alloc]initWithData:data];
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    UIImageView* imageView=[[UIImageView alloc]initWithImage:image];

    imageView.frame=CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    imageView.contentMode=UIViewContentModeScaleToFill;
    
    imageView.userInteractionEnabled=YES;
    [self.view addSubview:imageView];
    UIButton* button=[UIButton buttonWithType:UIButtonTypeCustom];
    
    button.frame=CGRectMake(20, 20, 100, 50);
    [button setTitle:@"关闭" forState:UIControlStateNormal];
    UIImage *name=[UIImage imageNamed:@"fanhui.png"];
    [button setImage:name forState:UIControlStateNormal];
    [button addTarget:self action:@selector(clickButton) forControlEvents:UIControlEventTouchUpInside];
    
    [imageView addSubview:button];

    
    
   
    
}



-(void)clickButton{
    [self dismissViewControllerAnimated:YES completion:^{
        NSArray *paths=NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *cachesDir=[paths objectAtIndex:0];
        NSFileManager *fileManger=[NSFileManager defaultManager];
        [fileManger removeItemAtPath:cachesDir error:nil];
        if( [self.delegate respondsToSelector:@selector(clickBtn:)]){
            [self.delegate clickBtn:self];
        }
       
        
    }];
    
        
  
    
}
//-(void)TCSnapViewControllerDidTaped:(TCSnapViewViewController*)tc{
//    [self dismissViewControllerAnimated:YES completion:nil];
//    //[self dismissModalViewControllerAnimated:YES];
//}
-(void)dataFilePath
{
    
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
