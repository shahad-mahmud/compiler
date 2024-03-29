#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "symtab.h"

int declare =0;

static list_t* head = NULL;

int address=0;

void insert(char *name,int len,int type)
{
    list_t* ptr = (list_t*)malloc(sizeof(list_t));
    strncpy(ptr->st_name,name,len);   // dest , src, length
    ptr->st_type = type;
    ptr->next = head;
    ptr->address = address;
    address++;
    printf("Inserting %s in symtab and its address = %d\n",ptr->st_name,ptr->address);
    head = ptr;
}

list_t* search (char *name)
{
    list_t *current = head;
    while (current != NULL)
    {
        if(strcmp(name, current->st_name)!=0)
        {
            current = current->next;
        }
        else{
            break;
        }
    }
    return current;
    
}
//roll : 1503073
