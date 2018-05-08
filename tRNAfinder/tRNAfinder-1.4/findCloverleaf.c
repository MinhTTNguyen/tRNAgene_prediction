/* (C) 2012 Makoto Kinouchi, Yamagata University */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#ifndef MAX_SEQUENCE
#define MAX_SEQUENCE 100 /* M bp */
#endif

#ifndef MAX_MISMATCH
#define MAX_MISMATCH 2
#endif

#ifndef MIN_INTRON
#define MIN_INTRON 0
#endif

#ifndef MAX_INTRON
#define MAX_INTRON 100
#endif

#ifndef max
#define max(x,y) ((x)>(y)?(x):(y))
#endif

char complement(char c)
{
  switch (c) {
  case 'a':
    return 't';
  case 'c':
    return 'g';
  case 'g':
    return 'c';
  case 't':
    return 'a';
  default:
    return c;
  }
}

int isComplement(char c1, char c2)
{
  if ((c1 == 'a' && c2 == 't') || (c1 == 't' && c2 == 'a') ||
      (c1 == 'c' && c2 == 'g') || (c1 == 'g' && c2 == 'c'))
    return 1;
  else if ((c1 == 'g' && c2 == 't') || (c1 == 't' && c2 == 'g'))
    return 1;
  else
    return 0;
}

void findRegion(char *data, int length, int mode, char *name)
{
  int xx, yy, x, y;
  int n, i, j;
  int interval;
  int sum, mismatch1, mismatch2, mismatch3;
  
  for (n = 0; n < length; n ++) {
    for (interval = 69; interval < 94 + MAX_INTRON; interval ++) {
      xx = n;
      yy = n + interval;
      if (yy >= length)
	continue;
      
      mismatch1 = 0;
      sum = 0;
      for (i = 0; i < 7; i ++)
	sum += isComplement(data[ xx + i ], data[ yy - i ]);
      mismatch1 += (7 - sum);
      if (sum < 5 || mismatch1 > MAX_MISMATCH)
	continue;
      
      y = n + interval - 7;
      x = y - 16;
      sum = 0;
      for (i = 0; i < 5; i ++)
	sum += isComplement(data[ x + i ], data[ y - i ]);
      mismatch1 += (5 - sum);
      if (sum < 4 || mismatch1 > MAX_MISMATCH)
	continue;
      
      for (j = 14; j < 19; j ++) {
	x = n + 9;
	y = x + j;
	sum = 0;
	
	if (j < 17) {
	  for (i = 0; i < 3; i ++)
	    sum += isComplement(data[ x + i ], data[ y - i ]);
	  mismatch2 = mismatch1 + (3 - sum);
	} else {
	  for (i = 0; i < 4; i ++)
	    sum += isComplement(data[ x + i ], data[ y - i ]);
	  mismatch2 = mismatch1 + (4 - sum);
	}
	
	if (mismatch2 <= MAX_MISMATCH) {
	  x = y + 2;
	  for (y = max(x + 16, yy - 54); (y <= x + 16 + MAX_INTRON) && (y <= yy - 28); y ++) {
	    sum = 0;
	    for (i = 0; i < 5; i ++)
	      sum += isComplement(data[ x + i ], data[ y - i ]);
	    mismatch3 = mismatch2 + (5 - sum);
	    
	    if (mismatch3 <= MAX_MISMATCH) {
	      if (!mode)
		fprintf(stdout, "%s\t%d..%d", name, xx + 1, yy + 1 + 1);
	      else
		fprintf(stdout, "%s\tcomplement(%d..%d)", name, length - yy - 1, length - xx);
	      fprintf(stdout, "\tmismatch=%d\n", mismatch3);
	      
	      fputc('\t', stdout);
	      for (i = xx; i < yy + 1 + 1; i ++) {
		switch (i - xx) {
		case 7:
		case 9:
		case 13:
		  fputc(' ', stdout);
		}
		switch (i - xx - j) {
		case 6:
		case 10:
		case 11:
		case 16:
		  fputc(' ', stdout);
		}
		switch (y - i) {
		case -1:
		case 4:
		  fputc(' ', stdout);
		}
		switch (yy - i) {
		case 23: 
		  fputc('\n', stdout);
		  fputc('\t', stdout);
		  break;
		case 18:
		case 11:
		case 6:
		case -1:
		  fputc(' ', stdout);
		}
		if (data[ i ] != '\0') {
		  fputc(data[ i ], stdout);
		}
	      }
	      fputc('\n', stdout);
	    }
	    if (MIN_INTRON && y == x + 16) {
	      y += MIN_INTRON - 1;
	    }
	  } // y
	}
      }
    }
  }
}

void sub(FILE *fp, char *name)
{
  char c, *data;
  char tmp;
  int maxsize, length, length2;
  int i;
  
  maxsize = MAX_SEQUENCE * 1024L * 1024L;
  data = (char *) malloc(maxsize --);
  
  length = 0;
  while ((c = fgetc(fp)) != EOF && length < maxsize) {
    if (c == '/') {
      break;
    } else if (c == '>') {
      ungetc(c, fp);
      break;
    } else if(c >= 'a' && c <= 'z') {
      data[ length ++ ] = c;
    } else if(c >= 'A' && c <= 'Z') {
      data[ length ++ ] = c - 'A' + 'a';
    }
  }
  data[ length ] = '\0';
  
  findRegion(data, length, 0, name);
  
  length2 = length / 2;
  for (i = 0; i < length2; i ++) {
    tmp = data[ i ];
    data[ i ] = complement(data[ length - 1 - i ]);
    data[ length - 1 - i ] = complement(tmp);
  }
  if (length % 2) {
    data[ length2 ] = complement(data[ length2 ]);
  }
  
  findRegion(data, length, 1, name);
  
  free(data);
}

main(int argc, char **argv)
{
  FILE *fpr;
  char S[ 256 ], tmp[ 256 ], name[ 256 ];
  int isFasta = 0;
  int pos;
  
  if (argc < 2) {
    return 1;
  }

  if (argv[ 1 ][ 0 ] == '-') {
    if (argv[ 1 ][ 1 ] == 'f' || argv[ 1 ][ 1 ] == 'F') {
      isFasta = 1;
      fpr = fopen(argv[ 2 ], "rb");
      if (fpr == NULL) {
	return 1;
      }
    } else {
      sub(stdin, argv[ 2 ]);
      return 0;
    }
  } else {
    fpr = fopen(argv[ 1 ], "rb");
    if (fpr == NULL) {
      return 1;
    }
    
    if (argc > 2 && argv[ 2 ][ 0 ] == '-' &&
	(argv[ 2 ][ 1 ] == 'f' || argv[ 2 ][ 1 ] == 'F')) {
      isFasta = 1;
    }
  }
  
  if (isFasta) {
    
    do {
      
      *name = '\0';
      
      do {
	pos = ftell(fpr);
	
	if (fgets(S, 256, fpr) == NULL) {
	  return 0;
	} 
	if (*S == '>' && *name == '\0') {
	  sscanf(S + 1, "%s", name);
	}
      } while (*S == '>');
      
      fseek(fpr, pos, SEEK_SET);
      sub(fpr, name);
      
    } while (1);
    
  } else {
    
    do {
      do {
	if (fgets(S, 256, fpr) == NULL) {
	  return 0;
	}
      } while (strncmp("ACCESSION", S, 9));
      
      sscanf(S, "%s%s", tmp, name);
      
      do {
	if (fgets(S, 256, fpr) == NULL) {
	  return 0;
	}
      } while (strncmp("ORIGIN", S, 6));
      
      sub(fpr, name);
      
    } while (1);
  }
}
