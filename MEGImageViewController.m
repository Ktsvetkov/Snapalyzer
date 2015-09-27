//
//  MEGImageViewController.m
//  Snapalyzer
//
//  Created by Kamen Tsvetkov on 10/11/14.
//  Copyright (c) 2014 Megatronix. All rights reserved.
//

#import "MEGImageViewController.h"
#import "MEGGalleryViewController.h"

@interface MEGImageViewController ()

@property(strong, nonatomic, retain) IBOutlet UIImageView *image;

@end

@implementation MEGImageViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *stringUncompressed = [self.picturePath
                                    stringByReplacingOccurrencesOfString:@"(compressed)" withString:@""];
    UIImage *imageToSet = [UIImage imageWithContentsOfFile:stringUncompressed];
    [self.image setImage:imageToSet];
}

- (IBAction)goBack {
    MEGGalleryViewController *oView = [[MEGGalleryViewController alloc] init];
    [self presentViewController:oView animated:NO completion:nil];
}

- (IBAction)deletePicture {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Delete" message:@"Are you sure?" delegate:self cancelButtonTitle:@"Yes" otherButtonTitles:@"No",nil];
    [alert setTag:11];
    [alert show];
}

- (IBAction)savePicture {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Saved" message:@"Image saved to pictures!" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
    NSString *stringUncompressed = [self.picturePath
                                     stringByReplacingOccurrencesOfString:@"(compressed)" withString:@""];
    
    UIImageWriteToSavedPhotosAlbum([UIImage imageWithContentsOfFile:stringUncompressed], nil, nil, nil);
    [alert setTag:12];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if ([alertView tag] == 12) {
        //do nothing
    } else {
        if (buttonIndex == 1) {
            //do nothing
        } else if (buttonIndex == 0) {
            NSString *path = self.picturePath;
            NSError *error;
            if ([[NSFileManager defaultManager] isDeletableFileAtPath:path]) {
                BOOL success = [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
                if (!success) {
                    NSLog(@"Error removing file at path: %@", error.localizedDescription);
                }
            }
            NSString *stringUncompressed = [path
                                            stringByReplacingOccurrencesOfString:@"(compressed)" withString:@""];
            if ([[NSFileManager defaultManager] isDeletableFileAtPath:stringUncompressed]) {
                BOOL success = [[NSFileManager defaultManager] removeItemAtPath:stringUncompressed error:&error];
                if (!success) {
                    NSLog(@"Error removing file at path: %@", error.localizedDescription);
                }
            }
            [self goBack];
        }
    }
}


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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
