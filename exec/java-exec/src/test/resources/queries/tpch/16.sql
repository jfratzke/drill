-- tpch16 using 1395599672 as a seed to the RNG
select
  p.p_brand,
  p.p_type,
  p.p_size,
  count(distinct ps.ps_suppkey) as supplier_cnt
from
  cp.`tpch/partsupp.parquet` ps,
  cp.`tpch/part.parquet` p
where
  p.p_partkey = ps.ps_partkey
  and p.p_brand <> 'Brand#21'
  and p.p_type not like 'MEDIUM PLATED%'
  and p.p_size in (38, 2, 8, 31, 44, 5, 14, 24)
  and ps.ps_suppkey not in (
    select
      s_suppkey
    from
      cp.`tpch/supplier.parquet`
    where
      s_comment like '%Customer%Complaints%'
  )
group by
  p.p_brand,
  p.p_type,
  p.p_size
order by
  supplier_cnt desc,
  p.p_brand,
  p.p_type,
  p.p_size;