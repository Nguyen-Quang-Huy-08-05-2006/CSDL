-- create database ss15;
-- use ss15;

create table users (
    user_id int primary key auto_increment,
    username varchar(50) unique not null,
    password varchar(255) not null,
    email varchar(100) unique not null,
    created_at datetime default current_timestamp
);

create table user_log (
    log_id int primary key auto_increment,
    user_id int not null,
    action varchar(100) not null,
    log_time datetime default current_timestamp,
    foreign key (user_id) references users(user_id) on delete cascade
);

create table posts (
    post_id int primary key auto_increment,
    user_id int not null,
    content text not null,
    like_count int not null default 0,
    created_at datetime default current_timestamp,
    foreign key (user_id) references users(user_id) on delete cascade
);

create table post_log (
    log_id int primary key auto_increment,
    post_id int not null,
    action varchar(100) not null,
    log_time datetime default current_timestamp,
    foreign key (post_id) references posts(post_id) on delete cascade
);

create table comments (
    comment_id int primary key auto_increment,
    post_id int not null,
    user_id int not null,
    content text not null,
    created_at datetime default current_timestamp,
    foreign key (post_id) references posts(post_id) on delete cascade,
    foreign key (user_id) references users(user_id) on delete cascade
);

create table likes (
    user_id int not null,
    post_id int not null,
    created_at datetime default current_timestamp,
    primary key (user_id, post_id),
    foreign key (user_id) references users(user_id) on delete cascade,
    foreign key (post_id) references posts(post_id) on delete cascade
);

create table friends (
    user_id int not null,
    friend_id int not null,
    status enum('pending','accepted') not null default 'pending',
    created_at datetime default current_timestamp,
    primary key (user_id, friend_id),
    foreign key (user_id) references users(user_id) on delete cascade,
    foreign key (friend_id) references users(user_id) on delete cascade
);

delimiter $$

-- bài 1: đăng ký thành viên (trigger log)
create trigger trg_user_register
after insert on users
for each row
begin
    insert into user_log(user_id, action)
    values (new.user_id, 'register');
end$$

-- bài 2: đăng bài viết (trigger log)
create trigger trg_post_create
after insert on posts
for each row
begin
    insert into post_log(post_id, action)
    values (new.post_id, 'create post');
end$$

create trigger trg_post_delete
after delete on posts
for each row
begin
    insert into post_log(post_id, action)
    values (old.post_id, 'delete post');
end$$

-- bài 3: thích bài viết
create trigger trg_like_add
after insert on likes
for each row
begin
    update posts
    set like_count = like_count + 1
    where post_id = new.post_id;
end$$

-- bài 3: bỏ thích bài viết (chống âm)
create trigger trg_like_remove
after delete on likes
for each row
begin
    update posts
    set like_count = if(like_count > 0, like_count - 1, 0)
    where post_id = old.post_id;
end$$

-- bài 5: chấp nhận lời mời kết bạn -> tạo bản ghi đối xứng accepted
create trigger trg_accept_friend
after update on friends
for each row
begin
    if new.status = 'accepted'
       and old.status = 'pending'
       and not exists (
            select 1 from friends
            where user_id = new.friend_id
              and friend_id = new.user_id
       )
    then
        insert into friends(user_id, friend_id, status)
        values (new.friend_id, new.user_id, 'accepted');
    end if;
end$$

delimiter ;

delimiter $$

-- bài 1: procedure đăng ký user
create procedure sp_register_user(
    in p_username varchar(50),
    in p_password varchar(255),
    in p_email varchar(100)
)
begin
    if p_username is null or trim(p_username) = '' then
        signal sqlstate '45000' set message_text = 'username empty';
    end if;

    if p_password is null or trim(p_password) = '' then
        signal sqlstate '45000' set message_text = 'password empty';
    end if;

    if p_email is null or trim(p_email) = '' then
        signal sqlstate '45000' set message_text = 'email empty';
    end if;

    if exists(select 1 from users where username = p_username) then
        signal sqlstate '45000' set message_text = 'username exists';
    end if;

    if exists(select 1 from users where email = p_email) then
        signal sqlstate '45000' set message_text = 'email exists';
    end if;

    insert into users(username, password, email)
    values(p_username, p_password, p_email);
