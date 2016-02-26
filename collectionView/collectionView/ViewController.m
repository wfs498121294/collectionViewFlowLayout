//
//  ViewController.m
//  collectionView
//
//  Created by smc on 16/2/25.
//  Copyright © 2016年 smc. All rights reserved.
//

#import "ViewController.h"
#import "SMCRelatedRecommendCell.h"
#import "SMCFMSectionHeadView.h"
#import "SMCFMSectionFootView.h"
#import "SMCViewController.h"
#define VIEW_WIDTH [UIScreen mainScreen].bounds.size.width
#define VIEW_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    UICollectionViewFlowLayout *layOut = [[UICollectionViewFlowLayout alloc] init];
    self.collectionView =[[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layOut];
    self.collectionView.delegate = self;
    self.collectionView.dataSource =self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"SMCRelatedRecommendCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"SMCFMSectionHeadView" bundle:nil]  forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"headView"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"SMCFMSectionFootView" bundle:nil]  forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footView"];
}

#pragma mark - collectionDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return 9;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    
    return 3;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((VIEW_WIDTH-40)/3, 141);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    
    return UIEdgeInsetsMake(0, 10.0, 0, 10.0);
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    
    return 10.0;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    
    return 10.0;
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    SMCFMSectionHeadView *headView = nil;
     SMCFMSectionFootView *footView = nil;
    if (kind==UICollectionElementKindSectionHeader)
    {
        headView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"headView" forIndexPath:indexPath];
        NSLog(@"section:%ld---item:%ld",indexPath.section,indexPath.row);
         return headView;
    }
    else if(kind ==UICollectionElementKindSectionFooter)
    {
     footView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"footView" forIndexPath:indexPath];
         NSLog(@"sectionFooter:%ld---item:%ld",indexPath.section,indexPath.row);
     return footView;
    }
    else{
      
    }
    return headView;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SMCRelatedRecommendCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(VIEW_WIDTH, 40);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(VIEW_WIDTH, 40);
}
/**
 *   点这个地方试试  
 */
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

    SMCViewController *vc = [[SMCViewController alloc] init];
    
    [self presentViewController:vc animated:YES completion:nil];
}
@end
