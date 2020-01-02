//
//  SBKTextView.m
//  SoraBeKetaba
//
//  Created by Mokhlas Hussein on 20/09/15.
//  Copyright © 2015 iMokhles. All rights reserved.
//

#import "SBKTextView.h"

@implementation SBKTextViewObject
+ (instancetype)textObjectWithString:(NSString *)textString font:(UIFont *)textFont color:(UIColor *)color {
    SBKTextViewObject *textObject = [[SBKTextViewObject alloc] init];
    textObject.text = textString;
    textObject.font = textFont;
    textObject.textColor = color;
    return textObject;
}
- (BOOL)isEqual:(id)object {
    if ([object isKindOfClass:[SBKTextViewObject class]]) {
        return [((SBKTextViewObject *)object).text isEqualToString:_text];
    }
    
    return NO;
}
@end

@interface SBKTextView () {
    UIPanGestureRecognizer *panGesture;
}
@property (nonatomic, strong) SBKTextViewObject *currentObject;
@property (nonatomic, copy) void (^completion)();
@end

@implementation SBKTextView

- (id)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.shineLabel = [[UILabel alloc] init];
        [self.shineLabel setNumberOfLines:0];
        [self.shineLabel setBackgroundColor:[UIColor clearColor]];
        [self addSubview:self.shineLabel];
        panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveLabelView:)];
        [self addGestureRecognizer:panGesture];
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapFrom:)];
        [self addGestureRecognizer:tapGestureRecognizer];
    }
    return self;
}
- (void)addTextObject:(SBKTextViewObject *)textObject
{
    _currentObject = textObject;
    [self.shineLabel setText:_currentObject.text];
    [self.shineLabel setFont:_currentObject.font];
    [self.shineLabel setTextColor:_currentObject.textColor];
    [self layoutSubviews];
}


- (void)handleTapFrom:(UITapGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateEnded) {
        CGPoint pointGesture = [gesture locationInView:[gesture.view superview]];
        self.tappedAction(pointGesture, self);
    }
    
}

- (void)moveLabelView:(UIPanGestureRecognizer *)sender {
    CGPoint translation = [sender translationInView:self.superview];
    sender.view.center = CGPointMake(sender.view.center.x+translation.x, sender.view.center.y+translation.y);
    [sender setTranslation:CGPointMake(0, 0) inView:self.superview];
}

- (void)setDraggable:(BOOL)draggable {
    [panGesture setEnabled:draggable];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    float width = _currentObject.text.length*10;
    if (width > [UIScreen mainScreen].bounds.size.width) {
        width = 310;
    }
    float height = [TWBEnhancer9Helper heightForText:_currentObject.text withFont:_currentObject.font];
    CGRect frame = CGRectMake(0, [[UIScreen mainScreen] bounds].size.height-height, width, height+20);
    self.frame = frame;
    [_shineLabel setFrame:CGRectMake(4, 0, self.frame.size.width-4, self.frame.size.height-10)];
}

@end
