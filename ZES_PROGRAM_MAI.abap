*&---------------------------------------------------------------------*
*&  Include           ZES_PROGRAM_MAI
*&---------------------------------------------------------------------*

START-OF-SELECTION. "Luego de presionar F8 / Ejecutar

  PERFORM init.
  CHECK gs_invalid IS INITIAL.
  PERFORM get_data.
  PERFORM process.
  PERFORM alv_display.

END-OF-SELECTION.