%{
    #include <iostream>
    #include <string>
    #include <vector>
    using namespace std;
    int yyerror(const char* m);   
    extern int yylex();
    extern FILE* yyin;
    extern vector<string> errors;
    extern int lineCount;
    extern int someNum;
    extern int sourceLineCount;
    extern int charLength;
    int numArg = 0;
%}





%union {
    int intVal;
    float floatVal;
    double doubleVal;
    char charVal;
    char* string;
}


%token <floatVal> TOKEN_FLOATCONST
%token <intVal> TOKEN_INTCONST
%token <doubleVal> TOKEN_DOUBLECONST
%token <charVal> TOKEN_CHARCONST
%token <string> TOKEN_ID TOKEN_STRINGCONST
%token TOKEN_PLUS TOKEN_MINUS TOKEN_STAR TOKEN_DIVIDE TOKEN_TAVAN TOKEN_AND TOKEN_OR TOKEN_NOT TOKEN_COMPARE_EQU TOKEN_COMPARE_NEQU TOKEN_COMPARE_BEQU TOKEN_COMPARE_LEQU TOKEN_COMPARE_LESS TOKEN_COMPARE_BIGG
%token TOKEN_IFCONDITION TOKEN_LOOP TOKEN_CONTINUESTMT TOKEN_ELSESTMT TOKEN_BREAKSTMT TOKEN_LEFTPAREN TOKEN_RIGHTPAREN TOKEN_LCB TOKEN_RCB TOKEN_SEMICOLON TOKEN_COMMA TOKEN_LB TOKEN_RB TOKEN_UNTIL TOKEN_RETURN TOKEN_ASSIGNOP
%token TOKEN_INTTYPE TOKEN_DOUBLETYPE TOKEN_VOIDTYPE TOKEN_FLOATTYPE TOKEN_CHARTYPE TOKEN_STRINGTYPE TOKEN_MAINFUNC TOKEN_ARITHMATICOP TOKEN_LOGICOP TOKEN_BITWISEOP TOKEN_RELATIONOP TOKEN_PRINT

%right TOKEN_TAVAN
%left TOKEN_COMPARE_EQU
%left TOKEN_LEFTPAREN TOKEN_RIGHTPAREN TOKEN_LB TOKEN_RB
%right TOKEN_NOT
%right TOKEN_PLUSPLUS 
%left TOKEN_STAR TOKEN_DIVIDE
%left TOKEN_PLUS TOKEN_MINUS
%left TOKEN_RELATIONOP
//%left EQUOP
%left TOKEN_OR
%left TOKEN_AND 
%right TOKEN_ASSIGNOP
%left TOKEN_COMMA

%start program

%%
program:            statements main_func
statements:         statements statement | statement
statement:          func_statement | definition
definition:         type names TOKEN_SEMICOLON
type:               TOKEN_INTTYPE | TOKEN_CHARTYPE | TOKEN_FLOATTYPE | TOKEN_DOUBLETYPE | TOKEN_VOIDTYPE
names:              assign_exp | names TOKEN_COMMA assign_exp
assign_exp:         TOKEN_ID TOKEN_ASSIGNOP constant
main_func:          type TOKEN_MAINFUNC TOKEN_LEFTPAREN argument_shape TOKEN_RIGHTPAREN tail


tail:               TOKEN_LCB statements2 TOKEN_RCB
statements2:        statements2 statement2 | statement2
statement2:         if_statement | for_statement | func_call | var_definition | TOKEN_CONTINUESTMT | TOKEN_RETURN | TOKEN_BREAKSTMT | assignment | print

func_call:          TOKEN_ID TOKEN_LEFTPAREN func_input { numArg = 0; }TOKEN_RIGHTPAREN TOKEN_SEMICOLON

func_input:         TOKEN_ID
                    {
                        numArg++;
                        if (numArg >= 4) {
                            printf("At line %d, number of the function arguments is exceeding the maximum of 4.\n", ;lineCount);
                        }
                    } |
                    constant
                    {
                        numArg++;
                        if (numArg >= 4) {
                            printf("At line %d, number of the function arguments is exceeding the maximum of 4.\n", ;lineCount);
                        }
                    } |
                    TOKEN_ID 
                    {                        
                        numArg++;
                        if (numArg >= 4) {
                            printf("At line %d, number of the function arguments is exceeding the maximum of 4.\n", ;lineCount);
                                        }
                    } TOKEN_COMMA func_input | 
                    constant {                        
                        numArg++;
                        if (numArg >= 4) {
                            printf("At line %d, number of the function arguments is exceeding the maximum of 4.\n", ;lineCount);
                                        }
                    } TOKEN_COMMA func_input

