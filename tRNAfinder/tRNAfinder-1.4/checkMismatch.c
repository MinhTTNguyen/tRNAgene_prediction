/* (C) 2012 Makoto Kinouchi, Yamagata University */

#include <stdio.h>
#include <string.h>

#define MAXMISMATCH 10

int isNotComplement(char c1, char c2)
{
  if ((c1 == 'a' && c2 == 't') || (c1 == 't' && c2 == 'a') ||
      (c1 == 'c' && c2 == 'g') || (c1 == 'g' && c2 == 'c'))
    return 0;
  else if ((c1 == 'g' && c2 == 't') || (c1 == 't' && c2 == 'g'))
    return 1;
  else
    return 5;
}

int countMismatch(char *S1, char *S2)
{
  char s0[ 256 ], s1[ 256 ], s2[ 256 ], s3[ 256 ], s4[ 256 ];
  char s5[ 256 ], s6[ 256 ], s7[ 65536 ], s8[ 256 ], s9[ 65536 ];
  char sa[ 256 ], sb[ 256 ], sc[ 256 ], sd[ 256 ], se[ 256 ];
  int i;
  int score = 0;

  sscanf(S1, "%s%s%s%s%s%s%s%s%s%s", s0, s1, s2, s3, s4, s5, s6, s7, s8, s9);
  sscanf(S2, "%s%s%s%s%s", sa, sb, sc, sd, se);

  for (i = 0; i < 7; i ++)
    score += isNotComplement(s0[ i ], sd[ 6 - i ]);

  for (i = 0; i < 3; i ++)
    score += isNotComplement(s2[ i ], s4[ 3 - i ]);

  for (i = 0; i < 5; i ++)
    score += isNotComplement(s6[ i ], s8[ 4 - i ]);

  for (i = 0; i < 5; i ++)
    score += isNotComplement(sa[ i ], sc[ 4 - i ]);

  if (strlen(s7) > 7)
    score += 2;

  return score;
}

main()
{
  char S0[ 65536 ], S1[ 65536 ], S2[ 65536 ];

  while (fgets(S0, 65536, stdin) != NULL) {
    fgets(S1, 65536, stdin);
    fgets(S2, 65536, stdin);

    if (countMismatch(S1, S2) <= MAXMISMATCH) {
      fputs(S0, stdout);
      fputs(S1, stdout);
      fputs(S2, stdout);
    }
  }
}
