//
//  SNGalleryDatasource.m
//  SNNewGallery
//
//  Created by H.Ekko on 04/01/2017.
//  Copyright © 2017 Huang Zhen. All rights reserved.
//

#import "SNGalleryDatasource.h"
#import "SNGalleryConst.h"

@interface SNGalleryDatasource ()

@end

@implementation SNGalleryDatasource

#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSInteger count = 0;
    if (self.imageUrls) {
        count = self.imageUrls.count;
    }
    else if (self.images) {
        count = self.images.count;
    }
    //有广告或者推荐的情况
    if (/* DISABLES CODE */ (0)) {
        count += 1;
    }
    return count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SNGalleryPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SNGalleryPhotoCellReuseIdentifier forIndexPath:indexPath];
    cell.indexPath = indexPath;
    cell.placeholderImage = self.placeholderImage;
    [cell resetZoomingScale];
    if (self.imageUrls) {
        [cell loadImageWithUrl:self.imageUrls[indexPath.row]];

    }
    else if (self.images) {
        cell.photoView.image = self.images[indexPath.row];
    }
    return cell;
}

@end
