## HOW IT WORKS

In this model there are N number of agents. each agent can be either a male or female. In the begining, all agents are single with a magenta color .While getting 18 years old( three ticks account for one year) each single agent moves and tries to find a single opposite sex for marriage. When two agents get married, the male's color turns to blue and that of female turns to orange. For marriage, each agent must be at least 18 years old. A married female agent can give birth to a child in an age ranging from min-age-of reproduction to max-age-of reproduction and when the age of a married female exceeds the max-age-of reproduction, she become unable to give birth to any other child. The bith of a child takes 20 units of energy from its mother and it is determined by the parameter of probability-of-birth.

When agents move in the lanscape and try to find food, they consume energy according to parameters of energy-lost-for-moving and energy-lost-for-finding-food and when they eat food they get some energy based on the parameter of energy-gained-from-eating. However if agents' energy becomes less than or equal to 0 they die immediately.

The food that agents eat regrows from the ground and its value is determined by parameter-of-regrowth. Every agent can normally live for 100 years if it dose not face a serious problem. Totally there are three conditions that can cause serious problems for an agent.
 
1) If it belongs to those people owning a vehicle and has a high-speed crash that in this case, it may die by 80% probability and if it has a low-speed crash it may die by 10% probability

2) If it losses all of energy and finds no food, it will die immmediately

3) If it gets infected by a parasite when the the society becomes overpopulated (the number of people exceed the critical threshold ) in this case the parasite-infected agent will have an aging speed three times faster than that of an unfected agents.



![Population Dynamics](https://github.com/user-attachments/assets/f6de5b07-4478-4df3-9680-7fbc31823dfd)

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
