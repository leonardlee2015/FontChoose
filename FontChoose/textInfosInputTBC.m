//
//  textInfosInputTBC.m
//  FontChoose
//
//  Created by 李南 on 15/12/25.
//  Copyright © 2015年 ctd.leonard. All rights reserved.
//

#import "textInfosInputTBC.h"
#import "TextInfos.h"
#import "TextInfoInputCell.h"
#import "AppDelegate.h"
#import "UIColor+CustomColor.h"
#import "InputTextInfo.h"
#import "UIView+SetRect.h"

@interface textInfosInputTBC ()<SWRevealTableViewCellDelegate,SWRevealTableViewCellDataSource>
@property(nonatomic,weak) TextInfos *textInfos;
@property(nonatomic, strong) NSMutableArray<InputTextInfo*> *inputTextInfos;
@end

@implementation textInfosInputTBC

NSString  *const cellIdentifier = @"text infos input cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = NO;
    
    // 设置 自动调整cell 大小。
    self.tableView.estimatedRowHeight = 70;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    // register table cell showed in table view.
    [self.tableView registerClass:[TextInfoInputCell class] forCellReuseIdentifier:cellIdentifier];
    // add a add text infos button as footer view.
    UIButton *addTextButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [addTextButton addTarget:self action:@selector(addTextInfo:) forControlEvents:UIControlEventTouchUpInside];
    [addTextButton addTarget:self action:@selector(addTextInfo:) forControlEvents:UIControlEventTouchDragOutside];
    
    addTextButton.translatesAutoresizingMaskIntoConstraints = NO;
    [addTextButton setTitle:@"clip to add text info." forState:UIControlStateNormal];
    addTextButton.backgroundColor = [UIColor yellowColor];
    [addTextButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    
    // add a footerView as add text info button
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.width, 50)];
    footerView.backgroundColor = [UIColor CustomBlueColor];
    [footerView addSubview:addTextButton];
    
    [footerView addConstraints:[NSLayoutConstraint \
                               constraintsWithVisualFormat:@"H:|[addTextButton]|"\
                               options:0\
                               metrics:nil\
                                views:NSDictionaryOfVariableBindings(addTextButton)]];
    [footerView addConstraints:[NSLayoutConstraint \
                               constraintsWithVisualFormat:@"V:|[addTextButton]|"\
                               options:0\
                               metrics:@{@"height":@(addTextButton.intrinsicContentSize.height)}\
                                views:NSDictionaryOfVariableBindings(addTextButton)]];
    
    
    self.tableView.tableFooterView = footerView;
    
    // add a gesture that canncel text field first responder.
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(canncelAllFirstResponder:)];
    //tapGesture.delegate = self;
    [self.tableView addGestureRecognizer:tapGesture];
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // 添加一个长按手势调整text info 位置。
    UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(exchangeCellLocation:)];
    [self.tableView addGestureRecognizer:longGesture];
}

-(IBAction)canncelAllFirstResponder:(UITapGestureRecognizer*)sender{
    for (TextInfoInputCell* cell in [self.tableView visibleCells]) {
        [cell resignAllFirstResponder];
    }
    
}

-(IBAction)addTextInfo:(UIButton*)sender{
    // 在 inputTextInfos 最后插入 空TextInfo.
    InputTextInfo *textInfo = [[InputTextInfo alloc]init];
    [self.inputTextInfos addObject:textInfo];
    
    // 在table view 最后插入 cell.
    //NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.inputTextInfos.count inSection:0];
    //[self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationMiddle];
    
    [self.tableView reloadData];

}

