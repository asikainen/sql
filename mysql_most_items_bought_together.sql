/*
* Date: 2014-07-27
* Author: Joonas Asikainen <tjasikai@mac.com>
* Description: MySQL script to solve the following problem:  
*
* The table "item_transaction" for each transaction (identified by
* the column "transaction_id" the items bought (identified by
* "item_id" and the price.  
* 
* Problem: figure out the pair of items that are most frequently 
* bought together.
* 
* */

/* drop and create table */
drop table if exists item_transaction;
create table item_transaction (
    transaction_id int not null,
    item_id int not null,
    price float not null,
    primary key (transaction_id, item_id)
);

/* insert artificial data */
truncate table item_transaction;
insert into item_transaction (transaction_id, item_id, price) values (1, 1, 10);
insert into item_transaction (transaction_id, item_id, price) values (1, 2, 10);
insert into item_transaction (transaction_id, item_id, price) values (2, 3, 10);
insert into item_transaction (transaction_id, item_id, price) values (2, 7, 10);
insert into item_transaction (transaction_id, item_id, price) values (3, 1, 10);
insert into item_transaction (transaction_id, item_id, price) values (3, 3, 10);
insert into item_transaction (transaction_id, item_id, price) values (4, 1, 10);
insert into item_transaction (transaction_id, item_id, price) values (4, 2, 10);
insert into item_transaction (transaction_id, item_id, price) values (5, 1, 10);
insert into item_transaction (transaction_id, item_id, price) values (5, 3, 10);
insert into item_transaction (transaction_id, item_id, price) values (6, 1, 10);
insert into item_transaction (transaction_id, item_id, price) values (6, 2, 10);

/* most frequently bought (single) items */
select item_id, count(*) frq
from item_transaction
group by item_id
order by count(*) desc
;

/* pairs of items bought together most frequently */
select item_id1, item_id2, count(*) frq
from (
    select a.transaction_id, a.item_id item_id1, b.item_id item_id2
    from item_transaction a
    inner join item_transaction b
    on a.transaction_id = b.transaction_id
    and a.item_id < b.item_id
    order by a.transaction_id, a.item_id, b.item_id
) sub
group by item_id1, item_id2
order by count(*) desc
;