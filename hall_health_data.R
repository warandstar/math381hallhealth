library(readxl)
library(dplyr)
hall_health <- read_excel("MHApptData_Fixed.xlsx", col_types = c("numeric", "date", "date", "numeric", "text", "text", "numeric", "numeric", "text", "numeric", "text", "text"))

# change the column names for the convenience

hall_health <- hall_health %>%
  rename(PT_ID = `Pt ID`, 
         Appt_Date = `Appt Date`,
         Appt_Time = `Appt Time`, 
         Appt_Status = `Appt Status`,
         Appt_Type = `Appt Type`, 
         Waiting_Days  = `Lead Days`)
  
mutate(hall_health, Appt_Date = as.Date(Appt_Date), Appt_Time = as.character(Appt_Time))
         
time_distribution <- table(hall_health$Appt_Time)


# see visualization of the hall health data
table(hall_health$Sex)
table(hall_health$Age)
table(hall_health$Appt_Status)
table(hall_health$Waiting_Days)

hist(hall_health$Appt_Status)
hist(hall_health$Waiting_Days)
hist(hall_health$Age)

# set the no show ratio
no_show_ratio = sum(hall_health$Appt_Status == -1) / length(hall_health$Appt_Status)

# function to create no show/show based on given waiting days
# min: minimum waiting day, max: maximum waiting day
appt_status_days <- function(min, max) {
  temp <- hall_health %>%
    filter(Waiting_Days <= max, Waiting_Days > min) %>%
    select(Appt_Status)
  table(temp)
}

# no show/show based on waiting days
appt_status_days(0, 7)
appt_status_days(7, 14)
appt_status_days(14, 21)
appt_status_days(21, 28)
appt_status_days(28, 1000)

# no show/show based on sex
table(hall_health$Appt_Status[sex == "Female"])
table(hall_health$Appt_Status[sex == "Male"])

# no show/show based on age
appt_status_age <- function(min, max) {
  temp <- hall_health %>%
    filter(Age < max, Age >= min) %>%
    select(Appt_Status)
  table(temp)
}

# undergrad students
appt_status_age(0, 23)
# grad students (or mid 20s)
appt_status_age(23, 27)
# grad students (or late 20s to early 30s)
appt_status_age(27, 32)
# late grad students and professors and other alumni 
appt_status_age(32, 100)


# mainly due to weird time handling on  Excel
#times<-c("1899-12-31 08:00:00","1899-12-31 08:30:00","1899-12-31 09:00:00", "1899-12-31 09:30:00","1899-12-31 10:00:00", "1899-12-31 10:30:00","1899-12-31 11:00:00","1899-12-31 11:30:00","1899-12-31 12:00:00","1899-12-31 12:30:00","1899-12-31 13:00:00","1899-12-31 13:30:00","1899-12-31 14:00:00","1899-12-31 14:30:00","1899-12-31 15:00:00","1899-12-31 15:30:00","1899-12-31 16:00:00","1899-12-31 16:30:00","1899-12-31 17:00:00")
times<-c("1899-12-31 00:00:00","1899-12-31 00:30:00","1899-12-31 01:00:00", "1899-12-31 01:30:00","1899-12-31 02:00:00", "1899-12-31 02:30:00","1899-12-31 03:00:00","1899-12-31 03:30:00","1899-12-31 04:00:00","1899-12-31 04:30:00","1899-12-31 05:00:00","1899-12-31 05:30:00","1899-12-31 06:00:00","1899-12-31 06:30:00","1899-12-31 07:00:00","1899-12-31 07:30:00","1899-12-31 08:00:00","1899-12-31 08:30:00","1899-12-31 09:00:00")


# no show rate based on time
no_show_time = 1:19
show_time = 1:19
x = 1:19
for (i in 1:19) {
  temp_table <- table(filter(hall_health, Appt_Time == times[i]) %>%
                        select(Appt_Status))
  show_time[i] <- temp_table[3]
  no_show_time[i] <- temp_table[1]
  x[i] <- no_show_time[i] / (no_show_time[i] + show_time[i])
}

