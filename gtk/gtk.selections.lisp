(in-package :gtk)

(define-g-boxed-cstruct target-entry "GtkTargetEntry"
  (target :string :initform 0)
  (flags target-flags :initform 0)
  (info :uint :initform 0))

(export (boxed-related-symbols 'target-entry))

;;

(defcfun (selection-owner-set "gtk_selection_owner_set") :boolean
  (widget (g-object widget))
  (selection gdk-atom-as-string)
  (time :uint32))

(defcfun (selection-owner-set-for-display "gtk_selection_owner_set_for_display")
    :boolean
  (display (g-object display))
  (widget (g-object widget))
  (selection gdk-atom-as-string)
  (time :uint32))

(defcfun (selection-add-target "gtk_selection_add_target") :void
  (widget (g-object display))
  (selection gdk-atom-as-string)
  (target gdk-atom-as-string)
  (info :uint))

(defcfun (selection-clear-targets "gtk_selection_clear_targets") :void
  (widget (g-object display))
  (selection gdk-atom-as-string))

(defcfun (selection-convert "gtk_selection_convert") :boolean
  (widget (g-object display))
  (selection gdk-atom-as-string)
  (target gdk-atom-as-string)
  (time :uint32))

;;

(define-g-boxed-opaque selection-data "GtkSelectionData"
  :alloc (error "Not allocated"))

(export (boxed-related-symbols 'selection-data))

(defcfun (gtk-selection-data-set "gtk_selection_data_set") :void
  (selection-data (g-boxed-foreign selection-data))
  (type gdk-atom-as-string)
  (format :int)
  (data :pointer)
  (length :int))

(defcfun (gtk-selection-data-get-data "gtk_selection_data_get_data") :pointer
  (selection-data (g-boxed-foreign selection-data)))

(defcfun (gtk-selection-data-get-data-type "gtk_selection_data_get_data_type")
    gdk-atom-as-string
  (selection-data (g-boxed-foreign selection-data)))

(defcfun (gtk-selection-data-get-format "gtk_selection_data_get_format")
    :int
  (selection-data (g-boxed-foreign selection-data)))

(defcfun (gtk-selection-data-get-length "gtk_selection_data_get_length") :int
  (selection-data (g-boxed-foreign selection-data)))

(defcfun (gtk-selection-data-set-pixbuf "gtk_selection_data_set_pixbuf") :boolean
  (selection-data (g-boxed-foreign selection-data))
  (pixbuf (g-object pixbuf)))

(defcfun (selection-data-get-pixbuf "gtk_selection_data_get_pixbuf") (g-object pixbuf)
  (selection-data (g-boxed-foreign selection-data)))

(defcfun (selection-data-targets-include-image "gtk_selection_data_targets_include_image")
    :boolean
  (selection-data (g-boxed-foreign selection-data))
  (writable :boolean))

(defcfun (selection-data-targets-include-text "gtk_selection_data_targets_include_text")
    :boolean
  (selection-data (g-boxed-foreign selection-data)))

(defcfun (selection-data-targets-include-uri "gtk_selection_data_targets_include_uri")
    :boolean
  (selection-data (g-boxed-foreign selection-data)))

(defcfun (selection-data-targets-include-rich-text "gtk_selection_data_targets_include_rich_text")
    :boolean
  (selection-data (g-boxed-foreign selection-data))
  (buffer (g-object text-buffer)))

(defcfun (selection-data-get-selection "gtk_selection_data_get_selection")
    gdk-atom-as-string
  (selection-data (g-boxed-foreign selection-data)))

(defcfun (selection-data-get-display "gtk_selection_data_get_display")
    (g-object display)
  (selection-data (g-boxed-foreign selection-data)))

(defcfun (selection-data-get-target "gtk_selection_data_get_target")
    gdk-atom-as-string
  (selection-data (g-boxed-foreign selection-data)))

; Easy future extension
(defgeneric selection-set (selection-data data &key type &allow-other-keys))

(defmethod selection-set ((selection-data selection-data) (data string)
                          &key (type "text/plain"))
  (with-foreign-string ((ptr len) data)
    (gtk-selection-data-set selection-data type 8 ptr (1- len))))

(defmethod selection-set ((selection-data selection-data) (data pixbuf)
                          &key (type "image/png"))
  (gtk-selection-data-set selection-data type 8 (null-pointer) 0)
  (gtk-selection-data-set-pixbuf selection-data data))

(defun foreign-to-int-or-array (ptr fmt len)
  (let ((ctype (case fmt (8 :int8) (16 :int16) (32 :long)))
        (clen (/ len (if (= fmt 32) (foreign-type-size :long) fmt))))
    (if (= clen 1)
        (mem-ref ptr ctype)
        (let ((array (make-array clen :element-type 'fixnum)))
          (loop for i from 0 below clen
             do (setf (aref array i) (mem-aref ptr ctype)))
          array))))

(defun selection-get (selection-data)
  (let ((fmt (gtk-selection-data-get-format selection-data))
        (len (gtk-selection-data-get-length selection-data))
        (ptr (gtk-selection-data-get-data selection-data)))
  (values
   (cond
     ((= len -1) nil)
     ((= fmt 8) (foreign-string-to-lisp ptr :count len))
     (t (foreign-to-int-or-array ptr fmt len)))
   (gtk-selection-data-get-data-type selection-data)
   fmt)))

(export '(selection-set selection-get))
