//
//  FontStyleDisplayViewController.m
//  FontChoose
//
//  Created by 李南 on 15/12/3.
//  Copyright © 2015年 ctd.leonard. All rights reserved.
//

#import "FontStyleDisplayViewController.h"
#import "FontDisplayCell.h"
#import "TextInputViewController.h"
#import "PresentAnimator.h"
#import "DimissAnimator.h"
#import "UIView+SetRect.h"
#import "UIImage+BitMap.h"
#import "UIColor+CustomColor.h"
#import "TextInfos.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "textInfosInputTBC.h"
#import "InputTextInfo.h"
#import "CurrentTextInfoViewController.h"
#define Test

@interface FontStyleDisplayViewController ()<UIViewControllerTransitioningDelegate,FontDisplayCellDelegate,UISearchResultsUpdating,UISearchControllerDelegate,UISearchBarDelegate,SWRevealTableViewCellDelegate,SWRevealTableViewCellDataSource>
@property (nonatomic,strong) UIButton *addTextButton;
@property (nonatomic,assign) CGFloat  addTextButtonY;

@property (nonatomic,strong) NSDictionary<NSString*, NSArray<NSString*>*> *fontFamilies;
@property (nonatomic,strong) NSArray<NSString*> *fontFamilyNames;
@property (nonatomic,strong) NSDictionary<NSString*,NSNumber*> *sectionIndex;

@property (nonatomic,strong) NSArray<NSString*> *searchResultFonts;
@property (nonatomic,strong) NSArray<NSString*> *fontNames;
@property (nonatomic,strong) NSArray <NSString*> *searchCondittionStrs;

@property (nonatomic,weak,readonly) TextInfos *textInfos;
@property (nonatomic,strong) UISearchController *searchController;

@property (nonatomic,strong) UITapGestureRecognizer *tapGesture;
@end

@implementation FontStyleDisplayViewController
#pragma mark - Override Mathods
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor whiteColor];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(clearAllText:)];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
    //[self NavigationBarBackgroundHide:YES];
    
    // 获取字体数据
    [self getTextFontName];
    
    // 注册 table view cell ，并设置 cell 高度自动调整
    self.tableView.estimatedRowHeight = 60;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self.tableView  registerNib:[UINib nibWithNibName:@"FontDisplayCell" bundle:nil] forCellReuseIdentifier:@"font display cell"];
    
    // 为table view 添加一个 search controller.
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.delegate = self;
    self.searchController.searchBar.delegate =self;
    //self.searchController.obscuresBackgroundDuringPresentation = NO;
    self.searchController.searchBar.height = 44.0;
    self.tableView.tableHeaderView = self.searchController.searchBar;
    
    
    /*
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 100)];
    headerView.backgroundColor = [UIColor CustomBlueColor];
    self.tableView.tableHeaderView = headerView;
    */
    
    //  添加一个添加显示文本 button
    [self initialaddTextButton];
    
    //设置 section index lists 外观
    [self.tableView setSectionIndexColor:[UIColor redColor]];
    //[self.tableView setSectionIndexBackgroundColor:[UIColor colorWithWhite:0.5 alpha:0.5]];
    [self.tableView setSectionIndexBackgroundColor:[UIColor clearColor]];
    
    
}


/**
 *  @brief 设置NavigationBar背景视图隐藏或显示
 *
 *  @param hide YES，显示。NO, 隐藏。
 */
-(void)NavigationBarBackgroundHide:(BOOL)hide{
    
    for (UIView *view in self.navigationController.navigationBar.subviews) {
        if ([view isKindOfClass:NSClassFromString(@"_UINavigationBarBackground")]) {
            view.hidden = hide;
        }
    }
    
    //self.navigationController.navigationBar.translucent = YES;
}
/**
 *  @brief 获取 table view 数据源 font families 和 font names;
 */
