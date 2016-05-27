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
    
    _provincePicker = [[ProvincePickerView alloc] init];        //初始化ProvincePicker
    [self.view addSubview:_provincePicker];                     //添加到view上
    
    //设置回调数据的Block
    __weak typeof(self) weak_self = self;
    [_provincePicker setSelectProvinceInfoBlock:^(ProvinceModel *currentProvinceModel) {
        if (currentProvinceModel) {
            [weak_self setLabelTextWithProvinceModel:currentProvinceModel];
        }
    }];
    
}

/**
 *  处理回调过来的选择数据
 *
 *  @param currentProvinceModel 当前选择的数据Model
 */
- (void)setLabelTextWithProvinceModel: (ProvinceModel *) currentProvinceModel {
    
    self.currentSelectProvinceModel = currentProvinceModel;
    self.provinceLabel.text = [NSString stringWithFormat:@"%@ %@", currentProvinceModel.provinceName, currentProvinceModel.cityName];
    
    self.currentProvinceNameLabel.text = currentProvinceModel.provinceName;
    self.currentProvinceCodeLabel.text = currentProvinceModel.provinceCode;
    self.currentCityNameLabel.text = currentProvinceModel.cityName;
    self.currentCityCodeLabel.text = currentProvinceModel.cityCode;

}

/**
 *  从服务器获取省市的Json编码，并存储到PList文件中
 *
 *  @param sender
 */
- (IBAction)tapPlistButton:(id)sender {
    
    NSString *hostString = @"http://127.0.0.1/PHPForProvince/read_excel.php";
    
    NSURL *plistURL = [[NSURL alloc] initWithString: hostString];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask =
    [session dataTaskWithURL:plistURL
           completionHandler:^(NSData * _Nullable data,
                               NSURLResponse * _Nullable response,
                               NSError * _Nullable error) {
       
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data
                                                            options:NSJSONReadingAllowFragments error:nil];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSURL *documentPath = [fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask][0] ;
        NSURL *filePath = [documentPath URLByAppendingPathComponent:@"province.plist"];
        
        [dic writeToURL:filePath atomically:YES];
        NSLog(@"文件存储路径%@", filePath);
        
        //从沙盒中读取文件
        NSMutableArray *provinceData = [[NSMutableArray alloc] initWithContentsOfURL:filePath];
        NSLog(@"%@", provinceData);
        
    }];
    
    [dataTask resume];
    
}
- (IBAction)tapRequestSearchButton:(id)sender {
    
    NSString *hostString = @"http://127.0.0.1/read_excel_search.php";
    
    NSURL *plistURL = [[NSURL alloc] initWithString: hostString];
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask =
    [session dataTaskWithURL:plistURL
           completionHandler:^(NSData * _Nullable data,
                               NSURLResponse * _Nullable response,
                               NSError * _Nullable error) {
               
               NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data
                                                                   options:NSJSONReadingAllowFragments error:nil];
               
               NSFileManager *fileManager = [NSFileManager defaultManager];
               NSURL *documentPath = [fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask][0] ;
               NSURL *filePath = [documentPath URLByAppendingPathComponent:@"province_search.plist"];
    
               [dic writeToURL:filePath atomically:YES];
               NSLog(@"文件存储路径%@", filePath);
               
               //从沙盒中读取文件
               NSMutableDictionary *provinceData = [[NSMutableDictionary alloc] initWithContentsOfURL:filePath];
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
