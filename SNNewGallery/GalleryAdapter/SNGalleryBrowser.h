//
//  SNGalleryBrowser.h
//  SNNewGallery
//
//  Created by H.Ekko on 03/01/2017.
//  Copyright © 2017 Huang Zhen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^GalleryDismissBlock)(UIImage*image, NSInteger index);

@interface SNGalleryBrowser : NSObject

/**
 开始图集浏览 传递对象为NSString 图片的url

 @param imageUrls 将要浏览的图片数组 存储对象为NSString 图片的url
 @param currentImageUrl 当前点击的图片url
 @param currentIndex 当前的index，默认0
 @param fromRect 原图相对屏幕的位置，用于打开动画，默认为屏幕中心
 @param fromView 期望的父视图，如果为nil，则自动设置为UIWindow.main
 @param info 其他信息，用于订制化，可为nil
 @param dismissBlock 关闭图集浏览的回调
 @return 返回一个 SNGalleryBrowser 实例
 */
+ (SNGalleryBrowser *)showGalleryWithImageUrls:(NSArray *)imageUrls
                               currentImageUrl:(NSString *)currentImageUrl
                                  currentIndex:(NSUInteger)currentIndex
                                      fromRect:(CGRect)fromRect
                                      fromView:(UIView *)fromView
                                          info:(NSDictionary *)info
                                  dismissBlock:(GalleryDismissBlock)dismissBlock;


/**
 开始图集浏览 传递对象为UIImage

 @param images 将要浏览的图片数组  存储对象为UIImage
 @param currentImage 当前点击的图片Image对象
 @param currentIndex 当前的index，默认0
 @param fromRect 原图相对屏幕的位置，用于打开动画，默认为屏幕中心
 @param fromView 期望的父视图，如果为nil，则自动设置为UIWindow.main
 @param info 其他信息，用于订制化，可为nil
 @param dismissBlock 关闭图集浏览的回调
 @return 返回一个 SNGalleryBrowser 实例
 */
+ (SNGalleryBrowser *)showGalleryWithImages:(NSArray *)images
                               currentImage:(UIImage *)currentImage
                               currentIndex:(NSUInteger)currentIndex
                                   fromRect:(CGRect)fromRect
                                   fromView:(UIView *)fromView
                                       info:(NSDictionary *)info
                               dismissBlock:(GalleryDismissBlock)dismissBlock;


@end
