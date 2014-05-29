#lang racket
(provide (combine-out (all-defined-out) (struct-out state)))
(struct state (s c) #:transparent)

(define (reset-c c) 0)
(define (inc-c c) (add1 c))
(define init-c 0)

