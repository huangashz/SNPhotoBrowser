//
//  SNGalleryBrowserView.h
//  SNNewGallery
//
//  Created by H.Ekko on 03/01/2017.
//  Copyright © 2017 Huang Zhen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SNGalleryBrowser.h"

@interface SNGalleryBrowserView : UIView

/**
 图片浏览器关闭的回调
 */
@property (nonatomic, copy) GalleryDismissBlock dismissBlock;

/**
 打开图片浏览器时当前的index
 */
@property (nonatomic, assign) NSUInteger currentIndex;

/**
 打开图片浏览器时当前的rect
 */
@property (nonatomic, assign) CGRect currentRect;

/**
 用于其他未定义的消息传递
 */
@property (nonatomic, strong) NSDictionary * info;


/**
 当前用于关闭动画的imageView
 */
@property (nonatomic, strong) UIImageView * currentPhotoView;

/**
 当前页的cell
 */
@property (nonatomic, strong) UICollectionViewCell * currentCell;

/**
 给图片浏览器设置网络图片数据源

 @param imageUrls 存放图片`url:NSString`的数组
 */
- (void)setImageUrls:(NSArray *)imageUrls;

/**
 给图片浏览器设置本地图片数据源

 @param images 存放`UIImage`对象的数组
 */
- (void)setImages:(NSArray *)images;

/**
 关闭图集浏览
 */
- (void)dismissAnimatedRect:(CGRect)endRect;

/**
 photo zoom的代理
 */
- (void)photoDidZoom:(BOOL)big;

@end
