#lang racket

(require (only-in "state-primitives.rkt"
          state state-s state-c reset-c inc-c init-c))

(require (only-in "subst-primitives.rkt"
          empty-s ext-s walk))

(require (only-in "var-primitives.rkt"
           var nonvar? var? var=?))

(provide (combine-out
          (all-defined-out)
          (all-from-out "state-primitives.rkt")
          (all-from-out "subst-primitives.rkt")
          (all-from-out "var-primitives.rkt")))



(define occur?
  (lambda (x term s)
    (let ((t (walk term s)))
      (cond
        ((var? t) (var=? x t))
        ((pair? t)
         (or (occur? x (car t) s)
             (occur? x (cdr t) s)))
        (else #f)))))

(define ext-s-check
  (lambda (u w s)
    (cond
      ((occur? u w s) #f)
      (else (ext-s u w s)))))

(define (unify u0 w0 s0)
  (let ((u (walk u0 s0)) (w (walk w0 s0)))
    (cond
      ((and (var? u) (var? w))
       (if (var=? u w) s0 (ext-s u w s0)))
      ((and (var? u) (nonvar? w))
       (ext-s-check u w s0))
      ((and (nonvar? u) (var? w))
       (ext-s-check w u s0))
      ((and (pair? u) (pair? w))
       (let ((s (unify (car u) (car w) s0)))
         (and s (unify (cdr u) (cdr w) s))))
      ((equal? u w) s0)
      (else #f))))

(define mzero '())
(define (unit s/c) (cons s/c mzero))

(define (== u w)
  (lambda (s0 c)
    (let ((s (unify u w s0)))
      (if s (unit (state s c)) mzero))))

;;(define fail (== #t #f))
;;(define succeed (== #t #t))

