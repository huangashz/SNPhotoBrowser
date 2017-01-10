//
//  SNGalleryPhotoCell.m
//  SNNewGallery
//
//  Created by H.Ekko on 04/01/2017.
//  Copyright © 2017 Huang Zhen. All rights reserved.
//

#import "SNGalleryPhotoCell.h"
#import "SNGalleryConst.h"
#import "UIImageView+WebCache.h"
#import "SNRingSpinnerView.h"

#define kMaxZoom        2.5
#define kMinZoom        1

@interface SNGalleryPhotoCell()<UIScrollViewDelegate>
{
    CGFloat _currentScale;
    BOOL _isDoubleTapingForZoom;
    CGFloat _touchX;
    CGFloat _touchY;
}

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) SNRingSpinnerView * ringSpinner;

@end

@implementation SNGalleryPhotoCell

#pragma mark - public

- (void)resetZoomingScale {
    if (self.scrollView.zoomScale != kMinZoom) {
        self.scrollView.zoomScale = kMinZoom;
        _currentScale = kMinZoom;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(photoCellDidResetZoom)]) {
        [self.delegate photoCellDidResetZoom];
    }
}

- (void)loadImageWithUrl:(NSString *)urlString {
    if (![urlString isKindOfClass:[NSString class]] || urlString.length <= 0) {
        return;
    }
    if (!self.ringSpinner) {
        self.ringSpinner = [[SNRingSpinnerView alloc] initWithFrame:CGRectMake(0, 0, 32.5, 32.5)];
    }
    self.ringSpinner.center = self.contentView.center;
    [self.scrollView addSubview:self.ringSpinner];
    [self.ringSpinner startAnimating];

    self.photoView.image = self.placeholderImage;
    NSURL *url = [NSURL URLWithString:urlString];
    [self.photoView sd_setImageWithURL:url placeholderImage:self.placeholderImage options:SDWebImageCacheMemoryOnly | SDWebImageProgressiveDownload | SDWebImageRefreshCached progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        if (receivedSize == expectedSize) {
            [self.ringSpinner stopAnimating];
            [self.ringSpinner removeFromSuperview];
            self.ringSpinner = nil;
        }
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.photoView.image = image;
        [self changeImageViewFrame];
    }];
}

#pragma mark - private

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self initContent];
        [self addGestureRecognizer];
    }
    return self;
}

- (void)initContent {
    self.scrollView = [[UIScrollView alloc] init];
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.maximumZoomScale = kMaxZoom;
    self.scrollView.minimumZoomScale = kMinZoom;
    self.scrollView.delegate = self;
    [self addSubview:self.scrollView];
    
    self.photoView = [[UIImageView alloc] init];
    self.photoView.backgroundColor = [UIColor clearColor];
    self.photoView.contentMode = UIViewContentModeScaleAspectFit;
    [self.scrollView addSubview:self.photoView];
    
}

- (void)addGestureRecognizer {
    //双击放大缩小
    UITapGestureRecognizer * twiceTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(twiceTapping:)];
    twiceTap.numberOfTapsRequired = 2;
    [self addGestureRecognizer:twiceTap];
    
    //单击事件
    UITapGestureRecognizer * onceTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onceTapping:)];
    onceTap.numberOfTapsRequired = 1;
    [self addGestureRecognizer:onceTap];
    [onceTap requireGestureRecognizerToFail:twiceTap];
}

- (void)twiceTapping:(UIGestureRecognizer *)getsure {
    if ([getsure isKindOfClass:[UITapGestureRecognizer class]]) {
        UITapGestureRecognizer * tap = (UITapGestureRecognizer *)getsure;
        _touchX = [tap locationInView:tap.view].x;
        _touchY = [tap locationInView:tap.view].y;
        _isDoubleTapingForZoom = YES;
        if (_currentScale > kMinZoom) {
            [self.scrollView setZoomScale:kMinZoom animated:YES];
            _currentScale = kMinZoom;
        }else{
            [self.scrollView setZoomScale:kMaxZoom animated:YES];
            _currentScale = kMaxZoom;
        }
    }
    _isDoubleTapingForZoom = NO;
}

