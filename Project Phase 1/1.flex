%option noyywrap

%{

#include <sstream>
#include <iostream>
#include <stdlib.h>
#include <string>
using namespace std;

int lineCount = 1;
int spaceCount = 1;
int sourceLineCount = 1;

int charLength = 0;

string fileName;

%}

KEYWORD double|int|break|else|switch|case|char|return|float|continue|for|void|if

IDENTIFIER [_a-zA-Z][_a-zA-Z0-9]*

OPERATOR [.][.][.]|[<>][<>][=]|[-][-]|[+][+]|[|][|]|[#][#]|[&][&]|[+\-*\/<>=!%^|&][=]|[<][<]|[->][>]|[<>&=+\/\-*(){}\[\]\.,%~!?:|^;]

FRACTIONALCONSTANT (([0-9]*\.[0-9]+)|([0-9]+\.))
EXPONENTPART ([eE][+-]?[0-9]+)

FLOATINGSUFFIX ([flFL])
INTEGERSUFFIX ([uU][lL]|[lL][uU]|[uUlL])

DECIMALCONSTANT ([1-9][0-9]*)
OCTALCONSTANT ([0][0-7]*)
HEXCONSTANT ([0][xX][0-9A-Fa-f]+)

CHARCONSTANT ('(([\\]['])|([^']))+')

STRINGLITERAL ["](([\\]["])|([^"]))*["]

WHITESPACE [ ]+

PREPROC [#][ ][0-9]+[ ]{STRINGLITERAL}[ 0-9]*

ALL .

%%

{KEYWORD} {
    yylval = new string(yytext);
    cout<<yylval<<endl;
    return Keyword;
}

{IDENTIFIER}{1,32} {
    yylval = new string(yytext);
    cout<<yylval<<endl;
    return Identifier;
}

{OPERATOR} {
    yylval = new string(yytext);
    cout<<yylval<<endl;
    return Operator;
}

{FRACTIONALCONSTANT}{EXPONENTPART}?{FLOATINGSUFFIX}? {
    yylval = new string(yytext);
    cout<<yylval<<endl;
    return Constant;
}

([0-9]+){EXPONENTPART}{FLOATINGSUFFIX}? {
    yylval = new string(yytext);
    cout<<yylval<<endl;
    return Constant;
}

{HEXCONSTANT}{INTEGERSUFFIX}? {
    yylval = new string(yytext);
    cout<<yylval<<endl;
    return Constant;
}

{DECIMALCONSTANT}{INTEGERSUFFIX}? {
    yylval = new string(yytext);
    cout<<yylval<<endl;
    return Constant;
}

{OCTALCONSTANT}{INTEGERSUFFIX}? {
    yylval = new string(yytext);
    cout<<yylval<<endl;
    return Constant;
}

{CHARCONSTANT} {
    string tmp(yytext);
    yylval = new string(tmp.substr(1, tmp.length()-2));
    cout<<yylval<<endl;
    return Constant;
}

{STRINGLITERAL} {
    string tmp(yytext);
    yylval = new string(tmp.substr(1, tmp.length()-2));
    cout<<yylval<<endl;
    return StringLiteral;
}


{WHITESPACE} {
    spaceCount++;
    cout<<yylval<<endl;
}

{PREPROC} {
    int srcLineInt;

    yylval = new string(yytext);
    stringstream preProcLine((*yylval).substr(1, (*yylval).length()));
    preProcLine >> srcLineInt >> fileName;
    sourceLineCount = srcLineInt - 1;
    fileName = fileName.substr(1, fileName.length() - 2);
}


{ALL} {
    yylval = new string(yytext);
    charLength = (int)yyleng;
    return Invalid;
}

%%