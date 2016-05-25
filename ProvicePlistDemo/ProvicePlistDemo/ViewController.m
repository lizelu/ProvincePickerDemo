//
//  ViewController.m
//  ProvicePlistDemo
//
//  Created by Mr.LuDashi on 16/5/24.
//  Copyright © 2016年 ZeluLi. All rights reserved.
//

#import "ViewController.h"
#import "ProvincePickerView.h"

@interface ViewController ()


@property (strong, nonatomic) ProvinceModel *currentSelectProvinceModel;

@property (strong, nonatomic) IBOutlet UILabel *provinceLabel;

@property (strong, nonatomic) IBOutlet UILabel *currentProvinceNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *currentProvinceCodeLabel;

@property (strong, nonatomic) IBOutlet UILabel *currentCityNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *currentCityCodeLabel;


@property (strong, nonatomic) ProvincePickerView * provincePicker;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _provincePicker = [[ProvincePickerView alloc] init];
    [self.view addSubview:_provincePicker];
    
    __weak typeof(self) weak_self = self;
    [_provincePicker setSelectProvinceInfoBlock:^(ProvinceModel *currentProvinceModel) {
        
        if (currentProvinceModel) {
            weak_self.currentSelectProvinceModel = currentProvinceModel;
            
            weak_self.provinceLabel.text = [NSString stringWithFormat:@"%@ %@", currentProvinceModel.provinceName, currentProvinceModel.cityName];
            
            weak_self.currentProvinceNameLabel.text = currentProvinceModel.provinceName;
            weak_self.currentProvinceCodeLabel.text = currentProvinceModel.provinceCode;
            weak_self.currentCityNameLabel.text = currentProvinceModel.cityName;
            weak_self.currentCityCodeLabel.text = currentProvinceModel.cityCode;
            
        }
    }];

    
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
    
    [self.provincePicker showPickerView];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
