//
//  ViewController.m
//  SNNewGallery
//
//  Created by H.Ekko on 03/01/2017.
//  Copyright © 2017 Huang Zhen. All rights reserved.
//

#import "ViewController.h"
#import "UIImageView+WebCache.h"
#import "SNGalleryBrowser.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView * img = [[UIImageView alloc] initWithFrame:CGRectMake(50, 100, 300, 300)];
    img.contentMode = UIViewContentModeScaleAspectFit;

    img.userInteractionEnabled = YES;
    NSURL * url = [NSURL URLWithString:@"http://img.mp.itc.cn/upload/20170103/c4217fd3a059438c98e2ad6787f9f789_th.jpeg"];
    [img sd_setImageWithURL:url completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [[SDImageCache sharedImageCache] storeImage:image forKey:@"http://img.mp.itc.cn/upload/20170103/c4217fd3a059438c98e2ad6787f9f789_th.jpeg" toDisk:YES];
    }];
    [self.view addSubview:img];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImg:)];
    [img addGestureRecognizer:tap];
}

- (void)tapImg:(UIGestureRecognizer *)tap {
    CGRect rect = [tap.view convertRect:tap.view.bounds toView:self.view];
    NSArray * imgUrls = @[@"http://img.mp.itc.cn/upload/20170103/c4217fd3a059438c98e2ad6787f9f789_th.jpeg",@"http://img.mp.itc.cn/upload/20170107/eb32e2c0889541efb47c741f7517a579_th.jpg",@"http://img.mp.itc.cn/upload/20170107/0f0edf09e0474a8294334aaa9364a83a_th.jpg",@"http://img.mp.itc.cn/upload/20170107/7d3e7f5d43fe4b27bdabd7093413f913_th.jpg",@"http://img.mp.itc.cn/upload/20170107/961a8e7399ad4875b29056d596db48b1_th.jpg"];
    [SNGalleryBrowser showGalleryWithImageUrls:imgUrls currentImageUrl:@"http://img.mp.itc.cn/upload/20170103/c4217fd3a059438c98e2ad6787f9f789_th.jpeg" currentIndex:0 fromRect:rect fromView:self.view info:nil dismissBlock:^(UIImage *image, NSInteger index) {
        
    } ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
