%{
    #include"compiler_lib.c"
%}


%union { 
    struct var_name { 
        char name[100];
        struct node* nd;
    } nd_obj; 
} 

%token <nd_obj> AND DIVIDE ASSIGN EQ GT GE LT LE SUBTRACT 
%token <nd_obj> NOT NE OR ADD MULTIPLY ADDR  
%token <nd_obj> STR BOOL CHAR INT REAL INT_P CHAR_P REAL_P
%token <nd_obj> INTEGER REAL_NUM CHARACTER STRING
%token <nd_obj> ARGS FUNCTION RETURN   
%token <nd_obj> IF ELSE WHILE FOR DO
%token <nd_obj> VAR TRUE FALSE NULL_VAL
%token <nd_obj> ID LEFT_BRACE RIGHT_BRACE
%token VOID 

%type <nd_obj> program

%type <nd_obj>  functions_list function function_title parameter_list parametr id_list

%type <nd_obj>  body _body return inner_block

%type <nd_obj>  if_statement else_st if_body if_st

%type <nd_obj>  while_statement dowhile_statement while_st

%type <nd_obj>  for_statement for_st

%type <nd_obj>  statement_list one_statement _one_statement

%type <nd_obj> assignment

%type <nd_obj>  declaration declaration_str_list declaration_str declaration_var_list declaration_var

%type <nd_obj>  expression_list expression _expression mutable_values iterator_id function_call value id

%type <nd_obj> signs datatype _datatype

