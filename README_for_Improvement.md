# Replicability Improvements

As seen from the replicability assessment there are many improvements that could be made to the code.
However, I chose to comment on the code that involves the use of the Heckman selection method which was described in the paper.

This was first done in an attempt to completely understand the mechanisms behind this STATA code in order to reproduce in a more open source language, for example R.
However, in the interest of time and the fact that understand the code proved to be an arduous task, I restricted my plans to extensively comment on what is going
on in the code. 

I managed to commment on every step, which would help the replicator in understand the process of the Heckman Selection Method more readily, epecially if they are uncomfortable with 
STATA functions. This will make it easier to translate into another more comfortable coding language for the future. 

One extra thing to note that there might be a mistake made by the authors in line 368 to 371 of the newly commented code. I explained this possibility in great detail in the 
comments of the code.

See the improved code [here](Heckman_std_commented.do) and the original code [here](heckmanfe_std.do).
