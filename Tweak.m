#define brightColor [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.85]
#define darkColor   [UIColor blackColor]



@interface RoundTriangle: UIView
@property (retain, nonatomic) UIColor *fillColor;
@end

@interface SleepTimerBubbleExpander: UIView {
    RoundTriangle *_triangle;
}
@property (retain, nonatomic) UIDatePicker *_pickerView;
- (void)setDarkUI;
- (void)colorButtons;
@end


%hook SleepTimerBubbleExpander

- (id)initWithFrame:(struct CGRect)arg1 andCurrentSleepTime:(id)arg2 andButtonLoc:(float)arg3 {
	id _self = %orig;
	[self setDarkUI];
	return _self;
}
- (id)initWithFrame:(struct CGRect)arg1 {
	id _self = %orig;
	[self setDarkUI];
	return _self;
}

%new
- (void)setDarkUI {
	RoundTriangle *triangle = MSHookIvar<RoundTriangle *>(self, "_triangle");
	triangle.fillColor = darkColor;

	UIView *contentView = self.subviews[0];
	contentView.backgroundColor = darkColor;

	UIView *headerContainerView = contentView.subviews[0];
	UILabel *headerLabel = (UILabel *)headerContainerView.subviews[0];
	headerLabel.textColor = brightColor;

	[self colorButtons];

	[self._pickerView setValue:brightColor forKey:@"textColor"];
}

float selectedCircleRGB[] = {
	244, // 0.956863
	89,  // 0.349020
	10   // 0.039216
};

%new
- (void)colorButtons {
	UIView *contentView = self.subviews[0];

	UIView *buttonsView = contentView.subviews[1];
	for (int i = 0; i < buttonsView.subviews.count; ++i) {
		UIButton *presetButton = (UIButton *)buttonsView.subviews[i];
		UIView *buttonContentView = presetButton.subviews[0];
		const CGFloat *colors = CGColorGetComponents(buttonContentView.layer.borderColor);
		BOOL isSelected = (int)(colors[0]*255) == selectedCircleRGB[0] &&
			(int)(colors[1]*255) == selectedCircleRGB[1] &&
			(int)(colors[2]*255) == selectedCircleRGB[2];
		if (!isSelected) {
			buttonContentView.layer.borderColor = [brightColor CGColor];
		}
		UILabel *textLabel = (UILabel *)buttonContentView.subviews[0];
		textLabel.textColor = brightColor;
		UILabel *minLabel = (UILabel *)presetButton.subviews[1];
		minLabel.textColor = brightColor;
	}
}

- (void)timerButtonPushed:(id)arg1 {
	%orig;
	[self colorButtons];
}

%end




@interface LoadView: UIView
@end

%hook LoadView

- (id)initWithFrame:(struct CGRect)arg1 {
	LoadView *_self = %orig;
	_self.backgroundColor = darkColor;
	return _self;
}

%end




@interface RootViewController: UIViewController
- (void)hideMenu:(id)arg1;
@end

%hook RootViewController

- (void)viewDidAppear:(_Bool)arg1 {
	%orig;
	[self hideMenu:nil];
}

%end



@interface STHeaderButton: UIView
@property(retain, nonatomic) UIView *bg;
@property(retain, nonatomic) UIButton *button;
@property(retain, nonatomic) UILabel *tLabel;
@end

@interface HeaderView: UIView
@property(retain, nonatomic) UILabel *middleView;
@property(retain, nonatomic) STHeaderButton *leftButton;
@end

%hook HeaderView

- (void)setHeaderWithLeftType:(int)arg1 rightType:(int)arg2 title:(NSString *)title theme:(int)arg4 {
	%orig;

	if (title.length == 0) { // player view
		self.backgroundColor = nil;
	} else {
		self.backgroundColor = darkColor;
		self.middleView.textColor = brightColor;
		self.leftButton.tLabel.textColor = brightColor;
	}
}

%end

@interface FilterButtonBar: UIView
@property(retain, nonatomic) UIButton *b2;
@property(retain, nonatomic) UIButton *b1;
@end

%hook FilterButtonBar

- (id)initWithFrame:(struct CGRect)arg1 {
	self = %orig;

	self.backgroundColor = darkColor;

	UILabel *stlabel1 = MSHookIvar<UILabel *>(self, "stlabel1");
	stlabel1.textColor = brightColor;

	UILabel *stlabel2 = MSHookIvar<UILabel *>(self, "stlabel2");
	stlabel2.textColor = brightColor;

	UILabel *l1 = MSHookIvar<UILabel *>(self, "l1");
	l1.textColor = brightColor;

	UILabel *l2 = MSHookIvar<UILabel *>(self, "l2");
	l2.textColor = brightColor;

	return self;
}

