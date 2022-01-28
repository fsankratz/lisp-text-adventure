#|
(defun do-something ()
  (format t "did something"))
|#
;; Example Code that Macro Should Expand to
#|
(loop
 (format t "End? [y]~%")
 (let ((answer (read-line)))
   (cond
     ((string= answer "g") (return (do-something)))
     ((string= answer "y") (return nil))
     (t nil))))
|#
;; "{" is used as a shorthand symbol and stands for creating a repl loop with given branches
(defmacro { (prompt &rest branches)
  `(progn
     (format t ,prompt)
     (loop
       (format t "--> ")
       ;; (format t "~a [~{~a/~}]~%" ,prompt '(,@(mapcar 'first branches)))
       (let ((answer (read-line)))
	 (cond
	   ,@(let ((cond-forms '((t nil))))
	       (dolist (branch branches)
		 (push `((string= answer ,(first branch)) ,(if (equal (second branch) :keep-looping) `(progn ,@(cddr branch)) `(return (progn ,@(rest branch))))) cond-forms))
	       cond-forms))))))

(defun start ()
  ({ "Welcome to Fabians amazing Text-Adventure! Let's get started.~%1. To find out what you can do, type *help*.~%2. To start over, type *restart*.~%3. To leave the game type *exit*~%Happy adventuring!~%"
     ("exit" (format t "Goodbye~%"))
     ("help" :keep-looping (format t "(1) get hint~%"))
     ("restart" (start))
     ("get hint" :keep-looping (format t "There is a locked door with a key in it in front of you. Try to open it~%"))
     ("turn key" (format t "Congrats, you found the exit.~%"))))
