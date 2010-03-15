#import <UIKit/UIKit.h>
#import "ArrayUtilities.h"
#import "NSObject-Utilities.h"

// Boolean test for collect and reject
@interface NSString (tests)
@end
@implementation NSString (tests)
- (BOOL) isShort
{
	return (self.length < 5);
}
@end

@interface TestBedController : UIViewController
@end

@implementation TestBedController
- (void) performAction
{
	/*
	 NSARRAY UTILITIES
	 */

	// Simple data to play with
	NSArray *array1 = [NSArray arrayWithObjects:@"a", @"b", @"a", @"f", @"b", @"c", [NSNumber numberWithInt:23], @"a", nil];
	NSArray *array2 = [NSArray arrayWithObjects:@"efgh", @"foo bar blort", @"afganicklebeesper", @"a", @"f", nil];
	
	// First object
	printf("First object of array:\n");
	CFShow([array1 firstObject]);
	
	// Unique members, Union, Intersection
	printf("\nUnique members, union, intersection:\n");
	CFShow([array1 uniqueMembers].stringValue);
	CFShow([array1 unionWithArray:array2].stringValue);
	CFShow([array1 intersectionWithArray:array2].stringValue);
	
	// Sorting
	printf("\nString sorting:\n");
	CFShow(array1.sortedStrings.stringValue);
	CFShow([array2 arrayBySortingStrings].stringValue);
	
	// Map, collect, reject
	// Note that results must be of type NSObject. Mapping "length" for instance crashes, returning int
	// NSNull is inserted when values return nil.
	printf("\nMapping and collecting\n");
	CFShow([array1 map:@selector(stringByAppendingString:) withObject:@"foo"].stringValue);
	CFShow([array2 map:@selector(stringByAppendingString:) withObject:@"foo"].stringValue);
	CFShow([array2 map:@selector(length)].stringValue);
	CFShow([array2 collect:@selector(isShort)].stringValue);
	CFShow([array2 reject:@selector(isShort)].stringValue);

	/*
	 MUTABLE ARRAY UTILITIES
	 */

	// Simple data to play with
	NSString *alpha = @"a b c d e f g h i j k l m n o p q r s t u v w x y z";
	NSMutableArray *array = [NSMutableArray arrayWithArray:[alpha componentsSeparatedByString:@" "]];

	// Reverse array
	printf("\nReversed:\n");
	CFShow(array.stringValue);
	CFShow(array.reversed.stringValue);
	
	// Scramble members
	printf("\nScrambling & Shuffling\n");
	CFShow([array scramble].stringValue);
	array = [NSMutableArray arrayWithArray:[alpha componentsSeparatedByString:@" "]];
	
	// Remove First object
	printf("\nRemove First Object\n");
	CFShow([array removeFirstObject].stringValue);
	
	// push/pop/pull
	printf("\nPush, Pop, Pull\n");
	CFShow([[array pushObject:@"1"] pushObject:@"2"].stringValue);
	CFShow([array popObject]);
	CFShow([array pullObject]);
	CFShow(array.stringValue);
	
	NSMutableArray *small = [[@"a b c" componentsSeparatedByString:@" "] mutableCopy];
	CFShow(small.stringValue);
	for (int i = 0; i < 5; i++) CFShow([small pullObject]);
	small = [[@"a b c" componentsSeparatedByString:@" "] mutableCopy];
	CFShow(small.stringValue);
	for (int i = 0; i < 5; i++) CFShow([small popObject]);
}

- (void) loadView
{
	UIView *contentView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
	self.view = contentView;
	contentView.backgroundColor = [UIColor whiteColor];
    [contentView release];
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc]
											   initWithTitle:@"Action" 
											   style:UIBarButtonItemStylePlain 
											   target:self 
											   action:@selector(performAction)] autorelease];
}
@end

@interface TestBedAppDelegate : NSObject <UIApplicationDelegate>
@end

@implementation TestBedAppDelegate
- (void)applicationDidFinishLaunching:(UIApplication *)application {
	UIWindow *window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:[[TestBedController alloc] init]];
	[window addSubview:nav.view];
	[window makeKeyAndVisible];
}
@end

int main(int argc, char *argv[])
{
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	int retVal = UIApplicationMain(argc, argv, nil, @"TestBedAppDelegate");
	[pool release];
	return retVal;
}
