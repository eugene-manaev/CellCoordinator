//  Created by Darius on 30/03/16.

#import "CCSource.h"
#import <objc/runtime.h>
#import "UIView+CC.h"

#define ASSERTS_STRING @"You should override this method"

@implementation UIView (CCView)

+ (NSString*)ccReuseIdentifier {
    
    return NSStringFromClass(self.class);
}

+ (CGSize)ccSizeForScrollSize:(CGSize)size params:(NSMutableDictionary*)params {
    
    NSAssert(NO, ASSERTS_STRING);
    
    return CGSizeZero;
}

- (void)ccSetup {
    
    
}

- (BOOL)ccDidSelectAndShouldReload {
    
    return NO;
}

+ (BOOL)ccShouldCacheSize {
    return YES;
}


- (CCSource *)ccSource {
    return objc_getAssociatedObject(self, @selector(ccSource));
}

- (void)ccSetSource:(CCSource*)source {
    objc_setAssociatedObject(self, @selector(ccSource), source, OBJC_ASSOCIATION_ASSIGN);
}

- (NSMutableDictionary*)ccParams {
    return [[self ccSource] params];
}

- (NSIndexPath *)ccIndexPath {
    return objc_getAssociatedObject(self, @selector(ccIndexPath));
}

- (void)ccSetIndexPath:(NSIndexPath *)indexPath {
    objc_setAssociatedObject(self, @selector(ccIndexPath), indexPath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


@end
