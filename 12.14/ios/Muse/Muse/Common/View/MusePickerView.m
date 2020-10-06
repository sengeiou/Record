//
//  MusePickerView.m
//  Muse
//
//  Created by apple on 16/6/26.
//  Copyright © 2016年 Muse. All rights reserved.
//

#import "MusePickerView.h"
#import "UIColor+FastKit.h"

@interface MusePickerView ()<UIPickerViewDataSource,UIPickerViewDelegate>

@property (nonatomic,assign)MusePickerType pickerType;
@property (nonatomic,weak)IBOutlet UILabel *middleLB;

@property (nonatomic,strong)NSMutableArray *defaultArr;
@property (nonatomic,strong)NSMutableArray *monthArr;
@property (nonatomic,strong)NSMutableArray *dayArr;
@property (nonatomic,strong)NSMutableArray *hourArr;
@property (nonatomic,strong)NSMutableArray *minArr;

@property (nonatomic,weak)IBOutlet UIPickerView *leftPicker;
@property (nonatomic,weak)IBOutlet UIPickerView *rightPicker;
@property (nonatomic,weak)IBOutlet UIPickerView *middlePicker;

@end

@implementation MusePickerView

+ (id)viewFromNib
{
    MusePickerView *view;
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self.class) owner:self options:nil];//加载自定义cell的xib文件
    view = [array objectAtIndex:0];
    return view;
}

- (void)setPickType:(MusePickerType)type middleString:(NSString *)middleString arr:(NSArray *)arr;
{
    [self setMyUIsByType:type middleStr:middleString];
    
    switch (type) {
        case MusePickerTypeDefault:
            [self.middlePicker selectRow:[self.defaultArr indexOfObject:arr[0]] inComponent:0 animated:NO];
            break;
        case MusePickerTypeTime:
            [self.leftPicker selectRow:[self.hourArr indexOfObject:arr[0]] inComponent:0 animated:NO];
            [self.rightPicker selectRow:[self.minArr indexOfObject:arr[1]] inComponent:0 animated:NO];
            break;
        case MusePickerTypeDate:
            [self.leftPicker selectRow:[self.monthArr indexOfObject:arr[0]] inComponent:0 animated:NO];
            [self.rightPicker selectRow:[self.dayArr indexOfObject:arr[1]] inComponent:0 animated:NO];
            break;
            
        default:
            break;
    }
    
}

- (void)setMyUIsByType:(MusePickerType)type middleStr:(NSString *)middleStr
{
    self.backgroundColor =[UIColor clearColor];
    self.clipsToBounds=YES;
    
    self.pickerType = type;
    self.middleLB.text = middleStr;
    self.middleLB.textColor = [UIColor colorWithHex:0x9898a4];
    
    if(type == MusePickerTypeDefault)
    {
        self.defaultArr = [NSMutableArray array];
        for (int i = 0; i<100; i++) {
            [self.defaultArr addObject:[NSString stringWithFormat:@"%02zd",i]];
        }
        
        self.leftPicker.hidden = YES;
        self.rightPicker.hidden = YES;
        self.middleLB.hidden = YES;
        
        self.middleLB.backgroundColor =[UIColor clearColor];
        [self.middlePicker reloadAllComponents];
    }
    else if(type == MusePickerTypeTime)
    {
        self.hourArr = [NSMutableArray array];
        for (int i = 0; i<23; i++) {
            [self.hourArr addObject:[NSString stringWithFormat:@"%02zd",i]];
        }
        
        self.minArr = [NSMutableArray array];
        for (int i = 0; i<59; i++) {
            [self.minArr addObject:[NSString stringWithFormat:@"%02zd",i]];
        }
        
        self.middlePicker.hidden = YES;
        
        [self.leftPicker reloadAllComponents];
        [self.rightPicker reloadAllComponents];
    }
    else if(type == MusePickerTypeDate)
    {
        self.monthArr = [NSMutableArray array];
        for (int i = 1; i<=12; i++) {
            [self.monthArr addObject:[NSString stringWithFormat:@"%02zd",i]];
        }
        
        self.dayArr = [NSMutableArray array];
        for (int i = 1; i<=31; i++) {
            [self.dayArr addObject:[NSString stringWithFormat:@"%02zd",i]];
        }
        
        self.middlePicker.hidden = YES;
        
        [self.leftPicker reloadAllComponents];
        [self.rightPicker reloadAllComponents];
    }
}

#pragma mark - UIPickerViewDataSource UIPickerViewDelegate

