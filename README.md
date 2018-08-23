# SendSeparately

Known issue - I hardcoded the y-coordinate of the stack view's frame specifically for an iPhone X, I'll try to figure out how to align it properly for other devices later

Known issue - If I filter com.apple.chatkit, it should show up in the Share Sheet as well (since CKShareSheetChatController inherits from CKComposeChatController), however only the UISwitch appears and it looks terrible.

If anyone knows why that happens, please fork and let me know!