expression:         expression TOKEN_PLUS expression | expression TOKEN_STAR expression | expression TOKEN_MINUS expression | expression TOKEN_PLUSPLUS// | expression TOKEN_MINUSMINUS
                    | TOKEN_PLUSPLUS expression | expression TOKEN_AND expression | expression TOKEN_OR expression | TOKEN_NOT expression | expression TOKEN_COMPARE_EQU expression
                    //| expression TOKEN_COMPARE_NEQU expression | expression TOKEN_COMPARE_BEQU expression | expression TOKEN_COMPARE_LEQU expression | expression TOKEN_COMPARE_LESS expression | expression TOKEN_COMPARE_BIGG expression
                    | expression TOKEN_RELATIONOP expression | TOKEN_LEFTPAREN expression TOKEN_RIGHTPAREN | expression TOKEN_TAVAN expression | constant | func_call
constant:           TOKEN_INTCONST | TOKEN_FLOATCONST | TOKEN_CHARCONST | TOKEN_DOUBLECONST
print:              TOKEN_PRINT TOKEN_LEFTPAREN expression TOKEN_RIGHTPAREN TOKEN_SEMICOLON
var_definition:     type names2 TOKEN_SEMICOLON | declare_arrays
declare_arrays:     type array_declarance TOKEN_SEMICOLON
names2:             variable init | names2 TOKEN_COMMA variable init
init:               TOKEN_ASSIGNOP init_value | /* empty */ 
init_value:         constant/* | array_init*/
variable:           TOKEN_ID | TOKEN_ID TOKEN_LB expression TOKEN_RB /* | pointer TOKEN_ID  | TOKEN_ID array */
//pointer:            pointer '*' | '*'
//array:              array TOKEN_LB expression TOKEN_RB | TOKEN_LB expression TOKEN_RB | TOKEN_LB TOKEN_INTCONST TOKEN_RB
array_declarance:   array_declarance TOKEN_LB TOKEN_INTCONST TOKEN_RB | TOKEN_LB TOKEN_INTCONST TOKEN_RB
//array_init:         TOKEN_LB values TOKEN_RB
//values:             values TOKEN_COMMA constant | constant
if_statement:       TOKEN_IFCONDITION TOKEN_LEFTPAREN expression TOKEN_RIGHTPAREN tail else_if optional_else
                    | TOKEN_IFCONDITION TOKEN_LEFTPAREN expression TOKEN_RIGHTPAREN tail optional_else
else_if:            else_if TOKEN_ELSESTMT TOKEN_IFCONDITION TOKEN_LEFTPAREN expression TOKEN_RIGHTPAREN tail
	                | TOKEN_ELSESTMT TOKEN_IFCONDITION TOKEN_LEFTPAREN expression TOKEN_RIGHTPAREN tail
optional_else:      TOKEN_ELSESTMT tail | /* empty */ 
assignment:         TOKEN_ID TOKEN_ASSIGNOP expression | TOKEN_ID TOKEN_LB expression TOKEN_RB TOKEN_ASSIGNOP expression
for_statement:      TOKEN_LOOP TOKEN_ID TOKEN_LEFTPAREN TOKEN_INTCONST TOKEN_UNTIL TOKEN_INTCONST TOKEN_RIGHTPAREN tail
func_statement:     type TOKEN_ID TOKEN_LEFTPAREN arguments TOKEN_RIGHTPAREN tail
arguments:          argument_shape { numArg = 0; }| arguments TOKEN_COMMA argument_shape { numArg = 0; }
argument_shape:     type TOKEN_ID TOKEN_ASSIGNOP constant { numArg++; }
                    | type TOKEN_ID 
                    { 
                        numArg++;
                        if (numArg >= 4) {
                            printf("At line %d, number of the function arguments is exceeding the maximum of 4.\n", ;lineCount);
                        }
                    }
                    | type TOKEN_ID TOKEN_LB TOKEN_RB
                    { 
                        numArg++;
                        if (numArg >= 4) {
                            printf("At line %d, number of the function arguments is exceeding the maximum of 4.\n", ;lineCount);
                        }
                    }


%%

int main(int argc, char* argv[]) {
    FILE* file = fopen("test.txt", "r");
    yyin = file;
    yyparse();
    return 0;
}

int yyerror(const char* m) {
    cout<<"Error"<<" "<<m<<endl;
    return 0;
}