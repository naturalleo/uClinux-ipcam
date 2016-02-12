#ifndef NETFLASH_CHECK_H
#define NETFLASH_CHECK_H

struct check_opt {
	int dochecksum;
	int doversion;
	int dohardwareversion;
	int doremoveversion;
#ifdef CONFIG_USER_NETFLASH_SHA256
	int dosha256sum;
#endif
#ifdef CONFIG_USER_NETFLASH_HMACMD5
	char *hmacmd5key;
#endif
#ifdef CONFIG_USER_NETFLASH_CRYPTO_V3
	char *ca;
	char *crl;
#endif
};

void update_chksum(unsigned char *data, int length);
void chksum(void);
int check_version_info(int offset, int doversion, int dohardwareversion, int removeversion, int failifnoversion);
void check(const struct check_opt *opt);

#endif
