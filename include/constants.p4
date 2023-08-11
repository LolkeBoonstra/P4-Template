/*************************************************************************
 ************* C O N S T A N T S    A N D   T Y P E S  *******************
**************************************************************************/
const bit<16> ETHERTYPE_TPID = 0x8100;
const bit<16> ETHERTYPE_IPV4 = 0x0800;

/* Table Sizes */
const int IPV4_HOST_SIZE = 65536;

#ifdef USE_ALPM
const int IPV4_LPM_SIZE  = 400*1024;
#else
const int IPV4_LPM_SIZE  = 12288;
#endif
