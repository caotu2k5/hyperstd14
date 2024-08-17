--c1: Viết một function để tính tổng số tiết học mà một sinh viên đã tham gia dựa trên mã sinh viên.
create function tongsoth (@masv char (3))
returns int
as
begin
	declare @tongth int
	select @tongth = SUM(SOTIET) from KetQua inner join MonHoc on KetQua.MAMH=MonHoc.MAMH
	where @masv=MASV
	return @tongth
end

select dbo.tongsoth ('001') as Tongsoth
--c2: Viết một procedure để xóa một sinh viên khỏi bảng SinhVien và tất cả
--các kết quả học tập của sinh viên đó khỏi bảng KetQua dựa trên mã sinh viên.
create procedure xoasvandkq
	@MASV char(3)
as
begin
	delete KetQua
	where MASV=@MASV
	delete SinhVien
	where MASV=@MASV
end

exec xoasvandkq
	@MASV='3'

--3: Tạo một trigger để tự động tăng giảm số sinh viên ở cột SOSV của bảng
--KHOA khi có thao tác trên bảng SINHVIEN.
create trigger CapNhatSLSV
on SinhVien
after insert,delete
as
begin
	declare @makh char(4)
	select @makh=inserted.MAKH from inserted
	select @makh=deleted.MAKH from deleted
	update khoa
	set SLSV = SLSV + (select count (*) from inserted where @makh=inserted.MAKH)
	from khoa inner join inserted on khoa.MAKH=inserted.MAKH
	update khoa
	set SLSV = SLSV - (select count(*) from deleted where @makh=deleted.MAKH)
	from khoa inner join deleted on khoa.MAKH=deleted.MAKH 
end

--4: Viết một rule để đảm bảo rằng mã khoa (MAKH) trong bảng Khoa phải bắt đầu
--bằng chữ số 0
create rule ktmakh
as @makh like '0%'


sp_bindrule 'ktmakh','khoa.MAKH'
--5: Viết một function để tính điểm trung bình của một sinh viên dựa trên mã sinh viên.
create function tinhdiemtbsv (@masv char(3))
returns float
as
begin
	declare @diemtb float
	select @diemtb = avg(DIEM) from KetQua where @masv=MASV
	return @diemtb
end

select dbo.tinhdiemtbsv ('001') as DiemTb
--6: Viết một procedure để cập nhật học bổng của sinh viên nếu điểm trung
--bình của sinh viên lớn hơn 8.0.
create proc capnhathb
	@masv char(3)
as
begin
	if not exists (select * from SinhVien where MASV=@masv)
	begin
		print N'Mã sinh viên không tồn tại.'
	end
	else if (select AVG(diem) from SinhVien inner join KetQua on SinhVien.MASV=KetQua.MASV where sinhvien.MASV=@masv)<8
	begin
		print N'Điểm trung bình của sinh viên ' + @masv + ' chưa trên 8.'
	end
	else
	begin
		update SinhVien
		set HOCBONG=HOCBONG+200000
		where MASV=@masv
	end
end

exec capnhathb
	@masv='A01'
--7: Tạo một trigger để tự động chèn một thông báo “có 1 SV mới được tạo”
--vào bảng Log khi có một sinh viên mới được thêm vào bảng SinhVien.
create trigger thongbao1 on SinhVien
after insert
as
	begin
	declare @slsv int
	select @slsv=count(*) from inserted
	print N'Có 1 sinh viên mới được tạo.'
	end

--8: Viết một rule để đảm bảo rằng tên môn học (TENMH) không được để trống
--trong bảng MonHoc.
create rule kiemtratenmh
as @tenmh !=''

sp_bindrule 'kiemtratenmh','monhoc.TENMH'
--9: Viết một function để kiểm tra xem một sinh viên có đủ điều kiện nhận
--học bổng không dựa trên điểm trung bình và mức học bổng qui định truyền vào.
create function kthocbong (@masv char(3), @muchb float)
returns nvarchar (50)
as
begin 
	declare @tb nvarchar (50)
	if (select AVG(diem) from SinhVien inner join KetQua on SinhVien.MASV=KetQua.MASV where sinhvien.MASV=@masv)<@muchb
	begin
		set @tb = N'Sinh viên ' + @masv + N' không đủ điều kiện nhận học bổng.'
	end
	else 
	begin
		set @tb = N'Sinh viên ' + @masv + N' đủ điều kiện nhận học bổng.'
	end
	return @tb
end

print dbo.kthocbong ('001',7)


--10: Tạo một trigger để tự động cập nhật điểm trung bình của sinh viên khi có
--thay đổi trong bảng KetQua, đảm bảo rằng điểm phải nằm trong khoảng từ 0 đến 10.
create trigger capnhatdiemtb
on SinhVien
after insert,update,delete
as
begin
	set nocount on;
	update SinhVien
	set DiemTB = (select case when AVG(diem) <0 then 0
	when AVG(diem) > 10 THEN 10 else avg(diem) end
	from KetQua where MASV=SinhVien.MASV)
	from SinhVien
	where exists (select * from inserted where inserted.MASV=SinhVien.MASV) or
		exists (select * from deleted where deleted.MASV=SinhVien.MASV)
end
