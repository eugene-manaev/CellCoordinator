//  Created by Darius on 01/11/16.

#import <Foundation/Foundation.h>

@interface CCManager : NSObject <UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>

- (instancetype)initWithTableView:(UITableView*)tableView delegate:(id)delegate;

- (instancetype)initWithCollectionView:(UICollectionView*)collectionView delegate:(id)delegate;

@end
