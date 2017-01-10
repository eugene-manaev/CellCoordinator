//  Created by Darius on 16/12/15.


#import <UIKit/UIKit.h>

/// For private usage only. We use this key to store manualy created view (non-dequeued)
extern NSString *const kPreloadedCell;


/*!
 `CCSource` contains all necessary information to create and setup view. 
 
 @discussion In most cases you don't need to use CCSource directly.
 
 @warning You should not instantiate `CCSource` directly.
 
 */

@interface CCSource : NSObject


/**
 Stores class of this source's view. In case you wanna use xib it should have the exact same name as class. (class `GoodTableViewCell` should have xib named GoodTableViewCell.xib)
 */
@property (nonatomic) Class cellClass;


/**
 Stores the parameters you specified for this source's view.
 @discussion You ara free use this params soever. This is the same params, that you passing in `UITableView -ccAppend:params:` method for example.
 */
@property (nonatomic, strong) NSMutableDictionary *params;


/**
 It clears height cache in case height cache enabled for source's view
 */
- (void)clearSizesCache;

@end
