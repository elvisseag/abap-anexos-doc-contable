*&---------------------------------------------------------------------*
*&  Include           ZES_PROGRAM_TOP
*&---------------------------------------------------------------------*

TABLES: bkpf.

TYPES:
  BEGIN OF gty_bkpf_cust,
    bukrs TYPE bkpf-bukrs,
    belnr TYPE bkpf-belnr,
    gjahr TYPE bkpf-gjahr,
    budat TYPE bkpf-budat,
    bldat TYPE bkpf-bldat,
    cpudt TYPE bkpf-cpudt,
    blart TYPE bkpf-blart,
    xblnr TYPE bkpf-xblnr,
    usnam TYPE bkpf-usnam,
    awkey TYPE bkpf-awkey,
    "
    inst  TYPE sibfboriid,
    inst2 TYPE sibfboriid,
  END OF gty_bkpf_cust,

  BEGIN OF gty_srgbtbrel_cust,
    instid_a  TYPE srgbtbrel-instid_a,
    instid_b  TYPE srgbtbrel-instid_b,
    objtp(3)  TYPE c,
    objyr(2)  TYPE c,
    objno(12) TYPE c,
  END OF gty_srgbtbrel_cust,

  BEGIN OF gty_sood_cust,
    objtp    TYPE sood-objtp,
    objyr    TYPE sood-objyr,
    objno    TYPE sood-objno,
    objdes   TYPE sood-objdes,
    file_ext TYPE sood-file_ext,
    cronam   TYPE sood-cronam,
    crdat    TYPE sood-crdat,
  END OF gty_sood_cust,

  BEGIN OF gty_report_cust,
    bukrs    TYPE bkpf-bukrs,
    belnr    TYPE bkpf-belnr,
    gjahr    TYPE bkpf-gjahr,
    budat    TYPE bkpf-budat,
    bldat    TYPE bkpf-bldat,
    cpudt    TYPE bkpf-cpudt,
    blart    TYPE bkpf-blart,
    xblnr    TYPE bkpf-xblnr,
    usnam    TYPE bkpf-usnam,
    objdes   TYPE sood-objdes,
    file_ext TYPE sood-file_ext,
    cronam   TYPE sood-cronam,
    crdat    TYPE sood-crdat,
  END OF gty_report_cust,

  BEGIN OF gty_t001_cust,
    bukrs TYPE t001-bukrs,
  END OF gty_t001_cust.

DATA: "gtd_bkpf TYPE STANDARD TABLE OF bkpf.
  gtd_bkpf      TYPE STANDARD TABLE OF gty_bkpf_cust,
  gtd_srgbtbrel TYPE STANDARD TABLE OF gty_srgbtbrel_cust,
  gtd_sood      TYPE STANDARD TABLE OF gty_sood_cust,
  gtd_report    TYPE STANDARD TABLE OF gty_report_cust,
  gtd_t001      TYPE STANDARD TABLE OF gty_t001_cust,
  gs_invalid.

FIELD-SYMBOLS: <fs_bkpf>      TYPE gty_bkpf_cust,
               <fs_srgbtbrel> TYPE gty_srgbtbrel_cust,
               <fs_sood>      TYPE gty_sood_cust,
               <fs_report>    TYPE gty_report_cust,
               <fs_t001>      TYPE gty_t001_cust.

DATA: gtd_fieldcat TYPE slis_t_fieldcat_alv,
      gwa_fieldcat TYPE slis_fieldcat_alv,
      gwa_layout   TYPE slis_layout_alv.