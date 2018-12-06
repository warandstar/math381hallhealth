library(readxl)

hall_health_data <- as.matrix(read_excel("MHApptData_Fixed.xlsx", col_types = c("numeric", "date", "date", "numeric", "text", "text", "numeric", "numeric", "text", "numeric", "text", "text")))


PT_ID = strtoi(hall_health_data[,1])

Appt_Date = as.Date(hall_health_data[,2])

Appt_Time = hall_health_data[,3]

time_distribution <- table(Appt_Time)

Appt_Type <- hall_health_data[,5]


Appt_Status <- strtoi(hall_health_data[,4])

Waiting_Days <- strtoi(hall_health_data[,8])

sex <- hall_health_data[,9]

age <- strtoi(hall_health_data[,10])

table(sex)
table(age)
table(Appt_Status)
table(Waiting_Days)

hist(Appt_Status)
hist(Waiting_Days)
hist(age)

no_show_ratio = sum(Appt_Status == -1) / length(Appt_Status)

table(Appt_Status[Waiting_Days<=7])
table(Appt_Status[Waiting_Days > 7 & Waiting_Days <= 14])
table(Appt_Status[Waiting_Days > 14 & Waiting_Days <= 21])
table(Appt_Status[Waiting_Days > 21 & Waiting_Days <= 28])
table(Appt_Status[Waiting_Days > 28])

table(Appt_Status[sex == "Female"])
table(Appt_Status[sex == "Male"])

table(Appt_Status[age < 23])
table(Appt_Status[age >= 23 & age < 27])
table(Appt_Status[age >= 27 & age < 32])
table(Appt_Status[age >= 32])

times<-c("1899-12-30 07:30:00", "1899-12-30 08:00:00","1899-12-30 08:30:00","1899-12-30 09:00:00", "1899-12-30 09:30:00","1899-12-30 10:00:00", "1899-12-30 10:30:00","1899-12-30 11:00:00","1899-12-30 11:30:00","1899-12-30 12:00:00","1899-12-30 12:30:00","1899-12-30 13:00:00","1899-12-30 13:30:00","1899-12-30 14:00:00","1899-12-30 14:30:00","1899-12-30 15:00:00","1899-12-30 15:30:00","1899-12-30 16:00:00","1899-12-30 16:30:00","1899-12-30 17:00:00","1899-12-30 17:30:00")

no_show_time = 1:21
show_time = 1:21
x = 1:21
no_show_time[1] = no_show_time[21] = 0
show_time[1] = table(Appt_Status[Appt_Time == times[1]])[1]
show_time[21] = table(Appt_Status[Appt_Time == times[21]])[1]
for (i in 2:20) {
  if (!is.null(table(Appt_Status[Appt_Time == times[i]])[2])) {
    no_show_time[i] = table(Appt_Status[Appt_Time == times[i]])[1]
    show_time[i] = table(Appt_Status[Appt_Time == times[i]])[2]
  } else {
    no_show_time[i] = 0
    show_time[i] = table(Appt_Status[Appt_Time == times[i]])[1]
  }

}

for (i in 1:21) {
  x[i] <- no_show_time[i] / (no_show_time[i] + show_time[i])
}


plot(no_show_time[2:20], type = "b", ylim = c(0, 1200))
lines(show_time[2:20], type = "b", col = "red")

plot(x, type = "b")


sum(no_show_time[2:6]) / (sum(no_show_time[2:6]) + sum(show_time[2:6]))
sum(no_show_time[7:20]) / (sum(no_show_time[7:20]) + sum(show_time[7:20]))


uniqueness1 <- table(PT_ID)
number <- table(uniqueness1)
uniqueness2 <- table(PT_ID[Appt_Status == -1])
no_show_numbers <- table(uniqueness2)
no_show_no_return = 0
good_patients = 0
repeated_patients = 0
one_time_patients = 0
one_missing_patients = 0