%end



@interface BookListCell: UITableViewCell
@end

%hook BookListCell

- (id)initWithStyle:(long long)arg1 reuseIdentifier:(id)arg2 {
	BookListCell *_self = %orig;

	UILabel *titleView = MSHookIvar<UILabel *>(self, "titleView");
	titleView.textColor = brightColor;

	UILabel *authorLabel = MSHookIvar<UILabel *>(self, "authorLabel");
	authorLabel.textColor = brightColor;

	UILabel *contentLabel = MSHookIvar<UILabel *>(self, "contentLabel");
	contentLabel.textColor = [UIColor grayColor];

	return _self;
}

%end



@interface BookListViewController: UITableViewController
@end

%hook BookListViewController

- (void)viewDidLoad {
	%orig;
	self.view.backgroundColor = darkColor;
}

- (void)tableView:(UITableView *)arg1 willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
	%orig;
	cell.backgroundColor = darkColor;
}

%end



@interface MDCParallaxView: UIView
@property(retain, nonatomic) UIView *foregroundView;
@end

@interface ABookDetailViewController: UIViewController
@property(retain, nonatomic) MDCParallaxView *_scrollView;
@end

%hook ABookDetailViewController

- (void)viewDidLoad {
	%orig;

	self.view.backgroundColor = darkColor;

	UIButton *authorButton = MSHookIvar<UIButton *>(self, "authorButton");
	authorButton.backgroundColor = nil;
	[authorButton setTitleColor:brightColor forState:UIControlStateNormal];
	authorButton.titleLabel.backgroundColor = nil;
	UILabel *authorArrowLabel = (UILabel *)authorButton.subviews[1];
	authorArrowLabel.backgroundColor = nil;
	authorArrowLabel.textColor = brightColor;

	UIButton *narratorButton = MSHookIvar<UIButton *>(self, "narratorButton");
	narratorButton.backgroundColor = nil;
	[narratorButton setTitleColor:brightColor forState:UIControlStateNormal];
	narratorButton.titleLabel.backgroundColor = nil;
	UILabel *narratorArrowLabel = (UILabel *)narratorButton.subviews[2];
	narratorArrowLabel.backgroundColor = nil;
	narratorArrowLabel.textColor = brightColor;

	UILabel *bookLengthLabel = MSHookIvar<UILabel *>(self, "bookLengthLabel");
	bookLengthLabel.textColor = brightColor;
	bookLengthLabel.backgroundColor = nil;

	UILabel *bookTitleLabel = MSHookIvar<UILabel *>(self, "bookTitleLabel");
	bookTitleLabel.textColor = brightColor;
	bookTitleLabel.backgroundColor = nil;

	UIView *topBar = MSHookIvar<UIView *>(self, "topBar");
	topBar.backgroundColor = nil;

	UILabel *formatLabel = MSHookIvar<UILabel *>(self, "formatLabel");
	formatLabel.textColor = brightColor;
	formatLabel.backgroundColor = nil;

	UIView *everythingBelowReadButton = MSHookIvar<UIView *>(self, "everythingBelowReadButton");
	everythingBelowReadButton.backgroundColor = nil;

	self._scrollView.foregroundView.subviews[0].backgroundColor = darkColor;
}

%end



@interface BookDescriptionLabel: UIView
@property(retain, nonatomic) UILabel *textLabel;
@property(retain, nonatomic) UIView *descriptionFadeView;
@end

%hook BookDescriptionLabel

- (id)initWithFrame:(struct CGRect)arg1 {
	self = %orig;

	self.textLabel.textColor = brightColor;

	UILabel *showMoreLabel = MSHookIvar<UILabel *>(self, "showMoreLabel");
	showMoreLabel.textColor = brightColor;

	self.descriptionFadeView.backgroundColor = darkColor;

	return self;
}

%end



@interface STMultiTokenView: UIView
@property(retain, nonatomic) UIColor *tokenColor;
@end

@interface ExtraInfoView: UIView
@property(retain, nonatomic) UIButton *tagButton;
@property(retain, nonatomic) UIButton *categoryButton;
@property(retain, nonatomic) UIButton *seriesButton;
@property(retain, nonatomic) UIButton *languageButton;
@end

%hook ExtraInfoView

