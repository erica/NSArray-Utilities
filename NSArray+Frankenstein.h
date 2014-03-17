/*
 
 Erica Sadun, http://ericasadun.com
 
 */

#import <Foundation/Foundation.h>

typedef id (^MapBlock)(id object);
typedef BOOL (^TestingBlock)(id object);

#pragma mark - Utility
@interface NSArray (Frankenstein)
- (id) safeObjectAtIndex: (NSUInteger) index;

@property (nonatomic, readonly) NSString *stringValue;
@property (nonatomic, readonly) NSArray *reversed;
@property (nonatomic, readonly) NSArray *sorted;
@property (nonatomic, readonly) NSArray *sortedCaseInsensitive;
@property (nonatomic, readonly) NSArray *uniqueElements;
@property (nonatomic, readonly) NSArray *scrambled;

// Setification
- (NSArray *) unionWithArray: (NSArray *) anArray;
- (NSArray *) intersectionWithArray: (NSArray *) anArray;
- (NSArray *) differenceToArray: (NSArray *) anArray;

// Lisp
- (NSArray *) map: (MapBlock) aBlock;
- (NSArray *) collect: (TestingBlock) aBlock;
- (NSArray *) reject: (TestingBlock) aBlock;

#if TARGET_OS_IPHONE
// Index 2-D array by IndexPath
- (id) objectForKeyedSubscript: (id) subscript;
#endif
@end

#pragma mark - Utility
@interface NSMutableArray (Frankenstein)
- (NSMutableArray *) reverse;
- (void) safeSetObject: (id) object atIndex: (NSUInteger) index;
@end

#pragma mark - Stacks and Queues
@interface NSMutableArray (StackAndQueueExtensions)
- (id) pop;
- (id) popObject;
- (id) pull;
- (id) pullObject;

- (NSMutableArray *) push:(id)object;
- (NSMutableArray *) pushObject:(id)object;
- (NSMutableArray *) pushObjects:(id)object,...;
@end

#pragma Pseudo Dictionary
@interface NSArray (pseudodictionary)
- (id) objectForKey: (NSString *) aKey;
@end

@interface NSMutableArray (pseudodictionary)
- (void) setObject: (id) object forKey: (NSString *) aKey;
@end


#pragma mark - Safe Access Override
@interface NSArray (safeArray)
- (id)objectAtIndexedSubscript:(NSUInteger)idx;
@end

@interface NSMutableArray (safeArray)
- (void)setObject:(id)anObject atIndexedSubscript:(NSUInteger)index;
@end