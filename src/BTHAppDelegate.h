#import <Cocoa/Cocoa.h>
#import "BTHBackgroundWindow.h"

/*
 * BTHAppDelegate
 *
 * The main application delegate. It handles launching the app,
 * setting up the window, and observing user defaults for changes.
 */
@interface BTHAppDelegate : NSObject <NSApplicationDelegate>

// The background window
@property (nonatomic, strong) BTHBackgroundWindow *window;

// Controller for managing user defaults
@property (nonatomic, strong) NSUserDefaultsController *defaults;

@end
