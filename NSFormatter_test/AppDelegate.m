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
@property (strong) NSMutableArray *testData;
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

// Generate formatted data with positive & negative numbers
- (void)setupData {
    NSNumber *positiveNumber = @(1234.5678);
    NSNumber *negativeNumber = @(-1234.5678);
    NSDate *testDate = [NSDate date];

    NSArray *formatters = @[
        @{@"name": @"Decimal", @"style": @(NSNumberFormatterDecimalStyle)},
        @{@"name": @"Currency", @"style": @(NSNumberFormatterCurrencyStyle)},
        @{@"name": @"Percent", @"style": @(NSNumberFormatterPercentStyle)},
        @{@"name": @"Scientific", @"style": @(NSNumberFormatterScientificStyle)}
    ];

    self.testData = [NSMutableArray array];

    for (NSDictionary *formatterData in formatters) {
        NSString *label = formatterData[@"name"];
        NSNumberFormatterStyle style = [formatterData[@"style"] intValue];

        [self.testData addObject:@{
            @"label": [NSString stringWithFormat:@"%@ (+)", label],
            @"value": positiveNumber,
            @"formatter": @(style),
            @"color": [NSColor blueColor]
        }.mutableCopy];

        [self.testData addObject:@{
            @"label": [NSString stringWithFormat:@"%@ (-)", label],
            @"value": negativeNumber,
            @"formatter": @(style),
            @"color": [NSColor redColor]
        }.mutableCopy];
    }

    // Add date formatters
    NSArray *dateStyles = @[
        @{@"name": @"Short Date", @"style": @(NSDateFormatterShortStyle)},
        @{@"name": @"Medium Date", @"style": @(NSDateFormatterMediumStyle)},
        @{@"name": @"Long Date", @"style": @(NSDateFormatterLongStyle)},
        @{@"name": @"Full Date", @"style": @(NSDateFormatterFullStyle)}
    ];

    for (NSDictionary *dateData in dateStyles) {
        [self.testData addObject:@{
            @"label": dateData[@"name"],
            @"value": testDate,
            @"formatter": dateData[@"style"],
            @"color": [NSColor greenColor]
        }.mutableCopy];
    }
}

// Returns the number of rows in the table
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return self.testData.count;
}

// Returns formatted values with color
- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NSMutableDictionary *rowData = self.testData[row];

    if ([tableColumn.identifier isEqualToString:@"label"]) {
        return rowData[@"label"];
    } else if ([tableColumn.identifier isEqualToString:@"value"]) {
        return [self attributedStringForFormattedValue:rowData];
    }
    return nil;
}

// Convert formatted values into NSAttributedString with embedded colors
- (NSAttributedString *)attributedStringForFormattedValue:(NSDictionary *)rowData {
    NSString *formattedString = [self formattedValueForRow:rowData];
    NSColor *color = rowData[@"color"];

    NSDictionary *attributes = @{ NSForegroundColorAttributeName: color };
    return [[NSAttributedString alloc] initWithString:formattedString attributes:attributes];
}

// Apply row background color (alternating rows)
- (void)tableView:(NSTableView *)tableView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    if ([cell isKindOfClass:[NSTextFieldCell class]]) {
        NSTextFieldCell *textCell = (NSTextFieldCell *)cell;

        // Alternate row background colors
        if (row % 2 == 0) {
            textCell.backgroundColor = [NSColor lightGrayColor]; // [NSColor colorWithWhite:0.95 alpha:1.0]; // Light gray
        } else {
            textCell.backgroundColor = [NSColor darkGrayColor]; // [NSColor whiteColor]; // White
        }
        textCell.drawsBackground = YES;
    }
}

// Allow editing and update values dynamically
- (void)tableView:(NSTableView *)tableView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NSMutableDictionary *rowData = self.testData[row];

    if ([tableColumn.identifier isEqualToString:@"value"]) {
        rowData[@"value"] = [self convertInput:object forRow:rowData];
        rowData[@"color"] = ([rowData[@"value"] doubleValue] < 0) ? [NSColor redColor] : [NSColor blueColor];
        [self.table reloadData]; // Refresh to apply formatting
    }
}

// Format values dynamically
- (NSString *)formattedValueForRow:(NSDictionary *)rowData {
    id value = rowData[@"value"];
    NSNumberFormatter *numFormatter = [[NSNumberFormatter alloc] init];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];

    if ([value isKindOfClass:[NSNumber class]]) {
        numFormatter.numberStyle = [rowData[@"formatter"] intValue];
        return [numFormatter stringFromNumber:value];
    } else if ([value isKindOfClass:[NSDate class]]) {
        dateFormatter.dateStyle = [rowData[@"formatter"] intValue];
        return [dateFormatter stringFromDate:value];
    }
    return @"";
}

// Convert user input based on formatter type
- (id)convertInput:(id)input forRow:(NSDictionary *)rowData {
    NSNumberFormatter *numFormatter = [[NSNumberFormatter alloc] init];
    numFormatter.numberStyle = NSNumberFormatterDecimalStyle;

    if ([rowData[@"formatter"] intValue] <= NSNumberFormatterScientificStyle) {
        return [numFormatter numberFromString:input];
    } else {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateStyle = [rowData[@"formatter"] intValue];
        return [dateFormatter dateFromString:input] ?: input;
    }
}

@end
