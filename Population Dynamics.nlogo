patches-own [food]

turtles-own [
 gender ;;  male or female
 married?  ;; the maritial status of the agent
 spouse  ;; the spouse of the agent if it is married
 age ;; the age of agent with maximum of 100
 vehicle? ;; it is true if the agent has a wehicle and false if the agent has no vehicle
 parasite? ;; when the population exceeds the critical threshold, 0.1 of them get infected with parasite
 energy  ;; the energy of the agent
]
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;setup block
to setup
  ca
  random-seed my-seed

  ask patches [
    set food random 10
    recolor-patch
  ]
  crt initial-pop [
    initial-properties
    setxy random-xcor random-ycor
  ]

  reset-ticks
end
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; Go block
to go
  if not any? turtles [stop]
  if ticks = stop-time [stop]

ask turtles [
    update-age
    eat
  ]


ask turtles with [ age >= 18 and not married? ] [
    move
    evaluation-for-marriage ;; it assess the other agents on  when it can marry or not
  ]

ask turtles with [ married? ] [
    reproduction
  ]

death-by-energy-loss ;; death by loss of energy
unexpected-events  ;;  unexpcted events like car accidents, airplane crashes
unexpected-illness ;; unexpcted illnesses like cancers, HIV and parasite spreading



ask turtles with [parasite?] [set age age + random 4 ]


ask patches [ regrowth  recolor-patch ]



  tick
end
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; helper procedures
;;;;;;;;;;;;;;;;;;a patch-procedure
to recolor-patch
  set pcolor scale-color green food 10 0
end
;;;;;;;;;;;;;;;;;; a turtle-procedure
to initial-properties
set size 2
set color magenta
set spouse nobody
set married? false
set age 0
set parasite? false
set energy 100
ifelse random-float 1.0 <= percentage-of-vehicle-owners [ set vehicle? true] [set vehicle? false]
ifelse random-float 1.0 <= 0.5 [set gender "male" set shape "person"] [ set gender "female" set shape "woman"]
end
;;;;;;;;;;;;;;;;;; a turtles procedure
 to update-age
  if ticks mod ticks-as-a-year = 0 [set age age + 1 ]
  if age >= 100 [ get-dead ]
end

to get-dead
if spouse != nobody [ask spouse [ set spouse nobody set married? false ] ]
die
end

;;;;;;;;;;;;;;;;;;a turtle procedure
to eat
  let target one-of patches with [food >= 1]
  set energy energy - energy-lost-for-finding-food
  if target != nobody [
    ask target [ set food food - 1 ]
    set energy energy + energy-gained-from-eating
  ]
end
;;;;;;;;;;;;;;;;;;;;;;a turtle procedure
to move
  rt random-float 90
 lt random-float 90
  if not can-move? 1 [ rt 180]
  fd 0.75
  set energy energy - energy-lost-from-moving
end
;;;;;;;;;;;;;;;;;;;;;; turtle procedure of marriage mechanisms
to evaluation-for-marriage
  let marriage-target one-of other turtles-here with [gender != [gender] of myself]  ;; target for marriage

  if  marriage-target != nobody and [age] of marriage-target >= 18 [

  let hypothesis? [married?] of marriage-target = true ;; a hypothesis that the target is married

    ifelse hypothesis? [ move ] [ marry marriage-target]

  ]
end

to marry [person]
   set married? true set spouse person set-color
   ask person [set married? true set spouse myself set-color ]
end

to set-color
  set color ifelse-value (gender = "male") [blue] [orange] ;; married man & woman
end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;a turtle procedure
to reproduction
  if  gender = "female" and married? and age >= min-age-of-reproduction and age <= max-age-of-reproduction [
    if random-float 1.0 <= probability-of-childbearing [set energy energy - 20 hatch 1 [
    initial-properties

  ]  ]   ]
end
;;;;;;;;;;;;;;;;;;;;;;;;;;; trurtle procedures for death by energy loss, unexpcted events and unexpected illness

to death-by-energy-loss
  ask turtles [ if energy <= 0 [ get-dead]  ]
end

to unexpected-events
  ;; for car accident
  ask turtles [if age >= 18 and vehicle?
                      [ if possibility-of-vehicle-accident?
                                      [ ifelse high-speed-crash?  [ if random-float 1.0 <= 0.8 [get-dead]]   [if random-float 1.0 <= 0.1 [get-dead] ]  ] ] ]
end

to unexpected-illness
  ;; for parasite spread
  if count turtles >= critical-threshold [ ask n-of (0.05 * count turtles) turtles [ set parasite? true] ]
end

;;;;;;;;;;;;;;;;;;;;;;;;;; a trurtle procedure
to regrowth
  if random-float 1.0 <= probability-of-regrowth [ if food <= 1 [set food food + random 10] ]
