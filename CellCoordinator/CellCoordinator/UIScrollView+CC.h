//  Created by Darius on 24/10/16.

@class CCSource, CCSection;

@interface UIScrollView (CellCoordinator)


- (void)ccInitializeWithDelegate:(id)delegate;

- (void)ccBuildSection;


// Getters

- (NSMutableArray <CCSection *> *)ccSections;

- (CCSection *)ccSectionAtIndex:(NSUInteger)index ;

- (CCSource *)ccSourceAtIndexPath:(NSIndexPath *)indexPath;

/*
 Setters
*/

- (CCSource *)ccAppend:(Class)cellClass params:(NSMutableDictionary**)params;

- (CCSource *)ccSetHeader:(Class)headerClass params:(NSMutableDictionary**)params;

- (CCSource *)ccSetFooter:(Class)footerClass params:(NSMutableDictionary**)params;

/*
 Inserts
 */

- (CCSource *)ccInsert:(Class)cellClass params:(NSMutableDictionary **)params atIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated;

/*
 Deletes
 */

- (NSArray <CCSource *> *)ccDeleteRowsAtIndexPaths:(NSArray <NSIndexPath  *> *)indexPaths animated:(BOOL)animated;

/*
 Cells management
 */

- (NSMutableArray <NSIndexPath *> *)ccIndexPathsForCellClass:(Class)cellClass;

- (void)ccReloadCellsForClass:(Class)cellClass animated:(BOOL)animated;

- (void)ccReloadCellsForPaths:(NSArray <NSIndexPath *> *)paths animated:(BOOL)animated;


- (void)ccDrop;

- (void)ccRemoveSourceAtIndex:(NSIndexPath *)indexPath;

- (void)ccDropLastSource;

@end
