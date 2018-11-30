//
//  YSMHeaderView.m
//  YSMContainerView
//
//  Created by duanzengguang on 2018/11/19.
//

#import "YSMHeaderView.h"

@interface YSMHeaderView ()

@property (nonatomic, strong) UIView * titleView;
@property (nonatomic, strong) NSMutableArray<UILabel *>* titleLabels;

@end

@implementation YSMHeaderView{
    NSInteger _currentIndex;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initialization];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self initialization];
    }
    return self;
}

- (void)initialization{
    [self addSubview:self.titleView];
}

- (void)setTitles:(NSMutableArray<NSString *> *)titles{
    _titles = titles;
    self.titleLabels = [NSMutableArray arrayWithCapacity:titles.count];
    [self setupSubViews];
}

- (void)setupSubViews{
    UIButton * titleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [titleButton setImage:[UIImage imageNamed:@"capture_shoot_cancel"] forState:UIControlStateNormal];
    [titleButton setTitle:@"所有照片" forState:UIControlStateNormal];
    titleButton.frame = CGRectMake(self.frame.size.width/2-(self.frame.size.width/3/2), 10, self.frame.size.width/3, 30);
    [titleButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [titleButton setTitleEdgeInsets:UIEdgeInsetsMake(0, - titleButton.imageView.image.size.width, 0, titleButton.imageView.image.size.width)];
    [titleButton setImageEdgeInsets:UIEdgeInsetsMake(0, titleButton.titleLabel.bounds.size.width, 0, -titleButton.titleLabel.bounds.size.width)];
    [self.titleView addSubview:titleButton];
    
    CGFloat titleWidth = self.frame.size.width/self.titles.count;
    CGSize titleSize = CGSizeMake(titleWidth, self.titleView.frame.size.height);
    [self.titles enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGRect frame = {CGPointMake(idx*titleWidth, 25),titleSize};
        UILabel * label = [[UILabel alloc] initWithFrame:frame];
        label.text = obj;
        label.userInteractionEnabled = YES;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont systemFontOfSize:12];
        label.tag = idx;
        [self.titleLabels addObject:label];
        [self.titleView addSubview:label];
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(titleLabelDidTap:)];
        [label addGestureRecognizer:tap];
        if (idx == 0) {
            self->_currentIndex = 0;
            label.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.3, 1.3);
        }
    }];
}


- (void)titleLabelDidTap:(UITapGestureRecognizer *)tap{
    NSInteger selectIndex = tap.view.tag;
    if (self.delegate && [self.delegate respondsToSelector:@selector(headerView:didSelectTitleAtIndex:)]) {
        [self.delegate headerView:self didSelectTitleAtIndex:selectIndex];
    }
    [self didSelectTitleIndex:selectIndex];
}

- (void)didSelectTitleIndex:(NSInteger)selectIndex{
    UILabel *currentLabel = self.titleLabels[_currentIndex];
    currentLabel.transform = CGAffineTransformIdentity;
    
    UILabel * selectLabel = self.titleLabels[selectIndex];
    selectLabel.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.3, 1.3);
    _currentIndex = selectIndex;
}

- (UIView *)titleView{
    if (_titleView == nil) {
        _titleView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame)-90, CGRectGetWidth(self.frame), 90)];
        _titleView.backgroundColor = [UIColor blackColor];
        _titleView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    }
    return _titleView;
}

@end