-(IBAction)exchangeCellLocation:(UILongPressGestureRecognizer*)sender{
    static UIImageView* snapshoot = nil;
    static NSIndexPath *sourchIndexPath = nil;
    static BOOL isExchangeCell = YES;
    static CGFloat hOffset = 0;
    CGPoint location = [sender locationInView:self.tableView];
    
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:{
            // 获取 长按手势发生所在的cell，若果长按位置没有cell,将不响应接下来的移动操作。
            sourchIndexPath = [self.tableView indexPathForRowAtPoint:location];
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:sourchIndexPath];
            
            if (!sourchIndexPath) {
                isExchangeCell = NO;
            }
            if (cell) {
                snapshoot = [self customSnapshootFromView:cell];
                snapshoot.frame = cell.frame;
                // 获取location与cell 原点在y轴上的的偏移
                hOffset = location.y - snapshoot.y;
                
                
                [self.tableView addSubview:snapshoot];
                [UIView animateWithDuration:0.5f animations:^{
                    cell.hidden = YES;
                    snapshoot.transform = CGAffineTransformMakeScale(1.05, 1.05);
                    snapshoot.alpha = 0.75f;
                }];
            }
            
            break;
        }
        case UIGestureRecognizerStateChanged:{
            if (isExchangeCell) {
                NSIndexPath *currentIndexPath = [self.tableView indexPathForRowAtPoint:location];
                
                if (currentIndexPath && ![currentIndexPath isEqual:sourchIndexPath]) {

                    [self.tableView moveRowAtIndexPath:sourchIndexPath toIndexPath:currentIndexPath];
                    [self.inputTextInfos exchangeObjectAtIndex:sourchIndexPath.row withObjectAtIndex:currentIndexPath.row];
                    
                    
                    sourchIndexPath = currentIndexPath;
                }
                snapshoot.y = location.y - hOffset;
                
            }
            
            break;
        }
            
        default:{
            UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:sourchIndexPath];
            [UIView animateWithDuration:0.5f animations:^{
                snapshoot.transform = CGAffineTransformIdentity;
                snapshoot.alpha = 1;
                cell.hidden = NO;
            }];
            
            [snapshoot removeFromSuperview];
            snapshoot = nil;
            sourchIndexPath = nil;
            isExchangeCell = YES;
            hOffset = 0;
            
            [self.tableView reloadData];
            break;
            

        }
    }
}
-(UIImageView*)customSnapshootFromView:(UIView*)view{
    
    CGSize size = view.frame.size;
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext() ];
    UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImageView *imageView  = [[UIImageView alloc]initWithImage:image];
    imageView.layer.shadowOffset = CGSizeMake(0, 5);
    imageView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
    imageView.layer.shadowOpacity = 0.5f;
    
    imageView.layer.cornerRadius = 5.f;
    
    return imageView;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.inputTextInfos.count;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    // Configure the cell...
    TextInfoInputCell *tCell = (TextInfoInputCell*)cell;
    tCell.dataSource = self;
    tCell.delegate = self;
    tCell.indexPath = indexPath;
    tCell.inputTextInfo = self.inputTextInfos[indexPath.row];
    tCell.cellRevealMode =  SWCellRevealModeReversedWithAction;
    
    if (self.inputTextInfos[indexPath.row].isSubmited) {
        [tCell submitTextInfos];
    
    }else{
        
        [tCell reEditTextInfos];
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TextInfoInputCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    

    
    return cell;
}
#pragma mark - SWRevealTableViewCellDataSource
-(NSArray *)leftButtonItemsInRevealTableViewCell:(SWRevealTableViewCell *)revealTableViewCell{
    // 添加右滑 submit 按键。
    __weak typeof(self) weakSelf = self;
    
    SWCellButtonItem *item1 = [SWCellButtonItem itemWithTitle:@"提交" handler:^BOOL(SWCellButtonItem *item, SWRevealTableViewCell *cell) {
        TextInfoInputCell *textInputCell;
        if ([cell isMemberOfClass:[TextInfoInputCell class]]) {
            // get cell info.
            textInputCell = (TextInfoInputCell*)cell;
            NSIndexPath *inPath = textInputCell.indexPath;
            InputTextInfo *textInfo = textInputCell.inputTextInfo;
            
            // submit model and update cell.
            if (!textInfo.isSubmited) {
                [textInputCell submitTextInfos];
            
                weakSelf.inputTextInfos[inPath.row].text = textInfo.text;
                weakSelf.inputTextInfos[inPath.row].textSize = textInfo.textSize;
                weakSelf.inputTextInfos[inPath.row].submited = textInfo.submited;
             
                // if submit seccussful,insert text info into text infos.
                if (textInfo.isSubmited) {
                    NSInteger expectedIndex = [self getExpectedTextInfosLocationByInputextInfoIndex:inPath.row];
                    [self.textInfos insertText:textInfo.text size:textInfo.textSize index:expectedIndex];
                }else{
                    
                    //
                    //[cell setRevealPosition:SWCellRevealPositionCenter];
                    //return NO;
                }

            }
            
            
            
            
        }

        return YES;
    }];
    
    item1.backgroundColor = [UIColor customGreenColor];
    item1.tintColor = [UIColor whiteColor];
    item1.width = 70;
    return @[item1];
}

