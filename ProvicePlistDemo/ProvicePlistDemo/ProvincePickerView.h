//
//  ProvincePickerView.h
//  ProvicePlistDemo
//
//  Created by Mr.LuDashi on 16/5/25.
//  Copyright © 2016年 ZeluLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProvinceModel.h"

typedef void (^SelectProvinceInfoBlock) (ProvinceModel *currentProvinceModel);

@interface ProvincePickerView : UIView
- (void) setSelectProvinceInfoBlock: (SelectProvinceInfoBlock) block;
- (void) showPickerView;
@end
