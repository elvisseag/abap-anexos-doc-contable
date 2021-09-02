*&---------------------------------------------------------------------*
*&  Include           ZES_PROGRAM_F01
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Form  INIT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM init .

  CLEAR: gs_invalid.
  REFRESH: gtd_t001.

  SELECT bukrs INTO TABLE gtd_t001
    FROM t001
    WHERE bukrs IN s_bukrs.

  LOOP AT gtd_t001 ASSIGNING <fs_t001>.
    AUTHORITY-CHECK OBJECT 'F_BKPF_BUK'
    ID 'BUKRS' FIELD <fs_t001>-bukrs.
    IF sy-subrc NE 0.
      MESSAGE s000(zfi) WITH 'No tiene autorización para ingresar a la Sociedad ' <fs_t001>-bukrs DISPLAY LIKE 'E'.
      gs_invalid = 'X'.
      EXIT.
    ENDIF.
  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  GET_DATA
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM get_data .

  DATA: ln_longitud(2) TYPE n.

*  SELECT * INTO TABLE gtd_bkpf
  SELECT bukrs belnr gjahr budat bldat cpudt blart xblnr usnam awkey
    INTO CORRESPONDING FIELDS OF TABLE gtd_bkpf
    FROM bkpf
    WHERE bukrs IN s_bukrs
      AND belnr IN s_belnr
      AND budat IN s_budat
      AND gjahr IN s_gjahr.

  LOOP AT gtd_bkpf ASSIGNING <fs_bkpf>.
    CONCATENATE <fs_bkpf>-bukrs <fs_bkpf>-belnr <fs_bkpf>-gjahr INTO <fs_bkpf>-inst.
    <fs_bkpf>-inst2 = <fs_bkpf>-awkey.
  ENDLOOP.

  IF gtd_bkpf[] IS NOT INITIAL.

    REFRESH gtd_srgbtbrel.

    SELECT instid_a instid_b
      INTO CORRESPONDING FIELDS OF TABLE gtd_srgbtbrel
      FROM srgbtbrel FOR ALL ENTRIES IN gtd_bkpf
      WHERE instid_a = gtd_bkpf-inst.

    SELECT instid_a instid_b
      APPENDING CORRESPONDING FIELDS OF TABLE gtd_srgbtbrel
      FROM srgbtbrel FOR ALL ENTRIES IN gtd_bkpf
      WHERE instid_a = gtd_bkpf-inst2.

    LOOP AT gtd_srgbtbrel ASSIGNING <fs_srgbtbrel>.
      CONDENSE <fs_srgbtbrel>-instid_b.
      IF <fs_srgbtbrel>-instid_b IS NOT INITIAL.
        ln_longitud = strlen( <fs_srgbtbrel>-instid_b ).

        IF ln_longitud GE 34.
          <fs_srgbtbrel>-objtp = <fs_srgbtbrel>-instid_b+17(3).
          <fs_srgbtbrel>-objyr = <fs_srgbtbrel>-instid_b+20(2).
          <fs_srgbtbrel>-objno = <fs_srgbtbrel>-instid_b+22(12).
        ENDIF.

      ENDIF.
    ENDLOOP.
