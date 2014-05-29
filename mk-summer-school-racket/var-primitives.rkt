#lang racket
(provide (all-defined-out))
(define (var n) (vector n))
(define (var? x) (vector? x))
(define (nonvar? x) (not (var? x)))
(define (var=? x1 x2) (= (vector-ref x1 0) (vector-ref x2 0)))

