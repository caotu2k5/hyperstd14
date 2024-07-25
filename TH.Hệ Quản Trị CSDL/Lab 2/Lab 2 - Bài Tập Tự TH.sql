--1: Liệt kê tất cả các nhân viên và thông tin chi tiết của họ.
select *
from NHANVIEN
--2: Tính tổng lương (bao gồm lương cơ bản, lương thưởng, và phụ cấp) của tất cả các nhân viên trong tháng 6 năm 2023.
select NHANVIEN.MANV,HOTEN, TongLuong = LUONGCB*HESOLUONG+LUONGTHUONG+PHUCAP
from NHANVIEN inner join LUONG on NHANVIEN.MANV=LUONG.MANV
where MONTH(NGAY)=6 and YEAR(NGAY)=2023
--3: Liệt kê các nhân viên thuộc phòng ban "Phòng Kỹ Thuật".
select MANV,HOTEN
from NHANVIEN inner join PHONGBAN on NHANVIEN.MAPB = PHONGBAN.MAPB
where TENPB=N'Phòng Kỹ Thuật'
--4: Tìm kiếm thông tin nhân viên theo mã nhân viên.
select MANV,HOTEN
from NHANVIEN
where MANV='NV02'
--5: Liệt kê các nhân viên có chức vụ "Trưởng Phòng".
select MANV,HOTEN
from NHANVIEN inner join CHUCVU on NHANVIEN.MACV=CHUCVU.MACV
where TENCV=N'Trưởng Phòng'
--6: Tính tổng số nhân viên trong mỗi phòng ban.
select PHONGBAN.MAPB,TENPB,SLNV=COUNT(MANV)
from NHANVIEN inner join PHONGBAN on NHANVIEN.MAPB = PHONGBAN.MAPB
group by PHONGBAN.MAPB,TENPB
--7: Liệt kê thông tin lương của tất cả nhân viên theo từng ngày.
select *
from LUONG
--8: Cập nhật địa chỉ của một nhân viên.
update NHANVIEN 
set DIACHI=N'Sài Gòn'
where MANV='NV03'
--9: Xóa thông tin của một nhân viên theo mã nhân viên.
delete NHANVIEN
where MANV='NV02'
--10: Thêm một nhân viên mới vào bảng NHANVIEN.
insert into NHANVIEN values ('NV04',N'Định Bồn Nước','2004-10-26',1,N'Quảng Ngãi','PB01','CV01',10000000,1.4)
--11: Truy vấn tên các chức vụ và số lượng nhân viên trong từng chức vụ
select TENCV,SLNV=COUNT(MANV)
from NHANVIEN inner join CHUCVU on NHANVIEN.MACV=CHUCVU.MACV
group by TENCV
--12: Truy vấn các nhân viên và tổng lương trong tháng 6/2023, sắp xếp theo tổng lương giảm dần
select NHANVIEN.MANV,HOTEN, TongLuong = LUONGCB*HESOLUONG+LUONGTHUONG+PHUCAP
from NHANVIEN inner join LUONG on NHANVIEN.MANV=LUONG.MANV
where MONTH(NGAY)=6 and YEAR(NGAY)=2023
order by TongLuong DESC
--13: Truy vấn danh sách nhân viên và phòng ban mà nhân viên đó thuộc về, chỉ lấy các
--nhân viên thuộc phòng "Phòng Kỹ Thuật"
select MANV,HOTEN,TENPB
from NHANVIEN inner join PHONGBAN on NHANVIEN.MAPB = PHONGBAN.MAPB
where TENPB=N'Phòng Kỹ Thuật'
--14: Truy vấn danh sách các nhân viên, chức vụ và tổng lương, chỉ lấy các nhân viên có
--tổng lương trên 8 triệu
select NHANVIEN.MANV,HOTEN,TENCV, TongLuong = LUONGCB*HESOLUONG+LUONGTHUONG+PHUCAP
from NHANVIEN inner join LUONG on NHANVIEN.MANV=LUONG.MANV
inner join CHUCVU on NHANVIEN.MACV=CHUCVU.MACV
where LUONGCB*HESOLUONG+LUONGTHUONG+PHUCAP>8000000
--15: Truy vấn tổng số nhân viên và lương trung bình theo phòng ban
select PHONGBAN.MAPB,TENPB,SLNV=COUNT(NHANVIEN.MANV),LuongTB=AVG(LUONGCB*HESOLUONG+LUONGTHUONG+PHUCAP)
from NHANVIEN inner join PHONGBAN on NHANVIEN.MAPB = PHONGBAN.MAPB
inner join LUONG on NHANVIEN.MANV=LUONG.MANV
group by PHONGBAN.MAPB,TENPB
--Ngoại lệ:
insert into LUONG values ('NV04','2023-06-01',800000,600000)
--16: Truy vấn các phòng ban có nhiều hơn 1 nhân viên
select PHONGBAN.MAPB,TENPB,SLNV=COUNT(NHANVIEN.MANV)
from NHANVIEN inner join PHONGBAN on NHANVIEN.MAPB = PHONGBAN.MAPB
group by PHONGBAN.MAPB,TENPB
having COUNT(NHANVIEN.MANV)>1
--17: Truy vấn tổng số nhân viên và lương trung bình theo giới tính, chỉ lấy những
--nhóm có lương trung bình lớn hơn 6 triệu
select GIOITINH = case when GIOITINH=0 then N'Nữ' else 'Nam' end, SLNV=COUNT(NHANVIEN.MANV),LuongTB=AVG(LUONGCB*HESOLUONG+LUONGTHUONG+PHUCAP)
from NHANVIEN inner join LUONG on NHANVIEN.MANV=LUONG.MANV
group by GIOITINH
having AVG(LUONGCB*HESOLUONG+LUONGTHUONG+PHUCAP)>6000000
--18: Truy vấn tổng lương thưởng và phụ cấp của mỗi nhân viên
select NHANVIEN.MANV,HOTEN,TongLuong=LUONGTHUONG+PHUCAP
from NHANVIEN inner join LUONG on NHANVIEN.MANV=LUONG.MANV
--19: Truy vấn tổng lương thưởng và phụ cấp theo phòng ban, chỉ lấy những phòng ban
--có tổng phụ cấp lớn hơn 500000
select PHONGBAN.MAPB,TENPB,TongLuong=SUM(LUONGTHUONG+PHUCAP)
from NHANVIEN inner join PHONGBAN on NHANVIEN.MAPB = PHONGBAN.MAPB
inner join LUONG on NHANVIEN.MANV=LUONG.MANV
group by PHONGBAN.MAPB,TENPB
having SUM(LUONGTHUONG+PHUCAP)>500000
--20: Truy vấn số lượng nhân viên theo từng năm sinh
select 'Năm Sinh'=YEAR(NGAYSINH), SLNV=COUNT(MANV)
from NHANVIEN
group by YEAR(NGAYSINH)
--21: Truy vấn số lượng nhân viên theo năm sinh, chỉ lấy những năm có nhiều hơn 1 nhân viên
select 'Năm Sinh'=YEAR(NGAYSINH), SLNV=COUNT(MANV)
from NHANVIEN
group by YEAR(NGAYSINH)
having COUNT(MANV)>1
--22: Truy vấn tổng lương (lương cơ bản + lương thưởng + phụ cấp) theo chức vụ, sắp xếp theo tổng lương giảm dần
select CHUCVU.MACV,TENCV, TongLuong = SUM(LUONGCB*HESOLUONG+LUONGTHUONG+PHUCAP)
from NHANVIEN inner join LUONG on NHANVIEN.MANV=LUONG.MANV
inner join CHUCVU on NHANVIEN.MACV=CHUCVU.MACV
group by CHUCVU.MACV,TENCV
order by TongLuong desc
--23: Truy vấn số lượng nhân viên và tổng lương cơ bản theo giới tính, chỉ lấy những
--nhóm có tổng lương cơ bản trên 15 triệu
select GIOITINH = case when GIOITINH=0 then N'Nữ' else 'Nam' end, SLNV=COUNT(NHANVIEN.MANV),LuongTB=SUM(LUONGCB)
from NHANVIEN inner join LUONG on NHANVIEN.MANV=LUONG.MANV
group by GIOITINH
having SUM(LUONGCB)>15000000
--24: Truy vấn tổng lương thưởng và phụ cấp của nhân viên trong mỗi phòng ban, chỉ
--lấy những phòng ban có tổng lương thưởng trên 1 triệu
select PHONGBAN.MAPB,TENPB,TongLuongThuong=SUM(LUONGTHUONG),PhuCap=SUM(PHUCAP)
from NHANVIEN inner join PHONGBAN on NHANVIEN.MAPB = PHONGBAN.MAPB
inner join LUONG on NHANVIEN.MANV=LUONG.MANV
group by PHONGBAN.MAPB,TENPB
having SUM(LUONGTHUONG)>1000000