-(void)getTextFontName{
    //  获取 font familyNames;
    NSArray <NSString*>*tempFontsFamilies = [UIFont familyNames];
    NSMutableArray <NSString*>*fontFamilyNames = [[NSMutableArray alloc]initWithArray: [tempFontsFamilies sortedArrayUsingSelector:@selector(localizedStandardCompare:)]];
    
   // 获取 fontNames of FontFamilyName and fontNames.
    NSMutableDictionary <NSString*, NSArray<NSString*>*> *fontFamilies = [NSMutableDictionary dictionaryWithCapacity:_fontFamilyNames.count];
    
    NSMutableArray <NSString*>*fontNames  = [NSMutableArray array];
    
    NSArray *tempArray = [NSMutableArray arrayWithArray:fontFamilyNames];
 
    [tempArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {

        NSArray<NSString*> * family = [UIFont fontNamesForFamilyName:obj];
        if (family.count <= 0) {
            [fontFamilyNames removeObject:obj];
        }else{
            family =  [family sortedArrayUsingSelector:@selector(localizedStandardCompare:)];
            
            [fontFamilies setObject:family forKey:obj];
            [fontNames addObjectsFromArray:family];
        }
    }];
    
    self.fontFamilies  = [fontFamilies copy];
    self.fontFamilyNames =  [fontFamilyNames copy];
    self.fontNames = [fontNames copy];
    
    // 获取 section index title字典
    // FamilyName 首字母为 key
    // FamilyName index 为value，如果key存在，不更新字典
    NSMutableDictionary<NSString*,NSNumber*> *sectionIndex = [NSMutableDictionary dictionary];
    
    [self.fontFamilyNames enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *key = [obj substringWithRange:NSMakeRange(0, 1)];
        if (![sectionIndex objectForKey:key]) {
            [sectionIndex setObject:[NSNumber numberWithInteger:idx] forKey:key];

        }
    }];
    self.sectionIndex = [sectionIndex copy];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    // 启动时显示text input view controller.
    [self.view bringSubviewToFront:self.addTextButton];

}

-(void)viewWillDisappear:(BOOL)animated{
    // 获取前一个 navigation stack 前一个 view controller.
    // 如果 是 display text input table vc, 转换text infos 为 内部 input text infos。
    UIViewController *vc = self.navigationController.visibleViewController;
    if ([vc isMemberOfClass:[textInfosInputTBC class]]) {
        textInfosInputTBC *tvc = (textInfosInputTBC*)vc;
        [tvc.inputTextInfos removeAllObjects];
        
        for (NSInteger i=0; i< self.textInfos.count; i++) {
            InputTextInfo *inputTextInfo = [[InputTextInfo alloc]init];
            inputTextInfo.text = [self.textInfos textOfIndex:i];
            inputTextInfo.textSize = [self.textInfos sizeOfIndex:i];
            inputTextInfo.submited = YES;
            
            [tvc.inputTextInfos addObject:inputTextInfo];
            
        
        }
        
        [tvc.tableView reloadData];
    }
    
    [super viewWillDisappear:animated];
   
    
}

