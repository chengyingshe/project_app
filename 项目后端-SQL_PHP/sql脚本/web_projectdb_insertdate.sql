#向MySQL数据库中插入数据
use webproject;
#向user表中插入用户信息
#department: 0:生产员，1:问题环节负责生产员，2：技术员
#gender：0：woman，1：man
insert into user (id, pwd, name, department, gender)
values
(100000, '100000', 'aaa', 0, 0), 
(100001, '100001', 'bbb', 1, 1),
(100002, '100002', 'ccc', 2, 1);

#向problist和text中插入数据