--1: Truy vấn danh sách sinh viên cùng với tên khoa của họ:
select MASV,HOSV,TENSV,TENKH
from SinhVien inner join khoa on SinhVien.MAKH=khoa.MAKH
--2: Truy vấn danh sách sinh viên và điểm số của họ trong từng môn học:
select SinhVien.MASV,TENSV,TENMH,DIEM
from SinhVien inner join KetQua on SinhVien.MASV=KetQua.MASV
			inner join MonHoc on KetQua.MAMH=MonHoc.MAMH
--3: Truy vấn danh sách sinh viên có học bổng từ 1,000,000 đồng trở lên.
select MASV,HOSV,TENSV, HOCBONG
from SinhVien
where HOCBONG>1000000
--4: Truy vấn tên các môn học cùng với số lượng sinh viên đăng ký học mỗi môn:
select TENMH,SLSV = count (MASV)
from MonHoc inner join KetQua on MonHoc.MAMH=KetQua.MAMH
group by TENMH
--5: Truy vấn danh sách sinh viên và điểm trung bình của họ trong các môn học:
select SinhVien.MASV,HOSV,TENSV,DiemTB=AVG(Diem)
from SinhVien inner join KetQua on SinhVien.MASV=KetQua.MASV
group by SinhVien.MASV,HOSV,TENSV
--6: Truy vấn danh sách các khoa và số lượng sinh viên trong mỗi khoa.
select TENKH,SLSV=count(MASV)
from SinhVien inner join khoa on SinhVien.MAKH=khoa.MAKH
group by TENKH
--7: Truy vấn danh sách sinh viên và số lượng môn học mà mỗi sinh viên đã đăng ký học.
select SinhVien.MASV,HOSV,TENSV,SLMH=count(MonHoc.MAMH)
from SinhVien inner join KetQua on SinhVien.MASV=KetQua.MASV
			inner join MonHoc on KetQua.MAMH=MonHoc.MAMH
group by SinhVien.MASV,HOSV,TENSV
--8: Truy vấn danh sách sinh viên có điểm môn "Toán" lớn hơn 8.
select SinhVien.MASV,HOSV,TENSV
from SinhVien inner join KetQua on SinhVien.MASV=KetQua.MASV
inner join MonHoc on KetQua.MAMH=MonHoc.MAMH
where TENMH=N'Toán'and DIEM>8
--9: Truy vấn danh sách sinh viên và tuổi của họ (dựa trên ngày sinh).
select MASV,HOSV,TENSV,Tuoi=YEAR(getdate())-YEAR(NGAYSINH)
from SinhVien
--10: Truy vấn danh sách sinh viên và điểm cao nhất mà mỗi sinh viên đã đạt được.
select SinhVien.MASV,HOSV,TENSV,DiemCaoNhat=MAX(DIEM)
from SinhVien inner join KetQua on SinhVien.MASV=KetQua.MASV
group by SinhVien.MASV,HOSV,TENSV