//
//  AppDelegate.h
//  NSFormatter_test
//
//  Created by Gregory John Casamento on 2/7/25.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate, NSTableViewDataSource, NSTableViewDelegate> {
    IBOutlet NSTableView *_tableView;
    IBOutlet NSWindow *_window;
    NSMutableArray *_testData;
}

- (NSMutableArray *)testData;
- (void)setTestData:(NSMutableArray *)data;

@end
