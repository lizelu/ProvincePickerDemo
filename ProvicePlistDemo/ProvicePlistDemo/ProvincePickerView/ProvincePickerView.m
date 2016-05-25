//
//  ProvincePickerView.m
//  ProvicePlistDemo
//
//  Created by Mr.LuDashi on 16/5/25.
//  Copyright © 2016年 ZeluLi. All rights reserved.
//

#import "ProvincePickerView.h"

#define PROVINCE_CITYS @"citys"
#define PROVINCE_AND_CITYS_NAME @"name"
#define PROVINCE_AND_CITYS_CODE @"code"
#define PICKER_VIEW_ROW_HEIGHT 30.0f
#define PICKER_VIEW_COMPONENT_COUNT 2


@interface ProvincePickerView()<UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) UITextField *inputTextField;      //用来触发pickerView的inputTextField
@property (strong, nonatomic) UIPickerView *provincePickerView; //PickerView
@property (strong, nonatomic) NSMutableArray *provinceArray;    //存储从plist文件中读取的省市信息
@property (assign, nonatomic) NSUInteger currentFirstRow;       //当前选中的第一列的行数
@property (assign, nonatomic) NSUInteger currentSecondRow;      //当前选中的第二列的行数

@property (strong, nonatomic) SelectProvinceInfoBlock block;
@end

@implementation ProvincePickerView


#pragma mark -- life cycle
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self loadAllProvinceData];
        [self addPickerViewToCurrentView];
    }
    return self;
}




#pragma mark -- setting and add subView

/**
 *  设置Block, 用来将用户选则的数据回调给使用者
 *
 *  @param block 回调数据的Block
 */
- (void) setSelectProvinceInfoBlock: (SelectProvinceInfoBlock) block{
    self.block = block;
}

/**
 *  实例化PickerView并添加到inputView上
 */
- (void)addPickerViewToCurrentView {
    _inputTextField = [[UITextField alloc] init];
    [self addSubview:_inputTextField];
    _provincePickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 1000, 216)];
    _provincePickerView.showsSelectionIndicator = YES;
    _provincePickerView.dataSource = self;
    _provincePickerView.delegate = self;
    _inputTextField.inputView = _provincePickerView;
    
    [self addToolBarItem];
}


/**
 *  往inputAccessoryView上添加ToolBar
 */
- (void) addToolBarItem {
    //TextView的键盘定制回收按钮
    UIToolbar * toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 1000, 44)];
    
    UIBarButtonItem *item0 = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(hiddenPickerView)];
    
    UIBarButtonItem * item1 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(tapSelectOkButton)];
    
    toolBar.items = @[item0,item1,item2];
    _inputTextField.inputAccessoryView = toolBar;
}

/**
 *  从plist文件中加载省市信息
 */
- (void)loadAllProvinceData {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"province" ofType:@"plist"];
    _provinceArray = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
}






#pragma mark - all event
/**
 *  显示PickerView
 */
- (void) showPickerView {
    [_inputTextField becomeFirstResponder];
    [_provincePickerView selectRow:_currentFirstRow inComponent:0 animated:NO];
    [_provincePickerView selectRow:_currentSecondRow inComponent:1 animated:NO];
    
}

/**
 *  隐藏PickerView
 */
- (void) hiddenPickerView {
    [self.superview endEditing:YES];
}

/**
 *  点击完成按钮
 */
- (void) tapSelectOkButton {
    [self hiddenPickerView];
    
    ProvinceModel *provinceModel = [[ProvinceModel alloc] init];
    
    if (_currentFirstRow < _provinceArray.count) {
        provinceModel.provinceName = [NSString stringWithFormat:@"%@", _provinceArray[_currentFirstRow][PROVINCE_AND_CITYS_NAME]];
        provinceModel.provinceCode = [NSString stringWithFormat:@"%@", _provinceArray[_currentFirstRow][PROVINCE_AND_CITYS_CODE]];
        
        NSArray *citys = _provinceArray[_currentFirstRow][PROVINCE_CITYS];

        if (_currentSecondRow < citys.count) {
            
            provinceModel.cityName = [NSString stringWithFormat:@"%@", citys[_currentSecondRow][PROVINCE_AND_CITYS_NAME]];
            provinceModel.cityCode = [NSString stringWithFormat:@"%@", citys[_currentSecondRow][PROVINCE_AND_CITYS_CODE]];
            
            if (self.block) {
                self.block(provinceModel);
            }
        }
    }
}



#pragma mark -- UIPickerViewDataSource
/**
 *  返回PickerView的列数
 *
 *  @param pickerView 当前使用的PikcerView
 *
 *  @return 列数
 */
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return PICKER_VIEW_COMPONENT_COUNT;
}


/**
 *  返回每列有多上行
 *
 *  @param pickerView   当前PickerView
 *  @param component    列数
 *
 *  @return 当前列数的行数
 */
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (component == 0 && _provinceArray != nil) {
        return _provinceArray.count;
    }
    
    if (component == 1 && _provinceArray != nil) {
        NSArray *citys = _provinceArray[_currentFirstRow][PROVINCE_CITYS];
        return citys.count;
    }
    
    return 0;
}






#pragma mark -- UIPickerViewDelegate

/**
 *  行高
 *
 *  @param pickerView
 *  @param component  列数
 *
 *  @return 返回当前列数的行高
 */
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return PICKER_VIEW_ROW_HEIGHT;
}


/**
 *  自定义PickerView上的显示View
 *
 *  @param pickerView 当前PickerView
 *  @param row        行数
 *  @param component  列数
 *  @param view       当前的显示View
 *
 *  @return 要替换的View
 */
-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *label = [[UILabel alloc] initWithFrame:view.frame];
    
    label.minimumScaleFactor = 0.5;
    label.adjustsFontSizeToFitWidth = YES;
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setFont:[UIFont boldSystemFontOfSize:15.0f]];
    label.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    
    return label;
}

/**
 *  为每行每列设置title
 *
 *  @param pickerView
 *  @param row        行数
 *  @param component  列数
 *
 *  @return 该行该列的title
 */
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    if (component == 0 && row < _provinceArray.count) {
        return _provinceArray[row][PROVINCE_AND_CITYS_NAME];
    }
    
    if (component == 1) {
        NSArray *citys = _provinceArray[_currentFirstRow][PROVINCE_CITYS];
        if (row < citys.count) {
            return citys[row][PROVINCE_AND_CITYS_NAME];
        }
        
    }
    return @"";
}

/**
 *  选中后的回调
 *
 *  @param pickerView
 *  @param row        当前选中的行
 *  @param component  当前选中的列
 */
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        _currentFirstRow = row;
    }
    
    if (component == 1) {
        _currentSecondRow = row;
    }
    
    [_provincePickerView reloadAllComponents];
}

@end
