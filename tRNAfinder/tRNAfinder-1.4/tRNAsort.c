/* (C) 2012 Makoto Kinouchi, Yamagata University */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

struct tRNA
{
  char string[ 65536 ];
  int position;
};

int getPosition(char *S)
{
  int a = 0;

  for(; *S != '\t'; S ++);
  for(; *S < '0' || *S > '9'; S ++);

  for(; *S >= '0' && *S <= '9'; S ++){
    a *= 10;
    a += *S - '0';
  }
  return a;
}

int compareData(const void *x, const void *y)
{
  struct tRNA *p, *q;
  p = (struct tRNA *) x;
  q = (struct tRNA *) y;

  if(p->position < q->position)
    return -1;
  else
    return 1;
}

main()
{
  struct tRNA *data;
  char S[ 65536 ];
  int i, ii;

  data = (struct tRNA *) malloc(4096 * sizeof(struct tRNA));

  for(i = 0; i < 4096 && fgets(S, 65536, stdin) != NULL; i ++){

    data[ i ].position = getPosition(S);

    strcpy(data[ i ].string, S);
    fgets(S, 65536, stdin);
    strcat(data[ i ].string, S);
    fgets(S, 65536, stdin);
    strcat(data[ i ].string, S);
  }
  ii = i;

  qsort(data, ii, sizeof(struct tRNA), &compareData);

  for(i = 0; i < ii; i ++)
    fputs(data[ i ].string, stdout);
}
