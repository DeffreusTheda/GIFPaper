#import "BTHAppDelegate.h"

// Constants for User Defaults keys
static NSString * const kDefaultsPathKey = @"Path";
static NSString * const kDefaultsAlignmentKey = @"Alignment";
static NSString * const kDefaultsScalingKey = @"Scaling";
static NSString * const kDefaultsBackgroundColorKey = @"BackgroundColor";

// Notification name posted by the preferences app when defaults change
static NSString * const kPrefsDidUpdateNotification = @"BTHGIFPaperPrefsDidUpdateDefaults";

@implementation BTHAppDelegate

/*
 * -[BTHAppDelegate applicationDidFinishLaunching:]
 *
 * Called when the application has finished launching.
 */
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // 1. Create and set up the main window
    self.window = [[BTHBackgroundWindow alloc] init];
    [self.window makeMainWindow];

    // 2. Set up the user defaults controller
    self.defaults = [NSUserDefaultsController sharedUserDefaultsController];
    
    // 3. Load and register the default values from "Defaults.plist"
    NSBundle *mainBundle = [NSBundle mainBundle];
    NSString *defaultsPath = [mainBundle pathForResource:@"Defaults" ofType:@"plist"];
    NSDictionary *initialValues = [[NSDictionary alloc] initWithContentsOfFile:defaultsPath];
    [self.defaults setInitialValues:initialValues];

    // 4. Apply the loaded settings for the first time
    [self didUpdateDefaults:nil];

    // 5. Register to observe notifications for when settings are changed externally
    //    (e.g., from a separate Preferences.app)
    NSDistributedNotificationCenter *center = [NSDistributedNotificationCenter defaultCenter];
    [center addObserver:self
               selector:@selector(didUpdateDefaults:)
                   name:kPrefsDidUpdateNotification
                 object:nil];
}

/*
 * -[BTHAppDelegate didUpdateDefaults:]
 *
 * This is the central update method, called on launch and when a notification is received.
 * It reads all settings from defaults and applies them.
 */
- (void)didUpdateDefaults:(NSNotification *)notification {
    [self updateImage];
    [self updateImageAlignment];
    [self updateImageScaling];
    [self updateWindowBackgroundColor];
    [self updateWindowVisibility]; // Must be last, as it depends on the image
}

/*
 * -[BTHAppDelegate updateImage]
 *
 * Loads the image from the path specified in user defaults.
 */
- (void)updateImage {
    NSUserDefaults *userDefaults = [self.defaults defaults];
    NSString *imagePath = [userDefaults valueForKey:kDefaultsPathKey];
    
    [self.window.imageView setImage:nil]; // Clear old image first

    if (imagePath) {
        NSImage *image = [[NSImage alloc] initWithContentsOfFile:imagePath];
        [self.window.imageView setImage:image];
    }
}

/*
 * -[BTHAppDelegate updateImageAlignment]
 *
 * Sets the image alignment (e.g., center, top-left) from user defaults.
 */
- (void)updateImageAlignment {
    NSUserDefaults *userDefaults = [self.defaults defaults];
    id alignmentValue = [userDefaults valueForKey:kDefaultsAlignmentKey];
    
    // Default to 5 (Center) if not set
    NSImageAlignment alignment = 5; // 5 = NSImageAlignCenter
    if (alignmentValue) {
        alignment = [alignmentValue unsignedIntegerValue];
    }
    
    [self.window.imageView setImageAlignment:alignment];
}

/*
 * -[BTHAppDelegate updateImageScaling]
 *
 * Sets the image scaling (e.g., stretch, fit) from user defaults.
 */
- (void)updateImageScaling {
    NSUserDefaults *userDefaults = [self.defaults defaults];
    id scalingValue = [userDefaults valueForKey:kDefaultsScalingKey];
    
    // Default to 0 (Proportionally) if not set
    NSImageScaling scaling = 0; // 0 = NSImageScaleProportionallyDown
    if (scalingValue) {
        scaling = [scalingValue unsignedIntegerValue];
    }
    
    [self.window.imageView setImageScaling:scaling];
}

/*
 * -[BTHAppDelegate updateWindowBackgroundColor]
 *
 * Sets the window background color. This color will show if the image
 * doesn't fill the screen (e.g., "fit" scaling).
 */
- (void)updateWindowBackgroundColor {
    NSUserDefaults *userDefaults = [self.defaults defaults];
    NSData *colorData = [userDefaults dataForKey:kDefaultsBackgroundColorKey];
    
    if (colorData) {
        // The color is archived as NSData, so it must be unarchived
        NSColor *color = [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
        [self.window setBackgroundColor:color];
    }
}

/*
 * -[BTHAppDelegate updateWindowVisibility]
 *
 * Shows the window if an image is set, and hides it if no image is set.
 */
- (void)updateWindowVisibility {
    if ([self.window.imageView image]) {
        [self.window orderFront:nil]; // Show the window
    } else {
        [self.window orderOut:nil]; // Hide the window
    }
}

/*
 * -Am I BTHAppDelegate .cxx_destruct]
 *
 * Handled by ARC. The decompiler shows:
 * void __cdecl -[BTHAppDelegate .cxx_destruct](BTHAppDelegate *self, SEL a2) {
 * objc_storeStrong((id *)&self->_window, 0);
 * objc_storeStrong((id *)&self->defaults, 0);
 * }
 */

@end