plot(no_show_time, type = "b", ylim = c(0, 1200))
lines(show_time, type = "b", col = "red")

plot(x, type = "b")

sum(no_show_time[1:5]) / (sum(no_show_time[1:5]) + sum(show_time[1:5]))
sum(no_show_time[6:19]) / (sum(no_show_time[6:19]) + sum(show_time[6:19]))

# to see if the patient comes back after no show
# one_missing patients are the ones who missed appointment once but later come back just fine
# no show no return is the one who never comes back after no show
# one_time patients are the one who visits just once
# good patients are the ones who never missed on repeated visits
uniqueness1 <- table(hall_health$PT_ID)
number <- table(uniqueness1)
uniqueness2 <- table(hall_health$PT_ID[Appt_Status == -1])
no_show_numbers <- table(uniqueness2)

no_show_no_return = 0
good_patients = 0
repeated_patients = 0
one_time_patients = 0
one_missing_patients = 0

for (b in unique(hall_health$PT_ID)) {
  a = toString(b)
  array = uniqueness1[a]
  if (array == 1) {
    if (hall_health$Appt_Status[hall_health$PT_ID == a] == -1) {
      no_show_no_return = no_show_no_return + 1
    } else {
      one_time_patients = one_time_patients + 1
    }
  }
  else if (array > 1) {
    numb = sum(hall_health$Appt_Status[hall_health$PT_ID == a] == -1)
    if (numb  == 0) {
      good_patients = good_patients + 1
    } else if (numb == 1) {
      one_missing_patients = one_missing_patients + 1
    } else {
      repeated_patients = repeated_patients + 1
    }
  }
}

number
no_show_no_return + one_time_patients
good_patients
repeated_patients
one_missing_patients


length(unique(hall_health$PT_ID))
length(hall_health$PT_ID[hall_health$Appt_Status == -1])
length(unique(hall_health$PT_ID[hall_health$Appt_Status == -1]))
plot(number)


# no show rates based on appointment dates and time
mean(table(hall_health$Appt_Date))
sd(table(hall_health$Appt_Date))
dates = sort(unique(hall_health$Appt_Date))
total_show_data = matrix(0, 19, length(dates))
total_no_show_data = matrix(0, 19, length(dates))
curr_date = 1

for (day in dates) {
  for (time in 1:19) {
    data_date_time = hall_health$Appt_Status[hall_health$Appt_Date == day & hall_health$Appt_Time == times[time]]
    no_show_date_time = 0
    show_date_time = 0
    if (length(data_date_time) > 0) {
      no_show_date_time = sum(data_date_time == -1)
      show_date_time = sum(data_date_time == 1)
    }
    total_show_data[time, curr_date] = show_date_time
    total_no_show_data[time, curr_date] = no_show_date_time
  }
  curr_date = curr_date + 1
}

total_percentage = total_no_show_data / (total_no_show_data + total_show_data)

# find the hours-based average no show rate
means_no_show_hours = 1:19
means_show_hours = 1:19
for (i in 1:19) {
  means_no_show_hours[i] = mean(total_no_show_data[i,])
  means_show_hours[i] = mean(total_show_data[i,])
}
plot(means_no_show_hours, type = "b", ylim = c(0,4))
lines(means_show_hours, type = "b", col = 2)
means_percentage_hours = means_no_show_hours / (means_no_show_hours + means_show_hours)
plot(means_percentage_hours, type = "b")

