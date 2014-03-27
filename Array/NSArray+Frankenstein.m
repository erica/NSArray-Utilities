/*
 
 Erica Sadun, http://ericasadun.com
 
 */

#import "NSArray+Frankenstein.h"

#pragma mark - NSArray Utility -

@implementation NSArray (Frankenstein)

#pragma mark - Custom description

- (NSString *) descriptionWithLocale:(id)locale
{
    NSMutableString *description = [NSMutableString string];
    NSArray *descriptionArray = [self map:^id(id object) {if ([object respondsToSelector:@selector(descriptionWithLocale:)]) return [object descriptionWithLocale:locale]; return [object description];}];

    [description appendString:@"["];
    [description appendString:[descriptionArray componentsJoinedByString:@", "]];
    [description appendString:@"]"];
    
    return description;
}

# pragma mark - va_list

- (va_list) va_list
{
    NSMutableData *data = [NSMutableData dataWithLength:(sizeof(id) * self.count)];
    [self getObjects: (__unsafe_unretained id *)data.mutableBytes range:NSMakeRange(0, self.count)];
    return data.mutableBytes;
}


#pragma mark - Random

- (id) randomItem
{
    if (!self.count) return nil;
    
    static BOOL seeded = NO;
    if (!seeded) {seeded = YES; srandom((unsigned int) time(0));}

    int whichItem = (NSUInteger)(random() % self.count);
    return self[whichItem];
}

- (NSArray *) scrambled
{
    static BOOL seeded = NO;
    if (!seeded) {seeded = YES; srandom((unsigned int) time(0));}
    
    NSMutableArray *resultArray = [self mutableCopy];
	for (int i = 0; i < (self.count - 2); i++)
		[resultArray exchangeObjectAtIndex:i withObjectAtIndex:(i + (random() % (self.count - i)))];
	return resultArray.copy;
}

#pragma mark - Utility

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


#pragma mark - Set theory

- (NSArray *) uniqueElements
{
    return [NSOrderedSet orderedSetWithArray:self].array.copy;
}

- (NSArray *) unionWithArray: (NSArray *) anArray
{
    NSMutableOrderedSet *set1 = [NSMutableOrderedSet orderedSetWithArray:self];
    NSMutableOrderedSet *set2 = [NSMutableOrderedSet orderedSetWithArray:anArray];
    
    [set1 unionOrderedSet:set2];
    
    return set1.array.copy;
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
    NSMutableOrderedSet *set1 = [NSMutableOrderedSet orderedSetWithArray:self];
    NSMutableOrderedSet *set2 = [NSMutableOrderedSet orderedSetWithArray:anArray];
    
    [set1 minusOrderedSet:set2];

    return set1.array.copy;
}

#pragma mark - Lisp

- (id) car
{
    if (self.count == 0) return nil;
    return self[0];
}

- (NSArray *) cdr
{
    if (self.count < 2) return nil;
    return [self subarrayWithRange:NSMakeRange(1, self.count - 1)];
}

- (NSArray *) map: (MapBlock) aBlock
{
    if (!aBlock) return self;
    
    NSMutableArray *resultArray = [NSMutableArray array];
    for (id object in self)
    {
        id result = aBlock(object);
        [resultArray addObject: result ? : [NSNull null]];
    }
    return [resultArray copy];
}

- (NSArray *) collect: (TestingBlock) aBlock
{
    if (!aBlock) return self;
    
    NSMutableArray *resultArray = [NSMutableArray array];
    for (id object in self)
    {
        BOOL result = aBlock(object);
        if (result)
            [resultArray addObject:object];
    }
    return [resultArray copy];
}

- (NSArray *) reject: (TestingBlock) aBlock
{
    if (!aBlock) return self;
    
    NSMutableArray *resultArray = [NSMutableArray array];
    for (id object in self)
    {
        BOOL result = aBlock(object);
        if (!result)
            [resultArray addObject:object];
    }
    return [resultArray copy];
}
@end


#pragma mark - NSMutableArray Utility -

@implementation NSMutableArray (Frankenstein)

- (NSMutableArray *) reverseSelf
{
	for (int i = 0; i < (floor(self.count/2.0)); i++) 
		[self exchangeObjectAtIndex:i withObjectAtIndex:(self.count-(i+1))];
	return self;
}

@end

#pragma mark - Stack and Queue -

// Pull from start, pop from end, push onto end
@implementation NSMutableArray (StackAndQueueExtensions)
- (id) popObject
{
	if (self.count == 0) return nil;
	
    id lastObject = [self lastObject];
    [self removeLastObject];

    return lastObject;
}

- (NSMutableArray *) pushObject:(id)object
{
    [self addObject:object];
	return self;
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
@end

#pragma mark - NSArray and NSMutableArray Pseudo Dictionary -

// Primarily used for key path for property list utilities

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

#pragma mark - Safe Arrays -

@implementation NSArray (safeArray)

// Consider using Sparse Array instead
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

- (id)objectAtIndexedSubscript:(NSUInteger)idx
{
    return [self safeObjectAtIndex:idx];
}
@end

@implementation NSMutableArray (safeArray)

// Consider using Sparse Array instead
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

- (void)setObject:(id)anObject atIndexedSubscript:(NSUInteger)index
{
    [self safeSetObject:anObject atIndex:index];
}
@end