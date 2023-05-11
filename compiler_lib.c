
#include<stdio.h>
#include<string.h>
#include<stdlib.h>
#include<ctype.h>
#include"lex.yy.c"

int yydebug=1;

void yyerror(const char *s);
int yylex();
int yywrap();



void print_tree(struct node* root, int level);
struct node* mknode(char* name, struct node* left, struct node* right);

struct node *head;
struct node {
    char name[100];
    struct node* left;
    struct node* right;
} node;



int main() {
    yyparse();
    printf("\n\n##### Abstract Syntax Tree ##### \n\n");
    print_tree(head, 0); 
    printf("\n\n");
}


void print_tree(struct node* root, int level) {
    if (root != NULL) {
        if (root->name != NULL) {
            if (strlen(root->name)!=0) {
                printf("%*s%s\n", level, "", root->name);
            }
        }
        print_tree(root->left, level + 2);
        print_tree(root->right, level + 2);
    }
}


struct node* mknode(char* name,  struct node* left, struct node* right) {
    struct node* new_node = (struct node*) malloc(sizeof(struct node));
    if (new_node == NULL) {
        fprintf(stderr, "Couldn't allocate memory.\n");
        exit(1);
    }
    strcpy(new_node->name, name);
    new_node->left = left;
    new_node->right = right;
    return new_node;
}

void yyerror(const char *s) {
  fprintf(stderr, "Error: %s at line %d, token '%s'\n", s, yylineno, yytext);
}

    