/*
 
 Erica Sadun, http://ericasadun.com
 
 */

#import <Foundation/Foundation.h>

typedef id (^MapBlock)(id object);
typedef BOOL (^TestingBlock)(id object);

#pragma mark - Utility
@interface NSArray (Frankenstein)

// Transform array to va_list
@property (nonatomic, readonly) va_list va_list;

// Random
@property (nonatomic, readonly) id randomItem;
@property (nonatomic, readonly) NSArray *scrambled;

// Utility
@property (nonatomic, readonly) NSArray *reversed;
@property (nonatomic, readonly) NSArray *sorted;
@property (nonatomic, readonly) NSArray *sortedCaseInsensitive;

// Setification
@property (nonatomic, readonly) NSArray *uniqueElements;
- (NSArray *) unionWithArray: (NSArray *) anArray;
- (NSArray *) intersectionWithArray: (NSArray *) anArray;
- (NSArray *) differenceToArray: (NSArray *) anArray;

// Lisp
@property (nonatomic, readonly) id car;
@property (nonatomic, readonly) NSArray *cdr;
- (NSArray *) map: (MapBlock) aBlock;
- (NSArray *) collect: (TestingBlock) aBlock;
- (NSArray *) reject: (TestingBlock) aBlock;
@end

#pragma mark - Utility
@interface NSMutableArray (Frankenstein)
- (NSMutableArray *) reverseSelf;
@end

#pragma mark - Stacks and Queues
@interface NSMutableArray (StackAndQueueExtensions)
- (id) popObject;
- (id) pullObject;
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
#if TARGET_OS_IPHONE
- (id) objectForKeyedSubscript: (id) subscript; // for IndexPath - iOS Only
#endif
@end

@interface NSMutableArray (safeArray)
- (void)setObject:(id)anObject atIndexedSubscript:(NSUInteger)index;
@end