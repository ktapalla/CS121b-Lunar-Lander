# README - COSI 121b Lunar Lander PS

The code provided in this repository contains the solutions to the Lunar Lander Problem Set for COSI 121b - Structure and Interpretations of Computer Programs. 

```
The 5 different problems will be described below, as well as the instructions for how to install and run the code. Each problem is solved within its own Java file/class. 

Note: This assignment was done for a class, and we were limited to using only Java features we had covered in class thus far. This may make the assignment solutions more complicated/longer than they would have to be. 
```

## Installation and Execution 

Get the files from GitHub and in your terminal/console move into the folder of the project. Run the following line to open the program in DrRacket: 

``` drracket Lunar_Lander.rtk ```

This will open up your DrRacket application where you will be able to play the game. Click the button labeled "Run" at the top right of the DrRacket Application window. The user will then be able to play the game within DrRacket themselves by typing the appropriate commands on the REPL.

Note: The instructions above assume that the user already has Racket and DrRacket installed on their device and the executable command of ``` drracket ``` added to their ``` $PATH ``` as an executable command. If the user does not have this done already, they can follow the steps at the following link to do so: 

https://docs.racket-lang.org/pollen/Installation.html 

Following the first four bullets under the section '1.2 Installation' will be enough. 

If the user would rather not open the program through the terminal, then they can also just make sure that they have DrRacket installed and open the ``` Lunar_Lander.rtk ``` file on the application directly. 


## Assignment Instructions 

Louis Reasoner, appalled by this term's tuition bill, has decided to put his education to work and reap a fortune in the video game business. His first best-selling game is called "Lunar Lander". The objective is to land a spaceship on a planet, firing the ship's rockets in order to reach the surface at a small enough velocity, and without running out of fuel. 

In implementing this game, Louis assumes that the user will, at each instant, specify a rate at which fuel is to be burned. The rate is a number between 0 (no burn) and 1 (maximum burn). In his model of the rocket motor, burning fuel at a given rate will provide a force of magnitude ``` strength * rate ```, where ``` strength ``` is some constant that determines the strength of the rocket engine. 

Louis creates a data structure called ``` ship-state ``` which consists of the ship's state relevant to his program: the ``` height ``` above the planet, the ``` velocity ```, and the amount of ``` fuel ``` that the ship has. He defines this data structure by a constructor, ``` make-ship-state ``` and three selectors: ``` height ```, ``` velocity ```, and ``` fuel ```. 

The heart of Louis' program is a procedure that updates the ship's position and velocity. This is done in a procedure that takes as arguments a ``` ship-state ```, the rate at which fuel is burned over the next time interval, and returns the new state of the ship after time interval ``` dt ```. 

When finished, Louis rushes to show his game to his friend Alyssa P. Hacker, who is not in the least bit impressed, and she claims that his program has a bug. 

### Problem 1
Alyssa has noticed that Louis has forgotten to take account of the fact that the ship might run out of fuel. If there is x amount of fuel left, then, no matter what rate is specified, the maximum (average) rate at which fuel can be burned during the next time interval is (/ x dt). 

Show how to install this constraint as a simple modification to the ``` update ``` procedure (``` update ``` is the only procedure that should be changed).

Louis is dejected, but not defeated, for he has a new idea. In his new game, the object will be to come up with a general strategy for landing the ship. Since Louis' game will be played using Scheme, a strategy can be represented as a procedure. We could specify a strategy by defining a procedure that takes a ship state as input, and returns a burn rate between 0 and 1. The two very simple strategies are: 

``` (define (full-burn ship-state) 1) ``` 

and 

``` (define (no-burn ship-state) 0) ``` 

The new game reduces the original one if we use a strategy that says in effect to "ask the user": 

``` (define (ask-user ship-state) (get-burn-rate)) ``` 

### Problem 2 

Modify Louis' ``` play ``` and ``` lander-loop ``` procedures so that ``` play ``` now takes an input - the strategy procedure to use to get the new state. To do so, define the three procedures above. 

``` (play ask-user) ``` should have the same behavior as before, and ``` (play full-burn) ``` should make the rocket behave as it did in Problem 1. 

Alyssa likes this new idea much better, and comes up with a twist of her own by suggesting that one can create new strategies by combining old ones. For example, we could make a new strategy by, at each instant, choosing between two given strategies. If the two strategies were, say, ``` full-burn ``` and ``` no-burn ```, we could express this new strategy as 

``` (lambda (shi[-state]) (if (= (random 2) 0) (full-burn ship-state) (no-burn ship-state))) ``` 

The Scheme procedure ``` random ``` is used to return either 0 or 1 with equal code. Testing whether the result is zero determines whether to apply ``` full-burn ``` or ``` no-burn ```. 

### Problem 3 

Generalize this idea further defining a "higher level" strategy called ``` random-choice ```. This procedure takes as arguments two strategies and returns the compound strategy whose behavior is, at each instant, to apply at random one or the other of the two component strategies. In other words, running: 

``` (random-choice full-burn no-burn) ``` 

should generate the compound strategy shown above. This can be tested by running the following line: 

``` (play (random-choice full-burn no-burn)) ``` 

### Problem 4 

Define a new compound strategy called ``` height-choice ``` that chooses between two strategies depending on the height of the rocket. ``` height-choice ``` itself should be implemented as a procedure that takes as arguments two strategies and a height at which to change from one strategy to another. For example, running 

``` (play (height-choice no-burn full-burn 30)) ``` 

should result in a strategy that doesn't burn the rockets when the ship's height is below 30. Turn in your code for ``` height-choice ```.

### Problem 5 

``` random-choice ``` and ``` height-choice ``` are special cases of a more general compound strategy called ``` choice ```, which takes as arguments two strategies together with a predicate used to select between them. The predicate should take a ship-state as argument. For example, ``` random-choice ``` could be alternatively defined as follows: 

``` (define (random-choice strategy-1 strategy-2) (choice strategy-1 strategy-2 (lambda (ship-state) (= (random 2) 0)))) ```

Define ``` choice ``` and show how to define ``` height-choice ``` in terms of ``` choice ```. Turn in your code for ``` choice ``` and the new definition of ``` height-choice ```. 

### Problem 6 

Using your procedures, give an expression that represents the compound strategy: "If the height is above 40 then do nothing. Otherwise randomly choose between doing a fullburn and asking the user." 

### Problem 7 

N/A - written problem 

### Problem 8 

Eve came up with the following strategy: At each instant, burn enough fuel so that the acceleration on the ship will be as given by a formula. In other words, force the rocket to fall at the right constant acceleration. 

Implement Eva's idea as a strategy called ``` constant-acc ```. 

One minor problem with Eva's strategy is that it only works if the ship is moving, while the game starts with the ship at zero velocity. This is easily fixed by letting the ship fall for a bit before using the strategy. Louis, Eva, and Alyssa experiment and find that: 

``` (play (height-choice no-burn constant-acc 40)) ``` 

gives good results. Continuing to experiment, they observe a curious phenomenon: the longer they allow the ship to fakk before turning on the rockets, the less fuel is consumed during the landing. 

### Problem 9 

N/A - written problem 

### Problem 10 

Another bug has been uncovered in the ``` update ``` procedure. Change the procedure so that, no matter what rate is specified, the actual burn rate will never be greater than 1, so always 0 <= f(t) <= 1. 

A realistic modification to the "wait until the very end" strategy is to let the ship fall as long as the desired burn rate is sufficiently less than 1, and then follow the ``` constant-acc ``` strategy. 

### Problem 11 

Implement the strategu described above as a procedure called ``` optimal-constant-acc ```. 
