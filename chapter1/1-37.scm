;;; Exercise 1.37:

;;; An infinite continued fraction is an expression of the form 
;;; f = N1 
;;;    ---- 
;;;    D1 + N2 
;;;         ----
;;;         D2 + N3 
;;;              ---- 
;;;              D3 + ...  
;;; As an example, one can show that the infinite continued fraction expansion with the Ni and the Di all equal to 1 produces 1 / φ , where φ is the golden ratio (described in 1.2.2). 
;;; One way to approximate an infinite continued fraction is to truncate the expansion after a given number of terms. 
;;; Such a truncation—a so-called finite continued fraction k-term finite continued fraction—has the form
;;; f = N1 
;;;    ---- 
;;;    D1 + N2 
;;;         ----
;;;         . + NK 
;;;          .  ---- 
;;;           . DK + ..
;;; Suppose that n and d are procedures of one argument (the term index i ) that return the Ni and Di of the terms of the continued fraction. 
;;; Define a procedure cont-frac such that evaluating (cont-frac n d k) computes the value of the k-term finite continued fraction. 
;;; Check your procedure by approximating 1 / φ using
(define (cont-frac n d k)
  (define (frac i)
    (let ((N (n i))
          (D (d i)))
    (if (< i k)
        (/ N (+ D (frac (+ i 1))))
        (/ N D))))
  (frac 1))

(cont-frac (lambda (i) 1.0)
           (lambda (i) 1.0)
           5)
; => 0.625

;;; for successive values of k. How large must you make k in order to get an approximation that is accurate to 4 decimal places?
(cont-frac (lambda(i) 1.0) (lambda(i) 1.0) 6)
; => .6153846153846154
(cont-frac (lambda(i) 1.0) (lambda(i) 1.0) 7)
; => .6190476190476191
(cont-frac (lambda(i) 1.0) (lambda(i) 1.0) 8)
; => .6176470588235294
(cont-frac (lambda(i) 1.0) (lambda(i) 1.0) 9)
; => .6181818181818182
(cont-frac (lambda(i) 1.0) (lambda(i) 1.0) 10)
; => .6179775280898876
(cont-frac (lambda(i) 1.0) (lambda(i) 1.0) 11)
; => .6180555555555556

;;; If your cont-frac procedure generates a recursive process, write one that generates an iterative process. 
;;; If it generates an iterative process, write one that generates a recursive process. 
(define (cont-frac-iter n d k)
  (define (frac-iter i acc)
    (let ((N (n i))
          (D (d i)))
      (if (= i 0)
          acc
          (frac-iter (- i 1) (/ N (+ D result))))))
  (frac-iter (- k 1) (/ (n i) (d i))))

(cont-frac-iter (lambda(i) 1.0) (lambda(i) 1.0) 6)
; => .6153846153846154
(cont-frac-iter (lambda(i) 1.0) (lambda(i) 1.0) 7)
; => .6190476190476191
(cont-frac-iter (lambda(i) 1.0) (lambda(i) 1.0) 8)
; => .6176470588235294
(cont-frac-iter (lambda(i) 1.0) (lambda(i) 1.0) 9)
; => .6181818181818182
(cont-frac-iter (lambda(i) 1.0) (lambda(i) 1.0) 10)
; => .6179775280898876
(cont-frac-iter (lambda(i) 1.0) (lambda(i) 1.0) 11)
; => .6180555555555556
