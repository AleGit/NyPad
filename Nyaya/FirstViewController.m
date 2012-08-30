//
//  FirstViewController.m
//  Nyaya
//
//  Created by Alexander Maringele on 16.07.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "FirstViewController.h"
#import "NyayaParser.h"
#import "NyayaNode.h"

@interface FirstViewController () {
    dispatch_queue_t queue;
}

@end

@implementation FirstViewController
@synthesize accessoryView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    // self.input.inputView = [[UIButton alloc] init];
    /*self.input.inputAccessoryView = [[UIButton alloc] init];
    
    CGRect accessFrame = CGRectMake(0.0, 0.0, 768.0, 77.0);
    UIView *inputAccessoryView = [[UIView alloc] initWithFrame:accessFrame];
    inputAccessoryView.backgroundColor = [UIColor blueColor];
    UIButton *compButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    compButton.frame = CGRectMake(313.0, 20.0, 158.0, 37.0);
    [compButton setTitle: @"Word Completions" forState:UIControlStateNormal];
    [compButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [compButton addTarget:self action:@selector(completeCurrentWord:)
         forControlEvents:UIControlEventTouchUpInside];
    [inputAccessoryView addSubview:compButton];*/
    
    // self.input.inputView = self.myInputView;
    if (!self.inputAccessoryView) {
        [[NSBundle mainBundle] loadNibNamed:@"NyAccessoryView" owner:self options:nil];
        self.input.inputAccessoryView = self.accessoryView;
        
        self.accessoryView = nil;
        
    }
    
    
    
    
    [self.input addTarget:self action:@selector(compute:) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.input becomeFirstResponder];
    
    // self.input.inputView = self.myInputView;
    
    
    queue = dispatch_queue_create("at.maringele.nyaya.queue", NULL);
}


- (void)viewDidUnload
{
    [self setInput:nil];
    [self setAst:nil];
    [self setImf:nil];
    [self setNnf:nil];
    [self setCnf:nil];
    [self setDnf:nil];
    [self setSubformulas:nil];
    [self setErrors:nil];
    [self setAccessoryView:nil];
    [super viewDidUnload];
    
    dispatch_release(queue);
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (IBAction)compute:(id)sender {
    if (![self.input hasText]) {
        // show alert
    }
    else {
        NyayaParser *parser = [[NyayaParser alloc] initWithString:self.input.text];
        dispatch_async(queue, ^{
            dispatch_queue_t mq = dispatch_get_main_queue();
            
            NyayaNode *node = [parser parseFormula];
            NSString *description = [node description];       
            
            dispatch_async(mq, ^{
                self.ast.text = description;
                if ([parser hasErrors]) self.errors.text = [parser errorDescriptions];
            });
            
            if (![parser hasErrors]) {
                NSString *s = [[[node setOfSubformulas] allObjects] componentsJoinedByString:@"; "];
                
                NyayaNode *imfnode = [node imf];
                NSString *imfdescription=[imfnode description];
                dispatch_async(mq, ^{
                    self.errors.text = @"";
                    self.imf.text = imfdescription;
                });
                
                
                NyayaNode *nnfnode = [imfnode nnf];
                NSString *nnfdescription=[nnfnode description];
                dispatch_async(mq, ^{
                    self.nnf.text = nnfdescription;
                });
                
                
                NyayaNode *cnfnode = [nnfnode cnf];
                NSString *cnfdescription=[cnfnode description];
                dispatch_async(mq, ^{
                    self.cnf.text = cnfdescription;
                });
                
                
                NyayaNode *dnfnode = [nnfnode dnf];
                NSString *dnfdescription=[dnfnode description];
                dispatch_async(mq, ^{
                    self.dnf.text = dnfdescription;
                });
                
                dispatch_async(mq, ^{
                    self.subformulas.text = s;
                });
            }
            
        });
        
        
        
        
       
        
        
        
        [self.input resignFirstResponder];
    }
    
}

- (void)parse {
    
    NyayaParser *parser = [[NyayaParser alloc] initWithString:self.input.text];
    dispatch_async(queue, ^{
        dispatch_queue_t mq = dispatch_get_main_queue();
        
        NyayaNode *a = [parser parseFormula];
        dispatch_async(mq, ^{
            self.ast.text = [a description];
            self.errors.text = @"  ";
        });
        
        
        
    });
}

- (IBAction)press:(UIButton *)sender {
    [self.input insertText:sender.currentTitle];
    if ([self.input hasText]) [self parse];
}

- (IBAction)delete:(UIButton *)sender {
    [self.input deleteBackward];
    if ([self.input hasText]) [self parse];
}

- (IBAction)parenthesize:(UIButton *)sender {
    if ([self.input hasText]) {
       self.input.text = [NSString stringWithFormat:@"(%@)", self.input.text]; 
    [self parse];
    }
    
}

- (IBAction)negate:(UIButton *)sender {
    if ([self.input hasText]) {
        self.input.text = [NSString stringWithFormat:@"¬(%@)", self.input.text]; 
        [self parse];
    }
}
@end
