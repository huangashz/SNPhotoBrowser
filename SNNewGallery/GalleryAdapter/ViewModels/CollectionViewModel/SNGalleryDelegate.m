//
//  SNGalleryCollectionViewDelegate.m
//  SNNewGallery
//
//  Created by H.Ekko on 04/01/2017.
//  Copyright © 2017 Huang Zhen. All rights reserved.
//

#import "SNGalleryDelegate.h"
#import "SNGalleryConst.h"
#import "SNGalleryBrowserView.h"

@interface SNGalleryDelegate()

@end

@implementation SNGalleryDelegate

#pragma mark <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell isKindOfClass:[SNGalleryPhotoCell class]] && indexPath.row == 0) {
        SNGalleryPhotoCell * photoCell = (SNGalleryPhotoCell *)cell;
        photoCell.delegate = self;
        self.browserView.currentPhotoView = photoCell.photoView;
        self.browserView.currentCell = photoCell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{

}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingSupplementaryView:(UICollectionReusableView *)view forElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath
{

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat offset = scrollView.contentOffset.x;
    NSInteger index = offset/kScreenWidth;
    [self.browserView setCurrentIndex:index];
}

#pragma mark <SNGalleryPhotoCellDelegate>

- (void)photoCellDidResetZoom {
    
}

- (void)photoCellDidZoom:(BOOL)big {
    [self.browserView photoDidZoom:big];
}

- (void)photoCellDidTap {
    [self.browserView dismissAnimatedRect:self.browserView.currentRect];
}

@end
