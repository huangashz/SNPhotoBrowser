//
//  SNGalleryBrowser.m
//  SNNewGallery
//
//  Created by H.Ekko on 03/01/2017.
//  Copyright © 2017 Huang Zhen. All rights reserved.
//

#import "SNGalleryBrowser.h"
#import "SNGalleryBrowserView.h"
#import "SNGalleryConst.h"
#import "SDImageCache.h"

@interface SNGalleryBrowser (){
    CGRect _endTempFrame;
}

@property (nonatomic, strong) SNGalleryBrowserView * gallery;

@end

@implementation SNGalleryBrowser

#pragma mark - static

+ (SNGalleryBrowser *)showGalleryWithImageUrls:(NSArray *)imageUrls
                               currentImageUrl:(NSString *)currentImageUrl
                                  currentIndex:(NSUInteger)currentIndex
                                      fromRect:(CGRect)fromRect
                                      fromView:(UIView *)fromView
                                          info:(NSDictionary *)info
                                  dismissBlock:(GalleryDismissBlock)dismissBlock
{
    //没有图片可浏览
    if (imageUrls.count <= 0) return nil;
    
    //default value
    NSUInteger p_currentIndex = currentIndex >= imageUrls.count ? 0 : currentIndex;
    
    UIView * p_fromView = fromView ? fromView : [UIApplication sharedApplication].keyWindow;
    
    CGRect p_rect = fromRect;
    if (CGRectIsNull(fromRect)
        || CGRectIsEmpty(fromRect)
        || CGRectIsInfinite(fromRect)) {
        p_rect = CGRectMake(kScreenWidth/2.f,
                            kScreenHeight/2.f,
                            0,
                            0);
    }

    return [self p_showGalleryWithImageUrls:imageUrls currentImageUrl:currentImageUrl currentIndex:p_currentIndex fromRect:p_rect fromView:p_fromView info:info dismissBlock:dismissBlock];
}

+ (SNGalleryBrowser *)p_showGalleryWithImageUrls:(NSArray *)p_imageUrls
                                 currentImageUrl:(NSString *)p_currentImageUrl
                                    currentIndex:(NSUInteger)p_currentIndex
                                        fromRect:(CGRect)p_fromRect
                                        fromView:(UIView *)p_fromView
                                            info:(NSDictionary *)p_info
                                    dismissBlock:(GalleryDismissBlock)p_dismissBlock
{
    SNGalleryBrowserView * gallery = [[SNGalleryBrowserView alloc]
                                      initWithFrame:kScreenRect];
    [gallery setImageUrls:p_imageUrls];
    [gallery setCurrentIndex:p_currentIndex];
    [gallery setCurrentRect:p_fromRect];
    [gallery setInfo:p_info];
    [gallery setDismissBlock:p_dismissBlock];
    
    SNGalleryBrowser * browser = [[SNGalleryBrowser alloc] init];
    [browser setGallery:gallery];
    //animation
    [browser animatedShowfrom:p_fromView fromRect:p_fromRect tapImage:p_currentImageUrl];
    
    return browser;
}


+ (SNGalleryBrowser *)showGalleryWithImages:(NSArray *)images
                               currentImage:(UIImage *)currentImage
                               currentIndex:(NSUInteger)currentIndex
                                   fromRect:(CGRect)fromRect
                                   fromView:(UIView *)fromView
                                       info:(NSDictionary *)info
                               dismissBlock:(GalleryDismissBlock)dismissBlock
{
    //没有图片可浏览
    if (images.count <= 0) return nil;
    
    //default value
    NSUInteger p_currentIndex = currentIndex >= images.count ? 0 : currentIndex;
    
    UIView * p_fromView = fromView ? fromView : [UIApplication sharedApplication].keyWindow;
    
    CGRect p_rect = fromRect;
    if (CGRectIsNull(fromRect)
        || CGRectIsEmpty(fromRect)
        || CGRectIsInfinite(fromRect)) {
        p_rect = CGRectMake(kScreenWidth/2.f,
                            kScreenWidth/2.f,
                            0,
                            0);
    }
    return [self p_showGalleryWithImages:images currentImage:currentImage currentIndex:p_currentIndex fromRect:p_rect fromView:p_fromView info:info dismissBlock:dismissBlock];
}

+ (SNGalleryBrowser *)p_showGalleryWithImages:(NSArray *)p_images
                               currentImage:(UIImage *)p_currentImage
                               currentIndex:(NSUInteger)p_currentIndex
                                   fromRect:(CGRect)p_fromRect
                                   fromView:(UIView *)p_fromView
                                       info:(NSDictionary *)p_info
                               dismissBlock:(GalleryDismissBlock)p_dismissBlock
{
    SNGalleryBrowserView * gallery = [[SNGalleryBrowserView alloc]
                                      initWithFrame:kScreenRect];
    [gallery setImages:p_images];
    [gallery setCurrentIndex:p_currentIndex];
    [gallery setCurrentRect:p_fromRect];
    [gallery setInfo:p_info];
    [gallery setDismissBlock:p_dismissBlock];
    
    SNGalleryBrowser * browser = [SNGalleryBrowser new];
    [browser setGallery:gallery];
    //animation
    [browser animatedShowfrom:p_fromView fromRect:p_fromRect tapImage:p_currentImage];
    return browser;
}



#pragma mark - animated show

/**
 browser 展开动画

 @param fromView 父视图
 @param rect 起始rect
 @param tapImage 点击的image，或者image的url，可兼容。
 */
- (void)animatedShowfrom:(UIView *)fromView fromRect:(CGRect)rect tapImage:(id)tapImage
{
    if (!_gallery || !fromView) {
        return;
    }
    UIImage *tempImage = nil;
    
    if (tapImage && [tapImage isKindOfClass:[UIImage class]]) {
        tempImage = tapImage;
    }else if (tapImage && [tapImage isKindOfClass:[NSString class]]) {
        //传过来url 查下缓存
        tempImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:tapImage];
    }else{
        //既不是url也不是image。
        NSLog(@"SNGalleryBrowser Error : tapped image is nil ! can not do any annimation.");
    }
    
    CGRect endFrame = kScreenRect;
    
    CGFloat ratio = tempImage.size.width / tempImage.size.height;
        
    if (ratio > kScreenRatio) {
        endFrame.size.height = kScreenWidth / ratio;
            
    } else {
        endFrame.size.height = kScreenHeight * ratio;
    }
    endFrame.origin.x = (kScreenWidth - endFrame.size.width) / 2;
    endFrame.origin.y = (kScreenHeight - endFrame.size.height) / 2;
    
    _endTempFrame = endFrame;
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];

    UIImageView * tmpImageView = [[UIImageView alloc] initWithFrame:rect];
    tmpImageView.contentMode = UIViewContentModeScaleAspectFill;
    tmpImageView.clipsToBounds = YES;
    tmpImageView.image = tempImage;
    
    UIView * tmpBackground = [[UIView alloc] initWithFrame:kScreenRect];
    tmpBackground.backgroundColor = [UIColor blackColor];
    [tmpBackground addSubview:tmpImageView];
    [fromView addSubview:tmpBackground];
    
    _gallery.hidden = YES;
    
    [fromView addSubview:_gallery];
    
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        tmpImageView.frame = endFrame;
    } completion:^(BOOL finished) {
        _gallery.hidden = NO;
        [tmpImageView removeFromSuperview];
        [tmpBackground removeFromSuperview];
    }];
}

#pragma mark - private

@end
