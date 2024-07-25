--Phần 1: Bài tập có hướng dẫn
create database QuanLySinhVien 
go
use QuanLySinhVien
go
create table khoa (
	MAKH char(2) primary key,
	TENKH nvarchar(50)
	);
	go
create table SinhVien (
	MASV char (3) not null primary key,
	HOSV nvarchar(15) not null,
	TENSV nvarchar(15) not null ,
	PHAI bit not null check (PHAI in (1,0)),
	NGAYSINH datetime not null,
	NOISINH nvarchar(50) not null,
	MAKH char (2) foreign key (MAKH) references KHOA(MAKH),
	HOCBONG int
	)
go
create table MonHoc (
	MAMH char(2) not null primary key,
	TENMH nvarchar(50) not null,
	SOTIET int not null
	)
go
create table KetQua (
	MASV char (3) not null,
	MAMH char (2) not null,
	DIEM real not null,
	primary key (MAMH,MASV),
	foreign key (MASV) references SinhVien(MASV),
	foreign key (MAMH) references MonHoc(MAMH)
	)
	go

insert into khoa values ('01','Khoa CNTT');
insert into khoa values ('02',N'Khoa Kinh Tế');
go

insert into SinhVien values ('001',N'Nguyễn','An',1,'2000-01-01',N'Hà Nội','01',1000000);
insert into SinhVien values ('002',N'Trần',N'Bình',0,'1999-05-15',N'Hải Phòng','02',2000000);
go

insert into MonHoc values ('M1',N'Toán',30);
insert into MonHoc values ('M2', N'Lý',25); 
go

insert into KetQua values ('001','M1',8.5);
insert into KetQua values ('001','M2',7.0);
insert into KetQua values ('002','M1',9.0);
insert into KetQua values ('002','M2',6.5);
go

select * from SinhVien
select * from khoa
select * from MonHoc
select * from KetQua
go
