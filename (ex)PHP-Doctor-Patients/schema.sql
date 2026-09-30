create database doctor_patients;
use doctor_patients;

create table doctors(
    id int primary key auto_increment,
    name varchar(255),
    specialization varchar(255)
);


create table patients(
    id int primary key auto_increment,
    name varchar(255),
    diagnosis varchar(255)
);

create table appointments(
    id int primary key auto_increment,
    doctor_id int,
    patient_id int,
    appointment_date date,
    foreign key (doctor_id) references doctors(id),
    foreign key (patient_id) references patients(id)
);


insert into doctors(name,specialization) values
    ('dr. Pop', 'neuro'),
    ('dr. Popescu', 'cardio'),
    ('dr. Mocan', 'psiho'),
    ('dr. Puscas', 'cardio');

insert into patients(name,diagnosis) values
    ('luiza','astm'),
    ('alex','anemie'),
    ('ana','depresie');

insert into appointments(doctor_id,patients,appointment_date)
values
    (1,3,'2025-06-06'),
    (2,2,'2025-07-07'),
    (3,1,'2025-08-08');        