Select w.name as warehouse_name,sum(p.Width * p.Length * p.Height * w.units) as volume
From Warehouse w
Left join Products p
On w.product_id = p.product_id
Group by warehouse_name