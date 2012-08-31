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

@interface NyBtDetailViewController () <NyAccessoryController> {
     dispatch_queue_t queue;
}
@end

@implementation NyBtDetailViewController
@synthesize inputField;
@synthesize parsedFormulalLabel;
@synthesize parsedLabel;
@synthesize parsedField;
@synthesize propertyView;
@synthesize satisfiabilityLabel;
@synthesize tautologyLabel;
@synthesize contradictionLabel;
@synthesize normalFormView;
@synthesize nnfLabel;
@synthesize nnfField;
@synthesize cnfLabel;
@synthesize cnfField;
@synthesize dnfLabel;
@synthesize dnfField;

@synthesize accessoryView, notButton, andButton, orButton, xorButton, impButton, bicButton, lparButton, rparButton, parButton, nparButton;

- (NSString*)localizedBarButtonItemTitle {
    return NSLocalizedString(@"BoolTool", @"BoolTool");
}

- (void)configureView
{
    [super configureView];
    // Update the user interface for the detail item.
    
    if (self.detailItem) {
        [self.inputField becomeFirstResponder];        
    }
}

- (IBAction)press:(UIButton *)sender {
    [self.inputField insertText:sender.currentTitle];
}

- (IBAction)parenthesize:(UIButton *)sender {
    if ([self.inputField hasText]) {
        self.inputField.text = [NSString stringWithFormat:@"(%@)", self.inputField.text];
    }
}

- (IBAction)negate:(UIButton *)sender {
    if ([self.inputField hasText]) {
        self.inputField.text = [NSString stringWithFormat:@"¬(%@)", self.inputField.text];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self resetOutputViews];
    
    if (!self.inputAccessoryView) {
        [[NSBundle mainBundle] loadNibNamed:@"NyAccessoryView" owner:self options:nil];
        self.inputField.inputAccessoryView = self.accessoryView;
        
        self.accessoryView = nil;
        
    }
    queue = dispatch_queue_create("at.maringele.nyaya.booltool.queue", NULL);
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
    [self setPropertyView:nil];
    [self setNormalFormView:nil];
    [super viewDidUnload];
}

- (void)resetOutputViews {
    self.normalFormView.hidden = YES;
    
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

- (IBAction)send:(id)sender {
    [self didEndOnExit:sender];
    // [self.inputField resignFirstResponder];
}

- (IBAction)didEndOnExit:(id)sender {
    self.normalFormView.hidden = NO;
    [self compute];
}

- (IBAction)editingChanged:(id)sender {
    [self parse];
}

- (IBAction)editingDidBegin:(id)sender {
    [self resetOutputViews];
}



- (void)parse {
    NyayaParser *parser = [[NyayaParser alloc] initWithString:self.inputField.text];
    dispatch_async(queue, ^{
        dispatch_queue_t mq = dispatch_get_main_queue();
        
        NyayaNode *a = [parser parseFormula];
        dispatch_async(mq, ^{
            self.parsedField.text = [[a description] stringByReplacingOccurrencesOfString:@"(null)" withString:@"…"];
            self.parsedLabel.backgroundColor = parser.hasErrors ? [UIColor nyWrongColor] : [UIColor nyRightColor];            
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
                self.parsedLabel.backgroundColor = hasErrors ? [UIColor nyWrongColor] : [UIColor nyRightColor];
            });
            
            if (!hasErrors) {
                TruthTable *truthTable = [[TruthTable alloc] initWithFormula:node];
                [truthTable evaluateTable];
                
                BOOL sat = truthTable.isSatisfiable;
                BOOL tau = truthTable.isTautology;
                BOOL con = truthTable.isContradiction;
                
                dispatch_async(mq, ^{
                    self.satisfiabilityLabel.backgroundColor = sat ? [UIColor nyRightColor] : [UIColor nyWrongColor];
                    self.tautologyLabel.backgroundColor = tau ? [UIColor nyRightColor] : [UIColor nyLightGreyColor];
                    self.contradictionLabel.backgroundColor = con ? [UIColor nyWrongColor] : [UIColor nyLightGreyColor];
                });
                
                
                NyayaNode *imfnode = [node imf];
                
                NyayaNode *nnfnode = [imfnode nnf];
                NSString *nnfdescription=[nnfnode description];
                dispatch_async(mq, ^{
                    self.nnfField.text = nnfdescription;
                });
                
                
                
                NyayaNode *cnfnode = [nnfnode cnf];
                NSString *cnfdescription=[cnfnode description];
                dispatch_async(mq, ^{
                    self.cnfField.text = cnfdescription;
                });
                
                
                NyayaNode *dnfnode = [nnfnode dnf];
                NSString *dnfdescription=[dnfnode description];
                dispatch_async(mq, ^{
                    self.dnfField.text = dnfdescription;
                });
            }
            
        });
    }
}
@end
