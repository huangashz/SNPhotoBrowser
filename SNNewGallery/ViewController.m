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

@interface ViewController (){
    NSArray * _imgUrls;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _imgUrls = @[@"http://img.mp.itc.cn/upload/20170103/c4217fd3a059438c98e2ad6787f9f789_th.jpeg",
                            @"http://img.mp.itc.cn/upload/20170107/eb32e2c0889541efb47c741f7517a579_th.jpg",
                            @"http://img.mp.itc.cn/upload/20170107/0f0edf09e0474a8294334aaa9364a83a_th.jpg",
                            @"http://img.mp.itc.cn/upload/20170107/7d3e7f5d43fe4b27bdabd7093413f913_th.jpg",
                            @"http://img.mp.itc.cn/upload/20170107/961a8e7399ad4875b29056d596db48b1_th.jpg"];
    
    CGFloat imgWidth    = 80.0;
    CGFloat imgHeight   = 80.0;
    int countInrow  = 3;
    CGFloat space   = 10;
    CGFloat left_space  = ([UIScreen mainScreen].bounds.size.width - countInrow * imgWidth - space * (countInrow - 1))/2.f;
    int i = 0;
    for (NSString * urlstring in _imgUrls) {
        UIImageView * img = [[UIImageView alloc] initWithFrame:CGRectMake(left_space + i%countInrow * (space+imgWidth), 100 + i/countInrow * (space+imgHeight), imgWidth, imgHeight)];
        img.contentMode = UIViewContentModeScaleAspectFill;
        img.clipsToBounds = YES;
        img.userInteractionEnabled = YES;
        img.tag = i;
        NSURL * url = [NSURL URLWithString:urlstring];
        [img sd_setImageWithURL:url completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            [[SDImageCache sharedImageCache] storeImage:image forKey:url.absoluteString toDisk:YES];
        }];
        [self.view addSubview:img];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImg:)];
        [img addGestureRecognizer:tap];
        i++;
    }
    
}

- (void)tapImg:(UIGestureRecognizer *)tap {
    
    CGRect rect = [tap.view convertRect:tap.view.bounds toView:self.view];
    [SNGalleryBrowser showGalleryWithImageUrls:_imgUrls currentImageUrl:_imgUrls[tap.view.tag] currentIndex:tap.view.tag fromRect:rect fromView:self.view info:nil dismissBlock:^(UIImage *image, NSInteger index) {
        
    } ];
}

@end
