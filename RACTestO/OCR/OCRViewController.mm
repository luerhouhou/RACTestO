//
//  OCRViewController.m
//  RACTestO
//
//  Created by zhanglu on 16/8/15.
//  Copyright © 2016年 zhanglu. All rights reserved.
//

#import "OCRViewController.h"
#import "ReactiveCocoa.h"

#import "EXTScope.h"

#import "UIImage+OpenCV.h"

@interface OCRViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *selectedPhotoBtn;
@property (weak, nonatomic) IBOutlet UIImageView *playImageView;

@property (nonatomic, strong) UIActionSheet *actionSheet;
@property (nonatomic, strong) UIImagePickerController *pickController;
@property (nonatomic, strong) UIImage *originalImage;
@end

@implementation OCRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self bindRAC];
}

- (void)bindRAC
{
    @weakify(self);
    RAC(self, selectedPhotoBtn.backgroundColor) = [RACObserve(self, playImageView.image) map:^id(id value) {
        @strongify(self);
        NSString *title = nil;
        if (!value) {
            title = @"拿照片";
        }
        [self.selectedPhotoBtn setTitle:title forState:UIControlStateNormal];
        return value == nil?[UIColor orangeColor] : [UIColor clearColor];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)takePhotoAction:(id)sender {
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [self.actionSheet showInView:self.view];
    } else {
        [self localPhoto];
    }
}

- (UIActionSheet *)actionSheet
{
    if (!_actionSheet) {
        _actionSheet = [[UIActionSheet alloc] initWithTitle:@"选择图片" delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"相册", nil];
        @weakify(self);
        [_actionSheet.rac_buttonClickedSignal subscribeNext:^(id x) {
            @strongify(self);
            if ([x integerValue] == 0) {
                [self takePhoto];
            }
            else if ([x integerValue] == 1) {
                [self localPhoto];
            }
        }];
    }
    return _actionSheet;
}

- (UIImagePickerController *)pickController
{
    if (!_pickController) {
        _pickController = [[UIImagePickerController alloc] init];
        _pickController.delegate = self;
    }
    return _pickController;
}

- (void)takePhoto
{
    self.pickController.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:self.pickController animated:YES completion:nil];
}

- (void)localPhoto
{
    self.pickController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:self.pickController animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    NSString *type = info[UIImagePickerControllerMediaType];
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"])
    {
        UIImage *image = info[UIImagePickerControllerEditedImage];
        [self performSelector:@selector(setOriginalImage:) withObject:image afterDelay:0.5];
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)setOriginalImage:(UIImage *)originalImage
{
    _originalImage = originalImage;
    self.playImageView.image = originalImage;
}

- (IBAction)readPhoto:(id)sender {
    NSString *readed=[self OCRImage:self.playImageView.image];
    [[[UIAlertView alloc] initWithTitle:@""
                                message:[NSString stringWithFormat:@"Recognized:\n%@", readed]
                               delegate:nil
                      cancelButtonTitle:nil
                      otherButtonTitles:@"OK", nil] show];
}

- (NSString*) OCRImage:(UIImage*)src{
    
    // init the tesseract engine.
    tesseract::TessBaseAPI *tesseract = new tesseract::TessBaseAPI();
    
    tesseract->Init([[self pathToLangugeFIle] cStringUsingEncoding:NSUTF8StringEncoding], "eng");
    
    //Pass the UIIMage to cvmat and pass the sequence of pixel to tesseract
    
    cv::Mat toOCR=[src CVGrayscaleMat];
    
    NSLog(@"%d", toOCR.channels());
    
    tesseract->SetImage((uchar*)toOCR.data, toOCR.size().width, toOCR.size().height
                        , toOCR.channels(), toOCR.step1());
    
    tesseract->Recognize(NULL);
    
    char* utf8Text = tesseract->GetUTF8Text();
    
    return [NSString stringWithUTF8String:utf8Text];
    
}
- (NSString*) pathToLangugeFIle{
    
    // Set up the tessdata path. This is included in the application bundle
    // but is copied to the Documents directory on the first run.
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = ([documentPaths count] > 0) ? [documentPaths objectAtIndex:0] : nil;
    
    NSString *dataPath = [documentPath stringByAppendingPathComponent:@"tessdata"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // If the expected store doesn't exist, copy the default store.
    if (![fileManager fileExistsAtPath:dataPath]) {
        // get the path to the app bundle (with the tessdata dir)
        NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
        NSString *tessdataPath = [bundlePath stringByAppendingPathComponent:@"tessdata"];
        if (tessdataPath) {
            [fileManager copyItemAtPath:tessdataPath toPath:dataPath error:NULL];
        }
    }
    
    setenv("TESSDATA_PREFIX", [[documentPath stringByAppendingString:@"/"] UTF8String], 1);
    
    return dataPath;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
