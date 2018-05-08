/* (C) 2012 Makoto Kinouchi, Yamagata University */

#include <stdio.h>
#include <string.h>

char complement(char c)
{
  switch (c) {
  case 'a':
  case 'A':
    return 't';
  case 'c':
  case 'C':
    return 'g';
  case 'g':
  case 'G':
    return 'c';
  case 't':
  case 'T':
    return 'a';
  default:
    return c;
  }
}

int nuc2val(char c)
{
  switch (c) {
  case 'u':
  case 't':
    return 0;
  case 'c':
    return 1;
  case 'a':
    return 2;
  case 'g':
    return 3;
  default:
    return 64;
  }
}

int codon2val(char *S)
{
  return nuc2val(S[ 0 ]) * 16 + nuc2val(S[ 1 ]) * 4 + nuc2val(S[ 2 ]);
} 

int makeTable(char *hashTable, char amino[ 64 ][ 4 ])
{
  char S1[ 4 ], S2[ 4 ], S3[ 4 ];
  int i;
  FILE *fp;

  fp = fopen("translation.dat", "r");

  for (i = 0; i < 64; i ++) {
    fscanf(fp, "%s%s%s", S1, S2, S3);
    hashTable[ codon2val(S1) ] = S2[ 0 ];
    strcpy(amino[ i ], S3);
  }
}

main()
{
  char hashTable[ 64 ];
  char amino[ 64 ][ 4 ];
  char codon[ 4 ] = "   ", anticodon[ 4 ] = "   ";
  char accession[ 256 ], location[ 256 ];
  char s0[ 256 ], s1[ 256 ], s2[ 256 ], s3[ 256 ], s4[ 256 ];
  char s5[ 256 ], s6[ 256 ], s7[ 65536 ], s8[ 256 ], s9[ 65536 ];
  char sa[ 256 ], sb[ 256 ], sc[ 256 ], sd[ 256 ], se[ 256 ];
  char S1[ 65536 ], S2[ 65536 ], S3[ 65536 ];
  int i;
  FILE *fp;

  makeTable(hashTable, amino);

  fp = stdin;

  
  while (fgets(S1, 65536, fp) != NULL) {
    sscanf(S1, "%s%s", accession, location);
    fgets(S2, 65536, fp);
    sscanf(S2, "%s%s%s%s%s%s%s%s%s%s", s0, s1, s2, s3, s4, s5, s6, s7, s8, s9);
    fgets(S3, 65536, fp);

    strncpy(anticodon, s7 + 2, 3);
    for (i = 0; i < 3; i ++)
      codon[ 2 - i ] = complement(anticodon[ i ]);

    if (codon2val(codon) < 64)
      strcpy(codon, amino[ codon2val(codon) ]);
    else
      strcpy(codon, "???");

    sprintf(S1, "%s\t%s\t%s %s\n", accession, location, codon, anticodon);

    fputs(S1, stdout);
    fputs(S2, stdout);
    fputs(S3, stdout);
  }
}
