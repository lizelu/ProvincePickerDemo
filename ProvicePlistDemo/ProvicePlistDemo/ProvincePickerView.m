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

@interface ProvincePickerView()<UIPickerViewDelegate, UIPickerViewDataSource>
@property (strong, nonatomic) UITextField *inputTextField;
@property (strong, nonatomic) UIPickerView *provincePickerView;

@property (strong, nonatomic) NSMutableArray *provinceArray;

@property (assign, nonatomic) NSUInteger currentFirstRow;
@property (assign, nonatomic) NSUInteger currentSecondRow;

@property (strong, nonatomic) NSNumber * currentProvinceCode;
@property (strong, nonatomic) NSNumber * currentCityCode;

@property (strong, nonatomic) SelectProvinceInfoBlock block;
@end

@implementation ProvincePickerView

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

- (void) setSelectProvinceInfoBlock: (SelectProvinceInfoBlock) block{
    self.block = block;
}

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

- (void) addToolBarItem {
    //TextView的键盘定制回收按钮
    UIToolbar * toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 1000, 44)];
    UIBarButtonItem *item0 = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancelSelect)];
    
    UIBarButtonItem * item1 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(tapSelectOkButton)];
    
    toolBar.items = @[item0,item1,item2];
    
    _inputTextField.inputAccessoryView = toolBar;
}


- (void)loadAllProvinceData {
    
    _currentProvinceCode = 0;
    _currentCityCode = 0;
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"province" ofType:@"plist"];
    _provinceArray = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
}



#pragma mark - all event

- (void) showPickerView {
    _currentFirstRow = 0;
    _currentSecondRow = 0;
    
    [_inputTextField becomeFirstResponder];
    [_provincePickerView reloadAllComponents];
}

- (void) cancelSelect {
    [self.superview endEditing:YES];
}

- (void) tapSelectOkButton {
    [self.superview endEditing:YES];
    
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
    return 2;
}

// returns the # of rows in each component..
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

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 30;
}

-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *label = [[UILabel alloc] initWithFrame:view.frame];
    
    label.minimumScaleFactor = 0.5;
    label.adjustsFontSizeToFitWidth = YES;
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setFont:[UIFont boldSystemFontOfSize:15.0f]];
    label.text = [self pickerView:pickerView titleForRow:row forComponent:component];
    
    return label;
}

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

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        _currentFirstRow = row;
        _currentSecondRow = 0;
    }
    
    if (component == 1) {
        _currentSecondRow = row;
    }
    
    [_provincePickerView reloadAllComponents];
}

@end