-(NSArray *)rightButtonItemsInRevealTableViewCell:(SWRevealTableViewCell *)revealTableViewCell{
    // 添加左滑 删除按键。
    __weak typeof(self) weakSelf = self;
    SWCellButtonItem *item1 = [SWCellButtonItem itemWithTitle:@"删除" handler:^BOOL(SWCellButtonItem *item, SWRevealTableViewCell *cell) {
    
        TextInfoInputCell *textInputCell;
        if ([cell isMemberOfClass:[TextInfoInputCell class]]) {
            // get cell info.
            textInputCell = (TextInfoInputCell*)cell;
            NSIndexPath *inPath = textInputCell.indexPath;
            InputTextInfo *textInfo = weakSelf.inputTextInfos[inPath.row];
            
            // if current text info have submit to textInfos, delete it in text info.
            if (textInfo.isSubmited) {
                NSInteger expectedIndex = [weakSelf getExpectedTextInfosLocationByInputextInfoIndex:inPath.row];
                
                [weakSelf.textInfos deleteTextInfoAtIndex:expectedIndex];
            }
            
            // delete current input text info.
            [weakSelf.inputTextInfos removeObjectAtIndex:inPath.row];
            [weakSelf.tableView reloadData];
            
            
            
        }
        return YES;
        
    
    }];
    
    item1.backgroundColor = [UIColor customRedColor];
    item1.tintColor = [UIColor whiteColor];
    item1.width = 70;
    
    // 添加左滑编辑 按键。
    SWCellButtonItem *item2 = [SWCellButtonItem itemWithTitle:@"编辑" handler:^BOOL(SWCellButtonItem *item, SWRevealTableViewCell *cell) {
        
        TextInfoInputCell *textInputCell;
        if ([cell isMemberOfClass:[TextInfoInputCell class]]) {
            // get cell info.
            textInputCell = (TextInfoInputCell*)cell;
            NSIndexPath *inPath = textInputCell.indexPath;
            InputTextInfo *textInfo = textInputCell.inputTextInfo;
            // re edit model and update cell.
            
            if (textInfo.isSubmited) {
                [textInputCell reEditTextInfos];
            
                weakSelf.inputTextInfos[inPath.row].text = textInfo.text;
                weakSelf.inputTextInfos[inPath.row].textSize = textInfo.textSize;
                weakSelf.inputTextInfos[inPath.row].submited = textInfo.submited;
            
                if (!textInfo.isSubmited) {
                    NSInteger expectedIndex = [weakSelf getExpectedTextInfosLocationByInputextInfoIndex:inPath.row];
                    [weakSelf.textInfos deleteTextInfoAtIndex:expectedIndex];
                    
                }else{
                    
                    //[cell setRevealPosition:SWCellRevealPositionCenter];
                    //return NO;
                }
                
            }
            
        }

        return YES;
    }];
    item2.backgroundColor = [UIColor blueColor];
    item2.tintColor = [UIColor whiteColor];
    item2.width = 70;
    
    SWCellButtonItem *item3 = [SWCellButtonItem itemWithTitle:@"新增" handler:^BOOL(SWCellButtonItem *item, SWRevealTableViewCell *cell) {
        // 获取 cell 信息
        TextInfoInputCell *tCell = (TextInfoInputCell*) cell;
        NSIndexPath *inPath = tCell.indexPath;
        
        InputTextInfo *textInfo = [[InputTextInfo alloc]init];
        
        NSIndexPath *newPath = [NSIndexPath indexPathForRow:inPath.row+1 inSection:inPath.section];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView beginUpdates];
            [self.tableView insertRowsAtIndexPaths:@[newPath] withRowAnimation:UITableViewRowAnimationMiddle];
            [self.inputTextInfos insertObject:textInfo atIndex:newPath.row];
            [self.tableView endUpdates];
            
        });
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
        
        return YES;
        
    }];
    item3.backgroundColor = [UIColor yellowColor];
    item3.tintColor = [UIColor whiteColor];
    item3.width = 70;
    return @[item1,item2,item3];
    
}

-(NSInteger)getExpectedTextInfosLocationByInputextInfoIndex:(NSInteger)index{
    
    NSInteger expectedIndex = 0;
    for (NSInteger i=index-1;i>=0 ; i--) {
        if (self.inputTextInfos[i].isSubmited == YES) {
            expectedIndex++;
        }
    }
    
    return expectedIndex;
}
#pragma mark - SWRevealTableViewCellDelegate
-(void)revealTableViewCell:(SWRevealTableViewCell *)revealTableViewCell willMoveToPosition:(SWCellRevealPosition)position{
    if (SWCellRevealPositionCenter == position) {
        return;
    }
    
    // 若果有非当前cell 处于侧滑状态，取消其他cell 侧滑状态。
    for (TextInfoInputCell* cell in [self.tableView visibleCells]) {
        
        if (cell != revealTableViewCell) {
            [cell setRevealPosition:SWCellRevealPositionCenter animated:YES];
        }
        
        // 取消所有cell first responder.
        [cell resignAllFirstResponder];
    }
    
}

#pragma mark - UIScrollViewDelegate
/*
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    for (TextInfoInputCell *cell in [self.tableView visibleCells]) {
        [cell resignAllFirstResponder];
    }
}
 */

#pragma mark -  UIGestrueRecognizer.
/*
-(BOOL)revealTableViewCell:(SWRevealTableViewCell *)revealTableViewCell panGestureRecognizerShouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    
    return YES;
}
 */

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


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
#pragma mark - Properties
@dynamic textInfos;
-(TextInfos *)textInfos{
    return [TextInfos shareTextInfos];
}

-(NSMutableArray<InputTextInfo *> *)inputTextInfos{
    if (!_inputTextInfos) {
        _inputTextInfos = [NSMutableArray array];
    }
    return _inputTextInfos;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"font compare"]) {
        //[self transformInputTextInfo];
        
    }
}

-(void)transformInputTextInfo{
    [self.textInfos clearTextInfos];
    for (InputTextInfo *textInfo in self.inputTextInfos) {
        if (textInfo.isSubmited) {
            [self.textInfos pushInfoText:textInfo.text size:textInfo.textSize];
        }
    }
}

@end
