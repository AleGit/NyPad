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
@synthesize inputField;
@synthesize parsedFormulalLabel;
@synthesize parsedLabel;
@synthesize parsedField;
@synthesize satisfiabilityLabel;
@synthesize tautologyLabel;
@synthesize contradictionLabel;
@synthesize resultView;
@synthesize stdLabel;
@synthesize stdField;
@synthesize nnfLabel;
@synthesize nnfField;
@synthesize cnfLabel;
@synthesize cnfField;
@synthesize dnfLabel;
@synthesize dnfField;
@synthesize bddView;

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
        [self.inputField becomeFirstResponder];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self resetOutputViews];
    [self loadAccessoryView];
    [self.inputField becomeFirstResponder];
    
    queue = dispatch_queue_create("at.maringele.nyaya.booltool.queue", DISPATCH_QUEUE_SERIAL);
}

- (void)viewDidUnload {
    // [self setInputField:nil];
    [self setParsedFormulalLabel:nil];
    [self setParsedLabel:nil];
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
    self.parsedLabel.backgroundColor = [UIColor nyLightGreyColor];
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
    if (![self.inputField hasText]) {
        // ignore
    }
    else {
        NyayaParser *parser = [[NyayaParser alloc] initWithString:self.inputField.text];
        dispatch_async(queue, ^{
            dispatch_queue_t mq = dispatch_get_main_queue();
            
            NyayaNode *node = [parser parseFormula];
            NSString *description = [[node description] stringByReplacingOccurrencesOfString:@"(null)" withString:@"…"];
            BOOL hasErrors = parser.hasErrors;
            
            dispatch_async(mq, ^{
                self.parsedField.text = description;
                self.parsedField.backgroundColor = hasErrors ? [UIColor nyWrongColor] : [UIColor nyRightColor];
                [self adjustResultViewPosition];
            });
            
            if (!hasErrors) {
                TruthTable *truthTable = [[TruthTable alloc] initWithFormula:node compact:YES];
                [truthTable evaluateTable];
                
                BOOL sat = truthTable.isSatisfiable;
                BOOL tau = truthTable.isTautology;
                BOOL con = truthTable.isContradiction;
                
                NSString *nf = nil;
                if (tau) nf = @"T";
                else if (con) nf = @"F";
                
                dispatch_async(mq, ^{
                    self.satisfiabilityLabel.backgroundColor = sat ? [UIColor nyRightColor] : [UIColor nyWrongColor];
                    self.tautologyLabel.backgroundColor = tau ? [UIColor nyRightColor] : [UIColor nyLightGreyColor];
                    self.contradictionLabel.backgroundColor = con ? [UIColor nyWrongColor] : [UIColor nyLightGreyColor];
                    if (nf) {
                        self.nnfField.text = nf;
                        self.cnfField.text = nf;
                        self.dnfField.text = nf;
                    }
                });
                
                if (!nf) {
                    
                    
                    
                    BddNode *bdd = [BddNode diagramWithTruthTable:truthTable];
                    
                    NSString *cnfdescription = [bdd cnfDescription];
                    NSString *dnfdescription = [bdd dnfDescription];
                    NSString *nnfdescription = [cnfdescription length] > [dnfdescription length] ? dnfdescription : cnfdescription;
                    
                    dispatch_async(mq, ^{
                        self.nnfField.text = nnfdescription;
                        self.cnfField.text = cnfdescription;
                        self.dnfField.text = dnfdescription;
                    });

                    
                    
//
//                                        
//                    if ([truthTable.variables count] < 6) {
//                        /* transformations with many variables are too expensive */
//
//                        NyayaNode *imfnode = [node imf];
//                        
//                        NyayaNode *nnfnode = [imfnode nnf];
//                        nnfdescription = nf ? nf : [nnfnode description];
//                        dispatch_async(mq, ^{
//                            self.nnfField.text = nnfdescription;
//                            self.nnfField.backgroundColor = [UIColor nyLightGreyColor];
//                        });
//
//                        NyayaNode *cnfnode = [nnfnode cnf];
//                        cnfdescription = nf ? nf : [cnfnode description];
//                        dispatch_async(mq, ^{
//                            self.cnfField.text = cnfdescription;
//                            self.cnfField.backgroundColor = [UIColor nyLightGreyColor];
//                        });
//                        
//                        
//                        NyayaNode *dnfnode = [nnfnode dnf];
//                        dnfdescription = nf ? nf : [dnfnode description];
//                        
//                        dispatch_async(mq, ^{
//                            self.dnfField.text = dnfdescription;
//                            self.dnfField.backgroundColor = [UIColor nyLightGreyColor];
//                        });
//                    } 
//                    
//                    NSString *ttcnf = [truthTable cnfDescription];
//                    NSString *ttdnf = [truthTable dnfDescription];
//                    
//                    NSString *ttnnf = [ttcnf length] <= [ttdnf length] ? ttcnf : ttcnf;
//                    
//                    if (!nnfdescription || [ttnnf length] < [nnfdescription length]) {
//                        dispatch_async(mq, ^{
//                            self.nnfField.text = ttnnf;
//#ifdef DEBUG
//                            self.nnfField.backgroundColor = [UIColor nyRightColor];
//#endif
//                        });
//                    }
//                    
//                    if (!cnfdescription || [ttcnf length] < [cnfdescription length]) {
//                        dispatch_async(mq, ^{
//                            self.cnfField.text = ttcnf;
//#ifdef DEBUG
//                            self.cnfField.backgroundColor = [UIColor nyRightColor];
//#endif
//                        });
//                    }
//                    
//                    if (!dnfdescription || [ttdnf length] < [dnfdescription length]) {
//                        dispatch_async(mq, ^{
//                            self.dnfField.text = ttdnf;
//                            
//#ifdef DEBUG
//                            self.dnfField.backgroundColor = [UIColor nyRightColor];
//#endif
//                        });
//                    }
                }
                
                dispatch_async(mq, ^{
                    [self adjustResultViewContent];
                });
                
                
            }
            
        });
    }
}

