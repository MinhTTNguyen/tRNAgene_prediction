/* (C) 2012 Makoto Kinouchi, Yamagata University */

#include <stdio.h>
#include <string.h>

int showPosition(char *S, int num0, int num1)
{
  int start, end;

  while (*S != '\t') {
    fputc(*S, stdout);
    S ++;
  }
  S ++;

  if (*S == 'c') {
    sscanf(S, "complement(%d..%d)", &end, &start);
    fprintf(stdout, "\tcomplement(join(%d..%d,", end, start - num1 + 1); 
    fprintf(stdout, "%d..%d))", start - num0, start);
  } else {
    sscanf(S, "%d..%d", &start, &end);
    fprintf(stdout, "\tjoin(%d..%d,", start, start + num0); 
    fprintf(stdout, "%d..%d)", start + num1 - 1, end);
  }

  while (*S != '\t') {
    S ++;
  }

  fputs(S, stdout);
}

int showIntron(char *S0, char *S1, char *S2)
{
  char s0[ 256 ], s1[ 256 ], s2[ 256 ], s3[ 256 ], s4[ 256 ];
  char s5[ 256 ], s6[ 256 ], s7[ 65536 ], s8[ 256 ], s9[ 65536 ];

  sscanf(S1, "%s%s%s%s%s%s%s%s%s%s", s0, s1, s2, s3, s4, s5, s6, s7, s8, s9);

  if (s7[ 7 ] == '\0') {
    fputs(S0, stdout);
  } else {
    int num0 = strlen(s2) + strlen(s3) + strlen(s4) + 15 + 5;
    int num1 = num0 + strlen(s7) - 5;
    showPosition(S0, num0, num1);
  }  
  fputs(S1, stdout);
  fputs(S2, stdout);
}

main()
{
  char S0[ 65536 ], S1[ 65536 ], S2[ 65536 ];

  while (fgets(S0, 65536, stdin) != NULL){
    fgets(S1, 65536, stdin);
    fgets(S2, 65536, stdin);

    showIntron(S0, S1, S2);
  }
}
