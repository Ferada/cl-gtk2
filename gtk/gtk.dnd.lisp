(in-package :gtk)

;;
(define-g-boxed-opaque target-list "GtkTargetList"
  :alloc (error "Use make-target-list to allocate GtkTargetList"))

(defcfun (gtk-target-list-new "gtk_target_list_new")
    (g-boxed-foreign target-list :free-from-foreign nil)
  (targets :pointer)
  (n-targets :int))

(defun make-target-list (targets)
  (with-foreign-boxed-array (n-targets targets-ptr target-entry targets)
    (gtk-target-list-new targets-ptr n-targets)))

(defcfun (gtk-target-list-ref "gtk_target_list_ref")
    (g-boxed-foreign target-list :free-from-foreign nil)
  (target-list (g-boxed-foreign target-list)))

(defcfun (gtk-target-list-unref "gtk_target_list_unref") :void
  (target-list (g-boxed-foreign target-list)))

(export (boxed-related-symbols 'target-list))

;;

(defcfun (gtk-drag-dest-set "gtk_drag_dest_set") :void
  (widget (g-object widget))
  (flags dest-defaults)
  (targets :pointer)
  (n-targets :int)
  (actions gdk-drag-action))

(defun drag-dest-set (widget flags targets actions)
  (if (eq targets nil)
      (gtk-drag-dest-set widget flags (null-pointer) 0 actions)
      (with-foreign-boxed-array (n-targets targets-ptr target-entry targets)
        (gtk-drag-dest-set widget flags targets-ptr n-targets actions))))

(export 'drag-dest-set)

(defcfun (drag-dest-unset "gtk_drag_dest_unset") :void
  (widget (g-object widget)))

(export 'drag-dest-unset)

(defcfun (drag-dest-add-text-targets "gtk_drag_dest_add_text_targets") :void
  (widget (g-object widget)))

(export 'drag-dest-add-text-targets)

(defcfun (drag-dest-add-image-targets "gtk_drag_dest_add_image_targets") :void
  (widget (g-object widget)))

(export 'drag-dest-add-image-targets)

(defcfun (drag-dest-add-uri-targets "gtk_drag_dest_add_uri_targets") :void
  (widget (g-object widget)))

(export 'drag-dest-add-uri-targets)

(defcfun (drag-dest-set-track-motion "gtk_drag_dest_set_track_motion") :void
  (widget (g-object widget))
  (track-motion :boolean))

(export 'drag-dest-set-track-motion)

(defcfun (drag-dest-get-track-motion "gtk_drag_dest_get_track_motion") :boolean
  (widget (g-object widget)))

(export 'drag-dest-get-track-motion)

(defcfun (drag-finish "gtk_drag_finish") :void
  (context (g-object drag-context))
  (success :boolean)
  (del :boolean)
  (time :uint32))

(export 'drag-finish)

(defcfun (drag-get-data "gtk_drag_get_data") :void
  (widget (g-object widget))
  (context (g-object drag-context))
  (target gdk-atom-as-string)
  (time :uint32))

(export 'drag-get-data)

(defcfun (drag-get-source-widget "gtk_drag_get_source_widget")
    (g-object widget)
  (context (g-object drag-context)))

(export 'drag-get-source-widget)

(defcfun (drag-highlight "gtk_drag_highlight") :void
  (widget (g-object widget)))

(export 'drag-highlight)

(defcfun (drag-unhighlight "gtk_drag_unhighlight") :void
  (widget (g-object widget)))

(export 'drag-unhighlight)

(defcfun (gtk-drag-begin "gtk_drag_begin") (g-object drag-context :free-from-foreign nil)
  (widget (g-object widget))
  (targets (g-boxed-foreign target-list))
  (actions gdk-drag-action)
  (button :int)
  (event (g-object gdk:event)))

(defun drag-begin (widget targets actions button event)
  (let* ((target-list (make-target-list targets))
         (context (gtk-drag-begin widget target-list actions button event)))
    (gtk-target-list-unref target-list)
    context))

(export 'drag-begin)

(defcfun (drag-set-icon-widget "gtk_drag_set_icon_widget") :void
  (context (g-object drag-context))
  (widget (g-object widget))
  (hot-x :int)
  (hot-y :int))

(export 'drag-set-icon-widget)

(defcfun (drag-set-icon-pixbuf "gtk_drag_set_icon_pixbuf") :void
  (context (g-object drag-context))
  (pixbuf (g-object pixbuf))
  (hot-x :int)
  (hot-y :int))

(export 'drag-set-icon-pixbuf)

(defcfun (drag-set-icon-stock "gtk_drag_set_icon_stock") :void
  (context (g-object drag-context))
  (stock-id :string)
  (hot-x :int)
  (hot-y :int))

(export 'drag-set-icon-stock)

(defcfun (drag-set-icon-name "gtk_drag_set_icon_name") :void
  (context (g-object drag-context))
  (icon-name :string)
  (hot-x :int)
  (hot-y :int))

(export 'drag-set-icon-name)

(defcfun (drag-set-icon-default "gtk_drag_set_icon_default") :void
  (context (g-object drag-context)))

(export 'drag-set-icon-default)

(defcfun (drag-check-threshold "gtk_drag_check_threshold") :boolean
  (widget (g-object widget))
  (start-x :int)
  (start-y :int)
  (current-x :int)
  (current-y :int))

(export 'drag-check-threshold)

(defcfun (gtk-drag-source-set "gtk_drag_source_set") :void
  (widget (g-object widget))
  (start-button-mask modifier-type)
  (targets :pointer)
  (n-targets :int)
  (actions gdk-drag-action))

(defun drag-source-set (widget button-mask targets actions)
  (with-foreign-boxed-array (n-targets targets-ptr target-entry targets)
    (gtk-drag-source-set widget button-mask targets-ptr n-targets actions)))

(export 'drag-source-set)

(defcfun (drag-source-set-icon-pixbuf "gtk_drag_source_set_icon_pixbuf") :void
  (widget (g-object widget))
  (pixbuf (g-object pixbuf)))

(export 'drag-source-set-icon-pixbuf)

(defcfun (drag-source-set-icon-stock "gtk_drag_source_set_icon_stock") :void
  (widget (g-object widget))
  (stock-id :string))

(export 'drag-source-set-icon-stock)

(defcfun (drag-source-set-icon-name "gtk_drag_source_set_icon_name") :void
  (widget (g-object widget))
  (icon-name :string))

(export 'drag-source-set-icon-name)

(defcfun (gtk-drag-source-unset "gtk_drag_source_unset") :void
  (widget (g-object widget))
  (target-list :pointer))

(defun drag-source-unset (widget targets)
  (let ((target-list (make-target-list targets)))
    (gtk-drag-source-unset widget target-list)
    (gtk-target-list-unref target-list)
    nil))

(export 'drag-source-unset)

(defcfun (drag-source-add-text-targets "gtk_drag_source_add_text_targets") :void
  (widget (g-object widget)))

(export 'drag-source-add-text-targets)

(defcfun (drag-source-add-image-targets "gtk_drag_source_add_image_targets") :void
  (widget (g-object widget)))

(export 'drag-source-add-image-targets)

(defcfun (drag-source-add-uri-targets "gtk_drag_source_add_uri_targets") :void
  (widget (g-object widget)))

(export 'drag-source-add-uri-targets)