- (CGSize)textViewSize:(UITextView*)textView {
    CGFloat height = textView.contentSize.height-16;
    if (height > 120.0) {
        textView.scrollEnabled = YES;
        height = 120.0;
    }
    else textView.scrollEnabled = NO;
    
    return CGSizeMake(textView.contentSize.width, height);
    
    //    float fudgeFactor = 16.0;
    //    CGSize tallerSize = CGSizeMake(textView.frame.size.width-fudgeFactor, 72); //kMaxFieldHeight);
    //    NSString *testString = @" ";
    //    if ([textView.text length] > 0) {
    //        testString = textView.text;
    //    }
    //    CGSize stringSize = [testString sizeWithFont:textView.font constrainedToSize:tallerSize lineBreakMode:UILineBreakModeWordWrap];
    //    return stringSize;
}

- (CGFloat)resizeTextView:(UITextView*)textView toSize:(CGSize)size yOffset:(CGFloat)yoffset {
    CGFloat height = textView.frame.size.height;
    CGFloat newHeight = size.height + 16;
    if (newHeight<37) newHeight = 37;

    
    [textView setFrame:CGRectMake(textView.frame.origin.x,
                                  textView.frame.origin.y + yoffset,
                                  textView.frame.size.width,
                                  newHeight)];
    return textView.frame.size.height - height;
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
    yoffset += [self resizeTextView: self.parsedField toSize:size yOffset:yoffset];
    
    if (yoffset != 0.0) {
        
        CGRect f = self.resultView.frame;
        self.resultView.frame = CGRectMake(f.origin.x, f.origin.y + yoffset, f.size.width, f.size.height - yoffset);
    }
    
}

- (void)adjustResultViewContent {
    CGFloat yoffset = 0.0;
    
    
    for (UITextView *textView in @[stdField, nnfField, cnfField, dnfField]) {
        CGSize size = [self textViewSize: textView];
        yoffset += [self resizeTextView: textView toSize:size yOffset:yoffset];
    }
    
    [self alignView:self.stdLabel toTopY:self.stdField.frame];
    [self alignView:self.nnfLabel toTopY:self.nnfField.frame];
    [self alignView:self.cnfLabel toTopY:self.cnfField.frame];
    [self alignView:self.dnfLabel toTopY:self.dnfField.frame];
    [self moveView:self.bddView toY: self.bddView.frame.origin.y + yoffset];
    
    
    self.resultView.contentSize = CGSizeMake(self.resultView.frame.size.width, self.bddView.frame.origin.y + self.bddView.frame.size.height);
    
}
@end
