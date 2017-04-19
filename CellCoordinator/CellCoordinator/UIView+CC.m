//  Created by Darius on 30/03/16.

#import "CCSource.h"
#import <objc/runtime.h>
#import "UIView+CC.h"
#import "UIScrollView+CC.h"
#import "CellCoordinator+Internal.h"

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
    return [[[self ccSource] scrollView] ccIndexPathsForCells:@[self]].firstObject;
}

- (void)reloadAnimated:(BOOL)animated {
    [[[self ccSource] scrollView] ccReloadCells:@[self] animated:animated];
}

- (void)removeAnimated:(BOOL)animated {
    [[[self ccSource] scrollView] ccDeleteRowsForCells:@[self] animated:animated];
}

@end