end$$

-- bài 2: procedure tạo bài viết
create procedure sp_create_post(
    in p_user_id int,
    in p_content text
)
begin
    if not exists(select 1 from users where user_id = p_user_id) then
        signal sqlstate '45000' set message_text = 'user not found';
    end if;

    if p_content is null or trim(p_content) = '' then
        signal sqlstate '45000' set message_text = 'content empty';
    end if;

    insert into posts(user_id, content)
    values(p_user_id, p_content);
end$$

-- bài 4: gửi lời mời kết bạn (chặn gửi trùng 2 chiều + chặn đã accepted)
create procedure sp_send_friend_request(
    in p_sender int,
    in p_receiver int
)
begin
    if p_sender is null or p_receiver is null then
        signal sqlstate '45000' set message_text = 'invalid user';
    end if;

    if p_sender = p_receiver then
        signal sqlstate '45000' set message_text = 'cannot add yourself';
    end if;

    if not exists(select 1 from users where user_id = p_sender) then
        signal sqlstate '45000' set message_text = 'sender not found';
    end if;

    if not exists(select 1 from users where user_id = p_receiver) then
        signal sqlstate '45000' set message_text = 'receiver not found';
    end if;

    -- chặn trùng theo 2 chiều (pending/accepted đều chặn)
    if exists(
        select 1 from friends
        where (user_id = p_sender and friend_id = p_receiver)
           or (user_id = p_receiver and friend_id = p_sender)
    ) then
        signal sqlstate '45000' set message_text = 'already pending/accepted';
    end if;

    insert into friends(user_id, friend_id, status)
    values(p_sender, p_receiver, 'pending');
end$$

-- bài 6: xóa bạn bè (transaction 2 chiều)
create procedure sp_remove_friend(in p_user1 int, in p_user2 int)
begin
    start transaction;

    delete from friends where user_id = p_user1 and friend_id = p_user2;
    delete from friends where user_id = p_user2 and friend_id = p_user1;

    commit;
end$$

-- bài 7: xóa bài viết (kiểm tra tồn tại + đúng chủ)
create procedure sp_delete_post(
    in p_post_id int,
    in p_user_id int
)
begin
    declare owner_id int;

    start transaction;

    select user_id into owner_id
    from posts
    where post_id = p_post_id;

    if owner_id is null then
        rollback;
        signal sqlstate '45000' set message_text = 'post not found';
    end if;

    if owner_id <> p_user_id then
        rollback;
        signal sqlstate '45000' set message_text = 'not owner';
    end if;

    delete from posts where post_id = p_post_id;

    commit;
end$$

-- bài 8: xóa tài khoản (có check tồn tại)
create procedure sp_delete_user(in p_user_id int)
begin
    start transaction;

    delete from users where user_id = p_user_id;

    if row_count() = 0 then
        rollback;
        signal sqlstate '45000' set message_text = 'user not found';
    end if;

    commit;
end$$

delimiter ;

call sp_register_user('alice','123','alice@gmail.com');
call sp_register_user('bob','123','bob@gmail.com');
call sp_register_user('charlie','123','charlie@gmail.com');

call sp_create_post(1,'hello world');
call sp_create_post(2,'first post');
call sp_create_post(1,'mysql is great');

insert into likes(user_id, post_id) values(2,1);
insert into likes(user_id, post_id) values(3,1);
delete from likes where user_id=2 and post_id=1;

call sp_send_friend_request(1,2);
update friends set status='accepted' where user_id=1 and friend_id=2;

call sp_remove_friend(1,2);

call sp_delete_post(2,2);

call sp_delete_user(3);

select * from users;
select * from posts;
select * from friends;
select * from user_log;
select * from post_log;
