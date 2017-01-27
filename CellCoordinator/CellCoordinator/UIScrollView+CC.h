//  Created by Darius on 24/10/16.

@class CCSource, CCSection;

@interface UIScrollView (CellCoordinator)


/**
 Call in `-viewDidLoad` for example, to setup your `UITableView` / `UICollectionView` with Cell Coordinator
 */
- (void)ccInitializeWithDelegate:(id)delegate;


/**
 Closes last section of `UITableView` / `UICollectionView` and appends new one.
 Leave it alone in case you want only single section, cause first section exists by default.
 */
- (void)ccBuildSection;


- (void)ccInsertSectionAtIndex:(NSInteger)sectionIndex animated:(BOOL)animated prepareSectionBlock:(void (^)())block;

/**
 @return Array of currently presented sections
 */
- (NSMutableArray <CCSection *> *)ccSections;


/**
 @return Section at specified index
 */
- (CCSection *)ccSectionAtIndex:(NSUInteger)index ;

- (CCSource *)ccSourceAtIndexPath:(NSIndexPath *)indexPath;

/**
 Appends cell at the and of the last section and returns it's source
 
 @param cellClass class of cell to initialize.
 @param params ?
 
 @discussion Your cell's class should override method described in `UIView+CC.h`
 
 @return 
 
*/
- (CCSource *)ccAppend:(Class)cellClass params:(NSMutableDictionary**)params;

- (CCSource *)ccSetHeader:(Class)headerClass params:(NSMutableDictionary**)params;

- (CCSource *)ccSetFooter:(Class)footerClass params:(NSMutableDictionary**)params;


/**
 Setts index to current section, to be displayed at the left side of the UITableView. (For UITableView only)
 
 @param sectionIndexName will be displayed at the left side
 
 @discussion Indexes are displaying only when indexName provided for every UITableView section
 
 */
- (void)ccSetSectionIndex:(NSString *)sectionIndexName;

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
