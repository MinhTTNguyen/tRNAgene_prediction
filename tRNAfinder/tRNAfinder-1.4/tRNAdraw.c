/* (C) 2012 Makoto Kinouchi, Yamagata University */

#include <stdio.h>
#include <string.h>

char s0[ 256 ], s1[ 256 ], s2[ 256 ], s3[ 256 ], s4[ 256 ];
char s5[ 256 ], s6[ 256 ], s7[ 65536 ], s8[ 256 ], s9[ 65536 ];
char sa[ 256 ], sb[ 256 ], sc[ 256 ], sd[ 256 ], se[ 256 ];
char r0[ 256 ], r1[ 256 ], r2[ 256 ], r3[ 256 ];

int isComplement(char c1, char c2)
{
  if (c1 == 'a' && c2 == 't')
    return 1;
  else if (c1 == 't' && c2 == 'a')
    return 1;
  else if (c1 == 'c' && c2 == 'g')
    return 1;
  else if (c1 == 'g' && c2 == 'c')
    return 1;
  else if (c1 == 'g' && c2 == 't')
    return 2;
  else if (c1 == 't' && c2 == 'g')
    return 2;
  else
    return 0;
}

void read()
{
  char S[ 65536 ];
  FILE *fp;
  fp = stdin;

  fgets(S, 65536, fp);
  sscanf(S, "%s%s%s%s%s%s%s%s%s%s", s0, s1, s2, s3, s4, s5, s6, s7, s8, s9);

  fgets(S, 65536, fp);
  sscanf(S, "%s%s%s%s%s", sa, sb, sc, sd, se);
}

void fix()
{
  int i;

  if (s3[7] == '\0'){
    for (i = 7; i < 13; i ++)
      s3[ i ] = ' ';
  } else {
    s3[11] = s3[6];
    s3[10] = s3[5];

    if (s3[9] != '\0')
      s3[12] = s3[9];
    else
      s3[12] = ' ';

    if (s3[8] != '\0')
      s3[6] = s3[8];
    else
      s3[6] = s3[12] = ' ';
    s3[5] = s3[7];

    s3[9] = s3[4];
    s3[8] = s3[3];
    s3[7] = s3[2];

    s3[4] = s3[3] = s3[2] = ' ';
  }
}

void check()
{
  char c[] = " -+";

  r0[0] = c[isComplement(s0[0], sd[6])];
  r0[1] = c[isComplement(s0[1], sd[5])];
  r0[2] = c[isComplement(s0[2], sd[4])];
  r0[3] = c[isComplement(s0[3], sd[3])];
  r0[4] = c[isComplement(s0[4], sd[2])];
  r0[5] = c[isComplement(s0[5], sd[1])];
  r0[6] = c[isComplement(s0[6], sd[0])];

  r2[0] = c[isComplement(s6[0], s8[4])];
  r2[1] = c[isComplement(s6[1], s8[3])];
  r2[2] = c[isComplement(s6[2], s8[2])];
  r2[3] = c[isComplement(s6[3], s8[1])];
  r2[4] = c[isComplement(s6[4], s8[0])];

  c[1] = '|';

  r1[0] = c[isComplement(s2[0], s4[3])];
  r1[1] = c[isComplement(s2[1], s4[2])];
  r1[2] = c[isComplement(s2[2], s4[1])];
  r1[3] = c[isComplement(s2[3], s4[0])];

  r3[0] = c[isComplement(sa[0], sc[4])];
  r3[1] = c[isComplement(sa[1], sc[3])];
  r3[2] = c[isComplement(sa[2], sc[2])];
  r3[3] = c[isComplement(sa[3], sc[1])];
  r3[4] = c[isComplement(sa[4], sc[0])];
}

void draw()
{
  int i, ii;
  char c;
  FILE *fp;
  fp = stdout;

  fprintf(fp, "\n");
  fprintf(fp, "                      %s\n", se);
  fprintf(fp, "                 %c %c %c\n", s0[0], r0[0], sd[6]);
  fprintf(fp, "                 %c %c %c\n", s0[1], r0[1], sd[5]);
  fprintf(fp, "                 %c %c %c\n", s0[2], r0[2], sd[4]);
  fprintf(fp, "                 %c %c %c\n", s0[3], r0[3], sd[3] );
  fprintf(fp, "                 %c %c %c\n", s0[4], r0[4], sd[2]);
  fprintf(fp, "                 %c %c %c\n", s0[5], r0[5], sd[1]);
  fprintf(fp, "                 %c %c %c          %c %c\n",
	  s0[6], r0[6], sd[0], sb[6], sb[5]);
  fprintf(fp, "                %c     %c %c %c %c %c     %c\n",
	  s1[0], sc[4], sc[3], sc[2], sc[1], sc[0], sb[4]);
  fprintf(fp, "  %c %c %c        %c      %c %c %c %c %c     %c\n",
	  s3[7], s3[1], s3[0], s1[1],
	  r3[0], r3[1], r3[2], r3[3], r3[4], sb[3]);
  fprintf(fp, "%c %c     %c %c %c %c       %c %c %c %c %c     %c\n",
	  s3[8], s3[2], s2[3], s2[2], s2[1], s2[0],
	  sa[0], sa[1], sa[2], sa[3], sa[4], sb[2]);
  fprintf(fp, "%c %c     %c %c %c %c                 %c %c\n",
	  s3[9], s3[3], r1[3], r1[2], r1[1], r1[0], sb[0], sb[1]);
  fprintf(fp, "%c %c     %c %c %c %c\n",
	  s3[10], s3[4], s4[0], s4[1], s4[2], s4[3]);
  fprintf(fp, "  %c %c %c %c      %c     %s\n",
	  s3[11], s3[5], s3[6], s3[ 12 ], s5[0], s9);
  fprintf(fp, "                %c %c %c\n", s6[0], r2[0], s8[4]);
  fprintf(fp, "                %c %c %c\n", s6[1], r2[1], s8[3]);
  fprintf(fp, "                %c %c %c\n", s6[2], r2[2], s8[2]);
  fprintf(fp, "                %c %c %c\n", s6[3], r2[3], s8[1]);
  fprintf(fp, "                %c %c %c\n", s6[4], r2[4], s8[0]);

  if (s7[7] == '\0') {
    fprintf(fp, "              %c       %c\n", s7[0], s7[6]);
    fprintf(fp, "              %c       %c\n", s7[1], s7[5]);
  } else {
    fprintf(fp, "              %c       %c\n", s7[0], s7[ strlen(s7) - 1 ]);
    fprintf(fp, "              %c       %c (intron)\n", s7[1], s7[5]);
  }

  fprintf(fp, "                %c %c %c\n", s7[2], s7[3], s7[4]);
  fprintf(fp, "\n");

  if (s7[7] != '\0') {
    fprintf(fp, "intron (length = %d):", ii = strlen(s7) - 7);
    for (i = 0; i < ii; i ++) {
      if (i % 70 == 0) {
	fputc('\n', fp);
      }
      fputc(s7[ i + 6 ], fp);
    }
    fputc('\n', fp);
    fputc('\n', fp);
  }
}

main()
{
  char S[ 65536 ];

  while (fgets(S, 65536, stdin) != NULL) {
    fputs(S, stdout);

    read();
    fix();
    check();
    draw();
  }
}
