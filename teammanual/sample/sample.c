#include <stdio.h>
int main(int argc, char** argv) {
  int num_testcases, i, a, b;
  scanf("%d\n", &num_testcases);
  for(i=0;i<num_testcases;++i) {
    scanf("%d %d\n", &a, &b);
    printf("%d %d\n", a+b, a-b);
  }
  return 0;
} 
