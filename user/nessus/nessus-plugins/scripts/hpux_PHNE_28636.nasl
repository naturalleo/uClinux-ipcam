#
# (C) Tenable Network Security
#

if ( ! defined_func("bn_random") ) exit(0);
if(description)
{
 script_id(17417);
 script_version ("$Revision: 1.3 $");

 name["english"] = "HP-UX Security patch : PHNE_28636";
 
 script_name(english:name["english"]);
 
 desc["english"] = '
The remote host is missing HP-UX Security Patch number PHNE_28636 .
(SSRT3451 Potential Security Vulnerability in HP-UX network drivers (Data Leakage)

Solution : ftp://ftp.itrc.hp.com/hp-ux_patches/s700_800/11.X/PHNE_28636
See also : HPUX security bulletin 261
Risk factor : High';

 script_description(english:desc["english"]);
 
 summary["english"] = "Checks for patch PHNE_28636";
 script_summary(english:summary["english"]);
 
 script_category(ACT_GATHER_INFO);
 
 script_copyright(english:"This script is Copyright (C) 2006 Tenable Network Security");
 family["english"] = "HP-UX Local Security Checks";
 script_family(english:family["english"]);
 
 script_dependencies("ssh_get_info.nasl");
 script_require_keys("Host/HP-UX/swlist");
 exit(0);
}

include("hpux.inc");

if ( ! hpux_check_ctx ( ctx:"700:11.00 800:11.00 " ) )
{
 exit(0);
}

if ( hpux_patch_installed (patches:"PHNE_28636 ") )
{
 exit(0);
}

if ( hpux_check_patch( app:"100BT-EISA-KRN.100BT-KRN", version:"B.11.00.01") )
{
 security_hole(0);
 exit(0);
}
if ( hpux_check_patch( app:"100BT-EISA-KRN.100BT-KRN", version:"B.11.00.02") )
{
 security_hole(0);
 exit(0);
}
if ( hpux_check_patch( app:"100BT-EISA-KRN.100BT-KRN", version:"B.11.00.03") )
{
 security_hole(0);
 exit(0);
}
if ( hpux_check_patch( app:"100BT-EISA-KRN.100BT-KRN", version:"B.11.00.04") )
{
 security_hole(0);
 exit(0);
}
if ( hpux_check_patch( app:"100BT-EISA-RUN.100BT-RUN", version:"B.11.00.01") )
{
 security_hole(0);
 exit(0);
}
if ( hpux_check_patch( app:"100BT-EISA-RUN.100BT-RUN", version:"B.11.00.02") )
{
 security_hole(0);
 exit(0);
}
if ( hpux_check_patch( app:"100BT-EISA-RUN.100BT-RUN", version:"B.11.00.03") )
{
 security_hole(0);
 exit(0);
}
if ( hpux_check_patch( app:"100BT-EISA-RUN.100BT-RUN", version:"B.11.00.04") )
{
 security_hole(0);
 exit(0);
}
if ( hpux_check_patch( app:"100BT-EISA-RUN.100BT-INIT", version:"B.11.00.01") )
{
 security_hole(0);
 exit(0);
}
if ( hpux_check_patch( app:"100BT-EISA-RUN.100BT-INIT", version:"B.11.00.02") )
{
 security_hole(0);
 exit(0);
}
if ( hpux_check_patch( app:"100BT-EISA-RUN.100BT-INIT", version:"B.11.00.03") )
{
 security_hole(0);
 exit(0);
}
if ( hpux_check_patch( app:"100BT-EISA-RUN.100BT-INIT", version:"B.11.00.04") )
{
 security_hole(0);
 exit(0);
}
if ( hpux_check_patch( app:"100BT-EISA-FMT.100BT-FORMAT", version:"B.11.00.01") )
{
 security_hole(0);
 exit(0);
}
if ( hpux_check_patch( app:"100BT-EISA-FMT.100BT-FORMAT", version:"B.11.00.02") )
{
 security_hole(0);
 exit(0);
}
if ( hpux_check_patch( app:"100BT-EISA-FMT.100BT-FORMAT", version:"B.11.00.03") )
{
 security_hole(0);
 exit(0);
}
if ( hpux_check_patch( app:"100BT-EISA-FMT.100BT-FORMAT", version:"B.11.00.04") )
{
 security_hole(0);
 exit(0);
}
