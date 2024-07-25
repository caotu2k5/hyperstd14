set dateformat dmy
--A: Thực hiện các lệnh truy vấn
--1: Liệt kê danh sách sinh viên của khoa Vật Lý, gồm các thông tin sau:
--Mã sinh viên, Họ tên sinh viên, Ngày sinh. Danh sách sẽ được sắp
--xếp theo thứ tự Ngày sinh giảm dần.
select masv,hoten=hosv+' '+tensv,ngaysinh
from sinhvien inner join khoa on sinhvien.makh=khoa.makh
where tenkh=N'Vật Lý'
order by ngaysinh DESC
--2: Cho biết danh sách các sinh viên có học bổng lớn hơn 100,000,
--gồm các thông tin: Mã sinh viên, Họ tên sinh viên, Mã khoa, Học
--bổng. Danh sách sẽ được sắp xếp theo thứ tự Mã khoa giảm dần.
select masv, hoten=hosv+' '+tensv, makh,hocbong
from sinhvien
where hocbong>100000
order by makh desc
--3: Liệt kê danh sách sinh viên sinh vào ngày 20/12/1981, gồm các
--thông tin: Họ tên sinh viên, Mã khoa, Tên khoa, Học bổng.
select hoten=hosv+' '+tensv,khoa.makh,tenkh,hocbong
from sinhvien inner join khoa on sinhvien.makh=khoa.makh
where ngaysinh='20/12/1981'
--4: Danh sách các nam sinh viên khoa Tin Học có ngày sinh sau ngày 30/05/1981.
select *
from sinhvien inner join khoa on sinhvien.makh=khoa.makh
where ngaysinh > '30/05/1981' and tenkh = N'Tin học' and phai =1
--5: Danh sách những sinh viên có học bổng từ 200000 xuống đến
--000, gồm các thông tin: Mã sinh viên, Ngày sinh, Phái, Mã khoa.
select masv,ngaysinh,makh
from sinhvien
where hocbong between 80000 and 200000
order by hocbong desc
--6: Cho biết những môn học có số tiết lớn hơn 40 và nhỏ hơn 60, gồm
--các thông tin: Mã môn học, Tên môn học, Số tiết.
select *
from monhoc
where sotiet >40 and sotiet<60
--7: Liệt kê các nam sinh viên của khoa Anh văn, gồm các thông tin: Mã sinh viên, Họ tên sinh viên, Phái.
select masv,hoten=hosv+' '+tensv,phai
from sinhvien inner join khoa on sinhvien.makh=khoa.makh
where tenkh=N'Anh Văn' and phai =1
--8: Liệt kê danh sách sinh viên trong khoa Tin học, gồm các thông tin:
--Họ tên sinh viên, Ngày sinh, Mã khoa, Tên khoa, Mã môn, Tên
--môn, Điểm. Danh sách được sắp giảm dần theo Điểm, nếu cùng
--điểm thì sắp tăng dần theo Mã môn.
select hoten=hosv+' '+tensv,ngaysinh,khoa.makh,tenkh,monhoc.mamh,tenmh,diem
from sinhvien inner join khoa on sinhvien.makh=khoa.makh
inner join ketqua on sinhvien.masv=ketqua.masv
inner join monhoc on ketqua.mamh=monhoc.mamh
where tenkh=N'Tin học'
order by diem desc ,monhoc.mamh
--9: liệt kê danh sách sinh viên sinh vào tháng 2 năm 1980, gồm các thông
--tin: Họ tên sinh viên, Phái, Ngày sinh. Trong đó, Ngày sinh chỉ lấy giá trị
--ngày của field NGAYSINH. Sắp xếp dữ liệu giảm dần theo cột Ngày sinh.
select hoten=hosv+' '+tensv,phai,ngaysinh=DAY(ngaysinh)
from sinhvien
where YEAR(ngaysinh) = 1980 and MONTH(ngaysinh)=2
ORDER BY ngaysinh DESC
--10: Cho biết thông tin về mức học bổng của các sinh viên, gồm: Mã sinh
--viên, Phái, Mã khoa, Mức học bổng. Trong đó, mức học bổng sẽ hiển thị
--là “Học bổng cao” nếu giá trị của field học bổng lớn hơn 100,000 và
--ngược lại hiển thị là “Mức trung bình”.
select masv,phai,makh,muchocbong=case when hocbong>100000 then N'Học bổng cao' when hocbong>0 and hocbong<=100000 then N'Mức trung bình' else N'Không có học bổng' end
from sinhvien
--11: Cho biết điểm thi của các sinh viên, gồm các thông tin: Họ tên sinh viên,
--Mã môn học, Điểm. Kết quả sẽ được sắp theo thứ tự Họ tên sinh viên và
--mã môn học tăng dần.
select hoten=hosv+' '+tensv,mamh,diem
from sinhvien inner join ketqua on sinhvien.masv=ketqua.masv
order by hoten asc, mamh asc
--12: Liệt kê bảng điểm của sinh viên khoa Tin Học, gồm các thông tin:
--Tên khoa, Họ tên sinh viên, Tên môn học, Sốt tiết, Điểm.
select tenkh,hoten=hosv+' '+tensv,tenmh,sotiet,diem
from sinhvien inner join khoa on sinhvien.makh=khoa.makh
inner join ketqua on sinhvien.masv=ketqua.masv
inner join monhoc on ketqua.mamh=monhoc.mamh
where tenkh=N'Tin học'
--13: Tổng điểm thi của từng sinh viên, gồm các thông tin: Tên sinh
--viên, Tên khoa, Giới tính, Tổng điểm thi.
select tensv,tenkh,GT=case when phai=1 then 'Nam' else N'Nữ' end, TongDiem = sum(diem)
from sinhvien inner join khoa on sinhvien.makh=khoa.makh
inner join ketqua on sinhvien.masv=ketqua.masv
group by tensv,tenkh,phai
--14: Cho biết tổng số sinh viên ở mỗi khoa, gồm các thông tin: Tên
--khoa, Tổng số sinh viên (liệt kê cả các khoa chưa có sinh viên).
select tenkh,TSSV=count(masv)
from sinhvien right outer join khoa on sinhvien.makh=khoa.makh
group by tenkh
--15: Cho biết điểm cao nhất của mỗi sinh viên, gồm các thông tin: Họ
--tên sinh viên, Điểm cao nhất.
select tensv,DiemCaoNhat=MAX(diem)
from sinhvien inner join ketqua on sinhvien.masv=ketqua.masv
group by tensv
--16: Thông tin của môn học có số tiết nhiều nhất, gồm các thông tin:
--Tên môn học, Số tiết.
select tenmh,sotiet
from monhoc
where sotiet=(select max(sotiet)
from monhoc)
--17: Danh sách các sinh viên rớt trên 2 môn, gồm Mã sinh viên, Họ sinh viên, Tên sinh viên, Mã khoa.
select sinhvien.masv,hosv,tensv,SoMonRot=count(diem)
from sinhvien inner join ketqua on sinhvien.masv=ketqua.masv
where diem in (select diem from ketqua where diem<4)
group by sinhvien.masv,hosv,tensv
having count (diem) >2
--18: Cho biết danh sách những khoa có nhiều hơn 10 sinh viên, gồm Mã
--khoa, Tên khoa, Tổng số sinh viên của khoa.
select khoa.makh,tenkh,TSSV=count(masv)
from sinhvien inner join khoa on sinhvien.makh=khoa.makh
group by khoa.makh,tenkh
having count(masv)>10
--19: Liệt kê danh sách sinh viên chưa thi môn nào, thông tin gồm: Mã sinh
--viên, Mã khoa, Phái.
select sinhvien.masv,makh,phai
from sinhvien inner join ketqua on sinhvien.masv=ketqua.masv
group by sinhvien.masv,makh,phai
having count(mamh)=0
--20: Liệt kê danh sách những sinh viên chưa thi môn Đồ họa, gồm các thông
--tin: Mã sinh viên, Họ tên sinh viên, Mã khoa.
select sinhvien.masv,hoten=hosv+' '+tensv,makh,phai
from sinhvien inner join ketqua on sinhvien.masv=ketqua.masv
where sinhvien.masv not in (select masv from ketqua where mamh='04')
group by sinhvien.masv,hosv+' '+tensv,makh,phai
--21: Cho biết những sinh viên có học bổng lớn hơn tổng học bổng của những
--sinh viên thuộc khoa Tin học.
select *
from sinhvien inner join khoa on sinhvien.makh=khoa.makh
where hocbong>(select sum(hocbong) from sinhvien) and tenkh=N'Tin học'
--22: Danh sách sinh viên có điểm cao nhất ứng với mỗi môn, gồm các thông
--tin: Mã sinh viên, Họ tên sinh viên, Tên môn, Điểm.
select temp.mamh,ketqua.masv,hoten=hosv+' '+tensv,tenmh,diem
from (select mamh,max(diem) as maxdiem
from ketqua
group by mamh) as temp, ketqua, sinhvien,monhoc
where temp.mamh=ketqua.mamh and temp.maxdiem=ketqua.diem and sinhvien.masv=ketqua.masv
and monhoc.mamh=temp.mamh and ketqua.mamh=monhoc.mamh
--B:Tạo view
--23: Tạo view SINHVIEN_KHOA_TH để hiển thị thông tin các SV khoa‘Tin Học’.
CREATE VIEW SINHVIEN_KHOA_TH AS
select masv,hoten=hosv+' '+tensv,ngaysinh,phai,sinhvien.makh,hocbong
from sinhvien inner join khoa on sinhvien.makh=khoa.makh
where tenkh=N'Tin Học'
--24: Xóa view SINHVIEN_KHOA_TH.
drop view SINHVIEN_KHOA_TH
--25: Tạo view hiển thị danh sách các môn học có tên bắt đầu bằng chữ
--‘T’, gồm các cột: Mã môn, Tên môn, Số tiết.
create view MONHOC_view1 as
select mamh,tenmh,sotiet
from monhoc
where tenmh like N'T%'
--26: Tạo view hiển thị danh sách những sinh viên mà họ có chứa chữ ‘Thị’.
create view sinhvien_view1 as
select masv,hoten=hosv+' '+tensv,ngaysinh,phai,sinhvien.makh,hocbong
from sinhvien
where hosv+' '+tensv like N'%Thị%'
--27: Tạo view hiển thị danh sách sinh viên sinh vào ngày ‘20/12/1981’.
create view sinhvien_view2 as
select masv,hoten=hosv+' '+tensv,ngaysinh,phai,sinhvien.makh,hocbong
from sinhvien
where ngaysinh='20/12/1981'

