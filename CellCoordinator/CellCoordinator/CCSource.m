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
   // return NSStringFromClass(_cellClass);
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
    
    CGSize cellSize = [_cellClass ccSizeForScrollSize:size params:self.params];
    
    
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
