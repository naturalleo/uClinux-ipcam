#
# (C) Tenable Network Security
#
# This plugin text was extracted from Mandrake Linux Security Advisory MDKSA-2006:030
#


if ( ! defined_func("bn_random") ) exit(0);
if(description)
{
 script_id(20851);
 script_version ("$Revision: 1.1 $");
 script_cve_id("CVE-2006-0301");
 
 name["english"] = "MDKSA-2006:030: poppler";
 
 script_name(english:name["english"]);
 
 desc["english"] = "
The remote host is missing the patch for the advisory MDKSA-2006:030 (poppler).



Heap-based buffer overflow in Splash.cc in xpdf allows attackers to cause a
denial of service and possibly execute arbitrary code via crafted splash images
that produce certain values that exceed the width or height of the associated
bitmap. Poppler uses a copy of the xpdf code and as such has the same issues.
The updated packages have been patched to correct this issue.



Solution : http://wwwnew.mandriva.com/security/advisories?name=MDKSA-2006:030
Risk factor : High";



 script_description(english:desc["english"]);
 
 summary["english"] = "Check for the version of the poppler package";
 script_summary(english:summary["english"]);
 
 script_category(ACT_GATHER_INFO);
 
 script_copyright(english:"This script is Copyright (C) 2006 Tenable Network Security");
 family["english"] = "Mandrake Local Security Checks";
 script_family(english:family["english"]);
 
 script_dependencies("ssh_get_info.nasl");
 script_require_keys("Host/Mandrake/rpm-list");
 exit(0);
}

include("rpm.inc");
if ( rpm_check( reference:"libpoppler0-0.4.1-3.2.20060mdk", release:"MDK2006.0", yank:"mdk") )
{
 security_hole(0);
 exit(0);
}
if ( rpm_check( reference:"libpoppler0-devel-0.4.1-3.2.20060mdk", release:"MDK2006.0", yank:"mdk") )
{
 security_hole(0);
 exit(0);
}
if ( rpm_check( reference:"libpoppler-qt0-0.4.1-3.2.20060mdk", release:"MDK2006.0", yank:"mdk") )
{
 security_hole(0);
 exit(0);
}
if ( rpm_check( reference:"libpoppler-qt0-devel-0.4.1-3.2.20060mdk", release:"MDK2006.0", yank:"mdk") )
{
 security_hole(0);
 exit(0);
}
if (rpm_exists(rpm:"poppler-", release:"MDK2006.0") )
{
 set_kb_item(name:"CVE-2006-0301", value:TRUE);
}
