//
//  NyBtDetailViewController.m
//  Nyaya
//
//  Created by Alexander Maringele on 22.08.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "NyBtDetailViewController.h"
#import "NyayaConstants.h"
#import "TruthTable+HTML.h"
#import "UIColor+Nyaya.h"
#import "NyayaFormula.h"
#import "NyBoolToolEntry.h"

@interface NyBtDetailViewController () {
    dispatch_queue_t queue;
}
@end

@implementation NyBtDetailViewController

- (NSString*)localizedBarButtonItemTitle {
    return NSLocalizedString(@"BoolTool", @"BoolTool");
}

#pragma mark - additional ib actions

- (IBAction)send:(id)sender {
    [self compute: self.inputField.text];
    [self.inputField resignFirstResponder];
}

- (IBAction)didEndOnExit:(id)sender {
    [self compute:self.inputField.text];
    [self.inputField resignFirstResponder];
    
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
        self.inputName.text = ((NyBoolToolEntry*)self.detailItem).title;
        self.inputField.text = ((NyBoolToolEntry*)self.detailItem).input;
        self.inputField.delegate = self;
        
        self.navigationItem.title = [self.detailItem title];
        
        
        [self.inputField resignFirstResponder];
        [self resetOutputViews];
        [self compute:self.inputField.text];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.resultView.backgroundColor = nil;
    self.bddView.backgroundColor = nil;
    
    [self resetOutputViews];
    [self loadAccessoryView];
    [self.inputField becomeFirstResponder];
    
    queue = dispatch_queue_create("at.maringele.nyaya.booltool.queue", DISPATCH_QUEUE_SERIAL);
    
    // if (self.detailItem) [self configureView];
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
    [self setTruthTableView:nil];
    [super viewDidUnload];
}

- (void)resetOutputViews {
    
    
    self.stdField.text = @"";
    self.nnfField.text = @"";
    self.cnfField.text = @"";
    self.dnfField.text = @"";
    
    self.parsedField.text = @"";
    
    self.satisfiabilityLabel.backgroundColor = [UIColor nyLightGreyColor];
    self.tautologyLabel.backgroundColor = [UIColor nyLightGreyColor];
    self.contradictionLabel.backgroundColor = [UIColor nyLightGreyColor];
    self.parsedField.backgroundColor = [UIColor nyHalfBlue];
}

- (void)parse {
    NSString *input = self.inputField.text;
    dispatch_async(queue, ^{
        dispatch_queue_t mq = dispatch_get_main_queue();
        NyayaFormula *formula = [NyayaFormula formulaWithString:input];
        NSString *description = [formula.description stringByReplacingOccurrencesOfString:@"(null)" withString:@"…"];
        
        dispatch_async(mq, ^{
            self.parsedField.text = description;
            self.parsedField.backgroundColor = formula.isWellFormed ? [UIColor nyRightColor] : [UIColor nyWrongColor];
            [self adjustResultViewPosition];
        });
    });
}

