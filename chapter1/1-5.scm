;;; Exercise 1.5.  Ben Bitdiddle has invented a test to determine whether the interpreter he is faced with is using applicative-order evaluation or normal-order evaluation. He defines the following two procedures:

(define (p) (p))

(define (test x y)
  (if (= x 0)
      0
      y))

;;; Then he evaluates the expression

(test 0 (p))

;;; What behavior will Ben observe with an interpreter that uses applicative-order evaluation? 

Using applicative-order evaluation the operands are first evaluated before applying the operator test, in this case since the application of (p) is one of the operands it will be evaluated. However, since the the body of procedure p is itself an application of p, in applicative-order evaluation this will result in a program that applies (p) infinitely.

;;; What behavior will he observe with an interpreter that uses normal-order evaluation? Explain your answer. (Assume that the evaluation rule for the special form if is the same whether the interpreter is using normal or applicative order: The predicate expression is evaluated first, and the result determines whether to evaluate the consequent or the alternative expression.)

Using normal-order application the values of the operands 0 and (p) are not evaluated until they are needed. This means that instead of evaluating (p) infinitely this program will enter the test procedure, evaluate the if expression and execute the consequent.
