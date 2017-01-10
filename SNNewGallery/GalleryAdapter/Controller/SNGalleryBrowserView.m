//
//  SNGalleryBrowserView.m
//  SNNewGallery
//
//  Created by H.Ekko on 03/01/2017.
//  Copyright © 2017 Huang Zhen. All rights reserved.
//

#import "SNGalleryBrowserView.h"
#import "SNGalleryDelegate.h"
#import "SNGalleryDatasource.h"
#import "SNGalleryConst.h"

#define  kDistance      (250.f)

@interface SNGalleryBrowserView (){
    NSIndexPath *_zoomingIndexPath;
    CGRect _originalRect;
    BOOL _photoDidZoom;
}

@property (nonatomic, strong) UICollectionView * collectionView;

@property (nonatomic, strong) SNGalleryDelegate * collectionDelegate;

@property (nonatomic, strong) SNGalleryDatasource * collectionDatasource;

@end

@implementation SNGalleryBrowserView

#pragma mark - public method

- (void)setImages:(NSArray *)images {
    if (!self.collectionDatasource) {
        self.collectionDatasource = [SNGalleryDatasource new];
    }
    self.collectionDatasource.images = images;
}

- (void)setImageUrls:(NSArray *)imageUrls {
    if (!self.collectionDatasource) {
        self.collectionDatasource = [SNGalleryDatasource new];
    }
    self.collectionDatasource.imageUrls = imageUrls;
}

#pragma mark - private method

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame: frame]) {
        
        self.backgroundColor = [UIColor blackColor];
        
        self.currentIndex = 0;
        
        [self configCollectionView];
        
        [self configDelegateAndDatasource];
        
        [self addCloseGesture];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadForScreenRotate) name:UIDeviceOrientationDidChangeNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(photoCellDidZooming:) name:kPhotoCellDidZommingNotification object:nil];
        
    }
    return self;
}

- (void)configCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
    layout.itemSize = CGSizeMake(kScreenRect.size.width + 10, kScreenRect.size.height);
    
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(-5, 0, self.frame.size.width + 10 , self.frame.size.height) collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.pagingEnabled = YES;
    collectionView.showsHorizontalScrollIndicator = NO;
    
    [collectionView registerClass:[SNGalleryPhotoCell class]
       forCellWithReuseIdentifier:SNGalleryPhotoCellReuseIdentifier];
    [collectionView registerClass:[SNGalleryAdCell class]
       forCellWithReuseIdentifier:SNGalleryAdCellReuseIdentifier];
    [collectionView registerClass:[SNGalleryRecommendCell class]
       forCellWithReuseIdentifier:SNGalleryRecommendCellReuseIdentifier];
    
    self.collectionView = collectionView;
    [self addSubview:collectionView];
}

- (void)configDelegateAndDatasource {
    self.collectionDelegate = [[SNGalleryDelegate alloc] init];
    self.collectionDelegate.browserView = self;
    self.collectionView.delegate = self.collectionDelegate;
    
    self.collectionDatasource = [[SNGalleryDatasource alloc] init];
    self.collectionView.dataSource = self.collectionDatasource;
}

- (void)setCurrentIndex:(NSUInteger)currentIndex {
    _currentIndex = currentIndex;
    UICollectionViewCell * cell = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:_currentIndex inSection:0]];
    if ([cell isKindOfClass:[SNGalleryPhotoCell class]]) {
        SNGalleryPhotoCell * photoCell = (SNGalleryPhotoCell *)cell;
        photoCell.delegate = self.collectionDelegate;
        self.currentPhotoView = photoCell.photoView;
        self.currentCell = cell;
    }
}

- (void)photoDidZoom:(BOOL)big {
    _photoDidZoom = big;
}

/**
 拖拽关闭图片浏览器
 */
- (void)addCloseGesture {
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]
                                    initWithTarget:self
                                    action:@selector(handlePan:)];
    pan.maximumNumberOfTouches = 1;
    [self addGestureRecognizer:pan];
}

- (void)handlePan:(UIPanGestureRecognizer *)pan {
    //如果没有当前的imageView
    if (!self.currentPhotoView) {
        NSLog(@"SNGalleryBrowserView Error : current imageView is nil, can't pan to close.");
        return;
    }
    if (_photoDidZoom) {
        return;
    }
    CGPoint translation = [pan translationInView:pan.view];

    if (pan.state == UIGestureRecognizerStateBegan) {
        _originalRect = self.currentPhotoView.frame;
    }
    else if (pan.state == UIGestureRecognizerStateEnded ||
        pan.state == UIGestureRecognizerStateCancelled) {
        
        //达到拖拽的最大限度 执行消失动画 关闭图集浏览器
        if (translation.y > kDistance) {
            [self dismissAnimated];
            return;
        }
        
        [UIView animateWithDuration:0.25 animations:^{
            self.currentPhotoView.transform = CGAffineTransformIdentity;
            self.currentPhotoView.frame = _originalRect;
            self.backgroundColor = [UIColor colorWithWhite:0 alpha:1];
        }];
        return;
    }
    
    //不允许向上拖拽
    if (translation.y <= 0) {
        return;
    }
//    NSLog(@"translation.x : %f || translation.y : %f",translation.x,translation.y);

    CGFloat alpha = (kDistance - translation.y * 0.5)/kDistance;
    self.backgroundColor = [UIColor colorWithWhite:0 alpha:alpha];
    self.currentPhotoView.transform = CGAffineTransformMakeTranslation(translation.x * 0.4, translation.y * 0.8);
    
    CGFloat scale = (kDistance - translation.y * 0.2)/kDistance;
    self.currentPhotoView.transform = CGAffineTransformScale(self.currentPhotoView.transform,scale,scale);
}

- (void)dismissAnimated {
    [UIView animateWithDuration:0.25 animations:^{
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        self.currentPhotoView.frame = self.currentRect;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
        self.dismissBlock(self.currentPhotoView.image,self.currentIndex);
    }];
}

- (void)reloadForScreenRotate {
    self.collectionView.frame = kScreenRect;
    [self.collectionView reloadData];
    self.collectionView.contentOffset = CGPointMake(kScreenWidth * _currentIndex,0);
}

- (void)photoCellDidZooming:(NSNotification *)nofit {
    NSIndexPath *indexPath = nofit.object;
    _zoomingIndexPath = indexPath;
}

@end
