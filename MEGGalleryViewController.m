//
//  MEGGalleryViewController.m
//  Snapalyzer
//
//  Created by Kamen Tsvetkov on 7/24/14.
//  Copyright (c) 2014 Megatronix. All rights reserved.
//

#import "MEGImageViewController.h"
#import "MEGMainViewController.h"
#import "SnapalyzerTableViewCell.h"
#import "MEGGalleryViewController.h"


@interface MEGGalleryViewController ()

@property (strong, nonatomic) IBOutlet UITableView *myTable1;
@property (strong, nonatomic) NSArray *nameData;
@property (strong, nonatomic) NSMutableArray *pictureDataFullCompressed;
@property (strong, nonatomic) MEGImageViewController *imageView;
@property (strong, nonatomic) NSString *mainFilePath;


@end

@implementation MEGGalleryViewController

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.mainFilePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingString:@"/"];
    self.nameData = [self getNameData];
    self.pictureDataFullCompressed = [self getPictureDataFullCompressed:self.nameData];
    self.myTable1.delegate=self;
    self.myTable1.dataSource=self;
    self.myTable1.tableFooterView = [UIView new];
    self.myTable1.tableFooterView.backgroundColor = [UIColor blackColor];
}

-(void)reloadData
{
    self.nameData = [self getNameData];
    self.pictureDataFullCompressed = [self getPictureDataFullCompressed:self.nameData];
    [self.myTable1 reloadData];
}

- (IBAction)goBack {
    MEGMainViewController *oView = [[MEGMainViewController alloc] init];
    [self presentViewController:oView animated:NO completion:nil];
}

-(NSArray *)getNameData
{
    NSArray *arrayData = nil;
    NSString *bundleRoot = self.mainFilePath;
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *dirContents = [fm contentsOfDirectoryAtPath:bundleRoot error:nil];
    NSPredicate *fltr = [NSPredicate predicateWithFormat:@"self ENDSWITH '(compressed).jpg'"];
    arrayData = [dirContents filteredArrayUsingPredicate:fltr];
    arrayData = [NSArray arrayWithArray:[self reverseArray:[NSMutableArray arrayWithArray:arrayData]]];
    return arrayData;
}

-(NSMutableArray *)getPictureDataFullCompressed:(NSArray *) arrayData
{
    NSMutableArray *toReturn = [NSMutableArray arrayWithObjects:nil];
    for (NSString *key in arrayData) {
        UIImage *newKey = [UIImage imageWithContentsOfFile:[self.mainFilePath stringByAppendingString:key]];
        [toReturn addObject:newKey];
    }
    return toReturn;
}

- (NSMutableArray *)reverseArray:(NSMutableArray *)arrayToReverse {
    if ([arrayToReverse count] == 0)
        return nil;
    NSUInteger i = 0;
    NSUInteger j = [arrayToReverse count] - 1;
    while (i < j) {
        [arrayToReverse exchangeObjectAtIndex:i
                            withObjectAtIndex:j];
        
        i++;
        j--;
    }
    return arrayToReverse;
}

-(NSString *)convertString:(NSString *) originalString
{
     NSString *toReturn = @"";
     NSString *amPm = @"";
     
     NSRange monthRange = NSMakeRange(4, 2);
     NSRange dayRange = NSMakeRange(6, 2);
     NSRange yearRange = NSMakeRange(2, 2);
     NSRange hourRange = NSMakeRange(8, 2);
     NSRange minuteRange = NSMakeRange(10, 2);
     
     NSString *month = [originalString substringWithRange:monthRange];
     NSString *day = [originalString substringWithRange:dayRange];
     NSString *year = [originalString substringWithRange:yearRange];
     NSString *hour = [originalString substringWithRange:hourRange];
     NSString *minute = [originalString substringWithRange:minuteRange];
     
     int hourNumber = [hour intValue];
     
     if(hourNumber > 11) {
     amPm = @"pm";
     hourNumber = hourNumber - 12;
     } else {
     amPm = @"am";
     }
     
     if (hourNumber == 0) {
     hourNumber = 12;
     }
     
     hour = [NSString stringWithFormat:@"%d",hourNumber];
     
     toReturn = [[[[[[[[[[toReturn
     stringByAppendingString:hour]
     stringByAppendingString:@":"]
     stringByAppendingString:minute]
     stringByAppendingString:amPm]
     stringByAppendingString:@"\n"]
     stringByAppendingString:month]
     stringByAppendingString:@"/"]
     stringByAppendingString:day]
     stringByAppendingString:@"/"]
     stringByAppendingString:year];
     
     if (hourNumber < 10) {
     toReturn = [toReturn stringByAppendingString:@" "];
     }
     
     return toReturn;
}

