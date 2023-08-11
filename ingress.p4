    /***************** M A T C H - A C T I O N  *********************/

control Ingress(
    /* User */
    inout my_ingress_headers_t                       hdr,
    inout my_ingress_metadata_t                      meta,
    /* Intrinsic */
    in    ingress_intrinsic_metadata_t               ig_intr_md,
    in    ingress_intrinsic_metadata_from_parser_t   ig_prsr_md,
    inout ingress_intrinsic_metadata_for_deparser_t  ig_dprsr_md,
    inout ingress_intrinsic_metadata_for_tm_t        ig_tm_md)
{
    action send(PortId_t port) {
        ig_tm_md.ucast_egress_port = port;
        ig_tm_md.bypass_egress     = 1;
    }

    action drop() {
        ig_dprsr_md.drop_ctl = 1;
    }

    table ipv4_host {
        key = { hdr.ipv4.dst_addr : exact; }
        actions = {
            send; drop;
#ifdef ONE_STAGE
            @defaultonly NoAction;
#endif /* ONE_STAGE */
        }

#ifdef ONE_STAGE
        const default_action = NoAction();
#endif /* ONE_STAGE */

        size = IPV4_HOST_SIZE;
    }

#ifdef USE_ALPM
    @alpm(1)
    @alpm_partitions(2048)
#endif
    table ipv4_lpm {
        key     = { hdr.ipv4.dst_addr : lpm; }
        actions = { send; drop; }

        default_action = send(64);
        size           = IPV4_LPM_SIZE;
    }

    apply {
        if (hdr.ipv4.isValid()) {
            if (!ipv4_host.apply().hit) {
                ipv4_lpm.apply();
            }
        }
    }
}
