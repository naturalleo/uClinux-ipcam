#
# This script was written by Renaud Deraison <deraison@cvs.nessus.org>
#
# See the Nessus Scripts License for details
#

if(description)
{
 script_id(10217);
 script_version ("$Revision: 1.11 $");
 
 name["english"] = "keyserv service";
 name["francais"] = "Service keyserv";
 script_name(english:name["english"], francais:name["francais"]);
 
 desc["english"] = "
The keyserv RPC service is running. 
If you do not use this service, then
disable it as it may become a security
threat in the future, if a vulnerability
is discovered.

This service is necessary to exploit
some holes in RPC services like
yppupdated.

Risk factor : Low / Medium";


 desc["francais"] = "
Le service RPC keyserv tourne.
Si vous ne l'utilisez pas, alors
d�sactivez-le puisqu'il risque de
devenir un jour une faille de 
s�curit� si une vulnerabilit� 
est trouv�e.

Ce service est n�c�ssaire pour
exploiter certains trous
de s�curit� tels que celui
de ypupdated.

Facteur de risque : Faible/Moyen";


 script_description(english:desc["english"], francais:desc["francais"]);
 
 summary["english"] = "checks the presence of a RPC service";
 summary["francais"] = "v�rifie la pr�sence d'un service RPC";
 script_summary(english:summary["english"], francais:summary["francais"]);
 
 script_category(ACT_GATHER_INFO);
 
 
 script_copyright(english:"This script is Copyright (C) 1999 Renaud Deraison",
		francais:"Ce script est Copyright (C) 1999 Renaud Deraison");
 family["english"] = "RPC"; 
 family["francais"] = "RPC";
 script_family(english:family["english"], francais:family["francais"]);
 script_dependencie("rpc_portmap.nasl");
 script_require_keys("rpc/portmap");
 exit(0);
}

#
# The script code starts here
#

include("misc_func.inc");
include('global_settings.inc');

if ( report_paranoia < 2 ) exit(0);



RPC_PROG = 100029;
tcp = 0;
port = get_rpc_port(program:RPC_PROG, protocol:IPPROTO_UDP);
if(!port){
	port = get_rpc_port(program:RPC_PROG, protocol:IPPROTO_TCP);
	tcp = 1;
	}

if(port)
{
 if(tcp)security_warning(port);
 else security_warning(port, protocol:"udp");
}
