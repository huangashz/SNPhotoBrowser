//
//  SNGalleryDelegate.h
//  SNNewGallery
//
//  Created by H.Ekko on 04/01/2017.
//  Copyright © 2017 Huang Zhen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SNGalleryPhotoCell.h"

@class SNGalleryBrowserView;
@interface SNGalleryDelegate : NSObject<UICollectionViewDelegate,SNGalleryPhotoCellDelegate>

@property (nonatomic, weak) SNGalleryBrowserView * browserView;

@end