end

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; reporters
to-report married-people
  report count turtles with [ married?]
end

to-report single-people
  report count turtles with [not married?]
end
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;; shocks

to shock-for-single-agents
  ask turtles with [ not married? ] [ move-to one-of patches]
end

to shock-for-all-agents
  ask turtles  [ move-to one-of patches]
end

;;;;;;;;;;; The voluem of food
to-report north-east
  report sum [food] of patches with [ pxcor > 0 and pycor > 0 ]
end

to-report north-west
  report sum [food] of patches with [ pxcor < 0 and pycor > 0 ]
end

to-report south-east
  report sum [food] of patches with [ pxcor > 0 and pycor < 0 ]
end

to-report south-west
  report sum [food] of patches with [ pxcor < 0 and pycor < 0 ]
end
@#$#@#$#@
GRAPHICS-WINDOW
981
10
1568
598
-1
-1
9.2
1
10
1
1
1
0
0
0
1
-31
31
-31
31
1
1
1
ticks
30.0

BUTTON
4
194
197
228
NIL
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
0

SLIDER
8
19
200
52
initial-pop
initial-pop
0
200
90.0
1
1
NIL
HORIZONTAL

SLIDER
5
275
200
308
min-age-of-reproduction
min-age-of-reproduction
0
100
18.0
1
1
NIL
HORIZONTAL

SLIDER
4
312
202
345
max-age-of-reproduction
max-age-of-reproduction
0
100
33.0
1
1
NIL
HORIZONTAL

SWITCH
4
383
203
416
possibility-of-vehicle-accident?
possibility-of-vehicle-accident?
0
1
-1000

SWITCH
5
420
203
453
high-speed-crash?
high-speed-crash?
0
1
-1000

SLIDER
9
56
203
89
percentage-of-vehicle-owners
percentage-of-vehicle-owners
0
1
0.3
0.05
1
NIL
HORIZONTAL

SLIDER
5
348
203
381
probability-of-childbearing
probability-of-childbearing
0
1
0.5
0.05
1
NIL
HORIZONTAL

PLOT
386
10
968
154
num-of-population
NIL
NIL
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"people" 1.0 0 -16777216 true "" "plot count turtles"
"threshold" 1.0 0 -2674135 true "" "plot-pen-reset\nplotxy 0 critical-threshold\nplotxy plot-x-max critical-threshold"

SLIDER
5
458
203
491
critical-threshold
critical-threshold
100
5000
1000.0
1
1
NIL
HORIZONTAL

PLOT
387
158
969
286
married and single
NIL
NIL
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"married" 1.0 0 -13345367 true "" "plot  married-people"
"single" 1.0 0 -5825686 true "" "plot  single-people"

SLIDER
7
495
204
528
energy-lost-for-finding-food
energy-lost-for-finding-food
0
10
0.75
0.25
1
NIL
HORIZONTAL

SLIDER
5
574
206
607
energy-gained-from-eating
energy-gained-from-eating
0
10
3.0
1
1
NIL
HORIZONTAL

SLIDER
3
615
206
648
probability-of-regrowth
probability-of-regrowth
0
1
0.1
0.01
1
%
HORIZONTAL

SLIDER
5
535
202
568
energy-lost-from-moving
energy-lost-from-moving
0
10
2.0
1
1
NIL
HORIZONTAL

MONITOR
219
19
373
64
Population
count turtles
17
1
11

BUTTON
3
157
197
191
NIL
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

