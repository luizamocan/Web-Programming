create database student_course;
use student_course;

create table students(
    id int primary key auto_increment,
    name varchar(255),
    year int
);

create table courses(
    id int primary key auto_increment,
    name varchar(255),
    professor varchar(255)
);

create table enrollments(
    id int primary key auto_increment,
    student_id int,
    course_id int,
    foreign key (student_id) references students(id),
    foreign key (course_id) references courses(id)
);

insert into students(name,year) values
    ('alex',2005),
    ('ana',2004),
    ('bob',1999);

insert into courses(name,professor) values  
    ('OOP','Arthur'),
    ('AI', 'Mihoc'),
    ('MPP', 'Gabi');

insert into enrollments(student_id,course_id) values
    (1,3), --alex mpp        
    (2,2),
    (2,3),
    (3,2);