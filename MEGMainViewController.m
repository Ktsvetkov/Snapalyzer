//
//  MEGMainViewController.m
//  Snapalyzer
//
//  Created by Kamen Tsvetkov on 7/24/14.
//  Copyright (c) 2014 Megatronix. All rights reserved.
//

#import "MEGMainViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import <CoreImage/CoreImage.h>
#import <QuartzCore/QuartzCore.h>
#import "MEGGalleryViewController.h"

@interface MEGMainViewController ()

@property (strong, nonatomic) UIAlertView *av;
@property (strong, nonatomic) UIImage *photoTaken;
@property BOOL pictureTaken;
@property (strong, nonatomic) NSString *mainFilePath;


@end

@implementation MEGMainViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.mainFilePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingString:@"/"];
    UIAlertView *toSet =[[UIAlertView alloc] initWithTitle:@"Processing Image..." message:@"" delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
    self.av = toSet;
    UIActivityIndicatorView *ActInd=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    [ActInd startAnimating];
    [ActInd setFrame:CGRectMake(125, 60, 37, 37)];
    [self.av addSubview:ActInd];
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.pictureTaken == YES) {
        
        [self.av show];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            UIImage *img = self.photoTaken;
            BOOL isFace = [self isFace:img];
            int drunkness = [self getDrunkness:img];
            img = [self memeImage:img isFace:isFace drunkness:drunkness];
            [self saveImage: img];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.av dismissWithClickedButtonIndex:0 animated:YES];
            });
        });
        
    }
}
////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////


-(int) getDrunkness:(UIImage*) img
{
    //CIDetector  *detector = [CIDetector detectorOfType:CIDetectorTypeFace
    //                                           context:nil
    //                                           options:[NSDictionary dictionaryWithObject: CIDetectorAccuracyHigh forKey: CIDetectorAccuracy]];
    
    //CIImage *ciImage = [CIImage imageWithCGImage: [image CGImage]];
    //NSArray *features = [detector featuresInImage:ciImage];
    
    //CIFaceFeature *faceFeature = [features objectAtIndex:0];
    
    
    //CGImageRef cgImage = [CIContext createCGImage:[CIImage imageWithCGImage:image.CGImage] fromRect:faceFeature.bounds];
    //UIImage *croppedFace = [UIImage imageWithCGImage:cgImage];
    
    
    //Going back
    //CGImageRef imgRef = [image CGImage];
    //UIImage *img = [UIImage imageWithCGImage:imgRef];
    
    //
    //
    //
    //
    
    //[imageView setAutoresizingMask:(UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth)];
    //imageView.image = image;
    return 0;
}

-(UIImage*) memeImage: (UIImage*) image
               isFace: (BOOL) isFace
            drunkness: (int) drunkness {
    
        //image = [self giveBackground:image];
        NSString *meme;
        NSString *BAC;
        if (isFace) {
            meme = @" So drunk, so wow";
            BAC = @"BAC 0.35%";
        } else {
            meme = @"No faces detected";
            BAC = @"BAC NA";
        }
        
        int textSize = image.size.width/10;
        //UIImage *imgTop = [MEGMainViewController drawText:meme
        //                                          inImage:image
        //                                          atPoint:CGPointMake(image.size.width/2 - 4.1 * textSize, -textSize * .5)
                       //                            ofSize: textSize];
        
        textSize = image.size.width/6;
        
        return [MEGMainViewController drawText:meme
                                       inImage:image
                                       atPoint:CGPointMake(image.size.width/2 - 4.1 * textSize, -textSize * .5)
                                        ofSize: textSize];

}

////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////

-(BOOL) isFace:(UIImage*) img
{
    CIImage* image = [CIImage imageWithCGImage:img.CGImage];
    CIDetector* detector = [CIDetector detectorOfType:CIDetectorTypeFace
                                              context:nil
                                              options:[NSDictionary
                                 dictionaryWithObject:CIDetectorAccuracyHigh
                                               forKey:CIDetectorAccuracy]];
    NSArray* features = [detector featuresInImage:image];

    if ([features count] > 0) {
        return YES;
    } else {
        return NO;
    }
}