- (id)initWithFrame:(struct CGRect)arg1 andBook:(id)arg2 andType:(int)arg3 {
	%orig;

	UIButton *releaseDateButton = MSHookIvar<UIButton *>(self, "releaseDateButton");
	UIButton *abridgedButton = MSHookIvar<UIButton *>(self, "abridgedButton");

	NSArray *buttons = @[
		self.tagButton ? self.tagButton : [NSNull null],
		self.categoryButton ? self.categoryButton : [NSNull null],
		self.seriesButton ? self.seriesButton : [NSNull null],
		self.languageButton ? self.languageButton : [NSNull null],
		releaseDateButton ? releaseDateButton : [NSNull null],
		abridgedButton ? abridgedButton : [NSNull null]
	];

	for (UIButton *button in buttons) {
		if ([button class] == [UIButton class]) {
			button.backgroundColor = nil;
			[button setTitleColor:brightColor forState:UIControlStateNormal];
			button.titleLabel.backgroundColor = nil;
			if (button == self.categoryButton || button == self.seriesButton) {
				UILabel *arrowLabel = button.subviews[1];
				arrowLabel.textColor = brightColor;
				arrowLabel.backgroundColor = nil;
			}
		}
	}

	STMultiTokenView *tagView = MSHookIvar<STMultiTokenView *>(self, "tagView");
	tagView.tokenColor = brightColor;

	return self;
}

- (void)layoutSubviews {
	self.backgroundColor = darkColor;
	%orig;
}

%end



@interface STTokenView: UIView
@property(retain, nonatomic) UILabel *selectedLabel;
@property(retain, nonatomic) UIView *selectedBackgroundView;
@property(retain, nonatomic) UILabel *label;
@property(retain, nonatomic) UIView *backgroundView;
@end

%hook STTokenView

- (void)layoutSubviews {
	%orig;

	self.selectedLabel.textColor = brightColor;
	self.selectedBackgroundView.backgroundColor = nil;
	self.label.textColor = brightColor;
	self.backgroundView.backgroundColor = nil;
}

%end



@interface STArrowButton: UIButton
@property(retain, nonatomic) UILabel *arrow;
@property(retain, nonatomic) UILabel *stLabel;
- (void)setArrowColor:(id)arg1;
@end

@interface GridListViewController: UIViewController
@end

%hook GridListViewController

- (void)viewDidLoad {
	%orig;

	STArrowButton *titleButton = MSHookIvar<STArrowButton *>(self, "titleButton");
	titleButton.arrow.backgroundColor = nil;
	titleButton.stLabel.backgroundColor = nil;
	[titleButton setTitleColor:brightColor forState:UIControlStateNormal];
	[titleButton setArrowColor:brightColor];
}

%end



@interface IconTextButton: UIButton
@property(retain, nonatomic) UIView *view;
@property(nonatomic, weak) UILabel *titleLabel;
@property(nonatomic, weak) UILabel *iconLabel;
@end

%hook IconTextButton

- (id)initWithFrame:(struct CGRect)arg1 {
	%orig;

	self.titleLabel.textColor = brightColor;
	self.iconLabel.textColor = brightColor;

	return self;
}

%end



@interface DescriptionLabelExtraView: UIView
- (void)setExtraInfoForBook:(id)arg1;
@end

%hook DescriptionLabelExtraView

- (void)setExtraInfoForBook:(id)arg1 {
	%orig;

	NSArray *labels = MSHookIvar<NSArray *>(self, "labels");
	for (int i = 0; i < labels.count; ++i) {
		((UILabel *)labels[i]).textColor = brightColor;
	}
}

%end



UIImage* colorizedImageWithColor(UIImage *image, UIColor *color) {
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, image.size.width, image.size.height);
    CGContextScaleCTM(context, 1, -1);
    CGContextTranslateCTM(context, 0, -area.size.height);
    CGContextSaveGState(context);
    CGContextClipToMask(context, area, image.CGImage);

    [color set];
    CGContextFillRect(context, area);

    CGContextRestoreGState(context);
    CGContextSetBlendMode(context, kCGBlendModeMultiply);
    CGContextDrawImage(context, area, image.CGImage);
    UIImage *colorizedImage = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();
    return colorizedImage;
}


NSMutableDictionary *hasDarkenedBookCover = [NSMutableDictionary dictionary];

@interface Book: NSObject
@end

%hook Book

- (id)abookCover {
	NSString *addressKey = self.description;
	if (!hasDarkenedBookCover[addressKey]) {
		UIImage *abookCover = MSHookIvar<UIImage *>(self, "abookCover");
		if (abookCover) {
			UIImage *darkenedCover = colorizedImageWithColor(abookCover, [UIColor grayColor]);
			MSHookIvar<UIImage *>(self, "abookCover") = darkenedCover;
			hasDarkenedBookCover[addressKey] = @1;
		}
	}
	return %orig;
}

%end