MONITOR
219
126
370
171
Num  of man
count turtles with [gender =\"male\"]
17
1
11

MONITOR
219
75
371
120
Num  of female
count turtles with [gender =\"female\"]
17
1
11

MONITOR
218
177
370
222
The youngest married agent
min [age] of turtles with [married?]
17
1
11

PLOT
387
295
971
427
Spread of parasite
NIL
NIL
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"infected persons" 1.0 0 -16777216 true "" "plot count turtles with [parasite?]"

MONITOR
219
282
370
327
Num of infected agents
count turtles with [parasite?]
17
1
11

MONITOR
219
229
370
274
Average age
mean [age] of turtles
17
1
11

BUTTON
217
334
372
367
NIL
shock-for-single-agents
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
218
375
374
408
NIL
shock-for-all-agents
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
2
237
200
270
ticks-as-a-year
ticks-as-a-year
1
12
3.0
3
1
NIL
HORIZONTAL

INPUTBOX
8
93
92
153
my-seed
100.0
1
0
Number

MONITOR
223
415
371
460
NIL
north-east
17
1
11

MONITOR
223
463
371
508
NIL
north-west
17
1
11

MONITOR
224
513
368
558
NIL
south-east
17
1
11

MONITOR
225
563
368
608
NIL
south-west
17
1
11

PLOT
389
434
967
594
Volume of fooed
NIL
NIL
0.0
10.0
0.0
10.0
true
true
"" ""
PENS
"north-east" 1.0 0 -13345367 true "" "plot north-east"
"nort-west" 1.0 0 -2674135 true "" "plot north-west"
"south-east" 1.0 0 -10899396 true "" "plot south-east"
"south-west" 1.0 0 -955883 true "" "plot south-west"

INPUTBOX
95
94
198
154
stop-time
10000.0
1
0
Number

@#$#@#$#@
## WHAT IS IT?

This model is designed to explain the dynamics of population in social system.  

## HOW IT WORKS

In this model there are N number of agents. each agent can be either a male or female. In the begining, all agents are single with a magenta color .While getting 18 years old( three ticks account for one year) each single agent moves and tries to find a single opposite sex for marriage. When two agents get married, the male's color turns to blue and that of female turns to orange. For marriage, each agent must be at least 18 years old. A married female agent can give birth to a child in an age ranging from min-age-of reproduction to max-age-of reproduction and when the age of a married female exceeds the max-age-of reproduction, she become unable to give birth to any other child. The bith of a child takes 20 units of energy from its mother and it is determined by the parameter of probability-of-birth.

When agents move in the lanscape and try to find food, they consume energy according to parameters of energy-lost-for-moving and energy-lost-for-finding-food and when they eat food they get some energy based on the parameter of energy-gained-from-eating. However if agents' energy becomes less than or equal to 0 they die immediately.

The food that agents eat regrows from the ground and its value is determined by parameter-of-regrowth. Every agent can normally live for 100 years if it dose not face a serious problem. Totally there are three conditions that can cause serious problems for an agent.
 
1) If it belongs to those people owning a vehicle and has a high-speed crash that in this case, it may die by 80% probability and if it has a low-speed crash it may die by 10% probability

2) If it losses all of energy and finds no food, it will die immmediately

3) If it gets infected by a parasite when the the society becomes overpopulated (the number of people exceed the critical threshold ) in this case the parasite-infected agent will have an aging speed three times faster than that of an unfected agents.


## HOW TO USE IT

(how to use the model, including a description of each of the items in the Interface tab)
Paramater of "initial-pop" stands for number of agents (persons)

Parameter of "percentage-of-vehicle-owner" stands for number of agents having a vehicle

Parameter of "min-age-of-reproduction" stands for minimum age of a married female agent that can get pregnant

Parameter of "ticks-as-a-year" stands for how many ticks correspond to a year

Parameter of "max-age-of-reproduction" stands for maximum age of a married female agent that can get pregnant.

Parameter of " probability-of-childbearing" stands for how likely  a married agent can get pregnant and give birth to a child.

Parameter of "possibility-of-vehicle-crash" stands for how likely a vehicle owner can have a crash.

Parameter of "High-speed-crash" is a switch that when it is  ON a car owner will have a high-speed-crash (death probability of 80%) and when it is Off a car owner will have a lowe-speed crash (death probability of 10%).
 
Parameter of "critical threshold" stands fro a value that when the number of population exceed it. The society will get overcrowded and a skin parasite will spread through the society and infect 5% of people in each tick.

Parameter of "energy-lost-for-finding-food " stands for how much energy an agent loses when it searches to find food

Parameter of "energy-lost-for-moving "  stands for how much energy an agent loses when it searches to move over landscape

Parameter of "energy-gained-for-eating" stands for how much energy an agent gaines when it eats food

Parameter of "probability-of-regrowth" stands for how likely a food can re-grow from the ground


## THINGS TO NOTICE

A clear path-dependecy is visible. Actually, When the population grows, the agents gradually convege to a specific place and they increase and decrease in number there.

## THINGS TO TRY

Try the model for different values of critical threshold when model is running.

Try the model for when the world can wrap verticall or horizontally or both of them ans see whether there will be a patch-dependency for population concentration.

## EXTENDING THE MODEL

A year is accounted for by three ticks and it can be parametrised by a slider 

The age for marriage is 18 (for both males and females) and it can be parametrised by a slider

When a married female agent gives birth to a child, it loses 20 units of energy.This number can be parametrised via a slider 

After over-population, the number of agents that get parasite-infected in each tick is fixed (5%) and can be parametrised by a slider 

The death probability of agents with high-speed-crash(80%)is fixed and can be parametrised by a slider

The death probability of agents with low-speed-crash (10%) is fixed and can be parametrised by a slider


## RELATED MODELS

Predator-prey Model

## CREDITS AND REFERENCES

(a reference to the model's URL on the web if it has one, as well as any other necessary credits, citations, and links)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

woman
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 135 75 270 105 270 135 270 150 270 165 270 195 270 225 270 180 135 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270
@#$#@#$#@
NetLogo 6.0.1
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180
@#$#@#$#@
0
@#$#@#$#@
