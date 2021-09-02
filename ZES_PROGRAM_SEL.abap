*&---------------------------------------------------------------------*
*&  Include           ZES_PROGRAM_SEL
*&---------------------------------------------------------------------*


SELECTION-SCREEN BEGIN OF BLOCK b_1 WITH FRAME TITLE text-001.

SELECT-OPTIONS: s_bukrs FOR bkpf-bukrs OBLIGATORY,
                s_belnr FOR bkpf-belnr,
                s_budat FOR bkpf-budat OBLIGATORY,
                s_gjahr FOR bkpf-gjahr OBLIGATORY.

SELECTION-SCREEN END OF BLOCK b_1.