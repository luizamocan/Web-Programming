create database organizer_event;
use organizer_event;

create table organizers(
    id int primary key auto_increment,
    username varchar(255),
    mail varchar(255)
);

create table events(
    id int primary key auto_increment,
    title varchar(255),
    location varchar(255),
    capacity int
);

create table registrations(
    id int primary key auto_increment,
    organizer_id int,
    event_id int,
    registration_date datetime,
    foreign key (organizer_id) references organizers(id),
    foreign key (event_id) references events(id)
);

insert into organizers(username,mail)
values
    ('alex','alex@gmail.com'),
    ('luiza','luiza@gmail.com'),
    ('raluca','raluca@gmail.com');

insert into events(title,location,capacity)
values
    ('party','feleac',100),
    ('chef','centru',80),
    ('cina','centru',30),
    ('party','oras', 300);

insert into registrations(organizer_id,event_id,registration_date)
values
    (1,3,'2025-07-07'),
    (1,2,'2025-06-06'),
    (2,1,'2025-06-06') ,
    (3,3,'2025-06-06');
