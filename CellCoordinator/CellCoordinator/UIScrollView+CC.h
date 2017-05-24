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


/**
 Inserts section into your `UITableView` / `UICollectionView`
 
 @param sectionIndex index for section be inserted at
 @param animated enable inserting animation
 @param block block of code to perform ccAppend:... / ccSetHeader:... / ccSetFooter:... methods to be immediately applied to the section that you are inserting
 
 */
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
 Appends cell at the end of the last section and returns it's source
 
 @param cellClass class of cell to initialize.
 @param params params for cell to be initialized with
 
 @discussion Your cell's class should override method described in `UIView+CC.h`
 
 @return The newly-initialized `CCSource` of cell for specified arguments.
 
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

- (NSArray <CCSource *> *)ccDeleteRowsForCells:(NSArray *)cells animated:(BOOL)animated;

- (NSArray <CCSource *> *)ccDeleteRowsAtIndexPaths:(NSArray <NSIndexPath  *> *)indexPaths animated:(BOOL)animated;

/*
 Cells management
 */

- (NSMutableArray <NSIndexPath *> *)ccIndexPathsForCellClass:(Class)cellClass;


- (NSArray <NSIndexPath *> *)ccIndexPathsForCells:(NSArray *)cells;

- (void)ccReloadCells:(NSArray *)cells animated:(BOOL)animated;

- (void)ccReloadCellsForClass:(Class)cellClass animated:(BOOL)animated;

- (void)ccReloadCellsForPaths:(NSArray <NSIndexPath *> *)paths animated:(BOOL)animated;


- (void)ccDrop;

- (void)ccDropLastSource;

@end
