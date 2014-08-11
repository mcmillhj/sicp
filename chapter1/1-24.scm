;;; Exercise 1.24: 
;;; Modify the timed-prime-test procedure of Exercise 1.22 to use fast-prime? (the Fermat method), and test each of the 12 primes you found in that exercise. 
;;; Since the Fermat test has Θ ( log n ) growth, how would you expect the time to test primes near 1,000,000 to compare with the time needed to test primes near 1000? 
;;; Do your data bear this out? 
;;; Can you explain any discrepancy you find? 

(define (fast-prime? n times)
  (define (fermat-test n)
    (define (expmod base exp m)
      (cond ((= exp 0) 1)
            ((even? exp)
             (remainder (square (expmod base (/ exp 2) m))
                        m))
            (else
             (remainder (* base (expmod base (- exp 1) m))
                        m))))        
    
    (define (try-it a)
      (= (expmod a n n) a))
    (try-it (+ 1 (random (- n 1)))))
  
  (cond ((= times 0) true)
        ((fermat-test n) (fast-prime? n (- times 1)))
        (else false)))

(define (runtime) 
  (let ((p (cons 0 0))) 
    ((make-primitive-procedure 'nanotime-since-utc-epoch 1) p) 
    (* 1000 (+ (car p) (/ (cdr p) 1e9)))))

(define (timed-prime-test n)
  (define (start-prime-test n start-time)
    (if (fast-prime? n 100)
        (report-prime (- (runtime) start-time))))
  (define (report-prime elapsed-time)
    (display " *** ")
    (display elapsed-time))
  (newline)
  (display n)
  (start-prime-test n (runtime)))

(define (search-for-primes start end)
  (if (even? start)
      (search-for-primes (+ 1 start) end)
      (cond ((< start end) (timed-prime-test start)
	     (search-for-primes (+ 2 start) end)))))

;; smallest 3 primes larger than 1_000
;; (search-for-primes 1000 1020)
;; 1001
;; 1003
;; 1005
;; 1007
;; 1009 *** 2.619140625
;; 1011
;; 1013 *** 2.639892578125
;; 1015
;; 1017
;; 1019 *** 2.785888671875

;; smallest 3 primes larger than 10_000
;; (search-for-primes 10000 10039)

;; 10001
;; 10003
;; 10005
;; 10007 *** 2.626953125
;; 10009 *** 2.503173828125
;; 10011
;; 10013
;; 10015
;; 10017
;; 10019
;; 10021
;; 10023
;; 10025
;; 10027
;; 10029
;; 10031
;; 10033
;; 10035
;; 10037 *** 2.5419921875

;; smallest 3 primes larger than 100_000
;; (search-for-primes 100000 100045)
;; 100001
;; 100003 *** 2.98974609375
;; 100005
;; 100007
;; 100009
;; 100011
;; 100013
;; 100015
;; 100017
;; 100019 *** 3.051025390625
;; 100021
;; 100023
;; 100025
;; 100027
;; 100029
;; 100031
;; 100033
;; 100035
;; 100037
;; 100039
;; 100041
;; 100043 *** 3.079833984375

;; smallest 3 primes larger than 1_000_000
;; (search-for-primes 1000000 1000039)
;; 1000001
;; 1000003 *** 3.52490234375
;; 1000005
;; 1000007
;; 1000009
;; 1000011
;; 1000013
;; 1000015
;; 1000017
;; 1000019
;; 1000021
;; 1000023
;; 1000025
;; 1000027
;; 1000029
;; 1000031
;; 1000033 *** 3.522216796875
;; 1000035
;; 1000037 *** 3.716064453125


;;; Since the Fermat test has Θ ( log n ) growth, how would you expect the time to test primes near 1,000,000 to compare with the time needed to test primes near 1000? 
;;; Do your data bear this out? 
As we increase the input size in order of magnitude the execution time is not moving by much. 

;;; Can you explain any discrepancy you find? 
Any discrepancies lie in the approximation of the (runtime) primitive and the fact that fast-prime?
is performing its check 100 times for each prime.
