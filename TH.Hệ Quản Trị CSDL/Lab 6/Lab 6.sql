--Phần 1-Bài tập có hướng dẫn
--1. Tạo Trigger để cập nhật thông tin học bổng.
create table ThongBao (
ID int identity (1,1),
MASV char (3),
NoiDung nvarchar (255),
NgayThongbao datetime default getdate()
)
go

create trigger CapNhatHocBong
on SinhVien
after update
as
	begin
	declare @masv char(3), @hocbong int
	select @masv=inserted.MASV, @hocbong=inserted.HOCBONG
	from inserted
	if @hocbong>1000
		begin
		insert into ThongBao (MASV,NoiDung) values (@masv,N'Sinh viên có học bổng mới là: ' + cast (@hocbong as varchar(50)))
		end
	end

select * from Thongbao
--Chạy thử
update SinhVien
set HOCBONG = 5000
where MASV='003'
select * from SinhVien
--2. Tạo Trigger để kiểm tra dữ liệu khi thêm mới sinh viên.
create trigger KiemTraMaKhoa on SinhVien
instead of insert
as
	begin
	declare @makh char(2)
	select @makh=inserted.MAKH
	from inserted
	if not exists (select * from khoa where @makh=MAKH)
		begin
		raiserror (N'Mã khoa không tồn tại',16,1)
		rollback transaction
		end
	end
	drop trigger KiemTraMaKhoa
--Chạy thử
insert into SinhVien values ('005','vnw','2',1,'2000-02-02','vnw','08',2000)
--3. Tạo Trigger để tự động cập nhật ngày sửa đổi cuối cùng.
create trigger CapNhatNSDC
on SinhVien
after update
as
	begin
	declare @masv char (3)
	select @masv = inserted.MASV
	from inserted
	update SinhVien
	set NgaySuaDoiCuoi=GETDATE()
	where @masv=MASV
	end

drop trigger CapNhatNSDC
--Chạy thử
update SinhVien 
set HOCBONG=4000
where MASV='003'
select * from SinhVien
--4. Tạo Trigger để tự động tạo mã sinh viên mới.
create trigger TuDongTaoMaSV on SinhVien
instead of insert
as
	begin
	declare @STT int
	select @STT  = ISNULL (max(cast(substring(MASV,3,3) as int)),0)+1
	from SinhVien
	insert into SinhVien (MASV,HOSV,TENSV,PHAI,NGAYSINH,NOISINH,MAKH,HOCBONG)
	select @STT,HOSV,TENSV,PHAI,NGAYSINH,NOISINH,MAKH,HOCBONG
	from inserted
	end
	drop trigger TuDongTaoMaSV
--Chạy thử
insert into SinhVien values ('008','vnw','4',1,'2000-04-04','vnw','01',3000,'2024-01-02')
--5. Tạo Trigger để kiểm tra điểm số khi cập nhật.
create trigger KiemTraDiem on KetQua
instead of update 
as
	begin
	declare @diem real
	select @diem = inserted.DIEM
	from inserted
	if @diem > 10 or @diem < 0
		begin
		raiserror(N'Điểm phải nằm trong khoảng từ 0 đến 10',16,1)
		rollback transaction
		end
	end
--Chạy thử
update KetQua
set DIEM=9
where MASV='001'
--Phần 2-Bài tập SV tự thực hiện
--1. Tạo Trigger để cập nhật thông tin lương thưởng.
create trigger CapNhatLuongThuong
on NHANVIEN
after update
as
	begin
	declare @manv char(4),@LuongCB int
	select @manv=inserted.MANV, @LuongCB=inserted.LUONGCB
	from inserted
	if @LuongCB>5000
		begin
		update LUONG
		set LUONGTHUONG= @LuongCB*0.1
		where @manv=MANV
		end
	end


--Chạy thử
update NHANVIEN
set LUONGCB=6000
where MANV='NV01'
select * from NHANVIEN inner join LUONG on NHANVIEN.MANV=LUONG.MANV
--2. Tạo Trigger để kiểm tra dữ liệu khi thêm mới nhân viên.
create trigger KiemTraPB on NHANVIEN
instead of insert
as
	begin
	declare @mapb char(4)
	select @mapb=inserted.MAPB
	from inserted
	if not exists (select * from PHONGBAN where @mapb=MAPB)
		begin
		raiserror (N'Mã phòng ban không tồn tại',16,1)
		rollback transaction
		end
	end
--Chạy thử
insert into NHANVIEN values ('NV05','vnw','2000-02-02',1,'vnw','PB06','CV01',2000,1.4)
--3. Tạo Trigger để tự động cập nhật ngày sửa đổi cuối cùng.
alter table NHANVIEN add NgaySuaDoiCuoi datetime

create trigger CapNhatNSDC
on NHANVIEN
after update
as
	begin
	declare @manv char (4)
	select @manv = inserted.MANV
	from inserted
	update NHANVIEN
	set NgaySuaDoiCuoi=GETDATE()
	where @manv=MANV
	end

drop trigger CapNhatNSDC
--Chạy thử
update NHANVIEN
set LUONGCB=14000
where MANV='NV02'
--4. Tạo Trigger để tự động tạo mã nhân viên mới.
create trigger TuDongTaoMaNV on NHANVIEN
instead of insert
as
	begin
	declare @STT int
	select @STT  = ISNULL (max(cast(substring(MANV,4,4) as int)),0)+1
	from NHANVIEN
	insert into NHANVIEN(MANV,HOTEN,NGAYSINH,GIOITINH,DIACHI,MAPB,MACV,LUONGCB,HESOLUONG)
	select @STT,HOTEN,NGAYSINH,GIOITINH,DIACHI,MAPB,MACV,LUONGCB,HESOLUONG
	from inserted
	end

--Chạy thử
insert into NHANVIEN values ('NV06','vnw2','2001-03-04',0,'vnw','PB03','CV02',8000,1.9)
--5. Tạo Trigger để kiểm tra lương cơ bản khi cập nhật.
create trigger KiemTraLuongCB on NHANVIEN
instead of update 
as
	begin
	declare @LuongCB int
	select @LuongCB = inserted.LUONGCB
	from inserted
	if @LuongCB <3000 or @LuongCB >20000
		begin
		raiserror(N'Lương cơ bản phải nằm trong khoảng từ 3000 đến 20000',16,1)
		rollback transaction
		end
	end
--Chạy thử
update NHANVIEN
set LUONGCB=20000
where MANV='NV04'