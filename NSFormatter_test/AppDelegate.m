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

// Generate formatted data with color-coded rows
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
        @{ @"label": @"Decimal", @"value": [decimalFormatter stringFromNumber:testNumber], @"color": [NSColor blueColor] },
        @{ @"label": @"Currency", @"value": [currencyFormatter stringFromNumber:testNumber], @"color": [NSColor blueColor] },
        @{ @"label": @"Percent", @"value": [percentFormatter stringFromNumber:testNumber], @"color": [NSColor blueColor] },
        @{ @"label": @"Scientific", @"value": [scientificFormatter stringFromNumber:testNumber], @"color": [NSColor blueColor] },
        @{ @"label": @"Short Date", @"value": [shortDateFormatter stringFromDate:testDate], @"color": [NSColor greenColor] },
        @{ @"label": @"Medium Date", @"value": [mediumDateFormatter stringFromDate:testDate], @"color": [NSColor greenColor] },
        @{ @"label": @"Long Date", @"value": [longDateFormatter stringFromDate:testDate], @"color": [NSColor greenColor] },
        @{ @"label": @"Full Date", @"value": [fullDateFormatter stringFromDate:testDate], @"color": [NSColor greenColor] }
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

// Apply text color to formatted values dynamically
- (void)tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NSDictionary *rowData = self.testData[row];

    if ([cell isKindOfClass:[NSTextFieldCell class]]) {
        NSTextFieldCell *textCell = (NSTextFieldCell *)cell;
        textCell.textColor = rowData[@"color"];
    }
}

@end