# find the days-based average no show rate
means_no_show_days = 1:273
means_show_days = 1:273
for (i in 1:273) {
  means_no_show_days[i] = mean(total_no_show_data[1:19,i])
  means_show_days[i] = mean(total_show_data[1:19,i])
}
plot(means_no_show_days, type = "l", ylim = c(0,4))
lines(means_show_days, type = "l", col = 2)
means_percentage_days = means_no_show_days / (means_no_show_days + means_show_days)
plot(means_percentage_days, type = "l")
abline(no_show_ratio, 0, col = 2)
abline(no_show_ratio + sd(means_percentage_days), 0, col = 3)
abline(no_show_ratio - sd(means_percentage_days), 0, col = 4)

means_no_show_peak = 1:273
means_show_peak = 1:273
means_no_show_non = 1:273
means_show_non = 1:273
for (i in 1:273) {
  means_no_show_peak[i] = mean(total_no_show_data[1:5,i])
  means_show_peak[i] = mean(total_show_data[1:5,i])
  means_no_show_non[i] = mean(total_no_show_data[6:19,i])
  means_show_non[i] = mean(total_show_data[6:19,i])
  
}
means_percentage_peak = means_no_show_peak / (means_no_show_peak + means_show_peak)
means_percentage_non = means_no_show_non / (means_no_show_non + means_show_non)

peak_mean = mean(means_percentage_peak, na.rm=TRUE)
non_mean = mean(means_percentage_non, na.rm=TRUE)

plot(means_percentage_peak, type = "l")
lines(means_percentage_non, type = "l", col = 2)
abline(peak_mean, 0, col = 3)
abline(non_mean, 0, col = 4)


# find the no show rates after the fee introduced
uniqueness_fee <- table(hall_health$PT_ID[hall_health$Appt_Date %in% dates[235:273]])
number_fee <- table(uniqueness_fee)
uniqueness2_fee <- table(hall_health$PT_ID[hall_health$Appt_Date %in% dates[235:273] & hall_health$Appt_Status == -1])
no_show_numbers_fee <- table(uniqueness2_fee)
no_show_no_return_fee = 0
good_patients_fee = 0
repeated_patients_fee = 0
one_time_patients_fee = 0
one_missing_patients_fee = 0

for (b in unique(hall_health$PT_ID[hall_health$Appt_Date %in% dates[235:273]])) {
  a = toString(b)
  array = uniqueness_fee[a]
  if (array == 1) {
    if (hall_health$Appt_Status[hall_health$PT_ID == a & hall_health$Appt_Date %in% dates[235:273]] == -1) {
      no_show_no_return_fee = no_show_no_return_fee + 1
    } else {
      one_time_patients_fee = one_time_patients_fee + 1
    }
  }
  else if (array > 1) {
    numb = sum(hall_health$Appt_Status[PT_ID == a & hall_health$Appt_Date %in% dates[235:273]] == -1)
    if (numb  == 0) {
      good_patients_fee = good_patients_fee + 1
    } else if (numb == 1) {
      one_missing_patients_fee = one_missing_patients_fee + 1
    } else {
      repeated_patients_fee = repeated_patients_fee + 1
    }
  }
}

number_fee
no_show_no_return_fee + one_time_patients_fee
good_patients_fee
repeated_patients_fee
one_missing_patients_fee

# compare the no show rate data after the fee introduced with the ones before
uniqueness_fee_before <- table(hall_health$PT_ID[hall_health$Appt_Date %in% dates[1:234]])
number_fee_before <- table(uniqueness_fee_before)
uniqueness2_fee_before <- table(hall_health$PT_ID[hall_health$Appt_Date %in% dates[1:234] & hall_health$Appt_Status == -1])
no_show_numbers_fee_before <- table(uniqueness2_fee_before)
no_show_no_return_fee_before = 0
good_patients_fee_before = 0
repeated_patients_fee_before = 0
one_time_patients_fee_before = 0
one_missing_patients_fee_before = 0

