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
