select *
from NhanVien
insert into ChiTietHoaDon
values('2020-10-10', '2020-10-10', null, null)

select *
from DatPhong
select *
from ChiTietHoaDon
SELECT * FROM KhachHang INNER JOIN LoaiThanhVien ON KhachHang.maKH = LoaiThanhVien.maKH
select *
from DichVu
SELECT *
FROM DatPhong INNER JOIN KhachHang ON DatPhong.maKhDatPhong = KhachHang.maKH INNER JOIN Phong ON DatPhong.maPhong = Phong.maPhong
where Phong.maPhong ='p1'
select *  FROM KhachHang INNER JOIN LoaiThanhVien ON KhachHang.maKH = LoaiThanhVien.maKH where LoaiThanhVien.maKH = ''
UPDATE Phong SET ttPhong = 'HOAT_DONG' WHERE maPhong = 'p1'
select *
from Phong
SELECT *
FROM ChiTietDichVu INNER JOIN ChiTietHoaDon ON ChiTietDichVu.maHD = ChiTietHoaDon.maHD INNER JOIN DichVu ON ChiTietDichVu.maDichVu = DichVu.maDichVu INNER JOIN HoaDon ON ChiTietDichVu.maHD = HoaDon.maHD AND ChiTietHoaDon.maHD = HoaDon.maHD INNER JOIN KhachHang ON HoaDon.maKH = KhachHang.maKH INNER JOIN Phong ON ChiTietHoaDon.maPhong = Phong.maPhong
select *
 from LoaiThanhVien
select *
 from KhachHang where maKH = '6789'
SELECT DatPhong.*, Phong.*
FROM DatPhong INNER JOIN
	Phong ON DatPhong.maPhong = Phong.maPhong
order by maDP

SELECT *
FROM DatPhong INNER JOIN KhachHang ON DatPhong.maKhDatPhong = KhachHang.maKH INNER JOIN Phong ON DatPhong.maPhong = Phong.maPhong
go



SELECT ChiTietHoaDon.*, Phong.*, HoaDon.*
FROM ChiTietHoaDon INNER JOIN
	HoaDon ON ChiTietHoaDon.maHD = HoaDon.maHD INNER JOIN
	Phong ON ChiTietHoaDon.maPhong = Phong.maPhong

select *
from NhanVien
select *
from catruc
select *
from ChiTietCaTruc
SELECT *
FROM NhanVien
WHERE emailDangNhap = 'long@gmail.com'
delete from LoaiThanhVien
insert into ChiTietCaTruc
values('long', '2020-10-10', '9h-11h', 'nv2', 'ca2')
SELECT *
FROM NhanVien
WHERE emailDangNhap = 'thuan@gmail.com'
go
SELECT *
FROM DatPhong INNER JOIN
	KhachHang ON DatPhong.maKhDatPhong = KhachHang.maKH INNER JOIN
	NhanVien ON DatPhong.maNhanVien = NhanVien.maNV INNER JOIN
	Phong ON DatPhong.maPhong = Phong.maPhong
select *
from DichVu
select * from view_hoaDon where maHD = '13T105NV02736835'
select * from view_hoaDonVangLai
select * from view_thanhToan
select * from view_hoaDonChiTiet
select *
from phong where  ttPhong ='HOAT_DONG'
select * from view_ChiTietDV where thoiGianSuDung  =0

select *
from HoaDon where maHD  ='15T105NV02864796'
select *
from ChiTietDichVu
select *
from ChiTietHoaDon where maHD = '08T509NV02864125'

SELECT *
FROM KhachHang INNER JOIN
	LoaiThanhVien ON KhachHang.maKH = LoaiThanhVien.maKH
SELECT *
FROM DatPhong INNER JOIN
	Phong ON DatPhong.maPhong = Phong.maPhong


