//
//  AppDelegate.m
//  NSFormatter_test
//
//  Created by Gregory John Casamento on 2/7/25.
//

#import "AppDelegate.h"

@interface AppDelegate ()
@property (strong) IBOutlet NSTableView *table;
@property (strong) IBOutlet NSWindow *window;
@property (strong) NSArray *testData;
@end

@implementation AppDelegate

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


- (BOOL)applicationSupportsSecureRestorableState:(NSApplication *)app {
    return YES;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [self setupData];
    [self.table reloadData];
}

// Generate formatted data
- (void)setupData {
    NSNumber *testNumber = @(1234.5678);
    NSDate *testDate = [NSDate date];

    NSNumberFormatter *decimalFormatter = [[NSNumberFormatter alloc] init];
    decimalFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    
    NSNumberFormatter *currencyFormatter = [[NSNumberFormatter alloc] init];
    currencyFormatter.numberStyle = NSNumberFormatterCurrencyStyle;

    NSNumberFormatter *percentFormatter = [[NSNumberFormatter alloc] init];
    percentFormatter.numberStyle = NSNumberFormatterPercentStyle;

    NSNumberFormatter *scientificFormatter = [[NSNumberFormatter alloc] init];
    scientificFormatter.numberStyle = NSNumberFormatterScientificStyle;

    NSDateFormatter *shortDateFormatter = [[NSDateFormatter alloc] init];
    shortDateFormatter.dateStyle = NSDateFormatterShortStyle;

    NSDateFormatter *mediumDateFormatter = [[NSDateFormatter alloc] init];
    mediumDateFormatter.dateStyle = NSDateFormatterMediumStyle;

    NSDateFormatter *longDateFormatter = [[NSDateFormatter alloc] init];
    longDateFormatter.dateStyle = NSDateFormatterLongStyle;

    NSDateFormatter *fullDateFormatter = [[NSDateFormatter alloc] init];
    fullDateFormatter.dateStyle = NSDateFormatterFullStyle;

    self.testData = @[
        @{ @"label": @"Decimal", @"value": [decimalFormatter stringFromNumber:testNumber] },
        @{ @"label": @"Currency", @"value": [currencyFormatter stringFromNumber:testNumber] },
        @{ @"label": @"Percent", @"value": [percentFormatter stringFromNumber:testNumber] },
        @{ @"label": @"Scientific", @"value": [scientificFormatter stringFromNumber:testNumber] },
        @{ @"label": @"Short Date", @"value": [shortDateFormatter stringFromDate:testDate] },
        @{ @"label": @"Medium Date", @"value": [mediumDateFormatter stringFromDate:testDate] },
        @{ @"label": @"Long Date", @"value": [longDateFormatter stringFromDate:testDate] },
        @{ @"label": @"Full Date", @"value": [fullDateFormatter stringFromDate:testDate] }
    ];
}

// Returns the number of rows in the table
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return self.testData.count;
}

// Configures each row
- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NSDictionary *rowData = self.testData[row];

    if ([tableColumn.identifier isEqualToString:@"label"]) {
        return rowData[@"label"];
    } else if ([tableColumn.identifier isEqualToString:@"value"]) {
        return rowData[@"value"];
    }
    return nil;
}

@end
