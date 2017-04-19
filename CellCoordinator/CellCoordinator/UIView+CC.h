//  Created by Darius on 30/03/16.

@class CCSource;

/**
 `CCView` category allows you (1) access important specifications of view and (2) provides basic implementations of methods you need to override.
 */

@interface UIView (CCView)


/**
 @return Parameters you specified for view. Use it in your overriden `-setup` method for example.
 @discussion You are free to change values by any key any time of view's lifecycle
 */
- (NSMutableDictionary*)ccParams;


///---------------------
/// @name Override next methods
///---------------------


/**
 @warning Override this method to perform customization in your subclass of `UITableViewCell` / `UICollectionViewCell` / `UITableViewHeaderFooterView` or `UICollectionReusableView`.
 
 This method will be called on view immediately after dequeue.
 @discussion use `-ccParams` method to access parameters you specified for this view.
 */
- (void)ccSetup;


/**
 @warning Override this method to calculate size of the view based on specified arguments.
 
 @param size of `UITableView / UICollectionView`.
 @param params you specified for view.
 
 @return Size of view for specified requirements.

 */
+ (CGSize)ccSizeForScrollSize:(CGSize)size params:(NSMutableDictionary*)params;


/**
 Override to recognize when the view did become selected.
 Not interested about selection? - Never mind about this.
 
 @return YES if want to reload this cell immediately after selection.
 @discussion Reloading cell after selection can be helpful in case you want to setup view again or resize it.
 
 */
- (BOOL)ccDidSelectAndShouldReload;


/**
 Override this method in case you don't want to cache size of the view.
 @return YES - size cache enabled; and vice versa
 */
+ (BOOL)ccShouldCacheSize;



///---------------------
/// @name Secondary info accessors
///---------------------

/**
 @return IndexPath of view
 @discussion This can be useful when you wanna display index of view to user. Numbered task-list in UITableView for example. And so on.
 */
- (NSIndexPath *)ccIndexPath;


/**
 @return Reuse identifier of view when it queued in `UITableView` / `UICollectionView`.
 @discussion The same as view's class name (by design). You don't need to invoke this method directly.
 Overriding is not recommended.
 */
+ (NSString *)ccReuseIdentifier;


/**
 @return Source for view.
 @discussion In most cases you will need `-ccParams` method, because CCSource is a wrapper for params with some additional info.
 */

- (CCSource *)ccSource;


/**
 @param animated YES for animated reload, NO for non-animated reload
 @discussion Use [self reloadAnimated:] inside cell to reload it. This way you don't need to interact with UITableView/UICollectionView itself.
 */
- (void)reloadAnimated:(BOOL)animated;


/**
 @param animated YES for animated remove, NO for non-animated
 @discussion Use [self removeAnimated:] inside cell to remove it. This way you don't need to interact with UITableView/UICollectionView itself.
 */
- (void)removeAnimated:(BOOL)animated;

@end
