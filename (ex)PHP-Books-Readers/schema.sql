create database books_readers;
use books_readers;

create table readers(
    id int primary key auto_increment,
    name varchar(255),
    city varchar(255)
);


create table books(
    id int primary key auto_increment,
    title varchar(255),
    genre varchar(255)
);

create table friendships(
    id int primary key auto_increment,
    reader1_id int,
    reader2_id int,
    book_id int,
    foreign key (reader1_id) references readers(id),
    foreign key (reader2_id) references readers(id),
    foreign key (book_id) references books(id)
);

insert into readers(name,city) values
    ('luiza','cluj'),
    ('alex','cluj'),
    ('raluca','bucuresti'),
    ('vlad', 'bucuresti'),
    ('ale','bistrita'),
    ('diana','arad');

insert into books(title,genre) values
    ('book1','comedy'),
    ('book2','drama'),
    ('book3','comedy'),
    ('book4','drama'),
    ('book5','horror');

insert into friendships(reader1_id,reader2_id,book_id) values
    (1,2,3),
    (1,3,2),
    (2,4,1),
    (3,6,2),
    (4,5,3); 
