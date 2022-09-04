(in-package #:kons-9)

;;;; class hierarchy ====================================================

(defun print-class-hierarchy (class &optional (indent 0))
  (print-spaces indent)
  (format t "~a : ~a~%" (class-name class) (mapcar #'class-name (closer-mop::class-direct-superclasses class)))
  (let ((subclasses (closer-mop::class-direct-subclasses class)))
    (dolist (subclass subclasses)
      (print-class-hierarchy subclass (+ indent 2)))))

;;;; utils ==============================================================

(defun my-debug (x &optional (str ""))
  (format t "DEBUG: ~a~s~%" str x)
  x)

;;; concatenate strings
(defun strcat (&rest strings)
  (apply #'concatenate 'string strings))

;;; concatenate symbols
(defun concat-syms (&rest objects)
  (intern (format nil "~{~a~}" objects)))

(defun make-keyword (name)
  (values (intern (string-upcase name) "KEYWORD")))

(defun print-spaces (num)
  (dotimes (i num)
    (princ " ")))

(defun indent-padding (num)
  (format nil "~v{~a~:*~}" num '(#\space)))

(defun array->list (array)
  (map 'list #'identity array))

#+nil 
(defun list->array (list)
  (map 'array #'identity list))

(defun list->array (list)
  (map 'vector #'identity list))

(defun wrap-list (list)
  (append list (list (first list))))

(defun flatten-list (l)
  (cond ((null l) nil)
        ((atom l) (list l))
        (t (loop for a in l appending (flatten-list a)))))

(defun flatten-list-1 (l)
  (let ((result '()))
    (dolist (a l)
      (if (atom a)
          (push a result)
          (dolist (b a)
            (push b result))))
    (nreverse result)))

(defmacro doarray ((i obj array) &rest body)
  `(dotimes (,i (length ,array))
     (let ((,obj (aref ,array ,i)))
       ,@body)))

(defmacro doarray-if ((i obj test array) &rest body)
  `(dotimes (,i (length ,array))
     (let ((,obj (aref ,array ,i)))
       (when (funcall ,test ,obj)
         ,@body))))

;;;; math ===============================================================

(defconstant 2pi (* 2 pi))
(defconstant pi/2 (/ pi 2))

;;; linear interpolation
(defun lerp (f lo hi)
  (+ lo (* f (- hi lo))))

;;; compute [0-1] factor
(defun tween (val start end)
  (cond ((<= val start) 0.0)
	((>= val end) 1.0)
	(t (/ (- val start) (- end start)))))

(defun rand2 (a b)
  (if (= a b)				;doesn't like (random 0)
      a
      (let ((lo (min a b))
	    (hi (max a b)))
	(+ lo (random (- hi lo))))))

;;; random float between -a and a
(defun rand1 (a &optional (pivot 0))
  (+ pivot (rand2 (- a) a)))

;;; from web
;; (defun normal-random (mean std-dev)
;;   "Normal random numbers, with the given mean & standard deviation."
;;   (do* ((rand-u (* 2 (- 0.5 (random 1.0))) (* 2 (- 0.5 (random 1.0))))
;;         (rand-v (* 2 (- 0.5 (random 1.0))) (* 2 (- 0.5 (random 1.0))))
;;         (rand-s (+ (* rand-u rand-u) (* rand-v rand-v))
;;                 (+ (* rand-u rand-u) (* rand-v rand-v))))
;;     ((not (or (= 0 rand-s) (>= rand-s 1)))
;;      (+ mean
;;       (* std-dev
;;          (* rand-u (sqrt (/ (* -2.0 (log rand-s)) rand-s))))))))

(defun radians (angle)
  (* angle (/ pi 180)))

(defun degrees (angle)
  (* angle (/ 180 pi)))

(defun clamp (x lo hi)
  (max lo (min x hi)))

