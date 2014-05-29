#lang racket

(require (only-in "state-primitives.rkt"
          state state-s state-c reset-c inc-c init-c))

(require (only-in "subst-primitives.rkt"
          empty-s ext-s walk))

(require (only-in "var-primitives.rkt"
           var nonvar? var? var=?))

(provide (all-defined-out))


(define ext-s-check
  (lambda (u w s)
    (cond
      ((occur? u w s) #f)
      (else (ext-s u w s)))))

(define (unify u0 w0 s0)
  (let ((u (walk u0 s0)) (w (walk w0 s0)))
    (cond
      ((and (var? u) (var? w))
       (if (var=? u w) s0 (ext-s-check u w s0)))
      ((and (var? u) (nonvar? w))
       (ext-s-check u w s0))
      ((and (nonvar? u) (var? w))
       (ext-s-check w u s0))
      ((and (pair? u) (pair? w))
       (let ((s (unify (car u) (car w) s0)))
         (and s (unify (cdr u) (cdr w) s))))
      ((equal? u w) s0)
      (else #f))))

