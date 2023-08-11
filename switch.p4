/* -*- P4_16 -*- */

#include <core.p4>
#include <tna.p4>

#include <include/constants.p4>
#include <include/headers.p4>

/*************************************************************************
 **************  I N G R E S S   P R O C E S S I N G   *******************
 *************************************************************************/

#include <include/ingress-types.p4>

#include <ingress-parser.p4>

#include <ingress.p4>

#include <ingress-parser.p4>

 /*************************************************************************
 ****************  E G R E S S   P R O C E S S I N G   *******************
 *************************************************************************/
#include <include/egress-types.p4>

#include <egress-parser.p4>

#include <egress.p4>

#include <egress-deparser.p4>

/************ F I N A L   P A C K A G E ******************************/
Pipeline(
    IngressParser(),
    Ingress(),
    IngressDeparser(),
    EgressParser(),
    Egress(),
    EgressDeparser()
) pipe;

Switch(pipe) main;
