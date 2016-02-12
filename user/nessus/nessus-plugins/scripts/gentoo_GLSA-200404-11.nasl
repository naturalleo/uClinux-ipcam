# This script was automatically generated from 
#  http://www.gentoo.org/security/en/glsa/glsa-200404-11.xml
# It is released under the Nessus Script Licence.
# The messages are release under the Creative Commons - Attribution /
# Share Alike license. See http://creativecommons.org/licenses/by-sa/2.0/
#
# Avisory is copyright 2001-2005 Gentoo Foundation, Inc.
# GLSA2nasl Convertor is copyright 2004 Michel Arboi <mikhail@nessus.org>

if (! defined_func('bn_random')) exit(0);

if (description)
{
 script_id(14476);
 script_version("$Revision: 1.3 $");
 script_xref(name: "GLSA", value: "200404-11");
 script_cve_id("CVE-2004-0097");

 desc = 'The remote host is affected by the vulnerability described in GLSA-200404-11
(Multiple Vulnerabilities in pwlib)


    Multiple vulnerabilities have been found in the implimentation of protocol
    H.323 contained in pwlib. Most of the vulnerabilies are in the parsing of
    ASN.1 elements which would allow an attacker to use a maliciously crafted
    ASN.1 element to cause unpredictable behavior in pwlib.
  
Impact

    An attacker may cause a denial of service condition or cause a buffer
    overflow that would allow arbitrary code to be executed with root
    privileges.
  
Workaround

    Blocking ports 1719 and 1720 may reduce the likelihood of an attack. All
    users are advised to upgrade to the latest version of the affected package.
  
References:
    http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2004-0097
    http://www.uniras.gov.uk/vuls/2004/006489/h323.htm


Solution: 
    All pwlib users are advised to upgrade to version 1.5.2-r3 or later:
    # emerge sync
    # emerge -pv ">=dev-libs/pwlib-1.5.2-r3"
    # emerge ">=dev-libs/pwlib-1.5.2-r3"
  

Risk factor : High
';
 script_description(english: desc);
 script_copyright(english: "(C) 2005 Michel Arboi <mikhail@nessus.org>");
 script_name(english: "[GLSA-200404-11] Multiple Vulnerabilities in pwlib");
 script_category(ACT_GATHER_INFO);
 script_family(english: "Gentoo Local Security Checks");
 script_dependencies("ssh_get_info.nasl");
 script_require_keys('Host/Gentoo/qpkg-list');
 script_summary(english: 'Multiple Vulnerabilities in pwlib');
 exit(0);
}

include('qpkg.inc');
if (qpkg_check(package: "dev-libs/pwlib", unaffected: make_list("ge 1.5.2-r3"), vulnerable: make_list("le 1.5.2-r2")
)) { security_hole(0); exit(0); }
