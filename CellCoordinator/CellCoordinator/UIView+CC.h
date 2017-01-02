//  Created by Darius on 30/03/16.

@class CCSource;

@interface UIView (CCView)

// Class methods

+ (NSString *)ccReuseIdentifier;

+ (CGSize)ccSizeForScrollSize:(CGSize)size params:(NSMutableDictionary*)params;

// Instance methods

- (void)ccSetup;

- (BOOL)ccDidSelectAndShouldReload;


// If you want CCManager to disable height's cache, override this method and return NO

+ (BOOL)ccShouldCacheSize;



// Getting and setting attached source

- (CCSource *)ccSource;


// Getting and setting attached params

- (NSMutableDictionary*)ccParams;


// Getting and setting attached indexPath

- (NSIndexPath *)ccIndexPath;

@end
