(in-package :glib)

(defcfun g-markup-escape-text g-string
  (text :string)
  (length :int))

(defun markup-escape-text (string)
  (g-markup-escape-text string (length string)))

(export 'markup-escape-text)
