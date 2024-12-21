use LittleLemonDB;

create view OrdersView as select * from orders where quantity > 2;

Select * from OrdersView;

select c.CustomerID, c.Name, o.OrderID, o.TotalCost, m.itemName, m.itemtype from 
CustomerDetails as c inner join Orders as o on c.CustomerID = o.CustomerID 
inner join Order_Menu as o_and_m on o_and_m.orderID = o.orderID inner join
Menu as m on o_and_m.MenuID = m.MenuID where o.totalcost > 150 ;

select m.itemName from menu as m inner join order_menu as o_m on m.menuID = o_m.menuID
where 2 >= any (select count(orderid) from order_menu group by menuID );

delimiter //

create procedure getMaximumQuantity()
begin
select max(quantity) from Order_Menu;
end //

call getMaximumQuantity() 
;

prepare prepared_statement from "select OrderID, quantity, totalcost from orders inner join customerdetails on orders.customerid
= customerdetails.customerid and orders.customerID = ?; "

set @id = 1;
execute prepared_statement using @id;

delimiter //

create procedure CancelOrder(in id int)
begin
delete from orders where orderID = id;
end //


call cancelorder(1);

insert into customerdetails values (1,'hi', 1232),
(2,'hi', 12232),
 (3,'hi', 123222);


insert into bookings(bookingid, date, tablenumber, customerid) values 
(1, "2022-10-10", 5,1),
(2, "2022-11-12", 3,3),
(3, "2022-10-11", 2,2),
(4, "2022-10-13", 2,1);

delimiter //

create procedure Checkbooking(in bookingDate datetime, in tableNumber int)
begin
select 
case
	when exists (select bookingID from bookings 
		where bookings.date = bookingdate and bookings.tableNumber = tableNumber) 
	then "table is already booked"
    else "table is available for booking"
end;
end //

call checkbooking("2022-11-12", 3);

delimiter //

create procedure AddValidBooking(in bookingDate datetime, in tableNumber int)
begin
start transaction;
set @bookingID = (select max(bookingID) from bookings) + 1;
insert into bookings values(@bookingID, bookingDate, tableNumber, 1 );
case
	when (select count(bookingID) from bookings as b where b.Date = bookingDate
		and b.tableNumber = tableNumber) > 1 then select "failed booking"; rollback;
    else select "success booking"; commit;
	end case;
end //

call AddValidBooking("2022-10-17", 5) ;

delimiter //

create procedure AddBooking(in bookingid int, in customerid int, in bookingDate datetime, in tableNumber int)
begin
insert into bookings values (bookingid, bookingDate, tablenumber, customerid); 
end //

call AddBooking(9,3,"2022-12-30", 4);

select * from bookings ;

delimiter //

create procedure UpdateBooking(in bookingid int, in bookingDate datetime)
begin
update bookings set bookings.date = bookingDate where bookings.bookingid=bookingid ;
end //

call UpdateBooking(9, "2022-12-17");


delimiter //

create procedure CancelBooking(in bookingid int)
begin
delete from bookings where bookings.bookingid = bookingid;
end //

call CancelBooking(5) ;