// sections "should be 1"
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

// height of a row
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

// total rows in each section
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//dataSource
{
    NSUInteger toReturn;
    if (self.nameData == nil || [self.nameData count] == 0) {
        toReturn = 1;
    } else {
        toReturn = [self.nameData count];
    }
    return toReturn;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//dataSource
{

        static NSString *CellIdentifier = @"cell";
        SnapalyzerTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil)
        {
            cell = [[SnapalyzerTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] ;
        }
    
        if (self.nameData == nil || [self.nameData count] == 0) {
            [cell setUserInteractionEnabled:NO];
            cell.separatorInset = UIEdgeInsetsMake(0.f, 0.f, 0.f, cell.bounds.size.width);
            cell.textLabel.text = @"                No Images Available";
        } else {
            cell.contentView.backgroundColor = [ UIColor whiteColor];
            cell.imageView.image = [self.pictureDataFullCompressed objectAtIndex:indexPath.row];

            NSString *originalString = [self.nameData objectAtIndex:indexPath.row];

            cell.textLabel.numberOfLines = 2;
            const CGFloat fontSize = 14;
            const CGFloat boldFontSize = 22;


            UIFont *boldFont = [UIFont systemFontOfSize:boldFontSize];
            UIFont *regularFont = [UIFont systemFontOfSize:fontSize];

            UIColor *foregroundColor = [UIColor blackColor];

            NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:
                                   boldFont,
                                   NSFontAttributeName,
                                   foregroundColor,
                                   NSForegroundColorAttributeName,
                                   nil];

            NSDictionary * subAttrs = [NSDictionary dictionaryWithObjectsAndKeys:
                                       regularFont,
                                       NSFontAttributeName,
                                       nil];
            
            NSRange range = NSMakeRange(7, 9);

           NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:[self convertString:originalString] attributes:attrs];
            
           [attributedText setAttributes:subAttrs range:range];

           [cell.textLabel setAttributedText: attributedText];
        }

        return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.nameData == nil || [self.nameData count] == 0) {
        return;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    MEGImageViewController *viewImage = [[MEGImageViewController alloc] init];
    viewImage.picturePath = [self.mainFilePath stringByAppendingString:[self.nameData objectAtIndex:indexPath.row]];
    [self presentViewController:viewImage animated:NO completion:nil];
}

/*
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}*/

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 -(UIColor*)colorWithHexString:(NSString*)hex
 {
 NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
 
 // String should be 6 or 8 characters
 if ([cString length] < 6) return [UIColor grayColor];
 
 // strip 0X if it appears
 if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
 
 if ([cString length] != 6) return  [UIColor grayColor];
 
 // Separate into r, g, b substrings
 NSRange range;
 range.location = 0;
 range.length = 2;
 NSString *rString = [cString substringWithRange:range];
 
 range.location = 2;
 NSString *gString = [cString substringWithRange:range];
 
 range.location = 4;
 NSString *bString = [cString substringWithRange:range];
 
 // Scan values
 unsigned int r, g, b;
 [[NSScanner scannerWithString:rString] scanHexInt:&r];
 [[NSScanner scannerWithString:gString] scanHexInt:&g];
 [[NSScanner scannerWithString:bString] scanHexInt:&b];
 
 return [UIColor colorWithRed:((float) r / 255.0f)
 green:((float) g / 255.0f)
 blue:((float) b / 255.0f)
 alpha:1.0f];
 }
 */

@end