- (void)onceTapping:(UITapGestureRecognizer *)getsure {
    if (self.delegate && [self.delegate respondsToSelector:@selector(photoCellDidTap)]) {
        [self.delegate photoCellDidTap];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.scrollView.frame = CGRectMake(5, 0, self.bounds.size.width - 10, self.bounds.size.height);
    self.photoView.frame = self.scrollView.bounds;
}

#pragma mark - scrollerView

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.photoView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale {
    [[NSNotificationCenter defaultCenter] postNotificationName:kPhotoCellDidZommingNotification object:self.indexPath];
    if (scale < kMinZoom) {
        [scrollView setZoomScale:kMinZoom animated:YES];
        _currentScale = kMinZoom;
    }else{
        _currentScale = scale;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(photoCellDidZoom:)]) {
        [self.delegate photoCellDidZoom:_currentScale > kMinZoom];
    }
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width) ? (scrollView.bounds.size.width - scrollView.contentSize.width)/2.f : 0.f;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height) ? (scrollView.bounds.size.height - scrollView.contentSize.height)/2.f : 0.f;
    _photoView.center = CGPointMake(scrollView.contentSize.width*.5f + offsetX, scrollView.contentSize.height/2.f + offsetY);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
}

#pragma mark - tool
//根据图片和屏幕尺寸的宽高来决定_photoView的宽和高
- (void)changeImageViewFrame
{
    if (!_photoView.image)
    {
        return;
    }
    
    CGRect pictureRect = _photoView.frame;
    pictureRect.size = _photoView.image.size;
    
    if (_photoView.image.size.height <= _scrollView.frame.size.height && _photoView.image.size.width <= _scrollView.frame.size.width)
    {
        _photoView.frame = pictureRect;
        _photoView.center = CGPointMake(_scrollView.frame.size.width/2.f, _scrollView.frame.size.height/2.f);
        _scrollView.contentSize = _photoView.frame.size;
    }
    else if (_photoView.image.size.height > _scrollView.frame.size.height && _photoView.image.size.width <= _scrollView.frame.size.width)
    {
        int image_x = (_scrollView.frame.size.width -_photoView.image.size.width)/2.f;
        pictureRect.origin.x = 0.f + image_x;
        pictureRect.origin.y = 0.f;
        _photoView.frame = pictureRect;
        _scrollView.contentSize =_photoView.image.size;
        _scrollView.contentOffset = CGPointMake(0.f, 0.f);
        
    }
    else if (_photoView.image.size.height <= _scrollView.frame.size.height && _photoView.image.size.width > _scrollView.frame.size.width)
    {
        pictureRect.size.width = _scrollView.frame.size.width;
        pictureRect.size.height = pictureRect.size.width * _photoView.image.size.height / _photoView.image.size.width;
        _photoView.frame = pictureRect;
        _photoView.center = CGPointMake(_scrollView.frame.size.width/2.f, _scrollView.frame.size.height/2.f);
    }
    else
    {
        pictureRect.origin.x = 0.f;
        pictureRect.origin.y = 0.f;
        pictureRect.size.width = _scrollView.frame.size.width ;
        pictureRect.size.height = pictureRect.size.width * _photoView.image.size.height / _photoView.image.size.width;
        _photoView.frame = pictureRect;
        
        if (pictureRect.size.height < _scrollView.frame.size.height)
        {
            _photoView.center = CGPointMake(_scrollView.frame.size.width/2.f, _scrollView.frame.size.height/2.f);
        }
        
        _scrollView.contentSize = _photoView.frame.size;
        _scrollView.contentOffset = CGPointMake(0.f, 0.f);
    }
}


@end
