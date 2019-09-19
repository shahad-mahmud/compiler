#define MAX 50

#define UNDEF 0
#define INT_TYPE 1
#define REAL_TYPE 2
#define CHAR_TYPE 3

typedef struct symtab
{
    char st_name[MAX];
    int st_type;
    int address;

    struct symtab *next;
}symtab;

symtab* search(char *name);
void insert(char *name, int len, int type);