*
  ENDIF.


  IF gtd_srgbtbrel[] IS NOT INITIAL.

    SELECT objtp objyr objno
           objdes file_ext cronam crdat
      INTO CORRESPONDING FIELDS OF TABLE gtd_sood
      FROM sood FOR ALL ENTRIES IN gtd_srgbtbrel
      WHERE objtp = gtd_srgbtbrel-objtp
        AND objyr = gtd_srgbtbrel-objyr
        AND objno = gtd_srgbtbrel-objno.

  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  PROCESS
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM process .

  DATA: ls_value.

  CLEAR ls_value.

  LOOP AT gtd_bkpf ASSIGNING <fs_bkpf>.

    READ TABLE gtd_srgbtbrel ASSIGNING <fs_srgbtbrel> WITH KEY instid_a = <fs_bkpf>-inst.
    IF sy-subrc EQ 0.

      LOOP AT gtd_srgbtbrel ASSIGNING <fs_srgbtbrel> WHERE instid_a = <fs_bkpf>-inst.

        READ TABLE gtd_sood ASSIGNING <fs_sood> WITH KEY objtp = <fs_srgbtbrel>-objtp
                                                         objyr = <fs_srgbtbrel>-objyr
                                                         objno = <fs_srgbtbrel>-objno.
        IF sy-subrc EQ 0.

          ls_value = 'X'.

          APPEND INITIAL LINE TO gtd_report ASSIGNING <fs_report>.
          <fs_report>-bukrs    = <fs_bkpf>-bukrs.
          <fs_report>-belnr    = <fs_bkpf>-belnr.
          <fs_report>-gjahr    = <fs_bkpf>-gjahr.
          <fs_report>-budat    = <fs_bkpf>-budat.
          <fs_report>-bldat    = <fs_bkpf>-bldat.
          <fs_report>-cpudt    = <fs_bkpf>-cpudt.
          <fs_report>-blart    = <fs_bkpf>-blart.
          <fs_report>-xblnr    = <fs_bkpf>-xblnr.
          <fs_report>-usnam    = <fs_bkpf>-usnam.
          <fs_report>-objdes   = <fs_sood>-objdes.
          <fs_report>-file_ext = <fs_sood>-file_ext.
          <fs_report>-cronam   = <fs_sood>-cronam.
          <fs_report>-crdat    = <fs_sood>-crdat.
        ENDIF.

      ENDLOOP.

    ENDIF.

    READ TABLE gtd_srgbtbrel ASSIGNING <fs_srgbtbrel> WITH KEY instid_a = <fs_bkpf>-inst2.
    IF sy-subrc EQ 0.

      LOOP AT gtd_srgbtbrel ASSIGNING <fs_srgbtbrel> WHERE instid_a = <fs_bkpf>-inst2.

        READ TABLE gtd_sood ASSIGNING <fs_sood> WITH KEY objtp = <fs_srgbtbrel>-objtp
                                                         objyr = <fs_srgbtbrel>-objyr
                                                         objno = <fs_srgbtbrel>-objno.
        IF sy-subrc EQ 0.

          ls_value = 'X'.

          APPEND INITIAL LINE TO gtd_report ASSIGNING <fs_report>.
          <fs_report>-bukrs    = <fs_bkpf>-bukrs.
          <fs_report>-belnr    = <fs_bkpf>-belnr.
          <fs_report>-gjahr    = <fs_bkpf>-gjahr.
          <fs_report>-budat    = <fs_bkpf>-budat.
          <fs_report>-bldat    = <fs_bkpf>-bldat.
          <fs_report>-cpudt    = <fs_bkpf>-cpudt.
          <fs_report>-blart    = <fs_bkpf>-blart.
          <fs_report>-xblnr    = <fs_bkpf>-xblnr.
          <fs_report>-usnam    = <fs_bkpf>-usnam.
          <fs_report>-objdes   = <fs_sood>-objdes.
          <fs_report>-file_ext = <fs_sood>-file_ext.
          <fs_report>-cronam   = <fs_sood>-cronam.
          <fs_report>-crdat    = <fs_sood>-crdat.
        ENDIF.

      ENDLOOP.

    ENDIF.

    IF ls_value IS INITIAL.

      APPEND INITIAL LINE TO gtd_report ASSIGNING <fs_report>.
      <fs_report>-bukrs = <fs_bkpf>-bukrs.
      <fs_report>-belnr = <fs_bkpf>-belnr.
      <fs_report>-gjahr = <fs_bkpf>-gjahr.
      <fs_report>-budat = <fs_bkpf>-budat.
      <fs_report>-bldat = <fs_bkpf>-bldat.
      <fs_report>-cpudt = <fs_bkpf>-cpudt.
      <fs_report>-blart = <fs_bkpf>-blart.
      <fs_report>-xblnr = <fs_bkpf>-xblnr.
      <fs_report>-usnam = <fs_bkpf>-usnam.

    ENDIF.

  ENDLOOP.

  DELETE ADJACENT DUPLICATES FROM gtd_report COMPARING ALL FIELDS.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  ALV_DISPLAY
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM alv_display .

  IF gtd_report[] IS NOT INITIAL.

    PERFORM build_fieldcat.
    PERFORM build_layout.

    CALL FUNCTION 'REUSE_ALV_GRID_DISPLAY'
      EXPORTING
        i_grid_title  = 'Listado de Anexos por Documento'
        is_layout     = gwa_layout
        it_fieldcat   = gtd_fieldcat
      TABLES
        t_outtab      = gtd_report
      EXCEPTIONS
        program_error = 1
        OTHERS        = 2.
    IF sy-subrc <> 0.
      WRITE 'Exception error'.
    ENDIF.

  ELSE.
    MESSAGE s000(zfi) WITH 'No hay datos para mostrar.'.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  BUILD_FIELDCAT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM build_fieldcat .

  CLEAR: gwa_fieldcat.
  gwa_fieldcat-tabname       = 'GTD_REPORT'.
  gwa_fieldcat-fieldname     = 'BUKRS'.
  gwa_fieldcat-ref_tabname   = 'BKPF'.
  gwa_fieldcat-ref_fieldname = 'BUKRS'.
  gwa_fieldcat-outputlen     = 8.
  APPEND gwa_fieldcat TO gtd_fieldcat.

  CLEAR: gwa_fieldcat.
  gwa_fieldcat-tabname       = 'GTD_REPORT'.
  gwa_fieldcat-fieldname     = 'BELNR'.
  gwa_fieldcat-ref_tabname   = 'BKPF'.
  gwa_fieldcat-ref_fieldname = 'BELNR'.
  APPEND gwa_fieldcat TO gtd_fieldcat.

  CLEAR: gwa_fieldcat.
  gwa_fieldcat-tabname       = 'GTD_REPORT'.
  gwa_fieldcat-fieldname     = 'GJAHR'.
  gwa_fieldcat-ref_tabname   = 'BKPF'.
  gwa_fieldcat-ref_fieldname = 'GJAHR'.
  gwa_fieldcat-outputlen     = 6.
  APPEND gwa_fieldcat TO gtd_fieldcat.

  CLEAR: gwa_fieldcat.
  gwa_fieldcat-tabname       = 'GTD_REPORT'.
  gwa_fieldcat-fieldname     = 'BUDAT'.
  gwa_fieldcat-ref_tabname   = 'BKPF'.
  gwa_fieldcat-ref_fieldname = 'BUDAT'.
  APPEND gwa_fieldcat TO gtd_fieldcat.

  CLEAR: gwa_fieldcat.
  gwa_fieldcat-tabname       = 'GTD_REPORT'.
  gwa_fieldcat-fieldname     = 'BLDAT'.
  gwa_fieldcat-ref_tabname   = 'BKPF'.
  gwa_fieldcat-ref_fieldname = 'BLDAT'.
  APPEND gwa_fieldcat TO gtd_fieldcat.

  CLEAR: gwa_fieldcat.
  gwa_fieldcat-tabname       = 'GTD_REPORT'.
  gwa_fieldcat-fieldname     = 'CPUDT'.
  gwa_fieldcat-ref_tabname   = 'BKPF'.
  gwa_fieldcat-ref_fieldname = 'CPUDT'.
  APPEND gwa_fieldcat TO gtd_fieldcat.

  CLEAR: gwa_fieldcat.
  gwa_fieldcat-tabname       = 'GTD_REPORT'.
  gwa_fieldcat-fieldname     = 'BLART'.
  gwa_fieldcat-ref_tabname   = 'BKPF'.
  gwa_fieldcat-ref_fieldname = 'BLART'.
  gwa_fieldcat-outputlen     = 6.
  APPEND gwa_fieldcat TO gtd_fieldcat.

  CLEAR: gwa_fieldcat.
  gwa_fieldcat-tabname       = 'GTD_REPORT'.
  gwa_fieldcat-fieldname     = 'XBLNR'.
  gwa_fieldcat-ref_tabname   = 'BKPF'.
  gwa_fieldcat-ref_fieldname = 'XBLNR'.
  APPEND gwa_fieldcat TO gtd_fieldcat.

  CLEAR: gwa_fieldcat.
  gwa_fieldcat-tabname       = 'GTD_REPORT'.
  gwa_fieldcat-fieldname     = 'USNAM'.
  gwa_fieldcat-ref_tabname   = 'BKPF'.
  gwa_fieldcat-ref_fieldname = 'USNAM'.
  APPEND gwa_fieldcat TO gtd_fieldcat.

  CLEAR: gwa_fieldcat.
  gwa_fieldcat-tabname       = 'GTD_REPORT'.
  gwa_fieldcat-fieldname     = 'OBJDES'.
  gwa_fieldcat-ref_tabname   = 'SOOD'.
  gwa_fieldcat-ref_fieldname = 'OBJDES'.
  APPEND gwa_fieldcat TO gtd_fieldcat.

  CLEAR: gwa_fieldcat.
  gwa_fieldcat-tabname       = 'GTD_REPORT'.
  gwa_fieldcat-fieldname     = 'FILE_EXT'.
  gwa_fieldcat-ref_tabname   = 'SOOD'.
  gwa_fieldcat-ref_fieldname = 'FILE_EXT'.
  gwa_fieldcat-outputlen     = 6.
  APPEND gwa_fieldcat TO gtd_fieldcat.

  CLEAR: gwa_fieldcat.
  gwa_fieldcat-tabname       = 'GTD_REPORT'.
  gwa_fieldcat-fieldname     = 'CRONAM'.
  gwa_fieldcat-ref_tabname   = 'SOOD'.
  gwa_fieldcat-ref_fieldname = 'CRONAM'.
  APPEND gwa_fieldcat TO gtd_fieldcat.

  CLEAR: gwa_fieldcat.
  gwa_fieldcat-tabname       = 'GTD_REPORT'.
  gwa_fieldcat-fieldname     = 'CRDAT'.
  gwa_fieldcat-ref_tabname   = 'SOOD'.
  gwa_fieldcat-ref_fieldname = 'CRDAT'.
  APPEND gwa_fieldcat TO gtd_fieldcat.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  BUILD_LAYOUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM build_layout .

  CLEAR: gwa_layout.
  gwa_layout-zebra = 'X'.

ENDFORM.