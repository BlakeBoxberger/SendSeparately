#import "UIBackdropView.h"

@interface CKComposeRecipientSelectionController : UIViewController
- (void)addRecipient:(id)arg1;
- (void)removeRecipient:(id)arg1;
@end

@interface CKComposition : NSObject
@end

@interface CKChatController : UIViewController
@property (nonatomic,retain) CKComposition *composition;
- (void)sendComposition:(CKComposition *)arg1;
@end

@interface CKComposeChatController : CKChatController
@property (nonatomic, retain) UISwitch *sendSeparatelySwitch; // NEW
@property (nonatomic, retain) UILabel *sendSeparatelyLabel; // NEW
@property (nonatomic, retain) UIStackView *sendSeparatelyStackView; // NEW
@property (nonatomic, readonly) NSArray *proposedRecipients;
@property (nonatomic,retain) UIBarButtonItem * composeCancelItem;
@property (nonatomic, retain) CKComposeRecipientSelectionController *composeRecipientSelectionController;
- (void)initializeSendSeparatelyView; // NEW
- (BOOL)shouldShowSendSeparatelyStackView; // NEW
- (void)cancelButtonTapped:(UIBarButtonItem *)arg1;
@end

@interface MFHeaderLabelView : UILabel
+ (UIColor *)_defaultColor;
@end

@interface MFComposeRecipient : NSObject
- (NSString *)rawAddress;
@end

@interface CKEntity : NSObject
- (NSString *)rawAddress;
@end

@interface CKConversation : NSObject
- (id)messageWithComposition:(CKComposition *)arg1;
- (void)sendMessage:(id)arg1 newComposition:(BOOL)arg2;
- (CKEntity *)recipient;
@end

@interface CKConversationList : NSObject
+ (CKConversationList *)sharedConversationList;
- (NSArray *)conversations;
@end
