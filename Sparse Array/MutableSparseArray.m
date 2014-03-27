/*
 
 Initially by JW. Public Domain, Use at your own risk.
 All bad coding is mine. All good ideas are his.
 
 */

#import "MutableSparseArray.h"

@implementation MutableSparseArray
{
    NSMutableDictionary *_sparseData;
}

- (id) init
{
    if ((self = [super init]))
        _sparseData = [NSMutableDictionary dictionary];
    return self;
}

- (id) initWithCapacity:(NSUInteger)numItems
{
    return [self init];
}

#pragma mark - 

- (NSUInteger) count
{
    return _sparseData.count;
}

- (NSArray *) sortedIndices
{
    return [_sparseData.allKeys sortedArrayUsingSelector:@selector(compare:)];
}

- (NSArray *) packedData
{
    NSMutableArray *packedData = [NSMutableArray array];
    for (NSNumber *number in [self sortedIndices])
        [packedData addObject:_sparseData[number]];
    return packedData;
}

#pragma mark -

- (id) objectAtIndex:(NSUInteger)index
{
    return _sparseData[@((NSUInteger)index)];
}

- (void) insertObject:(id)anObject atIndex:(NSUInteger)index
{
    NSArray *sortedIndices = [self sortedIndices];
    NSRange fullRange = NSMakeRange(0, sortedIndices.count);
    NSComparator comparator = ^NSComparisonResult(id obj1, id obj2){
        return [obj1 compare:obj2];};

    NSInteger sliceIndex = [sortedIndices indexOfObject:@(index)
                                       inSortedRange:fullRange
                                             options:NSBinarySearchingInsertionIndex
                                     usingComparator:comparator];
    
    NSRange sliceRange = NSMakeRange(sliceIndex, sortedIndices.count - sliceIndex);
    NSArray *toShift = [sortedIndices subarrayWithRange:sliceRange];
    
    for (NSNumber *shiftIndex in [toShift reverseObjectEnumerator])
        _sparseData[@(1 + shiftIndex.unsignedIntValue)] = _sparseData[shiftIndex];
    
    _sparseData[@(index)] = anObject;
}

- (void) removeObjectAtIndex:(NSUInteger)index
{
    [_sparseData removeObjectForKey:@(index)];
}

- (void) addObject:(id)anObject
{
    NSArray *sortedIndices = [self sortedIndices];
    NSUInteger newIndex = [sortedIndices.lastObject integerValue] + 1;
    _sparseData[@(newIndex)] = anObject;
}

- (void) removeLastObject
{
    NSArray *sortedIndices = [self sortedIndices];
    [_sparseData removeObjectForKey:[sortedIndices lastObject]];
}

- (void) replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject
{
    _sparseData[@(index)] = anObject;
}
@end