- (void)compute:(NSString*)input {
    @autoreleasepool {
        self.bddView.bddNode = nil;
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"CALC_DRAW_TITLE",nil)
                                                        message:NSLocalizedString(@"CALC_DRAW_MESSAGE", nil)
                                                       delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
        UIActivityIndicatorView *progress= [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(125, 50, 30, 30)];
        progress.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
        [alert addSubview:progress];
        [progress startAnimating];
        
        [alert show];
        
        dispatch_async(queue, ^{
            dispatch_queue_t mq = dispatch_get_main_queue();
            
            NyayaFormula *formula = [NyayaFormula formulaWithString:input];
            NSString *description = [formula.description stringByReplacingOccurrencesOfString:@"(null)" withString:@"…"];
            
            dispatch_async(mq, ^{
                self.parsedField.text = description;
                self.parsedField.backgroundColor = formula.isWellFormed ? [UIColor nyRightColor] : [UIColor nyWrongColor];
                self.resultView.hidden = !formula.isWellFormed;
                [self adjustResultViewPosition];
            });
            
            if (formula.isWellFormed) {
                dispatch_async(mq, ^{
                    [self.inputSaver save:self.inputName.text input:self.parsedField.text]; // must be the main thread
                    self.navigationItem.title = self.inputName.text;
                });
                
                BddNode *bdd = [formula OBDD:NO];
                NSUInteger bddLevelCount = [bdd height];
                NSString *truthTableHtml = [[formula truthTable:YES] htmlDescription];
                NSUInteger varCount = [[[formula truthTable:YES] variables] count];
                
                // NSString *stdDescription = @""; // [node.reducedFormula description];
                // NSString *imfDescription = node.imfDescription;
                NSString *nnfDescription = formula.nnfDescription;
                NSString *cnfDescription = formula.cnfDescription;
                NSString *dnfDescription = formula.dnfDescription;
                
                
                BOOL tau = [formula truthTable:YES].isTautology;
                BOOL con = [formula truthTable:YES].isContradiction;
                BOOL sat = !con;
                
                dispatch_async(mq, ^{
                    self.satisfiabilityLabel.backgroundColor = sat ? [UIColor nyRightColor] : [UIColor nyWrongColor];
                    self.tautologyLabel.backgroundColor = tau ? [UIColor nyRightColor] : nil;
                    self.contradictionLabel.backgroundColor = con ? [UIColor nyWrongColor] : nil;
                    
                    self.satisfiabilityLabel.textColor = sat ? [UIColor blackColor] : [UIColor whiteColor];
                    self.tautologyLabel.textColor = tau ? [UIColor blackColor] : [UIColor whiteColor];
                    self.contradictionLabel.textColor = con ? [UIColor blackColor] : [UIColor whiteColor];
                    
                    self.nnfField.text = nnfDescription;
                    self.cnfField.text = cnfDescription;
                    self.dnfField.text = dnfDescription;
                    
                    [self adjustResultViewContent:bddLevelCount variableCount:varCount];
                    
                    self.bddView.bddNode = bdd;
                    self.bddView.title = description;
                    self.bddView.subtitle = @"Reduced Ordered Binary Decision Diagram";
                    NSURL *url = [[NSBundle mainBundle] URLForResource:@"welcome" withExtension:@"html"];
                    
                    [self.truthTableView loadHTMLString:truthTableHtml baseURL:[url baseURL]];
                });
                
                [formula optimizeDescriptions];
                dispatch_async(mq, ^{
                    self.nnfField.text = formula.nnfDescription;
                    self.cnfField.text = formula.cnfDescription;
                    self.dnfField.text = formula.dnfDescription;
                    
                    // [self adjustResultViewContent:bddLevelCount];
                });
                
                
            }
            
            dispatch_async(mq, ^{
                [progress stopAnimating];
                [alert dismissWithClickedButtonIndex:0 animated:NO];
                // [self.resultView scrollRectToVisible:CGRectMake(0.0,0.0,10.0,10.0) animated:NO];
                // [self.resultView scrollRectToVisible:self.dnfField.frame animated:YES];
                [self.bddView setNeedsDisplay];
            });
        });
    }
    
}

- (IBAction)process:(UIButton *)sender {
    [self compute:self.inputField.text];
    [self.inputField resignFirstResponder];
}

- (CGSize)textViewSize:(UITextView*)textView {
    CGFloat height = textView.contentSize.height-16;
    if (height > 105.0) {
        textView.scrollEnabled = YES;
        height = 105.0;
        
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

- (void)centerView:(UIView*)view verticallyTo:(CGRect)r {
    CGRect f = view.frame;
    CGFloat yoffset = (r.size.height - f.size.height)/2.0;
    view.frame = CGRectMake(f.origin.x, r.origin.y + yoffset, f.size.width, f.size.height);
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

- (void)adjustResultViewContent:(NSUInteger)bddLevelCount variableCount:(NSUInteger)varCount {
    CGFloat yoffset = 0.0;
    
    
    for (UITextView *textView in @[_stdField, _nnfField, _cnfField, _dnfField]) {
        CGSize size = [self textViewSize: textView];
        yoffset += [self resizeView: textView toSize:size yOffset:yoffset];
    }
    
    [self centerView:self.stdLabel verticallyTo:self.stdField.frame];
    [self centerView:self.nnfLabel verticallyTo:self.nnfField.frame];
    [self centerView:self.cnfLabel verticallyTo:self.cnfField.frame];
    [self centerView:self.dnfLabel verticallyTo:self.dnfField.frame];
    
    NSUInteger visibleLines = MIN(1 << varCount,TRUTH_TABLE_MAX_VISIBLE_ROWS) + 1;
    CGFloat htmlHeight = 40+visibleLines*25;
    CGFloat bddHeight = 70 * bddLevelCount;
    
    CGRect f = self.bddView.frame;
    f = CGRectMake(f.origin.x, f.origin.y + yoffset, f.size.width, MAX(htmlHeight, bddHeight));
    self.bddView.frame = f;
    self.truthTableView.frame = f;    
    // self.truthTableView.frame = CGRectMake(CGRectGetMinX(f), CGRectGetMaxY(f)+10, CGRectGetWidth(f), );
    self.truthTableView.frame = self.bddView.frame;
    // [self moveView:self.bddView toY: self.bddView.frame.origin.y + yoffset];
    
    
    // self.resultView.contentSize = CGSizeMake(CGRectGetMaxX(self.truthTableView.frame), CGRectGetMaxY(self.truthTableView.frame));
    self.resultView.contentSize = CGSizeMake(CGRectGetMaxX(f), CGRectGetMaxY(f));
    
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [self.bddView setNeedsDisplay];
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    self.inputName.text = @"";
    return YES;
}
@end
