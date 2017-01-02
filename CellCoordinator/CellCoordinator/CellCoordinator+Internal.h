//  Created by Darius on 02/01/17.

#ifndef CellCoordinator_Internal
#define CellCoordinator_Internal

@class CCSource;


@interface UIView (CCViewInternal)

- (void)ccSetSource:(CCSource *)source;

- (void)ccSetIndexPath:(NSIndexPath *)indexPath;

@end


@interface CCSource (Internal)

+ (instancetype)sourceWithClass:(Class)cellClass params:(NSMutableDictionary *)params;

- (NSString *)reuseIdentifier;

- (CGSize)sizeForScrollSize:(CGSize)size;

@end

#endif /* CellCoordinator_Internal_h */