-(void)dealloc{
    /**
     *  @brief 移除 search controller防止"Attempting to load the view of a view controller while it is deallocating is not allowed and may result in undefined behavior " 报错。
     */
    [self.searchController.view removeFromSuperview];
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  @brief 添加浮动 text修改按钮
 */
-(void)initialaddTextButton{
    CGFloat scaleFactor = self.tableView.height / 736;
    // 设置button 位置
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(0,0, 50*scaleFactor, 50*scaleFactor);
    button.center = CGPointMake(self.tableView.width -50*scaleFactor, self.tableView.height - 250*scaleFactor);
    button.layer.zPosition = 1;
    
    //button.backgroundColor = [UIColor whiteColor];
    // 设置button外观
    button.titleLabel.font = [UIFont fontWithName:@"NoteWorthy-Bold" size:35];
    [button setTitle:@"T" forState:UIControlStateNormal];
    UIImage *backgroundImage = [UIImage ovalImageBySize:CGSizeMake(50*scaleFactor, 50*scaleFactor) color:[UIColor customGreenColor]];
    //UIImage *image = [UIImage dashLineAddImageBySize:CGSizeMake(50*scaleFactor, 50*scaleFactor)];
    [button setBackgroundImage:backgroundImage
                      forState:UIControlStateNormal];
    button.layer.shadowOffset = CGSizeMake(-2, 2);
    button.layer.shadowRadius = 5.f;
    button.layer.shadowOpacity = 0.5;
    
    
    // 设置button触发方法
    [button addTarget:self \
               action:@selector(showActionSheet)\
     forControlEvents:UIControlEventTouchUpInside];
    [button addTarget:self
               action:@selector(scaleToSmall:) forControlEvents:UIControlEventTouchDown];
    [button addTarget:self action:@selector(scaleToNormal:) forControlEvents:UIControlEventTouchUpInside];
    [button addTarget:self action:@selector(scaleToNormal:) forControlEvents:UIControlEventTouchDragExit];
    
    [self.tableView addSubview:button];
    self.addTextButton = button;
    self.addTextButtonY = self.addTextButton.y;
    
}

#pragma mark - Gesture Trigger  Mathods

-(void)showActionSheet{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"add text." message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *editTextInfoAction = [UIAlertAction actionWithTitle:@"edit texts" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
        
    }];
    
    UIAlertAction *addTextInfoAction = [UIAlertAction actionWithTitle:@"add text" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self presentTextInputViewController];
    }];
    
    UIAlertAction *clearAllTextAcition = [UIAlertAction actionWithTitle:@"clear all texts" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self clearAllText:action];
    }];
    
    UIAlertAction *canncelAction = [UIAlertAction actionWithTitle:@"canncel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertController addAction:editTextInfoAction];
    [alertController addAction:addTextInfoAction];
    [alertController addAction:clearAllTextAcition];
    [alertController addAction:canncelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}
/**
 *  @brief 弹出带动画 单个添加 text view controller。
 */
-(void)presentTextInputViewController{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    TextInputViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"text input vc"];
    vc.transitioningDelegate = self;
    vc.modalPresentationStyle = UIModalPresentationCustom;
    [self presentViewController:vc animated:YES completion:nil];
    
}

static  NSString *kScaleSmallAnimation = @"scale small animation";
static  NSString  *kScaleNormalAnimation = @"scale normal animation";

/**
 *  @brief add text button按下时效果。
 *
 *  @param sender 发生者
 */
-(IBAction)scaleToSmall:(id)sender{
    [self.addTextButton.layer removeAllAnimations];
    
    CABasicAnimation *scaleAnim = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnim.fromValue = @(1.f);
    scaleAnim.toValue = @(0.8);
    scaleAnim.duration = 0.25;
    scaleAnim.removedOnCompletion = NO;
    scaleAnim.fillMode = kCAFillModeBoth;
    [self.addTextButton.layer addAnimation:scaleAnim forKey:kScaleSmallAnimation];
    
}
/**
 *  @brief add text button松开后效果。
 *
 *  @param sender 事件发生者。
 */
-(IBAction)scaleToNormal:(id)sender{
    [self.addTextButton.layer removeAllAnimations];
    
    CABasicAnimation *scaleAnim = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnim.fromValue = @(0.8f);
    scaleAnim.toValue = @(1.0f);
    [self.addTextButton.layer addAnimation:scaleAnim forKey:nil];
    
}

-(IBAction)clearAllText:(id)sender{
    [self.textInfos  clearTextInfos];
    [self.tableView reloadData];
}

