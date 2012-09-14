//
//  TruthTable+HTML.m
//  Nyaya
//
//  Created by Alexander Maringele on 14.09.12.
//  Copyright (c) 2012 private. All rights reserved.
//

#import "TruthTable+HTML.h"
#import "NyayaNode_Cluster.h"
#import "NyayaConstants.h"

@implementation TruthTable (HTML)

- (NSString*)htmlDescription {
    
    NSString *template = @"<!DOCTYPE HTML PUBLIC '-//W3C//DTD HTML 4.01 Transitional//EN'>"
    "<html><head><meta http-equiv='content-type' content='text/html; charset=UTF-8'>"
    "<title>Nyāya :: TruthTable</title>"
    // "<link rel=\"stylesheet\" type=\"text/css\" href=\"format.css\"></head>"
    "    <style type='text/css'>"
    "    body {"
    "    margin-left:20px; margin-right:70px; margin-top:20px; margin-bottom:10px;"
    //"    background-image:url(syntaxtree.png), -webkit-linear-gradient(top left, #F9F9F9 25%, #F9F9F9 75%);"
    "    background-image:-webkit-linear-gradient(top left, #F9F9F9 25%, #F9F9F9 75%);"
    "}"
    "h1,h2,h3,h4,p,ul,ol,li,div,td,th,address,blockquote,nobr,b,i {"
    "    font-family:Arial,Helvetica,sans-serif; color:#555555;"
    "}"
    "table { border:solid 1px #555555; border-collapse:collapse; float:left; margin-right:20px}"
    "tr, th, td { border:solid 1px #AAAAAA; text-align:center; padding:2px 3px 2px 3px;}"
    "td.green { background-color:#DDFFDD; }"
    "td.red { background-color:#FFDDDD; }"
    "    </style> "
    "<body> "
    "<table>%@</table> </body></html> %@";
    
    NSMutableString *description = [NSMutableString stringWithString:@"<tr>"];
    
    for (NyayaNode *variable in self.variables) {
        [description appendFormat:@"<th>%@</th>", variable.symbol];
    }
    [description appendString:@"</th><th></th><th>Φ</th></tr>"];
    
    NSUInteger count = self.rowsCount >> 1;
    
    NSUInteger rowCount = 0;
    BOOL lastVal = ![self evalAtRow:0];    // allways print the first line
    NSString *tdT = nil;
    NSString *tdF = nil;
    BOOL compact = TRUTH_TABLE_MAX_FULL_ROWS <  self.rowsCount;
    BOOL spare = TRUTH_TABLE_MAX_ROWS <  self.rowsCount;
    BOOL firstSpare = YES;
    
    if (compact) {
        tdT = @"<td class=\"green\"></td>";
        tdF = @"<td class=\"red\"></td>";
    }
    else {
        tdT = @"<td class=\"green\">T</td>";
        tdF = @"<td class=\"red\">F</td>";
    }
    
    if (spare) {
        NSString *text = [NSString stringWithFormat:NSLocalizedString(TRUTH_TABLE_U_TRUE_OF_U_ROWS,nil), self.truthCount, self.rowsCount];
        [description appendFormat:@"<tr><td class='green' colspan='%u'>%@</td>", [self.variables count]+2, text];
        text = [NSString stringWithFormat:NSLocalizedString(TRUTH_TABLE_U_FALSE_OF_U_ROWS,nil), self.falseCount, self.rowsCount];
        [description appendFormat:@"<tr><td class='red' colspan='%u'>%@</td>", [self.variables count]+2, text];
        [description appendFormat:@"<tr><td colspan='%u'></td></tr>", [self.variables count]+2];
        
    }
    
    for (NSUInteger rowIndex = 0; rowIndex < self.rowsCount; rowIndex++) {
        [description appendString:@"<tr>"];
        
        
        
        
        BOOL eval = [self evalAtRow:rowIndex];
        
        if (TRUTH_TABLE_MAX_ROWS < rowCount) {
            rowIndex = self.rowsCount -1;   // allways print the last line
        }
        
        if (!spare || lastVal != eval || rowIndex == (self.rowsCount-1)) {
            firstSpare = YES;
            
            [self.variables enumerateObjectsUsingBlock:^(NyayaNodeVariable *variable, NSUInteger idx, BOOL *stop) {
                BOOL eval = (rowIndex & (count >> idx)) > 0 ? TRUE : FALSE;
                
                /*  idx     0   1
                 0  0000 & 01  10
                 1  0001 & 01  10
                 
                 2  0010 & 01  10
                 3  0011 & 01  10 */
                
                if (eval) [description appendString: tdT];
                else [description appendString:tdF];
                
            }];
            [description appendString:@"<td></td>"];
            
            
            if (eval) [description appendString: tdT];
            else [description appendString:tdF];
            
            rowCount++;
        }
        else if (firstSpare) {
            firstSpare = NO;
            [description appendFormat:@"<td colspan='%u'></td><td></td>", [self.variables count]];
            if (eval) [description appendString: tdT];
            else [description appendString:tdF];
            rowCount++;
        }
        
        lastVal = eval;
        
        [description appendString:@"</tr>"];
    }
    
    
    return [NSString stringWithFormat:template, description, @""];
}

@end
