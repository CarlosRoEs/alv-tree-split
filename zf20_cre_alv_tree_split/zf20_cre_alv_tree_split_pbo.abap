*----------------------------------------------------------------------*
***INCLUDE ZF20_CRE_ALV_TREE_SPLIT_PBO.
*----------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Module  STATUS_9000  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE status_9000 OUTPUT.
  SET PF-STATUS 'STATUS_9000'.
*  SET TITLEBAR 'xxx'.

ENDMODULE.                 " STATUS_9000  OUTPUT

*&---------------------------------------------------------------------*
*&      Module  CREAR_OBJETOS  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE crear_objetos OUTPUT.

  CONSTANTS: lc_cont_split TYPE c VALUE 'CONTAINER_SPLIT' LENGTH 15.

  DATA: lv_result TYPE i.

  go_container = NEW cl_gui_custom_container(
*      parent                      =
      container_name              = lc_cont_split
*      style                       =
*      lifetime                    = LIFETIME_DEFAULT
*      repid                       =
*      dynnr                       =
*      no_autodef_progid_dynnr     =
).

  go_split = NEW cl_gui_splitter_container(
*    link_dynnr              =
*    link_repid              =
*    shellstyle              =
*    left                    =
*    top                     =
*    width                   =
*    height                  =
*    metric                  = CNTL_METRIC_DYNPRO
*    align                   = 15
      parent                  = go_container " Le asignamos el contenedor padre.
    rows                    = 1
    columns                 = 2
*    no_autodef_progid_dynnr =
*    name                    =
  ).

* Se obtiene el contenedor del split
  go_split->get_container(
    EXPORTING
      row       = 1
      column    = 1
    RECEIVING
      container = go_container_1 ).

* Se establece el ancho de la columna que va a contener el arbol.
  go_split->set_column_width(
    EXPORTING
      id                = 1
      width             = 22
    IMPORTING
      result            = lv_result
    EXCEPTIONS
      cntl_error        = 1
      cntl_system_error = 2
      OTHERS            = 3 ).
  IF sy-subrc NE 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
               WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

* Se obtiene el contenedor del ALV.
  go_split->get_container(
    EXPORTING
      row       = 1
      column    = 2
    RECEIVING
      container = go_container_2 ).

  go_tree = NEW cl_simple_tree_model(
      node_selection_mode         = cl_simple_tree_model=>node_sel_mode_single " Selección de nodo unico
*      hide_selection              =
  ).
  IF sy-subrc EQ 0.

  ENDIF.
  go_tree->create_tree_control(
    EXPORTING
*    lifetime                     =
      parent                       = go_container_1
*    shellstyle                   =
*  IMPORTING
*    control                      =
    EXCEPTIONS
      lifetime_error               = 1
      cntl_system_error            = 2
      create_error                 = 3
      failed                       = 4
      tree_control_already_created = 5
      OTHERS                       = 6
  ).
  IF sy-subrc NE 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
               WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.

  go_alv2 = NEW cl_gui_alv_grid(
*    i_shellstyle      = 0
*    i_lifetime        =
      i_parent          = go_container_2
*    i_appl_events     = SPACE
*    i_parentdbg       =
*    i_applogparent    =
*    i_graphicsparent  =
*    i_name            =
*    i_fcat_complete   = SPACE
  ).

  IF sy-subrc EQ 0.

  ENDIF.

ENDMODULE.                 " OBJECT_CREATION  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  REGISTRAR_EVENTOS  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE registrar_eventos OUTPUT.