-(NSAttributedString*)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSMutableAttributedString *attriStr;
    switch (self.pickerType) {
        case MusePickerTypeDefault:
        {
            if(pickerView == self.middlePicker)
            {
                NSString *str = _defaultArr[row];
                attriStr =[[NSMutableAttributedString alloc]initWithString:str];
                [attriStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:24],NSForegroundColorAttributeName:[UIColor colorWithHex:0x9898a4]} range:NSMakeRange(0, attriStr.length)];
            }
        }
            break;
        case MusePickerTypeTime:
        {
            if(pickerView == self.leftPicker)
            {
                NSString *str = _hourArr[row];
                attriStr =[[NSMutableAttributedString alloc]initWithString:str];
                [attriStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:24],NSForegroundColorAttributeName:[UIColor colorWithHex:0x9898a4]} range:NSMakeRange(0, attriStr.length)];
            }
            else if (pickerView == self.rightPicker)
            {
                NSString *str = _minArr[row];
                attriStr =[[NSMutableAttributedString alloc]initWithString:str];
                [attriStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:24],NSForegroundColorAttributeName:[UIColor colorWithHex:0x9898a4]} range:NSMakeRange(0, attriStr.length)];
            }
        }
            break;
        case MusePickerTypeDate:
        {
            if(pickerView == self.leftPicker)
            {
                NSString *str = _monthArr[row];
                attriStr =[[NSMutableAttributedString alloc]initWithString:str];
                [attriStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:24],NSForegroundColorAttributeName:[UIColor colorWithHex:0x9898a4]} range:NSMakeRange(0, attriStr.length)];
            }
            else if (pickerView == self.rightPicker)
            {
                NSString *str = _dayArr[row];
                attriStr =[[NSMutableAttributedString alloc]initWithString:str];
                [attriStr addAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:24],NSForegroundColorAttributeName:[UIColor colorWithHex:0x9898a4]} range:NSMakeRange(0, attriStr.length)];
            }
        }
            break;
            
        default:
            break;
    }

    
    return attriStr;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}


#pragma mark  -每组多少行
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSArray *result ;
    switch (self.pickerType) {
        case MusePickerTypeDefault:
            result = _defaultArr;
            break;
        case MusePickerTypeTime:
        {
            if(pickerView == self.leftPicker)
            {
                result = _hourArr;
            }
            else if(pickerView == self.rightPicker)
            {
                result = _minArr;
            }
        }
            
            break;
        case MusePickerTypeDate:
        {
            if(pickerView == self.leftPicker)
            {
                result = _monthArr;
            }
            else if(pickerView == self.rightPicker)
            {
                result = _dayArr;
            }
        }
            break;
            
        default:
            break;
    }
    return result.count;
}


#pragma mark -UIPickerView数据代理
#pragma mark 对应组对应行的数据


-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    NSArray *result ;
    switch (self.pickerType) {
        case MusePickerTypeDefault:
            result = _defaultArr;
            break;
        case MusePickerTypeTime:
        {
            if(pickerView == self.leftPicker)
            {
                result = _hourArr;
            }
            else if(pickerView == self.rightPicker)
            {
                result = _minArr;
            }
        }
            
            break;
        case MusePickerTypeDate:
        {
            if(pickerView == self.leftPicker)
            {
                result = _monthArr;
            }
            else if(pickerView == self.rightPicker)
            {
                result = _dayArr;
            }
        }
            break;
            
        default:
            break;
    }
    return [NSString stringWithFormat:@"%@",result[row]];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSArray *result ;
    switch (self.pickerType) {
        case MusePickerTypeDefault:
            result = _defaultArr;
            break;
        case MusePickerTypeTime:
        {
            if(pickerView == self.leftPicker)
            {
                result = _hourArr;
            }
            else if(pickerView == self.rightPicker)
            {
                result = _minArr;
            }
        }
            
            break;
        case MusePickerTypeDate:
        {
            if(pickerView == self.leftPicker)
            {
                result = _monthArr;
            }
            else if(pickerView == self.rightPicker)
            {
                result = _dayArr;
            }
        }
            break;
            
        default:
            break;
    }
    
    LRLog(@"%@",[NSString stringWithFormat:@"%@",result[row]]);
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return self.frame.size.height;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [pickerView rowSizeForComponent:component].width, [pickerView rowSizeForComponent:component].height)];
    
    NSArray *result ;
    switch (self.pickerType) {
        case MusePickerTypeDefault:
            result = _defaultArr;
            
            [label setTextAlignment:NSTextAlignmentCenter];
            break;
        case MusePickerTypeTime:
        {
            if(pickerView == self.leftPicker)
            {
                result = _hourArr;
                
                [label setTextAlignment:NSTextAlignmentRight];
            }
            else if(pickerView == self.rightPicker)
            {
                result = _minArr;
                
                [label setTextAlignment:NSTextAlignmentLeft];
            }
        }
            
            break;
        case MusePickerTypeDate:
        {
            if(pickerView == self.leftPicker)
            {
                result = _monthArr;
                
                [label setTextAlignment:NSTextAlignmentRight];
            }
            else if(pickerView == self.rightPicker)
            {
                result = _dayArr;
                
                [label setTextAlignment:NSTextAlignmentLeft];
            }
        }
            break;
            
        default:
            break;
    }
    label.text = [NSString stringWithFormat:@"%@",result[row]];
    label.textColor = [UIColor colorWithHex:0x9898a4];
    label.font = [UIFont systemFontOfSize:24];
    return label;
}

@end
