dnl 
dnl custom mawk macros for autoconf
dnl 
dnl $Log: mawk.ac.m4,v $
dnl Revision 1.15  1996/09/04 23:40:34  mike
dnl Small tweak to strtod bug check
dnl
dnl Revision 1.14  1996/08/30 00:07:18  mike
dnl Modifications to the test and implementation of the bug fix for
dnl solaris overflow in strtod.
dnl
dnl Revision 1.13  1996/08/25 19:31:03  mike
dnl Added work-around for solaris strtod overflow bug.
dnl
dnl Revision 1.12  1996/01/18  11:51:36  mike
dnl 1.2.2 release
dnl
dnl Revision 1.11  1995/10/16  12:25:03  mike
dnl configure cleanup
dnl
dnl Revision 1.10  1995/04/20  20:26:54  mike
dnl beta improvements from Carl Mascott
dnl
dnl Revision 1.9  1994/12/18  20:46:23  mike
dnl fpe_check -> ./fpe_check
dnl
dnl Revision 1.8  1994/12/14  14:38:22  mike
dnl don't assume siginfo.h is inside signal.h
dnl
dnl Revision 1.7  1994/12/11  21:25:18  mike
dnl tweak XDEFINE
dnl
dnl Revision 1.6  1994/10/16  18:38:26  mike
dnl use sed on defines.out
dnl
dnl Revision 1.5  1994/10/11  02:49:08  mike
dnl systemVr4 siginfo
dnl
dnl Revision 1.4  1994/10/11  00:39:27  mike
dnl fpe check stuff
dnl
dnl
dnl **********  look for math library *****************
dnl
define(MIKE, brennan@whidbey.com)
dnl
define(LOOK_FOR_MATH_LIBRARY,[
if test "${MATHLIB+set}" != set  ; then
AC_CHECK_LIB(m,log,[MATHLIB=-lm ; LIBS="$LIBS -lm"],
[# maybe don't need separate math library
AC_CHECK_FUNC(log, log=yes)
if test "$log$" = yes
then
   MATHLIB='' # evidently don't need one
else
   AC_MSG_ERROR(
Cannot find a math library. You need to set MATHLIB in config.user)
fi])dnl
fi
AC_SUBST(MATHLIB)])dnl
dnl
dnl *********  utility macros **********************
dnl
dnl  I can't get AC_DEFINE_NOQUOTE to work so give up
define([XDEFINE],[AC_DEFINE($1)
echo  X '$1' 'ifelse($2,,1,$2)' >> defines.out])dnl
define([XXDEFINE],
[echo  X '$1' '$2' >> defines.out])dnl
dnl
dnl
dnl We want #define NO_STRERROR
dnl instead of #define HAVE_STRERROR
dnl
dnl
define([XADD_NO],[NO_[$1]])dnl 
define([ADD_NO], [XADD_NO(translit($1, a-z. , A-Z_))])dnl
define([HEADER_CHECK],[AC_CHECK_HEADER($1, ,XDEFINE(ADD_NO($1)))])dnl
define([FUNC_CHECK],[AC_CHECK_FUNC($1, ,XDEFINE(ADD_NO($1)))])dnl
dnl
dnl how to repeat a macro on a list of args
dnl (probably won't work if the args are expandable
dnl
define([REPEAT_IT],
[ifelse($#,1,[$1],$#,2,[$1($2)],
[$1($2) 
REPEAT_IT([$1],
builtin(shift,builtin(shift,$*)))])])dnl

define([CHECK_HEADERS],[REPEAT_IT([HEADER_CHECK],$*)])dnl
define([CHECK_FUNCTIONS],[REPEAT_IT([FUNC_CHECK],$*)])dnl
dnl
dnl ******* find size_t ********************
dnl
define([SIZE_T_CHECK],[
  [if test "$size_t_defed" != 1 ; then]
   AC_CHECK_HEADER($1,size_t_header=ok)
   [if test "$size_t_header" = ok ; then]
   AC_TRY_COMPILE([
#include <$1>],
[size_t *n ;
], [size_t_defed=1;
XXDEFINE($2,1)
echo getting size_t from '<$1>'])
[fi;fi]])dnl
define(WHERE_SIZE_T,
[SIZE_T_CHECK(stddef.h,SIZE_T_STDDEF_H)
SIZE_T_CHECK(sys/types.h,SIZE_T_TYPES_H)])dnl
dnl
dnl  **********  check compiler ******************
dnl
define(COMPILER_ATTRIBUTES,
[AC_MSG_CHECKING(compiler supports void*)
AC_TRY_COMPILE(
[char *cp ;
void *foo() ;] ,
[cp = (char*)(void*)(int*)foo() ;],void_star=yes,void_star=no)
AC_MSG_RESULT($void_star)
test "$void_star" = no && XXDEFINE(NO_VOID_STAR,1)
AC_MSG_CHECKING(compiler groks prototypes)
AC_TRY_COMPILE(,[int x(char*);],protos=yes,protos=no)
AC_MSG_RESULT([$protos])
test "$protos" = no && XXDEFINE(NO_PROTOS,1)
AC_C_CONST
test "$ac_cv_c_const" = no && XXDEFINE(const)])dnl
dnl
dnl
dnl
dnl **********  which yacc ***********
define(WHICH_YACC,
[AC_CHECK_PROGS(YACC, byacc bison yacc)
test "$YACC" = bison && YACC='bison -y'])dnl
dnl
dnl *************  header and footer for config.h *******************
dnl
define(CONFIG_H_HEADER,
[cat<<'EOF'
/* config.h -- generated by configure */
#ifndef CONFIG_H
#define CONFIG_H

EOF])dnl
define(CONFIG_H_TRAILER,
[cat<<'EOF'

#define HAVE_REAL_PIPES 1
#endif /* CONFIG_H */
EOF])dnl
dnl
dnl *************  build config.h ***********************
define(DO_CONFIG_H,
[# output config.h
rm -f config.h
(
CONFIG_H_HEADER
[sed 's/^X/#define/' defines.out]
CONFIG_H_TRAILER
) | tee config.h
rm defines.out])dnl
dnl
dnl
dnl *************** [sf]printf checks needed for print.c ***********
dnl
dnl sometimes fprintf() and sprintf() are not proto'ed in
dnl stdio.h
define(FPRINTF_IN_STDIO,
[AC_EGREP_HEADER([[[^v]]fprintf],stdio.h,,XDEFINE(NO_FPRINTF_IN_STDIO))
AC_EGREP_HEADER([[[^v]]sprintf],stdio.h,,XDEFINE(NO_SPRINTF_IN_STDIO))])dnl
dnl
dnl  **************************************************
dnl  C program to compute MAX__INT and MAX__LONG
dnl  if looking at headers fails
define([MAX__INT_PROGRAM],
[[#include <stdio.h>
int main()
{ int y ; long yy ;
  FILE *out ;

    if ( !(out = fopen("maxint.out","w")) ) exit(1) ;
    /* find max int and max long */
    y = 0x1000 ;
    while ( y > 0 ) y *= 2 ;
    fprintf(out,"X MAX__INT 0x%x\n", y-1) ;
    yy = 0x1000 ;
    while ( yy > 0 ) yy *= 2 ;
    fprintf(out,"X MAX__LONG 0x%lx\n", yy-1) ;
    exit(0) ;
    return 0 ;
 }]])dnl
dnl
dnl *** Try to find a definition of MAX__INT from limits.h else compute***
dnl
define(FIND_OR_COMPUTE_MAX__INT,
[AC_CHECK_HEADER(limits.h,limits_h=yes)
if test "$limits_h" = yes ; then :
else
AC_CHECK_HEADER(values.h,values_h=yes)
   if test "$values_h" = yes ; then
   AC_TRY_RUN(
[#include <values.h>
#include <stdio.h>
int main()
{   FILE *out = fopen("maxint.out", "w") ;
    if ( ! out ) exit(1) ;
    fprintf(out, "X MAX__INT 0x%x\n", MAXINT) ;
    fprintf(out, "X MAX__LONG 0x%lx\n", MAXLONG) ;
    exit(0) ; return(0) ;
}
], maxint_set=1,[MAX_INT_ERRMSG])
   fi
if test "$maxint_set" != 1 ; then 
# compute it  --  assumes two's complement
AC_TRY_RUN(MAX__INT_PROGRAM,:,[MAX_INT_ERRMSG])
fi
cat maxint.out >> defines.out ; rm -f maxint.out
fi ;])dnl
dnl
define(MAX_INT_ERRMSG,
[AC_MSG_ERROR(C program to compute maxint and maxlong failed.
Please send bug report to MIKE.)])dnl
dnl
dnl **********  input config.user ******************
define(GET_USER_DEFAULTS,
[cat < /dev/null > defines.out
test -f config.user && . ./config.user
NOTSET_THEN_DEFAULT(BINDIR,/usr/local/bin)
NOTSET_THEN_DEFAULT(MANDIR,/usr/local/man/man1)
NOTSET_THEN_DEFAULT(MANEXT,1)
echo "$USER_DEFINES" >> defines.out])
dnl
dnl ************************************************
dnl
define([NOTSET_THEN_DEFAULT],
[test "[$]{$1+set}" = set || $1="$2"
AC_SUBST($1)])dnl
dnl
dnl ******************  sysV and solaris fpe checks ***********
dnl  
define(LOOK_FOR_FPE_SIGINFO,
[AC_CHECK_FUNC(sigaction, sigaction=1)
AC_CHECK_HEADER(siginfo.h,siginfo_h=1)
if test "$sigaction" = 1 && test "$siginfo_h" = 1 ; then
   XDEFINE(SV_SIGINFO)
else
   AC_CHECK_FUNC(sigvec,sigvec=1)
   if test "$sigvec" = 1 && ./fpe_check phoney_arg >> defines.out ; then :
   else XDEFINE(NOINFO_SIGFPE)
   fi
fi])
dnl
dnl
dnl ******** AC_PROG_CC with defaultout -g to cflags **************
dnl 
AC_DEFUN([PROG_CC_NO_MINUS_G_NONSENSE],
[AC_BEFORE([$0], [AC_PROG_CPP])dnl
AC_CHECK_PROG(CC, gcc, gcc, cc)
dnl
AC_MSG_CHECKING(whether we are using GNU C)
AC_CACHE_VAL(ac_cv_prog_gcc,
[dnl The semicolon is to pacify NeXT's syntax-checking cpp.
cat > conftest.c <<EOF
#ifdef __GNUC__
  yes;
#endif
EOF
if ${CC-cc} -E conftest.c 2>&AC_FD_CC | egrep yes >/dev/null 2>&1; then
  ac_cv_prog_gcc=yes
else
  ac_cv_prog_gcc=no
fi])dnl
AC_MSG_RESULT($ac_cv_prog_gcc)
rm -f conftest*
])dnl
dnl
dnl ***********  dreaded fpe tests *************
dnl
define(DREADED_FPE_TESTS,
[if echo "$USER_DEFINES" | grep FPE_TRAPS_ON >/dev/null
then echo skipping fpe tests based on '$'USER_DEFINES
else
AC_TYPE_SIGNAL
[
echo checking handling of floating point exceptions
rm -f fpe_check
$CC $CFLAGS -DRETSIGTYPE=$ac_cv_type_signal -o fpe_check fpe_check.c $MATHLIB
if test -f fpe_check  ; then
   ./fpe_check 2>/dev/null
   status=$?
else 
   echo fpe_check.c failed to compile 1>&2
   status=100
fi

case $status in
   0)  ;;  # good news do nothing
   3)      # reasonably good news]
XDEFINE(FPE_TRAPS_ON)
LOOK_FOR_FPE_SIGINFO ;;

   1|2|4)   # bad news have to turn off traps
	    # only know how to do this on systemV and solaris
AC_CHECK_HEADER(ieeefp.h, ieeefp_h=1)
AC_CHECK_FUNC(fpsetmask, fpsetmask=1)
[if test "$ieeefp_h" = 1 && test "$fpsetmask" = 1 ; then]
XDEFINE(FPE_TRAPS_ON)
XDEFINE(USE_IEEEFP_H)
XXDEFINE([TURN_ON_FPE_TRAPS()],
[fpsetmask(fpgetmask()|FP_X_DZ|FP_X_OFL)])
LOOK_FOR_FPE_SIGINFO 
# look for strtod overflow bug
AC_MSG_CHECKING([strtod bug on overflow])
rm -f fpe_check
$CC $CFLAGS -DRETSIGTYPE=$ac_cv_type_signal -DUSE_IEEEFP_H \
	    -o fpe_check fpe_check.c $MATHLIB
if ./fpe_check phoney_arg phoney_arg 2>/dev/null
then 
   AC_MSG_RESULT([no bug])
else
   AC_MSG_RESULT([buggy -- will use work around])
   XXDEFINE([HAVE_STRTOD_OVF_BUG],1)
fi

else
   [if test $status != 4 ; then]
      XDEFINE(FPE_TRAPS_ON)
      LOOK_FOR_FPE_SIGINFO 
    fi

    [case $status in
    1) 
cat 1>&2 <<'EOF'
Warning: Your system defaults generate floating point exception 
on divide by zero but not on overflow.  You need to 
#define TURN_ON_FPE_TRAPS() to handle overflow.
Please report this so I can fix this script to do it automatically.
EOF
;;
    2)
cat 1>&2 <<'EOF'
Warning: Your system defaults generate floating point exception 
on overflow  but not on divide by zero.  You need to 
#define TURN_ON_FPE_TRAPS() to handle divide by zero.
Please report this so I can fix this script to do it automatically.
EOF
;;
    4)
cat 1>&2 <<'EOF'
Warning: Your system defaults do not generate floating point
exceptions, but your math library does not support this behavior.
You need to
#define TURN_ON_FPE_TRAPS() to use fp exceptions for consistency.
Please report this so I can fix this script to do it automatically.
EOF
;;
    esac]
echo MIKE
[echo You can continue with the build and the resulting mawk will be
echo useable, but getting FPE_TRAPS_ON correct eventually is best.
fi  ;;

  *)  # some sort of disaster
cat 1>&2 <<'EOF'
The program `fpe_check' compiled from fpe_check.c seems to have
unexpectly blown up.  Please report this to ]MIKE.[
EOF
# quit or not ???
;;
esac 
rm -f fpe_check  # whew!!]
fi])
