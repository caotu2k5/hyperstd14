--1 Tạo người dùng readOnlyUser chỉ có quyền đọc dữ liệu từ tất cả các bảng trong cơ sở dữ liệu quanLyNhanVien
create login readuser with password ='1234'
use QuanLyNhanVien
create user readuser for login readuser
go

grant select on chucvu to readuser
grant select on luong to readuser
grant select on nhanvien to readuser
grant select on phongban to readuser
go
--2 Tạo người dùng updateUser có quyền cập nhật (UPDATE) dữ liệu trong bảng NhanVien.
create login updateuser with password ='123'
use QuanLyNhanVien
create user updateuser for login updateuser
go

grant update on nhanvien to updateuser
--3 Tạo người dùng modifyUser có quyền chèn (INSERT) và xóa (DELETE) dữ liệu trong bảng DuAn.
create login modflyuser with password ='123'
use QuanLyNhanVien
create user modflyuser for login modflyuser
go

grant insert,delete on DuAn to modflyuser
--4 Tạo vai trò dataEntryRole có quyền chèn (INSERT) dữ liệu vào bảng NhanVien và
--PhanCong. Gán vai trò này cho người dùng entryUser.
create login entryuser with password ='123'
use QuanLyNhanVien
create user entryuser for login entryuser
go

use QuanLyNhanVien
create role dataentryrole
go

grant insert on nhanvien to dataentryrole
grant insert on phancong to dataentryrole
go

alter role dataentryrole add member entryuser
go
--5 Thu hồi quyền cập nhật (UPDATE) từ người dùng updateUser trên bảng NhanVien.
revoke update on nhanvien to updateuser
go
--6 Tạo người dùng limitedUser chỉ có quyền đọc dữ liệu từ bảng PhongBan và NhanVien,
--nhưng không có quyền đọc từ các bảng khác.
create login limiteduser with password ='123'
use QuanLyNhanVien
create user limiteduser for login limiteduser
go

grant select on phongban to limiteduser
grant select on nhanvien to limiteduser
go
--7 Tạo người dùng projectManager có quyền đọc (SELECT), chèn (INSERT), cập nhật
--(UPDATE), và xóa (DELETE) dữ liệu trong bảng DuAn và PhanCong.
create login projectmanager with password ='1234'
use QuanLyNhanVien
create user projectmanager for login projectmanager
go

grant select,insert,update,delete on DuAn to projectmanager
grant select,insert,update,delete on PhanCong to projectmanager
go

--8 Tạo vai trò departmentManagerRole có quyền đọc (SELECT) và cập nhật (UPDATE) dữ liệu
--trong bảng PhongBan. Gán vai trò này cho người dùng deptManager.
create login deptmanager with password ='1234'
use QuanLyNhanVien
create user deptmanager for login deptmanager
go

use QuanLyNhanVien
create role departmentmanagerole
go

grant select, update on phongban to departmentmanagerole
go

alter role departmentmanagerole add member deptmanager
go

--9 Kiểm tra quyền truy cập của người dùng readOnlyUser để đảm bảo họ chỉ có quyền đọc dữ
--liệu từ các bảng trong cơ sở dữ liệu.
use QuanLyNhanVien
exec as user ='readuser'
go

select * from NHANVIEN
select * from CHUCVU
select * from PHONGBAN
select * from LUONG
go

revert;
go

--10 Thu hồi tất cả các quyền từ vai trò dataEntryRole và đảm bảo rằng các thành viên của vai trò
--này không còn quyền truy cập dữ liệu.

revoke insert on nhanvien to dataentryrole
revoke insert on phancong to dataentryrole
go