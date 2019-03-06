//
//  NyDetailViewController.m
//  Nyaya
//
//  Created by Alexander Maringele on 22.08.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "NyDetailViewController.h"
#import "UIColor+Nyaya.h"
#import "UITextField+Nyaya.h"
#import "NyayaConstants.h"

@interface NyDetailViewController ()

@end

@implementation NyDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}


#pragma mark - Split view

// ****************************
// !!! OVERRIDE IN SUBCLASS !!!
// ****************************
- (NSString*)localizedBarButtonItemTitle {
    return NSLocalizedString(@"MASTER", @"Override in subclasses!");
}

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = [self localizedBarButtonItemTitle];
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

- (BOOL)splitViewController:(UISplitViewController*)svc
   shouldHideViewController:(UIViewController *)vc
              inOrientation:(UIInterfaceOrientation)orientation
{
    return YES; // this method will be called only once per orientation
}

#pragma mark - Managing the detail item

// ****************************
// !!! OVERRIDE IN SUBCLASS !!!
// ****************************
- (void)configureView {
    if (_detailItem) self.navigationItem.title = [_detailItem description];
    self.navigationItem.title = [self localizedBarButtonItemTitle];
}

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
    
    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }
}

@end

@implementation NyDetailInputViewController
// NyAccessoryDelegate protocol properties
@synthesize accessoryView, backButton, processButton, dismissButton;

#pragma mark - ny accessor controller protocol

- (NSString*)localizedBarButtonItemTitle {
    return NSLocalizedString(@"Formulas", nil);
}

- (BOOL)accessoryViewShouldBeVisible {
    return YES;
}

- (void)loadAccessoryView {
    if (!self.inputAccessoryView) {
        [[NSBundle mainBundle] loadNibNamed:@"NyExtendedKeysView" owner:self options:nil];
        [self configureAccessoryView];
    }
}

- (void)configureAccessoryView {
    [self.accessoryView viewWithTag:KEY_BACKGROUND_TAG].backgroundColor = [UIColor nyKeyboardBackgroundColor];
    self.inputField.inputView = self.accessoryView;
}

- (void)unloadAccessoryView {
    self.inputField.inputView = nil;
    self.inputField.inputAccessoryView = nil;
    self.accessoryView = nil;
}

- (IBAction)press:(UIButton *)sender {
    [self.inputField insertText:sender.currentTitle];
}

- (IBAction)back:(UIButton *)sender {
    [self.inputField deleteBackward];
}

- (IBAction)process:(UIButton *)sender {
    // implement in subclass
}

- (IBAction)dismiss:(UIButton*)sender {
    [self.inputField resignFirstResponder];
}

- (IBAction)negate:(UIButton *)sender {
    [self.inputField negate];
}

- (IBAction)parenthesize:(UIButton *)sender {
    [self.inputField parenthesize];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadAccessoryView];
}
@end