*  DATA: handler_tree TYPE REF TO lcl_event_handler.

  DATA: lt_events TYPE cntl_simple_events.

  DATA: ls_event LIKE LINE OF lt_events.

  CLEAR: lt_events.

  go_tree->get_registered_events(
    IMPORTING
      events = lt_events ).

  IF lt_events[] IS INITIAL.
    ls_event-eventid = cl_simple_tree_model=>eventid_node_double_click.
    APPEND ls_event TO lt_events.

  ENDIF.
  IF lt_events[] IS NOT INITIAL.
    go_tree->set_registered_events(
        EXPORTING
          events                    = lt_events
        EXCEPTIONS
          illegal_event_combination = 1
          unknown_event             = 2
          OTHERS                    = 3 ).
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

    DATA(handler_tree) = NEW lcl_event_handler( ).

    SET HANDLER handler_tree->evento_doble_click FOR go_tree.
  ENDIF.


ENDMODULE.                 " REGISTRAR_EVENTOS  OUTPUT
*&---------------------------------------------------------------------*
*&      Module  SALIDA_DATOS  OUTPUT
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
MODULE salida_datos OUTPUT.

  CONSTANTS: lc_key  TYPE tm_nodekey VALUE 'ROOT',
             lc_text TYPE tm_nodetxt VALUE 'DOCUMENTOS'.

  DATA: ls_node TYPE treemsnodt.

* Se añade el nodo principal
  go_tree->add_node(
    EXPORTING
      node_key                = lc_key
*    relative_node_key       =
*    relationship            =
      isfolder                = rs_c_true
      text                    = lc_text
*    hidden                  =
*    disabled                =
*    style                   =
*    no_branch               =
      expander                = rs_c_on
*    image                   =
*    expanded_image          =
*    drag_drop_id            =
*    user_object             =
    EXCEPTIONS
      node_key_exists         = 1
      illegal_relationship    = 2
      relative_node_not_found = 3
      node_key_empty          = 4
      OTHERS                  = 5 ).

  IF sy-subrc NE 0.
    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
               WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
  ENDIF.


  LOOP AT gt_ekko ASSIGNING FIELD-SYMBOL(<fs_ekko>).

    ls_node-node_key = <fs_ekko>-ebeln.
    ls_node-text = | Documento de compra { <fs_ekko>-ebeln }|.

    go_tree->add_node(
      EXPORTING
        node_key                = ls_node-node_key
        relative_node_key       = lc_key
        relationship            = cl_simple_tree_model=>relat_last_child
        isfolder                = rs_c_true
        text                    = ls_node-text
*    hidden                  =
*    disabled                =
*    style                   =
*    no_branch               =
      expander                = rs_c_true
*    image                   =
*    expanded_image          =
*    drag_drop_id            =
*    user_object             =
      EXCEPTIONS
        node_key_exists         = 1
        illegal_relationship    = 2
        relative_node_not_found = 3
        node_key_empty          = 4
        OTHERS                  = 5 ).

    IF sy-subrc NE 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.
  ENDLOOP.



  LOOP AT gt_ekpo ASSIGNING FIELD-SYMBOL(<fs_ekpo>).

    ls_node-node_key = |{ <fs_ekpo>-ebeln } { <fs_ekpo>-ebelp }|.
    ls_node-relatkey = <fs_ekpo>-ebeln.


    ls_node-text = |{ <fs_ekpo>-ebelp } { <fs_ekpo>-txz01 }|.

    go_tree->add_node(
      EXPORTING
        node_key                = ls_node-node_key
        relative_node_key       = ls_node-relatkey
        relationship            = cl_simple_tree_model=>relat_last_child
        isfolder                = rs_c_false
        text                    = ls_node-text
*    hidden                  =
*    disabled                =
*    style                   =
*    no_branch               =
        expander                = rs_c_false
*    image                   =
*    expanded_image          =
*    drag_drop_id            =
*    user_object             =
      EXCEPTIONS
        node_key_exists         = 1
        illegal_relationship    = 2
        relative_node_not_found = 3
        node_key_empty          = 4
        OTHERS                  = 5 ).
    IF sy-subrc <> 0.
      MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                 WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
    ENDIF.

  ENDLOOP.

ENDMODULE.                 " SALIDA_DATOS  OUTPUT