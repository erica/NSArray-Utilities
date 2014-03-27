/*
 
 Erica Sadun, http://ericasadun.com
 
 */

#import "CaseInsensitiveDictionary.h"

@interface CaseInsensitiveDictionary ()
@property (nonatomic, strong) NSMutableDictionary *internal;
@end

@implementation CaseInsensitiveDictionary
- (instancetype) init
{
    if (!(self = [super init])) return self;

    _internal = [NSMutableDictionary dictionary];

    return self;
}

+ (instancetype) dictionary {return [[self alloc] init];}
- (NSUInteger) count {return _internal.count;}
- (NSEnumerator *)keyEnumerator {return _internal.keyEnumerator;}

// Return a capitalized key
- (NSString *) adjustedKey: (id < NSCopying >) key
{
    if ([(NSObject *) key isKindOfClass:[NSString class]])
    {
        NSString *theKey = (NSString *) key;
        return theKey.capitalizedString;
    }
    return [(NSObject *)key description].capitalizedString;
}

- (void)setObject:(id)anObject forKey:(id) key
{
    NSString *adjustedKey = [self adjustedKey:key];
    [_internal setObject:anObject forKey:adjustedKey];
}

- (id) objectForKey: (id) key
{
    NSString *adjustedKey = [self adjustedKey:key];
    return [_internal objectForKey:adjustedKey];
}

- (NSMethodSignature *) methodSignatureForSelector:(SEL)selector
{
    NSMethodSignature *signature = [super methodSignatureForSelector:selector];
    if (!signature)
        signature = [_internal methodSignatureForSelector:selector];    
    return signature;
}

- (void)forwardInvocation:(NSInvocation *)invocation
{
    SEL selector = invocation.selector;    
    if ([_internal respondsToSelector:selector])
        [invocation invokeWithTarget:_internal];
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
    if ([super respondsToSelector:aSelector])
        return YES;
    if ([_internal respondsToSelector:aSelector])
        return YES;
    return NO;
}

- (BOOL)isKindOfClass:(Class)aClass
{
    if (aClass == [CaseInsensitiveDictionary class]) return YES;
    if ([_internal isKindOfClass:aClass]) return YES;
    return NO;
}
@end
