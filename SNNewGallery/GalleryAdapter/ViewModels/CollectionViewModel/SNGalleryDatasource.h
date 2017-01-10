//
//  SNGalleryDatasource.h
//  SNNewGallery
//
//  Created by H.Ekko on 04/01/2017.
//  Copyright © 2017 Huang Zhen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SNGalleryDatasource : NSObject<UICollectionViewDataSource>

/**
 默认图
 */
@property (nonatomic, strong) UIImage * placeholderImage;

/**
 网络图片的urls
 */
@property (nonatomic, strong) NSArray * imageUrls;

/**
 本地图片的images
 */
@property (nonatomic, strong) NSArray * images;

@end
