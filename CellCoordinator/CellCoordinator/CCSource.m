//  Created by Darius on 16/12/15.

#import "CCSource.h"
#import "UIView+CC.h"

NSString *const kPreloadedCell = @"__cell";

@interface CCSource()

// Caching size

@property (nonatomic, weak) UIScrollView *scrollView;

@property (nonatomic) BOOL cacheAvailable;

@property (nonatomic, strong) NSMutableDictionary *cache;

@end

@implementation CCSource

+ (instancetype)sourceWithClass:(Class)cellClass params:(NSMutableDictionary *)params {
    
    CCSource *source = [[CCSource alloc] init];
    
    if (source != nil) {
        
        source.cellClass = cellClass;
        source.params = params ?: [NSMutableDictionary dictionary];
        source.cacheAvailable = ((BOOL) [cellClass performSelector:@selector(ccShouldCacheSize)]) == YES;
        
        if (source.cacheAvailable) {
            source.cache = [NSMutableDictionary dictionary];
        }
        
    }
    
    return source;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"

- (NSString*)reuseIdentifier {
    // От этого мы не можем избавиться, пока у нас есть старая страничка агента. Она тянет за собой тему, что cellIdentifier может не соотвествовать cellClass
    return [_cellClass performSelector:@selector(ccReuseIdentifier)];
}

// Лучше не задумываться, что здесь написано. Оно просто работает.
// Но если кому-то интересно. Это применение метода с тремя аргументами к классу, которое в данной ситуации другим способом сделать не получится.


- (CGSize)sizeForScrollSize:(CGSize)size {
    
    
    // Setup key for cache
    NSValue *scrollSizeObject = nil;
    
    
    NSValue *cachedValue = nil;
    
    if (_cacheAvailable) {
        
        scrollSizeObject = [NSValue valueWithCGSize:size];
        
        // Check data in cache for current key. If it's exists, return it!
        cachedValue = _cache[scrollSizeObject];
        
        if (cachedValue != nil) {
            
            CGSize cachedSize = cachedValue.CGSizeValue;
            
            return cachedSize;
        }
        
    }
    

    
    SEL sizeSelector = @selector(ccSizeForScrollSize:params:);
    
    NSMethodSignature *methodSign = [_cellClass methodSignatureForSelector:sizeSelector];
    
    NSInvocation *methodInvocation = [NSInvocation invocationWithMethodSignature:methodSign];
    
    methodInvocation.selector = sizeSelector;
    
    methodInvocation.target = _cellClass;
    
    // Set size as second param
    
    [methodInvocation setArgument:&size atIndex:2];
    
  
    [methodInvocation setArgument:&_params atIndex:3];
    
    // go for it!
    [methodInvocation invoke];
    
    CGSize cellSize;
    
    [methodInvocation getReturnValue:&cellSize];
    
    
    
    // Save new value to cache
    
    if (_cacheAvailable) {
        cachedValue = [NSValue valueWithCGSize:cellSize];
        
        _cache[scrollSizeObject] = cachedValue;
    }
    
    return cellSize;
}

- (void)clearSizesCache {
    
    if (_cacheAvailable) {
         _cache = [NSMutableDictionary dictionary];
    }
}

#pragma clang diagnostic pop

@end
