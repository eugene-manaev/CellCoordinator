//  Created by Darius on 27/10/16.

#import <Foundation/Foundation.h>

@class CCSource;

/**
 `CCSection` keeps some amount of `CCSource` for section in `UITableView` / `UICollectionView`. 
 It provides getters and setters for cells, header and footer. We use it internally only now.
 */

@interface CCSection : NSObject


/**
 @return The newly-initialized empty section.
 */
+ (instancetype)section;


///---------------------
/// @name Setters
///---------------------


/**
 Appends new cell's source at the end of section and returns it's source.
 
 @param cellClass class to initialize cell.
 @param params params specified to setup cell.
 
 @return The newly-initialized `CCSource` of cell for specified arguments.
 */
- (CCSource*)appendCell:(Class)cellClass params:(NSMutableDictionary**)params;

/**
 Sets new header's source for section or replaces old one and returns it's source.
 
 @params headerClass class to initialize header.
 @params params params specified to setup header.
 
 @return The newly-initialized `CCSource` of header for specified arguments.
 */
- (CCSource*)setHeader:(Class)headerClass params:(NSMutableDictionary**)params;


/**
 Sets new footer's source for section or replaces old one and return it's source.
 
 @params footerClass class to initialize footer.
 @params params params specified to setup footer.
 
 @return The newly-initialized `CCSource` of footer for specified arguments.
 */
- (CCSource*)setFooter:(Class)footerClass params:(NSMutableDictionary**)params;


/**
 Inserts new cell's source at specified index and returns it's source.
 
 @param cellClass class to initialize cell.
 @param params params specified to setup cell.
 @param index index to insert cell at.
 
 @return The newly-initialized `CCSource` of cell for specified arguments.
 */
- (CCSource*)insertCell:(Class)cellClass params:(NSMutableDictionary**)params atIndex:(NSInteger)index;


///---------------------
/// @name Getters
///---------------------


/**
 @return number of cells currently presented in section.
 */
- (NSUInteger)count;

/**
 @return array of sources for cells currently presented in section.
 */
- (NSMutableArray <CCSource *> *)sources;

/**
 @return source of cell at specified index or nil if no cell for index exists.
 */
- (CCSource*)sourceAtIndex:(NSUInteger)index;

/**
 @return source of header or nil if it does not exist.
 */
- (CCSource*)sourceForHeader;

/**
 @return source of footer or nil if it does not exist.
 */
- (CCSource*)sourceForFooter;


///---------------------
/// @name Other mutators
///---------------------

/**
 Removes last cell's source. Does nothing if section has no sources.
 */
- (void)dropLastSource;

@end
