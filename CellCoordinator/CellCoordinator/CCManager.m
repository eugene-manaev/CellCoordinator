//  Created by Darius on 01/11/16.

#import "CCSource.h"
#import "CCSection.h"
#import "CCManager.h"
#import "UIView+CC.h"
#import "UIScrollView+CC.h"
#import "CellCoordinator+Internal.h"



@interface CCManager()

@property (nonatomic, weak) id delegate;

// Table

@property (nonatomic) BOOL callsWillDisplayCellforRowAtIndexPath;
@property (nonatomic) BOOL callsDidEndDisplayingCellForRowAtIndexPath;

// Scroll

@property (nonatomic) BOOL callsScrollViewDidScroll;
@property (nonatomic) BOOL callsScrollViewWillBeginDragging;
@property (nonatomic) BOOL callsScrollViewWillBeginDecelerating;
@property (nonatomic) BOOL callsScrollViewDidEndDecelerating;
@property (nonatomic) BOOL callsScrollViewDidEndDragging;
@property (nonatomic) BOOL callsScrollViewDidEndScrollingAnimation;

@end


@implementation CCManager

- (instancetype)initWithTableView:(UITableView*)tableView  delegate:(id)delegate {
    
    self = [super init];
    
    if (self) {
        
        tableView.delegate = self;
        
        tableView.dataSource = self;
        
        self.delegate = delegate;
        
    }
    
    return self;
    
}

- (instancetype)initWithCollectionView:(UICollectionView*)collectionView  delegate:(id)delegate {
    
    self = [super init];
    
    if (self) {
        
        collectionView.delegate = self;
        
        collectionView.dataSource = self;
        
        self.delegate = delegate;
        
    }
    
    return self;
    
}

- (void)setDelegate:(id)delegate {
    
    _delegate = delegate;
    
    self.callsScrollViewDidScroll = [delegate respondsToSelector:@selector(scrollViewDidScroll:)];
    
    self.callsScrollViewWillBeginDragging = [delegate respondsToSelector:@selector(scrollViewWillBeginDragging:)];
    
    self.callsScrollViewWillBeginDecelerating = [delegate respondsToSelector:@selector(scrollViewWillBeginDecelerating:)];
    
    self.callsScrollViewDidEndDecelerating = [delegate respondsToSelector:@selector(scrollViewDidEndDecelerating:)];
    
    self.callsWillDisplayCellforRowAtIndexPath = [delegate respondsToSelector:@selector(tableView:willDisplayCell:forRowAtIndexPath:)];
    
    self.callsDidEndDisplayingCellForRowAtIndexPath = [delegate respondsToSelector:@selector(tableView:didEndDisplayingCell:forRowAtIndexPath:)];
    
    self.callsScrollViewDidEndDragging = [delegate respondsToSelector:@selector(scrollViewDidEndDragging:willDecelerate:)];
    
    self.callsScrollViewDidEndScrollingAnimation = [delegate respondsToSelector:@selector(scrollViewDidEndScrollingAnimation:)];

    
}

#pragma mark -UIScrollView

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (self.callsScrollViewDidScroll) {
        [self.delegate scrollViewDidScroll:scrollView];
    }
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    if (self.callsScrollViewWillBeginDragging) {
        [self.delegate scrollViewWillBeginDragging:scrollView];
    }
    
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    
    if (self.callsScrollViewWillBeginDecelerating) {
        [self.delegate scrollViewWillBeginDecelerating:scrollView];
    }
    
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    if (self.callsScrollViewDidEndDragging) {
        [self.delegate scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
    }
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if (self.callsScrollViewDidEndDecelerating) {
        [self.delegate scrollViewDidEndDecelerating:scrollView];
    }
    
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
    if (self.callsScrollViewDidEndScrollingAnimation) {
        [self.delegate scrollViewDidEndScrollingAnimation:scrollView];
    }
    
}

