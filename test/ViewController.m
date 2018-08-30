//
//  ViewController.m
//  test
//
//  Created by Tiany on 2018/8/29.
//  Copyright © 2018 Tiany. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *dateText;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:YES forKey:@"22222"];
    [userDefaults synchronize];
    
    NSLog(@"====%d", [userDefaults boolForKey:@"22222"]);
    
   
    
}

- (IBAction)buttonAction:(id)sender {
    
    if (_dateText.text.length <= 0) {
        self.resultLabel.text = @"请输入日期";
    } else {
        self.resultLabel.text = [self formatDate:self.dateText.text];
        
        NSLog(@"===%@",[self formatDate:self.dateText.text]);
    }
}

- (NSString *)formatDate:(NSString *)dateStr {
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    NSDate *createdAtDate = [fmt dateFromString:dateStr];
    
    if ([self isThisYear:createdAtDate]) { // 今年
        if ([self isYesterday:createdAtDate]) { // 昨天
            fmt.dateFormat = @"昨天 HH:mm:ss";
            return [fmt stringFromDate:createdAtDate];
        } else if ([self isToday:createdAtDate]) { // 今天
            NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
            NSCalendarUnit unit = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
            NSDateComponents *cmps = [calendar components:unit fromDate:createdAtDate toDate:[NSDate date] options:0];
            
            if (cmps.hour >= 1) { // 时间间隔 >= 1小时
                return [NSString stringWithFormat:@"%zd小时前", cmps.hour];
            } else if (cmps.minute >= 1) { // 1小时 > 时间间隔 >= 1分钟
                return [NSString stringWithFormat:@"%zd分钟前", cmps.minute];
            } else if (cmps.second >= 5) { // 时间间隔 < 1分钟 && // 时间间隔 >= 5秒钟
                return [NSString stringWithFormat:@"%zd秒钟前", cmps.second];
            } else { // // 时间间隔 < 5秒钟
                return @"刚刚";
            }
        } else { // 不是今天昨天
            fmt.dateFormat = @"MM-dd HH:mm:ss";
            return [fmt stringFromDate:createdAtDate];
        }
    } else { // 不是今年
        fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
        return [fmt stringFromDate:createdAtDate];
    }
}

// 是否是今天
- (BOOL)isToday:(NSDate *)date {
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyyMMdd";
    
    NSString *nowString = [fmt stringFromDate:[NSDate date]];
    NSString *selfString = [fmt stringFromDate:date];
    
    return [nowString isEqualToString:selfString];
}

// 是否是昨天
- (BOOL)isYesterday:(NSDate *)date {
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyyMMdd";
    
    NSString *nowString = [fmt stringFromDate:[NSDate date]];
    NSString *selfString = [fmt stringFromDate:date];
    
    NSDate *nowDate = [fmt dateFromString:nowString];
    NSDate *selfDate = [fmt dateFromString:selfString];
    
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSCalendarUnit unit = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay;
    NSDateComponents *cmps = [calendar components:unit fromDate:selfDate toDate:nowDate options:0];
    
    return cmps.year == 0 && cmps.month == 0 && cmps.day == 1;
}

// 是否是今年
- (BOOL)isThisYear:(NSDate *)date {
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy";
    
    NSString *nowYear = [fmt stringFromDate:[NSDate date]];
    NSString *selfYear = [fmt stringFromDate:date];
    
    return [nowYear isEqualToString:selfYear];

}

- (NSDate *)test1 {
    // 1.返回的数据为 Tue May 31 18:20:45 +0800 2011
    NSString *string = @"Tue May 31 18:20:45 +0800 2011";
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"EEE MMM dd HH:mm:ss ZZZZ yyyy";
    fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en-US"];
    NSDate *date = [fmt dateFromString:string];
    return date;
}

- (NSDate *)test2 {
    // 2.返回的数据为 12/23/2015 12点08:03秒
    NSString *string = @"12/23/2015 12点08:03秒";
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"MM/dd/yyyy HH点mm:ss秒";
    NSDate *date = [fmt dateFromString:string];
    return date;
}

- (void)test3 {
    // 3.返回的数据为 2015-12-26 12:08:03
    NSString *createdAt = @"2015-12-26 12:08:03";
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
}

- (NSDate *)test4 {
    // 4.还有种特殊情况,也许服务器会返回一长串数字,譬如525245245,这个不是服务器出错了,这长串数字叫时间戳,这时候需要将时间戳转换为1970年的时间,并且除以1000
    NSString *string = @"1454645645654";
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:string.doubleValue / 1000];
    return date;
}



@end
