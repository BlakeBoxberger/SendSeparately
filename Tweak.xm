#import <Interfaces.h>

#define kWidth [[UIApplication sharedApplication] keyWindow].frame.size.width
#define kHeight [[UIApplication sharedApplication] keyWindow].frame.size.height

%hook CKComposeChatController
%property (nonatomic, retain) UISwitch *sendSeparatelySwitch;
%property (nonatomic, retain) UILabel *sendSeparatelyLabel;
%property (nonatomic, retain) UIStackView *sendSeparatelyStackView;

- (void)viewDidLoad {
	%orig;

	[self initializeSendSeparatelyView];
	self.sendSeparatelyStackView.hidden = YES;

	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shouldShowSendSeparatelyStackView) name:@"NZ9RecipientsChangedNotification" object:nil];
}

- (void)messageEntryViewSendButtonHit:(id)arg1 {
	if(self.sendSeparatelySwitch.on) {
		CKConversationList *conversationList = [%c(CKConversationList) sharedConversationList];
		NSArray *conversations = [conversationList conversations];
		for(MFComposeRecipient *recipient in self.proposedRecipients) {
			for(CKConversation *conversation in conversations) {
				if([[[conversation recipient] rawAddress] isEqualToString: [recipient rawAddress]]) {
					id message = [conversation messageWithComposition:self.composition];
					[conversation sendMessage:message newComposition:YES];
				}
			}
		}
		[self cancelButtonTapped: self.composeCancelItem];
	}
	else {
		%orig;
	}
}

%new - (void)initializeSendSeparatelyView {
	self.sendSeparatelySwitch = [[UISwitch alloc] init];
	self.sendSeparatelySwitch.onTintColor = [UIColor colorWithRed:0 green:0.478431 blue:1 alpha:1];

	self.sendSeparatelyLabel = [[UILabel alloc] init];
	self.sendSeparatelyLabel.font = [UIFont systemFontOfSize: 15];
	self.sendSeparatelyLabel.text = @"Send Separately";
	self.sendSeparatelyLabel.textAlignment = NSTextAlignmentLeft;
	self.sendSeparatelyLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
	self.sendSeparatelyLabel.textColor = UIColor.lightGrayColor; // [%c(MFHeaderLabelView) _defaultColor];

	CGRect stackViewFrame = CGRectMake(0, 163, kWidth, 53);
	self.sendSeparatelyStackView = [[UIStackView alloc] initWithFrame:stackViewFrame];

	_UIBackdropView *blurView = [[_UIBackdropView alloc] initWithStyle:2010];
	[blurView setBlurRadiusSetOnce:NO];
  [blurView setBlurRadius:20.0];
  [blurView setBlurQuality:@"default"];

	[self.sendSeparatelyStackView addSubview:blurView];

	CAShapeLayer *line = [CAShapeLayer layer];
  UIBezierPath *linePath = [UIBezierPath bezierPath];
	CGPoint origin = blurView.frame.origin;
	CGSize size = blurView.frame.size;
  [linePath moveToPoint: origin];
  [linePath addLineToPoint: CGPointMake(origin.x + size.width, origin.y)];
  line.path = linePath.CGPath;
  line.fillColor = nil;
  line.opacity = 1.0;
  line.strokeColor = [[[%c(MFHeaderLabelView) _defaultColor] colorWithAlphaComponent: 0.5] CGColor];
  [blurView.layer addSublayer: line];

	self.sendSeparatelyStackView.spacing = 8.0;
	self.sendSeparatelyStackView.alignment = UIStackViewAlignmentCenter;
	self.sendSeparatelyStackView.axis = UILayoutConstraintAxisHorizontal;

	UIView *frontSpacerView = [[UIView alloc] initWithFrame:CGRectZero];
	frontSpacerView.translatesAutoresizingMaskIntoConstraints = NO;
	[frontSpacerView.heightAnchor constraintEqualToConstant:8].active = YES;
	[frontSpacerView.widthAnchor constraintEqualToConstant:0].active = YES;

	UIView *backSpacerView = [[UIView alloc] initWithFrame:CGRectZero];
	backSpacerView.translatesAutoresizingMaskIntoConstraints = NO;
	[backSpacerView.heightAnchor constraintEqualToConstant:8].active = YES;
	[backSpacerView.widthAnchor constraintEqualToConstant:0].active = YES;

	[self.sendSeparatelyStackView addArrangedSubview:frontSpacerView];
	[self.sendSeparatelyStackView addArrangedSubview:self.sendSeparatelyLabel];
	[self.sendSeparatelyStackView addArrangedSubview:self.sendSeparatelySwitch];
	[self.sendSeparatelyStackView addArrangedSubview:backSpacerView];

	[self.view addSubview: self.sendSeparatelyStackView];
}

%new - (BOOL)shouldShowSendSeparatelyStackView {
	if([self.proposedRecipients count] >= 2) {
		self.sendSeparatelyStackView.hidden = NO;
		return YES;
	}
	else {
		self.sendSeparatelyStackView.hidden = YES;
		return NO;
	}
}

%end

%hook CKComposeRecipientSelectionController

- (void)addRecipient:(id)arg1 {
	%orig;
	[[NSNotificationCenter defaultCenter] postNotificationName:@"NZ9RecipientsChangedNotification" object:nil];
}

- (void)removeRecipient:(id)arg1 {
	%orig;
	[[NSNotificationCenter defaultCenter] postNotificationName:@"NZ9RecipientsChangedNotification" object:nil];
}

%end
