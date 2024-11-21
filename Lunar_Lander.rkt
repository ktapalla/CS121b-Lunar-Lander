#lang racket

;; this is the code for problem set -- Lunar Lander

; Updating the ship state through one time unit when given a (constant) burn rate
;  You'll need to modify this procedure
;(define (update ship-state fuel-burn-rate)  
;  (make-ship-state 
;   (+ (height ship-state) (* (velocity ship-state) dt)) ; height
;   (+ (velocity ship-state)  
;      (* (- (* engine-strength
;               (cond ((<= fuel-burn-rate (/ (fuel ship-state) dt))
;                      fuel-burn-rate) (else (/ (fuel ship-state) dt))))
;                gravity) dt))  ; velocity 
;   (cond ((<= fuel-burn-rate (/ (fuel ship-state) dt))    
;       (- (fuel ship-state) (* fuel-burn-rate dt)))
;       (else  (- (fuel ship-state) (* (/ (fuel ship-state) dt) dt)))))) ; fuel


(define (update ship-state fuel-burn-rate)
  ; checks max burn rate from prob. 1
  (let ((burn-rate
    (if (<= fuel-burn-rate (/ (fuel ship-state) dt))
            fuel-burn-rate (/ (fuel ship-state) dt))))
    ; checks burn rate <= 1
    (let ((burn-rate2
     (if (> burn-rate 1) 1 burn-rate)))
      ; checks burn rate >= 0
      (let ((burn-rate3
           (if (< burn-rate2 0) 0 burn-rate2 )))
       ; burn-rate3 is final burn rate after limitations 
      (make-ship-state 
   (+ (height ship-state) (* (velocity ship-state) dt)) ; height
   (+ (velocity ship-state)  
      (* (- (* engine-strength burn-rate3) gravity) 
         dt))  ; velocity
   (- (fuel ship-state) (* burn-rate3 dt))))))) ; fuel

   
; How to begin the "game"
;  You'll need to modify this procedure
; (define (play) (lander-loop (initial-ship-state))) 
 (define (play strategy) (lander-loop (initial-ship-state) strategy))


; Basic loop for the "game"
;  You'll need to modify this procedure
; original code (commented out)
;(define (lander-loop ship-state)
(define (lander-loop ship-state strategy)
  (show-ship-state ship-state) ; Display the current state
  (if (landed? ship-state) ; Run the next step 
      (end-game ship-state)
      (lander-loop (update ship-state (strategy ship-state)) strategy)))


; !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
; !!!!!!!!!!!!!! WRITE YOUR NEW PROCEDURES HERE !!!!!!!!!!!!!! 
; !!!!!! (this includes code-based exercise solutions!) !!!!!!
; !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

; Problem 2
(define (full-burn ship-state) 1)
(define (no-burn ship-state) 0)
(define (ask-user ship-state) (get-burn-rate))


; Problem 3
(define (old-random-choice strat-1 strat-2)
  (lambda (ship-state)
    (if (= (random 2) 0)
        (strat-1 ship-state)
        (strat-2 ship-state))))


;(play (choice full-burn no-burn random-choice))
; Problem 4
(define (old-height-choice strat-1 strat-2 height-switch)
  (lambda (ship-state)
    (if (>= (height ship-state) height-switch)
        (strat-1 ship-state)
        (strat-2 ship-state))))


; Problem 5
(define (choice strat-1 strat-2 predicate) 
  (lambda (ship-state) 
    (if (predicate ship-state) (strat-1 ship-state) (strat-2 ship-state))))


(define (height-choice strat-1 strat-2 height-switch)
  (choice strat-1 strat-2 
          (lambda (ship-state) (>= (height ship-state) height-switch))))

; random choice example
(define (random-choice strategy-1 strategy-2)
(choice strategy-1
        strategy-2
(lambda (ship-state) (= (random 2) 0))))


; Problem 6
(define (random-nothing-choice)
  (height-choice
    (lambda (ship-state) (no-burn ship-state))
    (random-choice
      (lambda (ship-state) (full-burn ship-state))
      (lambda (ship-state) (ask-user ship-state)))
    40))

                   
; Problem 8

(define (constant-acc ship-state)
     (/ (+ ( / (square (velocity ship-state))
               (* 2 (height ship-state))) 
          gravity)
       engine-strength))


(define (square x) (* x x))


; Problem 11
(define (optimal-constant-acc ship-state)
  (let (( br (constant-acc ship-state)))
         (if (<= br .885) br 0))) 



; !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
; !!!!!!!!!!!!!!!!!!!!! WRITE NEW CODE ABOVE HERE !!!!!!!!!!!!!!!!!!!!!
; !!!!! (code below here is still useful to read and understand!) !!!!!
; !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

; Writing the ship's state to console
(define (show-ship-state ship-state)
  (write-line
   (list 'height (height ship-state)
         'velocity (velocity ship-state)
         'fuel (fuel ship-state))))

; Determining if the ship has hit the ground
(define (landed? ship-state)
  (<= (height ship-state) 0))

; Ending the game
(define (end-game ship-state)
  (let ((final-velocity (velocity ship-state)))
    (write-line final-velocity)
    (cond ((>= final-velocity safe-velocity)
           (write-line "good landing")
           'game-over)
          (else
           (write-line "you crashed!")
           'game-over))))

; Used in player-controlled burn strategy
(define (get-burn-rate)
  (if (= (player-input) burn-key)
      1
      0))

; Starting state of the ship
(define (initial-ship-state)
  (make-ship-state
   50  ; 50 km high
   0   ; not moving (0 km/sec)
   20)); 20 kg of fuel left

; Global constants for the "game"
(define engine-strength 1) ; 1 kilonewton-second
(define safe-velocity -0.5) ; 0.5 km/sec or faster is a crash
(define burn-key 32) ;space key
(define gravity 0.5) ; 0.5 km/sec/sec
;(define dt 1) ; 1 second interval of simulation
(define dt 0.3) ; 0.3 second interval of simulation

; Getting the player's input from the console
(define (player-input)
  (char->integer (prompt-for-command-char " action: ")))


; You’ll learn about the stuff below here in Chapter 2. For now, think of make-ship-state,
; height, velocity, and fuel as primitive procedures built in to Scheme.
(define (make-ship-state height velocity fuel)
  (list 'HEIGHT height 'VELOCITY velocity 'FUEL fuel))
(define (height state) (second state))
(define (velocity state) (fourth state))
(define (fuel state) (sixth state))
(define (second l) (cadr l))
(define (fourth l) (cadr (cddr l)))
(define (sixth l) (cadr (cddr (cddr l))))
; Users of DrScheme or DrRacket: add these for compatibility with MIT Scheme...
; for input and output
(define (write-line x)
  (display x)
  (newline))
; Fixes the buffer-reading issue- you can ignore this method
(define (input-parse line)
  (if (or (equal? "" line) (not (equal? " " (substring line 0 1))))
      #\newline
      #\space))
(define (prompt-for-command-char prompt)
  (display prompt)
  (input-parse (read-line)))
; for random number generation
(#%require (only racket/base random))
; a ridiculous addendum
; (you’ll need this for the exercises)
(define (1+ x) (+ 1 x))