%%
    program: 
        functions_list  { $$.nd = mknode("CODE", NULL, $1.nd); head = $$.nd; } 
        ;

    inner_block:
        LEFT_BRACE body RIGHT_BRACE { $$.nd = mknode("INNER_BLOCK", NULL, $2.nd); }
        ;

    functions_list: 
        function { $$.nd  = $$.nd; }
        | functions_list function {$$.nd = mknode("FUNCTION_LIST", $1.nd, $2.nd);  }
        ;

    function: 
        function_title ':' datatype LEFT_BRACE body  RIGHT_BRACE 
        { 
            $1.nd = mknode("FUNCTION_TITLE",  $1.nd, $3.nd); 
            $$.nd = mknode("FUNCTION", $1.nd, $5.nd); 
        } 
        | function_title ':' VOID LEFT_BRACE body RIGHT_BRACE  {   $$.nd = mknode("PROCEDURE", $1.nd, $5.nd); } 
        ;

    function_title: 
        FUNCTION id '('')'   {   $$.nd = $2.nd;  }
        | FUNCTION id '(' parameter_list ')'   {   $$.nd = mknode("", $2.nd, $4.nd);  }
        ;

    parameter_list: 
        parametr { $$.nd = $1.nd; } 
        | parameter_list ';' parametr { $$.nd = mknode("PARAMETR_LIST",  $1.nd, $3.nd);  }
        ;

    parametr: 
        ARGS id_list ':' datatype  {  $$.nd = mknode("PARAMETR",  $2.nd, $4.nd);   }
        ;

    id_list:  
        id {$$.nd = $$.nd; }
        | id_list ',' id {$$.nd = mknode("ID_LIST", $1.nd, $3.nd); }
        ;

    body: _body { $$.nd = mknode("BODY", NULL, $1.nd);}

    _body:
        statement_list { $$.nd = $$.nd; }
        | if_statement { $$.nd = $$.nd; }
        | while_statement { $$.nd = $$.nd; }
        | dowhile_statement { $$.nd = $$.nd; }
        | for_statement { $$.nd = $$.nd; }
        | function { $$.nd = $$.nd; }
        | return { $$.nd = $$.nd; }
        | inner_block { $$.nd = $$.nd; }
        | body body {$$.nd = mknode("BODY_LIST", $1.nd, $2.nd); }
        | {$$.nd = NULL;}
        ;


    return: 
        RETURN expression ';' {$$.nd = mknode("RETURN", NULL, $2.nd); } 
        ;


    if_statement: 
        if_body else_st {  $$.nd = mknode("IF_ELSE", $1.nd, $2.nd); }
        | if_body {  $$.nd = mknode("IF", NULL, $1.nd); }
        | if_st one_statement {  $$.nd = mknode("IF_STATEMENT", $1.nd, $2.nd); }
        ;

    else_st:
        ELSE LEFT_BRACE body RIGHT_BRACE { $$.nd = mknode("ELSE", NULL, $3.nd); }
        | ELSE one_statement { $$.nd = mknode("ELSE", NULL, $2.nd); }
        ;

    if_body:
        if_st LEFT_BRACE body RIGHT_BRACE { $$.nd = mknode("IF_WHEN", $1.nd, $3.nd);}
        ;

    if_st:
        IF '(' expression ')'  { $$.nd = mknode("IF", NULL, $3.nd); }
        ; 

    while_statement: 
        while_st LEFT_BRACE body RIGHT_BRACE { $$.nd = mknode("WHILE_BODY", $1.nd, $3.nd); }
        | while_st one_statement { $$.nd = mknode("WHILE_STATEMENT", $1.nd, $2.nd); }
        ;

    dowhile_statement: 
        DO LEFT_BRACE body RIGHT_BRACE while_st ';' { $$.nd = mknode("DO", $3.nd, $5.nd); }
        ;

    while_st:  
        WHILE '(' expression ')' { $$.nd = mknode("WHILE", NULL, $3.nd); }
        ;

    for_statement: 
        for_st LEFT_BRACE body RIGHT_BRACE { $$.nd = mknode("FOR_BODY", $1.nd, $3.nd); }
        | for_st one_statement { $$.nd = mknode("FOR_STATEMENT", $1.nd, $2.nd); }
        ;


    for_st:
        FOR '(' assignment ';' expression ';' assignment ')'
        {
            $3.nd = mknode("FOR_INIT", NULL, $3.nd);
            $7.nd = mknode("FOR_UPDATE", NULL, $7.nd);

            $3.nd = mknode("FOR_ASSIGMENTS", $3.nd, $7.nd);


            $5.nd = mknode("FOR_EXPRESSION", NULL, $5.nd);


            $$.nd = mknode("FOR_TITLE", $3.nd, $5.nd);
        }
        ;

    statement_list:
        one_statement { $$.nd  = $$.nd; }
        | statement_list ';' one_statement  {$$.nd = mknode("STATEMENT_LIST", $1.nd, $3.nd);  }
        ;

    one_statement: _one_statement ';' { $$.nd = mknode("STATEMENT", NULL, $1.nd);};

    _one_statement:
        function_call { $$.nd  = $$.nd; }
        | assignment { $$.nd  = $$.nd; }
        | declaration { $$.nd  = $$.nd; }
        ;

    assignment:
        mutable_values ASSIGN expression {$$.nd = mknode("=", $1.nd, $3.nd);  }
        ;


    declaration:
        VAR declaration_var_list ':' datatype {$$.nd = mknode("VAR INIT", $4.nd, $2.nd);  }
        | STR declaration_str_list {$$.nd = mknode("STR INIT", NULL, $2.nd);  }
        ;


    declaration_str_list:
        declaration_str { $$.nd  = $$.nd; }
        | declaration_str_list ',' declaration_str {$$.nd = mknode("DECLARATION_STR_LIST", $1.nd, $3.nd);  }
        ;

    declaration_str:
        iterator_id { $$.nd  = $$.nd; }
        | iterator_id ASSIGN expression {$$.nd = mknode("ASSIGN_STR", $1.nd, $3.nd);  }
        ;

    declaration_var_list:
        declaration_var { $$.nd  = $$.nd; }
        | declaration_var_list ',' declaration_var {$$.nd = mknode("DECLARATION_VAR_LIST", $1.nd, $3.nd);  }
        ;

    declaration_var:
        id { $$.nd  = $$.nd; }
        | id ASSIGN expression {$$.nd = mknode("ASSIGN_VAR", $1.nd, $3.nd);  }
        ;

    expression_list: 
        expression {$$.nd = $$.nd;  }
        | expression_list ',' expression {$$.nd = mknode("EXPRESSION_LIST", $1.nd, $3.nd);  }
        ;

    expression:  _expression { $$.nd = mknode("EXPRESSION", NULL, $1.nd);};

    _expression:
        value { $$.nd  = $$.nd; }
        | '|' id '|' { $$.nd = mknode("| ID |", NULL, $2.nd); } 
        | NOT expression { $$.nd = mknode("NOT", NULL, $2.nd); } 
        | SUBTRACT expression { $$.nd = mknode("-", NULL, $2.nd); } 
        | ADDR id { $$.nd = mknode("&ID", NULL, $2.nd); } 
        | ADDR iterator_id { $$.nd = mknode("&STRING[]", NULL, $2.nd); } 
        | function_call { $$.nd  = $1.nd; }
        | expression signs expression { $$.nd = mknode($2.name, $1.nd, $3.nd); } 
        | '(' expression ')' { $$.nd = $2.nd; }
        | mutable_values { $$.nd = $$.nd; } 
        ;

    mutable_values:
        MULTIPLY id { $$.nd = mknode("*POINTER", NULL, $2.nd); } 
        | MULTIPLY '(' expression ')' { $$.nd = mknode("*POINTER", NULL, $3.nd); } 
        | iterator_id { $$.nd = $$.nd; } 
        | id { $$.nd =$$.nd; }
        ;

    iterator_id:
        id '[' expression ']' { $$.nd = mknode("[]ID", $1.nd, $3.nd); } 

    function_call:
        id '('  ')' { $$.nd = mknode("FUNCTION_CALL", $1.nd, NULL); }
        | id '(' expression_list ')' { $$.nd = mknode("FUNCTION_CALL", $1.nd, $3.nd); }
        ;

    value:
        INTEGER { $1.nd = mknode($1.name, NULL, NULL); $$.nd = mknode("INTEGER", NULL, $1.nd); }
        | REAL_NUM { $1.nd = mknode($1.name, NULL, NULL); $$.nd = mknode("REAL_NUM", NULL, $1.nd); }
        | CHARACTER  { $1.nd = mknode($1.name, NULL, NULL); $$.nd = mknode("CHARACTER", NULL, $1.nd); }
        | STRING  { $1.nd = mknode($1.name, NULL, NULL); $$.nd = mknode("STRING", NULL, $1.nd); }
        | TRUE  { $1.nd = mknode($1.name, NULL, NULL); $$.nd = mknode("TRUE", NULL, $1.nd); }
        | FALSE  { $1.nd = mknode($1.name, NULL, NULL); $$.nd = mknode("FALSE", NULL, $1.nd); }
        | NULL_VAL { $1.nd = mknode($1.name, NULL, NULL); $$.nd = mknode("NULL", NULL, $1.nd); }
        ;

    id: ID { $1.nd = mknode($1.name, NULL, NULL); $$.nd = mknode("ID", NULL, $1.nd); }

    signs: 
        LT { $$.nd = mknode($1.name, NULL, NULL);  }
        | GT { $$.nd = mknode($1.name, NULL, NULL);  }
        | LE { $$.nd = mknode($1.name, NULL, NULL);  }
        | GE { $$.nd = mknode($1.name, NULL, NULL);  }
        | EQ { $$.nd = mknode($1.name, NULL, NULL);  }
        | NE { $$.nd = mknode($1.name, NULL, NULL);  }
        | OR { $$.nd = mknode($1.name, NULL, NULL);  }
        | AND { $$.nd = mknode($1.name, NULL, NULL);  }
        | ADD  { $$.nd = mknode($1.name, NULL, NULL);  }
        | SUBTRACT  { $$.nd = mknode($1.name, NULL, NULL);  }
        | MULTIPLY { $$.nd = mknode($1.name, NULL, NULL);  }
        | DIVIDE { $$.nd = mknode($1.name, NULL, NULL);  }
        ;

    datatype:
        _datatype {$$.nd = mknode("DATATYPE", NULL, $1.nd);}
        ;

    _datatype: 
        INT { $$.nd = mknode($1.name, NULL, NULL);  }
        | REAL { $$.nd = mknode($1.name, NULL, NULL);  }
        | CHAR { $$.nd = mknode($1.name, NULL, NULL);  }
        | STR { $$.nd = mknode($1.name, NULL, NULL);  }
        | BOOL { $$.nd = mknode($1.name, NULL, NULL);  }
        | INT_P { $$.nd = mknode($1.name, NULL, NULL);  }
        | CHAR_P  { $$.nd = mknode($1.name, NULL, NULL);  }
        | REAL_P { $$.nd = mknode($1.name, NULL, NULL);  }
        ;

%%
