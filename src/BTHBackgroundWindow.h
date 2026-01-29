#import <Cocoa/Cocoa.h>

/*
 * BTHBackgroundWindow
 *
 * A custom window designed to sit on the desktop, behind the icons.
 * It does not become a key window but can be the main window.
 */
@interface BTHBackgroundWindow : NSWindow

// The image view that will display the wallpaper
@property (nonatomic, strong) NSImageView *imageView;

@end
