#
# (C) Tenable Network Security
#

if ( ! defined_func("bn_random") ) exit(0);
if(description)
{
 script_id(17093);
 script_version ("$Revision: 1.2 $");

 name["english"] = "HP-UX Security patch : PHSS_16151";
 
 script_name(english:name["english"]);
 
 desc["english"] = '
The remote host is missing HP-UX Security Patch number PHSS_16151 .
(Security Vulnerability in dtmail/rpc.ttdbserverd on HP-UX)

Solution : ftp://ftp.itrc.hp.com/hp-ux_patches/s700_800/10.X/PHSS_16151
See also : HPUX security bulletin 084
Risk factor : High';

 script_description(english:desc["english"]);
 
 summary["english"] = "Checks for patch PHSS_16151";
 script_summary(english:summary["english"]);
 
 script_category(ACT_GATHER_INFO);
 
 script_copyright(english:"This script is Copyright (C) 2005 Tenable Network Security");
 family["english"] = "HP-UX Local Security Checks";
 script_family(english:family["english"]);
 
 script_dependencies("ssh_get_info.nasl");
 script_require_keys("Host/HP-UX/swlist");
 exit(0);
}

include("hpux.inc");

if ( ! hpux_check_ctx ( ctx:"800:10.30 700:10.30 " ) )
{
 exit(0);
}

if ( hpux_patch_installed (patches:"PHSS_16151 ") )
{
 exit(0);
}

if ( hpux_check_patch( app:"CDE.CDE-MIN", version:NULL) )
{
 security_hole(0);
 exit(0);
}
if ( hpux_check_patch( app:"CDE.CDE-RUN", version:NULL) )
{
 security_hole(0);
 exit(0);
}
if ( hpux_check_patch( app:"CDE.CDE-SHLIBS", version:NULL) )
{
 security_hole(0);
 exit(0);
}
if ( hpux_check_patch( app:"CDE.CDE-HELP-RUN", version:NULL) )
{
 security_hole(0);
 exit(0);
}
if ( hpux_check_patch( app:"CDE.CDE-DTTERM", version:NULL) )
{
 security_hole(0);
 exit(0);
}
if ( hpux_check_patch( app:"CDE.CDE-ENG-A-MAN", version:NULL) )
{
 security_hole(0);
 exit(0);
}
