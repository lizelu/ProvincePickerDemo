//
//  ProvincePickerView.h
//  ProvicePlistDemo
//
//  Created by Mr.LuDashi on 16/5/25.
//  Copyright © 2016年 ZeluLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProvinceModel.h"

/**
 *  回调用的Block
 *
 *  @param currentProvinceModel 当前选中的省的Model
 */
typedef void (^SelectProvinceInfoBlock) (ProvinceModel *currentProvinceModel);

@interface ProvincePickerView : UIView
/**
 *  设置Block, 用来将用户选则的数据回调给使用者
 *
 *  @param block 回调数据的Block
 */
- (void) setSelectProvinceInfoBlock: (SelectProvinceInfoBlock) block;

/**
 *  显示PickerView
 */
- (void) showPickerView;
@end
