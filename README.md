# Math 381: Discrete Mathematical Modeling Final Group Project

## Effectively Scheduling Appointments for Hall Health’s Mental Health Clinic

This directory contains the Microsoft Office Excel files for the data, R and Python files for simulation and our final project documents

### *Explaining on the Data and Algorithm on our simulation*

* Motivation and base of Algorithm

Our main focus is to research on finding the solution for the problem of patients who do not show up to their appointments.

The main problem is that the patients who do not show up will waste the time and space that could have been dedicated for other patients if they notified the mental health clinic earlier.

To solve the issue, we have created some strategies along with the current system the Mental Health Clinic has implemented.

Current system is fining patients who do not show up to the appointments. If they were absent, the patients will pay $40 and if they were cancelled late (cancelled after 24 hours prior to the appointment), they will pay $25.

The problem with the current system is that the fee system may discourage patients at first place as most of patients may suffer the financial issue as well.

Thus, we have considered the modified fee system where they will pay the fees after 2nd time of no show. In other words, the clinic will forgive the patients who do not show up for the first time, but the clinic will put fines on patients after.

In addition, we have considered the overbooking model, which we can easily find in the airplane booking system. Basically, we will make each slot available to be booked for at most 2 patients such that we will reduce the wasted resource for time and space at that time in the case of a patient would not show up that time. The problem is that if everyone shows up for every slot for that day, it is inevitable for clinic to tell patients to go back home and reschedule for the next time. This is not very ideal for the clinic since it is penalizing on the patients who try to come to appointments, not who do not show up to the appointments!

Thus, we have considered the modified overbooking model, which is half overbooking model. We will only allow 8 to 10:30 am and 1 to 3:30pm to be overbooked and other time to be normal as now. The motivation behind those specific time is that at that time we have observed higher no show rate than other time as patients oversleep or lunch breaktime. Overall, in the simulation, this method works way better than the full overbooking system we have described earlier.

Among those models, the half overbooking system has performed the best out of all 4 stratetegies.

* Algorithm

We use Python from Jupyter Notebook of Anaconda for Monte Carlo Simulation to create and compare each strategy.

For our penalization on simulation on no show patients, we have used some arbitrary and justified numbers on each cases (negative on both no show and discouraging patients and positive for showing and somewhat encouraging patients)

* Data

We obtained data from Hall Health, and used it to find probability of each situation. We have observed that the age, gender and type of appointments has no statistical significance on no show rate (there is little bit of difference but can be negligible)
and 26.9% of appointments involves the no show patients.

The MHApptData_Fixed.xlsx is modified version of original file (MHApptData.xlsx) to be analyzed -- the original data was hard to be parse through in R studio.

* Full details about the analysis we have obtained from these simulations are in the document file called "Effectively Scheduling Appointments for Hall Health’s Mental Health Clinic."

### *Participants of the Project and Their Roles*
* Jong Tai Kim: Writing simulations on R and Python (and Writing the results to paper)
* Kevin Tran: Researching, Writing Paper and Leading Communication
* Yeojun Yoon: Researching and Writing Paper

### *Special Thanks*
* Sara Billey: our professor for math 381, one of advisors of the paper who gives critical feedbacks
* Patricia Atwater: our advisor from UW hall health who gives the idea of scheduling problem in mental clinic of UW hall health
* Nico Courts: our teaching assistant for math 381, one of advisors of the paper who gives critical feedbacks
