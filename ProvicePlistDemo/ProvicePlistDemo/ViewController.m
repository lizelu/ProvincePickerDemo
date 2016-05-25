//
//  ViewController.m
//  ProvicePlistDemo
//
//  Created by Mr.LuDashi on 16/5/24.
//  Copyright © 2016年 ZeluLi. All rights reserved.
//

#import "ViewController.h"

#define PROVINCE_CITYS @"citys"
#define PROVINCE_AND_CITYS_NAME @"name"
#define PROVINCE_AND_CITYS_CODE @"code"

@interface ViewController ()<UIPickerViewDelegate, UIPickerViewDataSource>
@property (strong, nonatomic) IBOutlet UILabel *provinceLabel;

@property (strong, nonatomic) UITextField *inputTextField;
@property (strong, nonatomic) UIPickerView *provincePickerView;

@property (strong, nonatomic) NSMutableArray *provinceArray;

@property (assign, nonatomic) NSUInteger currentFirstRow;
@property (assign, nonatomic) NSUInteger currentSecondRow;

@property (strong, nonatomic) NSNumber * currentProvinceCode;
@property (strong, nonatomic) NSNumber * currentCityCode;


@property (strong, nonatomic) IBOutlet UILabel *currentProvinceNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *currentProvinceCodeLabel;

@property (strong, nonatomic) IBOutlet UILabel *currentCityNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *currentCityCodeLabel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _currentProvinceCode = 0;
    _currentCityCode = 0;
    
    _inputTextField = [[UITextField alloc] init];
    [self.view addSubview:_inputTextField];
    
    _provincePickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 1000, 216)];
    _provincePickerView.showsSelectionIndicator = YES;
    _provincePickerView.dataSource = self;
    _provincePickerView.delegate = self;
    
    _inputTextField.inputView = _provincePickerView;
    
    
    
    
    //TextView的键盘定制回收按钮
    UIToolbar * toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 1000, 44)];
    
    
    
    UIBarButtonItem *item0 = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancelSelect)];
    
    UIBarButtonItem * item1 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(tapSelectOkButton)];
    
    toolBar.items = @[item0,item1,item2];
    
    _inputTextField.inputAccessoryView = toolBar;
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"province" ofType:@"plist"];
    _provinceArray = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
    
    
    
    
}

- (void) cancelSelect {
    [self.view endEditing:YES];
}

- (void) tapSelectOkButton {
    [self.view endEditing:YES];
    
    if (_currentFirstRow < _provinceArray.count) {
        NSString *provinceName = _provinceArray[_currentFirstRow][PROVINCE_AND_CITYS_NAME];
        _currentProvinceCode = _provinceArray[_currentFirstRow][PROVINCE_AND_CITYS_CODE];
        
        NSArray *citys = _provinceArray[_currentFirstRow][PROVINCE_CITYS];
        NSString *cityName = @"";
        if (_currentSecondRow < citys.count) {
            
            cityName = citys[_currentSecondRow][PROVINCE_AND_CITYS_NAME];
            _currentCityCode = citys[_currentSecondRow][PROVINCE_AND_CITYS_CODE];
            
            _provinceLabel.text = [NSString stringWithFormat:@"%@ %@", provinceName, cityName];
            
            
            
            //test display
            _currentProvinceNameLabel.text = [NSString stringWithFormat:@"%@", provinceName];
            _currentProvinceCodeLabel.text = [NSString stringWithFormat:@"%@", _currentProvinceCode];
            
            
            _currentCityNameLabel.text = [NSString stringWithFormat:@"%@", cityName];
            _currentCityCodeLabel.text = [NSString stringWithFormat:@"%@", _currentCityCode];
            
            
            
        }
    }
}
- (IBAction)tapPlistButton:(id)sender {
    
    NSString *hostString = @"http://127.0.0.1/read_excel.php";
    NSURL *plistURL = [[NSURL alloc] initWithString: hostString];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithURL:plistURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        //NSLog(@"%@\n\n", data);
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        //NSLog(@"%@\n\n", dic);
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSURL *documentPath = [fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask][0] ;
        NSURL *filePath = [documentPath URLByAppendingPathComponent:@"province.plist"];
        
        [dic writeToURL:filePath atomically:YES];
        NSLog(@"%@", filePath);
        
        NSMutableArray *provinceData = [[NSMutableArray alloc] initWithContentsOfURL:filePath];
        NSLog(@"%@", provinceData);
        
        
    }];
    [dataTask resume];
    
}

- (IBAction)tapSelectButton:(id)sender {
    _currentFirstRow = 0;
    _currentSecondRow = 0;

    [_inputTextField becomeFirstResponder];
    [_provincePickerView reloadAllComponents];
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

//-(NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {
//    
//    NSString *title = @"";
//    
//    if (component == 0 && row < _provinceArray.count) {
//        title = _provinceArray[row][PROVINCE_AND_CITYS_NAME];
//    }
//    
//    if (component == 1) {
//        NSArray *citys = _provinceArray[_currentFirstRow][PROVINCE_CITYS];
//        if (row < citys.count) {
//            title = citys[row][PROVINCE_AND_CITYS_NAME];
//        }
//    }
//    
//    
//    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:title];
//    [attributeString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.0f] range:NSMakeRange(0, 3)];
//    
//    return attributeString;
//
//}


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




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
