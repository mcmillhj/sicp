;;; Exercise 1.23: 
;;; The smallest-divisor procedure shown at the start of this section does lots of needless testing: 
;;;    After it checks to see if the number is divisible by 2 there is no point in checking to see if it is divisible by any larger even numbers. 
;;; This suggests that the values used for test-divisor should not be 2, 3, 4, 5, 6, …, but rather 2, 3, 5, 7, 9, …. 
;;; To implement this change, define a procedure next that returns 3 if its input is equal to 2 and otherwise returns its input plus 2. 
;;; Modify the smallest-divisor procedure to use (next test-divisor) instead of (+ test-divisor 1). 
;;; With timed-prime-test incorporating this modified version of smallest-divisor, run the test for each of the 12 primes found in Exercise 1.22. 
;;; Since this modification halves the number of test steps, you should expect it to run about twice as fast. 
;;; Is this expectation confirmed? If not, what is the observed ratio of the speeds of the two algorithms, and how do you explain the fact that it is different from 2? 

(define (prime? n)
  (define (smallest-divisor n)
    (define (next test-divisor)
      (if (= test-divisor 2)
          3
          (+ 2 test-divisor)))
    (define (find-divisor n test-divisor)
      (cond ((> (square test-divisor) n) n)
            ((divides? test-divisor n) test-divisor)
            (else (find-divisor n (next test-divisor)))))
    (define (divides? a b)
      (= (remainder b a) 0))
    (define (square x)
      (* x x))
    (find-divisor n 2))
  (= n (smallest-divisor n)))

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
;; 1009 *** .02783203125
;; 1011
;; 1013 *** .027099609375
;; 1015
;; 1017
;; 1019 *** .02685546875

;; smallest 3 primes larger than 10_000
;; (search-for-primes 10000 10039)
;; 10001
;; 10003
;; 10005
;; 10007 *** .077880859375
;; 10009 *** .076904296875
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
;; 10037 *** .076904296875

;; smallest 3 primes larger than 100_000
;; (search-for-primes 100000 100045)
;; 100001
;; 100003 *** .252197265625
;; 100005
;; 100007
;; 100009
;; 100011
;; 100013
;; 100015
;; 100017
;; 100019 *** .299072265625
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
;; 100043 *** .234130859375

;; smallest 3 primes larger than 1_000_000
;; (search-for-primes 1000000 1000039)
;; 1000001
;; 1000003 *** .76611328125
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
;; 1000033 *** .7587890625
;; 1000035
;; 1000037 *** .7548828125

;; Results
;; n         |  prime   | time (ms)       | avg time (ms) | last avg time (ms)
;; ---------------------------------------------------------------------------  
;;    1000   |    1009  | 0.02783203125   |               |
;;    1000   |    1013  | 0.027099609375  |               | x 2.9 faster 
;;    1000   |    1019  | 0.02685546875   | 0.02726237    | 0.079020182

;;   10000   |   10007  | 0.077880859375  |               |
;;   10000   |   10009  | 0.076904296875  | x 2.8 slower  | x 3.2 faster
;;   10000   |   10037  | 0.076904296875  | 0.077229818   | 0.243652344
 
;;  100000   |  100003  | 0.252197265625  |               |
;;  100000   |  100019  | 0.299072265625  | x 3.4 slower  | x 2.9 faster
;;  100000   |  100043  | 0.234130859375  | 0.26180013    | 0.764567057

;; 1000000   | 1000003  | 0.76611328125   |               |
;; 1000000   | 1000033  | 0.7587890625    | x 2.9 slower  | x 3.0 faster
;; 1000000   | 1000037  | 0.7548828125    | 0.759928385   | 2.312988281
                                            
;;; Since this modification halves the number of test steps, you should expect it to run about twice as fast. 
;;; Is this expectation confirmed? 
More than confirmed, the new timings show that on average using the next procedure increased execution speed by a factor of 3. 
There is probably a small margin of error due to my approximation of (runtime). 

;;; If not, what is the observed ratio of the speeds of the two algorithms, and how do you explain the fact that it is different from 2?
The ratio of speeds was 3-to-1 in favor of the next procedure. I think that it is likely if I ran the trial thousands of times that the increase would approach 2. 
