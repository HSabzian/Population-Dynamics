## HOW IT WORKS

In this model there are N number of agents. each agent can be either a male or female. In the begining, all agents are single with a magenta color .While getting 18 years old( three ticks account for one year) each single agent moves and tries to find a single opposite sex for marriage. When two agents get married, the male's color turns to blue and that of female turns to orange. For marriage, each agent must be at least 18 years old. A married female agent can give birth to a child in an age ranging from min-age-of reproduction to max-age-of reproduction and when the age of a married female exceeds the max-age-of reproduction, she become unable to give birth to any other child. The bith of a child takes 20 units of energy from its mother and it is determined by the parameter of probability-of-birth.

When agents move in the lanscape and try to find food, they consume energy according to parameters of energy-lost-for-moving and energy-lost-for-finding-food and when they eat food they get some energy based on the parameter of energy-gained-from-eating. However if agents' energy becomes less than or equal to 0 they die immediately.

The food that agents eat regrows from the ground and its value is determined by parameter-of-regrowth. Every agent can normally live for 100 years if it dose not face a serious problem. Totally there are three conditions that can cause serious problems for an agent.
 
1) If it belongs to those people owning a vehicle and has a high-speed crash that in this case, it may die by 80% probability and if it has a low-speed crash it may die by 10% probability

2) If it losses all of energy and finds no food, it will die immmediately

3) If it gets infected by a parasite when the the society becomes overpopulated (the number of people exceed the critical threshold ) in this case the parasite-infected agent will have an aging speed three times faster than that of an unfected agents.



![Population Dynamics](https://github.com/user-attachments/assets/f6de5b07-4478-4df3-9680-7fbc31823dfd)

