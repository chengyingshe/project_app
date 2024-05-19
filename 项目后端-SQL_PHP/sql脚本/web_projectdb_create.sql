# 创建数据库
create database if not exists webproject;
use webproject;
# 创建表，存储用户信息
create table user
(
	id int not null auto_increment,
	pwd varchar(20) not null,
	phone varchar(11) not null default '',
    name varchar(10) not null default '',
    department tinyint not null default 0,  #0,1,2
    gender tinyint not null default 1,  #0,1
    address varchar(20) not null default '',
    primary key(id)  #定义主键
)engine=InnoDB;

#创建表，存储问题单
create table problist
(
	prob_id int not null auto_increment,
    prob_image mediumblob null,   #问题图片
    prob_taken_time TIMESTAMP null DEFAULT CURRENT_TIMESTAMP,  #问题提出日期
	solve_state tinyint not null default 0,   #问题状态0,1,2
    solve_ddl int null,   #问题预期解决时间（天）
	solve_person int null,  #解决问题的人（user-id）
	solve_image mediumblob null,  #问题解决后的图片
    primary key(prob_id)
)engine=InnoDB;

#创建表，存储text文本，使用MyISAM引擎，用于fulltext全文本搜索
create table text
(
	prob_id int not null,
	description text null,   #问题描述
    analyse text null,   #问题分析
    solution text null,   #问题解决方案
    fulltext(description),
    fulltext(analyse),
	fulltext(solution)
)engine=MyISAM;

#定义外键
alter table text
add constraint fk_text_problist
foreign key (prob_id) references problist (prob_id);

alter table problist
add constraint fk_problist_user
foreign key (solve_person) references user (id);

#定义insert触发器
#每次新建一个问题单需传入description、prob_image、prob_taken_time参数
#并向problist中insert一行新的数据，此时触发器会insert一行到text中
use webproject;
delimiter //
#创建insert触发器
create trigger new_text
after insert on problist
for each row
begin
	set @new_prob_id = new.prob_id;  #获取刚添加的新行中的prob_id
	insert into text(prob_id)
	values(@new_prob_id);
end//

#创建delete触发器
create trigger drop_text
before delete on problist
for each row
begin
	delete from text where prob_id = old.prob_id;
end//

# 创建过程，每次产出一行数据时更新表单中的prob_id顺序
delimiter //
create procedure order_problist_after_delete()
begin
	declare finish bool default false;
    declare `order` int default 1;
    declare cur_problist_id int;
    declare cur_text_id int;
	declare id cursor for
    select prob_id from problist;
	declare text_id cursor for
    select prob_id from `text`;
    declare continue handler for sqlstate '02000' set finish = true;
    open id;
    open text_id;
    repeat
		fetch id into cur_problist_id;
        fetch text_id into cur_text_id;
		if cur_problist_id != `order` then
			update problist set prob_id = `order` where prob_id = cur_problist_id;
		end if;
        if cur_text_id != `order` then
			update `text` set prob_id = `order` where prob_id = cur_text_id;
		end if;
		set `order` = `order` + 1;
    until finish end repeat;
    close id;
    close text_id;
end//
delimiter ;

