#include <stdio_checked.h>
#include <stdlib_checked.h>
#include <string_checked.h>

int main(void) {
    int a, b; 
    char values _Checked [1024];
    char item _Checked[1024] = {0};
    printf("YESNO: Option a: ");
    fgets(values, 1024, stdin);
    a = strncmp((const char *)values, "yes", 3) == 0 ? 1 : 0;
    printf("PROMPT: Enter a number: ");
    fgets(values, 1024, stdin);
    sscanf((const char *) values, "%d", &b);
    printf("MENU: (chicken pork beef) # Choose Food");
    fgets(item, 1023, stdin);
    printf("a is %s, b is %d, Food: %s\n", a ? "true" : "false", b, item);
    fprintf(stderr, "error\n");
    return 0;
}
