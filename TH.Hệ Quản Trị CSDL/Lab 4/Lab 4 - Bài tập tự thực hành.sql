--1: Tạo Stored Procedure để thêm nhân viên mới vào bảng NHANVIEN.
create procedure ThemNhanVien
	@MANV char(5),
	@HOTEN nvarchar(50),
	@NGAYSINH datetime,
	@GIOITINH bit,
	@DIACHI nvarchar(100),
	@MAPB char (5),
	@MACV char(5),
	@LUONGCB float,
	@HESOLUONG float
as
begin
	if exists (select 1 from NHANVIEN where @MANV=MANV)
		begin
			print N'Mã nhân viên đã tồn tại'
		end
	else
		begin
			insert into NHANVIEN (MANV, HOTEN, NGAYSINH, GIOITINH, DIACHI,MAPB, MACV, LUONGCB, HESOLUONG)
			values (@MANV, @HOTEN, @NGAYSINH, @GIOITINH, @DIACHI,@MAPB, @MACV, @LUONGCB, @HESOLUONG)
			print N'Thêm nhân viên thành công'
		end
end
--Chạy thực thi
exec ThemNhanVien
	@MANV='001',
	@HOTEN=N'Trần Dần',
	@NGAYSINH='2000-03-03',
	@GIOITINH=1,
	@DIACHI=N'33/33 Nhà 33',
	@MAPB='PB01',
	@MACV='CV01',
	@LUONGCB=10000000,
	@HESOLUONG=1.5

--2: Tạo Stored Procedure để cập nhật thông tin nhân viên.
create procedure CapNhatNhanVien
	@MANV char(5),
	@HOTEN nvarchar(50),
	@NGAYSINH datetime,
	@GIOITINH bit,
	@DIACHI nvarchar(100),
	@MAPB char (5),
	@MACV char(5),
	@LUONGCB float,
	@HESOLUONG float
as
begin
	if not exists (select 1 from NHANVIEN where @MANV=MANV)
		begin
			print N'Mã nhân viên không tồn tại'
		end
	else
		begin
			update NHANVIEN
			set HOTEN=@HOTEN,
			NGAYSINH=@NGAYSINH,
			GIOITINH=@GIOITINH,
			DIACHI=@DIACHI,
			MAPB=@MAPB,
			MACV=@MACV,
			LUONGCB=@LUONGCB,
			HESOLUONG=@HESOLUONG
			where MANV=@MANV
			print N'Cập nhật thông tin nhân viên thành công'
		end
end
--Chạy thực thi
exec CapNhatNhanVien
	@MANV='001',
	@HOTEN=N'Trần Cọp',
	@NGAYSINH='2000-03-03',
	@GIOITINH=1,
	@DIACHI=N'33/33 Nhà 33',
	@MAPB='PB01',
	@MACV='CV01',
	@LUONGCB=10000000,
	@HESOLUONG=1.5
--3: Tạo Stored Procedure để xóa thông tin nhân viên.
create procedure XoaNhanVien
	@MANV char(5)
as
begin
	if not exists (select 1 from NHANVIEN where @MANV=MANV)
		begin
			print N'Mã nhân viên không tồn tại'
		end
	else
		begin
			delete NHANVIEN
			where MANV=@MANV
			print N'Xóa thông tin nhân viên thành công'
		end
end
--Chạy thực thi
exec XoaNhanVien
	@MANV='001'
--4: Tạo Stored Procedure để tìm kiếm thông tin nhân viên theo mã nhân viên.
create procedure TimKiemNhanVien
	@MANV char(5)
as
begin
	if not exists (select 1 from NHANVIEN where @MANV=MANV)
		begin
			print N'Mã nhân viên không tồn tại'
		end
	else
		begin
			select * from NHANVIEN
			where MANV=@MANV
		end
end
--Chạy thực thi
exec TimKiemNhanVien
	@MANV='001'
--5: Tạo Stored Procedure để tính tổng lương của nhân viên trong một tháng.
create procedure TongLuongNV
	@MANV char(5),
	@MONTH int,
	@YEAR int,
	@TongLuong decimal(18,1) output
as
begin
	if not exists (select 1 from NHANVIEN where MANV=@MANV)
	begin
		print N'Mã Nhân viên không tồn tại'
	end
else 
	begin
	select @TongLuong=LUONGCB+LUONGTHUONG+PHUCAP
	from NHANVIEN inner join LUONG on NHANVIEN.MANV=LUONG.MANV
	where NHANVIEN.MANV=@MANV or LUONG.MANV=@MANV
	PRINT N'Tổng lương của nhân viên ' + @MANV +' là: ' + CAST(@TongLuong AS
VARCHAR(15))
	end
end
--Chạy thực thi
declare @TongLuong decimal(18,1);
exec TongLuongNV
	@MANV ='NV01',
	@MONTH =6,
	@YEAR=2023,
	@TongLuong=@TongLuong output
--...
	select @TongLuong as TongLuong