for (b in unique(PT_ID)) {
  a = toString(b)
  array = uniqueness1[a]
  if (array == 1) {
    if (Appt_Status[PT_ID == a] == -1) {
      no_show_no_return = no_show_no_return + 1
    } else {
      one_time_patients = one_time_patients + 1
    }
  }
  else if (array > 1) {
    numb = sum(Appt_Status[PT_ID == a] == -1)
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


length(unique(PT_ID))
length(PT_ID[Appt_Status == -1])
length(unique(PT_ID[Appt_Status == -1]))
plot(number)


mean(table(Appt_Date))
sd(table(Appt_Date))
dates = sort(unique(Appt_Date))
total_show_data = matrix(0, 21, length(dates))
total_no_show_data = matrix(0, 21, length(dates))
curr_date = 1
for (day in dates) {
  for (time in 1:21) {
    data_date_time = Appt_Status[Appt_Date == day & Appt_Time == times[time]]
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

means_no_show_hours = 1:21
means_show_hours = 1:21
for (i in 1:21) {
  means_no_show_hours[i] = mean(total_no_show_data[i,])
  means_show_hours[i] = mean(total_show_data[i,])
}
plot(means_no_show_hours, type = "b", ylim = c(0,4))
lines(means_show_hours, type = "b", col = 2)
means_percentage_hours = means_no_show_hours / (means_no_show_hours + means_show_hours)
plot(means_percentage_hours, type = "b", ylim = c(0.2, 0.3))

means_no_show_days = 1:273
means_show_days = 1:273
for (i in 1:273) {
  means_no_show_days[i] = mean(total_no_show_data[2:20,i])
  means_show_days[i] = mean(total_show_data[2:20,i])
}
plot(means_no_show_days, type = "l", ylim = c(0,4))
lines(means_show_days, type = "l", col = 2)
means_percentage_days = means_no_show_days / (means_no_show_days + means_show_days)
plot(means_percentage_days, type = "l")
abline(no_show_ratio, 0, col = 2)
abline(no_show_ratio + sd(means_percentage_days), 0, col = 3)
abline(no_show_ratio - sd(means_percentage_days), 0, col = 4)

stand = sd(means_percentage_days)

means_no_show_peak = 1:273
means_show_peak = 1:273
means_no_show_non = 1:273
means_show_non = 1:273
for (i in 1:273) {
  means_no_show_peak[i] = mean(total_no_show_data[2:6,i])
  means_show_peak[i] = mean(total_show_data[2:6,i])
  means_no_show_non[i] = mean(total_no_show_data[7:20,i])
  means_show_non[i] = mean(total_show_data[7:20,i])
  
}
means_percentage_peak = means_no_show_peak / (means_no_show_peak + means_show_peak)
means_percentage_non = means_no_show_non / (means_no_show_non + means_show_non)

peak_mean = mean(means_percentage_peak, na.rm=TRUE)
non_mean = mean(means_percentage_non, na.rm=TRUE)

plot(means_percentage_peak, type = "l")
lines(means_percentage_non, type = "l", col = 2)
abline(peak_mean, 0, col = 3)
abline(non_mean, 0, col = 4)


uniqueness_fee <- table(PT_ID[Appt_Date %in% dates[235:273]])
number_fee <- table(uniqueness_fee)
uniqueness2_fee <- table(PT_ID[Appt_Date %in% dates[235:273] & Appt_Status == -1])
no_show_numbers_fee <- table(uniqueness2_fee)
no_show_no_return_fee = 0
good_patients_fee = 0
repeated_patients_fee = 0
one_time_patients_fee = 0
one_missing_patients_fee = 0

for (b in unique(PT_ID[Appt_Date %in% dates[235:273]])) {
  a = toString(b)
  array = uniqueness_fee[a]
  if (array == 1) {
    if (Appt_Status[PT_ID == a & Appt_Date %in% dates[235:273]] == -1) {
      no_show_no_return_fee = no_show_no_return_fee + 1
    } else {
      one_time_patients_fee = one_time_patients_fee + 1
    }
  }
  else if (array > 1) {
    numb = sum(Appt_Status[PT_ID == a & Appt_Date %in% dates[235:273]] == -1)
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

uniqueness_fee_before <- table(PT_ID[Appt_Date %in% dates[1:234]])
number_fee_before <- table(uniqueness_fee_before)
uniqueness2_fee_before <- table(PT_ID[Appt_Date %in% dates[1:234] & Appt_Status == -1])
no_show_numbers_fee_before <- table(uniqueness2_fee_before)
no_show_no_return_fee_before = 0
good_patients_fee_before = 0
repeated_patients_fee_before = 0
one_time_patients_fee_before = 0
one_missing_patients_fee_before = 0

for (b in unique(PT_ID[Appt_Date %in% dates[1:234]])) {
  a = toString(b)
  array = uniqueness_fee_before[a]
  if (array == 1) {
    if (Appt_Status[PT_ID == a & Appt_Date %in% dates[1:234]] == -1) {
      no_show_no_return_fee_before = no_show_no_return_fee_before + 1
    } else {
      one_time_patients_fee_before = one_time_patients_fee_before + 1
    }
  }
  else if (array > 1) {
    numb = sum(Appt_Status[PT_ID == a & Appt_Date %in% dates[1:234]] == -1)
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


sd(table(Appt_Date[Appt_Time <= times[10]])) 
sd(table(Appt_Date[Appt_Time > times[10]]))

hist(Appt_Date[Appt_Time <= times[10]], breaks = 100)
hist(Appt_Date[Appt_Time > times[10]], breaks = 100)

table(Appt_Time[Appt_Time <= times[10]]) 
table(Appt_Time[Appt_Time > times[10]]) 

table(Appt_Status[Appt_Date > dates[235]])
table(Appt_Status)

facts <- as.factor(Appt_Status)

hist(Appt_Status, breaks = c(-1.5, -0.5, 0.5, 1.5), main = "no show status of each patients")

table(Appt_Type)
