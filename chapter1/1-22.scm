;;; Exercise 1.22.  
;;; Most Lisp implementations include a primitive called runtime that returns an integer that specifies the amount of time the system has been running (measured, for example, in microseconds). 
;;; The following timed-prime-test procedure, when called with an integer n, prints n and checks to see if n is prime. 
;;; If n is prime, the procedure prints three asterisks followed by the amxount of time used in performing the test.
(define (runtime) 
  (let ((p (cons 0 0))) 
    ((make-primitive-procedure 'nanotime-since-utc-epoch 1) p) 
    (* 1000 (+ (car p) (/ (cdr p) 1e9)))))

(define (timed-prime-test n)
  (define (start-prime-test n start-time)
    (if (prime? n)
        (report-prime (- (runtime) start-time))))
  (define (report-prime elapsed-time)
    (display " *** ")
    (display elapsed-time))
  (newline)
  (display n)
  (start-prime-test n (runtime)))

(define (prime? n)
  (define (find-divisor n test-divisor)
    (cond ((> (square test-divisor) n) n)
	  ((divides? test-divisor n) test-divisor)
	  (else (find-divisor n (+ test-divisor 1)))))
  (define (divides? a b)
    (= (remainder b a) 0))
  (define (square x)
    (* x x))
  (define (smallest-divisor n)
    (find-divisor n 2))
  (= n (smallest-divisor n)))

;;; Using this procedure, write a procedure search-for-primes that checks the primality of consecutive odd integers in a specified range. 
;;; Use your procedure to find the three smallest primes larger than 1000; larger than 10,000; larger than 100,000; larger than 1,000,000. 
;;; Note the time needed to test each prime. 
;;; Since the testing algorithm has order of growth of (n), you should expect that testing for primes around 10,000 should take about 10 times as long as testing for primes around 1000. 
;;; Do your timing data bear this out? 
;;; How well do the data for 100,000 and 1,000,000 support the n prediction? 
;;; Is your result compatible with the notion that programs on your machine run in time proportional to the number of steps required for the computation? 

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
;; 1009 *** .078857421875
;; 1011
;; 1013 *** .0791015625
;; 1015
;; 1017
;; 1019 *** .0791015625

;; smallest 3 primes larger than 10_000
;; (search-for-primes 10000 10039)
;; 10001
;; 10003
;; 10005
;; 10007 *** .243896484375
;; 10009 *** .243896484375
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
;; 10037 *** .2431640625

;; smallest 3 primes larger than 100_000
;; (search-for-primes 100000 100045)
;; 100001
;; 100003 *** .7587890625
;; 100005
;; 100007
;; 100009
;; 100011
;; 100013
;; 100015
;; 100017
;; 100019 *** .7578125
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
;; 100043 *** .77709960937

;; smallest 3 primes larger than 1_000_000
;; (search-for-primes 1000000 1000039)
;; 1000001
;; 1000003 *** 2.382080078125
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
;; 1000033 *** 2.448974609375
;; 1000035
;; 1000037 *** 2.10791015625


;; Results
;; n         |  prime   | time (ms)      | avg time (ms)
;; ----------------------------------------------------- 
;;    1000   |    1009  | 0.078857421875 |
;;    1000   |    1013  | 0.0791015625   |
;;    1000   |    1019  | 0.0791015625   | 0.079020182  

;;   10000   |   10007  | 0.243896484375 | 
;;   10000   |   10009  | 0.243896484375 | 
;;   10000   |   10037  | 0.2431640625   | 0.243652344   x 3.08 slower

;;  100000   |  100003  | 0.7587890625   |
;;  100000   |  100019  | 0.7578125      |
;;  100000   |  100043  | 0.77709960937  | 0.764567057   x 3.14 slower

;; 1000000   | 1000003  | 2.382080078125 |
;; 1000000   | 1000033  | 2.448974609375 |
;; 1000000   | 1000037  | 2.10791015625  | 2.312988281   x 3.03 slower

;;; Since the testing algorithm has order of growth of (n), you should expect that testing for primes around 10,000 should take about 10 times as long as testing for primes around 1000. 
;;; Do your timing data bear this out? 
No, the timing data shows that for each order of magnitude increase (10x) in the input size execution only took ~3x longer. 

;;; How well do the data for 100,000 and 1,000,000 support the n prediction? 
Similar to the above, each increase in input size by a factor of 10 took ~3x as long to execute. This is consistent with O(sqrt(10)).  

;;; Is your result compatible with the notion that programs on your machine run in time proportional to the number of steps required for the computation? 
Yes, these results do seem to verify that programs on my machine run in time proportional to the number of steps required for the computation.
