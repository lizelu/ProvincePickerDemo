//
//  ViewController.m
//  ProvicePlistDemo
//
//  Created by Mr.LuDashi on 16/5/24.
//  Copyright © 2016年 ZeluLi. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIPickerViewDelegate, UIPickerViewDataSource>
@property (strong, nonatomic) IBOutlet UILabel *provinceLabel;

@property (strong, nonatomic) UITextField *inputTextField;
@property (strong, nonatomic) UIPickerView *provincePickerView;

@property (strong, nonatomic) NSMutableArray *provinceArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _inputTextField = [[UITextField alloc] init];
    [self.view addSubview:_inputTextField];
    
    _provincePickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 0, 1000, 216)];
    _provincePickerView.showsSelectionIndicator = YES;
    _provincePickerView.dataSource = self;
    _provincePickerView.delegate = self;
    
    _inputTextField.inputView = _provincePickerView;
    
    
    
    
    //TextView的键盘定制回收按钮
    UIToolbar * toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 1000, 44)];
    
    UIBarButtonItem * item0 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(changeKeyboardToFunction)];
    
    
    UIBarButtonItem * item2 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    toolBar.items = @[item0,item1,item2];
    
    _inputTextField.inputAccessoryView = toolBar;
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"province" ofType:@"plist"];
    _provinceArray = [[NSMutableArray alloc] initWithContentsOfFile:filePath];
    
    
    
    
}

- (void) changeKeyboardToFunction {
    
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
    [_inputTextField becomeFirstResponder];
}



#pragma mark -- UIPickerViewDataSource
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
//    if (_provinceArray != nil) {
//        return _provinceArray.count;
//    }
    
    return 2;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
//    NSArray *citys = _provinceArray[component][@"citys"];
//    if (citys != nil) {
//        return citys.count;
//    }
    return 10;
}


#pragma mark -- UIPickerViewDelegate

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 30;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return @"aaaaa";
}

-(NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"bbbb"];
    return str;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {

}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
