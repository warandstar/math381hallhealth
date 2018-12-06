# math381hallhealth

*Explaining on the Data and Algorithm on our simulation*

* Motivation and base of Algorithm
Research on the case of solving the problem of patients who do not show up to their appointments. 

The main problem is that the patients who do not show up will waste the time and space that could have been dedicated for other patients if they notified the mental health clinic earlier. 

To solve the issue, we have created some strategies along with the current system the Mental Health Clinic has implemented. 

Current system is fining patients who do not show up to the appointments. If they were absent, the patients will pay $40 and if they were cancelled late, they will pay $25.

The problem with the current system is that the fee system may discourage patients at first place as most of patients may suffer the financial issue as well.

Thus, we have considered the modified fee system where they will pay the fees after 2nd time of no show. In other words, the clinic will forgive the patients who do not show up for the first time, but the clinic will put fines on patients after.

In addition, we have considered the overbooking model like in airplane booking system. Basically, we will make each slot able to be booked for at most 2 patients such that we will reduce the wasted resource for time and space at that time. The problem is that if everyone shows up for every slot for that day, it is inevitable for clinic to tell patients to go back home and reschedule for the next time. This is not very ideal for the clinic as it is penalizing on the patients who try to come to appointments, not who do not show up to the appointments!

Thus, we have considered the modified overbooking model, which is half overbooking model. We will only allow 8~10:30 am and 1~3:30pm to be overbooked and other time to be normal as now. The motivation behind those specific time is that at that time we have observed higher no show rate than other time as patients oversleep or lunch breaktime. Overall, this method works way better than the full overbooking system we have described earlier.

Among those models, the half overbooking system has performed the best out of all 4 stratetegies.

* Algorithm

We used Python from Jupyter Notebook of Anaconda, and used Monte Carlo Simulation for simulating and compare each strategy.

* Data

We obtained data from Hall Health, and used it to find probability of each situation. We have observed that the age, gender and type of appointments has no statistical significance on no show rate (there is little bit of difference but can be negligible)
and 26.9% of appointments involves the no show patients.
