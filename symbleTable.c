#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "symbleTable.h"

int declear = 0;
static symtab *head = NULL; //top of the table

int address = 0; //relative address

void insert(char *name, int len, int type){
    symtab *ptr = (symtab*) malloc(sizeof(symtab));
    strncpy(ptr -> st_name, name, len);
    ptr -> st_type = type;
    ptr -> next = head;
    ptr -> address = address;
    address++;

    printf("inserting %s in symtab and its address = %d\n", ptr->st_name, ptr->address);
    head = ptr; //next item will point this row
}

symtab* search(char *name){
    symtab *current = head;  // Initialize current. Head points to the last element of the table
    while (current != NULL) 
    { 
        if (strcmp(name,current->st_name) != 0)
            current = current->next;
        else
            break;
    } 
    return current; 
}