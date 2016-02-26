//
//  SMCViewController.m
//  collectionView
//
//  Created by smc on 16/2/25.
//  Copyright © 2016年 smc. All rights reserved.
//

#import "SMCViewController.h"
#import "SMCRelatedRecommendCell.h"
#import "SMCFMSectionHeadView.h"
#import "SMCFMSectionFootView.h"
#import "WFSCollectionViewFlemishBondLayout.h"
@interface SMCViewController () <UICollectionViewDataSource, UICollectionViewDelegate,WFSCollectionViewFlemishBondLayoutDelegate>
@property (nonatomic, strong) WFSCollectionViewFlemishBondLayout *collectionViewLayout;
@property (nonatomic, readonly) UICollectionView *collectionView;
@end

@implementation SMCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setup];
}
- (UICollectionView *)collectionView
{
    return (UICollectionView *)self.view;
}

- (void)setup
{
    self.collectionViewLayout = [[WFSCollectionViewFlemishBondLayout alloc] init];
    self.collectionViewLayout.delegate = self;
    self.collectionViewLayout.numberOfElements = 3;
    self.collectionViewLayout.highlightedCellHeight = 260.0f;
    self.collectionViewLayout.highlightedCellWidth = 0.0;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.collectionViewLayout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = [UIColor whiteColor];
    [collectionView registerNib:[UINib nibWithNibName:@"SMCRelatedRecommendCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    [collectionView registerNib:[UINib nibWithNibName:@"SMCFMSectionHeadView" bundle:nil]  forSupplementaryViewOfKind:WFSCollectionViewFlemishBondHeaderKind withReuseIdentifier:@"headView"];
    [collectionView registerNib:[UINib nibWithNibName:@"SMCFMSectionFootView" bundle:nil]  forSupplementaryViewOfKind:WFSCollectionViewFlemishBondFooterKind withReuseIdentifier:@"footView"];
    
    self.view = collectionView;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    
    return 9;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SMCRelatedRecommendCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    return cell;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    SMCFMSectionHeadView *headView = nil;
    SMCFMSectionFootView *footView = nil;
    if (kind==WFSCollectionViewFlemishBondHeaderKind)
    {
        headView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"headView" forIndexPath:indexPath];
   
        return headView;
    }
    else if(kind ==WFSCollectionViewFlemishBondFooterKind)
    {
        footView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"footView" forIndexPath:indexPath];
        
        return footView;
    }
    else{
        
    }
    return headView;
}

#pragma mark - WFSCollectionViewVunityLayoutDelegate
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(WFSCollectionViewFlemishBondLayout *)collectionViewLayout estimatedSizeForHeaderInSection:(NSInteger)section
{
    if (section==0) {
        return CGSizeMake(CGRectGetWidth(self.collectionView.frame), 60);
    }
    else if (section==1)
    {
        return CGSizeMake(CGRectGetWidth(self.collectionView.frame), 80);
    }
    else return CGSizeMake(CGRectGetWidth(self.collectionView.frame), 100);
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(WFSCollectionViewLayout *)collectionViewLayout estimatedSizeForFooterInSection:(NSInteger)section
//{
//    return CGSizeMake(CGRectGetWidth(self.collectionView.fWFSe), 40);
//}

- (WFSCollectionViewFlemishBondLayoutGroupDirection)collectionView:(UICollectionView *)collectionView layout:(WFSCollectionViewFlemishBondLayout *)collectionViewLayout highlightedCellDirectionForGroup:(NSInteger)group atIndexPath:(NSIndexPath *)indexPath
{
    WFSCollectionViewFlemishBondLayoutGroupDirection direction;
    
    if (indexPath.row % 2) {
        direction = WFSCollectionViewFlemishBondLayoutGroupDirectionRight;
    } else {
        direction = WFSCollectionViewFlemishBondLayoutGroupDirectionLeft;
    }
    
    return direction;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"%ld",indexPath.item);
}
@end



