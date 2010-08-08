;; history-ring.el
;; v0.1
;;
;; this adds history to a prompt
;; first run history-ring-init, then make a function something like:
;;  (defun history-prev ()
;;    (interactive)
;;    (history-ring-access 1 STARTPOINT ENDPOINT))

(defun history-ring-init ()
  "initialize a history ring for current buffer"
  (defvar history-ring-list '()
    "holds the history")
  (defvar tmp-history-ring-list '()
    "copy of the variable `history-ring', that is operated on
    until the next insertation onto history-ring")
  (defvar history-pos '()
    "holds the current position in history")
  (set (make-local-variable 'history-ring-list) '())
  (set (make-local-variable 'tmp-history-ring-list) '())
  (set (make-local-variable 'history-pos) 0))

(defun history-ring-access (elem beg end)
  "access the history ring

ELEM should hold an positive or negative integer.
\"-1\" equals return the previous element and \"1\" equals return the next
element in ring

BEG and END should be the beginnig and ending point of prompt"

  (when (not tmp-history-ring-list)
    (setq tmp-history-ring-list (copy-list history-ring-list))
    (push "" tmp-history-ring-list))
  (let ((current-line (buffer-substring beg end)))
    (when (and (nth (+ history-pos elem) tmp-history-ring-list)
               (>= (+ history-pos elem) 0))
      (setcar (nthcdr history-pos tmp-history-ring-list) current-line)
      (setq history-pos (+ history-pos elem))
      (delete-region beg end)
      (insert (nth history-pos tmp-history-ring-list)))))

(defun history-ring-add (new)
  "add NEW to history ring"
  (unless (equal new (car history-ring-list))
    (push new history-ring-list))
  (setq tmp-history-ring-list '()))

(provide 'history-ring)
