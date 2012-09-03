//
//  NyBtDetailViewController.m
//  Nyaya
//
//  Created by Alexander Maringele on 22.08.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "NyBtDetailViewController.h"
#import "NyAccessoryController.h"
#import "UIColor+Nyaya.h"
#import "NyayaParser.h"
#import "NyayaNode.h"
#import "TruthTable.h"
#import "BddNode.h"
#import "UITextField+Nyaya.h"

@interface NyBtDetailViewController () <NyAccessoryController> {
    dispatch_queue_t queue;
}
@end

@implementation NyBtDetailViewController

// NyAccessoryDelegate protocol properties
@synthesize accessoryView, backButton, actionButton, dismissButton;


- (NSString*)localizedBarButtonItemTitle {
    return NSLocalizedString(@"BoolTool", @"BoolTool");
}

#pragma mark - ny accessor controller protocol

- (BOOL)accessoryViewShouldBeVisible {
    return NO;
}

- (void)loadAccessoryView {
    if (!self.inputAccessoryView) {
        [[NSBundle mainBundle] loadNibNamed:@"NyExtendedKeysView" owner:self options:nil];
        [self configureAccessoryView];
    }
}

- (void)configureAccessoryView {
    [self.accessoryView viewWithTag:100].backgroundColor = [UIColor nyKeyboardBackgroundColor];
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

- (IBAction)action:(UIButton *)sender {
    [self didEndOnExit:sender];
}

- (IBAction)dismiss:(UIButton*)sender {
    [self.inputField resignFirstResponder];
}

#pragma mark - additional ib actions

- (IBAction)parenthesize:(UIButton *)sender {
    [self.inputField parenthesize];
}

- (IBAction)negate:(UIButton *)sender {
    [self.inputField negate];
}

- (IBAction)send:(id)sender {
    self.resultView.hidden = NO;
    [self compute];
}

- (IBAction)didEndOnExit:(id)sender {
    self.resultView.hidden = NO;
    [self compute];
}

- (IBAction)editingChanged:(id)sender {
    [self resetOutputViews];
    [self parse];
}

- (IBAction)editingDidBegin:(id)sender {
    [self resetOutputViews];
}

#pragma mark - view configuration

- (void)configureView
{
    [super configureView];
    // Update the user interface for the detail item.
    
    if (self.detailItem) {
        self.inputName.text = [self.detailItem title];
        self.inputField.text = [self.detailItem input];
        
        [self.inputField becomeFirstResponder];
        
        self.navigationItem.title = [self.detailItem title];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self resetOutputViews];
    [self loadAccessoryView];
    [self.inputField becomeFirstResponder];
    
    queue = dispatch_queue_create("at.maringele.nyaya.booltool.queue", DISPATCH_QUEUE_SERIAL);
    
    if (self.detailItem) [self configureView];
}

- (void)viewDidUnload {
    [self setInputField:nil];
    [self setParsedField:nil];
    [self setSatisfiabilityLabel:nil];
    [self setTautologyLabel:nil];
    [self setContradictionLabel:nil];
    [self setNnfLabel:nil];
    [self setNnfField:nil];
    [self setCnfLabel:nil];
    [self setCnfField:nil];
    [self setDnfLabel:nil];
    [self setDnfField:nil];
    [self setResultView:nil];
    [self setStdLabel:nil];
    [self setStdField:nil];
    [self setBddView:nil];
    [self setInputName:nil];
    [super viewDidUnload];
}

- (void)resetOutputViews {
    self.resultView.hidden = YES;
    
    self.nnfField.text = @"";
    self.cnfField.text = @"";
    self.dnfField.text = @"";
    
    self.parsedField.text = @"";
    
    self.satisfiabilityLabel.backgroundColor = [UIColor nyLightGreyColor];
    self.tautologyLabel.backgroundColor = [UIColor nyLightGreyColor];
    self.contradictionLabel.backgroundColor = [UIColor nyLightGreyColor];
    self.parsedField.backgroundColor = [UIColor nyLightGreyColor];
}



- (void)parse {
    NyayaParser *parser = [[NyayaParser alloc] initWithString:self.inputField.text];
    dispatch_async(queue, ^{
        dispatch_queue_t mq = dispatch_get_main_queue();
        
        NyayaNode *node = [parser parseFormula];
        NSString *description = [[node description] stringByReplacingOccurrencesOfString:@"(null)" withString:@"…"];
        
        dispatch_async(mq, ^{
            self.parsedField.text = description;
            self.parsedField.backgroundColor = parser.hasErrors ? [UIColor nyWrongColor] : [UIColor nyRightColor];
            [self adjustResultViewPosition];
        });
    });
}

- (void)compute {
    
    NyayaParser *parser = [[NyayaParser alloc] initWithString:self.inputField.text];
    dispatch_async(queue, ^{
        dispatch_queue_t mq = dispatch_get_main_queue();
        
        NyayaNode *node = [parser parseFormula];
        NSString *description = [[node description] stringByReplacingOccurrencesOfString:@"(null)" withString:@"…"];
        
        BOOL hasErrors = parser.hasErrors;
        
        
        
        dispatch_async(mq, ^{
            self.parsedField.text = description;
            self.parsedField.backgroundColor = hasErrors ? [UIColor nyWrongColor] : [UIColor nyRightColor];
            self.resultView.hidden = hasErrors;
            [self adjustResultViewPosition];
        });
        
        
        
        if (!hasErrors) {
            NSString *stdDescription = [[node std] description];
            TruthTable *truthTable = [[TruthTable alloc] initWithFormula:node];
            [truthTable evaluateTable];
            
            BOOL sat = truthTable.isSatisfiable;
            BOOL tau = truthTable.isTautology;
            BOOL con = truthTable.isContradiction;
            
            NSString *nf = nil;
            if (tau) nf = @"T";
            else if (con) nf = @"F";
            
            dispatch_async(mq, ^{
                self.stdField.text = stdDescription;
                self.satisfiabilityLabel.backgroundColor = sat ? [UIColor nyRightColor] : [UIColor nyWrongColor];
                self.tautologyLabel.backgroundColor = tau ? [UIColor nyRightColor] : [UIColor nyLightGreyColor];
                self.contradictionLabel.backgroundColor = con ? [UIColor nyWrongColor] : [UIColor nyLightGreyColor];
                if (nf) {
                    self.nnfField.text = nf;
                    self.cnfField.text = nf;
                    self.dnfField.text = nf;
                }
                
                if (tau) self.bddView.bddNode = [BddNode top];
                else if (con) self.bddView.bddNode = [BddNode bottom];
            });
            
            NSUInteger bddLevelCount = 1;
            if (!nf) {
                BddNode *bdd = [BddNode diagramWithTruthTable:truthTable];
                
                NSString *cnfdescription = [bdd cnfDescription];
                NSString *dnfdescription = [bdd dnfDescription];
                NSString *nnfdescription = [cnfdescription length] > [dnfdescription length] ? dnfdescription : cnfdescription;
                
                dispatch_async(mq, ^{
                    self.nnfField.text = nnfdescription;
                    self.cnfField.text = cnfdescription;
                    self.dnfField.text = dnfdescription;
                    self.bddView.bddNode = bdd;
                });
                bddLevelCount = bdd.levelCount;
            }
            else {
                dispatch_async(mq, ^{
                    if (tau) self.bddView.bddNode = [BddNode top];
                    else if (con) self.bddView.bddNode = [BddNode bottom];
                });
            }
            
           
            
            dispatch_async(mq, ^{
                // [self.inputField becomeFirstResponder];
                [self.inputSaver save:self.inputName.text input:self.parsedField.text]; // must be the main thread
                [self adjustResultViewContent:bddLevelCount];
                
                
            });
            
            
            
            
        }
        
    });
    
}

- (CGSize)textViewSize:(UITextView*)textView {
    CGFloat height = textView.contentSize.height-16;
    if (height > 120.0) {
        textView.scrollEnabled = YES;
        height = 120.0;
    }
    else textView.scrollEnabled = NO;
    
    return CGSizeMake(textView.contentSize.width, height);
}

- (CGFloat)resizeView:(UIView*)view toSize:(CGSize)size yOffset:(CGFloat)yoffset {
    CGFloat height = view.frame.size.height;
    CGFloat newHeight = size.height + 16;
    if (newHeight<37) newHeight = 37;
    
    
    [view setFrame:CGRectMake(view.frame.origin.x,
                                  view.frame.origin.y + yoffset,
                                  view.frame.size.width,
                                  newHeight)];
    return view.frame.size.height - height;
}

- (void)moveView:(UIView*)view toY:(CGFloat)y {
    CGRect f = view.frame;
    view.frame = CGRectMake(f.origin.x, y, f.size.width, f.size.height);
    
}

- (void)alignView:(UIView*)view toTopY:(CGRect)r {
    [self moveView:view toY:r.origin.y];
}

- (void)adjustResultViewPosition {
    CGFloat yoffset = 0.0;
    
    CGSize size = [self textViewSize: self.parsedField];
    yoffset += [self resizeView: self.parsedField toSize:size yOffset:yoffset];
    
    if (yoffset != 0.0) {
        
        CGRect f = self.resultView.frame;
        self.resultView.frame = CGRectMake(f.origin.x, f.origin.y + yoffset, f.size.width, f.size.height - yoffset);
    }
    
}

- (void)adjustResultViewContent:(NSUInteger)bddLevelCount {
    CGFloat yoffset = 0.0;
    
    
    for (UITextView *textView in @[_stdField, _nnfField, _cnfField, _dnfField]) {
        CGSize size = [self textViewSize: textView];
        yoffset += [self resizeView: textView toSize:size yOffset:yoffset];
    }
    
    [self alignView:self.stdLabel toTopY:self.stdField.frame];
    [self alignView:self.nnfLabel toTopY:self.nnfField.frame];
    [self alignView:self.cnfLabel toTopY:self.cnfField.frame];
    [self alignView:self.dnfLabel toTopY:self.dnfField.frame];
    
    CGRect f = self.bddView.frame;
    self.bddView.frame = CGRectMake(f.origin.x, f.origin.y + yoffset, f.size.width, 20 + bddLevelCount * (50+60) - 60 + 20);
    
    // [self moveView:self.bddView toY: self.bddView.frame.origin.y + yoffset];
    
    
    self.resultView.contentSize = CGSizeMake(self.resultView.frame.size.width, self.bddView.frame.origin.y + self.bddView.frame.size.height);
    [self.bddView setNeedsDisplay];
    
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [self.bddView setNeedsDisplay];
}
@end
