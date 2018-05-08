/* (C) 2012 Makoto Kinouchi, Yamagata University */

#include <stdio.h>
#include <string.h>

#undef SHOW_HEADER

main(int argc, char **argv)
{
  char S[ 65536 ];
  char anticodon[ 64 ][ 256 ];
  char *p;
  int i, j;
  int sum = 0;
  int count[ 64 ];

  FILE *fp;
  fp = fopen("anticodon.dat", "r");

  if (fp == NULL)
    return 1;

  for (i = 0; i < 64; i ++) {

    fgets(S, 1024, fp);
    strcpy(anticodon[ i ], S);

    count[ i ] = 0;
  }

  fclose(fp);

  while (fgets(S, 65536, stdin) != NULL) {
    
    for (p = S; *p != '\t' && *p != '\0'; p ++);
    if (*p == '\0')
      continue;

    for (p ++; *p != '\t' && *p != '\0'; p ++);
    if (*p == '\0')
      continue;

    p ++;

    for (i = 0; i < 64; i ++) {
      if (!strcmp(p, anticodon[ i ])) {
	count[ i ] ++;
	i = 64;
      }
    }
  }

  for (i = 0; i < 64; i ++) {
    strcpy(S, anticodon[ i ]);
    S[ strlen(S) - 1 ] = '\0';
    fprintf(stderr, "%s\t%d\n", S, count[ i ]);
  }

#ifdef SHOW_HEADER
  for (j = 4; j < 7; j ++) {
    fprintf(stdout, "\t");
    for (i = 0; i < 64; i ++)
      fprintf(stdout, "%c ", anticodon[ i ][ j ]);
    fprintf(stdout, "\n");
  }
#endif

  fprintf(stdout, "%s\t", argv[ 1 ]);
  for (i = 0; i < 64; i ++) {
    fprintf(stdout, "%d ", count[ i ]);
    sum += count[ i ];
  }
  
  fprintf(stdout, "%d\n", sum);
}