delete from HoaDon
delete from ChiTietDichVu
delete from ChiTietHoaDon
SELECT ma = HoaDon.maHD FROM ChiTietHoaDon INNER JOIN HoaDon ON ChiTietHoaDon.maHD = HoaDon.maHD where ngayLapHD = '2022-12-07' and HoaDon.maNhanVien = 'NV02736' and maPhong = 'T215'
select *
from DichVu
select *
from ChiTietDichVu
delete from HoaDon  where MONTH(ngayLapHD) = 12 and DAY(ngayLapHD) = 10
update phong set ttPhong = 'TRONG' where  ttPhong ='HOAT_DONG'
update phong set ttPhong = 'TRONG' where  ttPhong ='DAT_TRUOC'
select *
from HoaDon where MONTH(ngayLapHD) = 12 and DAY(ngayLapHD) = 16 and YEAR(ngayLapHD) = 2022
SELECT * FROM ChiTietHoaDon INNER JOIN HoaDon ON ChiTietHoaDon.maHD = HoaDon.maHD 
where MONTH(ngayLapHD) = 12 and DAY(ngayLapHD) = 08 and YEAR(ngayLapHD) = 2022 and HoaDon.maNhanVien = 'NV02864' and maPhong = 'T186'
select * from HoaDon where maHD ='8T186NV02736712 '
SELECT * FROM DatPhong INNER JOIN KhachHang ON DatPhong.maKhDatPhong = KhachHang.maKH 
					   INNER JOIN NhanVien ON DatPhong.maNhanVien = NhanVien.maNV 
					   INNER JOIN Phong ON DatPhong.maPhong = Phong.maPhong 
					   INNER JOIN LoaiThanhVien ON LoaiThanhVien.maKH = KhachHang.maKH
where loaiPhong = 'VIP'
delete DatPhong where maNhanVien = 'NV02864'
select * from view_hoaDonChiTiet where maHD  ='10T105NV02864341'
select *
from DatPhong
update Phong set soLanDatTruoc = 0 where ttPhong = 'TRONG'
select *
from Phong 
select *
from DatPhong
select *
from NhanVien
update NhanVien set viTriCongViec = N'Quản lý' where maNV = 'NV02864'
select *
from TaiKhoan
where email ='bichtuyenNV@gmail.com' and matKhau ='tuyendepgai'
select *
from ChiTietCaTruc
select *
from CaTruc
delete from KhachHang where  maKH ='6221'
select *
from KhachHang 
select *
from LoaiThanhVien where maKH ='6221'
delete from NhanVien where maNV = 'nv2'

UPDATE LoaiThanhVien SET uuDai = 1 FROM KhachHang INNER JOIN LoaiThanhVien ON KhachHang.maLoaiTV = LoaiThanhVien.maLoaiTV where KhachHang.maKH = '0789'

delete from CaTruc
--insert into TaiKhoan values('thuan@gmail.com', '123456', 1)
--insert into NhanVien values('nv2', 'nhan vien 2', '0123456789', '10-10-2020', 0, '10-10-2020', 'nhan vien', 'hanoi', 'nv2',
--		'thuan@gmail.com')

SELECT * FROM DatPhong INNER JOIN 
			KhachHang ON DatPhong.maKhDatPhong = KhachHang.maKH INNER JOIN 
			NhanVien ON DatPhong.maNhanVien = NhanVien.maNV INNER JOIN 
			Phong ON DatPhong.maPhong = Phong.maPhong INNER JOIN
			LoaiThanhVien ON LoaiThanhVien.maKH = KhachHang.maKH

SELECT * FROM     HoaDon INNER JOIN ChiTietHoaDon ON HoaDon.maHD = ChiTietHoaDon.maHD INNER JOIN
                           ChiTietDichVu ON HoaDon.maHD = ChiTietDichVu.maHD INNER JOIN
                           DichVu ON ChiTietDichVu.maDichVu = DichVu.maDichVu INNER JOIN
                           Phong ON ChiTietHoaDon.maPhong = Phong.maPhong INNER JOIN
                           KhachHang ON HoaDon.maKH = KhachHang.maKH INNER JOIN
                           NhanVien ON HoaDon.maNhanVien = NhanVien.maNV
						   where HoaDon.maHD = '13T105NV02736835'
select * from view_ChiTietDV where maHD = '13T105NV02736835'