#pragma mark - UIViewControllerTransitioningDelegate
-(id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    
    return [PresentAnimator new];
}
-(id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    
    return [DimissAnimator new];
}
#pragma mark - TableView Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (self.searchController.active) {
        return 1;
    }else{
        return self.fontFamilyNames.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (self.searchController.active) {
        
        if (!self.searchResultFonts || self.searchResultFonts.count==0) {
            return 0;
        }else{
            return self.searchResultFonts.count;
        }
    }else{
        
        return [self.fontFamilies objectForKey:_fontFamilyNames[section]].count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FontDisplayCell *cell = [tableView dequeueReusableCellWithIdentifier:@"font display cell" forIndexPath:indexPath];
    // Configure the cell...
    cellEntity *entity = [cellEntity new];;
    if (self.searchController.active) {
        entity.currentFontName = self.searchResultFonts[indexPath.row];
        entity.fontSearchStrs = self.searchCondittionStrs;
    }else{
        NSArray *fontNames = self.fontFamilies[_fontFamilyNames[indexPath.section]];
        entity.currentFontName = fontNames[indexPath.row];
        entity.fontSearchStrs = nil;
    }
    

    entity.currentSize = self.fontSize;
    entity.textInfos = self.textInfos;
    //cell.accessoryType = UITableViewCellAccessoryDetailButton;

    [cell configCellByEntity:entity];
    cell.indexPath = indexPath;
    
    cell.delegate = self;
    cell.dataSource = self;
    cell.cellRevealMode = SWCellRevealModeReversedWithAction;
    
    return cell;
    
}

/*
-(void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [(FontDisplayCell*)cell reloadContainerView];
    [cell layoutIfNeeded];
}
*/
-(NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    if (self.searchController.active) {
        return nil;
    }else{
        NSArray *tempArray  = [[self.sectionIndex allKeys]sortedArrayUsingSelector:@selector(localizedStandardCompare:)];
        NSMutableArray *indexTitiles = [NSMutableArray arrayWithArray:tempArray];
        
        [indexTitiles insertObject:UITableViewIndexSearch atIndex:0];
        return [indexTitiles copy];
    }
}

-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    if (self.searchController.active) {
        return 0;
    }else{
        NSInteger section = 0;
        if (index == 0) {
            [tableView scrollRectToVisible:tableView.tableHeaderView.frame animated: NO];
            section = index - 1;
        }else{
            section = [[self.sectionIndex objectForKey:title] integerValue] - 1;
        }
        return section;
    }
}
 
-(UIFont*)fontAtIndexPath:(NSIndexPath*)indexPath size:(CGFloat)size{

    NSArray *fontNames = self.fontFamilies[_fontFamilyNames[indexPath.section]];
    
    size = size?size:14;
    return [UIFont fontWithName:fontNames[indexPath.row] size:size];
}

#pragma mark - UITableViewDelegate
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (self.searchController.active) {
        return nil;
    }else{
        return [self.fontFamilyNames objectAtIndex:section];
    }
}
/*
-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath{
    NSString *currentFontName;
    // 获取当前 view 的 font name;
    if (self.searchController.active) {
        currentFontName = self.searchResultFonts[indexPath.row];
    }else{
        NSArray *fontNames = self.fontFamilies[_fontFamilyNames[indexPath.section]];
        currentFontName = fontNames[indexPath.row];
    }
    
    CurrentTextInfoViewController *vc = [[CurrentTextInfoViewController alloc]init];
    vc.currentFontName = currentFontName;
    
    [self.navigationController pushViewController:vc animated:YES];
    
    
    
}
*/
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *currentFontName;
    // 获取当前 view 的 font name;
    if (self.searchController.active) {
        currentFontName = self.searchResultFonts[indexPath.row];
    }else{
        NSArray *fontNames = self.fontFamilies[_fontFamilyNames[indexPath.section]];
        currentFontName = fontNames[indexPath.row];
    }
    
    CurrentTextInfoViewController *vc = [[CurrentTextInfoViewController alloc]init];
    vc.currentFontName = currentFontName;
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - SWRevealTableViewCellDelegate
-(void)revealTableViewCell:(SWRevealTableViewCell *)revealTableViewCell willMoveToPosition:(SWCellRevealPosition)position{
    if (SWCellRevealPositionCenter == position) {
        return;
    }
    
    for (SWRevealTableViewCell *cell in [self.tableView visibleCells]) {
        if (cell != revealTableViewCell) {
            [cell setRevealPosition:SWCellRevealPositionCenter animated:YES];
        }
    }
    
    
}

