/* (C) 2012 Makoto Kinouchi, Yamagata University */

#include <stdio.h>
#include <string.h>

#define T_IN_ANTICODON_LOOP
#define GC_PAIR_IN_T_STEM
#define GG_IN_D_LOOP
#define TTC_IN_T_LOOP
#define ATC_IN_T_LOOP_FOR_MET
#define TCC_IN_T_LOOP_FOR_TYR

main()
{
  char s0[ 256 ], s1[ 256 ], s2[ 256 ], s3[ 256 ], s4[ 256 ];
  char s5[ 256 ], s6[ 256 ], s7[ 4096 ], s8[ 256 ], s9[ 4096 ];
  char sa[ 256 ], sb[ 256 ], sc[ 256 ], sd[ 256 ], se[ 256 ];
  char S1[ 8192 ], S2[ 8192 ], S3[ 8192 ];

  FILE *fp;
  fp = stdin;
  
  while (fgets(S1, 8192, fp) != NULL) {
    fgets(S2, 8192, fp);
    sscanf(S2, "%s%s%s%s%s%s%s%s%s%s", s0, s1, s2, s3, s4, s5, s6, s7, s8, s9);

    fgets(S3, 8192, fp);
    sscanf(S3, "%s%s%s%s%s", sa, sb, sc, sd, se);

#ifdef T_IN_ANTICODON_LOOP
    if (s7[ 1 ] != 't')
      continue;
#endif

#ifdef GC_PAIR_IN_T_STEM
    if (sa[ 4 ] != 'g' || sc[ 0 ] != 'c')
      continue;
#endif

#ifdef GG_IN_D_LOOP
    if (strncmp(s3 + 3, "gg", 2) &&
	strncmp(s3 + 4, "gg", 2) &&
	strncmp(s3 + 5, "gg", 2))
      continue;
#endif

    if (1)
#ifdef TTC_IN_T_LOOP
      if (strncmp(sb, "ttc", 3))
#endif

#ifdef ATC_IN_T_LOOP_FOR_MET
	if (strncmp(sb, "atc", 3) || strncmp(s7 + 2, "cat", 3))
#endif

#ifdef TCC_IN_T_LOOP_FOR_TYR
	  if (strncmp(sb, "tcc", 3) || strncmp(s7 + 2, "gta", 3))
#endif
	    continue;

    fputs(S1, stdout);
    fputs(S2, stdout);
    fputs(S3, stdout);
  }
}
