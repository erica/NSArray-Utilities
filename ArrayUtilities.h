/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 3.0 Edition
 BSD License, Use at your own risk
 */

#import <Foundation/Foundation.h>
@interface NSArray (StringExtensions)
- (NSArray *) arrayBySortingStrings;
@property (readonly, getter=arrayBySortingStrings) NSArray *sortedStrings;
@property (readonly) NSString *stringValue;
@end

@interface NSArray (UtilityExtensions)
- (id) firstObject;
- (NSArray *) uniqueMembers;
- (NSArray *) unionWithArray: (NSArray *) array;
- (NSArray *) intersectionWithArray: (NSArray *) array;


// Note also see: makeObjectsPeformSelector: withObject:. Map collects the results a la mapcar in Lisp
- (NSArray *) map: (SEL) selector;
- (NSArray *) map: (SEL) selector withObject: (id)object;
- (NSArray *) map: (SEL) selector withObject: (id)object1 withObject: (id)object2;

- (NSArray *) collect: (SEL) selector withObject: (id) object1 withObject: (id) object2;
- (NSArray *) collect: (SEL) selector withObject: (id) object1;
- (NSArray *) collect: (SEL) selector;

- (NSArray *) reject: (SEL) selector withObject: (id) object1 withObject: (id) object2;
- (NSArray *) reject: (SEL) selector withObject: (id) object1;
- (NSArray *) reject: (SEL) selector;
@end

@interface NSMutableArray (UtilityExtensions)
- (NSMutableArray *) removeFirstObject;
- (NSMutableArray *) reverse;
- (NSMutableArray *) scramble;
@property (readonly, getter=reverse) NSMutableArray *reversed;
@end

@interface NSMutableArray (StackAndQueueExtensions) 
- (NSMutableArray *)pushObject:(id)object;
- (NSMutableArray *)pushObjects:(id)object,...;
- (id) popObject;
- (id) pullObject;

// Synonyms for traditional use
- (NSMutableArray *)push:(id)object;
- (id) pop;
- (id) pull;
@end