#pragma mark - SWRevealTableViewCellDataSource
-(NSArray *)leftButtonItemsInRevealTableViewCell:(SWRevealTableViewCell *)revealTableViewCell{
    SWCellButtonItem *item1 = [SWCellButtonItem itemWithTitle:@"选定" handler:^BOOL(SWCellButtonItem *item, SWRevealTableViewCell *cell) {
        if (self.textInfos.count) {

            NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
            
            NSString *fontName;
            if (self.searchController.active) {
                fontName = self.searchResultFonts[indexPath.row];
            }else{
                NSArray *fontNames = self.fontFamilies[_fontFamilyNames[indexPath.section]];
                fontName = fontNames[indexPath.row];
            }
            
            NSString *msg ;
            if (self.textInfos.currentIndex == -1) {
                msg = @"当前无可设置文本。";
            }else{
                msg = [NSString stringWithFormat:@"字体:%@\n",fontName];
                msg = [msg stringByAppendingString:[NSString stringWithFormat:@"文本位置: %ld",self.textInfos.currentIndex+1]];
            }
            // 弹出 alert view.
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"选定当前字体?" message:msg preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction *conformAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

                [self.textInfos commitTextIndex:self.textInfos.currentIndex byFontNmae:fontName];
                [self.tableView reloadData];
            }];
        
            UIAlertAction *canncelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
            }];
            
            [alertVC addAction:conformAction];
            [alertVC addAction:canncelAction];
            
            if (self.textInfos.currentIndex >= 0) {
                alertVC.preferredAction = conformAction;
            }else{
                conformAction.enabled = NO;
            }
        

        
            [self presentViewController:alertVC animated:YES completion:nil];
        
        }
        return YES;
    }];
    
    
    item1.backgroundColor = [UIColor customYellowColor];
    item1.tintColor = [UIColor whiteColor];
    item1.width = 70;
    return @[item1];
}

#pragma mark - FontDisplayCellDelegate
-(void)displayCell:(FontDisplayCell *)cell didSelectedHoldlerView:(UIView *)view ofIndex:(NSInteger)index{
    [self presentTextInputViewController];
    
}
-(void)displayCell:(FontDisplayCell *)cell didSelectedTextView:(UIView *)view ofIndex:(NSInteger)index{
    [self.textInfos compareTextInfoWithIndex:index];
    [self.tableView reloadData];
    
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat y = self.addTextButtonY + scrollView.contentOffset.y+64;
    self.addTextButton.y = y;
    [self.tableView bringSubviewToFront:self.addTextButton];

/*
    if (scrollView.contentOffset.y >= (100-64)) {
        [self NavigationBarBackgroundHide:NO];
    }else{
        [self NavigationBarBackgroundHide:YES];
    }
 */
}

#pragma mark - UISearchResultsUpdating
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController{
    [self searchFontsByText:searchController.searchBar.text];
    [self.tableView reloadData];
    
}


-(NSArray<NSString*>*)splitSearchConditionString:(NSString*)searchStr{
    NSArray <NSString*> *conditionStrs = [searchStr componentsSeparatedByString:@" "];
    conditionStrs = [conditionStrs filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"length > 0"]];
    
    return conditionStrs;
}
-(void)searchFontsByText:(NSString*)str{
    
    NSArray<NSString*>* conditionStrs = [self splitSearchConditionString:str];
    _searchCondittionStrs = conditionStrs;
    
    NSMutableString *predicateFormat;
    for (NSInteger i=0; i<conditionStrs.count; i++) {
        NSString *str = conditionStrs[i];
        if (i == 0) {
            predicateFormat = [NSMutableString stringWithFormat:@"(SELF CONTAINS [cd] '%@')",str];
        }else{
            [predicateFormat appendFormat:@" AND (SELF CONTAINS [cd] '%@')", str];
        }
    }
    
    if (predicateFormat) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateFormat];
        self.searchResultFonts = [self.fontNames filteredArrayUsingPredicate:predicate];
    }else{
        self.searchResultFonts = nil;
    }
    
}


#pragma mark - UISearchControllerDelegate
-(void)willPresentSearchController:(UISearchController *)searchController{
    self.addTextButton.hidden = YES;
    
    // 当search controller 活动时，添加一个 手势取消 键盘
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(canncelSearchBarInput:)];
    [self.tableView addGestureRecognizer:tapGesture];
    self.tapGesture = tapGesture;
}
-(void)willDismissSearchController:(UISearchController *)searchController{
    self.addTextButton.hidden = NO;
    
    // 当 search controller dismiss 时 删除 取消键盘手势。
    [self.tableView removeGestureRecognizer:self.tapGesture];
}

-(void)canncelSearchBarInput:(UITapGestureRecognizer*)gesture{
    [self.searchController.searchBar resignFirstResponder];
}
#pragma mark - UISearchBarDelegate
-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
}
#pragma mark - Properties
-(TextInfos *)textInfos{
    return [TextInfos shareTextInfos];
}


@end
