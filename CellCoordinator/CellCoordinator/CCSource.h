//  Created by Darius on 16/12/15.

#import <UIKit/UIKit.h>

// For private usage only:
extern NSString *const kPreloadedCell;


@interface CCSource : NSObject


@property (nonatomic) Class cellClass;

@property (nonatomic, strong) NSMutableDictionary *params;


- (void)clearSizesCache;  // Clears height cache

@end
