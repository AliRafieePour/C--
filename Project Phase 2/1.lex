%option noyywrap

%{

#include <sstream>
#include <iostream>
#include <stdlib.h>
#include <string>
#include <typeinfo>
#include <math.h>
#include <vector>
#include "myapp.hpp"

using namespace std;

vector<string> errors;
int lineCount = 1;
int someNum = 1;
int sourceLineCount = 1;

int charLength = 0;

string fileName;
%}

start \/\*
end  \*\/

KEYWORD double|int|break|else|switch|case|char|return|float|continue|for|void|if|main|string

IDENTIFIER [_a-zA-Z][_a-zA-Z0-9]*
ERROR_IN_IDENTIFIER [0-9]+[_a-zA-Z][_a-zA-Z0-9]*

CHAR ['][a-zA-Z0-9][']

STRING ["][a-zA-Z0-9]*["]

OPERATOR [.][.][.]|[<>][<>][=]|[-][-]|[+][+]|[|][|]|[#][#]|[&][&]|[+\-*\/<>=!%^|&][=]|[<][<]|[->][>]|[<>&=+\/\-*(){}\[\]\.,%~!?:|^;]|[.][.]

FRACTIONALCONSTANT (([0-9]+\.[0-9]+))

EXPONENTPART ([eE][+-]?[0-9]+)

FLOATINGSUFFIX ([flFL])
INTEGERSUFFIX ([uU][lL]|[lL][uU]|[uUlL])

DECIMALCONSTANT ([1-9][0-9]*)|[0]
OCTALCONSTANT ([0][0-7]*)
HEXCONSTANT ([0][xX][0-9A-Fa-f]+)

CHARCONSTANT ('(([\\]['])|([^']))+')

STRINGLITERAL ["](([\\]["])|([^"]))*["]

NEWLINE (\r\n?|\n)

TAB \t

WHITESPACE [ ]+

PREPROC [#][ ][0-9]+[ ]{STRINGLITERAL}[ 0-9]*

ALL .


%%

\/\/(.*) {
  //  return TOKEN_COMMENT;
}
{start}.*{end} {
   // return TOKEN_COMMENT;
}

{start}.* {
    string er = "Error @ line: " + to_string(lineCount) + " Unclosed comment section!";
    errors.push_back(er);
}

.*{end} {
    string er = "Error @ line: " + to_string(lineCount) + " Comment section not opened!";
    errors.push_back(er);
}

{FRACTIONALCONSTANT}{EXPONENTPART}?{FLOATINGSUFFIX}? {
    yylval.floatVal = stof(yytext);
    return TOKEN_FLOATCONST;
}

([0-9]+){EXPONENTPART}|([0-9]+){EXPONENTPART}([0-9]+) {
    yylval.floatVal = stof(yytext);
    return TOKEN_FLOATCONST;
}

{ERROR_IN_IDENTIFIER} {
    string er = "Error @ line: " + to_string(lineCount) + " Wrong ID definition!";
    errors.push_back(er);
}
{KEYWORD} {


    if ((string)yytext == "if") {
        return TOKEN_IFCONDITION;
    }
    if ((string)yytext == "void") {
        return TOKEN_VOIDTYPE;
    }
    if ((string)yytext == "int") {
        return TOKEN_INTTYPE;
    }
    if ((string)yytext == "foreach") {
        return TOKEN_LOOP;
    }
    if ((string)yytext == "return") {
        return TOKEN_RETURN;
    }
    if ((string)yytext == "double") {
        return TOKEN_DOUBLETYPE;
    }
    if ((string)yytext == "float") {
        return TOKEN_FLOATTYPE;
    }
    if ((string)yytext == "char") {
        return TOKEN_CHARTYPE;
    }
    if ((string)yytext == "string") {
        return TOKEN_STRINGTYPE;
    }
    if ((string)yytext == "main") {
        return TOKEN_MAINFUNC;
    }
    if ((string)yytext == "print") {
        return TOKEN_PRINT;
    }
    if ((string)yytext == "break") {
        return TOKEN_BREAKSTMT;
    }
    if ((string)yytext == "continue") {
        return TOKEN_CONTINUESTMT;
    }
    if ((string)yytext == "else") {
        return TOKEN_ELSESTMT;
    }
}

{IDENTIFIER}{1,32} {
    yylval.string = yytext;
    return TOKEN_ID;
}

{CHAR} {
    yylval.charVal = yytext[0];
     return TOKEN_CHARCONST;
}

{STRING} {
    yylval.string = yytext;
     return TOKEN_STRINGCONST;
}

{OPERATOR} {
    if ((string)yytext == "+") {
         return TOKEN_PLUS;
    }

    if ((string)yytext == "-") {
        return TOKEN_MINUS;
    }
    if ((string)yytext == "*") {
        return TOKEN_STAR;
    }
    if ((string)yytext == "/") {
        return TOKEN_DIVIDE;
    }
    if ((string)yytext == "^") {
        return TOKEN_TAVAN;
    }

    if ((string)yytext == "&&") {
         return TOKEN_AND;
    }
    if ((string)yytext == "||") {
        return TOKEN_OR;
    }
    if ((string)yytext == "!") {
        return TOKEN_NOT;
    }
    if ((string)yytext == "&" || (string)yytext == "|") {
         return TOKEN_BITWISEOP;
    }
    if ((string)yytext == "==" || (string)yytext == "!=" || (string)yytext == ">=" || (string)yytext == "<=" || (string)yytext == "<" || (string)yytext == ">") {
         return TOKEN_RELATIONOP;
    }
    if ((string)yytext == "=") {
        return TOKEN_ASSIGNOP;
    }

    if ((string)yytext == "(") {
         return TOKEN_LEFTPAREN;
    }
    if ((string)yytext == ")") {
         return TOKEN_RIGHTPAREN;
    }
    if ((string)yytext == "{") {
         return TOKEN_LCB;
    }
    if ((string)yytext == "}") {
         return TOKEN_RCB;
    }
    if ((string)yytext == ";") {
         return TOKEN_SEMICOLON;
    }
    if ((string)yytext == ",") {
         return TOKEN_COMMA;
    }
    if ((string)yytext == "[") {
         return TOKEN_LB;
    }
    if ((string)yytext == "]") {
         return TOKEN_RB;
    }
    if ((string)yytext == "..") {
         return TOKEN_UNTIL;
    }
}



{DECIMALCONSTANT}{INTEGERSUFFIX}? {
    try {
        yylval.intVal = stoi(yytext);
         return TOKEN_INTCONST;
    } catch(...) {
        string er = "Error @ line: " + to_string(lineCount) + " integer out of range!";
        errors.push_back(er);
    }
    
}

{WHITESPACE} {
  //   return TOKEN_WHITESPACE;
}


{NEWLINE} {
 //    return TOKEN_WHITESPACE;
    ++lineCount;
}

{TAB} {
  //   return TOKEN_WHITESPACE ;
}

{ALL} {
    
    string er = "ERROR @ line: "+ to_string(lineCount) + " The wording of tokens in the line does not much any pattern.";
    errors.push_back(er);
}

%%

