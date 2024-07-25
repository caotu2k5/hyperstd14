--Phần 1-Bài tập có hướng dẫn
--1. Tạo Function để tính tuổi của sinh viên.
create function TinhTuoi(@NGAYSINH datetime) 
returns int
as
begin
	return datediff(year,@NGAYSINH,getdate())
end
--Thực thi
select dbo.TinhTuoi ('2000-01-01') as Tuoi;
--2. Tạo Function để kiểm tra sinh viên có học bổng hay không.
CREATE FUNCTION KiemTraHocBong(@MASV CHAR(3))
RETURNS bit
AS
	BEGIN
	DECLARE @HOCBONG INT
	SELECT @HOCBONG = HOCBONG FROM SINHVIEN WHERE MASV = @MASV
	IF @HOCBONG>0
		RETURN 1
		RETURN 0
	END
drop function KiemTraHocBong
--Gọi thực thi:
SELECT dbo.KiemTraHocBong('001') AS 'SV1_HocBong'; -- Kết quả: 1
SELECT dbo.KiemTraHocBong('SV2') AS 'SV2_HocBong'; -- Kết quả: 0
SELECT dbo.KiemTraHocBong('A01') AS 'SV3_HocBong'; -- Kết quả: 1
--3. Tạo Function để lấy tên khoa từ mã khoa.
CREATE FUNCTION LayTenKhoa (@MAKH CHAR(2))
RETURNS NVARCHAR(30)
AS
BEGIN
DECLARE @TENKH NVARCHAR(30)
SELECT @TENKH = TENKH FROM KHOA WHERE MAKH = @MAKH
RETURN @TENKH
END
--Thực thi
select dbo.LayTenKhoa ('02') as TenKhoa;
--4. Tạo Function để tính điểm trung bình của một sinh viên.
create function DiemTB (@masv char(3))
returns float
as
	begin
	declare @DiemTb float
	select @DiemTb=avg(DIEM) from KetQua where KetQua.MASV=@masv
	return @DiemTB
	end
--Thực thi
select dbo.DiemTB ('001') as DiemTB
--5. Tạo Function để lấy danh sách các môn học của một sinh viên.
create function DSmonhoc (@masv char(3))
returns nvarchar(50)
as
	begin
	declare @DanhSach nvarchar(50)
	select @DanhSach= COALESCE(@DanhSach + ',',' ') + TENMH from KetQua inner join MonHoc on KetQua.MAMH=MonHoc.MAMH
	where KetQua.MASV=@masv
	return @DanhSach
	end
--Thực thi
select dbo.DSmonhoc('001') as DSMH
--Phần 2-Bài tập SV tự thực hiện
--1. Tạo Function để tính tuổi của nhân viên.
create function TinhTuoi (@ngaysinh datetime)
returns int
as
	begin
	declare @tuoi int
	select @tuoi=DATEDIFF(year,@ngaysinh,GETDATE()) from NHANVIEN where @ngaysinh=NGAYSINH
	return @tuoi
	end
--Thực thi
select dbo.TinhTuoi ('2000-03-03') as Tuoi
--2. Tạo Function để kiểm tra nhân viên có thưởng hay không.
create function KiemTraLuongThuong (@manv char(4))
returns bit
as
	begin
	declare @Luong int
	select @Luong=LUONGTHUONG from LUONG where @manv=MANV
	if @Luong>0
	return 1
	return 0
	end
--Thực thi
select dbo.KiemTraLuongThuong ('NV01') as CheckLT
--3. Tạo Function để lấy tên phòng ban từ mã phòng ban.
create function LayTenPB (@MAPB char(4))
returns NVARCHAR(50)
as
	begin
	declare @TenPB nvarchar(50)
	select @TenPB=TENPB from PHONGBAN where @MAPB=MAPB
	return @TenPB
	end
--Thực thi
select dbo.LayTenPB ('PB01') as TenPB
--4. Tạo Function để tính tổng lương của một nhân viên trong một tháng.
create function Tongluong (@manv char(4), @month bit, @year int)
returns int
as
	begin
	declare @TongLuong int
	select @TongLuong = LUONGCB+LUONGTHUONG+PHUCAP from NHANVIEN inner join LUONG on NHANVIEN.MANV=LUONG.MANV
	where @manv=LUONG.MANV
	return @TongLuong
	end
drop function TongLuong
	--Thực thi
select dbo.TongLuong('NV01',06,2023) as TongLuong
--5. Tạo Function để lấy danh sách các chức vụ của một nhân viên.\
create function DSChucVu (@manv char(4))
returns nvarchar(50)
as
	begin
	declare @TenCV nvarchar (50)
	select @TenCV = COALESCE(@TenCV + ',',' ') + TENCV from NHANVIEN inner join CHUCVU on NHANVIEN.MACV=CHUCVU.MACV
	where @manv=MANV
	return @TenCV
	end
--Thực thi
select dbo.DSChucVu ('NV01') as DSChucVu
