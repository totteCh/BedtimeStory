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
	RoundTriangle *triangle;
	object_getInstanceVariable(self, "_triangle", (void**)&triangle);
	triangle.fillColor = [UIColor blackColor];

	UIView *contentView = self.subviews[0];
	contentView.backgroundColor = [UIColor blackColor];

	UIView *headerContainerView = contentView.subviews[0];
	UILabel *headerLabel = (UILabel *)headerContainerView.subviews[0];
	headerLabel.textColor = [UIColor whiteColor];

	[self colorButtons];

	[self._pickerView setValue:[UIColor whiteColor] forKey:@"textColor"];
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
			buttonContentView.layer.borderColor = [[UIColor whiteColor] CGColor];
		}
		UILabel *textLabel = (UILabel *)buttonContentView.subviews[0];
		textLabel.textColor = [UIColor whiteColor];
		UILabel *minLabel = (UILabel *)presetButton.subviews[1];
		minLabel.textColor = [UIColor whiteColor];
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
	_self.backgroundColor = [UIColor blackColor];
	return _self;
}

%end
