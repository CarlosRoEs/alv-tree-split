*&---------------------------------------------------------------------*
*&  Include           ZF20_CRE_ALV_TREE_SPLIT_CLS
*&---------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&                       Event Class
*&---------------------------------------------------------------------*
CLASS lcl_event_handler DEFINITION.
    PUBLIC SECTION.
      METHODS: evento_doble_click FOR EVENT node_double_click OF cl_simple_tree_model
      IMPORTING node_key sender.
  ENDCLASS.
  
  CLASS lcl_event_handler IMPLEMENTATION.
    METHOD: evento_doble_click.
  
      CONSTANTS: lc_structure TYPE dd02l-tabname VALUE 'zf20_cre_alv_tree'.
      " La tabla es de tipo (tm_nodekey)Tree Model: Clave de un nodo
      DATA: lt_hijos TYPE tm_nodekey,
            lt_alv   TYPE STANDARD TABLE OF zf20_cre_alv_tree.
  
      DATA: ls_alv LIKE LINE OF lt_alv.
  
      DATA: lv_ebeln TYPE ebeln,
            lv_ebelp TYPE ebelp.
  
      DATA: ls_layout TYPE lvc_s_layo.
  * 'SENDER' es un parametro implicito que proviene del ABAP Objects runtime system.
  * Contiene las referencias del objeto que dispara el evento.
  * Se usa para llamar al método de la instancia.
  
      sender->node_get_last_child(
        EXPORTING
          node_key       = node_key "Clave del nodo
        IMPORTING
          child_node_key = lt_hijos
        EXCEPTIONS
          node_not_found = 1
          OTHERS         = 2 ).
      IF sy-subrc NE 0.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                   WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  
      ENDIF.
      sender->expand_node(
        EXPORTING
          node_key            = node_key
  *            expand_predecessors =
  *            expand_subtree      =
          level_count         = 2 "Determina en el nivel del arbol donde se activa el evento double click
        EXCEPTIONS
          node_not_found      = 1
          OTHERS              = 2 ).
      IF sy-subrc <> 0.
        MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                   WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
      ENDIF.
  
  
      SPLIT node_key AT space INTO lv_ebeln lv_ebelp.
  
      lt_alv = gt_alv.
  
      CLEAR: lt_alv,
             ls_alv.
  
      LOOP AT gt_alv ASSIGNING FIELD-SYMBOL(<fs_alv>) WHERE ebeln = lv_ebeln.
        ls_alv-ebeln = <fs_alv>-ebeln.
        ls_alv-ebelp = <fs_alv>-ebelp.
        ls_alv-bukrs  = <fs_alv>-bukrs.
        ls_alv-bstyp = <fs_alv>-bstyp.
        ls_alv-aedat = <fs_alv>-aedat.
        ls_alv-lifnr = <fs_alv>-lifnr.
        ls_alv-ernam = <fs_alv>-ernam.
        ls_alv-txz01 = <fs_alv>-txz01.
        ls_alv-matnr = <fs_alv>-matnr.
        ls_alv-werks = <fs_alv>-werks.
        ls_alv-lgort = <fs_alv>-lgort.
        ls_alv-kunnr = <fs_alv>-kunnr.
        ls_alv-menge = <fs_alv>-menge.
        ls_alv-meins = <fs_alv>-meins.
  
        APPEND ls_alv TO lt_alv.
  
        CLEAR: ls_alv.
  
      ENDLOOP.
  
      IF lt_alv[] IS NOT INITIAL.
        ls_layout-grid_title = text-002.
        ls_layout-zebra      = rs_c_true.
        ls_layout-smalltitle = rs_c_false.
        ls_layout-cwidth_opt = rs_c_true.
  
        IF gv_display IS INITIAL.
  
          go_alv2->set_table_for_first_display(
                  EXPORTING
  *          i_buffer_active               =
  *          i_bypassing_buffer            =
  *          i_consistency_check           =
                    i_structure_name              = lc_structure
  *          is_variant                    =
  *          i_save                        =
  *          i_default                     = 'X'
                    is_layout                     = ls_layout
  *          is_print                      =
  *          it_special_groups             =
  *          it_toolbar_excluding          =
  *          it_hyperlink                  =
  *          it_alv_graphics               =
  *          it_except_qinfo               =
  *          ir_salv_adapter               =
                  CHANGING
                    it_outtab                     = lt_alv
  *          it_fieldcatalog               =
  *          it_sort                       =
  *          it_filter                     =
                  EXCEPTIONS
                    invalid_parameter_combination = 1
                    program_error                 = 2
                    too_many_lines                = 3
                    OTHERS                        = 4
                ).
          IF sy-subrc NE 0.
            MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                       WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
          ENDIF.
        ELSE.
          go_alv2->refresh_table_display(
  *          EXPORTING
  *            is_stable      =
  *            i_soft_refresh =
            EXCEPTIONS
              finished       = 1
              OTHERS         = 2 ).
  
          IF sy-subrc NE 0.
            MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                       WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDMETHOD.
  ENDCLASS