;;; Exercise 1.26: 
;;; Louis Reasoner is having great difficulty doing Exercise 1.24. 
;;; His fast-prime? test seems to run more slowly than his prime? test. 
;;; Louis calls his friend Eva Lu Ator over to help. 
;;; When they examine Louis’s code, they find that he has rewritten the expmod procedure to use an explicit multiplication, rather than calling square:

(define (expmod base exp m)
  (cond ((= exp 0) 1)
        ((even? exp)
         (remainder 
          (* (expmod base (/ exp 2) m)
             (expmod base (/ exp 2) m))
          m))
        (else
         (remainder 
          (* base 
             (expmod base (- exp 1) m))
          m))))

;;; “I don’t see what difference that could make,” says Louis. 
;;; “I do.” says Eva. “By writing the procedure like that, you have transformed the Θ(log ⁡n) process into a Θ(n) process.” 
;;; Explain. 

As written, in the even case Louis' code will make two recursive calls to the expmod procedure with the same arguments.
This means that instead of having a linear recursive algorithm like before, we are now generating a tree of 
recursive procedure calls. Everytime this branch occurs, both subtrees will compute the same result. When we were
using the square procedure instead, there were no wasteful calls to expmod. 

; Here is an example of what the original recursive process looked like: 
(expmod 2 8 2)
   (expmod 2 4 2) 
      (expmod 2 2 2)
         (expmod 2 1 2)
            (expmod 2 0 2)

; Here is how it looks using Louis' expmod procedure
(expmod 2 8 2)
   (expmod 2 4 2)
      (expmod 2 2 2)
         (expmod 2 1 2)
            (expmod 2 0 2) 
            (expmod 2 0 2)  
         (expmod 2 1 2)
            (expmod 2 0 2)  
            (expmod 2 0 2)  
      (expmod 2 2 2)
         (expmod 2 1 2)
            (expmod 2 0 2)  
            (expmod 2 0 2) 
         (expmod 2 1 2)
            (expmod 2 0 2) 
            (expmod 2 0 2) 
   (expmod 2 4 2)
      (expmod 2 2 2)
         (expmod 2 1 2)
            (expmod 2 0 2)  
            (expmod 2 0 2) 
         (expmod 2 1 2)
            (expmod 2 0 2) 
            (expmod 2 0 2)  
      (expmod 2 2 2)
         (expmod 2 1 2)
            (expmod 2 0 2)  
            (expmod 2 0 2) 
         (expmod 2 1 2)  
            (expmod 2 0 2)  
            (expmod 2 0 2) 

; As a result of this seemingly innocuous change, this changed the expmod procedure from a O(log n) to O(log 2^n) which reduces to O(n) ( log2(2^n) == n ) 
