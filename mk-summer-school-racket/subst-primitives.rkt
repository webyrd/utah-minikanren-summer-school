#lang racket
(require "var-primitives.rkt")
(provide (all-defined-out))

(define empty-s '())

(define (ext-s x v s) `((,x . ,v) . ,s))

(define (walk u s)
  (let ((pr (and (var? u) (assf (lambda (v) (var=? u v)) s))))
    (if pr (walk (cdr pr) s) u)))
