#import "BTHBackgroundWindow.h"

@implementation BTHBackgroundWindow

/*
 * -[BTHBackgroundWindow init]
 *
 * Initializes the window.
 */
- (instancetype)init {
    // Get the frame of the main screen
    NSScreen *mainScreen = [NSScreen mainScreen];
    NSRect screenFrame = [mainScreen frame];

    // Initialize the window to fill the main screen.
    // The decompiled code calls `initWithContentRect:styleMask:backing:defer:screen:`.
    // The arguments are inferred to be:
    //   styleMask: 0 (NSWindowStyleMaskBorderless)
    //   backing: 2 (NSBackingStoreBuffered)
    //   defer: YES (1)
    //
    // Note: `initWithContentRect:styleMask:backing:defer:screen:` is deprecated.
    // The modern equivalent would be `initWithContentRect:styleMask:backing:defer:`.
    self = [super initWithContentRect:screenFrame
                            styleMask:NSWindowStyleMaskBorderless
                              backing:NSBackingStoreBuffered
                                defer:YES
                               screen:mainScreen];
    
    if (self) {
        // Set window properties
        [self setAlphaValue:1.0]; // Fully opaque
        [self setOpaque:YES];
        [self setMovableByWindowBackground:NO]; // Cannot be dragged
        
        // Set the window level to be behind the desktop icons
        [self setLevel:CGWindowLevelForKey(kCGDesktopIconWindowLevelKey)];

        // <3 Set the window to appear on all virtual desktops/spaces <3
        [self setCollectionBehavior:NSWindowCollectionBehaviorCanJoinAllSpaces];

        // Initialize the image view to fill the window
        _imageView = [[NSImageView alloc] initWithFrame:screenFrame];
        
        // Add the image view as a subview of the window's content view
        [[self contentView] addSubview:self.imageView];
    }
    return self;
}

/*
 * -[BTHBackgroundWindow canBecomeKeyWindow]
 *
 * Prevents this window from ever becoming the key window (e.g., receiving keyboard input).
 */
- (BOOL)canBecomeKeyWindow {
    return NO;
}

/*
 * -[BTHBackgroundWindow canBecomeMainWindow]
 *
 * Allows this window to be the "main" window (part of the app's window list).
 */
- (BOOL)canBecomeMainWindow {
    return YES;
}

/*
 * -[BTHBackgroundWindow .cxx_destruct]
 *
 * The `@property` and ARC handle the release of the `imageView`.
 * The decompiler shows this as:
 * void __cdecl -[BTHBackgroundWindow .cxx_destruct](BTHBackgroundWindow *self, SEL a2) {
 * objc_storeStrong((id *)&self->imageView, 0);
 * }
 */

@end
