//
//  AppDelegate.m
//  NSFormatter_test
//
//  Created by Gregory John Casamento on 2/7/25.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


- (BOOL)applicationSupportsSecureRestorableState:(NSApplication *)app {
    return YES;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [self setupData];
    [_tableView reloadData];
}

// Getter for testData
- (NSMutableArray *)testData {
    return _testData;
}

// Setter for testData
- (void)setTestData:(NSMutableArray *)data {
    if (_testData != data) {
        // [_testData release];
        _testData = data; // [data retain];
    }
}

// Returns tableView
- (NSTableView *)tableView {
    return _tableView;
}

// Generate formatted data with positive & negative numbers
- (void)setupData {
    NSNumber *positiveNumber = [NSNumber numberWithDouble:1234.5678];
    NSNumber *negativeNumber = [NSNumber numberWithDouble:-1234.5678];
    NSDate *testDate = [NSDate date];

    NSMutableArray *data = [[NSMutableArray alloc] init];

    NSArray *formatters = [NSArray arrayWithObjects:
        [NSDictionary dictionaryWithObjectsAndKeys:@"Decimal", @"name", [NSNumber numberWithInt:NSNumberFormatterDecimalStyle], @"style", nil],
        [NSDictionary dictionaryWithObjectsAndKeys:@"Currency", @"name", [NSNumber numberWithInt:NSNumberFormatterCurrencyStyle], @"style", nil],
        [NSDictionary dictionaryWithObjectsAndKeys:@"Percent", @"name", [NSNumber numberWithInt:NSNumberFormatterPercentStyle], @"style", nil],
        [NSDictionary dictionaryWithObjectsAndKeys:@"Scientific", @"name", [NSNumber numberWithInt:NSNumberFormatterScientificStyle], @"style", nil], nil
    ];

    for (NSUInteger i = 0; i < [formatters count]; i++) {
        NSDictionary *formatterData = [formatters objectAtIndex:i];
        NSString *label = [formatterData objectForKey:@"name"];
        NSNumberFormatterStyle style = [[formatterData objectForKey:@"style"] intValue];

        [data addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:
            [NSString stringWithFormat:@"%@ (+)", label], @"label",
            positiveNumber, @"value",
            [NSNumber numberWithInt:style], @"formatter",
            [NSColor blueColor], @"color",
            nil]];

        [data addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:
            [NSString stringWithFormat:@"%@ (-)", label], @"label",
            negativeNumber, @"value",
            [NSNumber numberWithInt:style], @"formatter",
            [NSColor redColor], @"color",
            nil]];
    }

    NSArray *dateStyles = [NSArray arrayWithObjects:
        [NSDictionary dictionaryWithObjectsAndKeys:@"Short Date", @"name", [NSNumber numberWithInt:NSDateFormatterShortStyle], @"style", nil],
        [NSDictionary dictionaryWithObjectsAndKeys:@"Medium Date", @"name", [NSNumber numberWithInt:NSDateFormatterMediumStyle], @"style", nil],
        [NSDictionary dictionaryWithObjectsAndKeys:@"Long Date", @"name", [NSNumber numberWithInt:NSDateFormatterLongStyle], @"style", nil],
        [NSDictionary dictionaryWithObjectsAndKeys:@"Full Date", @"name", [NSNumber numberWithInt:NSDateFormatterFullStyle], @"style", nil], nil
    ];

    for (NSUInteger i = 0; i < [dateStyles count]; i++) {
        NSDictionary *dateData = [dateStyles objectAtIndex:i];

        [data addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:
            [dateData objectForKey:@"name"], @"label",
            testDate, @"value",
            [dateData objectForKey:@"style"], @"formatter",
            [NSColor greenColor], @"color",
            nil]];
    }

    [self setTestData:data];
    //[data release];
}

// Returns the number of rows in the table
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return [[self testData] count];
}

// Returns formatted values with color
- (id)tableView:(NSTableView *)tableView objectValueForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NSMutableDictionary *rowData = [[self testData] objectAtIndex:row];

    if ([[tableColumn identifier] isEqualToString:@"label"]) {
        return [rowData objectForKey:@"label"];
    } else if ([[tableColumn identifier] isEqualToString:@"value"]) {
        return [self attributedStringForFormattedValue:rowData];
    }
    return nil;
}

// Convert formatted values into NSAttributedString with embedded colors
- (NSAttributedString *)attributedStringForFormattedValue:(NSDictionary *)rowData {
    NSString *formattedString = [self formattedValueForRow:rowData];
    NSColor *color = [rowData objectForKey:@"color"];

    NSDictionary *attributes = [NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
    return [[NSAttributedString alloc] initWithString:formattedString attributes:attributes]; /// autorelease];
}

// Allow editing and update values dynamically
- (void)tableView:(NSTableView *)tableView setObjectValue:(id)object forTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row {
    NSMutableDictionary *rowData = [[self testData] objectAtIndex:row];

    if ([[tableColumn identifier] isEqualToString:@"value"]) {
        [rowData setObject:[self convertInput:object forRow:rowData] forKey:@"value"];
        [rowData setObject:([[rowData objectForKey:@"value"] doubleValue] < 0 ? [NSColor redColor] : [NSColor blueColor]) forKey:@"color"];
        [[self tableView] reloadData];
    }
}

// Format values dynamically
- (NSString *)formattedValueForRow:(NSDictionary *)rowData {
    id value = [rowData objectForKey:@"value"];
    NSNumberFormatter *numFormatter = [[NSNumberFormatter alloc] init]; // autorelease];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; // autorelease];

    if ([value isKindOfClass:[NSNumber class]]) {
        [numFormatter setNumberStyle:[[rowData objectForKey:@"formatter"] intValue]];
        return [numFormatter stringFromNumber:value];
    } else if ([value isKindOfClass:[NSDate class]]) {
        [dateFormatter setDateStyle:[[rowData objectForKey:@"formatter"] intValue]];
        return [dateFormatter stringFromDate:value];
    }
    return @"";
}

// Convert user input based on formatter type
- (id)convertInput:(id)input forRow:(NSDictionary *)rowData {
    NSNumberFormatter *numFormatter = [[NSNumberFormatter alloc] init]; // autorelease];
    [numFormatter setNumberStyle:NSNumberFormatterDecimalStyle];

    if ([[rowData objectForKey:@"formatter"] intValue] <= NSNumberFormatterScientificStyle) {
        return [numFormatter numberFromString:input];
    } else {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init]; // autorelease];
        [dateFormatter setDateStyle:[[rowData objectForKey:@"formatter"] intValue]];
        return [dateFormatter dateFromString:input] ?: input;
    }
}

@end
