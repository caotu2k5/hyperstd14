--Phần 1-Bài tập có hướng dẫn
--1.	Tạo Rule để ràng buộc giá trị học bổng. 
create rule HocBongRule
as @HocBong between 0 and 5000

--AD cho cột HOCBONG của bảng SINHVIEN

sp_bindrule 'HocBongRule','SinhVien.HOCBONG'

select *
 from SinhVien
 --2.	Tạo Rule để ràng buộc giá trị điểm.
 create rule DiemRule
 as @Diem between 0 and 10
 --AD cho cột DIEM của bảng KETQUA
 sp_bindrule 'DiemRule','KetQua.DIEM'

 --3.	Tạo Rule để ràng buộc mã khoa.
 create rule MAKHRule
 as len(@makh) =2
 --AD cho cột MAKH của bảng KHOA
 sp_bindrule 'MAKHRule','Khoa.MAKH'

 --4.	Tạo Rule để ràng buộc giới tính.
 create rule GTRule
 as @GioiTinh in (0,1)
 --AD cho cột PHAI của bảng SINHVIEN
 sp_bindrule 'GTRule', 'SinhVien.PHAI'

 --5.	Tạo Rule để ràng buộc ngày sinh.
 
 create rule NgaySinhRule
 AS @NgaySinh <= getdate()
 --AD cho cột NGAYSINH của bảng SINHVIEN
 sp_bindrule 'NgaySinhRule','SinhVien.NGAYSINH'

 --Phần 2-Bài tập SV tự thực hiện
 --1.	Tạo Rule để ràng buộc giá trị lương cơ bản. 
 create rule LuongCBRule
 as @LuongCB between 3000 and 20000
 --AD cho cột LUONGCB của bảng NHANVIEN
 sp_bindrule 'LuongCBRule','NhanVien.LUONGCB'

 --2.	Tạo Rule để ràng buộc giá trị hệ số lương. 
 create rule HSLuongRule
 as @HeSoLuong between 1.0 and 5.0
  --AD cho cột HESOLUONG của bảng NHANVIEN
 sp_bindrule 'HSLuongRule','NhanVien.HESOLUONG'

 --3.	Tạo Rule để ràng buộc giá trị lương thưởng. 
 create rule LuongThuongRule
 as @LuongThuong >=0
  --AD cho cột LUONGTHUONG của bảng LUONG
 sp_bindrule 'LuongThuongRule','Luong.LUONGTHUONG'

 --4.	Tạo Rule để ràng buộc giá trị phụ cấp.
 create rule PhuCapRule
 as @PhuCap >=0
  --AD cho cột PHUCAP của bảng LUONG
 sp_bindrule 'PhuCapRule','Luong.PHUCAP'

 --5.	Tạo Rule để ràng buộc mã phòng ban. 
 create rule MAPBRule
 as len(@MAPB) =5
  --AD cho cột MAPB của bảng PHONGBAN
 sp_bindrule 'MAPBRule','PhongBan.MAPB'

 select * from NHANVIEN
 select * from LUONG

 insert into NHANVIEN values ('002','vnw2','2000-02-02',1,'22/22.22','PB01','CV02',20000,1.5)
 