#pragma mark -UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[tableView ccSections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [[tableView ccSectionAtIndex:section] count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CCSource *cellSource = [tableView ccSourceAtIndexPath:indexPath];
    
    NSString *cellIdentifier = [cellSource reuseIdentifier];
    
    // Probably there's preloaded cell
    UITableViewCell *cell = cellSource.params[kPreloadedCell];
    
    if (cell == nil) {
         cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    }
    
   
    
    [cell ccSetSource:cellSource];
    
    [cell ccSetIndexPath:indexPath];
    
    [cell ccSetup];
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CCSource *cellSource = [tableView ccSourceAtIndexPath:indexPath];
    
    return [cellSource sizeForScrollSize:tableView.frame.size].height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIView *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    BOOL shouldReloadCell = [cell ccDidSelectAndShouldReload];
    
    if (shouldReloadCell == NO) {
        return;
    }
    
    [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.callsWillDisplayCellforRowAtIndexPath) {
        [self.delegate tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
        
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)sectionIdx {
    
    CCSection *section = [tableView ccSectionAtIndex:sectionIdx];
    
    CCSource *headerSource = [section sourceForHeader];
    
    NSString *headerIdentifier = [headerSource reuseIdentifier];
    
    UIView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerIdentifier];
    
    [headerView ccSetSource:headerSource];
    
    [headerView ccSetup];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)sectionIdx {
    
    CCSection *section = [tableView ccSectionAtIndex:sectionIdx];
    
    CCSource *headerSource = [section sourceForHeader];
    
    if (headerSource == nil) {
        return 0.0;
    }
    
    return [headerSource sizeForScrollSize:tableView.frame.size].height;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)sectionIdx {
    
    CCSection *section = [tableView ccSectionAtIndex:sectionIdx];
    
    CCSource *footerSource = [section sourceForFooter];
    
    NSString *footerIdentifier = [footerSource reuseIdentifier];
    
    UIView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:footerIdentifier];
    
    [footerView ccSetSource:footerSource];
    
    [footerView ccSetup];
    
    return footerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)sectionIdx {
    
    CCSection *section = [tableView ccSectionAtIndex:sectionIdx];
    
    CCSource *footerSource = [section sourceForFooter];
    
    
    if (footerSource == nil) {
        return 0.01;
    }
    
    return [footerSource sizeForScrollSize:tableView.frame.size].height;
    
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.callsDidEndDisplayingCellForRowAtIndexPath == YES) {
        
        [self.delegate tableView:tableView didEndDisplayingCell:cell forRowAtIndexPath:indexPath];
        
    }
    
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    
    NSMutableArray <NSString *> *indexes = [NSMutableArray array];
    
    for (CCSection *section in [tableView ccSections]) {
        
        if (section.indexName != nil) {
            [indexes addObject:section.indexName];
        } else {
            return nil;
        }
        
    }
    
    return indexes;
}

#pragma mark -UICollectionView

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return [[collectionView ccSections] count];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [[collectionView ccSectionAtIndex:section] count];
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CCSource *cellSource = [collectionView ccSourceAtIndexPath:indexPath];
    
    NSString *cellIdentifier = [cellSource reuseIdentifier];
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    [cell ccSetSource:cellSource];
    
    [cell ccSetIndexPath:indexPath];
    
    [cell ccSetup];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CCSource *cellSource = [collectionView ccSourceAtIndexPath:indexPath];
    
    return [cellSource sizeForScrollSize:collectionView.frame.size];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UIView *cell = [collectionView cellForItemAtIndexPath:indexPath];
    
    BOOL shouldReload = [cell ccDidSelectAndShouldReload];
    
    if (!shouldReload) {
        return;
    }
    
    [collectionView reloadItemsAtIndexPaths:@[indexPath]];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)sectionIdx {
    
    CCSection *section = [collectionView ccSectionAtIndex:sectionIdx];
    
    CCSource *headerSource = [section sourceForHeader];
    
    return [headerSource sizeForScrollSize:collectionView.frame.size];
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)sectionIdx {
    
    CCSection *section = [collectionView ccSectionAtIndex:sectionIdx];
    
    CCSource *footerSource = [section sourceForFooter];
    
    return [footerSource sizeForScrollSize:collectionView.frame.size];
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    
    CCSection *section = [collectionView ccSectionAtIndex:indexPath.section];
    
    CCSource *source = nil;
    
    if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        source = [section sourceForFooter];
    } else if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        source = [section sourceForHeader];
    }
    
    NSString *identifier = [source reuseIdentifier];
    
    UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:identifier forIndexPath:indexPath];
    
    [view ccSetSource:source];
    
    [view ccSetup];
    
    return view;
}



@end
