--C1: Tạo Stored Procedure để thêm sinh viên mới vào bảng SINHVIEN.
create procedure ThemSinhVien
	@MASV char(3),
	@HOSV nvarchar(15),
	@TENSV nvarchar(7),
	@PHAI bit,
	@NGAYSINH datetime,
	@NOISINH nvarchar(15),
	@MAKH char(2),
	@HOCBONG INT
as
begin
if exists (select 1 from SinhVien where MASV=@MASV)
	begin
		print N'Mã sinh viên đã tồn tại'
	end
else 
	begin
	insert into SinhVien (MASV,HOSV,TENSV,PHAI,NGAYSINH,NOISINH,MAKH,HOCBONG)
		values (@MASV,@HOSV,@TENSV,@PHAI,@NGAYSINH,@NOISINH,@MAKH,@HOCBONG)
		print N'Thêm sinh viên thành công'
	end
end
--Chạy thực thi
exec ThemSinhVien
	@MASV ='A01',
	@HOSV=N'Trần',
	@TENSV=N'Dần',
	@PHAI=1,
	@NGAYSINH='2000-01-01',
	@NOISINH=N'TP.HCM',
	@MAKH='CS',
	@HOCBONG=100000;

select * from sinhvien

--C2: Tạo Stored Procedure để cập nhật thông tin sinh viên.
create procedure CapNhatSinhVien
	@MASV char(3),
	@HOSV nvarchar(15),
	@TENSV nvarchar(7),
	@PHAI bit,
	@NGAYSINH datetime,
	@NOISINH nvarchar(15),
	@MAKH char(2),
	@HOCBONG INT
as
begin
if not exists (select 1 from SinhVien where MASV=@MASV)
	begin
		print N'Mã sinh viên không tồn tại'
	end
else 
	begin
	update SinhVien
	set HOSV=@HOSV,
	TENSV=@TENSV,
	PHAI=@PHAI,
	NGAYSINH=@NGAYSINH,
	NOISINH=@NOISINH,
	MAKH=@MAKH,
	HOCBONG=@HOCBONG
		where MASV=@MASV
		print N'Cập nhật sinh viên thành công'
	end
end
--Chạy thực thi
exec CapNhatSinhVien
	@MASV ='A01',
	@HOSV=N'Trần',
	@TENSV=N'Cọp',
	@PHAI=1,
	@NGAYSINH='2000-01-01',
	@NOISINH=N'TP.HCM',
	@MAKH='CS',
	@HOCBONG=100000;

select * from SinhVien
--3: Tạo Stored Procedure để xóa sinh viên khỏi bảng SINHVIEN.
create procedure XoaSinhVien
	@MASV char(3),
	@HOSV nvarchar(15),
	@TENSV nvarchar(7),
	@PHAI bit,
	@NGAYSINH datetime,
	@NOISINH nvarchar(15),
	@MAKH char(2),
	@HOCBONG INT
as
begin
if not exists (select 1 from SinhVien where MASV=@MASV)
	begin
		print N'Mã sinh viên không tồn tại'
	end
else 
	begin
	delete SinhVien
		where MASV=@MASV
		print N'Xóa sinh viên thành công'
	end
end
--Chạy thực thi
exec XoaSinhVien
	@MASV ='A01',
	@HOSV=N'Trần',
	@TENSV=N'Cọp',
	@PHAI=1,
	@NGAYSINH='2000-01-01',
	@NOISINH=N'TP.HCM',
	@MAKH='CS',
	@HOCBONG=100000;

--4: Tạo Stored Procedure để lấy thông tin chi tiết của một sinh viên.
create procedure LayThongTinSV
	@MASV char(3)
as
begin
	if not exists (select 1 from SinhVien where MASV=@MASV)
	begin
		print N'Mã sinh viên không tồn tại'
	end
else 
	begin
	select *
	from SinhVien
	where MASV=@MASV
	end
end
--Chạy thực thi
exec LayThongTinSV
	@MASV ='A01'

--5: Tạo Stored Procedure để tính điểm trung bình của sinh viên.
create procedure DiemTrungBinhSV
	@MASV char(3),
	@DiemTB float output
as
begin
	if not exists (select 1 from SinhVien where MASV=@MASV)
	begin
		print N'Mã sinh viên không tồn tại'
	end
else 
	begin
	select @DiemTB=AVG(diem)
	from KetQua
	where MASV=@MASV
	PRINT N'Điểm trung bình của sinh viên ' + @MASV +' là: ' + CAST(@DiemTB AS
NVARCHAR)
	end
end
--Chạy thực thi
declare @DiemTB float;
exec DiemTrungBinhSV
	@MASV ='001',
	@DiemTB=@DiemTB output
--...
	select @DiemTB as DiemTB

