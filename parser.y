%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

// External declarations
extern int yylex();
extern int yyparse();
extern FILE *yyin;

// Function prototypes
void yyerror(const char *s);

// Global variables
int temp_counter = 1;  // Counter for temporary variables
int result;            // Final computed result

// Function to generate intermediate code for operations
void print_temp_code(const char *op, int left_temp, int right_temp, int t, int left_val, int right_val) {
    printf("\n====================\n");
    printf("  Intermediate Code\n");
    printf("====================\n");
    printf("t%d = ", t);

    // Print the left operand
    if (left_temp > 0) {
        printf("t%d ", left_temp);
    } else {
        printf("%d ", left_val);
    }

    // Print the operator
    printf("%s ", op);

    // Print the right operand
    if (right_temp > 0) {
        printf("t%d;\n", right_temp);
    } else {
        printf("%d;\n", right_val);
    }
    printf("====================\n");
}

// Helper function to reverse a number
int reverse_number(int num) {
    int reversed = 0;
    while (num != 0) {
        reversed = reversed * 10 + num % 10;
        num /= 10;
    }
    return reversed;
}

// Check if a number is a multiple of 10
int is_multiple_of_10(int num) {
    return num % 10 == 0;
}
%}

%union {
    int num;          // Numeric values
    char *id;         // Identifiers
    struct {
        int value;    // Value of the expression
        int temp;     // Temporary variable index
    } attributes;
}

// Token declarations
%token <num> NUMBER
%token <id> IDENTIFIER
%token PLUS MINUS MULTIPLY DIVIDE ASSIGN LPAREN RPAREN SEMICOLON

// Non-terminal types
%type <attributes> statement expression term factor

// Operator precedence and associativity
%right ASSIGN
%left PLUS MINUS
%left MULTIPLY DIVIDE

%%

program:
    statements
    ;

statements:
    statements statement
    | /* Empty */
    ;

statement:
    IDENTIFIER ASSIGN expression SEMICOLON {
        printf("\n====================\n");
        printf("Assignment Operation\n");
        printf("====================\n");
        printf("%s = t%d;\n", $1, $3.temp ? $3.temp : $3.value);
        printf("====================\n");
        free($1);
        result = $3.value;
        printf("Result: %d\n", result);
        temp_counter = 1;  // Reset temporary variable counter
        printf("\n");
        printf("=================================\n");
        printf("Enter an expression:\n");
    }
    ;

expression:
    expression MULTIPLY term {
        int temp_value = $1.value * $3.value;
        $$ = is_multiple_of_10(temp_value)
             ? (typeof($$)){.value = temp_value, .temp = temp_counter++}
             : (typeof($$)){.value = reverse_number(temp_value), .temp = temp_counter++};
        print_temp_code("*", $1.temp, $3.temp, $$.temp, $1.value, $3.value);
    }
    | expression DIVIDE term {
        int temp_value = $1.value / $3.value;
        $$ = is_multiple_of_10(temp_value)
             ? (typeof($$)){.value = temp_value, .temp = temp_counter++}
             : (typeof($$)){.value = reverse_number(temp_value), .temp = temp_counter++};
        print_temp_code("/", $1.temp, $3.temp, $$.temp, $1.value, $3.value);
    }
    | term {
        $$ = $1;
    }
    ;

term:
    factor PLUS term {
        int temp_value = $1.value + $3.value;
        $$ = is_multiple_of_10(temp_value)
             ? (typeof($$)){.value = temp_value, .temp = temp_counter++}
             : (typeof($$)){.value = reverse_number(temp_value), .temp = temp_counter++};
        print_temp_code("+", $1.temp, $3.temp, $$.temp, $1.value, $3.value);
    }
    | factor MINUS term {
        int temp_value = $1.value - $3.value;
        $$ = is_multiple_of_10(temp_value)
             ? (typeof($$)){.value = temp_value, .temp = temp_counter++}
             : (typeof($$)){.value = reverse_number(temp_value), .temp = temp_counter++};
        print_temp_code("-", $1.temp, $3.temp, $$.temp, $1.value, $3.value);
    }
    | factor {
        $$ = $1;
    }
    ;

factor:
    NUMBER {
        $$ = is_multiple_of_10($1)
             ? (typeof($$)){.value = $1, .temp = 0}
             : (typeof($$)){.value = reverse_number($1), .temp = 0};
    }
    | LPAREN expression RPAREN {
        $$ = $2;  // Pass expression result
    }
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

int main() {
    printf("\nWelcome to the Expression Parser\n");
    printf("=================================\n");
    printf("Enter an expression:\n");
    if (!yyparse()) {
        printf("\nParsing complete. No errors found.\n");
    }
    return 0;
}