-(void) saveImage: (UIImage*) image {
        
        NSData* imageData = UIImageJPEGRepresentation(image, 1);
        NSData* compressedImageData = UIImageJPEGRepresentation([self scaleImage:image], .005);
        
        NSError *error = nil;
        if (![[NSFileManager defaultManager] fileExistsAtPath:self.mainFilePath])
            [[NSFileManager defaultManager] createDirectoryAtPath:self.mainFilePath withIntermediateDirectories:NO attributes:nil error:&error];
        
        double theLoggedInTokenTimestampDateEpochSeconds = [[NSDate date] timeIntervalSince1970];
        NSString *theConversationTimeStampString = [NSString stringWithFormat:@"%f", theLoggedInTokenTimestampDateEpochSeconds];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setLocale:[NSLocale currentLocale]];
        [dateFormatter setTimeZone:nil];
        [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
        NSDate *conversationDate = [NSDate dateWithTimeIntervalSince1970:[theConversationTimeStampString intValue]];
        NSString *conversationDateString = [dateFormatter stringFromDate:conversationDate];
        
        NSString *path = self.mainFilePath;
        path = [path stringByAppendingString:conversationDateString];
        NSString *path1 = [path stringByAppendingString:@".jpg"];
        NSString *path2 = [path stringByAppendingString:@"(compressed).jpg"];
        
        [imageData writeToFile:path1 atomically:NO];
        [compressedImageData writeToFile:path2 atomically:NO];
        
        self.pictureTaken = NO;
        self.photoTaken = nil;
    
}

/*-(UIImage*) giveBackground: (UIImage*) image{
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}*/

+(UIImage*) drawText:(NSString*) text
             inImage:(UIImage*)  image
             atPoint:(CGPoint)   point
              ofSize:(int) size
{
    int canvasWidth = image.size.width + 50;
    int canvasHeight = image.size.height + 700;
    UIGraphicsBeginImageContext(CGSizeMake(canvasWidth, canvasHeight));
    [[UIColor blackColor] set];
    CGContextFillRect(UIGraphicsGetCurrentContext(),
                      CGRectMake(0, 0, canvasWidth, canvasHeight));
    [image drawInRect:CGRectMake((canvasWidth-image.size.width)/2,350,image.size.width,image.size.height)];
    
    UIFont *font = [UIFont boldSystemFontOfSize:size];
    
    
    CGRect rect = CGRectMake(point.x, point.y, image.size.width, image.size.height);
    [[UIColor whiteColor] set];
    NSDictionary *dictionary = @{ NSFontAttributeName: font,
                                  NSParagraphStyleAttributeName: [[NSMutableParagraphStyle alloc] init],
                                  NSForegroundColorAttributeName: [UIColor whiteColor]};
    
    [text drawInRect:CGRectIntegral(rect) withAttributes:dictionary];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (UIImage *)scaleImage:(UIImage *)image{
    CGSize newSize = image.size;
    
    newSize.height = 960;
    newSize.width = 720;
    
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (IBAction)openGalleryView {
    MEGGalleryViewController *oView = [[MEGGalleryViewController alloc] init];
    [self presentViewController:oView animated:NO completion:nil];
}


- (IBAction) showCameraUI {
    [self startCameraControllerFromViewController: self
                                    usingDelegate: (id)self];
}


- (BOOL) startCameraControllerFromViewController: (UIViewController*) controller
                                   usingDelegate: (id <UIImagePickerControllerDelegate,
                                                   UINavigationControllerDelegate>) delegate {
    //Make sure there is a camera
    if (([UIImagePickerController isSourceTypeAvailable:
          UIImagePickerControllerSourceTypeCamera] == NO)
        || (delegate == nil)
        || (controller == nil))
        return NO;
    
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
    cameraUI.mediaTypes =
    [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
    cameraUI.allowsEditing = NO;
    cameraUI.delegate = delegate;
    [controller presentViewController: cameraUI animated:YES completion:nil];
    
    return YES;
}


#pragma mark- camera picker delegate methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info
                           objectForKey:UIImagePickerControllerMediaType];
    
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
        UIImage *image = [info
                          objectForKey:UIImagePickerControllerOriginalImage];
        self.pictureTaken = YES;
        self.photoTaken = image;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];

}

-(void)image:(UIImage *)image
finishedSavingWithError:(NSError *)error
 contextInfo:(void *)contextInfo
{
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Save failed"
                              message: @"Failed to save image"\
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
}

/*- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
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
}
*/
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