for (b in unique(hall_health$PT_ID[hall_health$Appt_Date %in% dates[1:234]])) {
  a = toString(b)
  array = uniqueness_fee_before[a]
  if (array == 1) {
    if (hall_health$Appt_Status[hall_health$PT_ID == a & hall_health$Appt_Date %in% dates[1:234]] == -1) {
      no_show_no_return_fee_before = no_show_no_return_fee_before + 1
    } else {
      one_time_patients_fee_before = one_time_patients_fee_before + 1
    }
  }
  else if (array > 1) {
    numb = sum(hall_health$Appt_Status[hall_health$PT_ID == a & hall_health$Appt_Date %in% dates[1:234]] == -1)
    if (numb  == 0) {
      good_patients_fee_before = good_patients_fee_before + 1
    } else if (numb == 1) {
      one_missing_patients_fee_before = one_missing_patients_fee_before + 1
    } else {
      repeated_patients_fee_before = repeated_patients_fee_before + 1
    }
  }
}

number_fee_before
no_show_no_return_fee_before + one_time_patients_fee_before
good_patients_fee_before
repeated_patients_fee_before
one_missing_patients_fee_before


total_data <- total_no_show_data + total_show_data
max(total_data)

hist(Waiting_Days, breaks = 100)

# misc codes
sd(table(hall_health$Appt_Date[hall_health$Appt_Time <= times[10]])) 
sd(table(hall_health$Appt_Date[hall_health$Appt_Time > times[10]]))

hist(hall_health$Appt_Date[hall_health$Appt_Time <= times[10]], breaks = 100)
hist(hall_health$Appt_Date[hall_health$Appt_Time > times[10]], breaks = 100)

table(hall_health$Appt_Time[hall_health$Appt_Time <= times[10]]) 
table(hall_health$Appt_Time[hall_health$Appt_Time > times[10]]) 

table(hall_health$Appt_Status[hall_health$Appt_Date > dates[235]])
table(hall_health$Appt_Status)

facts <- as.factor(hall_health$Appt_Status)

hist(hall_health$Appt_Status, breaks = c(-1.5, -0.5, 0.5, 1.5), main = "no show status of each patients")

table(hall_health$Appt_Type)

length(hall_health$Waiting_Days[hall_health$Waiting_Days<=7]) / length(hall_health$Waiting_Days)
length(hall_health$Waiting_Days[hall_health$Waiting_Days<=7])
sum(table(hall_health$Appt_Status[hall_health$Waiting_Days<=7])[1:2]) / length(hall_health$Waiting_Days[hall_health$Waiting_Days<=7]) 

length(hall_health$Waiting_Days[hall_health$Waiting_Days<=14 & hall_health$Waiting_Days > 7]) / length(hall_health$Waiting_Days)
length(hall_health$Waiting_Days[hall_health$Waiting_Days<=14 & hall_health$Waiting_Days > 7])
sum(table(hall_health$Appt_Status[hall_health$Waiting_Days<=14 & Waiting_Days > 7])[1:2]) / length(Waiting_Days[Waiting_Days<=14 & Waiting_Days > 7]) 

length(Waiting_Days[Waiting_Days<=21 & Waiting_Days > 14]) / length(Waiting_Days)
length(Waiting_Days[Waiting_Days<=21 & Waiting_Days > 14])
sum(table(Appt_Status[Waiting_Days<=21 & Waiting_Days > 14])[1:2]) / length(Waiting_Days[Waiting_Days<=21 & Waiting_Days > 14])

length(Waiting_Days[Waiting_Days<=28 & Waiting_Days > 21]) / length(Waiting_Days)
length(Waiting_Days[Waiting_Days<=28 & Waiting_Days > 21])
sum(table(Appt_Status[Waiting_Days<=28 & Waiting_Days > 21])[1:2]) / length(Waiting_Days[Waiting_Days<=28 & Waiting_Days > 21])


length(Waiting_Days[Waiting_Days>28]) / length(Waiting_Days)
length(Waiting_Days[Waiting_Days>28])
sum(table(Appt_Status[Waiting_Days>28])[1:2]) / length(Waiting_Days[Waiting_Days>28]) 

