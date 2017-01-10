//  Created by Darius on 01/11/16.

#import <Foundation/Foundation.h>

/**
 `CCCManager` is for private usage inside `UIScrollView+CC`
 Documentation will be soon.
 */

@interface CCManager : NSObject <UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>

- (instancetype)initWithTableView:(UITableView*)tableView delegate:(id)delegate;

- (instancetype)initWithCollectionView:(UICollectionView*)collectionView delegate:(id)delegate;

@end
