/*
 
 Erica Sadun, http://ericasadun.com
 
 */

#import "NSArray+Frankenstein.h"

@implementation NSArray (Frankenstein)

- (NSString *) descriptionWithLocale:(id)locale
{
//    if ([NSJSONSerialization isValidJSONObject:self])
//    {
//        NSData *d = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:nil];
//        return [[NSString alloc] initWithData:d encoding:NSUTF8StringEncoding];
//    }
    
    NSMutableString *description = [NSMutableString string];
    NSArray *descriptionArray = [self map:^id(id object) {if ([object respondsToSelector:@selector(descriptionWithLocale:)]) return [object descriptionWithLocale:locale]; return [object description];}];

    [description appendString:@"["];
    [description appendString:[descriptionArray componentsJoinedByString:@", "]];
    [description appendString:@"]"];
    
    return description;
}

# pragma mark - handy properties

- (NSString *) stringValue
{
	return [NSString stringWithFormat:@"[%@]", [self componentsJoinedByString:@", "]];
}

- (NSArray *) reversed
{
    return [[self reverseObjectEnumerator] allObjects];
}

- (NSArray *) sorted
{
    NSArray *resultArray = [self sortedArrayUsingComparator:
                            ^(id obj1, id obj2){return [obj1 compare:obj2];}];
    return resultArray;
}

- (NSArray *) sortedCaseInsensitive
{
    NSArray *resultArray = [self sortedArrayUsingComparator:
                            ^(id obj1, id obj2){return [obj1 caseInsensitiveCompare:obj2];}];
    return resultArray;
}


- (NSArray *) uniqueElements
{
    return [NSOrderedSet orderedSetWithArray:self].array.copy;
}

- (NSArray *) scrambled
{
    static BOOL seeded = NO;
    if (!seeded) {seeded = YES; srandom((unsigned int) time(0));}
    
    NSMutableArray *resultArray = self.mutableCopy;
	for (int i = 0; i < (self.count - 2); i++)
		[resultArray exchangeObjectAtIndex:i withObjectAtIndex:(i + (random() % (self.count - i)))];
	return resultArray;
}

#pragma mark - Set theory

- (NSArray *) unionWithArray: (NSArray *) anArray
{
    NSMutableOrderedSet *set = [NSMutableOrderedSet orderedSetWithArray:self];
    [set addObjectsFromArray:anArray];
    return set.array.copy;
}

- (NSArray *) intersectionWithArray: (NSArray *) anArray
{
    NSMutableOrderedSet *set1 = [NSMutableOrderedSet orderedSetWithArray:self];
    NSMutableOrderedSet *set2 = [NSMutableOrderedSet orderedSetWithArray:anArray];
    
    [set1 intersectOrderedSet:set2];
    
    return set1.array.copy;
}

- (NSArray *) differenceToArray: (NSArray *) anArray
{
    NSMutableArray *mutable = self.mutableCopy;
    [mutable removeObjectsInArray:anArray];
    return [mutable copy];
}

#pragma mark - Lisp

- (NSArray *) map: (MapBlock) aBlock
{
    NSMutableArray *resultArray = [NSMutableArray array];
    for (id object in self)
    {
        id result = aBlock(object);
        [resultArray addObject: result ? : [NSNull null]];
    }
    return resultArray;
}

- (NSArray *) collect: (TestingBlock) aBlock
{
    NSMutableArray *resultArray = [NSMutableArray array];
    for (id object in self)
    {
        BOOL result = aBlock(object);
        if (result)
            [resultArray addObject:object];
    }
    return resultArray;
}

- (NSArray *) reject: (TestingBlock) aBlock
{
    NSMutableArray *resultArray = [NSMutableArray array];
    for (id object in self)
    {
        BOOL result = aBlock(object);
        if (!result)
            [resultArray addObject:object];
    }
    return resultArray;
}

#pragma mark - Utility

- (id) safeObjectAtIndex: (NSUInteger) index
{
    if (index < self.count)
    {
        id object = [self objectAtIndex:index];
        if ([object isKindOfClass:[NSNull class]])
            return nil;
        return object;
    }
    return nil;
}

#pragma mark -

#if TARGET_OS_IPHONE
- (id) objectForKeyedSubscript: (id) subscript
{
    if (![subscript isKindOfClass:[NSIndexPath class]])
        return nil;
    NSIndexPath *path = (NSIndexPath *) subscript;
    NSArray *sub = [self safeObjectAtIndex:path.section];
    if (![sub isKindOfClass:[NSArray class]])
        return nil;
    return [sub safeObjectAtIndex:path.row];
}
#endif
@end

@implementation NSMutableArray (Frankenstein)
- (NSMutableArray *) reverse
{
	for (int i = 0; i < (floor(self.count/2.0)); i++) 
		[self exchangeObjectAtIndex:i withObjectAtIndex:(self.count-(i+1))];
	return self;
}

- (void) safeSetObject: (id) object atIndex: (NSUInteger) index
{
    if (index < self.count)
    {
        if (object)
        {
            self[index] = object;
            return;
        }
        
        // Insert nil as a null object
        self[index] = [NSNull null];
        return;
    }
    
    // out of bounds
    for (NSInteger i = self.count; i < index; i++)
        [self addObject:[NSNull null]];
    
    [self addObject:object];
}
@end

// Pull from start, pop from end, push onto end
@implementation NSMutableArray (StackAndQueueExtensions)
- (id) popObject
{
	if (self.count == 0) return nil;
	
    id lastObject = [self lastObject];
    [self removeLastObject];

    return lastObject;
}

- (id) pop
{
	return [self popObject];
}

- (NSMutableArray *) pushObject:(id)object
{
    [self addObject:object];
	return self;
}

- (NSMutableArray *) push:(id)object
{
	return [self pushObject:object];
}

- (NSMutableArray *) pushObjects:(id)object,...
{
	if (!object) return self;
	id obj = object;
	va_list objects;
	va_start(objects, object);
	do 
	{
		[self addObject:obj];
		obj = va_arg(objects, id);
	} while (obj);
	va_end(objects);
	return self;
}

- (id) pullObject
{
	if (self.count == 0) return nil;
	
	id object = [self firstObject];
	[self removeObjectAtIndex:0];
	return object;
}

- (id) pull
{
	return [self pullObject];
}
@end

#pragma mark NSArray and NSMutableArray Pseudo Dictionary
@implementation NSArray (pseudodictionary)
- (id) objectForKey: (NSString *) aKey
{
	int key = [aKey intValue];
	if ((key < 0) || (key >= self.count)) return nil;
	return self[key];
}
@end

@implementation NSMutableArray (pseudodictionary)
- (void) setObject: (id) object forKey: (NSString *) aKey
{
	int key = [aKey intValue];
	if ((key < 0)  || (key >= self.count))
    {
        NSLog(@"Error: Array index (%d) out of bounds for array with %ld items", key, (long) self.count);
        return;
    }
	[self replaceObjectAtIndex:key withObject:object];
}
@end

#pragma mark - Safe Array
@implementation NSArray (safeArray)
- (id)objectAtIndexedSubscript:(NSUInteger)idx
{
    return [self safeObjectAtIndex:idx];
}
@end

@implementation NSMutableArray (safeArray)
- (void)setObject:(id)anObject atIndexedSubscript:(NSUInteger)index
{
    [self safeSetObject:anObject atIndex:index];
}
@end