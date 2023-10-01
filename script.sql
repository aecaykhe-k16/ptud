use master
go

if exists(select *
from sysdatabases
where name ='Karaoke')
drop database Karaoke
go
create database Karaoke

GO
USE [Karaoke]

go

CREATE TABLE CaTruc
(
	maCaTruc NCHAR(11) NOT NULL CONSTRAINT PK_CT PRIMARY KEY,
	[thoiGianCaTruc] [nchar](20) NOT NULL,
)

go

CREATE TABLE DichVu
(
	maDichVu NCHAR(5) NOT NULL CONSTRAINT PK_DV PRIMARY KEY,
	tenDichVu NCHAR(20) NOT NULL,
	giaDichVu FLOAT NOT NULL,
	[slTon] [int] NOT NULL,
	[hinhAnh] [nvarchar](255) NOT NULL,
)

CREATE TABLE Phong
(
	maPhong NCHAR(4) NOT NULL CONSTRAINT PK_P PRIMARY KEY,
	[tenPhong] [nchar](20) NOT NULL,
	[giaPhong] [float] NOT NULL,
	[sucChua] [int] NOT NULL,
	[chieuRong] [float] NOT NULL,
	[chieuDai] [float] NOT NULL,
	[tivi] [nchar](255) NOT NULL,
	[ban] [nchar](255) NOT NULL,
	[tenSofa] [nchar](255) NOT NULL,
	[slSofa] [int] NOT NULL,
	[slLoa] [int] NOT NULL,
	[loaiPhong] [nchar](20) NOT NULL,
	[ttPhong] [nchar](20) NOT NULL,
	[soLanDatTruoc] [int] NULL,
)

go

CREATE TABLE KhachHang
(
	maKH NCHAR(4) NOT NULL CONSTRAINT PK_KH PRIMARY KEY,
	[tenKH] [nvarchar](20) NULL,
	[sdt] [nchar](10) NOT NULL,
	[gioiTinh] [bit] NULL,
	[diaChi] [nvarchar](255) NULL,
	[trangThai] [bit] NULL
)
go
CREATE TABLE LoaiThanhVien
(
	maLoaiTV NCHAR(8) NOT NULL CONSTRAINT PK_LTV PRIMARY KEY,
	[tenLoaiTV] [nchar](20) NULL,
	[uuDai] int NULL,
	[ngayDangKy] [datetime] NULL,
	[ngayHetHan] [datetime] NULL,
	[soDinhDanh] [nchar](12) NULL,
	maKH NCHAR(4) NULL
		UNIQUE FOREIGN KEY (maKH) REFERENCES dbo.KhachHang(maKH) ON DELETE CASCADE ON UPDATE CASCADE
)
go
CREATE TABLE TaiKhoan
(
	email NCHAR(50) NOT NULL CONSTRAINT PK_TK PRIMARY KEY,
	[matKhau] [nchar](15) NOT NULL,
	[trangThai] [bit] NOT NULL,
)
go

select * from nhanvien
CREATE TABLE NhanVien
(
	[maNV] NCHAR(7) NOT NULL CONSTRAINT PK_NV PRIMARY KEY,
	[tenNV] [nvarchar](20) NOT NULL,
	[sdt] [nchar](10) NOT NULL,
	[ngaySinh] [datetime] NOT NULL,
	[gioiTinh] [bit] NOT NULL,
	[ngayTuyenDung] [datetime] NOT NULL,
	[viTriCongViec] [nvarchar](20) NOT NULL,
	[diaChi] [nvarchar](255) NOT NULL,
	[quanLyNV] [nchar](7) NULL,
	[trangThai] [bit] NOT NULL,
	FOREIGN KEY (quanLyNV) REFERENCES dbo.NhanVien(maNV) ON DELETE NO ACTION ON UPDATE NO ACTION,
	emailDangNhap NCHAR(50) NOT NULL
		UNIQUE FOREIGN KEY (emailDangNhap) REFERENCES dbo.TaiKhoan(email) ON DELETE CASCADE ON UPDATE CASCADE
)

GO

CREATE TABLE DatPhong
(
	maDP NCHAR(5) NOT NULL CONSTRAINT PK_DP PRIMARY KEY,
	[ngayDatPhong] [datetime] NOT NULL,
	[gioNhanPhong] [datetime] NOT NULL,
	[maNhanVien] [nchar](7) NOT NULL,
	FOREIGN KEY (maNhanVien) REFERENCES dbo.NhanVien(maNV) ON DELETE CASCADE ON UPDATE CASCADE,
	[maKhDatPhong] [nchar](4) NOT NULL,
	FOREIGN KEY (maKhDatPhong) REFERENCES dbo.KhachHang(maKH),
	[maPhong] [nchar](4) NOT NULL,
	FOREIGN KEY (maPhong) REFERENCES dbo.Phong(maPhong) ON DELETE CASCADE ON UPDATE CASCADE
)
go

CREATE TABLE HoaDon
(
	maHD NCHAR(16) NOT NULL CONSTRAINT PK_HD PRIMARY KEY,
	[ngayLapHD] [datetime] NOT NULL,
	[maNhanVien] [nchar](7) NOT NULL,
	FOREIGN KEY (maNhanVien) REFERENCES dbo.NhanVien(maNV) ON DELETE CASCADE ON UPDATE CASCADE,
	[maKH] [nchar](4) NULL,
	FOREIGN KEY (maKH) REFERENCES dbo.KhachHang(maKH),
)
GO

CREATE TABLE ChiTietHoaDon
(
	[thoiGianSuDung] [int] NOT NULL,
	[maHD] [nchar](16) NOT NULL,
	[maPhong] [nchar](4) NOT NULL,
	PRIMARY KEY (maHD, maPhong),
	FOREIGN KEY (maHD) REFERENCES dbo.HoaDon(maHD) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (maPhong) REFERENCES dbo.Phong(maPhong) ON DELETE CASCADE ON UPDATE CASCADE,
)
GO
CREATE TABLE ChiTietDichVu
(
	[soLuong] [int] NOT NULL,
	[maHD] [nchar](16) NOT NULL,
	[maDichVu] [nchar](5) NOT NULL,
	PRIMARY KEY (maHD, maDichVu),
	FOREIGN KEY (maHD) REFERENCES dbo.HoaDon(maHD) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (maDichVu) REFERENCES dbo.DichVu(maDichVu) ON DELETE CASCADE ON UPDATE CASCADE,
)
GO
CREATE TABLE ChiTietCaTruc
(
	[trangThaiCaTruc] [nchar](10) NOT NULL,
	[ngayPhanCa] [datetime] NOT NULL,
	[maNV] [nchar](7) NOT NULL,
	[maCaTruc] [nchar](11) NOT NULL,
	PRIMARY KEY (maNV, maCaTruc),
	FOREIGN KEY (maNV) REFERENCES dbo.NhanVien(maNV) ON DELETE CASCADE ON UPDATE CASCADE,
	FOREIGN KEY (maCaTruc) REFERENCES dbo.CaTruc(maCaTruc) ON DELETE CASCADE ON UPDATE CASCADE,
)


GO
drop view [dbo].[view_hoaDonChiTiet]
drop view [dbo].[view_hoaDonVangLai]
drop view [dbo].[view_thanhToan]

drop view [dbo].[view_ChiTietDV]
drop trigger tangSLDatTruoc
drop trigger giamSLDatTruoc
GO

create view [dbo].[view_ChiTietDV]
as
	SELECT dbo.HoaDon.maHD, dbo.HoaDon.ngayLapHD, dbo.Phong.tenPhong, dbo.Phong.giaPhong, dbo.ChiTietHoaDon.thoiGianSuDung,
		dbo.DichVu.tenDichVu, dbo.DichVu.giaDichVu, dbo.ChiTietDichVu.soLuong,
		dbo.Phong.maPhong, dbo.DichVu.maDichVu
	FROM ChiTietDichVu INNER JOIN
		ChiTietHoaDon ON ChiTietDichVu.maHD = ChiTietHoaDon.maHD INNER JOIN
		DichVu ON ChiTietDichVu.maDichVu = DichVu.maDichVu INNER JOIN
		HoaDon ON ChiTietDichVu.maHD = HoaDon.maHD AND ChiTietHoaDon.maHD = HoaDon.maHD INNER JOIN
		Phong ON ChiTietHoaDon.maPhong = Phong.maPhong

GO
create view [dbo].[view_thanhToan]
as
	SELECT Phong.maPhong, Phong.tenPhong, Phong.giaPhong, KhachHang.tenKH, KhachHang.sdt, NhanVien.tenNV, LoaiThanhVien.maLoaiTV, HoaDon.maHD, HoaDon.ngayLapHD, Phong.ttPhong
	FROM ChiTietHoaDon INNER JOIN
		HoaDon ON ChiTietHoaDon.maHD = HoaDon.maHD INNER JOIN
		KhachHang ON HoaDon.maKH = KhachHang.maKH INNER JOIN
		LoaiThanhVien ON KhachHang.maKH = LoaiThanhVien.maKH INNER JOIN
		NhanVien ON HoaDon.maNhanVien = NhanVien.maNV INNER JOIN
		Phong ON ChiTietHoaDon.maPhong = Phong.maPhong
	WHERE	Phong.ttPhong = 'HOAT_DONG'
GO
create view [dbo].[view_hoaDonChiTiet]
as
	SELECT dbo.HoaDon.maHD, dbo.HoaDon.ngayLapHD, dbo.Phong.tenPhong, dbo.Phong.giaPhong, dbo.ChiTietHoaDon.thoiGianSuDung, dbo.DichVu.tenDichVu, dbo.DichVu.giaDichVu, dbo.ChiTietDichVu.soLuong,
		dbo.KhachHang.tenKH, dbo.NhanVien.tenNV, dbo.Phong.maPhong, dbo.KhachHang .maKH
	FROM dbo.ChiTietDichVu INNER JOIN
		dbo.ChiTietHoaDon ON dbo.ChiTietDichVu.maHD = dbo.ChiTietHoaDon.maHD INNER JOIN
		dbo.DichVu ON dbo.ChiTietDichVu.maDichVu = dbo.DichVu.maDichVu INNER JOIN
		dbo.HoaDon ON dbo.ChiTietDichVu.maHD = dbo.HoaDon.maHD AND dbo.ChiTietHoaDon.maHD = dbo.HoaDon.maHD INNER JOIN
		dbo.Phong ON dbo.ChiTietHoaDon.maPhong = dbo.Phong.maPhong INNER JOIN
		dbo.KhachHang ON dbo.HoaDon.maKH = dbo.KhachHang.maKH INNER JOIN
		dbo.NhanVien ON dbo.HoaDon.maNhanVien = dbo.NhanVien.maNV
GO


create view view_hoaDonVangLai
as
	SELECT dbo.HoaDon.maHD, dbo.HoaDon.ngayLapHD, dbo.Phong.tenPhong, dbo.Phong.giaPhong, dbo.ChiTietHoaDon.thoiGianSuDung,
		dbo.DichVu.tenDichVu, dbo.DichVu.giaDichVu, dbo.ChiTietDichVu.soLuong, maChiTiet = dbo.ChiTietDichVu.maHD, dbo.NhanVien.tenNV
	FROM dbo.ChiTietDichVu INNER JOIN
		dbo.ChiTietHoaDon ON dbo.ChiTietDichVu.maHD = dbo.ChiTietHoaDon.maHD INNER JOIN
		dbo.DichVu ON dbo.ChiTietDichVu.maDichVu = dbo.DichVu.maDichVu INNER JOIN
		dbo.HoaDon ON dbo.ChiTietDichVu.maHD = dbo.HoaDon.maHD AND dbo.ChiTietHoaDon.maHD = dbo.HoaDon.maHD INNER JOIN
		dbo.Phong ON dbo.ChiTietHoaDon.maPhong = dbo.Phong.maPhong INNER JOIN
		dbo.NhanVien ON dbo.HoaDon.maNhanVien = dbo.NhanVien.maNV

go
CREATE TRIGGER tangSLDatTruoc ON DatPhong AFTER INSERT AS
BEGIN
	UPDATE Phong
	SET soLanDatTruoc = soLanDatTruoc + 1
	FROM Phong
		JOIN inserted ON Phong.maPhong = inserted.maPhong
END

go

CREATE TRIGGER giamSLDatTruoc ON DatPhong FOR DELETE AS
BEGIN
	UPDATE Phong
	SET soLanDatTruoc = soLanDatTruoc - 1
	FROM Phong
		JOIN deleted ON Phong.maPhong = deleted.maPhong
END
GO
INSERT [dbo].[CaTruc] ([maCaTruc], [thoiGianCaTruc]) VALUES (N'14122241   ', N'7h-11h              ')
GO
INSERT [dbo].[CaTruc] ([maCaTruc], [thoiGianCaTruc]) VALUES (N'16122261   ', N'7h-11h              ')
GO
INSERT [dbo].[CaTruc] ([maCaTruc], [thoiGianCaTruc]) VALUES (N'16122262   ', N'12h-17h             ')
GO
INSERT [dbo].[CaTruc] ([maCaTruc], [thoiGianCaTruc]) VALUES (N'17122272   ', N'12h-17h             ')
GO
INSERT [dbo].[TaiKhoan] ([email], [matKhau], [trangThai]) VALUES (N'babacNV@gmail.com                                 ', N'123456         ', 1)
GO
INSERT [dbo].[TaiKhoan] ([email], [matKhau], [trangThai]) VALUES (N'baotrucNV@gmail.com                               ', N'123456         ', 1)
GO
INSERT [dbo].[TaiKhoan] ([email], [matKhau], [trangThai]) VALUES (N'bichtuyenNV@gmail.com                             ', N'123456         ', 1)
GO
INSERT [dbo].[TaiKhoan] ([email], [matKhau], [trangThai]) VALUES (N'binhtrietNV@gmail.com                             ', N'123456         ', 1)
GO
INSERT [dbo].[TaiKhoan] ([email], [matKhau], [trangThai]) VALUES (N'binhtrongNV@gmail.com                             ', N'123456         ', 1)
GO
INSERT [dbo].[TaiKhoan] ([email], [matKhau], [trangThai]) VALUES (N'congminhNV@gmail.com                              ', N'123456         ', 1)
GO
INSERT [dbo].[TaiKhoan] ([email], [matKhau], [trangThai]) VALUES (N'cuongNV@gmail.com                                 ', N'123456         ', 1)
GO
INSERT [dbo].[TaiKhoan] ([email], [matKhau], [trangThai]) VALUES (N'dinhchungNV@gmail.com                             ', N'123456         ', 1)
GO
INSERT [dbo].[TaiKhoan] ([email], [matKhau], [trangThai]) VALUES (N'dinhlongNV@gmail.com                              ', N'123456         ', 1)
GO
INSERT [dbo].[TaiKhoan] ([email], [matKhau], [trangThai]) VALUES (N'ducchienNV@gmail.com                              ', N'123456         ', 1)
GO
INSERT [dbo].[TaiKhoan] ([email], [matKhau], [trangThai]) VALUES (N'ductaiNV@gmail.com                                ', N'123456         ', 1)
GO
INSERT [dbo].[TaiKhoan] ([email], [matKhau], [trangThai]) VALUES (N'duytuanNV@gmail.com                               ', N'123456         ', 1)
GO
INSERT [dbo].[TaiKhoan] ([email], [matKhau], [trangThai]) VALUES (N'giadaiNV@gmail.com                                ', N'123456         ', 1)
GO
INSERT [dbo].[TaiKhoan] ([email], [matKhau], [trangThai]) VALUES (N'giahyNV@gmail.com                                 ', N'123456         ', 1)
GO
INSERT [dbo].[TaiKhoan] ([email], [matKhau], [trangThai]) VALUES (N'hanamNV@gmail.com                                 ', N'123456         ', 1)
GO
INSERT [dbo].[TaiKhoan] ([email], [matKhau], [trangThai]) VALUES (N'hieudongNV@gmail.com                              ', N'123456         ', 1)
GO
INSERT [dbo].[TaiKhoan] ([email], [matKhau], [trangThai]) VALUES (N'hoaianNV@gmail.com                                ', N'123456         ', 1)
GO
INSERT [dbo].[TaiKhoan] ([email], [matKhau], [trangThai]) VALUES (N'hoanganhNV@gmail.com                              ', N'123456         ', 1)
GO
INSERT [dbo].[TaiKhoan] ([email], [matKhau], [trangThai]) VALUES (N'hoangthaiNV@gmail.com                             ', N'123456         ', 1)
GO
INSERT [dbo].[TaiKhoan] ([email], [matKhau], [trangThai]) VALUES (N'hodiepNV@gmail.com                                ', N'123456         ', 1)
GO
INSERT [dbo].[TaiKhoan] ([email], [matKhau], [trangThai]) VALUES (N'huubangNV@gmail.com                               ', N'123456         ', 1)
GO
INSERT [dbo].[TaiKhoan] ([email], [matKhau], [trangThai]) VALUES (N'huuhiepNV@gmail.com                               ', N'123456         ', 1)
GO
INSERT [dbo].[TaiKhoan] ([email], [matKhau], [trangThai]) VALUES (N'huuphuocNV@gmail.com                              ', N'123456         ', 1)
GO
INSERT [dbo].[TaiKhoan] ([email], [matKhau], [trangThai]) VALUES (N'huynhhuongNV@gmail.com                            ', N'123456         ', 1)
GO
INSERT [dbo].[TaiKhoan] ([email], [matKhau], [trangThai]) VALUES (N'khachinhNV@gmail.com                              ', N'123456         ', 1)
GO
INSERT [dbo].[TaiKhoan] ([email], [matKhau], [trangThai]) VALUES (N'kimnganNV@gmail.com                               ', N'123456         ', 1)
GO
INSERT [dbo].[TaiKhoan] ([email], [matKhau], [trangThai]) VALUES (N'lanhuongNV@gmail.com                              ', N'123456         ', 1)
GO
INSERT [dbo].[TaiKhoan] ([email], [matKhau], [trangThai]) VALUES (N'lantuongNV@gmail.com                              ', N'123456         ', 1)
GO
INSERT [dbo].[TaiKhoan] ([email], [matKhau], [trangThai]) VALUES (N'manhtriNV@gmail.com                               ', N'123456         ', 1)
GO
INSERT [dbo].[TaiKhoan] ([email], [matKhau], [trangThai]) VALUES (N'minhanNV@gmail.com                                ', N'123456         ', 1)
GO
INSERT [dbo].[TaiKhoan] ([email], [matKhau], [trangThai]) VALUES (N'minhduyNV@gmail.com                               ', N'123456         ', 1)
GO
INSERT [dbo].[TaiKhoan] ([email], [matKhau], [trangThai]) VALUES (N'minhhuyenNV@gmail.com                             ', N'123456         ', 1)
GO
INSERT [dbo].[TaiKhoan] ([email], [matKhau], [trangThai]) VALUES (N'minhluanNV@gmail.com                              ', N'123456         ', 1)
GO
INSERT [dbo].[TaiKhoan] ([email], [matKhau], [trangThai]) VALUES (N'minhthuanNV@gmail.com                             ', N'123456         ', 1)
GO
INSERT [dbo].[TaiKhoan] ([email], [matKhau], [trangThai]) VALUES (N'minhtienNV@gmail.com                              ', N'123456         ', 1)
GO
INSERT [dbo].[TaiKhoan] ([email], [matKhau], [trangThai]) VALUES (N'minhtriNV@gmail.com                               ', N'123456         ', 1)
GO
INSERT [dbo].[TaiKhoan] ([email], [matKhau], [trangThai]) VALUES (N'mychauNV@gmail.com                                ', N'123456         ', 1)
GO
INSERT [dbo].[TaiKhoan] ([email], [matKhau], [trangThai]) VALUES (N'ngocmaiNV@gmail.com                               ', N'123456         ', 1)
GO
INSERT [dbo].[TaiKhoan] ([email], [matKhau], [trangThai]) VALUES (N'ngocvuNV@gmail.com                                ', N'123456         ', 1)
GO
INSERT [dbo].[TaiKhoan] ([email], [matKhau], [trangThai]) VALUES (N'nguyensinhNV@gmail.com                            ', N'123456         ', 1)
GO
INSERT [dbo].[TaiKhoan] ([email], [matKhau], [trangThai]) VALUES (N'nhatkhanhNV@gmail.com                             ', N'123456         ', 1)
GO
INSERT [dbo].[TaiKhoan] ([email], [matKhau], [trangThai]) VALUES (N'nhatlinhNV@gmail.com                              ', N'123456         ', 1)
GO
INSERT [dbo].[TaiKhoan] ([email], [matKhau], [trangThai]) VALUES (N'nhatthaiNV@gmail.com                              ', N'123456         ', 1)
GO
INSERT [dbo].[TaiKhoan] ([email], [matKhau], [trangThai]) VALUES (N'phiminhNV@gmail.com                               ', N'123456         ', 1)
GO
INSERT [dbo].[TaiKhoan] ([email], [matKhau], [trangThai]) VALUES (N'quanghopNV@gmail.com                              ', N'123456         ', 1)
GO
INSERT [dbo].[TaiKhoan] ([email], [matKhau], [trangThai]) VALUES (N'quangphongNV@gmail.com                            ', N'123456         ', 1)
GO
INSERT [dbo].[TaiKhoan] ([email], [matKhau], [trangThai]) VALUES (N'quochaoNV@gmail.com                               ', N'123456         ', 1)
GO
INSERT [dbo].[TaiKhoan] ([email], [matKhau], [trangThai]) VALUES (N'quochuyNV@gmail.com                               ', N'123456         ', 1)
GO
INSERT [dbo].[TaiKhoan] ([email], [matKhau], [trangThai]) VALUES (N'quoctuanNV@gmail.com                              ', N'123456         ', 1)
GO
INSERT [dbo].[TaiKhoan] ([email], [matKhau], [trangThai]) VALUES (N'quyencoNV@gmail.com                               ', N'123456         ', 1)
GO
INSERT [dbo].[TaiKhoan] ([email], [matKhau], [trangThai]) VALUES (N'tandatNV@gmail.com                                ', N'123456         ', 1)
GO
INSERT [dbo].[TaiKhoan] ([email], [matKhau], [trangThai]) VALUES (N'tandungNV@gmail.com                               ', N'123456         ', 1)
GO
INSERT [dbo].[TaiKhoan] ([email], [matKhau], [trangThai]) VALUES (N'thaiduongNV@gmail.com                             ', N'123456         ', 1)
GO
INSERT [dbo].[TaiKhoan] ([email], [matKhau], [trangThai]) VALUES (N'thanhdaiNV@gmail.com                              ', N'123456         ', 1)
GO
INSERT [dbo].[TaiKhoan] ([email], [matKhau], [trangThai]) VALUES (N'thanhdoanhNV@gmail.com                            ', N'123456         ', 1)
GO
INSERT [dbo].[TaiKhoan] ([email], [matKhau], [trangThai]) VALUES (N'thanhhaiNV@gmail.com                              ', N'123456         ', 1)
GO
INSERT [dbo].[TaiKhoan] ([email], [matKhau], [trangThai]) VALUES (N'thanhsonNV@gmail.com                              ', N'123456         ', 1)
GO
INSERT [dbo].[TaiKhoan] ([email], [matKhau], [trangThai]) VALUES (N'thanhtamNV@gmail.com                              ', N'123456         ', 1)
GO
INSERT [dbo].[TaiKhoan] ([email], [matKhau], [trangThai]) VALUES (N'thanhthangNV@gmail.com                            ', N'123456         ', 1)
GO
INSERT [dbo].[TaiKhoan] ([email], [matKhau], [trangThai]) VALUES (N'thanhtoanNV@gmail.com                             ', N'123456         ', 1)
GO
INSERT [dbo].[TaiKhoan] ([email], [matKhau], [trangThai]) VALUES (N'thanhtungNV@gmail.com                             ', N'123456         ', 1)
GO
INSERT [dbo].[TaiKhoan] ([email], [matKhau], [trangThai]) VALUES (N'thekietNV@gmail.com                               ', N'123456         ', 1)
GO
INSERT [dbo].[TaiKhoan] ([email], [matKhau], [trangThai]) VALUES (N'thevinhNV@gmail.com                               ', N'123456         ', 1)
GO
INSERT [dbo].[TaiKhoan] ([email], [matKhau], [trangThai]) VALUES (N'thiendatNV@gmail.com                              ', N'123456         ', 1)
GO
INSERT [dbo].[TaiKhoan] ([email], [matKhau], [trangThai]) VALUES (N'thiennghiaNV@gmail.com                            ', N'123456         ', 1)
GO
INSERT [dbo].[TaiKhoan] ([email], [matKhau], [trangThai]) VALUES (N'thuan@gmail.com                                   ', N'123456         ', 1)
GO
INSERT [dbo].[TaiKhoan] ([email], [matKhau], [trangThai]) VALUES (N'thuytinhNV@gmail.com                              ', N'123456         ', 1)
GO
INSERT [dbo].[TaiKhoan] ([email], [matKhau], [trangThai]) VALUES (N'trieuphuNV@gmail.com                              ', N'123456         ', 1)
GO
INSERT [dbo].[TaiKhoan] ([email], [matKhau], [trangThai]) VALUES (N'trithucNV@gmail.com                               ', N'123456         ', 1)
GO
INSERT [dbo].[TaiKhoan] ([email], [matKhau], [trangThai]) VALUES (N'trunghieuNV@gmail.com                             ', N'123456         ', 1)
GO
INSERT [dbo].[TaiKhoan] ([email], [matKhau], [trangThai]) VALUES (N'tuankietNV@gmail.com                              ', N'123456         ', 1)
GO
INSERT [dbo].[TaiKhoan] ([email], [matKhau], [trangThai]) VALUES (N'vandatNV@gmail.com                                ', N'123456         ', 1)
GO
INSERT [dbo].[TaiKhoan] ([email], [matKhau], [trangThai]) VALUES (N'vanhieuNV@gmail.com                               ', N'123456         ', 1)
GO
INSERT [dbo].[TaiKhoan] ([email], [matKhau], [trangThai]) VALUES (N'vanhoangNV@gmail.com                              ', N'123456         ', 1)
GO
INSERT [dbo].[TaiKhoan] ([email], [matKhau], [trangThai]) VALUES (N'vanhungNV@gmail.com                               ', N'123456         ', 1)
GO
INSERT [dbo].[TaiKhoan] ([email], [matKhau], [trangThai]) VALUES (N'vanlocNV@gmail.com                                ', N'123456         ', 1)
GO
INSERT [dbo].[TaiKhoan] ([email], [matKhau], [trangThai]) VALUES (N'vanthuanNV@gmail.com                              ', N'123456         ', 1)
GO
INSERT [dbo].[TaiKhoan] ([email], [matKhau], [trangThai]) VALUES (N'vanvietNV@gmail.com                               ', N'123456         ', 1)
GO
INSERT [dbo].[TaiKhoan] ([email], [matKhau], [trangThai]) VALUES (N'xuancanhNV@gmail.com                              ', N'123456         ', 1)
GO
INSERT [dbo].[TaiKhoan] ([email], [matKhau], [trangThai]) VALUES (N'xuanlongNV@gmail.com                              ', N'123456         ', 1)
GO
INSERT [dbo].[TaiKhoan] ([email], [matKhau], [trangThai]) VALUES (N'yennhiNV@gmail.com                                ', N'123456         ', 1)
GO
INSERT [dbo].[NhanVien] ([maNV], [tenNV], [sdt], [ngaySinh], [gioiTinh], [ngayTuyenDung], [viTriCongViec], [diaChi], [quanLyNV], [trangThai], [emailDangNhap]) VALUES (N'NV02105', N'Lê Hữu Hiệp', N'0939244869', CAST(N'2002-10-16T00:00:00.000' AS DateTime), 1, CAST(N'2018-02-03T00:00:00.000' AS DateTime), N'Nhân viên', N'Xã An Lạc Tây, Huyện Kế Sách, Tỉnh Sóc Trăng', NULL, 1, N'huuhiepNV@gmail.com                               ')
GO
INSERT [dbo].[NhanVien] ([maNV], [tenNV], [sdt], [ngaySinh], [gioiTinh], [ngayTuyenDung], [viTriCongViec], [diaChi], [quanLyNV], [trangThai], [emailDangNhap]) VALUES (N'NV02118', N'Trần Văn Hùng', N'0396209345', CAST(N'2002-12-28T00:00:00.000' AS DateTime), 1, CAST(N'2018-11-20T00:00:00.000' AS DateTime), N'Nhân viên', N'Xã Nghĩa Lạc, Huyện Nghĩa Hưng, Tỉnh Nam Định', NULL, 1, N'vanhungNV@gmail.com                               ')
GO
INSERT [dbo].[NhanVien] ([maNV], [tenNV], [sdt], [ngaySinh], [gioiTinh], [ngayTuyenDung], [viTriCongViec], [diaChi], [quanLyNV], [trangThai], [emailDangNhap]) VALUES (N'NV02119', N'Huỳnh Triệu Phú', N'0948743637', CAST(N'2002-05-13T00:00:00.000' AS DateTime), 1, CAST(N'2017-01-01T00:00:00.000' AS DateTime), N'Nhân viên', N'Xã Bình Thành, Huyện Đức Huệ, Tỉnh Long An', NULL, 1, N'trieuphuNV@gmail.com                              ')
GO
INSERT [dbo].[NhanVien] ([maNV], [tenNV], [sdt], [ngaySinh], [gioiTinh], [ngayTuyenDung], [viTriCongViec], [diaChi], [quanLyNV], [trangThai], [emailDangNhap]) VALUES (N'NV02121', N'Lê Thị Kim Ngân', N'0375950082', CAST(N'2002-02-15T00:00:00.000' AS DateTime), 1, CAST(N'2018-01-01T00:00:00.000' AS DateTime), N'Nhân viên', N'Xã Bình Đức, Huyện Bến Lức, Tỉnh Long An', NULL, 1, N'kimnganNV@gmail.com                               ')
GO
INSERT [dbo].[NhanVien] ([maNV], [tenNV], [sdt], [ngaySinh], [gioiTinh], [ngayTuyenDung], [viTriCongViec], [diaChi], [quanLyNV], [trangThai], [emailDangNhap]) VALUES (N'NV02140', N'Nguyễn Thanh Sơn', N'0387866829', CAST(N'2002-05-11T00:00:00.000' AS DateTime), 0, CAST(N'2017-10-24T00:00:00.000' AS DateTime), N'Nhân viên', N'Phường Xuân Phú, Thị xã Sông Cầu, Tỉnh Phú Yên', NULL, 1, N'thanhsonNV@gmail.com                              ')
GO
INSERT [dbo].[NhanVien] ([maNV], [tenNV], [sdt], [ngaySinh], [gioiTinh], [ngayTuyenDung], [viTriCongViec], [diaChi], [quanLyNV], [trangThai], [emailDangNhap]) VALUES (N'NV02155', N'Văn Quang Phong', N'0397932681', CAST(N'2002-02-11T00:00:00.000' AS DateTime), 1, CAST(N'2017-04-27T00:00:00.000' AS DateTime), N'Nhân viên', N'Phường Hòa Lợi, Thị xã Bến Cát, Tỉnh Bình Dương', NULL, 1, N'quangphongNV@gmail.com                            ')
GO
INSERT [dbo].[NhanVien] ([maNV], [tenNV], [sdt], [ngaySinh], [gioiTinh], [ngayTuyenDung], [viTriCongViec], [diaChi], [quanLyNV], [trangThai], [emailDangNhap]) VALUES (N'NV02156', N'Trần Thanh Đại', N'0862808775', CAST(N'2002-12-09T00:00:00.000' AS DateTime), 1, CAST(N'2022-07-26T00:00:00.000' AS DateTime), N'Nhân viên', N'Phường Lam Sơn, Thành phố Hưng Yên, Tỉnh Hưng Yên', NULL, 1, N'thanhdaiNV@gmail.com                              ')
GO
INSERT [dbo].[NhanVien] ([maNV], [tenNV], [sdt], [ngaySinh], [gioiTinh], [ngayTuyenDung], [viTriCongViec], [diaChi], [quanLyNV], [trangThai], [emailDangNhap]) VALUES (N'NV02157', N'Võ Tấn Đạt', N'0329672303', CAST(N'2002-05-02T00:00:00.000' AS DateTime), 1, CAST(N'2016-08-16T00:00:00.000' AS DateTime), N'Nhân viên', N'Xã Tiên Thọ, Huyện Tiên Phước, Tỉnh Quảng Nam', NULL, 1, N'tandatNV@gmail.com                                ')
GO
INSERT [dbo].[NhanVien] ([maNV], [tenNV], [sdt], [ngaySinh], [gioiTinh], [ngayTuyenDung], [viTriCongViec], [diaChi], [quanLyNV], [trangThai], [emailDangNhap]) VALUES (N'NV02182', N'Nguyễn Gia Hy', N'0396765290', CAST(N'2002-05-11T00:00:00.000' AS DateTime), 1, CAST(N'2018-03-20T00:00:00.000' AS DateTime), N'Nhân viên', N'Xã Phước Thạnh, Huyện Củ Chi, Thành phố Hồ Chí Minh', NULL, 1, N'giahyNV@gmail.com                                 ')
GO
INSERT [dbo].[NhanVien] ([maNV], [tenNV], [sdt], [ngaySinh], [gioiTinh], [ngayTuyenDung], [viTriCongViec], [diaChi], [quanLyNV], [trangThai], [emailDangNhap]) VALUES (N'NV02186', N'Nguyễn Thành Doanh', N'0348968518', CAST(N'2002-10-19T00:00:00.000' AS DateTime), 1, CAST(N'2018-03-26T00:00:00.000' AS DateTime), N'Nhân viên', N'Xã Khánh Nhạc, Huyện Yên Khánh, Tỉnh Ninh Bình', NULL, 1, N'thanhdoanhNV@gmail.com                            ')
GO
INSERT [dbo].[NhanVien] ([maNV], [tenNV], [sdt], [ngaySinh], [gioiTinh], [ngayTuyenDung], [viTriCongViec], [diaChi], [quanLyNV], [trangThai], [emailDangNhap]) VALUES (N'NV02198', N'Lý Phi Minh', N'0396664136', CAST(N'2002-06-04T00:00:00.000' AS DateTime), 1, CAST(N'2017-09-02T00:00:00.000' AS DateTime), N'Nhân viên', N'Xã Trung Lập Thượng, Huyện Củ Chi, Thành phố Hồ Chí Minh', NULL, 1, N'phiminhNV@gmail.com                               ')
GO
INSERT [dbo].[NhanVien] ([maNV], [tenNV], [sdt], [ngaySinh], [gioiTinh], [ngayTuyenDung], [viTriCongViec], [diaChi], [quanLyNV], [trangThai], [emailDangNhap]) VALUES (N'NV02202', N'Lê Võ Duy Tấn', N'0398439700', CAST(N'2002-01-24T00:00:00.000' AS DateTime), 1, CAST(N'2017-03-26T00:00:00.000' AS DateTime), N'Nhân viên', N'Xã Bình Thạnh, Huyện Tuy Phong, Tỉnh Bình Thuận', NULL, 1, N'duytuanNV@gmail.com                               ')
GO
INSERT [dbo].[NhanVien] ([maNV], [tenNV], [sdt], [ngaySinh], [gioiTinh], [ngayTuyenDung], [viTriCongViec], [diaChi], [quanLyNV], [trangThai], [emailDangNhap]) VALUES (N'NV02228', N'Nguyễn Thanh Tâm', N'0966002637', CAST(N'2002-10-10T00:00:00.000' AS DateTime), 1, CAST(N'2017-03-26T00:00:00.000' AS DateTime), N'Nhân viên', N'Xã Long Hưng B, Huyện Lấp Vò, Tỉnh Đồng Tháp', NULL, 1, N'thanhtamNV@gmail.com                              ')
GO
INSERT [dbo].[NhanVien] ([maNV], [tenNV], [sdt], [ngaySinh], [gioiTinh], [ngayTuyenDung], [viTriCongViec], [diaChi], [quanLyNV], [trangThai], [emailDangNhap]) VALUES (N'NV02255', N'Phạm Nhật Linh', N'0906702589', CAST(N'2002-01-20T00:00:00.000' AS DateTime), 1, CAST(N'2022-06-20T00:00:00.000' AS DateTime), N'Nhân viên', N'Xã Quảng Văn, Thị xã Ba Đồn, Tỉnh Quảng Bình', NULL, 1, N'nhatlinhNV@gmail.com                              ')
GO
INSERT [dbo].[NhanVien] ([maNV], [tenNV], [sdt], [ngaySinh], [gioiTinh], [ngayTuyenDung], [viTriCongViec], [diaChi], [quanLyNV], [trangThai], [emailDangNhap]) VALUES (N'NV02256', N'Mai Thanh Thắng', N'0869084958', CAST(N'2002-08-28T00:00:00.000' AS DateTime), 1, CAST(N'2017-12-22T00:00:00.000' AS DateTime), N'Nhân viên', N'Xã Phước Thắng, Huyện Tuy Phước, Tỉnh Bình Định', NULL, 1, N'thanhthangNV@gmail.com                            ')
GO
INSERT [dbo].[NhanVien] ([maNV], [tenNV], [sdt], [ngaySinh], [gioiTinh], [ngayTuyenDung], [viTriCongViec], [diaChi], [quanLyNV], [trangThai], [emailDangNhap]) VALUES (N'NV02273', N'Lê Nguyên Sinh', N'0398890029', CAST(N'2002-02-19T00:00:00.000' AS DateTime), 1, CAST(N'2019-07-22T00:00:00.000' AS DateTime), N'Nhân viên', N'Xã Khánh Vân, Huyện Yên Khánh,Tỉnh  Ninh Bình', NULL, 1, N'nguyensinhNV@gmail.com                            ')
GO
INSERT [dbo].[NhanVien] ([maNV], [tenNV], [sdt], [ngaySinh], [gioiTinh], [ngayTuyenDung], [viTriCongViec], [diaChi], [quanLyNV], [trangThai], [emailDangNhap]) VALUES (N'NV02277', N'Võ Quốc Huy', N'0332509042', CAST(N'2002-12-14T00:00:00.000' AS DateTime), 1, CAST(N'2022-03-26T00:00:00.000' AS DateTime), N'Nhân viên', N'Xã Nghĩa Trung, Huyện Tư Nghĩa, Tỉnh Quảng Ngãi', NULL, 1, N'quochuyNV@gmail.com                               ')
GO
INSERT [dbo].[NhanVien] ([maNV], [tenNV], [sdt], [ngaySinh], [gioiTinh], [ngayTuyenDung], [viTriCongViec], [diaChi], [quanLyNV], [trangThai], [emailDangNhap]) VALUES (N'NV02279', N'Trần Minh Trí', N'0965162057', CAST(N'2002-05-21T00:00:00.000' AS DateTime), 1, CAST(N'2017-05-08T00:00:00.000' AS DateTime), N'Nhân viên', N'Xã Long Thới, Huyện Nhà Bè, Thành phố Hồ Chí Minh', NULL, 1, N'minhtriNV@gmail.com                               ')
GO
INSERT [dbo].[NhanVien] ([maNV], [tenNV], [sdt], [ngaySinh], [gioiTinh], [ngayTuyenDung], [viTriCongViec], [diaChi], [quanLyNV], [trangThai], [emailDangNhap]) VALUES (N'NV02283', N'Nguyễn Mạnh Trí', N'0945349387', CAST(N'2002-07-21T00:00:00.000' AS DateTime), 1, CAST(N'1970-01-01T00:00:00.000' AS DateTime), N'Nhân viên', N'Xã Thuận Sơn, Huyện Đô Lương, Tỉnh Nghệ An', NULL, 1, N'manhtriNV@gmail.com                               ')
GO
INSERT [dbo].[NhanVien] ([maNV], [tenNV], [sdt], [ngaySinh], [gioiTinh], [ngayTuyenDung], [viTriCongViec], [diaChi], [quanLyNV], [trangThai], [emailDangNhap]) VALUES (N'NV02286', N'Lê Hữu Bằng', N'0837699806', CAST(N'2002-05-30T00:00:00.000' AS DateTime), 1, CAST(N'2018-01-01T00:00:00.000' AS DateTime), N'Nhân viên', N'Xã Mỹ Phước Tây, Thị xã Cai Lậy, Tỉnh Tiền Giang', NULL, 1, N'huubangNV@gmail.com                               ')
GO
INSERT [dbo].[NhanVien] ([maNV], [tenNV], [sdt], [ngaySinh], [gioiTinh], [ngayTuyenDung], [viTriCongViec], [diaChi], [quanLyNV], [trangThai], [emailDangNhap]) VALUES (N'NV02299', N'Ngô Ngọc Vũ', N'0337344134', CAST(N'2002-03-19T00:00:00.000' AS DateTime), 1, CAST(N'2017-03-26T00:00:00.000' AS DateTime), N'Nhân viên', N'Xã Tân Lý Đông, Huyện Châu Thành, Tỉnh Tiền Giang', NULL, 1, N'ngocvuNV@gmail.com                                ')
GO
INSERT [dbo].[NhanVien] ([maNV], [tenNV], [sdt], [ngaySinh], [gioiTinh], [ngayTuyenDung], [viTriCongViec], [diaChi], [quanLyNV], [trangThai], [emailDangNhap]) VALUES (N'NV02305', N'Vũ Thế Kiệt', N'0974034565', CAST(N'2002-09-04T00:00:00.000' AS DateTime), 1, CAST(N'2020-04-20T00:00:00.000' AS DateTime), N'Nhân viên', N'Xã Định Hưng, Huyện Yên Định, Tỉnh Thanh Hóa', NULL, 1, N'thekietNV@gmail.com                               ')
GO
INSERT [dbo].[NhanVien] ([maNV], [tenNV], [sdt], [ngaySinh], [gioiTinh], [ngayTuyenDung], [viTriCongViec], [diaChi], [quanLyNV], [trangThai], [emailDangNhap]) VALUES (N'NV02344', N'Nguyễn Huỳnh Hương', N'0856947926', CAST(N'2002-12-01T00:00:00.000' AS DateTime), 0, CAST(N'2018-01-01T00:00:00.000' AS DateTime), N'Nhân viên', N'Xã Bình Thạnh, Huyện Cao Lãnh, Tỉnh Đồng Tháp', NULL, 1, N'huynhhuongNV@gmail.com                            ')
GO
INSERT [dbo].[NhanVien] ([maNV], [tenNV], [sdt], [ngaySinh], [gioiTinh], [ngayTuyenDung], [viTriCongViec], [diaChi], [quanLyNV], [trangThai], [emailDangNhap]) VALUES (N'NV02357', N'Lê Thanh Tùng', N'0379179754', CAST(N'2001-05-03T00:00:00.000' AS DateTime), 1, CAST(N'2019-03-26T00:00:00.000' AS DateTime), N'Nhân viên', N'Xã Đại Lộc, Huyện Đại Lộc, Tỉnh Quảng Nam', NULL, 1, N'thanhtungNV@gmail.com                             ')
GO
INSERT [dbo].[NhanVien] ([maNV], [tenNV], [sdt], [ngaySinh], [gioiTinh], [ngayTuyenDung], [viTriCongViec], [diaChi], [quanLyNV], [trangThai], [emailDangNhap]) VALUES (N'NV02366', N'Nguyễn Văn Việt', N'0345641602', CAST(N'2002-08-12T00:00:00.000' AS DateTime), 1, CAST(N'2017-03-26T00:00:00.000' AS DateTime), N'Nhân viên', N'Phường Tân Thuận Đông, Quận 7, Thành phố Hồ Chí Minh', NULL, 1, N'vanvietNV@gmail.com                               ')
GO
INSERT [dbo].[NhanVien] ([maNV], [tenNV], [sdt], [ngaySinh], [gioiTinh], [ngayTuyenDung], [viTriCongViec], [diaChi], [quanLyNV], [trangThai], [emailDangNhap]) VALUES (N'NV02368', N'Trần Bình Trọng', N'0366581227', CAST(N'2002-06-19T00:00:00.000' AS DateTime), 1, CAST(N'2018-03-26T00:00:00.000' AS DateTime), N'Nhân viên', N'Xã Phong Mỹ, Huyện Cao Lãnh, Tỉnh Đồng Tháp', NULL, 1, N'binhtrongNV@gmail.com                             ')
GO
INSERT [dbo].[NhanVien] ([maNV], [tenNV], [sdt], [ngaySinh], [gioiTinh], [ngayTuyenDung], [viTriCongViec], [diaChi], [quanLyNV], [trangThai], [emailDangNhap]) VALUES (N'NV02378', N'Trần Thị Yến Nhi', N'0343375618', CAST(N'2002-04-13T00:00:00.000' AS DateTime), 0, CAST(N'2018-01-09T00:00:00.000' AS DateTime), N'Nhân viên', N'Xã Tam An, Huyện Long Thành, Tỉnh Đồng Nai', NULL, 1, N'yennhiNV@gmail.com                                ')
GO
INSERT [dbo].[NhanVien] ([maNV], [tenNV], [sdt], [ngaySinh], [gioiTinh], [ngayTuyenDung], [viTriCongViec], [diaChi], [quanLyNV], [trangThai], [emailDangNhap]) VALUES (N'NV02470', N'Lê Thanh Toàn', N'0366637192', CAST(N'2002-04-08T00:00:00.000' AS DateTime), 1, CAST(N'2017-01-01T00:00:00.000' AS DateTime), N'Nhân viên', N'Phường Xuân Phú, Thị xã Sông Cầu, Tỉnh Phú Yên', NULL, 1, N'thanhtoanNV@gmail.com                             ')
GO
INSERT [dbo].[NhanVien] ([maNV], [tenNV], [sdt], [ngaySinh], [gioiTinh], [ngayTuyenDung], [viTriCongViec], [diaChi], [quanLyNV], [trangThai], [emailDangNhap]) VALUES (N'NV02477', N'Nguyễn Lê Mỹ Châu', N'0972097103', CAST(N'2002-01-12T00:00:00.000' AS DateTime), 0, CAST(N'2017-09-29T00:00:00.000' AS DateTime), N'Nhân viên', N'Phường 14, Quận 11, Thành phố Hồ Chí Minh', NULL, 1, N'mychauNV@gmail.com                                ')
GO
INSERT [dbo].[NhanVien] ([maNV], [tenNV], [sdt], [ngaySinh], [gioiTinh], [ngayTuyenDung], [viTriCongViec], [diaChi], [quanLyNV], [trangThai], [emailDangNhap]) VALUES (N'NV02478', N'Tô Hiếu Đông', N'0859505384', CAST(N'2002-11-02T00:00:00.000' AS DateTime), 1, CAST(N'2017-03-26T00:00:00.000' AS DateTime), N'Nhân viên', N'Xã Tân Tập, Huyện Cần Giuộc, Tỉnh Long An', NULL, 1, N'hieudongNV@gmail.com                              ')
GO
INSERT [dbo].[NhanVien] ([maNV], [tenNV], [sdt], [ngaySinh], [gioiTinh], [ngayTuyenDung], [viTriCongViec], [diaChi], [quanLyNV], [trangThai], [emailDangNhap]) VALUES (N'NV02490', N'Trần Thị Minh Huyền', N'0384601453', CAST(N'2002-11-11T00:00:00.000' AS DateTime), 0, CAST(N'2017-12-22T00:00:00.000' AS DateTime), N'Nhân viên', N'Xã Trung Nam, Huyện Vĩnh Linh, Tỉnh Quảng Trị', NULL, 1, N'minhhuyenNV@gmail.com                             ')
GO
INSERT [dbo].[NhanVien] ([maNV], [tenNV], [sdt], [ngaySinh], [gioiTinh], [ngayTuyenDung], [viTriCongViec], [diaChi], [quanLyNV], [trangThai], [emailDangNhap]) VALUES (N'NV02499', N'Dương Tuấn Kiệt', N'0368125719', CAST(N'2002-03-27T00:00:00.000' AS DateTime), 1, CAST(N'2017-04-30T00:00:00.000' AS DateTime), N'Nhân viên', N'Xã Ngũ Phụng, Huyện Phú Quí, Tỉnh Bình Thuận', NULL, 1, N'tuankietNV@gmail.com                              ')
GO
INSERT [dbo].[NhanVien] ([maNV], [tenNV], [sdt], [ngaySinh], [gioiTinh], [ngayTuyenDung], [viTriCongViec], [diaChi], [quanLyNV], [trangThai], [emailDangNhap]) VALUES (N'NV02514', N'Nguyễn Xuân Long', N'0366231860', CAST(N'2002-10-23T00:00:00.000' AS DateTime), 1, CAST(N'2018-12-21T00:00:00.000' AS DateTime), N'Nhân viên', N'Xã Cẩm Lĩnh, Huyện Cẩm Xuyên, Tỉnh Hà Tĩnh', NULL, 1, N'xuanlongNV@gmail.com                              ')
GO
INSERT [dbo].[NhanVien] ([maNV], [tenNV], [sdt], [ngaySinh], [gioiTinh], [ngayTuyenDung], [viTriCongViec], [diaChi], [quanLyNV], [trangThai], [emailDangNhap]) VALUES (N'NV02525', N'Vũ Lan Tường', N'0794336524', CAST(N'2002-05-18T00:00:00.000' AS DateTime), 0, CAST(N'2016-03-26T00:00:00.000' AS DateTime), N'Nhân viên', N'Xã Vọng Đông, Huyện Thoại Sơn, Tỉnh An Giang', NULL, 1, N'lantuongNV@gmail.com                              ')
GO
INSERT [dbo].[NhanVien] ([maNV], [tenNV], [sdt], [ngaySinh], [gioiTinh], [ngayTuyenDung], [viTriCongViec], [diaChi], [quanLyNV], [trangThai], [emailDangNhap]) VALUES (N'NV02563', N'Huỳnh Quốc Hào', N'0355112561', CAST(N'2002-01-02T00:00:00.000' AS DateTime), 0, CAST(N'2017-03-20T00:00:00.000' AS DateTime), N'Nhân viên', N'Xã Mỹ Hương, Huyện Mỹ Tú, Tỉnh Sóc Trăng', NULL, 1, N'quochaoNV@gmail.com                               ')
GO
INSERT [dbo].[NhanVien] ([maNV], [tenNV], [sdt], [ngaySinh], [gioiTinh], [ngayTuyenDung], [viTriCongViec], [diaChi], [quanLyNV], [trangThai], [emailDangNhap]) VALUES (N'NV02569', N'Phạm Bá Bắc', N'0989937030', CAST(N'2002-07-05T00:00:00.000' AS DateTime), 0, CAST(N'2017-03-26T00:00:00.000' AS DateTime), N'Nhân viên', N'Xã Trù Sơn, Huyện Đô Lương, Tỉnh Nghệ An', NULL, 1, N'babacNV@gmail.com                                 ')
GO
INSERT [dbo].[NhanVien] ([maNV], [tenNV], [sdt], [ngaySinh], [gioiTinh], [ngayTuyenDung], [viTriCongViec], [diaChi], [quanLyNV], [trangThai], [emailDangNhap]) VALUES (N'NV02583', N'Nguyễn Minh Luận', N'0387703131', CAST(N'2002-05-26T00:00:00.000' AS DateTime), 1, CAST(N'2018-03-26T00:00:00.000' AS DateTime), N'Nhân viên', N'Xã Vĩnh Hòa, Thị xã Tân Châu, Tỉnh An Giang', NULL, 1, N'minhluanNV@gmail.com                              ')
GO
INSERT [dbo].[NhanVien] ([maNV], [tenNV], [sdt], [ngaySinh], [gioiTinh], [ngayTuyenDung], [viTriCongViec], [diaChi], [quanLyNV], [trangThai], [emailDangNhap]) VALUES (N'NV02610', N'Võ Đình Chung', N'0379595404', CAST(N'2002-02-21T00:00:00.000' AS DateTime), 1, CAST(N'2017-03-26T00:00:00.000' AS DateTime), N'Nhân viên', N'Xã Diễn Cát, Huyện Diễn Châu, Tỉnh Nghệ An', NULL, 1, N'dinhchungNV@gmail.com                             ')
GO
INSERT [dbo].[NhanVien] ([maNV], [tenNV], [sdt], [ngaySinh], [gioiTinh], [ngayTuyenDung], [viTriCongViec], [diaChi], [quanLyNV], [trangThai], [emailDangNhap]) VALUES (N'NV02619', N'Nguyễn Văn Hiếu', N'0975654628', CAST(N'2000-12-10T00:00:00.000' AS DateTime), 1, CAST(N'2016-03-26T00:00:00.000' AS DateTime), N'Nhân viên', N'Xã Đô Thành, Huyện Yên Thành, Tỉnh Nghệ An', NULL, 1, N'vanhieuNV@gmail.com                               ')
GO
INSERT [dbo].[NhanVien] ([maNV], [tenNV], [sdt], [ngaySinh], [gioiTinh], [ngayTuyenDung], [viTriCongViec], [diaChi], [quanLyNV], [trangThai], [emailDangNhap]) VALUES (N'NV02620', N'Nguyễn Đức Chiến', N'0395309735', CAST(N'2002-11-30T00:00:00.000' AS DateTime), 1, CAST(N'2019-07-27T00:00:00.000' AS DateTime), N'Nhân viên', N'Xã Minh Nghĩa, Huyện Nông Cống, Tỉnh Thanh Hóa', NULL, 1, N'ducchienNV@gmail.com                              ')
GO
INSERT [dbo].[NhanVien] ([maNV], [tenNV], [sdt], [ngaySinh], [gioiTinh], [ngayTuyenDung], [viTriCongViec], [diaChi], [quanLyNV], [trangThai], [emailDangNhap]) VALUES (N'NV02649', N' Phạm Khả Chỉnh', N'0767578845', CAST(N'2002-12-22T00:00:00.000' AS DateTime), 1, CAST(N'2019-07-27T00:00:00.000' AS DateTime), N'Nhân viên', N'Xã Nhơn Phúc, Thị xã An Nhơn, Tỉnh Bình Định', NULL, 1, N'khachinhNV@gmail.com                              ')
GO
INSERT [dbo].[NhanVien] ([maNV], [tenNV], [sdt], [ngaySinh], [gioiTinh], [ngayTuyenDung], [viTriCongViec], [diaChi], [quanLyNV], [trangThai], [emailDangNhap]) VALUES (N'NV02653', N'Võ Thị Minh Tiến', N'0344112540', CAST(N'2002-02-02T00:00:00.000' AS DateTime), 0, CAST(N'1970-07-20T00:00:00.000' AS DateTime), N'Nhân viên', N'Xã Tam Xuân I, Huyện Núi Thành, Quảng Nam', NULL, 1, N'minhtienNV@gmail.com                              ')
GO
INSERT [dbo].[NhanVien] ([maNV], [tenNV], [sdt], [ngaySinh], [gioiTinh], [ngayTuyenDung], [viTriCongViec], [diaChi], [quanLyNV], [trangThai], [emailDangNhap]) VALUES (N'NV02657', N'Đỗ Quốc Tuấn', N'0338995837', CAST(N'2002-10-21T00:00:00.000' AS DateTime), 1, CAST(N'2019-04-30T00:00:00.000' AS DateTime), N'Nhân viên', N'Xã Sơn Công, Huyện Ứng Hòa, Thành phố Hà Nội', NULL, 1, N'quoctuanNV@gmail.com                              ')
GO
INSERT [dbo].[NhanVien] ([maNV], [tenNV], [sdt], [ngaySinh], [gioiTinh], [ngayTuyenDung], [viTriCongViec], [diaChi], [quanLyNV], [trangThai], [emailDangNhap]) VALUES (N'NV02659', N'Phạm Quang Hợp', N'0395331942', CAST(N'2002-03-24T00:00:00.000' AS DateTime), 1, CAST(N'2017-03-24T00:00:00.000' AS DateTime), N'Nhân viên', N'Thị trấn Đức Thọ, Huyện Đức Thọ, Tỉnh Hà Tĩnh', NULL, 1, N'quanghopNV@gmail.com                              ')
GO
INSERT [dbo].[NhanVien] ([maNV], [tenNV], [sdt], [ngaySinh], [gioiTinh], [ngayTuyenDung], [viTriCongViec], [diaChi], [quanLyNV], [trangThai], [emailDangNhap]) VALUES (N'NV02672', N'Trường Bình Triết', N'0399889692', CAST(N'2002-02-11T00:00:00.000' AS DateTime), 1, CAST(N'2020-07-12T00:00:00.000' AS DateTime), N'Nhân viên', N'Xã Phú An, Huyện Phú Tân, Tỉnh An Giang', NULL, 1, N'binhtrietNV@gmail.com                             ')
GO
INSERT [dbo].[NhanVien] ([maNV], [tenNV], [sdt], [ngaySinh], [gioiTinh], [ngayTuyenDung], [viTriCongViec], [diaChi], [quanLyNV], [trangThai], [emailDangNhap]) VALUES (N'NV02673', N'Nguyễn Văn Lộc', N'0338710667', CAST(N'2002-08-31T00:00:00.000' AS DateTime), 1, CAST(N'2017-03-26T00:00:00.000' AS DateTime), N'Nhân viên', N'Phường Hùng Vương, Quận Hồng Bàng, Thành phố Hải Phòng', NULL, 1, N'vanlocNV@gmail.com                                ')
GO
INSERT [dbo].[NhanVien] ([maNV], [tenNV], [sdt], [ngaySinh], [gioiTinh], [ngayTuyenDung], [viTriCongViec], [diaChi], [quanLyNV], [trangThai], [emailDangNhap]) VALUES (N'NV02678', N'Trần Công Minh', N'0961263780', CAST(N'2002-07-10T00:00:00.000' AS DateTime), 1, CAST(N'2018-07-22T00:00:00.000' AS DateTime), N'Nhân viên', N'Xã Hợp Tiến, Huyện Mỹ Đức, Thành phố Hà Nội', NULL, 1, N'congminhNV@gmail.com                              ')
GO
INSERT [dbo].[NhanVien] ([maNV], [tenNV], [sdt], [ngaySinh], [gioiTinh], [ngayTuyenDung], [viTriCongViec], [diaChi], [quanLyNV], [trangThai], [emailDangNhap]) VALUES (N'NV02680', N'Phạm Hà Nam', N'0333660652', CAST(N'2002-10-05T00:00:00.000' AS DateTime), 1, CAST(N'2018-03-26T00:00:00.000' AS DateTime), N'Nhân viên', N'Xã Đông Động, Huyện Đông Hưng, Tỉnh Thái Bình', NULL, 1, N'hanamNV@gmail.com                                 ')
GO
INSERT [dbo].[NhanVien] ([maNV], [tenNV], [sdt], [ngaySinh], [gioiTinh], [ngayTuyenDung], [viTriCongViec], [diaChi], [quanLyNV], [trangThai], [emailDangNhap]) VALUES (N'NV02691', N'Võ Ngọc Minh Anh', N'0774770288', CAST(N'2002-07-20T00:00:00.000' AS DateTime), 0, CAST(N'2020-03-26T00:00:00.000' AS DateTime), N'Nhân viên', N'Phường 5, Thành phố Tân An, Tỉnh Long An', NULL, 1, N'minhanNV@gmail.com                                ')
GO
INSERT [dbo].[NhanVien] ([maNV], [tenNV], [sdt], [ngaySinh], [gioiTinh], [ngayTuyenDung], [viTriCongViec], [diaChi], [quanLyNV], [trangThai], [emailDangNhap]) VALUES (N'NV02695', N'Đặng Duy Hồ Điệp', N'0344037974', CAST(N'2002-01-25T00:00:00.000' AS DateTime), 1, CAST(N'2017-03-26T00:00:00.000' AS DateTime), N'Nhân viên', N'Xã Tây Sơn, Huyện Tây Sơn, Tỉnh Bình Định', NULL, 1, N'hodiepNV@gmail.com                                ')
GO
INSERT [dbo].[NhanVien] ([maNV], [tenNV], [sdt], [ngaySinh], [gioiTinh], [ngayTuyenDung], [viTriCongViec], [diaChi], [quanLyNV], [trangThai], [emailDangNhap]) VALUES (N'NV02714', N'Phạm Xuân Cảnh', N'0934060177', CAST(N'2002-11-29T00:00:00.000' AS DateTime), 1, CAST(N'2017-03-20T00:00:00.000' AS DateTime), N'Nhân viên', N'Xã Phước Hiệp, Huyện Tuy Phước, Tỉnh Bình Định', NULL, 1, N'xuancanhNV@gmail.com                              ')
GO
INSERT [dbo].[NhanVien] ([maNV], [tenNV], [sdt], [ngaySinh], [gioiTinh], [ngayTuyenDung], [viTriCongViec], [diaChi], [quanLyNV], [trangThai], [emailDangNhap]) VALUES (N'NV02724', N'Vũ Thái Dương', N'0337052369', CAST(N'2002-03-23T00:00:00.000' AS DateTime), 1, CAST(N'2017-10-02T00:00:00.000' AS DateTime), N'Nhân viên', N'Xã Hồng Phong, Huyện Thanh Miện, Tỉnh Hải Dương', NULL, 1, N'thaiduongNV@gmail.com                             ')
GO
INSERT [dbo].[NhanVien] ([maNV], [tenNV], [sdt], [ngaySinh], [gioiTinh], [ngayTuyenDung], [viTriCongViec], [diaChi], [quanLyNV], [trangThai], [emailDangNhap]) VALUES (N'NV02736', N'Trần Bảo Trúc', N'0338030540', CAST(N'2002-05-06T00:00:00.000' AS DateTime), 0, CAST(N'2018-03-26T00:00:00.000' AS DateTime), N'Nhân viên', N'Xã Phước Bình, Thị xã Trảng Bàng, Tỉnh Tây Ninh', NULL, 1, N'baotrucNV@gmail.com                               ')
GO
INSERT [dbo].[NhanVien] ([maNV], [tenNV], [sdt], [ngaySinh], [gioiTinh], [ngayTuyenDung], [viTriCongViec], [diaChi], [quanLyNV], [trangThai], [emailDangNhap]) VALUES (N'NV02748', N'Nguyễn Nhật Khanh', N'0916420671', CAST(N'2002-02-24T00:00:00.000' AS DateTime), 1, CAST(N'2017-03-26T00:00:00.000' AS DateTime), N'Nhân viên', N'Thị trấn Đức Thọ, Huyện Đức Thọ, Tỉnh Hà Tĩnh', NULL, 1, N'nhatkhanhNV@gmail.com                             ')
GO
INSERT [dbo].[NhanVien] ([maNV], [tenNV], [sdt], [ngaySinh], [gioiTinh], [ngayTuyenDung], [viTriCongViec], [diaChi], [quanLyNV], [trangThai], [emailDangNhap]) VALUES (N'NV02763', N'Bùi Gia Đại', N'0382890389', CAST(N'2002-06-30T00:00:00.000' AS DateTime), 1, CAST(N'2018-01-08T00:00:00.000' AS DateTime), N'Nhân viên', N'Xã Yên Phương, Huyện Ý Yên, Nam Định', NULL, 1, N'giadaiNV@gmail.com                                ')
GO
INSERT [dbo].[NhanVien] ([maNV], [tenNV], [sdt], [ngaySinh], [gioiTinh], [ngayTuyenDung], [viTriCongViec], [diaChi], [quanLyNV], [trangThai], [emailDangNhap]) VALUES (N'NV02774', N'Bùi Trí Thức', N'0963015348', CAST(N'2002-06-15T00:00:00.000' AS DateTime), 1, CAST(N'2018-03-26T00:00:00.000' AS DateTime), N'Nhân viên', N'Xã Tân Đức, Huyện Đầm Dơi, Tỉnh Cà Mau', NULL, 1, N'trithucNV@gmail.com                               ')
GO
INSERT [dbo].[NhanVien] ([maNV], [tenNV], [sdt], [ngaySinh], [gioiTinh], [ngayTuyenDung], [viTriCongViec], [diaChi], [quanLyNV], [trangThai], [emailDangNhap]) VALUES (N'NV02791', N'Đặng Thị Quyền Cơ', N'0365227701', CAST(N'2002-01-31T00:00:00.000' AS DateTime), 0, CAST(N'2017-09-28T00:00:00.000' AS DateTime), N'Nhân viên', N'Xã Long Hựu Tây, Huyện Cần Đước,Tỉnh  Long An', NULL, 1, N'quyencoNV@gmail.com                               ')
GO
INSERT [dbo].[NhanVien] ([maNV], [tenNV], [sdt], [ngaySinh], [gioiTinh], [ngayTuyenDung], [viTriCongViec], [diaChi], [quanLyNV], [trangThai], [emailDangNhap]) VALUES (N'NV02808', N'Huỳnh Hữu Phước', N'0348307336', CAST(N'2002-03-26T00:00:00.000' AS DateTime), 1, CAST(N'2017-04-30T00:00:00.000' AS DateTime), N'Nhân viên', N'Xã Bình Phú, Huyện Cai Lậy, Tỉnh Tiền Giang', NULL, 1, N'huuphuocNV@gmail.com                              ')
GO
INSERT [dbo].[NhanVien] ([maNV], [tenNV], [sdt], [ngaySinh], [gioiTinh], [ngayTuyenDung], [viTriCongViec], [diaChi], [quanLyNV], [trangThai], [emailDangNhap]) VALUES (N'NV02812', N'Lê Thiện Nghĩa', N'0326711384', CAST(N'2002-06-27T00:00:00.000' AS DateTime), 1, CAST(N'2017-04-27T00:00:00.000' AS DateTime), N'Nhân viên', N'Xã Nhơn Ninh, Huyện Tân Thạnh, Tỉnh Long An', NULL, 1, N'thiennghiaNV@gmail.com                            ')
GO
INSERT [dbo].[NhanVien] ([maNV], [tenNV], [sdt], [ngaySinh], [gioiTinh], [ngayTuyenDung], [viTriCongViec], [diaChi], [quanLyNV], [trangThai], [emailDangNhap]) VALUES (N'NV02847', N'Nguyễn Thúy Tình', N'0988580844', CAST(N'2002-09-14T00:00:00.000' AS DateTime), 0, CAST(N'2018-03-15T00:00:00.000' AS DateTime), N'Nhân viên', N'Xã Hoài Mỹ, Thị xã Hoài Nhơn, Tỉnh Bình Định', NULL, 1, N'thuytinhNV@gmail.com                              ')
GO
INSERT [dbo].[NhanVien] ([maNV], [tenNV], [sdt], [ngaySinh], [gioiTinh], [ngayTuyenDung], [viTriCongViec], [diaChi], [quanLyNV], [trangThai], [emailDangNhap]) VALUES (N'NV02851', N'Phan Hoài An', N'0332530656', CAST(N'2002-06-09T00:00:00.000' AS DateTime), 1, CAST(N'2018-03-20T00:00:00.000' AS DateTime), N'Nhân viên', N'Xã Tân Lợi Thạnh, Huyện Giồng Trôm, Tỉnh Bến Tre', NULL, 1, N'hoaianNV@gmail.com                                ')
GO
INSERT [dbo].[NhanVien] ([maNV], [tenNV], [sdt], [ngaySinh], [gioiTinh], [ngayTuyenDung], [viTriCongViec], [diaChi], [quanLyNV], [trangThai], [emailDangNhap]) VALUES (N'NV02853', N'Nguyễn Tấn Dũng', N'0395663597', CAST(N'2002-06-09T00:00:00.000' AS DateTime), 1, CAST(N'2017-12-15T00:00:00.000' AS DateTime), N'Nhân viên', N'Xã Nghĩa Kỳ, Huyện Tư Nghĩa, Tỉnh Quảng Ngãi', NULL, 1, N'tandungNV@gmail.com                               ')
GO
INSERT [dbo].[NhanVien] ([maNV], [tenNV], [sdt], [ngaySinh], [gioiTinh], [ngayTuyenDung], [viTriCongViec], [diaChi], [quanLyNV], [trangThai], [emailDangNhap]) VALUES (N'NV02856', N'Lê Thị Ngọc Mai', N'0352594707', CAST(N'2002-02-15T00:00:00.000' AS DateTime), 0, CAST(N'2017-03-26T00:00:00.000' AS DateTime), N'Nhân viên', N'Xã Vĩnh Trường, Huyện An Phú, Tỉnh An Giang', NULL, 1, N'ngocmaiNV@gmail.com                               ')
GO
INSERT [dbo].[NhanVien] ([maNV], [tenNV], [sdt], [ngaySinh], [gioiTinh], [ngayTuyenDung], [viTriCongViec], [diaChi], [quanLyNV], [trangThai], [emailDangNhap]) VALUES (N'NV02864', N'Châu Bích Tuyền', N'0856659876', CAST(N'2002-10-26T00:00:00.000' AS DateTime), 0, CAST(N'2018-03-26T00:00:00.000' AS DateTime), N'Quản lý', N'Phường Tân Thành, Thành phố Cà Mau, Tỉnh Cà Mau', N'NV02864', 1, N'bichtuyenNV@gmail.com                             ')
GO
INSERT [dbo].[NhanVien] ([maNV], [tenNV], [sdt], [ngaySinh], [gioiTinh], [ngayTuyenDung], [viTriCongViec], [diaChi], [quanLyNV], [trangThai], [emailDangNhap]) VALUES (N'NV02874', N'Nguyễn Văn Hoàng', N'0944268988', CAST(N'2002-09-14T00:00:00.000' AS DateTime), 1, CAST(N'2017-10-15T00:00:00.000' AS DateTime), N'Nhân viên', N'Xã Hải An, Huyện Hải Hậu, Tỉnh Nam Định', NULL, 1, N'vanhoangNV@gmail.com                              ')
GO
INSERT [dbo].[NhanVien] ([maNV], [tenNV], [sdt], [ngaySinh], [gioiTinh], [ngayTuyenDung], [viTriCongViec], [diaChi], [quanLyNV], [trangThai], [emailDangNhap]) VALUES (N'NV02883', N'Nguyễn Văn Thuận', N'0797740900', CAST(N'2002-11-24T00:00:00.000' AS DateTime), 1, CAST(N'2018-03-26T00:00:00.000' AS DateTime), N'Nhân viên', N'Xã Tân Lân, Huyện Cần Đước, Tỉnh Long An', NULL, 1, N'vanthuanNV@gmail.com                              ')
GO
INSERT [dbo].[NhanVien] ([maNV], [tenNV], [sdt], [ngaySinh], [gioiTinh], [ngayTuyenDung], [viTriCongViec], [diaChi], [quanLyNV], [trangThai], [emailDangNhap]) VALUES (N'NV02884', N'Lê Thanh Hải', N'0368983043', CAST(N'2002-09-18T00:00:00.000' AS DateTime), 1, CAST(N'2016-07-20T00:00:00.000' AS DateTime), N'Nhân viên', N'Phường Bình Minh, Thị xã Nghi Sơn, Tỉnh Thanh Hóa', NULL, 1, N'thanhhaiNV@gmail.com                              ')
GO
INSERT [dbo].[NhanVien] ([maNV], [tenNV], [sdt], [ngaySinh], [gioiTinh], [ngayTuyenDung], [viTriCongViec], [diaChi], [quanLyNV], [trangThai], [emailDangNhap]) VALUES (N'NV02895', N'Lường Văn Đạt', N'0981993215', CAST(N'2002-09-08T00:00:00.000' AS DateTime), 1, CAST(N'2020-05-20T00:00:00.000' AS DateTime), N'Nhân viên', N'Xã Phú Lộc, Huyện Hậu Lộc, Tỉnh Thanh Hóa', NULL, 1, N'vandatNV@gmail.com                                ')
GO
INSERT [dbo].[NhanVien] ([maNV], [tenNV], [sdt], [ngaySinh], [gioiTinh], [ngayTuyenDung], [viTriCongViec], [diaChi], [quanLyNV], [trangThai], [emailDangNhap]) VALUES (N'NV02928', N'Phương Thị Lan Hương', N'0703935114', CAST(N'2002-07-15T00:00:00.000' AS DateTime), 0, CAST(N'2018-05-18T00:00:00.000' AS DateTime), N'Nhân viên', N'Quận Phú Nhuận, Thành phố Hồ Chí Minh', NULL, 1, N'lanhuongNV@gmail.com                              ')
GO
INSERT [dbo].[NhanVien] ([maNV], [tenNV], [sdt], [ngaySinh], [gioiTinh], [ngayTuyenDung], [viTriCongViec], [diaChi], [quanLyNV], [trangThai], [emailDangNhap]) VALUES (N'NV02929', N'Trần Minh Thuận', N'0364976472', CAST(N'2002-03-03T00:00:00.000' AS DateTime), 1, CAST(N'2018-03-24T00:00:00.000' AS DateTime), N'Nhân viên', N'Xã Thanh Phước, Huyện Gò Dầu, Tỉnh Tây Ninh', NULL, 1, N'minhthuanNV@gmail.com                             ')
GO
INSERT [dbo].[NhanVien] ([maNV], [tenNV], [sdt], [ngaySinh], [gioiTinh], [ngayTuyenDung], [viTriCongViec], [diaChi], [quanLyNV], [trangThai], [emailDangNhap]) VALUES (N'NV02937', N'Dương Đình Long', N'0372021772', CAST(N'2002-05-28T00:00:00.000' AS DateTime), 1, CAST(N'2018-12-12T00:00:00.000' AS DateTime), N'Nhân viên', N'Xã Tượng Sơn, Huyện Thạch Hà, Tỉnh Hà Tĩnh', NULL, 1, N'dinhlongNV@gmail.com                              ')
GO
INSERT [dbo].[NhanVien] ([maNV], [tenNV], [sdt], [ngaySinh], [gioiTinh], [ngayTuyenDung], [viTriCongViec], [diaChi], [quanLyNV], [trangThai], [emailDangNhap]) VALUES (N'NV02939', N'Trần Thiện Đạt', N'0879159759', CAST(N'2002-07-29T00:00:00.000' AS DateTime), 1, CAST(N'2017-11-29T00:00:00.000' AS DateTime), N'Nhân viên', N'Xã Tân Hải, Thị xã La Gi, Tỉnh Bình Thuận', NULL, 1, N'thiendatNV@gmail.com                              ')
GO
INSERT [dbo].[NhanVien] ([maNV], [tenNV], [sdt], [ngaySinh], [gioiTinh], [ngayTuyenDung], [viTriCongViec], [diaChi], [quanLyNV], [trangThai], [emailDangNhap]) VALUES (N'NV02960', N'Ngô Nhật Thái', N'0961306963', CAST(N'2002-08-25T00:00:00.000' AS DateTime), 1, CAST(N'2018-04-30T00:00:00.000' AS DateTime), N'Nhân viên', N'Xã Lương Phi, Huyện Tri Tôn, Tỉnh An Giang', NULL, 1, N'nhatthaiNV@gmail.com                              ')
GO
INSERT [dbo].[NhanVien] ([maNV], [tenNV], [sdt], [ngaySinh], [gioiTinh], [ngayTuyenDung], [viTriCongViec], [diaChi], [quanLyNV], [trangThai], [emailDangNhap]) VALUES (N'NV02968', N'Lê Thế Vinh', N'0827805396', CAST(N'2002-09-03T00:00:00.000' AS DateTime), 1, CAST(N'2018-03-26T00:00:00.000' AS DateTime), N'Nhân viên', N'Xã Tân Hưng, Huyện Cái Bè, Tỉnh Tiền Giang', NULL, 1, N'thevinhNV@gmail.com                               ')
GO
INSERT [dbo].[ChiTietCaTruc] ([trangThaiCaTruc], [ngayPhanCa], [maNV], [maCaTruc]) VALUES (N'true      ', CAST(N'2022-12-15T00:00:00.000' AS DateTime), N'NV02105', N'16122261   ')
GO
INSERT [dbo].[ChiTietCaTruc] ([trangThaiCaTruc], [ngayPhanCa], [maNV], [maCaTruc]) VALUES (N'true      ', CAST(N'2022-12-16T00:00:00.000' AS DateTime), N'NV02736', N'16122261   ')
GO
INSERT [dbo].[ChiTietCaTruc] ([trangThaiCaTruc], [ngayPhanCa], [maNV], [maCaTruc]) VALUES (N'true      ', CAST(N'2022-12-16T00:00:00.000' AS DateTime), N'NV02864', N'16122261   ')
GO
INSERT [dbo].[ChiTietCaTruc] ([trangThaiCaTruc], [ngayPhanCa], [maNV], [maCaTruc]) VALUES (N'true      ', CAST(N'2022-12-16T00:00:00.000' AS DateTime), N'NV02864', N'16122262   ')
GO
INSERT [dbo].[ChiTietCaTruc] ([trangThaiCaTruc], [ngayPhanCa], [maNV], [maCaTruc]) VALUES (N'true      ', CAST(N'2022-12-17T00:00:00.000' AS DateTime), N'NV02864', N'17122272   ')
GO
INSERT [dbo].[DichVu] ([maDichVu], [tenDichVu], [giaDichVu], [slTon], [hinhAnh]) VALUES (N'DV148', N'Hạt điều            ', 80000, 21, N'assets\images\cashew.png')
GO
INSERT [dbo].[DichVu] ([maDichVu], [tenDichVu], [giaDichVu], [slTon], [hinhAnh]) VALUES (N'DV160', N'Điều                ', 80000, 12, N'assets\images\cashew.png')
GO
INSERT [dbo].[DichVu] ([maDichVu], [tenDichVu], [giaDichVu], [slTon], [hinhAnh]) VALUES (N'DV226', N'CocaCola            ', 20000, 7, N'assets\images\cola.png')
GO
INSERT [dbo].[DichVu] ([maDichVu], [tenDichVu], [giaDichVu], [slTon], [hinhAnh]) VALUES (N'DV269', N'Gà Rán              ', 55000, 8, N'assets\images\fried-chicken.png')
GO
INSERT [dbo].[DichVu] ([maDichVu], [tenDichVu], [giaDichVu], [slTon], [hinhAnh]) VALUES (N'DV293', N'Bia                 ', 10000, 5, N'assets\images\beer.png')
GO
INSERT [dbo].[DichVu] ([maDichVu], [tenDichVu], [giaDichVu], [slTon], [hinhAnh]) VALUES (N'DV324', N'Hoa quả             ', 50000, 47, N'assets\images\fruit.png')
GO
INSERT [dbo].[DichVu] ([maDichVu], [tenDichVu], [giaDichVu], [slTon], [hinhAnh]) VALUES (N'DV412', N'Bỏng ngô            ', 60000, 24, N'assets\images\popcorn.png')
GO
INSERT [dbo].[DichVu] ([maDichVu], [tenDichVu], [giaDichVu], [slTon], [hinhAnh]) VALUES (N'DV526', N'Mực nướng           ', 100000, 84, N'assets\images\squid.png')
GO
INSERT [dbo].[DichVu] ([maDichVu], [tenDichVu], [giaDichVu], [slTon], [hinhAnh]) VALUES (N'DV643', N'Mì                  ', 15000, 78, N'assets\images\ramen.png')
GO
INSERT [dbo].[DichVu] ([maDichVu], [tenDichVu], [giaDichVu], [slTon], [hinhAnh]) VALUES (N'DV716', N'Nước suối           ', 25000, 137, N'assets\images\water.png')
GO
INSERT [dbo].[DichVu] ([maDichVu], [tenDichVu], [giaDichVu], [slTon], [hinhAnh]) VALUES (N'DV755', N'Nem nướng           ', 40000, 1, N'assets\images\fried-spring-rolls.png')
GO
INSERT [dbo].[DichVu] ([maDichVu], [tenDichVu], [giaDichVu], [slTon], [hinhAnh]) VALUES (N'DV785', N'Snack               ', 30000, 115, N'assets\images\snack.png')
GO
INSERT [dbo].[DichVu] ([maDichVu], [tenDichVu], [giaDichVu], [slTon], [hinhAnh]) VALUES (N'DV882', N'Nước chanh          ', 30000, 22, N'assets\images\juice.png')
GO
INSERT [dbo].[KhachHang] ([maKH], [tenKH], [sdt], [gioiTinh], [diaChi], [trangThai]) VALUES (N'0136', N'Nguyễn Quốc Trường', N'0386290136', 1, N'Xã Phổ Cường, Huyện Đức Phổ, Tỉnh Quảng Ngãi', 1)
GO
INSERT [dbo].[KhachHang] ([maKH], [tenKH], [sdt], [gioiTinh], [diaChi], [trangThai]) VALUES (N'0789', N'Nguyễn Phi Trường', N'0782800789', 1, N'Ấp Tân Quang, Xã Hiếu Phụng, Huyện Vũng Liêm, Tĩnh Vĩnh Long', 1)
GO
INSERT [dbo].[KhachHang] ([maKH], [tenKH], [sdt], [gioiTinh], [diaChi], [trangThai]) VALUES (N'1065', N'Nguyễn Nhật Huy', N'0352481065', 1, N'Ấp Trâm Vàng 1, Xã Thanh Phước, Huyện Gò Dầu, Tỉnh Tây Ninh', 1)
GO
INSERT [dbo].[KhachHang] ([maKH], [tenKH], [sdt], [gioiTinh], [diaChi], [trangThai]) VALUES (N'1142', N'Phạm Văn Tuyên', N'0911321142', 1, N'Thôn 3, Xã Ea Kao, Thành phố Buôn Ma Thuột, Tỉnh Đắk Lắk', 1)
GO
INSERT [dbo].[KhachHang] ([maKH], [tenKH], [sdt], [gioiTinh], [diaChi], [trangThai]) VALUES (N'1421', N'Phan Tiến Phong', N'0913261421', 1, N'Huyện Tây Hòa, Tỉnh Phú Yên.', 1)
GO
INSERT [dbo].[KhachHang] ([maKH], [tenKH], [sdt], [gioiTinh], [diaChi], [trangThai]) VALUES (N'1439', N'Đỗ Xuân Chung', N'0967811439', 1, N'Khu phố 3, Phường Thác Mơ, Thị Xã Phước Long, Tỉnh Bình Phước', 1)
GO
INSERT [dbo].[KhachHang] ([maKH], [tenKH], [sdt], [gioiTinh], [diaChi], [trangThai]) VALUES (N'1497', N'Phạm Khánh Nguyên', N'0398111497', 1, N'Xã Nhơn Lý, hhành phố Quy Nhơn, Tỉnh Bình Định.', 1)
GO
INSERT [dbo].[KhachHang] ([maKH], [tenKH], [sdt], [gioiTinh], [diaChi], [trangThai]) VALUES (N'1725', N'Hồ Yến Ngọc', N'0326351725', 0, N'Ấp 6B, Xã Long Phú, Huyện Tam Bình, Tỉnh Vĩnh Long', 1)
GO
INSERT [dbo].[KhachHang] ([maKH], [tenKH], [sdt], [gioiTinh], [diaChi], [trangThai]) VALUES (N'1860', N'Nguyễn Văn Hiền', N'          ', 1, N'Xóm 1, Xã Hùng Sơn, Huyện Anh Sơn, Tỉnh Nghệ An.', 1)
GO
INSERT [dbo].[KhachHang] ([maKH], [tenKH], [sdt], [gioiTinh], [diaChi], [trangThai]) VALUES (N'1978', N'Tạ Nguyễn Gia Bảo', N'0933551978', 1, N'Khu phố 1, Thị trấn Long Thành, Huyện Đức Huệ, Tỉnh Long An.', 1)
GO
INSERT [dbo].[KhachHang] ([maKH], [tenKH], [sdt], [gioiTinh], [diaChi], [trangThai]) VALUES (N'2245', N'Nguyễn Đình Thanh', N'0862462245', 1, N'Huyện Chư Sê, Tỉnh Gia Lai.', 1)
GO
INSERT [dbo].[KhachHang] ([maKH], [tenKH], [sdt], [gioiTinh], [diaChi], [trangThai]) VALUES (N'2293', N'Hà Tĩnh', N'0327002293', 1, N'Chánh Hóa, Xã Cát Chánh, Huyện Phù Cát, Tỉnh Bình Định', 1)
GO
INSERT [dbo].[KhachHang] ([maKH], [tenKH], [sdt], [gioiTinh], [diaChi], [trangThai]) VALUES (N'2320', N'Phạm Nhật Tiến', N'0975892320', 1, N'KV Phú Sơn, phường Nhơn Hòa, TX An Nhơn, tỉnh Bình Định', 1)
GO
INSERT [dbo].[KhachHang] ([maKH], [tenKH], [sdt], [gioiTinh], [diaChi], [trangThai]) VALUES (N'2382', N'Nguyễn Băng Như', N'0329632382', 1, N'TPHCM		', 0)
GO
INSERT [dbo].[KhachHang] ([maKH], [tenKH], [sdt], [gioiTinh], [diaChi], [trangThai]) VALUES (N'2423', N'Cao Nguyễn Khánh Duy', N'0368022423', 1, N'Thị trấn Thạnh Mỹ, Huyện Đơn Dương, Tỉnh Lâm Đồng', 1)
GO
INSERT [dbo].[KhachHang] ([maKH], [tenKH], [sdt], [gioiTinh], [diaChi], [trangThai]) VALUES (N'2839', N'Trương Văn Học', N'0963032839', 1, N'Tổ 8, Khu phố Đồng Sổ, Thị trấn Lai Uyên, Huyện Bàu Bàng, Tỉnh Bình Dương.', 1)
GO
INSERT [dbo].[KhachHang] ([maKH], [tenKH], [sdt], [gioiTinh], [diaChi], [trangThai]) VALUES (N'3236', N'Phan Ngọc Quảng', N'0356153236', 1, N'Thôn Tân Phú, Xã Đắk R''Moan, Huyện Gia Nghĩa, Tỉnh Đắk Nông', 1)
GO
INSERT [dbo].[KhachHang] ([maKH], [tenKH], [sdt], [gioiTinh], [diaChi], [trangThai]) VALUES (N'3380', N'Phan Công Trạng', N'0368943380', 1, N'Số 29, Khu Phố 2, Thị trấn Ba Tri, Huyện Ba Tri, Tỉnh Bến Tre', 1)
GO
INSERT [dbo].[KhachHang] ([maKH], [tenKH], [sdt], [gioiTinh], [diaChi], [trangThai]) VALUES (N'3715', N'Hà Quốc Long', N'0981833715', 1, N'7A/2, Ấp An Bình, Xã Trung Hòa, Huyện Trảng Bom, Tỉnh Đồng Nai', 1)
GO
INSERT [dbo].[KhachHang] ([maKH], [tenKH], [sdt], [gioiTinh], [diaChi], [trangThai]) VALUES (N'3874', N'Phạm Bình Phương Duy', N'0387733874', 1, N'66/6D ấp 4, xã Xuân Thới Thượng, huyện Hóc Môn, Thành phố Hồ Chí Minh.', 1)
GO
INSERT [dbo].[KhachHang] ([maKH], [tenKH], [sdt], [gioiTinh], [diaChi], [trangThai]) VALUES (N'3916', N'Lê Thành Đạt', N'0327553916', 1, N'Thôn Lan Trà, Phường Trúc Lâm, Huyện Tỉnh Gia, Tỉnh Thanh Hoá', 1)
GO
INSERT [dbo].[KhachHang] ([maKH], [tenKH], [sdt], [gioiTinh], [diaChi], [trangThai]) VALUES (N'4026', N'Nguyễn Thành Nam', N'0389204026', 1, N'THôn 3, Xã Ea Kmút, Huyện Ea Kar, Tỉnh Đắk Lắk.', 1)
GO
INSERT [dbo].[KhachHang] ([maKH], [tenKH], [sdt], [gioiTinh], [diaChi], [trangThai]) VALUES (N'4204', N'Võ Hoàng Tuấn', N'523924204 ', 1, N'688/93/15 Quang Trung, phường 11, Quận Gò Vấp, Thành phố Hồ Chí Minh.', 1)
GO
INSERT [dbo].[KhachHang] ([maKH], [tenKH], [sdt], [gioiTinh], [diaChi], [trangThai]) VALUES (N'4881', N'Nguyễn Tuấn Hùng', N'0382024881', 1, N'Xã Hùng Sơn, Huyện Tĩnh Gia, Tỉnh Thanh Hóa.', 1)
GO
INSERT [dbo].[KhachHang] ([maKH], [tenKH], [sdt], [gioiTinh], [diaChi], [trangThai]) VALUES (N'4905', N'Nguyễn Thành An', N'0962114905', 1, N'Tổ 5, Khu Phố 4, Phường Phước Hưng, Thành Phố Bà Rịa, Tỉnh Bà Rịa Vũng Tàu', 1)
GO
INSERT [dbo].[KhachHang] ([maKH], [tenKH], [sdt], [gioiTinh], [diaChi], [trangThai]) VALUES (N'4940', N'Nguyễn Văn Phường', N'0329347405', 1, N'Xã Cát Chánh, Huyện Phù Cát, Tỉnh Bình Định', 1)
GO
INSERT [dbo].[KhachHang] ([maKH], [tenKH], [sdt], [gioiTinh], [diaChi], [trangThai]) VALUES (N'5121', N'Nguyễn Hữu Hải', N'0374195121', 1, N'Thôn Hiền Lương, Xã Cam An Bắc, Huyện Cam Lâm, Tỉnh Khánh Hòa', 1)
GO
INSERT [dbo].[KhachHang] ([maKH], [tenKH], [sdt], [gioiTinh], [diaChi], [trangThai]) VALUES (N'5215', N'Bùi Thanh Đạt', N'0342825215', 1, N'Huyện Núi Thành, Tỉnh Quảng Nam.', 1)
GO
INSERT [dbo].[KhachHang] ([maKH], [tenKH], [sdt], [gioiTinh], [diaChi], [trangThai]) VALUES (N'5376', N'Hồ Nguyễn Đăng Khoa', N'0904135376', 1, N'108A Thi Sách, Phường 6, Thành phố Đà Lạt, Tỉnh Lâm Đồng.', 1)
GO
INSERT [dbo].[KhachHang] ([maKH], [tenKH], [sdt], [gioiTinh], [diaChi], [trangThai]) VALUES (N'5971', N'Nguyễn Tiến Trường', N'0358055971', 1, N'Huyện Tân Phú.', 1)
GO
INSERT [dbo].[KhachHang] ([maKH], [tenKH], [sdt], [gioiTinh], [diaChi], [trangThai]) VALUES (N'6101', N'Nguyễn Tuấn Anh', N'0583156101', 1, N'1A79/2B Nguyễn Huệ, Thị trấn Gia Ray, Huyện Xuân Lộc, Tỉnh Đồng Nai', 1)
GO
INSERT [dbo].[KhachHang] ([maKH], [tenKH], [sdt], [gioiTinh], [diaChi], [trangThai]) VALUES (N'6144', N'Hồ Võ Hoàng Duy', N'0374426144', 1, N'11 Đường số 425, tổ 7, ấp 6, Xã Phước Vĩnh An, Huyện Củ Chi, Thành phố Hồ Chí Minh', 1)
GO
INSERT [dbo].[KhachHang] ([maKH], [tenKH], [sdt], [gioiTinh], [diaChi], [trangThai]) VALUES (N'6203', N'Nguyễn Văn A', N'0968396203', NULL, NULL, 1)
GO
INSERT [dbo].[KhachHang] ([maKH], [tenKH], [sdt], [gioiTinh], [diaChi], [trangThai]) VALUES (N'6222', N'Nguyễn Văn D', N'0968396222', NULL, NULL, 1)
GO
INSERT [dbo].[KhachHang] ([maKH], [tenKH], [sdt], [gioiTinh], [diaChi], [trangThai]) VALUES (N'6228', N'Nguyễn Văn A', N'0968396228', NULL, NULL, 1)
GO
INSERT [dbo].[KhachHang] ([maKH], [tenKH], [sdt], [gioiTinh], [diaChi], [trangThai]) VALUES (N'6229', N'Nguyễn Văn A', N'0968396229', NULL, NULL, 1)
GO
INSERT [dbo].[KhachHang] ([maKH], [tenKH], [sdt], [gioiTinh], [diaChi], [trangThai]) VALUES (N'6414', N'Đinh Quang Khiêm', N'0369286414', 1, N'Xã Hòa Hiệp, Huyện Xuyên Mộc, Tỉnh Bà Rịa - Vũng Tàu.', 1)
GO
INSERT [dbo].[KhachHang] ([maKH], [tenKH], [sdt], [gioiTinh], [diaChi], [trangThai]) VALUES (N'6747', N'Nguyễn Tấn Phát', N'0918996747', 1, N'Số nhà 272, xã Điền Hải, Huyện Đông Hải, Tỉnh Bạc Liêu.', 1)
GO
INSERT [dbo].[KhachHang] ([maKH], [tenKH], [sdt], [gioiTinh], [diaChi], [trangThai]) VALUES (N'6782', N'cter', N'0123456782', 1, N'daklak', 1)
GO
INSERT [dbo].[KhachHang] ([maKH], [tenKH], [sdt], [gioiTinh], [diaChi], [trangThai]) VALUES (N'6789', N'kuga', N'0123456789', 1, N'longan', 1)
GO
INSERT [dbo].[KhachHang] ([maKH], [tenKH], [sdt], [gioiTinh], [diaChi], [trangThai]) VALUES (N'6873', N'Nguyễn Văn C', N'0968396873', NULL, NULL, 1)
GO
INSERT [dbo].[KhachHang] ([maKH], [tenKH], [sdt], [gioiTinh], [diaChi], [trangThai]) VALUES (N'6902', N'Nguyễn Văn Tuyền', N'0968396902', NULL, NULL, 1)
GO
INSERT [dbo].[KhachHang] ([maKH], [tenKH], [sdt], [gioiTinh], [diaChi], [trangThai]) VALUES (N'6908', N'Nguyễn Văn A', N'0968396908', NULL, NULL, 1)
GO
INSERT [dbo].[KhachHang] ([maKH], [tenKH], [sdt], [gioiTinh], [diaChi], [trangThai]) VALUES (N'7130', N'Dương Quân Mạnh', N'0928447130', 1, N'TDP 9, Phường Tự An, Thành phố Buôn Ma Thuột, Tỉnh Đắk Lắk', 1)
GO
INSERT [dbo].[KhachHang] ([maKH], [tenKH], [sdt], [gioiTinh], [diaChi], [trangThai]) VALUES (N'7269', N'Nguyễn Văn Thế Hoàng', N'0985847269', 1, N'Huyện Củ Chi.', 1)
GO
INSERT [dbo].[KhachHang] ([maKH], [tenKH], [sdt], [gioiTinh], [diaChi], [trangThai]) VALUES (N'7292', N'Võ Nguyễn Hữu Lộc', N'0989537292', 1, N'Ấp Bình Thạnh 1, Xã Thạnh Trị, Huyện Bình Đại, Tỉnh Bến Tre', 1)
GO
INSERT [dbo].[KhachHang] ([maKH], [tenKH], [sdt], [gioiTinh], [diaChi], [trangThai]) VALUES (N'7417', N'Nguyễn Thị Hồng Vân', N'0399247417', 0, N'Huyện Tiền Hải.', 1)
GO
INSERT [dbo].[KhachHang] ([maKH], [tenKH], [sdt], [gioiTinh], [diaChi], [trangThai]) VALUES (N'7464', N'Bùi Thị Yến Yến', N'0387917464', 0, N'Thôn 8, Xã Nhân Đạo, Huyện Đắk R Lấp, Tỉnh Đắk Nông', 1)
GO
INSERT [dbo].[KhachHang] ([maKH], [tenKH], [sdt], [gioiTinh], [diaChi], [trangThai]) VALUES (N'7552', N'Nguyễn Tuấn Anh', N'0973237552', 1, N'Thôn 6, Xã Tâm Thắng, Huyện Cư Jút, Tỉnh Đắk Nông', 1)
GO
INSERT [dbo].[KhachHang] ([maKH], [tenKH], [sdt], [gioiTinh], [diaChi], [trangThai]) VALUES (N'7841', N'Nguyễn Khải', N'0898917841', 1, N'9/18 Mai Xuân Thưởng, Phường Tấn Tài, Thành phố Phan Rang -Tháp Chàm, Tỉnh Ninh Thuận', 1)
GO
INSERT [dbo].[KhachHang] ([maKH], [tenKH], [sdt], [gioiTinh], [diaChi], [trangThai]) VALUES (N'7919', N'Bùi Thị Huyền Trang', N'0389467919', 0, N'Thôn Kiến Xương, Xã Buôn Tría, Huyện Lắk, Tỉnh Đắk Lắk', 1)
GO
INSERT [dbo].[KhachHang] ([maKH], [tenKH], [sdt], [gioiTinh], [diaChi], [trangThai]) VALUES (N'8049', N'Hoàng Xuân Trường', N'0394468049', 1, N'Thôn Tam Liên, xã Ea Tam, huyện Krông Năng, Tỉnh Đắk Lắk.', 1)
GO
INSERT [dbo].[KhachHang] ([maKH], [tenKH], [sdt], [gioiTinh], [diaChi], [trangThai]) VALUES (N'8100', N'Trần Công Toàn', N'0379498100', 1, N'Thôn Phí Xá, Xã Lê Thiện, Huyện An Dương, Thành phố Hải Phòng', 1)
GO
INSERT [dbo].[KhachHang] ([maKH], [tenKH], [sdt], [gioiTinh], [diaChi], [trangThai]) VALUES (N'8431', N'cter', N'0237238431', 1, N'daklak', 1)
GO
INSERT [dbo].[KhachHang] ([maKH], [tenKH], [sdt], [gioiTinh], [diaChi], [trangThai]) VALUES (N'8695', N'Nguyễn Minh Hoàng', N'0763178695', 1, N'Thôn Nội Thượng, Xã Hà Bình, Huyện Hà Trung, Tỉnh Thanh Hóa', 1)
GO
INSERT [dbo].[KhachHang] ([maKH], [tenKH], [sdt], [gioiTinh], [diaChi], [trangThai]) VALUES (N'8702', N'Lê Đình Chương', N'0355678702', 1, N'Đội 3, thôn Thái Thuận, Xã Nhơn Phúc, Thị xã An Nhơn, Tỉnh Bình Định', 1)
GO
INSERT [dbo].[KhachHang] ([maKH], [tenKH], [sdt], [gioiTinh], [diaChi], [trangThai]) VALUES (N'8773', N'Nguyễn Văn A', N'0987678773', NULL, NULL, 1)
GO
INSERT [dbo].[KhachHang] ([maKH], [tenKH], [sdt], [gioiTinh], [diaChi], [trangThai]) VALUES (N'8819', N'Đặng Thị Ngọc Lan', N'0865398819', 0, N'43/242 Huỳng THúc Kháng, Phường Yên Đỗ, Thành phố Pleiku, Tỉnh Gia Lai.', 1)
GO
INSERT [dbo].[KhachHang] ([maKH], [tenKH], [sdt], [gioiTinh], [diaChi], [trangThai]) VALUES (N'8963', N'Phạm Quốc Huy', N'0933268963', 1, N'Ấp 1, Xã Trừ Văn Thố, Huyện Bàu Bàng, Tỉnh Bình Dương', 1)
GO
INSERT [dbo].[KhachHang] ([maKH], [tenKH], [sdt], [gioiTinh], [diaChi], [trangThai]) VALUES (N'9073', N'Nguyen Van Anh', N'0965799073', 1, N'Xã Phố Là, Huyện Đồng Văn, Tỉnh Hà Giang', 1)
GO
INSERT [dbo].[KhachHang] ([maKH], [tenKH], [sdt], [gioiTinh], [diaChi], [trangThai]) VALUES (N'9078', N'Nguyễn Mỹ Quyên', N'0965799078', 0, N'Ấp Mỹ Phú, xã Mỹ Phước, huyện Mang Thít, tỉnh Vĩnh Long', 1)
GO
INSERT [dbo].[KhachHang] ([maKH], [tenKH], [sdt], [gioiTinh], [diaChi], [trangThai]) VALUES (N'9112', N'Nguyễn Văn Anh Khoa', N'0971789112', 1, N'Xã Vĩnh Lộc, Huyện Can Lộc, Tỉnh Hà Tĩnh', 1)
GO
INSERT [dbo].[KhachHang] ([maKH], [tenKH], [sdt], [gioiTinh], [diaChi], [trangThai]) VALUES (N'9259', N'Trần Vũ Minh Nhật', N'0934909259', 1, N'TT1, Xã Tam Quan Bắc, Huyện Hoài Nhơn, Tỉnh Bình Định', 1)
GO
INSERT [dbo].[KhachHang] ([maKH], [tenKH], [sdt], [gioiTinh], [diaChi], [trangThai]) VALUES (N'9607', N'Trần Thanh Thảo', N'0945609607', 1, N'514A, Nguyễn Phi Khanh, Phường Vĩnh Quang, Thành phố Rạch Giá, Tỉnh Kiên Giang', 1)
GO
INSERT [dbo].[KhachHang] ([maKH], [tenKH], [sdt], [gioiTinh], [diaChi], [trangThai]) VALUES (N'9953', N'Đinh Văn Toàn', N'0336189953', 1, N'Thôn 5 , Xã Lộc Nam, Huyện Bảo Lâm, Tỉnh Lâm Đồng.', 1)
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'12T105NV02736872', CAST(N'2022-12-12T13:51:34.773' AS DateTime), N'NV02736', N'6203')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'12T234NV02736631', CAST(N'2022-12-12T13:48:49.077' AS DateTime), N'NV02736', N'8773')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'12T345NV02736207', CAST(N'2022-12-12T13:48:49.103' AS DateTime), N'NV02736', N'8773')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'12T345NV02736935', CAST(N'2022-12-12T13:51:34.787' AS DateTime), N'NV02736', N'6203')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'12T384NV02736652', CAST(N'2022-12-12T13:51:34.797' AS DateTime), N'NV02736', N'6203')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'13T105NV02736580', CAST(N'2022-12-13T14:06:03.530' AS DateTime), N'NV02736', N'2382')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'13T105NV02736594', CAST(N'2022-12-13T14:54:34.343' AS DateTime), N'NV02736', N'1142')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'13T105NV02736835', CAST(N'2022-12-13T19:54:14.147' AS DateTime), N'NV02736', N'2423')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'13T234NV02736879', CAST(N'2022-12-13T12:49:48.100' AS DateTime), N'NV02736', N'1439')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'13T234NV02736989', CAST(N'2022-12-13T14:37:29.770' AS DateTime), N'NV02736', N'1439')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'13T405NV02736281', CAST(N'2022-12-13T12:46:46.823' AS DateTime), N'NV02736', N'1439')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'13T717NV02736579', CAST(N'2022-12-13T14:45:15.283' AS DateTime), N'NV02736', N'9112')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'13V170NV02736396', CAST(N'2022-12-13T14:06:22.837' AS DateTime), N'NV02736', N'3380')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'13V170NV02736898', CAST(N'2022-12-13T14:36:03.210' AS DateTime), N'NV02736', N'3380')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'14T105NV02864267', CAST(N'2022-12-14T23:27:54.673' AS DateTime), N'NV02864', N'6222')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'14T105NV02864302', CAST(N'2022-12-14T23:20:37.433' AS DateTime), N'NV02864', N'6873')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'14T105NV02864328', CAST(N'2022-12-14T20:47:58.640' AS DateTime), N'NV02864', N'7464')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'14T105NV02864586', CAST(N'2022-12-14T23:19:13.903' AS DateTime), N'NV02864', N'6902')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'14T234NV02864280', CAST(N'2022-12-14T23:20:37.447' AS DateTime), N'NV02864', N'6873')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'14T234NV02864325', CAST(N'2022-12-14T23:32:45.447' AS DateTime), N'NV02864', N'6228')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'14T234NV02864376', CAST(N'2022-12-14T20:53:34.123' AS DateTime), N'NV02864', N'2423')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'14T345NV02864902', CAST(N'2022-12-14T23:19:13.920' AS DateTime), N'NV02864', N'6902')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'14T384NV02864207', CAST(N'2022-12-14T23:20:37.457' AS DateTime), N'NV02864', N'6873')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'14T384NV02864467', CAST(N'2022-12-14T20:55:50.237' AS DateTime), N'NV02864', N'2423')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'14T384NV02864473', CAST(N'2022-12-14T23:19:13.927' AS DateTime), N'NV02864', N'6902')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'14T389NV02864237', CAST(N'2022-12-14T23:32:45.463' AS DateTime), N'NV02864', N'6228')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'14T389NV02864240', CAST(N'2022-12-14T23:30:16.690' AS DateTime), N'NV02864', N'6229')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'14T389NV02864622', CAST(N'2022-12-14T23:19:13.937' AS DateTime), N'NV02864', N'6902')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'14T405NV02864855', CAST(N'2022-12-14T21:11:45.810' AS DateTime), N'NV02864', N'2423')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'14T533NV02864921', CAST(N'2022-12-14T23:32:45.473' AS DateTime), N'NV02864', N'6228')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'14V174NV02864585', CAST(N'2022-12-14T23:20:37.467' AS DateTime), N'NV02864', N'6873')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T105NV02864109', CAST(N'2022-08-10T16:49:00.000' AS DateTime), N'NV02864', N'2245')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T105NV02864139', CAST(N'2022-12-10T05:43:00.000' AS DateTime), N'NV02864', N'3715')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T105NV02864172', CAST(N'2022-12-09T09:32:00.000' AS DateTime), N'NV02864', N'1439')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T105NV02864175', CAST(N'2022-12-08T17:07:00.000' AS DateTime), N'NV02864', N'2320')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T105NV02864232', CAST(N'2022-12-10T10:01:00.000' AS DateTime), N'NV02864', N'6101')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T105NV02864234', CAST(N'2020-10-10T13:58:00.000' AS DateTime), N'NV02864', N'6101')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T105NV02864247', CAST(N'2022-10-10T06:16:00.000' AS DateTime), N'NV02864', N'7919')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T105NV02864277', CAST(N'2020-10-10T19:23:00.000' AS DateTime), N'NV02864', N'9078')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T105NV02864396', CAST(N'2022-12-10T04:05:00.000' AS DateTime), N'NV02864', N'4881')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T105NV02864485', CAST(N'2022-12-10T01:07:00.000' AS DateTime), N'NV02864', N'2320')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T105NV02864515', CAST(N'2020-11-10T15:12:00.000' AS DateTime), N'NV02864', N'4881')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T105NV02864547', CAST(N'2022-09-10T19:57:00.000' AS DateTime), N'NV02864', N'2839')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T105NV02864578', CAST(N'2022-09-10T13:32:00.000' AS DateTime), N'NV02864', N'7841')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T105NV02864595', CAST(N'2022-12-07T20:25:00.000' AS DateTime), N'NV02864', N'4026')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T105NV02864601', CAST(N'2022-08-10T11:26:00.000' AS DateTime), N'NV02864', N'8963')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T105NV02864603', CAST(N'2022-12-12T20:27:00.000' AS DateTime), N'NV02864', N'6203')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T105NV02864606', CAST(N'2022-12-07T02:45:00.000' AS DateTime), N'NV02864', N'4026')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T105NV02864614', CAST(N'2022-09-10T06:13:00.000' AS DateTime), N'NV02864', N'2382')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T105NV02864624', CAST(N'2022-12-12T05:27:00.000' AS DateTime), N'NV02864', N'4026')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T105NV02864631', CAST(N'2020-11-10T18:18:00.000' AS DateTime), N'NV02864', N'4881')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T105NV02864644', CAST(N'2022-12-09T01:15:00.000' AS DateTime), N'NV02864', N'7417')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T105NV02864722', CAST(N'2022-12-08T03:11:00.000' AS DateTime), N'NV02864', N'2320')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T105NV02864744', CAST(N'2022-10-10T18:57:00.000' AS DateTime), N'NV02864', N'7841')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T105NV02864769', CAST(N'2022-12-10T20:31:00.000' AS DateTime), N'NV02864', N'9112')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T105NV02864800', CAST(N'2022-10-10T06:07:00.000' AS DateTime), N'NV02864', N'1421')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T105NV02864809', CAST(N'2022-10-10T10:57:00.000' AS DateTime), N'NV02864', N'6203')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T105NV02864825', CAST(N'2022-12-07T03:34:00.000' AS DateTime), N'NV02864', N'4905')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T105NV02864829', CAST(N'2022-08-10T04:18:00.000' AS DateTime), N'NV02864', N'2293')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T105NV02864841', CAST(N'2022-12-07T05:07:00.000' AS DateTime), N'NV02864', N'2293')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T105NV02864853', CAST(N'2020-10-10T12:17:00.000' AS DateTime), N'NV02864', N'2382')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T105NV02864930', CAST(N'2020-11-10T21:10:00.000' AS DateTime), N'NV02864', N'5376')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T105NV02864935', CAST(N'2022-08-10T07:36:00.000' AS DateTime), N'NV02864', N'1439')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T105NV02864938', CAST(N'2022-10-10T21:51:00.000' AS DateTime), N'NV02864', N'2245')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T105NV02864957', CAST(N'2022-12-16T07:54:24.120' AS DateTime), N'NV02864', NULL)
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T234NV02864179', CAST(N'2022-12-12T09:26:00.000' AS DateTime), N'NV02864', N'7841')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T234NV02864186', CAST(N'2022-05-10T02:30:00.000' AS DateTime), N'NV02864', N'7464')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T234NV02864259', CAST(N'2022-09-10T10:18:00.000' AS DateTime), N'NV02864', N'1860')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T234NV02864266', CAST(N'2022-05-10T11:31:00.000' AS DateTime), N'NV02864', N'5376')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T234NV02864269', CAST(N'2022-08-10T14:51:00.000' AS DateTime), N'NV02864', N'4026')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T234NV02864316', CAST(N'2022-12-10T02:35:00.000' AS DateTime), N'NV02864', N'2320')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T234NV02864342', CAST(N'2022-12-08T19:04:00.000' AS DateTime), N'NV02864', N'6902')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T234NV02864374', CAST(N'2020-11-10T23:21:00.000' AS DateTime), N'NV02864', N'7919')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T234NV02864393', CAST(N'2022-12-09T22:13:00.000' AS DateTime), N'NV02864', N'6101')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T234NV02864497', CAST(N'2022-05-10T17:54:00.000' AS DateTime), N'NV02864', N'3715')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T234NV02864546', CAST(N'2022-12-09T14:50:00.000' AS DateTime), N'NV02864', N'3715')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T234NV02864707', CAST(N'2022-12-10T00:18:00.000' AS DateTime), N'NV02864', N'0789')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T234NV02864722', CAST(N'2022-12-12T15:42:00.000' AS DateTime), N'NV02864', N'8963')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T234NV02864777', CAST(N'2022-09-10T17:48:00.000' AS DateTime), N'NV02864', N'2382')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T234NV02864793', CAST(N'2022-12-07T19:24:00.000' AS DateTime), N'NV02864', N'6902')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T234NV02864919', CAST(N'2022-12-08T09:02:00.000' AS DateTime), N'NV02864', N'0789')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T234NV02864952', CAST(N'2022-09-10T05:10:00.000' AS DateTime), N'NV02864', N'7464')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T234NV02864974', CAST(N'2022-12-07T18:19:00.000' AS DateTime), N'NV02864', N'1421')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T345NV02864129', CAST(N'2020-11-10T14:15:00.000' AS DateTime), N'NV02864', N'4881')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T345NV02864138', CAST(N'2022-12-12T09:38:00.000' AS DateTime), N'NV02864', N'5215')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T345NV02864203', CAST(N'2022-10-10T18:23:00.000' AS DateTime), N'NV02864', N'4905')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T345NV02864222', CAST(N'2022-12-07T03:32:00.000' AS DateTime), N'NV02864', N'0789')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T345NV02864252', CAST(N'2022-12-08T04:39:00.000' AS DateTime), N'NV02864', N'2423')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T345NV02864255', CAST(N'2020-10-10T02:14:00.000' AS DateTime), N'NV02864', N'7919')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T345NV02864260', CAST(N'2022-12-08T17:30:00.000' AS DateTime), N'NV02864', N'8963')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T345NV02864367', CAST(N'2022-12-12T11:37:00.000' AS DateTime), N'NV02864', N'4940')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T345NV02864399', CAST(N'2022-09-10T08:01:00.000' AS DateTime), N'NV02864', N'4881')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T345NV02864493', CAST(N'2020-10-10T15:37:00.000' AS DateTime), N'NV02864', N'7417')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T345NV02864495', CAST(N'2022-12-07T11:46:00.000' AS DateTime), N'NV02864', N'9078')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T345NV02864589', CAST(N'2022-09-10T21:17:00.000' AS DateTime), N'NV02864', N'1142')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T345NV02864628', CAST(N'2022-12-08T16:43:00.000' AS DateTime), N'NV02864', N'8963')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T345NV02864668', CAST(N'2022-12-07T05:17:00.000' AS DateTime), N'NV02864', N'2245')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T345NV02864714', CAST(N'2022-12-10T05:04:00.000' AS DateTime), N'NV02864', N'2423')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T345NV02864886', CAST(N'2020-10-10T20:21:00.000' AS DateTime), N'NV02864', N'2293')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T384NV02864164', CAST(N'2022-12-07T12:14:00.000' AS DateTime), N'NV02864', N'3715')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T384NV02864324', CAST(N'2022-12-10T13:35:00.000' AS DateTime), N'NV02864', N'4940')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T384NV02864367', CAST(N'2022-12-10T08:18:00.000' AS DateTime), N'NV02864', N'3715')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T384NV02864454', CAST(N'2022-12-09T02:41:00.000' AS DateTime), N'NV02864', N'2245')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T384NV02864476', CAST(N'2022-12-07T20:00:00.000' AS DateTime), N'NV02864', N'2320')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T384NV02864499', CAST(N'2022-12-10T17:02:00.000' AS DateTime), N'NV02864', N'1725')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T384NV02864558', CAST(N'2022-12-10T16:38:00.000' AS DateTime), N'NV02864', N'9078')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T384NV02864584', CAST(N'2022-12-10T11:03:00.000' AS DateTime), N'NV02864', N'6902')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T384NV02864612', CAST(N'2022-12-07T21:53:00.000' AS DateTime), N'NV02864', N'6902')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T384NV02864657', CAST(N'2022-05-10T07:50:00.000' AS DateTime), N'NV02864', N'6902')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T384NV02864784', CAST(N'2022-12-12T02:51:00.000' AS DateTime), N'NV02864', N'7464')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T384NV02864846', CAST(N'2022-12-07T17:14:00.000' AS DateTime), N'NV02864', N'4026')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T384NV02864870', CAST(N'2022-12-08T17:14:00.000' AS DateTime), N'NV02864', N'4026')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T384NV02864880', CAST(N'2022-12-07T00:03:00.000' AS DateTime), N'NV02864', N'1439')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T384NV02864999', CAST(N'2022-12-07T15:25:00.000' AS DateTime), N'NV02864', N'4026')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T389NV02864124', CAST(N'2022-05-10T04:03:00.000' AS DateTime), N'NV02864', N'4026')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T389NV02864326', CAST(N'2022-12-08T17:05:00.000' AS DateTime), N'NV02864', N'9078')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T389NV02864462', CAST(N'2022-10-10T00:05:00.000' AS DateTime), N'NV02864', N'9078')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T389NV02864469', CAST(N'2022-05-10T17:38:00.000' AS DateTime), N'NV02864', N'1439')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T389NV02864482', CAST(N'2022-12-09T05:21:00.000' AS DateTime), N'NV02864', N'4905')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T389NV02864575', CAST(N'2022-08-10T15:09:00.000' AS DateTime), N'NV02864', N'1421')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T389NV02864664', CAST(N'2022-10-10T08:25:00.000' AS DateTime), N'NV02864', N'9078')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T389NV02864686', CAST(N'2022-12-09T15:36:00.000' AS DateTime), N'NV02864', N'9078')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T389NV02864801', CAST(N'2022-12-08T23:39:00.000' AS DateTime), N'NV02864', N'1725')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T389NV02864888', CAST(N'2022-12-10T21:53:00.000' AS DateTime), N'NV02864', N'1725')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T389NV02864894', CAST(N'2022-12-09T04:39:00.000' AS DateTime), N'NV02864', N'7417')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T389NV02864901', CAST(N'2022-05-10T18:23:00.000' AS DateTime), N'NV02864', N'2423')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T389NV02864918', CAST(N'2022-12-08T14:31:00.000' AS DateTime), N'NV02864', N'4905')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T389NV02864922', CAST(N'2022-12-09T16:56:00.000' AS DateTime), N'NV02864', N'1439')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T389NV02864982', CAST(N'2022-12-10T14:18:00.000' AS DateTime), N'NV02864', N'1725')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T405NV02864166', CAST(N'2022-12-10T21:39:00.000' AS DateTime), N'NV02864', N'0789')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T405NV02864168', CAST(N'2022-08-10T23:38:00.000' AS DateTime), N'NV02864', N'4881')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T405NV02864187', CAST(N'2022-12-07T02:22:00.000' AS DateTime), N'NV02864', N'7919')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T405NV02864257', CAST(N'2022-12-08T20:39:00.000' AS DateTime), N'NV02864', N'4881')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T405NV02864261', CAST(N'2022-12-07T08:00:00.000' AS DateTime), N'NV02864', N'2839')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T405NV02864302', CAST(N'2022-12-12T07:24:00.000' AS DateTime), N'NV02864', N'4026')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T405NV02864307', CAST(N'2022-12-09T00:19:00.000' AS DateTime), N'NV02864', N'6203')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T405NV02864328', CAST(N'2020-11-10T12:01:00.000' AS DateTime), N'NV02864', N'6101')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T405NV02864334', CAST(N'2022-12-09T07:55:00.000' AS DateTime), N'NV02864', N'1439')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T405NV02864343', CAST(N'2022-12-07T13:50:00.000' AS DateTime), N'NV02864', N'6902')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T405NV02864395', CAST(N'2022-12-07T05:07:00.000' AS DateTime), N'NV02864', N'9112')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T405NV02864521', CAST(N'2022-12-10T16:03:00.000' AS DateTime), N'NV02864', N'1439')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T405NV02864582', CAST(N'2022-12-16T07:54:46.767' AS DateTime), N'NV02864', NULL)
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T405NV02864604', CAST(N'2022-12-10T00:45:00.000' AS DateTime), N'NV02864', N'7464')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T405NV02864628', CAST(N'2022-12-10T15:02:00.000' AS DateTime), N'NV02864', N'8963')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T405NV02864658', CAST(N'2022-12-09T16:25:00.000' AS DateTime), N'NV02864', N'2423')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T405NV02864696', CAST(N'2022-12-12T04:07:00.000' AS DateTime), N'NV02864', N'4905')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T405NV02864859', CAST(N'2022-12-09T17:05:00.000' AS DateTime), N'NV02864', N'7417')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T405NV02864903', CAST(N'2022-08-10T03:28:00.000' AS DateTime), N'NV02864', N'2293')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T533NV02864205', CAST(N'2022-05-10T08:42:00.000' AS DateTime), N'NV02864', N'1142')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T533NV02864208', CAST(N'2022-08-10T15:54:00.000' AS DateTime), N'NV02864', N'9078')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T533NV02864244', CAST(N'2022-12-12T00:06:00.000' AS DateTime), N'NV02864', N'5376')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T533NV02864330', CAST(N'2022-12-07T11:23:00.000' AS DateTime), N'NV02864', N'4905')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T533NV02864339', CAST(N'2022-12-07T07:30:00.000' AS DateTime), N'NV02864', N'2293')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T533NV02864381', CAST(N'2022-12-12T11:36:00.000' AS DateTime), N'NV02864', N'5215')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T533NV02864495', CAST(N'2022-08-10T10:33:00.000' AS DateTime), N'NV02864', N'0789')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T533NV02864506', CAST(N'2022-12-07T03:54:00.000' AS DateTime), N'NV02864', N'5215')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T533NV02864671', CAST(N'2022-12-07T18:30:00.000' AS DateTime), N'NV02864', N'6902')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T533NV02864681', CAST(N'2022-12-09T10:09:00.000' AS DateTime), N'NV02864', N'2320')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T533NV02864717', CAST(N'2022-12-12T08:56:00.000' AS DateTime), N'NV02864', N'4881')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T533NV02864719', CAST(N'2022-12-07T03:54:00.000' AS DateTime), N'NV02864', N'9078')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T533NV02864743', CAST(N'2020-11-10T21:33:00.000' AS DateTime), N'NV02864', N'1421')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T533NV02864746', CAST(N'2020-10-10T18:31:00.000' AS DateTime), N'NV02864', N'6203')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T533NV02864784', CAST(N'2022-12-10T09:18:00.000' AS DateTime), N'NV02864', N'0789')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T533NV02864788', CAST(N'2022-12-07T11:16:00.000' AS DateTime), N'NV02864', N'3715')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T533NV02864805', CAST(N'2022-12-07T03:25:00.000' AS DateTime), N'NV02864', N'9078')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T533NV02864880', CAST(N'2022-12-07T16:16:00.000' AS DateTime), N'NV02864', N'0789')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T533NV02864922', CAST(N'2022-05-10T09:32:00.000' AS DateTime), N'NV02864', N'1860')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T533NV02864936', CAST(N'2022-12-07T01:17:00.000' AS DateTime), N'NV02864', N'1421')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T533NV02864947', CAST(N'2022-12-10T23:01:00.000' AS DateTime), N'NV02864', N'1439')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T533NV02864974', CAST(N'2022-09-10T08:13:00.000' AS DateTime), N'NV02864', N'1421')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T554NV02864299', CAST(N'2022-12-07T14:44:00.000' AS DateTime), N'NV02864', N'9078')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T554NV02864305', CAST(N'2022-12-10T00:16:00.000' AS DateTime), N'NV02864', N'7841')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T554NV02864377', CAST(N'2022-12-10T17:53:00.000' AS DateTime), N'NV02864', N'4026')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T554NV02864403', CAST(N'2022-12-08T04:42:00.000' AS DateTime), N'NV02864', N'7417')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T554NV02864500', CAST(N'2022-12-09T10:53:00.000' AS DateTime), N'NV02864', N'2839')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T554NV02864558', CAST(N'2022-12-10T05:45:00.000' AS DateTime), N'NV02864', N'8963')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T554NV02864679', CAST(N'2022-12-07T12:25:00.000' AS DateTime), N'NV02864', N'1142')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T554NV02864682', CAST(N'2022-12-10T00:29:00.000' AS DateTime), N'NV02864', N'2423')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T554NV02864703', CAST(N'2022-09-10T04:47:00.000' AS DateTime), N'NV02864', N'7464')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T554NV02864736', CAST(N'2022-10-10T17:05:00.000' AS DateTime), N'NV02864', N'6203')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T554NV02864743', CAST(N'2022-12-07T18:32:00.000' AS DateTime), N'NV02864', N'5215')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T554NV02864777', CAST(N'2020-11-10T01:13:00.000' AS DateTime), N'NV02864', N'2423')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T554NV02864781', CAST(N'2022-10-10T03:01:00.000' AS DateTime), N'NV02864', N'2423')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T554NV02864787', CAST(N'2022-12-08T04:45:00.000' AS DateTime), N'NV02864', N'1142')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T554NV02864842', CAST(N'2022-12-10T11:28:00.000' AS DateTime), N'NV02864', N'2423')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T554NV02864956', CAST(N'2022-12-10T14:32:00.000' AS DateTime), N'NV02864', N'9078')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T554NV02864962', CAST(N'2022-12-08T01:36:00.000' AS DateTime), N'NV02864', N'7919')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T599NV02864176', CAST(N'2022-09-10T00:19:00.000' AS DateTime), N'NV02864', N'9078')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T599NV02864271', CAST(N'2022-12-12T00:39:00.000' AS DateTime), N'NV02864', N'2423')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T599NV02864358', CAST(N'2022-12-09T01:47:00.000' AS DateTime), N'NV02864', N'6902')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T599NV02864376', CAST(N'2022-12-08T23:59:00.000' AS DateTime), N'NV02864', N'1860')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T599NV02864424', CAST(N'2022-05-10T13:36:00.000' AS DateTime), N'NV02864', N'7464')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T599NV02864496', CAST(N'2022-10-10T17:17:00.000' AS DateTime), N'NV02864', N'7417')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T599NV02864514', CAST(N'2022-10-10T15:02:00.000' AS DateTime), N'NV02864', N'5376')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T599NV02864669', CAST(N'2022-05-10T16:01:00.000' AS DateTime), N'NV02864', N'2382')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T599NV02864677', CAST(N'2022-12-10T00:16:00.000' AS DateTime), N'NV02864', N'4940')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T599NV02864706', CAST(N'2022-10-10T23:29:00.000' AS DateTime), N'NV02864', N'6203')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T599NV02864784', CAST(N'2022-12-07T05:34:00.000' AS DateTime), N'NV02864', N'6902')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T599NV02864789', CAST(N'2022-12-07T22:06:00.000' AS DateTime), N'NV02864', N'7417')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T599NV02864796', CAST(N'2022-12-09T12:10:00.000' AS DateTime), N'NV02864', N'2423')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T716NV02864171', CAST(N'2022-12-07T11:14:00.000' AS DateTime), N'NV02864', N'2839')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T716NV02864180', CAST(N'2022-12-10T05:31:00.000' AS DateTime), N'NV02864', N'4881')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T716NV02864264', CAST(N'2020-10-10T12:45:00.000' AS DateTime), N'NV02864', N'2245')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T716NV02864284', CAST(N'2022-12-07T13:49:00.000' AS DateTime), N'NV02864', N'3715')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T716NV02864397', CAST(N'2022-09-10T09:48:00.000' AS DateTime), N'NV02864', N'4940')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T716NV02864486', CAST(N'2022-12-12T09:13:00.000' AS DateTime), N'NV02864', N'2382')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T716NV02864525', CAST(N'2022-12-08T09:20:00.000' AS DateTime), N'NV02864', N'6203')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T716NV02864537', CAST(N'2022-12-08T17:59:00.000' AS DateTime), N'NV02864', N'5215')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T716NV02864612', CAST(N'2020-10-10T18:37:00.000' AS DateTime), N'NV02864', N'7464')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T716NV02864646', CAST(N'2022-10-10T02:45:00.000' AS DateTime), N'NV02864', N'4940')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T716NV02864788', CAST(N'2022-09-10T14:56:00.000' AS DateTime), N'NV02864', N'7841')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T716NV02864837', CAST(N'2022-12-09T08:14:00.000' AS DateTime), N'NV02864', N'9078')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T716NV02864871', CAST(N'2020-11-10T08:24:00.000' AS DateTime), N'NV02864', N'1421')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T716NV02864920', CAST(N'2020-11-10T04:56:00.000' AS DateTime), N'NV02864', N'2293')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T716NV02864926', CAST(N'2022-12-12T02:11:00.000' AS DateTime), N'NV02864', N'2382')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T716NV02864952', CAST(N'2022-12-07T08:18:00.000' AS DateTime), N'NV02864', N'9112')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T716NV02864965', CAST(N'2022-10-10T21:56:00.000' AS DateTime), N'NV02864', N'5215')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T717NV02864188', CAST(N'2022-12-12T03:15:00.000' AS DateTime), N'NV02864', N'1725')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T717NV02864255', CAST(N'2022-12-07T11:02:00.000' AS DateTime), N'NV02864', N'1142')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T717NV02864326', CAST(N'2022-08-10T11:31:00.000' AS DateTime), N'NV02864', N'1142')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T717NV02864333', CAST(N'2022-10-10T15:04:00.000' AS DateTime), N'NV02864', N'2293')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T717NV02864390', CAST(N'2022-12-07T01:27:00.000' AS DateTime), N'NV02864', N'4881')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T717NV02864400', CAST(N'2022-12-10T07:30:00.000' AS DateTime), N'NV02864', N'2382')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T717NV02864430', CAST(N'2022-12-09T15:54:00.000' AS DateTime), N'NV02864', N'6902')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T717NV02864443', CAST(N'2022-12-10T04:44:00.000' AS DateTime), N'NV02864', N'2245')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T717NV02864480', CAST(N'2022-12-10T07:30:00.000' AS DateTime), N'NV02864', N'2293')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T717NV02864665', CAST(N'2022-12-10T05:41:00.000' AS DateTime), N'NV02864', N'2320')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T717NV02864713', CAST(N'2022-12-09T14:43:00.000' AS DateTime), N'NV02864', N'0789')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T717NV02864734', CAST(N'2022-05-10T05:20:00.000' AS DateTime), N'NV02864', N'1142')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T717NV02864743', CAST(N'2022-12-09T12:19:00.000' AS DateTime), N'NV02864', N'1142')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T717NV02864851', CAST(N'2022-08-10T06:50:00.000' AS DateTime), N'NV02864', N'0789')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T717NV02864995', CAST(N'2022-12-07T21:21:00.000' AS DateTime), N'NV02864', N'5215')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T778NV02864136', CAST(N'2022-12-07T10:00:00.000' AS DateTime), N'NV02864', N'7841')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T778NV02864144', CAST(N'2022-12-12T22:50:00.000' AS DateTime), N'NV02864', N'1142')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T778NV02864146', CAST(N'2022-12-09T18:43:00.000' AS DateTime), N'NV02864', N'7464')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T778NV02864217', CAST(N'2022-12-07T01:49:00.000' AS DateTime), N'NV02864', N'0789')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T778NV02864242', CAST(N'2022-12-08T02:28:00.000' AS DateTime), N'NV02864', N'4905')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T778NV02864279', CAST(N'2022-12-10T03:29:00.000' AS DateTime), N'NV02864', N'1860')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T778NV02864307', CAST(N'2022-09-10T11:08:00.000' AS DateTime), N'NV02864', N'7417')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T778NV02864434', CAST(N'2022-12-07T16:10:00.000' AS DateTime), N'NV02864', N'2839')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T778NV02864595', CAST(N'2022-08-10T11:01:00.000' AS DateTime), N'NV02864', N'7464')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T778NV02864651', CAST(N'2020-10-10T07:25:00.000' AS DateTime), N'NV02864', N'7841')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T778NV02864697', CAST(N'2022-05-10T16:51:00.000' AS DateTime), N'NV02864', N'2382')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T778NV02864781', CAST(N'2022-12-09T04:12:00.000' AS DateTime), N'NV02864', N'7841')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T778NV02864945', CAST(N'2022-12-09T13:07:00.000' AS DateTime), N'NV02864', N'9078')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T778NV02864999', CAST(N'2022-10-10T23:31:00.000' AS DateTime), N'NV02864', N'1421')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T811NV02864154', CAST(N'2022-09-10T01:39:00.000' AS DateTime), N'NV02864', N'8963')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T811NV02864289', CAST(N'2022-12-08T00:22:00.000' AS DateTime), N'NV02864', N'8963')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T811NV02864304', CAST(N'2022-12-08T01:40:00.000' AS DateTime), N'NV02864', N'0789')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T811NV02864392', CAST(N'2022-08-10T18:55:00.000' AS DateTime), N'NV02864', N'4940')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T811NV02864409', CAST(N'2022-12-09T23:25:00.000' AS DateTime), N'NV02864', N'1725')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T811NV02864426', CAST(N'2022-12-07T04:19:00.000' AS DateTime), N'NV02864', N'5215')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T811NV02864470', CAST(N'2022-09-10T06:16:00.000' AS DateTime), N'NV02864', N'2320')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T811NV02864581', CAST(N'2022-12-07T15:32:00.000' AS DateTime), N'NV02864', N'1421')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T811NV02864589', CAST(N'2022-12-08T12:25:00.000' AS DateTime), N'NV02864', N'6203')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T811NV02864685', CAST(N'2020-10-10T19:41:00.000' AS DateTime), N'NV02864', N'9078')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T811NV02864690', CAST(N'2022-12-09T10:59:00.000' AS DateTime), N'NV02864', N'1860')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T811NV02864711', CAST(N'2022-12-09T10:23:00.000' AS DateTime), N'NV02864', N'7464')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T811NV02864803', CAST(N'2022-10-10T14:07:00.000' AS DateTime), N'NV02864', N'7417')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T811NV02864823', CAST(N'2020-11-10T23:51:00.000' AS DateTime), N'NV02864', N'7417')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T811NV02864939', CAST(N'2022-12-08T15:05:00.000' AS DateTime), N'NV02864', N'2839')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T897NV02864110', CAST(N'2022-12-07T04:37:00.000' AS DateTime), N'NV02864', N'2382')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T897NV02864235', CAST(N'2022-12-10T12:39:00.000' AS DateTime), N'NV02864', N'9078')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T897NV02864297', CAST(N'2022-05-10T03:33:00.000' AS DateTime), N'NV02864', N'6203')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T897NV02864453', CAST(N'2022-12-07T17:32:00.000' AS DateTime), N'NV02864', N'1142')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T897NV02864459', CAST(N'2022-12-07T11:53:00.000' AS DateTime), N'NV02864', N'1860')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T897NV02864472', CAST(N'2020-11-10T10:33:00.000' AS DateTime), N'NV02864', N'2245')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T897NV02864510', CAST(N'2022-12-07T15:32:00.000' AS DateTime), N'NV02864', N'7919')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T897NV02864654', CAST(N'2022-12-09T03:16:00.000' AS DateTime), N'NV02864', N'8963')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T897NV02864655', CAST(N'2022-12-10T16:28:00.000' AS DateTime), N'NV02864', N'6902')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T897NV02864762', CAST(N'2022-12-09T03:40:00.000' AS DateTime), N'NV02864', N'7841')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T897NV02864812', CAST(N'2022-05-10T22:42:00.000' AS DateTime), N'NV02864', N'4881')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T897NV02864820', CAST(N'2020-10-10T19:39:00.000' AS DateTime), N'NV02864', N'1860')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T949NV02864101', CAST(N'2022-12-09T22:02:00.000' AS DateTime), N'NV02864', N'4026')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T949NV02864204', CAST(N'2022-12-10T08:14:00.000' AS DateTime), N'NV02864', N'5376')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T949NV02864248', CAST(N'2022-12-07T21:30:00.000' AS DateTime), N'NV02864', N'8963')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T949NV02864313', CAST(N'2022-12-12T19:23:00.000' AS DateTime), N'NV02864', N'2245')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T949NV02864315', CAST(N'2020-11-10T17:26:00.000' AS DateTime), N'NV02864', N'1439')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T949NV02864369', CAST(N'2020-10-10T19:31:00.000' AS DateTime), N'NV02864', N'2245')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T949NV02864379', CAST(N'2022-12-08T04:50:00.000' AS DateTime), N'NV02864', N'7919')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T949NV02864437', CAST(N'2022-12-08T01:14:00.000' AS DateTime), N'NV02864', N'4905')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T949NV02864466', CAST(N'2022-12-08T03:45:00.000' AS DateTime), N'NV02864', N'7841')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T949NV02864470', CAST(N'2022-12-08T13:21:00.000' AS DateTime), N'NV02864', N'9078')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T949NV02864479', CAST(N'2022-05-10T22:53:00.000' AS DateTime), N'NV02864', N'7464')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T949NV02864484', CAST(N'2022-12-07T17:02:00.000' AS DateTime), N'NV02864', N'2382')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T949NV02864627', CAST(N'2022-12-09T11:04:00.000' AS DateTime), N'NV02864', N'2839')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T949NV02864634', CAST(N'2020-10-10T19:04:00.000' AS DateTime), N'NV02864', N'7919')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T949NV02864724', CAST(N'2022-12-07T04:19:00.000' AS DateTime), N'NV02864', N'8963')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T949NV02864776', CAST(N'2022-10-10T00:45:00.000' AS DateTime), N'NV02864', N'4881')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T949NV02864858', CAST(N'2022-08-10T11:33:00.000' AS DateTime), N'NV02864', N'3715')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16T949NV02864932', CAST(N'2020-11-10T11:57:00.000' AS DateTime), N'NV02864', N'0789')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V170NV02864277', CAST(N'2022-12-08T17:25:00.000' AS DateTime), N'NV02864', N'7919')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V170NV02864368', CAST(N'2022-12-08T03:37:00.000' AS DateTime), N'NV02864', N'2293')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V170NV02864439', CAST(N'2022-10-10T10:04:00.000' AS DateTime), N'NV02864', N'5376')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V170NV02864540', CAST(N'2022-09-10T13:42:00.000' AS DateTime), N'NV02864', N'9112')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V170NV02864615', CAST(N'2020-11-10T15:25:00.000' AS DateTime), N'NV02864', N'4940')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V170NV02864718', CAST(N'2022-12-08T05:03:00.000' AS DateTime), N'NV02864', N'2320')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V170NV02864788', CAST(N'2022-12-09T01:48:00.000' AS DateTime), N'NV02864', N'6203')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V170NV02864860', CAST(N'2022-10-10T08:44:00.000' AS DateTime), N'NV02864', N'4881')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V170NV02864869', CAST(N'2022-12-07T01:58:00.000' AS DateTime), N'NV02864', N'4026')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V170NV02864932', CAST(N'2022-12-07T11:16:00.000' AS DateTime), N'NV02864', N'6101')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V170NV02864941', CAST(N'2022-12-10T05:07:00.000' AS DateTime), N'NV02864', N'9112')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V170NV02864960', CAST(N'2022-12-09T11:04:00.000' AS DateTime), N'NV02864', N'1142')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V170NV02864961', CAST(N'2020-11-10T02:29:00.000' AS DateTime), N'NV02864', N'6101')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V174NV02864149', CAST(N'2022-12-08T07:09:00.000' AS DateTime), N'NV02864', N'1439')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V174NV02864271', CAST(N'2022-12-08T12:48:00.000' AS DateTime), N'NV02864', N'4940')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V174NV02864390', CAST(N'2020-10-10T00:49:00.000' AS DateTime), N'NV02864', N'2382')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V174NV02864415', CAST(N'2022-12-09T19:39:00.000' AS DateTime), N'NV02864', N'1421')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V174NV02864446', CAST(N'2022-12-07T03:58:00.000' AS DateTime), N'NV02864', N'1439')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V174NV02864530', CAST(N'2022-12-10T05:26:00.000' AS DateTime), N'NV02864', N'5215')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V174NV02864544', CAST(N'2022-12-09T08:17:00.000' AS DateTime), N'NV02864', N'9112')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V174NV02864551', CAST(N'2020-11-10T10:35:00.000' AS DateTime), N'NV02864', N'6902')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V174NV02864564', CAST(N'2022-12-09T12:19:00.000' AS DateTime), N'NV02864', N'7417')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V174NV02864895', CAST(N'2022-05-10T03:38:00.000' AS DateTime), N'NV02864', N'1725')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V174NV02864950', CAST(N'2022-12-07T19:24:00.000' AS DateTime), N'NV02864', N'4026')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V231NV02864169', CAST(N'2022-05-10T20:47:00.000' AS DateTime), N'NV02864', N'1142')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V231NV02864384', CAST(N'2020-10-10T06:59:00.000' AS DateTime), N'NV02864', N'1860')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V231NV02864479', CAST(N'2022-12-10T04:23:00.000' AS DateTime), N'NV02864', N'9078')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V231NV02864571', CAST(N'2022-12-08T01:06:00.000' AS DateTime), N'NV02864', N'3715')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V231NV02864602', CAST(N'2022-08-10T21:38:00.000' AS DateTime), N'NV02864', N'2839')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V231NV02864624', CAST(N'2022-12-09T05:20:00.000' AS DateTime), N'NV02864', N'2423')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V231NV02864662', CAST(N'2022-10-10T13:20:00.000' AS DateTime), N'NV02864', N'6101')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V231NV02864730', CAST(N'2022-12-07T12:43:00.000' AS DateTime), N'NV02864', N'7417')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V231NV02864771', CAST(N'2022-09-10T11:54:00.000' AS DateTime), N'NV02864', N'6902')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V231NV02864797', CAST(N'2022-12-07T23:10:00.000' AS DateTime), N'NV02864', N'2423')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V231NV02864932', CAST(N'2022-12-09T09:53:00.000' AS DateTime), N'NV02864', N'1439')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V231NV02864949', CAST(N'2022-12-10T10:46:00.000' AS DateTime), N'NV02864', N'4940')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V231NV02864988', CAST(N'2022-12-07T15:42:00.000' AS DateTime), N'NV02864', N'2382')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V344NV02864164', CAST(N'2022-08-10T15:01:00.000' AS DateTime), N'NV02864', N'9078')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V344NV02864184', CAST(N'2020-11-10T23:39:00.000' AS DateTime), N'NV02864', N'1421')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V344NV02864218', CAST(N'2022-12-09T10:00:00.000' AS DateTime), N'NV02864', N'1725')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V344NV02864389', CAST(N'2022-12-07T01:18:00.000' AS DateTime), N'NV02864', N'3715')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V344NV02864436', CAST(N'2022-12-07T06:44:00.000' AS DateTime), N'NV02864', N'3715')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V344NV02864465', CAST(N'2022-12-08T07:09:00.000' AS DateTime), N'NV02864', N'8963')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V344NV02864470', CAST(N'2022-10-10T07:29:00.000' AS DateTime), N'NV02864', N'5376')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V344NV02864910', CAST(N'2022-12-12T06:30:00.000' AS DateTime), N'NV02864', N'9078')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V344NV02864919', CAST(N'2022-12-09T02:20:00.000' AS DateTime), N'NV02864', N'9112')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V344NV02864986', CAST(N'2022-12-08T07:43:00.000' AS DateTime), N'NV02864', N'2293')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V344NV02864999', CAST(N'2022-12-08T00:18:00.000' AS DateTime), N'NV02864', N'9078')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V347NV02864383', CAST(N'2022-12-09T16:07:00.000' AS DateTime), N'NV02864', N'4026')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V347NV02864519', CAST(N'2022-12-10T03:34:00.000' AS DateTime), N'NV02864', N'9078')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V347NV02864799', CAST(N'2020-10-10T03:28:00.000' AS DateTime), N'NV02864', N'6203')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V347NV02864835', CAST(N'2022-12-08T01:03:00.000' AS DateTime), N'NV02864', N'4940')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V347NV02864892', CAST(N'2022-08-10T09:54:00.000' AS DateTime), N'NV02864', N'7919')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V347NV02864902', CAST(N'2022-05-10T03:57:00.000' AS DateTime), N'NV02864', N'1142')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V347NV02864954', CAST(N'2022-12-07T17:11:00.000' AS DateTime), N'NV02864', N'6101')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V351NV02864167', CAST(N'2022-12-07T18:40:00.000' AS DateTime), N'NV02864', N'4026')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V351NV02864237', CAST(N'2022-12-09T08:31:00.000' AS DateTime), N'NV02864', N'4940')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V351NV02864314', CAST(N'2022-10-10T14:46:00.000' AS DateTime), N'NV02864', N'1860')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V351NV02864340', CAST(N'2022-05-10T18:49:00.000' AS DateTime), N'NV02864', N'6902')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V351NV02864464', CAST(N'2022-12-07T14:08:00.000' AS DateTime), N'NV02864', N'2293')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V351NV02864516', CAST(N'2022-12-10T12:23:00.000' AS DateTime), N'NV02864', N'4940')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V351NV02864520', CAST(N'2022-12-07T10:21:00.000' AS DateTime), N'NV02864', N'2423')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V351NV02864575', CAST(N'2022-12-10T05:15:00.000' AS DateTime), N'NV02864', N'5215')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V351NV02864670', CAST(N'2022-12-12T17:05:00.000' AS DateTime), N'NV02864', N'4905')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V351NV02864726', CAST(N'2022-12-09T12:18:00.000' AS DateTime), N'NV02864', N'4905')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V351NV02864767', CAST(N'2022-12-08T19:02:00.000' AS DateTime), N'NV02864', N'2382')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V351NV02864770', CAST(N'2020-11-10T13:18:00.000' AS DateTime), N'NV02864', N'6203')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V351NV02864791', CAST(N'2022-12-10T19:39:00.000' AS DateTime), N'NV02864', N'9078')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V351NV02864832', CAST(N'2022-12-07T13:29:00.000' AS DateTime), N'NV02864', N'5215')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V351NV02864880', CAST(N'2022-12-09T15:15:00.000' AS DateTime), N'NV02864', N'4881')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V351NV02864922', CAST(N'2020-10-10T13:27:00.000' AS DateTime), N'NV02864', N'3715')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V351NV02864932', CAST(N'2022-05-10T21:45:00.000' AS DateTime), N'NV02864', N'6101')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V351NV02864995', CAST(N'2020-11-10T03:38:00.000' AS DateTime), N'NV02864', N'5215')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V392NV02864119', CAST(N'2022-09-10T12:53:00.000' AS DateTime), N'NV02864', N'1725')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V392NV02864125', CAST(N'2020-11-10T02:10:00.000' AS DateTime), N'NV02864', N'2423')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V392NV02864172', CAST(N'2020-10-10T14:34:00.000' AS DateTime), N'NV02864', N'6902')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V392NV02864222', CAST(N'2022-12-10T15:20:00.000' AS DateTime), N'NV02864', N'3715')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V392NV02864327', CAST(N'2022-12-08T08:22:00.000' AS DateTime), N'NV02864', N'7919')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V392NV02864351', CAST(N'2022-10-10T22:51:00.000' AS DateTime), N'NV02864', N'7464')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V392NV02864521', CAST(N'2022-12-08T04:08:00.000' AS DateTime), N'NV02864', N'7841')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V392NV02864563', CAST(N'2020-11-10T15:08:00.000' AS DateTime), N'NV02864', N'8963')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V392NV02864949', CAST(N'2020-11-10T22:08:00.000' AS DateTime), N'NV02864', N'9078')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V392NV02864967', CAST(N'2022-12-10T05:19:00.000' AS DateTime), N'NV02864', N'7841')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V432NV02864138', CAST(N'2022-12-08T18:44:00.000' AS DateTime), N'NV02864', N'2293')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V432NV02864266', CAST(N'2022-12-08T07:22:00.000' AS DateTime), N'NV02864', N'9078')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V432NV02864270', CAST(N'2022-12-12T05:17:00.000' AS DateTime), N'NV02864', N'4026')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V432NV02864276', CAST(N'2022-12-10T10:56:00.000' AS DateTime), N'NV02864', N'1439')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V432NV02864298', CAST(N'2022-12-12T14:46:00.000' AS DateTime), N'NV02864', N'5215')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V432NV02864380', CAST(N'2022-12-08T21:27:00.000' AS DateTime), N'NV02864', N'2245')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V432NV02864411', CAST(N'2022-09-10T12:54:00.000' AS DateTime), N'NV02864', N'4881')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V432NV02864458', CAST(N'2022-05-10T19:45:00.000' AS DateTime), N'NV02864', N'9078')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V432NV02864463', CAST(N'2022-12-07T21:52:00.000' AS DateTime), N'NV02864', N'6902')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V432NV02864517', CAST(N'2022-12-07T01:35:00.000' AS DateTime), N'NV02864', N'2293')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V432NV02864536', CAST(N'2022-12-09T23:47:00.000' AS DateTime), N'NV02864', N'2293')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V432NV02864538', CAST(N'2022-08-10T03:46:00.000' AS DateTime), N'NV02864', N'1439')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V432NV02864549', CAST(N'2022-12-07T05:44:00.000' AS DateTime), N'NV02864', N'9112')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V432NV02864562', CAST(N'2022-12-07T17:47:00.000' AS DateTime), N'NV02864', N'4905')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V432NV02864573', CAST(N'2022-12-08T05:44:00.000' AS DateTime), N'NV02864', N'2293')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V432NV02864727', CAST(N'2020-11-10T20:49:00.000' AS DateTime), N'NV02864', N'9078')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V432NV02864771', CAST(N'2022-12-08T09:03:00.000' AS DateTime), N'NV02864', N'2423')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V432NV02864849', CAST(N'2022-09-10T02:28:00.000' AS DateTime), N'NV02864', N'9112')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V432NV02864860', CAST(N'2022-12-07T17:34:00.000' AS DateTime), N'NV02864', N'1142')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V432NV02864871', CAST(N'2022-12-07T18:06:00.000' AS DateTime), N'NV02864', N'2320')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V432NV02864977', CAST(N'2022-12-08T03:48:00.000' AS DateTime), N'NV02864', N'7464')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V531NV02864102', CAST(N'2022-12-07T20:32:00.000' AS DateTime), N'NV02864', N'2382')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V531NV02864146', CAST(N'2020-10-10T17:20:00.000' AS DateTime), N'NV02864', N'7417')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V531NV02864265', CAST(N'2022-05-10T01:50:00.000' AS DateTime), N'NV02864', N'6203')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V531NV02864324', CAST(N'2020-11-10T01:01:00.000' AS DateTime), N'NV02864', N'1860')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V531NV02864445', CAST(N'2022-12-10T00:57:00.000' AS DateTime), N'NV02864', N'0789')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V531NV02864459', CAST(N'2022-12-09T05:07:00.000' AS DateTime), N'NV02864', N'2293')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V531NV02864504', CAST(N'2022-08-10T22:39:00.000' AS DateTime), N'NV02864', N'7919')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V531NV02864589', CAST(N'2022-12-07T10:21:00.000' AS DateTime), N'NV02864', N'4940')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V531NV02864692', CAST(N'2020-10-10T01:53:00.000' AS DateTime), N'NV02864', N'2423')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V531NV02864774', CAST(N'2022-12-09T14:12:00.000' AS DateTime), N'NV02864', N'2423')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V531NV02864782', CAST(N'2022-12-12T00:00:00.000' AS DateTime), N'NV02864', N'4881')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V531NV02864808', CAST(N'2022-12-09T06:17:00.000' AS DateTime), N'NV02864', N'1439')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V531NV02864864', CAST(N'2022-12-08T08:47:00.000' AS DateTime), N'NV02864', N'4905')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V531NV02864872', CAST(N'2022-09-10T19:47:00.000' AS DateTime), N'NV02864', N'5376')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V531NV02864951', CAST(N'2022-12-07T22:36:00.000' AS DateTime), N'NV02864', N'6203')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V531NV02864962', CAST(N'2022-08-10T15:56:00.000' AS DateTime), N'NV02864', N'2320')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V596NV02864157', CAST(N'2022-12-12T02:53:00.000' AS DateTime), N'NV02864', N'3715')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V596NV02864180', CAST(N'2022-12-07T12:35:00.000' AS DateTime), N'NV02864', N'2423')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V596NV02864229', CAST(N'2022-12-07T23:39:00.000' AS DateTime), N'NV02864', N'7464')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V596NV02864271', CAST(N'2022-10-10T21:30:00.000' AS DateTime), N'NV02864', N'3715')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V596NV02864360', CAST(N'2022-09-10T04:49:00.000' AS DateTime), N'NV02864', N'7417')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V596NV02864368', CAST(N'2022-12-09T13:44:00.000' AS DateTime), N'NV02864', N'7464')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V596NV02864455', CAST(N'2022-12-09T06:48:00.000' AS DateTime), N'NV02864', N'6902')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V596NV02864494', CAST(N'2022-12-09T06:17:00.000' AS DateTime), N'NV02864', N'6101')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V596NV02864641', CAST(N'2022-12-08T22:13:00.000' AS DateTime), N'NV02864', N'7919')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V596NV02864766', CAST(N'2022-05-10T22:59:00.000' AS DateTime), N'NV02864', N'7919')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V596NV02864836', CAST(N'2022-05-10T06:19:00.000' AS DateTime), N'NV02864', N'1439')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V596NV02864972', CAST(N'2022-05-10T01:21:00.000' AS DateTime), N'NV02864', N'9078')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V596NV02864995', CAST(N'2022-12-12T16:51:00.000' AS DateTime), N'NV02864', N'2382')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V627NV02864104', CAST(N'2022-12-07T15:07:00.000' AS DateTime), N'NV02864', N'2423')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V627NV02864223', CAST(N'2022-12-08T16:40:00.000' AS DateTime), N'NV02864', N'2245')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V627NV02864423', CAST(N'2022-12-10T10:12:00.000' AS DateTime), N'NV02864', N'7464')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V627NV02864463', CAST(N'2022-12-10T13:10:00.000' AS DateTime), N'NV02864', N'1421')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V627NV02864571', CAST(N'2020-11-10T14:45:00.000' AS DateTime), N'NV02864', N'9112')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V627NV02864587', CAST(N'2022-12-10T23:00:00.000' AS DateTime), N'NV02864', N'2320')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V627NV02864597', CAST(N'2022-12-08T09:51:00.000' AS DateTime), N'NV02864', N'2382')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V627NV02864769', CAST(N'2022-12-08T17:28:00.000' AS DateTime), N'NV02864', N'5376')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V627NV02864844', CAST(N'2022-12-08T17:12:00.000' AS DateTime), N'NV02864', N'8963')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V627NV02864845', CAST(N'2022-08-10T05:20:00.000' AS DateTime), N'NV02864', N'9078')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V786NV02864104', CAST(N'2022-10-10T03:18:00.000' AS DateTime), N'NV02864', N'0789')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V786NV02864134', CAST(N'2022-08-10T21:49:00.000' AS DateTime), N'NV02864', N'1142')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V786NV02864144', CAST(N'2022-12-10T20:17:00.000' AS DateTime), N'NV02864', N'1142')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V786NV02864167', CAST(N'2022-08-10T00:16:00.000' AS DateTime), N'NV02864', N'9078')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V786NV02864234', CAST(N'2022-08-10T11:00:00.000' AS DateTime), N'NV02864', N'7919')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V786NV02864285', CAST(N'2022-12-09T21:49:00.000' AS DateTime), N'NV02864', N'6902')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V786NV02864368', CAST(N'2022-12-12T10:48:00.000' AS DateTime), N'NV02864', N'4940')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V786NV02864461', CAST(N'2020-10-10T03:28:00.000' AS DateTime), N'NV02864', N'3715')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V786NV02864528', CAST(N'2022-12-07T13:33:00.000' AS DateTime), N'NV02864', N'6902')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V786NV02864677', CAST(N'2022-09-10T12:53:00.000' AS DateTime), N'NV02864', N'2293')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V786NV02864714', CAST(N'2022-12-08T03:48:00.000' AS DateTime), N'NV02864', N'4940')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V786NV02864760', CAST(N'2022-05-10T20:19:00.000' AS DateTime), N'NV02864', N'4881')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V786NV02864785', CAST(N'2022-08-10T21:56:00.000' AS DateTime), N'NV02864', N'9078')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V786NV02864863', CAST(N'2020-11-10T11:37:00.000' AS DateTime), N'NV02864', N'7464')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V786NV02864867', CAST(N'2022-08-10T07:05:00.000' AS DateTime), N'NV02864', N'4881')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V908NV02864158', CAST(N'2022-12-07T07:56:00.000' AS DateTime), N'NV02864', N'2320')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V908NV02864179', CAST(N'2022-09-10T09:31:00.000' AS DateTime), N'NV02864', N'7919')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V908NV02864224', CAST(N'2022-12-07T12:09:00.000' AS DateTime), N'NV02864', N'8963')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V908NV02864248', CAST(N'2022-12-07T11:50:00.000' AS DateTime), N'NV02864', N'6902')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V908NV02864253', CAST(N'2022-12-07T02:55:00.000' AS DateTime), N'NV02864', N'2320')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V908NV02864330', CAST(N'2022-05-10T09:53:00.000' AS DateTime), N'NV02864', N'2293')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V908NV02864406', CAST(N'2022-09-10T18:00:00.000' AS DateTime), N'NV02864', N'3715')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V908NV02864423', CAST(N'2022-12-09T11:08:00.000' AS DateTime), N'NV02864', N'6902')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V908NV02864456', CAST(N'2022-12-07T05:23:00.000' AS DateTime), N'NV02864', N'9112')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V908NV02864546', CAST(N'2022-10-10T08:33:00.000' AS DateTime), N'NV02864', N'1860')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V908NV02864612', CAST(N'2022-12-10T02:59:00.000' AS DateTime), N'NV02864', N'8963')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V908NV02864651', CAST(N'2022-12-10T06:26:00.000' AS DateTime), N'NV02864', N'4881')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V908NV02864693', CAST(N'2022-05-10T06:35:00.000' AS DateTime), N'NV02864', N'5215')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V908NV02864745', CAST(N'2022-12-07T09:00:00.000' AS DateTime), N'NV02864', N'4940')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V908NV02864773', CAST(N'2020-10-10T13:12:00.000' AS DateTime), N'NV02864', N'2839')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V908NV02864824', CAST(N'2020-10-10T10:36:00.000' AS DateTime), N'NV02864', N'6101')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V908NV02864850', CAST(N'2022-12-09T12:00:00.000' AS DateTime), N'NV02864', N'9078')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V908NV02864918', CAST(N'2022-12-07T21:09:00.000' AS DateTime), N'NV02864', N'7841')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V908NV02864932', CAST(N'2022-12-09T15:12:00.000' AS DateTime), N'NV02864', N'4940')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V983NV02864125', CAST(N'2020-11-10T03:43:00.000' AS DateTime), N'NV02864', N'1725')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V983NV02864192', CAST(N'2022-09-10T07:46:00.000' AS DateTime), N'NV02864', N'1439')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V983NV02864228', CAST(N'2020-11-10T17:07:00.000' AS DateTime), N'NV02864', N'0789')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V983NV02864267', CAST(N'2022-09-10T11:04:00.000' AS DateTime), N'NV02864', N'7417')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V983NV02864290', CAST(N'2022-10-10T16:24:00.000' AS DateTime), N'NV02864', N'4940')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V983NV02864293', CAST(N'2022-08-10T04:13:00.000' AS DateTime), N'NV02864', N'2320')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V983NV02864397', CAST(N'2022-12-12T18:07:00.000' AS DateTime), N'NV02864', N'6101')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V983NV02864437', CAST(N'2022-12-08T20:12:00.000' AS DateTime), N'NV02864', N'2245')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V983NV02864451', CAST(N'2022-12-08T18:02:00.000' AS DateTime), N'NV02864', N'9112')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V983NV02864485', CAST(N'2022-12-12T04:16:00.000' AS DateTime), N'NV02864', N'9078')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V983NV02864501', CAST(N'2022-08-10T21:02:00.000' AS DateTime), N'NV02864', N'2293')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V983NV02864655', CAST(N'2022-12-12T20:37:00.000' AS DateTime), N'NV02864', N'7464')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V983NV02864680', CAST(N'2022-12-10T19:05:00.000' AS DateTime), N'NV02864', N'9112')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V983NV02864810', CAST(N'2022-12-08T04:38:00.000' AS DateTime), N'NV02864', N'5215')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V983NV02864858', CAST(N'2022-12-09T21:45:00.000' AS DateTime), N'NV02864', N'1860')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V983NV02864936', CAST(N'2020-11-10T03:28:00.000' AS DateTime), N'NV02864', N'0789')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V983NV02864939', CAST(N'2020-10-10T22:38:00.000' AS DateTime), N'NV02864', N'2293')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V983NV02864949', CAST(N'2020-11-10T01:19:00.000' AS DateTime), N'NV02864', N'1860')
GO
INSERT [dbo].[HoaDon] ([maHD], [ngayLapHD], [maNhanVien], [maKH]) VALUES (N'16V983NV02864993', CAST(N'2020-11-10T16:37:00.000' AS DateTime), N'NV02864', N'2839')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'13T105NV02736835', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'13T105NV02736835', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'13T105NV02736835', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'13T405NV02736281', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'14T384NV02864467', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'14T384NV02864467', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'14T384NV02864467', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'14T384NV02864467', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'14T384NV02864467', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (52, N'14T384NV02864467', N'DV716')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'14T389NV02864622', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'14T389NV02864622', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'14T405NV02864855', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'14T405NV02864855', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'14T405NV02864855', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'14T405NV02864855', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'14T405NV02864855', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'14T405NV02864855', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'14T405NV02864855', N'DV716')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'14T405NV02864855', N'DV785')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'14T405NV02864855', N'DV882')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T105NV02864109', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16T105NV02864109', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T105NV02864109', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T105NV02864109', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T105NV02864109', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T105NV02864109', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T105NV02864109', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16T105NV02864109', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T105NV02864109', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T105NV02864139', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T105NV02864139', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16T105NV02864139', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T105NV02864139', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16T105NV02864172', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T105NV02864172', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T105NV02864172', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T105NV02864172', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T105NV02864172', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T105NV02864175', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T105NV02864175', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T105NV02864175', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T105NV02864175', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T105NV02864175', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T105NV02864175', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16T105NV02864175', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T105NV02864175', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16T105NV02864175', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T105NV02864175', N'DV716')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T105NV02864232', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T105NV02864232', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16T105NV02864232', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T105NV02864232', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T105NV02864232', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T105NV02864232', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T105NV02864232', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T105NV02864232', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T105NV02864232', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T105NV02864234', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T105NV02864234', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T105NV02864247', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T105NV02864247', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T105NV02864247', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T105NV02864247', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16T105NV02864247', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T105NV02864247', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T105NV02864247', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T105NV02864247', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T105NV02864247', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T105NV02864247', N'DV716')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T105NV02864247', N'DV755')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T105NV02864277', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T105NV02864277', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T105NV02864396', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T105NV02864396', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16T105NV02864396', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T105NV02864396', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T105NV02864485', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T105NV02864485', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16T105NV02864485', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T105NV02864485', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T105NV02864485', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T105NV02864485', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T105NV02864485', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T105NV02864485', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T105NV02864485', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T105NV02864515', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T105NV02864515', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16T105NV02864515', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T105NV02864515', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T105NV02864515', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T105NV02864515', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T105NV02864515', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T105NV02864515', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T105NV02864515', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16T105NV02864515', N'DV716')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T105NV02864515', N'DV755')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T105NV02864515', N'DV785')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16T105NV02864547', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T105NV02864547', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16T105NV02864578', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T105NV02864578', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16T105NV02864595', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T105NV02864595', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T105NV02864595', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16T105NV02864595', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T105NV02864595', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T105NV02864595', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T105NV02864601', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16T105NV02864601', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T105NV02864601', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T105NV02864601', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T105NV02864601', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T105NV02864601', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T105NV02864601', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16T105NV02864601', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T105NV02864601', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16T105NV02864603', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T105NV02864603', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T105NV02864603', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T105NV02864603', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T105NV02864603', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T105NV02864603', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T105NV02864603', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16T105NV02864603', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T105NV02864603', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T105NV02864603', N'DV716')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T105NV02864603', N'DV755')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T105NV02864606', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T105NV02864606', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T105NV02864606', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T105NV02864606', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T105NV02864606', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16T105NV02864606', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T105NV02864606', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T105NV02864606', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16T105NV02864606', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16T105NV02864614', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T105NV02864614', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16T105NV02864624', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T105NV02864624', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T105NV02864624', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T105NV02864624', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T105NV02864624', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T105NV02864624', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T105NV02864624', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16T105NV02864624', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T105NV02864624', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T105NV02864624', N'DV716')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T105NV02864624', N'DV755')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T105NV02864631', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T105NV02864631', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16T105NV02864631', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T105NV02864631', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T105NV02864631', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T105NV02864631', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T105NV02864631', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T105NV02864631', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T105NV02864631', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16T105NV02864631', N'DV716')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T105NV02864631', N'DV755')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T105NV02864631', N'DV785')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16T105NV02864644', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T105NV02864644', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T105NV02864644', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T105NV02864644', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T105NV02864644', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16T105NV02864722', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T105NV02864722', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T105NV02864722', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T105NV02864722', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T105NV02864722', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T105NV02864722', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16T105NV02864722', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T105NV02864722', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T105NV02864744', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T105NV02864744', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T105NV02864744', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T105NV02864744', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16T105NV02864744', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T105NV02864744', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T105NV02864744', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T105NV02864744', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T105NV02864744', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T105NV02864744', N'DV716')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T105NV02864744', N'DV755')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T105NV02864769', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T105NV02864769', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16T105NV02864769', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T105NV02864769', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T105NV02864769', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T105NV02864769', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T105NV02864769', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T105NV02864769', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T105NV02864769', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T105NV02864800', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T105NV02864800', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T105NV02864800', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T105NV02864800', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16T105NV02864800', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T105NV02864800', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T105NV02864800', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T105NV02864800', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T105NV02864800', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T105NV02864800', N'DV716')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T105NV02864800', N'DV755')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T105NV02864809', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T105NV02864809', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T105NV02864809', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T105NV02864809', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16T105NV02864809', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T105NV02864809', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T105NV02864809', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T105NV02864809', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T105NV02864809', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T105NV02864809', N'DV716')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T105NV02864809', N'DV755')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T105NV02864825', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T105NV02864825', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T105NV02864825', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T105NV02864825', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T105NV02864825', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16T105NV02864825', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T105NV02864825', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T105NV02864825', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16T105NV02864825', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T105NV02864829', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16T105NV02864829', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T105NV02864829', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T105NV02864829', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T105NV02864829', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T105NV02864829', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T105NV02864829', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16T105NV02864829', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T105NV02864829', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T105NV02864841', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T105NV02864841', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T105NV02864841', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T105NV02864841', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T105NV02864841', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16T105NV02864841', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T105NV02864841', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T105NV02864841', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16T105NV02864841', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T105NV02864853', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T105NV02864853', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T105NV02864930', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T105NV02864930', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16T105NV02864930', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T105NV02864930', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T105NV02864930', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T105NV02864930', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T105NV02864930', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T105NV02864930', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T105NV02864930', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16T105NV02864930', N'DV716')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T105NV02864930', N'DV755')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T105NV02864930', N'DV785')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T105NV02864935', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16T105NV02864935', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T105NV02864935', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T105NV02864935', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T105NV02864935', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T105NV02864935', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T105NV02864935', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16T105NV02864935', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T105NV02864935', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T105NV02864938', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T105NV02864938', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T105NV02864938', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T105NV02864938', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16T105NV02864938', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T105NV02864938', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T105NV02864938', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T105NV02864938', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T105NV02864938', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T105NV02864938', N'DV716')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T105NV02864938', N'DV755')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T105NV02864957', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T105NV02864957', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T105NV02864957', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T105NV02864957', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16T234NV02864179', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T234NV02864179', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T234NV02864179', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T234NV02864179', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T234NV02864179', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T234NV02864179', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T234NV02864179', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16T234NV02864179', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T234NV02864179', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T234NV02864179', N'DV716')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T234NV02864179', N'DV755')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T234NV02864186', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T234NV02864186', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T234NV02864186', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16T234NV02864259', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T234NV02864259', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T234NV02864266', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T234NV02864266', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T234NV02864266', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T234NV02864269', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16T234NV02864269', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T234NV02864269', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T234NV02864269', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T234NV02864269', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T234NV02864269', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T234NV02864269', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16T234NV02864269', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T234NV02864269', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T234NV02864316', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T234NV02864316', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16T234NV02864316', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T234NV02864316', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16T234NV02864342', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T234NV02864342', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T234NV02864342', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T234NV02864342', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T234NV02864342', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T234NV02864342', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16T234NV02864342', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T234NV02864342', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T234NV02864374', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T234NV02864374', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16T234NV02864374', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T234NV02864374', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T234NV02864374', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T234NV02864374', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T234NV02864374', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T234NV02864374', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T234NV02864374', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16T234NV02864374', N'DV716')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T234NV02864374', N'DV755')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T234NV02864374', N'DV785')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T234NV02864393', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T234NV02864393', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T234NV02864393', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16T234NV02864393', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T234NV02864497', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T234NV02864497', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T234NV02864497', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16T234NV02864546', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T234NV02864546', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T234NV02864546', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T234NV02864546', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T234NV02864546', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T234NV02864707', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T234NV02864707', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16T234NV02864707', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T234NV02864707', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16T234NV02864722', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T234NV02864722', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T234NV02864722', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T234NV02864722', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T234NV02864722', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T234NV02864722', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T234NV02864722', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16T234NV02864722', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T234NV02864722', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T234NV02864722', N'DV716')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T234NV02864722', N'DV755')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16T234NV02864777', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T234NV02864777', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T234NV02864793', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T234NV02864793', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16T234NV02864793', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T234NV02864793', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16T234NV02864919', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T234NV02864919', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T234NV02864919', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T234NV02864919', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T234NV02864919', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T234NV02864919', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16T234NV02864919', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T234NV02864919', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16T234NV02864952', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T234NV02864952', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16T234NV02864974', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T234NV02864974', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T234NV02864974', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16T234NV02864974', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T234NV02864974', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T234NV02864974', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T345NV02864129', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T345NV02864129', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16T345NV02864129', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T345NV02864129', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T345NV02864129', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T345NV02864129', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T345NV02864129', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T345NV02864129', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T345NV02864129', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16T345NV02864129', N'DV716')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T345NV02864129', N'DV755')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T345NV02864129', N'DV785')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16T345NV02864138', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T345NV02864138', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T345NV02864138', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T345NV02864138', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T345NV02864138', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T345NV02864138', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T345NV02864138', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16T345NV02864138', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T345NV02864138', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T345NV02864138', N'DV716')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T345NV02864138', N'DV755')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T345NV02864203', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T345NV02864203', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T345NV02864203', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T345NV02864203', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16T345NV02864203', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T345NV02864203', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T345NV02864203', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T345NV02864203', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T345NV02864203', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T345NV02864203', N'DV716')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T345NV02864203', N'DV755')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16T345NV02864222', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T345NV02864222', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T345NV02864222', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16T345NV02864222', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T345NV02864222', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T345NV02864222', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T345NV02864252', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T345NV02864252', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T345NV02864252', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T345NV02864252', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T345NV02864252', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T345NV02864252', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16T345NV02864252', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T345NV02864252', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16T345NV02864252', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T345NV02864252', N'DV716')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T345NV02864255', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T345NV02864255', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16T345NV02864260', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T345NV02864260', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T345NV02864260', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T345NV02864260', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T345NV02864260', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T345NV02864260', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16T345NV02864260', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T345NV02864260', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16T345NV02864367', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T345NV02864367', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T345NV02864367', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T345NV02864367', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T345NV02864367', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T345NV02864367', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T345NV02864367', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16T345NV02864367', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T345NV02864367', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T345NV02864367', N'DV716')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T345NV02864367', N'DV755')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16T345NV02864399', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T345NV02864399', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T345NV02864493', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T345NV02864493', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16T345NV02864495', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T345NV02864495', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T345NV02864495', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16T345NV02864495', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T345NV02864495', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T345NV02864495', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16T345NV02864589', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T345NV02864589', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T345NV02864628', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T345NV02864628', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T345NV02864628', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T345NV02864628', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T345NV02864628', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T345NV02864628', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16T345NV02864628', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T345NV02864628', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16T345NV02864628', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T345NV02864628', N'DV716')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T345NV02864668', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T345NV02864668', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T345NV02864668', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T345NV02864668', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T345NV02864668', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16T345NV02864668', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T345NV02864668', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T345NV02864668', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16T345NV02864668', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T345NV02864714', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T345NV02864714', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16T345NV02864714', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T345NV02864714', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T345NV02864886', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T345NV02864886', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T384NV02864164', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T384NV02864164', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16T384NV02864164', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T384NV02864164', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T384NV02864324', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T384NV02864324', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16T384NV02864324', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T384NV02864324', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T384NV02864367', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T384NV02864367', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16T384NV02864367', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T384NV02864367', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T384NV02864367', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T384NV02864367', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T384NV02864367', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T384NV02864367', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T384NV02864367', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T384NV02864454', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T384NV02864454', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T384NV02864454', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16T384NV02864454', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T384NV02864476', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T384NV02864476', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16T384NV02864476', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T384NV02864476', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T384NV02864499', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T384NV02864499', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16T384NV02864499', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T384NV02864499', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T384NV02864558', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T384NV02864558', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16T384NV02864558', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T384NV02864558', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T384NV02864584', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T384NV02864584', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16T384NV02864584', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T384NV02864584', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T384NV02864584', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T384NV02864584', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T384NV02864584', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T384NV02864584', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T384NV02864584', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16T384NV02864612', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T384NV02864612', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T384NV02864612', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16T384NV02864612', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T384NV02864612', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T384NV02864612', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T384NV02864657', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T384NV02864657', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T384NV02864657', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16T384NV02864784', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T384NV02864784', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T384NV02864784', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T384NV02864784', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T384NV02864784', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T384NV02864784', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T384NV02864784', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16T384NV02864784', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T384NV02864784', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T384NV02864784', N'DV716')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T384NV02864784', N'DV755')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T384NV02864846', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T384NV02864846', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16T384NV02864846', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T384NV02864846', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T384NV02864870', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T384NV02864870', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T384NV02864870', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T384NV02864870', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T384NV02864870', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T384NV02864870', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16T384NV02864870', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T384NV02864870', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16T384NV02864870', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T384NV02864870', N'DV716')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T384NV02864880', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T384NV02864880', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T384NV02864880', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T384NV02864880', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T384NV02864880', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16T384NV02864880', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T384NV02864880', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T384NV02864880', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16T384NV02864880', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16T384NV02864999', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T384NV02864999', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T384NV02864999', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16T384NV02864999', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T384NV02864999', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T384NV02864999', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T389NV02864124', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T389NV02864124', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T389NV02864124', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16T389NV02864326', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T389NV02864326', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T389NV02864326', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T389NV02864326', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T389NV02864326', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T389NV02864326', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16T389NV02864326', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T389NV02864326', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T389NV02864462', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T389NV02864462', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T389NV02864462', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T389NV02864462', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16T389NV02864462', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T389NV02864462', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T389NV02864462', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T389NV02864462', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T389NV02864462', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T389NV02864462', N'DV716')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T389NV02864462', N'DV755')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T389NV02864469', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T389NV02864469', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T389NV02864469', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T389NV02864482', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T389NV02864482', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T389NV02864482', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16T389NV02864482', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T389NV02864575', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16T389NV02864575', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T389NV02864575', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T389NV02864575', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T389NV02864575', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T389NV02864575', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T389NV02864575', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16T389NV02864575', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T389NV02864575', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T389NV02864664', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T389NV02864664', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T389NV02864664', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T389NV02864664', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16T389NV02864664', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T389NV02864664', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T389NV02864664', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T389NV02864664', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T389NV02864664', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T389NV02864664', N'DV716')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T389NV02864664', N'DV755')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16T389NV02864686', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T389NV02864686', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T389NV02864686', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T389NV02864686', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T389NV02864686', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16T389NV02864801', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T389NV02864801', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T389NV02864801', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T389NV02864801', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T389NV02864801', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T389NV02864801', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16T389NV02864801', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T389NV02864801', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T389NV02864888', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T389NV02864888', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16T389NV02864888', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T389NV02864888', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T389NV02864888', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T389NV02864888', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T389NV02864888', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T389NV02864888', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T389NV02864888', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16T389NV02864894', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T389NV02864894', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T389NV02864894', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T389NV02864894', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T389NV02864894', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T389NV02864901', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T389NV02864901', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T389NV02864901', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T389NV02864918', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T389NV02864918', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T389NV02864918', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T389NV02864918', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T389NV02864918', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T389NV02864918', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16T389NV02864918', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T389NV02864918', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16T389NV02864918', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T389NV02864918', N'DV716')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16T389NV02864922', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T389NV02864922', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T389NV02864922', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T389NV02864922', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T389NV02864922', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T389NV02864982', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T389NV02864982', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16T389NV02864982', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T389NV02864982', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T389NV02864982', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T389NV02864982', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T389NV02864982', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T389NV02864982', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T389NV02864982', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T405NV02864166', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T405NV02864166', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16T405NV02864166', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T405NV02864166', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T405NV02864166', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T405NV02864166', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T405NV02864166', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T405NV02864166', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T405NV02864166', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T405NV02864168', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16T405NV02864168', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T405NV02864168', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T405NV02864168', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T405NV02864168', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T405NV02864168', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T405NV02864168', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16T405NV02864168', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T405NV02864168', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T405NV02864187', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T405NV02864187', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16T405NV02864187', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T405NV02864187', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T405NV02864257', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T405NV02864257', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T405NV02864257', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T405NV02864257', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T405NV02864257', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T405NV02864257', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16T405NV02864257', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T405NV02864257', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16T405NV02864257', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T405NV02864257', N'DV716')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T405NV02864261', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T405NV02864261', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16T405NV02864261', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T405NV02864261', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16T405NV02864302', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T405NV02864302', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T405NV02864302', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T405NV02864302', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T405NV02864302', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T405NV02864302', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T405NV02864302', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16T405NV02864302', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T405NV02864302', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T405NV02864302', N'DV716')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T405NV02864302', N'DV755')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T405NV02864307', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T405NV02864307', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T405NV02864307', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16T405NV02864307', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T405NV02864328', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T405NV02864328', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16T405NV02864328', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T405NV02864328', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T405NV02864328', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T405NV02864328', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T405NV02864328', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T405NV02864328', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T405NV02864328', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16T405NV02864328', N'DV716')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T405NV02864328', N'DV755')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T405NV02864328', N'DV785')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T405NV02864334', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T405NV02864334', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T405NV02864334', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16T405NV02864334', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16T405NV02864343', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T405NV02864343', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T405NV02864343', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16T405NV02864343', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T405NV02864343', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T405NV02864343', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16T405NV02864395', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T405NV02864395', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T405NV02864395', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16T405NV02864395', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T405NV02864395', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T405NV02864395', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T405NV02864521', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T405NV02864521', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16T405NV02864521', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T405NV02864521', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T405NV02864604', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T405NV02864604', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16T405NV02864604', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T405NV02864604', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T405NV02864604', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T405NV02864604', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T405NV02864604', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T405NV02864604', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T405NV02864604', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T405NV02864628', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T405NV02864628', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16T405NV02864628', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T405NV02864628', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T405NV02864658', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T405NV02864658', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T405NV02864658', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16T405NV02864658', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16T405NV02864696', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T405NV02864696', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T405NV02864696', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T405NV02864696', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T405NV02864696', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T405NV02864696', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T405NV02864696', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16T405NV02864696', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T405NV02864696', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T405NV02864696', N'DV716')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T405NV02864696', N'DV755')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16T405NV02864859', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T405NV02864859', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T405NV02864859', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T405NV02864859', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T405NV02864859', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T405NV02864903', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16T405NV02864903', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T405NV02864903', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T405NV02864903', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T405NV02864903', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T405NV02864903', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T405NV02864903', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16T405NV02864903', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T405NV02864903', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T533NV02864205', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T533NV02864205', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T533NV02864205', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T533NV02864208', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16T533NV02864208', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T533NV02864208', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T533NV02864208', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T533NV02864208', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T533NV02864208', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T533NV02864208', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16T533NV02864208', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T533NV02864208', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16T533NV02864244', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T533NV02864244', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T533NV02864244', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T533NV02864244', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T533NV02864244', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T533NV02864244', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T533NV02864244', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16T533NV02864244', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T533NV02864244', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T533NV02864244', N'DV716')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T533NV02864244', N'DV755')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T533NV02864330', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T533NV02864330', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16T533NV02864330', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T533NV02864330', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T533NV02864339', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T533NV02864339', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T533NV02864339', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T533NV02864339', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T533NV02864339', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16T533NV02864339', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T533NV02864339', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T533NV02864339', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16T533NV02864339', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16T533NV02864381', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T533NV02864381', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T533NV02864381', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T533NV02864381', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T533NV02864381', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T533NV02864381', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T533NV02864381', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16T533NV02864381', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T533NV02864381', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T533NV02864381', N'DV716')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T533NV02864381', N'DV755')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T533NV02864495', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16T533NV02864495', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T533NV02864495', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T533NV02864495', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T533NV02864495', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T533NV02864495', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T533NV02864495', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16T533NV02864495', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T533NV02864495', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T533NV02864506', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T533NV02864506', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16T533NV02864506', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T533NV02864506', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16T533NV02864671', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T533NV02864671', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T533NV02864671', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16T533NV02864671', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T533NV02864671', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T533NV02864671', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T533NV02864681', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T533NV02864681', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T533NV02864681', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16T533NV02864681', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16T533NV02864717', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T533NV02864717', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T533NV02864717', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T533NV02864717', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T533NV02864717', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T533NV02864717', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T533NV02864717', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16T533NV02864717', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T533NV02864717', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T533NV02864717', N'DV716')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T533NV02864717', N'DV755')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T533NV02864719', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T533NV02864719', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T533NV02864719', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T533NV02864719', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T533NV02864719', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16T533NV02864719', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T533NV02864719', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T533NV02864719', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16T533NV02864719', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T533NV02864743', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T533NV02864743', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16T533NV02864743', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T533NV02864743', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T533NV02864743', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T533NV02864743', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T533NV02864743', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T533NV02864743', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T533NV02864743', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16T533NV02864743', N'DV716')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T533NV02864743', N'DV755')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T533NV02864743', N'DV785')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T533NV02864746', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T533NV02864746', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T533NV02864784', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T533NV02864784', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16T533NV02864784', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T533NV02864784', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T533NV02864784', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T533NV02864784', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T533NV02864784', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T533NV02864784', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T533NV02864784', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T533NV02864788', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T533NV02864788', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16T533NV02864788', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T533NV02864788', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16T533NV02864805', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T533NV02864805', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T533NV02864805', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16T533NV02864805', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T533NV02864805', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T533NV02864805', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T533NV02864880', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T533NV02864880', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T533NV02864880', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T533NV02864880', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T533NV02864880', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16T533NV02864880', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T533NV02864880', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T533NV02864880', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16T533NV02864880', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T533NV02864922', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T533NV02864922', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T533NV02864922', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16T533NV02864936', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T533NV02864936', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T533NV02864936', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16T533NV02864936', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T533NV02864936', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T533NV02864936', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T533NV02864947', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T533NV02864947', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16T533NV02864947', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T533NV02864947', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T533NV02864947', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T533NV02864947', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T533NV02864947', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T533NV02864947', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T533NV02864947', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16T533NV02864974', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T533NV02864974', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16T554NV02864299', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T554NV02864299', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T554NV02864299', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16T554NV02864299', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T554NV02864299', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T554NV02864299', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T554NV02864305', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T554NV02864305', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16T554NV02864305', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T554NV02864305', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T554NV02864377', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T554NV02864377', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16T554NV02864377', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T554NV02864377', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16T554NV02864403', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T554NV02864403', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T554NV02864403', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T554NV02864403', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T554NV02864403', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T554NV02864403', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16T554NV02864403', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T554NV02864403', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T554NV02864500', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T554NV02864500', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T554NV02864500', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16T554NV02864500', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T554NV02864558', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T554NV02864558', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16T554NV02864558', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T554NV02864558', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T554NV02864679', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T554NV02864679', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16T554NV02864679', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T554NV02864679', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T554NV02864682', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T554NV02864682', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16T554NV02864682', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T554NV02864682', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16T554NV02864703', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T554NV02864703', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T554NV02864736', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T554NV02864736', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T554NV02864736', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T554NV02864736', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16T554NV02864736', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T554NV02864736', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T554NV02864736', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T554NV02864736', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T554NV02864736', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T554NV02864736', N'DV716')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T554NV02864736', N'DV755')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T554NV02864743', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T554NV02864743', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16T554NV02864743', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T554NV02864743', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T554NV02864777', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T554NV02864777', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16T554NV02864777', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T554NV02864777', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T554NV02864777', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T554NV02864777', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T554NV02864777', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T554NV02864777', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T554NV02864777', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16T554NV02864777', N'DV716')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T554NV02864777', N'DV755')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T554NV02864777', N'DV785')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T554NV02864781', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T554NV02864781', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T554NV02864781', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T554NV02864781', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16T554NV02864781', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T554NV02864781', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T554NV02864781', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T554NV02864781', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T554NV02864781', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T554NV02864781', N'DV716')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T554NV02864781', N'DV755')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16T554NV02864787', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T554NV02864787', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T554NV02864787', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T554NV02864787', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T554NV02864787', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T554NV02864787', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16T554NV02864787', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T554NV02864787', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T554NV02864842', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T554NV02864842', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16T554NV02864842', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T554NV02864842', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T554NV02864956', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T554NV02864956', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16T554NV02864956', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T554NV02864956', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T554NV02864956', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T554NV02864956', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T554NV02864956', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T554NV02864956', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T554NV02864956', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16T554NV02864962', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T554NV02864962', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T554NV02864962', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T554NV02864962', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T554NV02864962', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T554NV02864962', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16T554NV02864962', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T554NV02864962', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16T599NV02864176', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T599NV02864176', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16T599NV02864271', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T599NV02864271', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T599NV02864271', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T599NV02864271', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T599NV02864271', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T599NV02864271', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T599NV02864271', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16T599NV02864271', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T599NV02864271', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T599NV02864271', N'DV716')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T599NV02864271', N'DV755')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16T599NV02864358', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T599NV02864358', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T599NV02864358', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T599NV02864358', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T599NV02864358', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16T599NV02864376', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T599NV02864376', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T599NV02864376', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T599NV02864376', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T599NV02864376', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T599NV02864376', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16T599NV02864376', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T599NV02864376', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T599NV02864424', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T599NV02864424', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T599NV02864424', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T599NV02864496', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T599NV02864496', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T599NV02864496', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T599NV02864496', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16T599NV02864496', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T599NV02864496', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T599NV02864496', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T599NV02864496', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T599NV02864496', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T599NV02864496', N'DV716')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T599NV02864496', N'DV755')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T599NV02864514', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T599NV02864514', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T599NV02864514', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T599NV02864514', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16T599NV02864514', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T599NV02864514', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T599NV02864514', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T599NV02864514', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T599NV02864514', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T599NV02864514', N'DV716')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T599NV02864514', N'DV755')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T599NV02864669', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T599NV02864669', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T599NV02864669', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T599NV02864677', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T599NV02864677', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16T599NV02864677', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T599NV02864677', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T599NV02864706', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T599NV02864706', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T599NV02864706', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T599NV02864706', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16T599NV02864706', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T599NV02864706', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T599NV02864706', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T599NV02864706', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T599NV02864706', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T599NV02864706', N'DV716')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T599NV02864706', N'DV755')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16T599NV02864784', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T599NV02864784', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T599NV02864784', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16T599NV02864784', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T599NV02864784', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T599NV02864784', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T599NV02864789', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T599NV02864789', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16T599NV02864789', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T599NV02864789', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T599NV02864796', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T599NV02864796', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T599NV02864796', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16T599NV02864796', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T716NV02864171', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T716NV02864171', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T716NV02864171', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T716NV02864171', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T716NV02864171', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16T716NV02864171', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T716NV02864171', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T716NV02864171', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16T716NV02864171', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T716NV02864180', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T716NV02864180', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16T716NV02864180', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T716NV02864180', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T716NV02864180', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T716NV02864180', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T716NV02864180', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T716NV02864180', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T716NV02864180', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T716NV02864264', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T716NV02864264', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16T716NV02864284', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T716NV02864284', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T716NV02864284', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16T716NV02864284', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T716NV02864284', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T716NV02864284', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16T716NV02864397', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T716NV02864397', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16T716NV02864486', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T716NV02864486', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T716NV02864486', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T716NV02864486', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T716NV02864486', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T716NV02864486', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T716NV02864486', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16T716NV02864486', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T716NV02864486', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T716NV02864486', N'DV716')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T716NV02864486', N'DV755')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T716NV02864525', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T716NV02864525', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T716NV02864525', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T716NV02864525', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T716NV02864525', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T716NV02864525', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16T716NV02864525', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T716NV02864525', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16T716NV02864525', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T716NV02864525', N'DV716')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T716NV02864537', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T716NV02864537', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T716NV02864537', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T716NV02864537', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T716NV02864537', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T716NV02864537', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16T716NV02864537', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T716NV02864537', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16T716NV02864537', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T716NV02864537', N'DV716')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T716NV02864612', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T716NV02864612', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T716NV02864646', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T716NV02864646', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T716NV02864646', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T716NV02864646', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16T716NV02864646', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T716NV02864646', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T716NV02864646', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T716NV02864646', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T716NV02864646', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T716NV02864646', N'DV716')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T716NV02864646', N'DV755')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16T716NV02864788', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T716NV02864788', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T716NV02864837', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T716NV02864837', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T716NV02864837', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16T716NV02864837', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T716NV02864871', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T716NV02864871', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16T716NV02864871', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T716NV02864871', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T716NV02864871', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T716NV02864871', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T716NV02864871', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T716NV02864871', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T716NV02864871', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16T716NV02864871', N'DV716')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T716NV02864871', N'DV755')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T716NV02864871', N'DV785')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T716NV02864920', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T716NV02864920', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16T716NV02864920', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T716NV02864920', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T716NV02864920', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T716NV02864920', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T716NV02864920', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T716NV02864920', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T716NV02864920', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16T716NV02864920', N'DV716')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T716NV02864920', N'DV755')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T716NV02864920', N'DV785')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16T716NV02864926', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T716NV02864926', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T716NV02864926', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T716NV02864926', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T716NV02864926', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T716NV02864926', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T716NV02864926', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16T716NV02864926', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T716NV02864926', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T716NV02864926', N'DV716')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T716NV02864926', N'DV755')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T716NV02864952', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T716NV02864952', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T716NV02864952', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T716NV02864952', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T716NV02864952', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16T716NV02864952', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T716NV02864952', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T716NV02864952', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16T716NV02864952', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T716NV02864965', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T716NV02864965', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T716NV02864965', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T716NV02864965', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16T716NV02864965', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T716NV02864965', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T716NV02864965', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T716NV02864965', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T716NV02864965', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T716NV02864965', N'DV716')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T716NV02864965', N'DV755')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16T717NV02864188', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T717NV02864188', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T717NV02864188', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T717NV02864188', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T717NV02864188', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T717NV02864188', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T717NV02864188', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16T717NV02864188', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T717NV02864188', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T717NV02864188', N'DV716')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T717NV02864188', N'DV755')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T717NV02864255', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T717NV02864255', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16T717NV02864255', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T717NV02864255', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T717NV02864326', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16T717NV02864326', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T717NV02864326', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T717NV02864326', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T717NV02864326', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T717NV02864326', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T717NV02864326', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16T717NV02864326', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T717NV02864326', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T717NV02864333', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T717NV02864333', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T717NV02864333', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T717NV02864333', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16T717NV02864333', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T717NV02864333', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T717NV02864333', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T717NV02864333', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T717NV02864333', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T717NV02864333', N'DV716')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T717NV02864333', N'DV755')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T717NV02864390', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T717NV02864390', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T717NV02864390', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T717NV02864390', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T717NV02864390', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16T717NV02864390', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T717NV02864390', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T717NV02864390', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16T717NV02864390', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T717NV02864400', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T717NV02864400', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16T717NV02864400', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T717NV02864400', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T717NV02864400', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T717NV02864400', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T717NV02864400', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T717NV02864400', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T717NV02864400', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16T717NV02864430', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T717NV02864430', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T717NV02864430', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T717NV02864430', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T717NV02864430', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T717NV02864443', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T717NV02864443', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16T717NV02864443', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T717NV02864443', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T717NV02864443', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T717NV02864443', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T717NV02864443', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T717NV02864443', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T717NV02864443', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T717NV02864480', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T717NV02864480', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16T717NV02864480', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T717NV02864480', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T717NV02864480', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T717NV02864480', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T717NV02864480', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T717NV02864480', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T717NV02864480', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T717NV02864665', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T717NV02864665', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16T717NV02864665', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T717NV02864665', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T717NV02864713', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T717NV02864713', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T717NV02864713', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16T717NV02864713', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T717NV02864734', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T717NV02864734', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T717NV02864734', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16T717NV02864743', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T717NV02864743', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T717NV02864743', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T717NV02864743', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T717NV02864743', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T717NV02864851', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16T717NV02864851', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T717NV02864851', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T717NV02864851', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T717NV02864851', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T717NV02864851', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T717NV02864851', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16T717NV02864851', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T717NV02864851', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16T717NV02864995', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T717NV02864995', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T717NV02864995', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16T717NV02864995', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T717NV02864995', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T717NV02864995', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16T778NV02864136', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T778NV02864136', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T778NV02864136', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16T778NV02864136', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T778NV02864136', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T778NV02864136', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16T778NV02864144', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T778NV02864144', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T778NV02864144', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T778NV02864144', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T778NV02864144', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T778NV02864144', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T778NV02864144', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16T778NV02864144', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T778NV02864144', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T778NV02864144', N'DV716')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T778NV02864144', N'DV755')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16T778NV02864146', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T778NV02864146', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T778NV02864146', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T778NV02864146', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T778NV02864146', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16T778NV02864217', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T778NV02864217', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T778NV02864217', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16T778NV02864217', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T778NV02864217', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T778NV02864217', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16T778NV02864242', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T778NV02864242', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T778NV02864242', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T778NV02864242', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T778NV02864242', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T778NV02864242', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16T778NV02864242', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T778NV02864242', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T778NV02864279', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T778NV02864279', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16T778NV02864279', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T778NV02864279', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T778NV02864279', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T778NV02864279', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T778NV02864279', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T778NV02864279', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T778NV02864279', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16T778NV02864307', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T778NV02864307', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16T778NV02864434', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T778NV02864434', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T778NV02864434', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16T778NV02864434', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T778NV02864434', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T778NV02864434', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T778NV02864595', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16T778NV02864595', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T778NV02864595', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T778NV02864595', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T778NV02864595', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T778NV02864595', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T778NV02864595', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16T778NV02864595', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T778NV02864595', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T778NV02864651', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T778NV02864651', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T778NV02864697', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T778NV02864697', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T778NV02864697', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T778NV02864781', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T778NV02864781', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T778NV02864781', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16T778NV02864781', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T778NV02864945', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T778NV02864945', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T778NV02864945', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16T778NV02864945', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T778NV02864999', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T778NV02864999', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T778NV02864999', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T778NV02864999', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16T778NV02864999', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T778NV02864999', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T778NV02864999', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T778NV02864999', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T778NV02864999', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T778NV02864999', N'DV716')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T778NV02864999', N'DV755')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16T811NV02864154', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T811NV02864154', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16T811NV02864289', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T811NV02864289', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T811NV02864289', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T811NV02864289', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T811NV02864289', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T811NV02864289', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16T811NV02864289', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T811NV02864289', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T811NV02864304', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T811NV02864304', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T811NV02864304', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T811NV02864304', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T811NV02864304', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T811NV02864304', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16T811NV02864304', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T811NV02864304', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16T811NV02864304', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T811NV02864304', N'DV716')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T811NV02864392', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16T811NV02864392', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T811NV02864392', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T811NV02864392', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T811NV02864392', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T811NV02864392', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T811NV02864392', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16T811NV02864392', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T811NV02864392', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16T811NV02864409', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T811NV02864409', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T811NV02864409', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T811NV02864409', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T811NV02864409', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16T811NV02864426', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T811NV02864426', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T811NV02864426', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16T811NV02864426', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T811NV02864426', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T811NV02864426', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16T811NV02864470', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T811NV02864470', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T811NV02864581', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T811NV02864581', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T811NV02864581', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T811NV02864581', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T811NV02864581', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16T811NV02864581', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T811NV02864581', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T811NV02864581', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16T811NV02864581', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16T811NV02864589', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T811NV02864589', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T811NV02864589', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T811NV02864589', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T811NV02864589', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T811NV02864589', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16T811NV02864589', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T811NV02864589', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T811NV02864685', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T811NV02864685', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T811NV02864690', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T811NV02864690', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T811NV02864690', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16T811NV02864690', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16T811NV02864711', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T811NV02864711', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T811NV02864711', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T811NV02864711', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T811NV02864711', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T811NV02864803', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T811NV02864803', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T811NV02864803', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T811NV02864803', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16T811NV02864803', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T811NV02864803', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T811NV02864803', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T811NV02864803', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T811NV02864803', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T811NV02864803', N'DV716')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T811NV02864803', N'DV755')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T811NV02864823', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T811NV02864823', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16T811NV02864823', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T811NV02864823', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T811NV02864823', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T811NV02864823', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T811NV02864823', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T811NV02864823', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T811NV02864823', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16T811NV02864823', N'DV716')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T811NV02864823', N'DV755')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T811NV02864823', N'DV785')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16T811NV02864939', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T811NV02864939', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T811NV02864939', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T811NV02864939', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T811NV02864939', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T811NV02864939', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16T811NV02864939', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T811NV02864939', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16T897NV02864110', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T897NV02864110', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T897NV02864110', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16T897NV02864110', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T897NV02864110', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T897NV02864110', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T897NV02864235', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T897NV02864235', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16T897NV02864235', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T897NV02864235', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T897NV02864297', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T897NV02864297', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T897NV02864297', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16T897NV02864453', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T897NV02864453', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T897NV02864453', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16T897NV02864453', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T897NV02864453', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T897NV02864453', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T897NV02864459', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T897NV02864459', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16T897NV02864459', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T897NV02864459', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T897NV02864472', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16T897NV02864472', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16T897NV02864472', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T897NV02864472', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T897NV02864472', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T897NV02864472', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T897NV02864472', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T897NV02864510', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T897NV02864510', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T897NV02864510', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T897NV02864510', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T897NV02864510', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16T897NV02864510', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T897NV02864510', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T897NV02864510', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16T897NV02864510', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T897NV02864654', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T897NV02864654', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T897NV02864654', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16T897NV02864654', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T897NV02864655', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T897NV02864655', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16T897NV02864655', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T897NV02864655', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T897NV02864655', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T897NV02864655', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T897NV02864655', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T897NV02864655', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T897NV02864655', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T897NV02864762', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T897NV02864762', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T897NV02864762', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16T897NV02864762', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T897NV02864812', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T897NV02864812', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T897NV02864812', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T897NV02864820', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T897NV02864820', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T949NV02864101', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T949NV02864101', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T949NV02864101', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16T949NV02864101', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T949NV02864204', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T949NV02864204', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16T949NV02864204', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T949NV02864204', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T949NV02864248', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T949NV02864248', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16T949NV02864248', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T949NV02864248', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16T949NV02864313', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T949NV02864313', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T949NV02864313', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T949NV02864313', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T949NV02864313', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T949NV02864313', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T949NV02864313', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16T949NV02864313', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T949NV02864313', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T949NV02864313', N'DV716')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T949NV02864313', N'DV755')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T949NV02864315', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T949NV02864315', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16T949NV02864315', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T949NV02864315', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T949NV02864315', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T949NV02864315', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T949NV02864315', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T949NV02864315', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T949NV02864315', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16T949NV02864315', N'DV716')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T949NV02864315', N'DV755')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T949NV02864315', N'DV785')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T949NV02864369', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T949NV02864369', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16T949NV02864379', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T949NV02864379', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T949NV02864379', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T949NV02864379', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T949NV02864379', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T949NV02864379', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16T949NV02864379', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T949NV02864379', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T949NV02864437', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T949NV02864437', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T949NV02864437', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T949NV02864437', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T949NV02864437', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T949NV02864437', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16T949NV02864437', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T949NV02864437', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16T949NV02864437', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T949NV02864437', N'DV716')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T949NV02864466', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T949NV02864466', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T949NV02864466', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T949NV02864466', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T949NV02864466', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T949NV02864466', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16T949NV02864466', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T949NV02864466', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16T949NV02864466', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T949NV02864466', N'DV716')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T949NV02864470', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T949NV02864470', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T949NV02864470', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T949NV02864470', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T949NV02864470', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T949NV02864470', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16T949NV02864470', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T949NV02864470', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16T949NV02864470', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T949NV02864470', N'DV716')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T949NV02864479', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T949NV02864479', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T949NV02864479', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T949NV02864484', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T949NV02864484', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T949NV02864484', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T949NV02864484', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T949NV02864484', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16T949NV02864484', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T949NV02864484', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T949NV02864484', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16T949NV02864484', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T949NV02864627', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T949NV02864627', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T949NV02864627', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16T949NV02864627', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T949NV02864634', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T949NV02864634', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T949NV02864724', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T949NV02864724', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16T949NV02864724', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T949NV02864724', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T949NV02864776', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T949NV02864776', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T949NV02864776', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T949NV02864776', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16T949NV02864776', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T949NV02864776', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T949NV02864776', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T949NV02864776', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T949NV02864776', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T949NV02864776', N'DV716')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T949NV02864776', N'DV755')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T949NV02864858', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16T949NV02864858', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T949NV02864858', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16T949NV02864858', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T949NV02864858', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T949NV02864858', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T949NV02864858', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16T949NV02864858', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T949NV02864858', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T949NV02864932', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16T949NV02864932', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16T949NV02864932', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16T949NV02864932', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T949NV02864932', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T949NV02864932', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16T949NV02864932', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16T949NV02864932', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16T949NV02864932', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16T949NV02864932', N'DV716')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T949NV02864932', N'DV755')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16T949NV02864932', N'DV785')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16V170NV02864277', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V170NV02864277', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V170NV02864277', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V170NV02864277', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V170NV02864277', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V170NV02864277', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16V170NV02864277', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V170NV02864277', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V170NV02864368', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V170NV02864368', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V170NV02864368', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V170NV02864368', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V170NV02864368', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V170NV02864368', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16V170NV02864368', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V170NV02864368', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16V170NV02864368', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V170NV02864368', N'DV716')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V170NV02864439', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V170NV02864439', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V170NV02864439', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V170NV02864439', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16V170NV02864439', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V170NV02864439', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V170NV02864439', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16V170NV02864439', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V170NV02864439', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V170NV02864439', N'DV716')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V170NV02864439', N'DV755')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16V170NV02864540', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V170NV02864540', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V170NV02864615', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16V170NV02864615', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16V170NV02864615', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V170NV02864615', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V170NV02864615', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V170NV02864615', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V170NV02864615', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V170NV02864615', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V170NV02864615', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16V170NV02864615', N'DV716')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V170NV02864615', N'DV755')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V170NV02864615', N'DV785')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16V170NV02864718', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V170NV02864718', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V170NV02864718', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V170NV02864718', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V170NV02864718', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V170NV02864718', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16V170NV02864718', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V170NV02864718', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16V170NV02864788', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V170NV02864788', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V170NV02864788', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V170NV02864788', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V170NV02864788', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V170NV02864860', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V170NV02864860', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V170NV02864860', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V170NV02864860', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16V170NV02864860', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V170NV02864860', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V170NV02864860', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16V170NV02864860', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V170NV02864860', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V170NV02864860', N'DV716')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V170NV02864860', N'DV755')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V170NV02864869', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V170NV02864869', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V170NV02864869', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V170NV02864869', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V170NV02864869', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16V170NV02864869', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16V170NV02864869', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V170NV02864869', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16V170NV02864869', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V170NV02864932', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V170NV02864932', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V170NV02864932', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V170NV02864932', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V170NV02864932', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16V170NV02864932', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16V170NV02864932', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V170NV02864932', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16V170NV02864932', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V170NV02864941', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V170NV02864941', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16V170NV02864941', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16V170NV02864941', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V170NV02864941', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V170NV02864941', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16V170NV02864941', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V170NV02864941', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V170NV02864941', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16V170NV02864960', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V170NV02864960', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V170NV02864960', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V170NV02864960', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V170NV02864960', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V170NV02864961', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16V170NV02864961', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16V170NV02864961', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V170NV02864961', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V170NV02864961', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V170NV02864961', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V170NV02864961', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V170NV02864961', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V170NV02864961', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16V170NV02864961', N'DV716')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V170NV02864961', N'DV755')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V170NV02864961', N'DV785')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V174NV02864149', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V174NV02864149', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V174NV02864149', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V174NV02864149', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V174NV02864149', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V174NV02864149', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16V174NV02864149', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V174NV02864149', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16V174NV02864149', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V174NV02864149', N'DV716')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16V174NV02864271', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V174NV02864271', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V174NV02864271', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V174NV02864271', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V174NV02864271', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V174NV02864271', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16V174NV02864271', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V174NV02864271', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V174NV02864390', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V174NV02864390', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V174NV02864415', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16V174NV02864415', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V174NV02864415', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16V174NV02864415', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V174NV02864446', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V174NV02864446', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16V174NV02864446', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V174NV02864446', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V174NV02864530', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V174NV02864530', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16V174NV02864530', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16V174NV02864530', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V174NV02864530', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V174NV02864530', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16V174NV02864530', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V174NV02864530', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V174NV02864530', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16V174NV02864544', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V174NV02864544', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V174NV02864544', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V174NV02864544', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V174NV02864544', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V174NV02864551', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16V174NV02864551', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16V174NV02864551', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V174NV02864551', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V174NV02864551', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V174NV02864551', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V174NV02864551', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V174NV02864551', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V174NV02864551', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16V174NV02864551', N'DV716')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V174NV02864551', N'DV755')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V174NV02864551', N'DV785')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16V174NV02864564', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V174NV02864564', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V174NV02864564', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V174NV02864564', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V174NV02864564', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V174NV02864895', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V174NV02864895', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V174NV02864895', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16V174NV02864950', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V174NV02864950', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V174NV02864950', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16V174NV02864950', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V174NV02864950', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V174NV02864950', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V231NV02864169', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V231NV02864169', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V231NV02864169', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V231NV02864384', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V231NV02864384', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V231NV02864479', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V231NV02864479', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16V231NV02864479', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16V231NV02864479', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V231NV02864479', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V231NV02864479', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16V231NV02864479', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V231NV02864479', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V231NV02864479', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V231NV02864571', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V231NV02864571', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V231NV02864571', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V231NV02864571', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V231NV02864571', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V231NV02864571', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16V231NV02864571', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V231NV02864571', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16V231NV02864571', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V231NV02864571', N'DV716')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V231NV02864602', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16V231NV02864602', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V231NV02864602', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V231NV02864602', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V231NV02864602', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V231NV02864602', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V231NV02864602', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16V231NV02864602', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V231NV02864602', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V231NV02864624', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16V231NV02864624', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V231NV02864624', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16V231NV02864624', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V231NV02864662', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V231NV02864662', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V231NV02864662', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V231NV02864662', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16V231NV02864662', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V231NV02864662', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V231NV02864662', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16V231NV02864662', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V231NV02864662', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V231NV02864662', N'DV716')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V231NV02864662', N'DV755')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V231NV02864730', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V231NV02864730', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16V231NV02864730', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V231NV02864730', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16V231NV02864771', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V231NV02864771', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V231NV02864797', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V231NV02864797', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V231NV02864797', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V231NV02864797', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V231NV02864797', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16V231NV02864797', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16V231NV02864797', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V231NV02864797', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16V231NV02864797', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16V231NV02864932', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V231NV02864932', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V231NV02864932', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V231NV02864932', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V231NV02864932', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V231NV02864949', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V231NV02864949', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16V231NV02864949', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16V231NV02864949', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V231NV02864949', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V231NV02864949', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16V231NV02864949', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V231NV02864949', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V231NV02864949', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V231NV02864988', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V231NV02864988', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V231NV02864988', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V231NV02864988', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V231NV02864988', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16V231NV02864988', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16V231NV02864988', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V231NV02864988', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16V231NV02864988', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V344NV02864164', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16V344NV02864164', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V344NV02864164', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V344NV02864164', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V344NV02864164', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V344NV02864164', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V344NV02864164', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16V344NV02864164', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V344NV02864164', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V344NV02864184', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16V344NV02864184', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16V344NV02864184', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V344NV02864184', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V344NV02864184', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V344NV02864184', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V344NV02864184', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V344NV02864184', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V344NV02864184', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16V344NV02864184', N'DV716')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V344NV02864184', N'DV755')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V344NV02864184', N'DV785')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V344NV02864218', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16V344NV02864218', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V344NV02864218', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16V344NV02864218', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V344NV02864389', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V344NV02864389', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16V344NV02864389', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V344NV02864389', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V344NV02864436', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V344NV02864436', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16V344NV02864436', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V344NV02864436', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V344NV02864465', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V344NV02864465', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V344NV02864465', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V344NV02864465', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V344NV02864465', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V344NV02864465', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16V344NV02864465', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V344NV02864465', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16V344NV02864465', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V344NV02864465', N'DV716')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V344NV02864470', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V344NV02864470', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V344NV02864470', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V344NV02864470', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16V344NV02864470', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V344NV02864470', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V344NV02864470', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16V344NV02864470', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V344NV02864470', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V344NV02864470', N'DV716')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V344NV02864470', N'DV755')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16V344NV02864910', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V344NV02864910', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V344NV02864910', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16V344NV02864910', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V344NV02864910', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V344NV02864910', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V344NV02864910', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16V344NV02864910', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V344NV02864910', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V344NV02864910', N'DV716')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V344NV02864910', N'DV755')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16V344NV02864919', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V344NV02864919', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V344NV02864919', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V344NV02864919', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V344NV02864919', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16V344NV02864986', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V344NV02864986', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V344NV02864986', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V344NV02864986', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V344NV02864986', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V344NV02864986', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16V344NV02864986', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V344NV02864986', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16V344NV02864999', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V344NV02864999', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V344NV02864999', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V344NV02864999', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V344NV02864999', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V344NV02864999', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16V344NV02864999', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V344NV02864999', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V347NV02864383', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16V347NV02864383', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V347NV02864383', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16V347NV02864383', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V347NV02864519', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16V347NV02864519', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16V347NV02864519', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V347NV02864519', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V347NV02864799', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V347NV02864799', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V347NV02864835', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V347NV02864835', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V347NV02864835', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V347NV02864835', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V347NV02864835', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V347NV02864835', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16V347NV02864835', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V347NV02864835', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16V347NV02864835', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V347NV02864835', N'DV716')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V347NV02864892', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16V347NV02864892', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V347NV02864892', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V347NV02864892', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V347NV02864892', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V347NV02864892', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V347NV02864892', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16V347NV02864892', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V347NV02864892', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V347NV02864902', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V347NV02864902', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V347NV02864902', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V347NV02864954', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V347NV02864954', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16V347NV02864954', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V347NV02864954', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16V351NV02864167', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V351NV02864167', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V351NV02864167', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16V351NV02864167', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V351NV02864167', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V351NV02864167', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16V351NV02864237', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V351NV02864237', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V351NV02864237', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V351NV02864237', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V351NV02864237', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V351NV02864314', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V351NV02864314', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V351NV02864314', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V351NV02864314', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16V351NV02864314', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V351NV02864314', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V351NV02864314', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16V351NV02864314', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V351NV02864314', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V351NV02864314', N'DV716')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V351NV02864314', N'DV755')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V351NV02864340', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V351NV02864340', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V351NV02864340', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16V351NV02864464', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V351NV02864464', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V351NV02864464', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16V351NV02864464', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V351NV02864464', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V351NV02864464', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V351NV02864516', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V351NV02864516', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16V351NV02864516', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16V351NV02864516', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V351NV02864516', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V351NV02864516', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16V351NV02864516', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V351NV02864516', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V351NV02864516', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V351NV02864520', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V351NV02864520', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16V351NV02864520', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V351NV02864520', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V351NV02864575', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V351NV02864575', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16V351NV02864575', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16V351NV02864575', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V351NV02864575', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V351NV02864575', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16V351NV02864575', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V351NV02864575', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V351NV02864575', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16V351NV02864670', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V351NV02864670', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V351NV02864670', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16V351NV02864670', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V351NV02864670', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V351NV02864670', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V351NV02864670', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16V351NV02864670', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V351NV02864670', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V351NV02864670', N'DV716')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V351NV02864670', N'DV755')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V351NV02864726', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16V351NV02864726', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V351NV02864726', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16V351NV02864726', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16V351NV02864767', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V351NV02864767', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V351NV02864767', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V351NV02864767', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V351NV02864767', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V351NV02864767', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16V351NV02864767', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V351NV02864767', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V351NV02864770', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16V351NV02864770', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16V351NV02864770', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V351NV02864770', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V351NV02864770', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V351NV02864770', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V351NV02864770', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V351NV02864770', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V351NV02864770', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16V351NV02864770', N'DV716')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V351NV02864770', N'DV755')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V351NV02864770', N'DV785')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V351NV02864791', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16V351NV02864791', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16V351NV02864791', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V351NV02864791', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V351NV02864832', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V351NV02864832', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V351NV02864832', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V351NV02864832', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V351NV02864832', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16V351NV02864832', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16V351NV02864832', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V351NV02864832', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16V351NV02864832', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V351NV02864880', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16V351NV02864880', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V351NV02864880', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16V351NV02864880', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V351NV02864922', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V351NV02864922', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V351NV02864932', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V351NV02864932', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V351NV02864932', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V351NV02864995', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16V351NV02864995', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16V351NV02864995', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V351NV02864995', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V351NV02864995', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V351NV02864995', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V351NV02864995', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16V392NV02864119', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V392NV02864119', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V392NV02864125', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16V392NV02864125', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16V392NV02864125', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V392NV02864125', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V392NV02864125', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V392NV02864125', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V392NV02864125', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V392NV02864125', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V392NV02864125', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16V392NV02864125', N'DV716')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V392NV02864125', N'DV755')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V392NV02864125', N'DV785')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V392NV02864172', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V392NV02864172', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V392NV02864222', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16V392NV02864222', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16V392NV02864222', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V392NV02864222', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V392NV02864327', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V392NV02864327', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V392NV02864327', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V392NV02864327', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V392NV02864327', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V392NV02864327', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16V392NV02864327', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V392NV02864327', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16V392NV02864327', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V392NV02864327', N'DV716')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V392NV02864351', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V392NV02864351', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V392NV02864351', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V392NV02864351', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16V392NV02864351', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V392NV02864351', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V392NV02864351', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16V392NV02864351', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V392NV02864351', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V392NV02864351', N'DV716')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V392NV02864351', N'DV755')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V392NV02864521', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V392NV02864521', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V392NV02864521', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V392NV02864521', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V392NV02864521', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V392NV02864521', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16V392NV02864521', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V392NV02864521', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16V392NV02864521', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V392NV02864521', N'DV716')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V392NV02864563', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16V392NV02864563', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16V392NV02864563', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V392NV02864563', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V392NV02864563', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V392NV02864563', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V392NV02864563', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V392NV02864563', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V392NV02864563', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16V392NV02864563', N'DV716')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V392NV02864563', N'DV755')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V392NV02864563', N'DV785')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V392NV02864949', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16V392NV02864949', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16V392NV02864949', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V392NV02864949', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V392NV02864949', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V392NV02864949', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V392NV02864949', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V392NV02864949', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V392NV02864949', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16V392NV02864949', N'DV716')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V392NV02864949', N'DV755')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V392NV02864949', N'DV785')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V392NV02864967', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V392NV02864967', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16V392NV02864967', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16V392NV02864967', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V392NV02864967', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V392NV02864967', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16V392NV02864967', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V392NV02864967', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V392NV02864967', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16V432NV02864138', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V432NV02864138', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V432NV02864138', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V432NV02864138', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V432NV02864138', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V432NV02864138', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16V432NV02864138', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V432NV02864138', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V432NV02864266', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V432NV02864266', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V432NV02864266', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V432NV02864266', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V432NV02864266', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V432NV02864266', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16V432NV02864266', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V432NV02864266', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16V432NV02864266', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V432NV02864266', N'DV716')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16V432NV02864270', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V432NV02864270', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V432NV02864270', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16V432NV02864270', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V432NV02864270', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V432NV02864270', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V432NV02864270', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16V432NV02864270', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V432NV02864270', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V432NV02864270', N'DV716')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V432NV02864270', N'DV755')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V432NV02864276', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V432NV02864276', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16V432NV02864276', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16V432NV02864276', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V432NV02864276', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V432NV02864276', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16V432NV02864276', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V432NV02864276', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V432NV02864276', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16V432NV02864298', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V432NV02864298', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V432NV02864298', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16V432NV02864298', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V432NV02864298', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V432NV02864298', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V432NV02864298', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16V432NV02864298', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V432NV02864298', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V432NV02864298', N'DV716')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V432NV02864298', N'DV755')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V432NV02864380', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V432NV02864380', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V432NV02864380', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V432NV02864380', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V432NV02864380', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V432NV02864380', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16V432NV02864380', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V432NV02864380', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16V432NV02864380', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V432NV02864380', N'DV716')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16V432NV02864411', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V432NV02864411', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V432NV02864458', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V432NV02864458', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V432NV02864458', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V432NV02864463', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V432NV02864463', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V432NV02864463', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V432NV02864463', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V432NV02864463', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16V432NV02864463', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16V432NV02864463', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V432NV02864463', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16V432NV02864463', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16V432NV02864517', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V432NV02864517', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V432NV02864517', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16V432NV02864517', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V432NV02864517', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V432NV02864517', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16V432NV02864536', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V432NV02864536', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V432NV02864536', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V432NV02864536', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V432NV02864536', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V432NV02864538', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16V432NV02864538', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V432NV02864538', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V432NV02864538', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V432NV02864538', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V432NV02864538', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V432NV02864538', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16V432NV02864538', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V432NV02864538', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16V432NV02864549', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V432NV02864549', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V432NV02864549', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16V432NV02864549', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V432NV02864549', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V432NV02864549', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V432NV02864562', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V432NV02864562', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V432NV02864562', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V432NV02864562', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V432NV02864562', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16V432NV02864562', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16V432NV02864562', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V432NV02864562', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16V432NV02864562', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V432NV02864573', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V432NV02864573', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V432NV02864573', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V432NV02864573', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V432NV02864573', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V432NV02864573', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16V432NV02864573', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V432NV02864573', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16V432NV02864573', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V432NV02864573', N'DV716')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V432NV02864727', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16V432NV02864727', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16V432NV02864727', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V432NV02864727', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V432NV02864727', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V432NV02864727', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V432NV02864727', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V432NV02864727', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V432NV02864727', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16V432NV02864727', N'DV716')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V432NV02864727', N'DV755')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V432NV02864727', N'DV785')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V432NV02864771', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V432NV02864771', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V432NV02864771', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V432NV02864771', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V432NV02864771', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V432NV02864771', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16V432NV02864771', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V432NV02864771', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16V432NV02864771', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V432NV02864771', N'DV716')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16V432NV02864849', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V432NV02864849', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V432NV02864860', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V432NV02864860', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V432NV02864860', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V432NV02864860', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V432NV02864860', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16V432NV02864860', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16V432NV02864860', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V432NV02864860', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16V432NV02864860', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V432NV02864871', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V432NV02864871', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V432NV02864871', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V432NV02864871', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V432NV02864871', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16V432NV02864871', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16V432NV02864871', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V432NV02864871', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16V432NV02864871', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16V432NV02864977', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V432NV02864977', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V432NV02864977', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V432NV02864977', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V432NV02864977', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V432NV02864977', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16V432NV02864977', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V432NV02864977', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V531NV02864102', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V531NV02864102', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16V531NV02864102', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V531NV02864102', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V531NV02864146', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V531NV02864146', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V531NV02864265', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V531NV02864265', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V531NV02864265', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V531NV02864324', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16V531NV02864324', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16V531NV02864324', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V531NV02864324', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V531NV02864324', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V531NV02864324', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V531NV02864324', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V531NV02864445', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16V531NV02864445', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16V531NV02864445', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V531NV02864445', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V531NV02864459', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16V531NV02864459', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V531NV02864459', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16V531NV02864459', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V531NV02864504', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16V531NV02864504', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V531NV02864504', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V531NV02864504', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V531NV02864504', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V531NV02864504', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V531NV02864504', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16V531NV02864504', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V531NV02864504', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16V531NV02864589', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V531NV02864589', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V531NV02864589', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16V531NV02864589', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V531NV02864589', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V531NV02864589', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V531NV02864692', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V531NV02864692', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16V531NV02864774', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V531NV02864774', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V531NV02864774', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V531NV02864774', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V531NV02864774', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16V531NV02864782', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V531NV02864782', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V531NV02864782', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16V531NV02864782', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V531NV02864782', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V531NV02864782', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V531NV02864782', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16V531NV02864782', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V531NV02864782', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V531NV02864782', N'DV716')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V531NV02864782', N'DV755')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16V531NV02864808', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V531NV02864808', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V531NV02864808', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V531NV02864808', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V531NV02864808', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16V531NV02864864', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V531NV02864864', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V531NV02864864', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V531NV02864864', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V531NV02864864', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V531NV02864864', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16V531NV02864864', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V531NV02864864', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16V531NV02864872', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V531NV02864872', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V531NV02864951', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V531NV02864951', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16V531NV02864951', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V531NV02864951', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V531NV02864962', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16V531NV02864962', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V531NV02864962', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V531NV02864962', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V531NV02864962', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V531NV02864962', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V531NV02864962', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16V531NV02864962', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V531NV02864962', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16V596NV02864157', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V596NV02864157', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V596NV02864157', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16V596NV02864157', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V596NV02864157', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V596NV02864157', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V596NV02864157', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16V596NV02864157', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V596NV02864157', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V596NV02864157', N'DV716')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V596NV02864157', N'DV755')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V596NV02864180', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V596NV02864180', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V596NV02864180', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V596NV02864180', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V596NV02864180', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16V596NV02864180', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16V596NV02864180', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V596NV02864180', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16V596NV02864180', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V596NV02864229', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V596NV02864229', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16V596NV02864229', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V596NV02864229', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V596NV02864271', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V596NV02864271', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V596NV02864271', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V596NV02864271', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16V596NV02864271', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V596NV02864271', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V596NV02864271', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16V596NV02864271', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V596NV02864271', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V596NV02864271', N'DV716')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V596NV02864271', N'DV755')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16V596NV02864360', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V596NV02864360', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V596NV02864368', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16V596NV02864368', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V596NV02864368', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16V596NV02864368', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V596NV02864455', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16V596NV02864455', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V596NV02864455', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16V596NV02864455', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16V596NV02864494', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V596NV02864494', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V596NV02864494', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V596NV02864494', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V596NV02864494', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16V596NV02864641', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V596NV02864641', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V596NV02864641', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V596NV02864641', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V596NV02864641', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V596NV02864641', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16V596NV02864641', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V596NV02864641', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V596NV02864766', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V596NV02864766', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V596NV02864766', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V596NV02864836', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V596NV02864836', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V596NV02864836', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V596NV02864972', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V596NV02864972', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V596NV02864972', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16V596NV02864995', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V596NV02864995', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V596NV02864995', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16V596NV02864995', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V596NV02864995', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V596NV02864995', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V596NV02864995', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16V596NV02864995', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V596NV02864995', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V596NV02864995', N'DV716')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V596NV02864995', N'DV755')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V627NV02864104', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V627NV02864104', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16V627NV02864104', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V627NV02864104', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V627NV02864223', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V627NV02864223', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V627NV02864223', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V627NV02864223', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V627NV02864223', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V627NV02864223', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16V627NV02864223', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V627NV02864223', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16V627NV02864223', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V627NV02864223', N'DV716')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V627NV02864423', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16V627NV02864423', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16V627NV02864423', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V627NV02864423', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V627NV02864463', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16V627NV02864463', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16V627NV02864463', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V627NV02864463', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V627NV02864571', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16V627NV02864571', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16V627NV02864571', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V627NV02864571', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V627NV02864571', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V627NV02864571', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V627NV02864571', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V627NV02864571', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V627NV02864571', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16V627NV02864571', N'DV716')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V627NV02864571', N'DV755')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V627NV02864571', N'DV785')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V627NV02864587', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16V627NV02864587', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16V627NV02864587', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V627NV02864587', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16V627NV02864597', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V627NV02864597', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V627NV02864597', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V627NV02864597', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V627NV02864597', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V627NV02864597', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16V627NV02864597', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V627NV02864597', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V627NV02864769', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V627NV02864769', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V627NV02864769', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V627NV02864769', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V627NV02864769', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V627NV02864769', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16V627NV02864769', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V627NV02864769', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16V627NV02864769', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V627NV02864769', N'DV716')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V627NV02864844', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V627NV02864844', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V627NV02864844', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V627NV02864844', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V627NV02864844', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V627NV02864844', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16V627NV02864844', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V627NV02864844', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16V627NV02864844', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V627NV02864844', N'DV716')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V627NV02864845', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16V627NV02864845', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V627NV02864845', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V627NV02864845', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V627NV02864845', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V627NV02864845', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V627NV02864845', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16V627NV02864845', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V627NV02864845', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V786NV02864104', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V786NV02864104', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V786NV02864104', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V786NV02864104', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16V786NV02864104', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V786NV02864104', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V786NV02864104', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16V786NV02864104', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V786NV02864104', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V786NV02864104', N'DV716')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V786NV02864104', N'DV755')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V786NV02864134', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16V786NV02864134', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V786NV02864134', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V786NV02864134', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V786NV02864134', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V786NV02864134', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V786NV02864134', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16V786NV02864134', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V786NV02864134', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V786NV02864144', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16V786NV02864144', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16V786NV02864144', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V786NV02864144', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V786NV02864167', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16V786NV02864167', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V786NV02864167', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V786NV02864167', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V786NV02864167', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V786NV02864167', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V786NV02864167', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16V786NV02864167', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V786NV02864167', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V786NV02864234', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16V786NV02864234', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V786NV02864234', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V786NV02864234', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V786NV02864234', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V786NV02864234', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V786NV02864234', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16V786NV02864234', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V786NV02864234', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16V786NV02864285', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V786NV02864285', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V786NV02864285', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V786NV02864285', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V786NV02864285', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16V786NV02864368', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V786NV02864368', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V786NV02864368', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16V786NV02864368', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V786NV02864368', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V786NV02864368', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V786NV02864368', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16V786NV02864368', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V786NV02864368', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V786NV02864368', N'DV716')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V786NV02864368', N'DV755')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V786NV02864461', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V786NV02864461', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16V786NV02864528', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V786NV02864528', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V786NV02864528', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16V786NV02864528', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V786NV02864528', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V786NV02864528', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16V786NV02864677', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V786NV02864677', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V786NV02864714', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V786NV02864714', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V786NV02864714', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V786NV02864714', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V786NV02864714', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V786NV02864714', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16V786NV02864714', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V786NV02864714', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16V786NV02864714', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V786NV02864714', N'DV716')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V786NV02864760', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V786NV02864760', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V786NV02864760', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V786NV02864785', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16V786NV02864785', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V786NV02864785', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V786NV02864785', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V786NV02864785', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V786NV02864785', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V786NV02864785', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16V786NV02864785', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V786NV02864785', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V786NV02864863', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16V786NV02864863', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16V786NV02864863', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V786NV02864863', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V786NV02864863', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V786NV02864863', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V786NV02864863', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V786NV02864863', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V786NV02864863', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16V786NV02864863', N'DV716')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V786NV02864863', N'DV755')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V786NV02864863', N'DV785')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V786NV02864867', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16V786NV02864867', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V786NV02864867', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V786NV02864867', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V786NV02864867', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V786NV02864867', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V786NV02864867', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16V786NV02864867', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V786NV02864867', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V908NV02864158', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V908NV02864158', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16V908NV02864158', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V908NV02864158', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16V908NV02864179', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V908NV02864179', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V908NV02864224', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V908NV02864224', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V908NV02864224', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V908NV02864224', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V908NV02864224', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16V908NV02864224', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16V908NV02864224', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V908NV02864224', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16V908NV02864224', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V908NV02864248', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V908NV02864248', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V908NV02864248', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V908NV02864248', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V908NV02864248', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16V908NV02864248', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16V908NV02864248', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V908NV02864248', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16V908NV02864248', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V908NV02864253', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V908NV02864253', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V908NV02864253', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V908NV02864253', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V908NV02864253', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16V908NV02864253', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16V908NV02864253', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V908NV02864253', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16V908NV02864253', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V908NV02864330', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V908NV02864330', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V908NV02864330', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16V908NV02864406', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V908NV02864406', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V908NV02864423', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16V908NV02864423', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V908NV02864423', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16V908NV02864423', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V908NV02864456', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V908NV02864456', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V908NV02864456', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V908NV02864456', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V908NV02864456', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16V908NV02864456', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16V908NV02864456', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V908NV02864456', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16V908NV02864456', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V908NV02864546', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V908NV02864546', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V908NV02864546', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V908NV02864546', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16V908NV02864546', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V908NV02864546', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V908NV02864546', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16V908NV02864546', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V908NV02864546', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V908NV02864546', N'DV716')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V908NV02864546', N'DV755')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V908NV02864612', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16V908NV02864612', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16V908NV02864612', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V908NV02864612', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V908NV02864651', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V908NV02864651', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16V908NV02864651', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16V908NV02864651', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V908NV02864651', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V908NV02864651', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16V908NV02864651', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V908NV02864651', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V908NV02864651', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V908NV02864693', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V908NV02864693', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V908NV02864693', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16V908NV02864745', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V908NV02864745', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V908NV02864745', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16V908NV02864745', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V908NV02864745', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V908NV02864745', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V908NV02864773', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V908NV02864773', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V908NV02864824', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V908NV02864824', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16V908NV02864850', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V908NV02864850', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V908NV02864850', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V908NV02864850', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V908NV02864850', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V908NV02864918', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V908NV02864918', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16V908NV02864918', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V908NV02864918', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16V908NV02864932', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V908NV02864932', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V908NV02864932', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V908NV02864932', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V908NV02864932', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V983NV02864125', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16V983NV02864125', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16V983NV02864125', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V983NV02864125', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V983NV02864125', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V983NV02864125', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V983NV02864125', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V983NV02864125', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V983NV02864125', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16V983NV02864125', N'DV716')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V983NV02864125', N'DV755')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V983NV02864125', N'DV785')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16V983NV02864192', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V983NV02864192', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V983NV02864228', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16V983NV02864228', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16V983NV02864228', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V983NV02864228', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V983NV02864228', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V983NV02864228', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V983NV02864228', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V983NV02864228', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V983NV02864228', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16V983NV02864228', N'DV716')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V983NV02864228', N'DV755')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V983NV02864228', N'DV785')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16V983NV02864267', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V983NV02864267', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V983NV02864290', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V983NV02864290', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V983NV02864290', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V983NV02864290', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16V983NV02864290', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V983NV02864290', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V983NV02864290', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16V983NV02864290', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V983NV02864290', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V983NV02864290', N'DV716')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V983NV02864290', N'DV755')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V983NV02864293', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16V983NV02864293', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V983NV02864293', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V983NV02864293', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V983NV02864293', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V983NV02864293', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V983NV02864293', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16V983NV02864293', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V983NV02864293', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16V983NV02864397', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V983NV02864397', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V983NV02864397', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16V983NV02864397', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V983NV02864397', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V983NV02864397', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V983NV02864397', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16V983NV02864397', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V983NV02864397', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V983NV02864397', N'DV716')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V983NV02864397', N'DV755')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V983NV02864437', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V983NV02864437', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V983NV02864437', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V983NV02864437', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V983NV02864437', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V983NV02864437', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16V983NV02864437', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V983NV02864437', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16V983NV02864437', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V983NV02864437', N'DV716')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16V983NV02864451', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V983NV02864451', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V983NV02864451', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V983NV02864451', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V983NV02864451', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V983NV02864451', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16V983NV02864451', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V983NV02864451', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16V983NV02864485', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V983NV02864485', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V983NV02864485', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16V983NV02864485', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V983NV02864485', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V983NV02864485', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V983NV02864485', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16V983NV02864485', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V983NV02864485', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V983NV02864485', N'DV716')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V983NV02864485', N'DV755')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V983NV02864501', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16V983NV02864501', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V983NV02864501', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V983NV02864501', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V983NV02864501', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V983NV02864501', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V983NV02864501', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16V983NV02864501', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V983NV02864501', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16V983NV02864655', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V983NV02864655', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V983NV02864655', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16V983NV02864655', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V983NV02864655', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V983NV02864655', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V983NV02864655', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (6, N'16V983NV02864655', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V983NV02864655', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V983NV02864655', N'DV716')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V983NV02864655', N'DV755')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V983NV02864680', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V983NV02864680', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16V983NV02864680', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16V983NV02864680', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V983NV02864680', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V983NV02864680', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16V983NV02864680', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V983NV02864680', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V983NV02864680', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (9, N'16V983NV02864810', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V983NV02864810', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V983NV02864810', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V983NV02864810', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (5, N'16V983NV02864810', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V983NV02864810', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16V983NV02864810', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V983NV02864810', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V983NV02864858', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16V983NV02864858', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V983NV02864858', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16V983NV02864858', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V983NV02864936', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16V983NV02864936', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16V983NV02864936', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V983NV02864936', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V983NV02864936', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V983NV02864936', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V983NV02864936', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V983NV02864936', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V983NV02864936', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16V983NV02864936', N'DV716')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V983NV02864936', N'DV755')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V983NV02864936', N'DV785')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V983NV02864939', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V983NV02864939', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V983NV02864949', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16V983NV02864949', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16V983NV02864949', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V983NV02864949', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V983NV02864949', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V983NV02864949', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V983NV02864949', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V983NV02864949', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V983NV02864949', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16V983NV02864949', N'DV716')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V983NV02864949', N'DV755')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V983NV02864949', N'DV785')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V983NV02864993', N'DV148')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (8, N'16V983NV02864993', N'DV160')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16V983NV02864993', N'DV226')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (4, N'16V983NV02864993', N'DV269')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V983NV02864993', N'DV293')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V983NV02864993', N'DV324')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (2, N'16V983NV02864993', N'DV412')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (7, N'16V983NV02864993', N'DV526')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (10, N'16V983NV02864993', N'DV643')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (3, N'16V983NV02864993', N'DV716')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V983NV02864993', N'DV755')
GO
INSERT [dbo].[ChiTietDichVu] ([soLuong], [maHD], [maDichVu]) VALUES (1, N'16V983NV02864993', N'DV785')
GO
INSERT [dbo].[Phong] ([maPhong], [tenPhong], [giaPhong], [sucChua], [chieuRong], [chieuDai], [tivi], [ban], [tenSofa], [slSofa], [slLoa], [loaiPhong], [ttPhong], [soLanDatTruoc]) VALUES (N'T105', N'Phòng T454          ', 200000, 10, 20, 20, N'Android Tivi Toshiba                                                                                                                                                                                                                                           ', N'Karaoke QVB 04                                                                                                                                                                                                                                                 ', N'Blizz 948SS                                                                                                                                                                                                                                                    ', 5, 3, N'THUONG              ', N'DAT_TRUOC           ', 0)
GO
INSERT [dbo].[Phong] ([maPhong], [tenPhong], [giaPhong], [sucChua], [chieuRong], [chieuDai], [tivi], [ban], [tenSofa], [slSofa], [slLoa], [loaiPhong], [ttPhong], [soLanDatTruoc]) VALUES (N'T234', N'Phòng T421          ', 200000, 10, 20, 20, N'Android Tivi Toshiba                                                                                                                                                                                                                                           ', N'Karaoke QVB 04                                                                                                                                                                                                                                                 ', N'Blizz 948SS                                                                                                                                                                                                                                                    ', 5, 3, N'THUONG              ', N'DAT_TRUOC           ', 1)
GO
INSERT [dbo].[Phong] ([maPhong], [tenPhong], [giaPhong], [sucChua], [chieuRong], [chieuDai], [tivi], [ban], [tenSofa], [slSofa], [slLoa], [loaiPhong], [ttPhong], [soLanDatTruoc]) VALUES (N'T345', N'Phòng T216          ', 200000, 10, 20, 20, N'Android Tivi Toshiba                                                                                                                                                                                                                                           ', N'Karaoke QVB 04                                                                                                                                                                                                                                                 ', N'Blizz 948SS                                                                                                                                                                                                                                                    ', 5, 3, N'THUONG              ', N'DAT_TRUOC           ', 1)
GO
INSERT [dbo].[Phong] ([maPhong], [tenPhong], [giaPhong], [sucChua], [chieuRong], [chieuDai], [tivi], [ban], [tenSofa], [slSofa], [slLoa], [loaiPhong], [ttPhong], [soLanDatTruoc]) VALUES (N'T384', N'Phòng T857          ', 200000, 10, 20, 20, N'Android Tivi Toshiba                                                                                                                                                                                                                                           ', N'Karaoke QVB 04                                                                                                                                                                                                                                                 ', N'Blizz 948SS                                                                                                                                                                                                                                                    ', 5, 3, N'THUONG              ', N'TRONG               ', 0)
GO
INSERT [dbo].[Phong] ([maPhong], [tenPhong], [giaPhong], [sucChua], [chieuRong], [chieuDai], [tivi], [ban], [tenSofa], [slSofa], [slLoa], [loaiPhong], [ttPhong], [soLanDatTruoc]) VALUES (N'T389', N'Phòng T214          ', 200000, 10, 20, 20, N'Android Tivi Toshiba                                                                                                                                                                                                                                           ', N'Karaoke QVB 04                                                                                                                                                                                                                                                 ', N'Blizz 948SS                                                                                                                                                                                                                                                    ', 5, 3, N'THUONG              ', N'TRONG               ', 0)
GO
INSERT [dbo].[Phong] ([maPhong], [tenPhong], [giaPhong], [sucChua], [chieuRong], [chieuDai], [tivi], [ban], [tenSofa], [slSofa], [slLoa], [loaiPhong], [ttPhong], [soLanDatTruoc]) VALUES (N'T405', N'Phòng T400          ', 200000, 10, 20, 20, N'Android Tivi Toshiba                                                                                                                                                                                                                                           ', N'Karaoke QVB 04                                                                                                                                                                                                                                                 ', N'Blizz 948SS                                                                                                                                                                                                                                                    ', 5, 3, N'THUONG              ', N'HOAT_DONG           ', 0)
GO
INSERT [dbo].[Phong] ([maPhong], [tenPhong], [giaPhong], [sucChua], [chieuRong], [chieuDai], [tivi], [ban], [tenSofa], [slSofa], [slLoa], [loaiPhong], [ttPhong], [soLanDatTruoc]) VALUES (N'T533', N'Phòng T302          ', 200000, 10, 20, 20, N'Android Tivi Toshiba                                                                                                                                                                                                                                           ', N'Karaoke QVB 04                                                                                                                                                                                                                                                 ', N'Blizz 948SS                                                                                                                                                                                                                                                    ', 5, 3, N'THUONG              ', N'TRONG               ', 0)
GO
INSERT [dbo].[Phong] ([maPhong], [tenPhong], [giaPhong], [sucChua], [chieuRong], [chieuDai], [tivi], [ban], [tenSofa], [slSofa], [slLoa], [loaiPhong], [ttPhong], [soLanDatTruoc]) VALUES (N'T554', N'Phòng T873          ', 200000, 10, 20, 20, N'Android Tivi Toshiba                                                                                                                                                                                                                                           ', N'Karaoke QVB 04                                                                                                                                                                                                                                                 ', N'Blizz 948SS                                                                                                                                                                                                                                                    ', 5, 3, N'THUONG              ', N'TRONG               ', 0)
GO
INSERT [dbo].[Phong] ([maPhong], [tenPhong], [giaPhong], [sucChua], [chieuRong], [chieuDai], [tivi], [ban], [tenSofa], [slSofa], [slLoa], [loaiPhong], [ttPhong], [soLanDatTruoc]) VALUES (N'T599', N'Phòng T528          ', 200000, 10, 20, 20, N'Android Tivi Toshiba                                                                                                                                                                                                                                           ', N'Karaoke QVB 04                                                                                                                                                                                                                                                 ', N'Blizz 948SS                                                                                                                                                                                                                                                    ', 5, 3, N'THUONG              ', N'TRONG               ', 0)
GO
INSERT [dbo].[Phong] ([maPhong], [tenPhong], [giaPhong], [sucChua], [chieuRong], [chieuDai], [tivi], [ban], [tenSofa], [slSofa], [slLoa], [loaiPhong], [ttPhong], [soLanDatTruoc]) VALUES (N'T716', N'Phòng T663          ', 200000, 10, 20, 20, N'Android Tivi Toshiba                                                                                                                                                                                                                                           ', N'Karaoke QVB 04                                                                                                                                                                                                                                                 ', N'Blizz 948SS                                                                                                                                                                                                                                                    ', 5, 3, N'THUONG              ', N'TRONG               ', 0)
GO
INSERT [dbo].[Phong] ([maPhong], [tenPhong], [giaPhong], [sucChua], [chieuRong], [chieuDai], [tivi], [ban], [tenSofa], [slSofa], [slLoa], [loaiPhong], [ttPhong], [soLanDatTruoc]) VALUES (N'T717', N'Phòng T759          ', 200000, 10, 20, 20, N'Android Tivi Toshiba                                                                                                                                                                                                                                           ', N'Karaoke QVB 04                                                                                                                                                                                                                                                 ', N'Blizz 948SS                                                                                                                                                                                                                                                    ', 5, 3, N'THUONG              ', N'TRONG               ', 0)
GO
INSERT [dbo].[Phong] ([maPhong], [tenPhong], [giaPhong], [sucChua], [chieuRong], [chieuDai], [tivi], [ban], [tenSofa], [slSofa], [slLoa], [loaiPhong], [ttPhong], [soLanDatTruoc]) VALUES (N'T778', N'Phòng T803          ', 200000, 10, 20, 20, N'Android Tivi Toshiba                                                                                                                                                                                                                                           ', N'Karaoke QVB 04                                                                                                                                                                                                                                                 ', N'Blizz 948SS                                                                                                                                                                                                                                                    ', 5, 3, N'THUONG              ', N'TRONG               ', 0)
GO
INSERT [dbo].[Phong] ([maPhong], [tenPhong], [giaPhong], [sucChua], [chieuRong], [chieuDai], [tivi], [ban], [tenSofa], [slSofa], [slLoa], [loaiPhong], [ttPhong], [soLanDatTruoc]) VALUES (N'T811', N'Phòng T817          ', 200000, 10, 20, 20, N'Android Tivi Toshiba                                                                                                                                                                                                                                           ', N'Karaoke QVB 04                                                                                                                                                                                                                                                 ', N'Blizz 948SS                                                                                                                                                                                                                                                    ', 5, 3, N'THUONG              ', N'TRONG               ', 0)
GO
INSERT [dbo].[Phong] ([maPhong], [tenPhong], [giaPhong], [sucChua], [chieuRong], [chieuDai], [tivi], [ban], [tenSofa], [slSofa], [slLoa], [loaiPhong], [ttPhong], [soLanDatTruoc]) VALUES (N'T897', N'Phòng T940          ', 200000, 10, 20, 20, N'Android Tivi Toshiba                                                                                                                                                                                                                                           ', N'Karaoke QVB 04                                                                                                                                                                                                                                                 ', N'Blizz 948SS                                                                                                                                                                                                                                                    ', 5, 3, N'THUONG              ', N'TRONG               ', 0)
GO
INSERT [dbo].[Phong] ([maPhong], [tenPhong], [giaPhong], [sucChua], [chieuRong], [chieuDai], [tivi], [ban], [tenSofa], [slSofa], [slLoa], [loaiPhong], [ttPhong], [soLanDatTruoc]) VALUES (N'T949', N'Phòng T253          ', 200000, 10, 20, 20, N'Android Tivi Toshiba                                                                                                                                                                                                                                           ', N'Karaoke QVB 04                                                                                                                                                                                                                                                 ', N'Blizz 948SS                                                                                                                                                                                                                                                    ', 5, 3, N'THUONG              ', N'TRONG               ', 0)
GO
INSERT [dbo].[Phong] ([maPhong], [tenPhong], [giaPhong], [sucChua], [chieuRong], [chieuDai], [tivi], [ban], [tenSofa], [slSofa], [slLoa], [loaiPhong], [ttPhong], [soLanDatTruoc]) VALUES (N'V170', N'Phòng V682          ', 500000, 15, 25, 25, N'Smart Tivi Samsung 4K 55 inch UA55AU7002                                                                                                                                                                                                                       ', N'Karaoke QVB 04                                                                                                                                                                                                                                                 ', N'Blizz 948SS                                                                                                                                                                                                                                                    ', 7, 5, N'VIP                 ', N'TRONG               ', 0)
GO
INSERT [dbo].[Phong] ([maPhong], [tenPhong], [giaPhong], [sucChua], [chieuRong], [chieuDai], [tivi], [ban], [tenSofa], [slSofa], [slLoa], [loaiPhong], [ttPhong], [soLanDatTruoc]) VALUES (N'V174', N'Phòng V587          ', 500000, 15, 25, 25, N'Smart Tivi Samsung 4K 55 inch UA55AU7002                                                                                                                                                                                                                       ', N'Karaoke QVB 04                                                                                                                                                                                                                                                 ', N'Blizz 948SS                                                                                                                                                                                                                                                    ', 7, 5, N'VIP                 ', N'TRONG               ', 0)
GO
INSERT [dbo].[Phong] ([maPhong], [tenPhong], [giaPhong], [sucChua], [chieuRong], [chieuDai], [tivi], [ban], [tenSofa], [slSofa], [slLoa], [loaiPhong], [ttPhong], [soLanDatTruoc]) VALUES (N'V231', N'Phòng V813          ', 500000, 15, 25, 25, N'Smart Tivi Samsung 4K 55 inch UA55AU7002                                                                                                                                                                                                                       ', N'Karaoke QVB 04                                                                                                                                                                                                                                                 ', N'Blizz 948SS                                                                                                                                                                                                                                                    ', 7, 5, N'VIP                 ', N'TRONG               ', 0)
GO
INSERT [dbo].[Phong] ([maPhong], [tenPhong], [giaPhong], [sucChua], [chieuRong], [chieuDai], [tivi], [ban], [tenSofa], [slSofa], [slLoa], [loaiPhong], [ttPhong], [soLanDatTruoc]) VALUES (N'V344', N'Phòng V281          ', 500000, 15, 25, 25, N'Smart Tivi Samsung 4K 55 inch UA55AU7002                                                                                                                                                                                                                       ', N'Karaoke QVB 04                                                                                                                                                                                                                                                 ', N'Blizz 948SS                                                                                                                                                                                                                                                    ', 7, 5, N'VIP                 ', N'TRONG               ', 0)
GO
INSERT [dbo].[Phong] ([maPhong], [tenPhong], [giaPhong], [sucChua], [chieuRong], [chieuDai], [tivi], [ban], [tenSofa], [slSofa], [slLoa], [loaiPhong], [ttPhong], [soLanDatTruoc]) VALUES (N'V347', N'Phòng V534          ', 500000, 15, 25, 25, N'Smart Tivi Samsung 4K 55 inch UA55AU7002                                                                                                                                                                                                                       ', N'Karaoke QVB 04                                                                                                                                                                                                                                                 ', N'Blizz 948SS                                                                                                                                                                                                                                                    ', 7, 5, N'VIP                 ', N'TRONG               ', 0)
GO
INSERT [dbo].[Phong] ([maPhong], [tenPhong], [giaPhong], [sucChua], [chieuRong], [chieuDai], [tivi], [ban], [tenSofa], [slSofa], [slLoa], [loaiPhong], [ttPhong], [soLanDatTruoc]) VALUES (N'V351', N'Phòng V255          ', 500000, 15, 25, 25, N'Smart Tivi Samsung 4K 55 inch UA55AU7002                                                                                                                                                                                                                       ', N'Karaoke QVB 04                                                                                                                                                                                                                                                 ', N'Blizz 948SS                                                                                                                                                                                                                                                    ', 7, 5, N'VIP                 ', N'TRONG               ', 0)
GO
INSERT [dbo].[Phong] ([maPhong], [tenPhong], [giaPhong], [sucChua], [chieuRong], [chieuDai], [tivi], [ban], [tenSofa], [slSofa], [slLoa], [loaiPhong], [ttPhong], [soLanDatTruoc]) VALUES (N'V392', N'Phòng V155          ', 500000, 15, 25, 25, N'Smart Tivi Samsung 4K 55 inch UA55AU7002                                                                                                                                                                                                                       ', N'Karaoke QVB 04                                                                                                                                                                                                                                                 ', N'Blizz 948SS                                                                                                                                                                                                                                                    ', 7, 5, N'VIP                 ', N'TRONG               ', 0)
GO
INSERT [dbo].[Phong] ([maPhong], [tenPhong], [giaPhong], [sucChua], [chieuRong], [chieuDai], [tivi], [ban], [tenSofa], [slSofa], [slLoa], [loaiPhong], [ttPhong], [soLanDatTruoc]) VALUES (N'V432', N'Phòng V576          ', 500000, 15, 25, 25, N'Smart Tivi Samsung 4K 55 inch UA55AU7002                                                                                                                                                                                                                       ', N'Karaoke QVB 04                                                                                                                                                                                                                                                 ', N'Blizz 948SS                                                                                                                                                                                                                                                    ', 7, 5, N'VIP                 ', N'TRONG               ', 0)
GO
INSERT [dbo].[Phong] ([maPhong], [tenPhong], [giaPhong], [sucChua], [chieuRong], [chieuDai], [tivi], [ban], [tenSofa], [slSofa], [slLoa], [loaiPhong], [ttPhong], [soLanDatTruoc]) VALUES (N'V531', N'Phòng V995          ', 500000, 15, 25, 25, N'Smart Tivi Samsung 4K 55 inch UA55AU7002                                                                                                                                                                                                                       ', N'Karaoke QVB 04                                                                                                                                                                                                                                                 ', N'Blizz 948SS                                                                                                                                                                                                                                                    ', 7, 5, N'VIP                 ', N'TRONG               ', 0)
GO
INSERT [dbo].[Phong] ([maPhong], [tenPhong], [giaPhong], [sucChua], [chieuRong], [chieuDai], [tivi], [ban], [tenSofa], [slSofa], [slLoa], [loaiPhong], [ttPhong], [soLanDatTruoc]) VALUES (N'V596', N'Phòng V294          ', 500000, 15, 25, 25, N'Smart Tivi Samsung 4K 55 inch UA55AU7002                                                                                                                                                                                                                       ', N'Karaoke QVB 04                                                                                                                                                                                                                                                 ', N'Blizz 948SS                                                                                                                                                                                                                                                    ', 7, 5, N'VIP                 ', N'TRONG               ', 0)
GO
INSERT [dbo].[Phong] ([maPhong], [tenPhong], [giaPhong], [sucChua], [chieuRong], [chieuDai], [tivi], [ban], [tenSofa], [slSofa], [slLoa], [loaiPhong], [ttPhong], [soLanDatTruoc]) VALUES (N'V627', N'Phòng V116          ', 500000, 15, 25, 25, N'Smart Tivi Samsung 4K 55 inch UA55AU7002                                                                                                                                                                                                                       ', N'Karaoke QVB 04                                                                                                                                                                                                                                                 ', N'Blizz 948SS                                                                                                                                                                                                                                                    ', 7, 5, N'VIP                 ', N'TRONG               ', 0)
GO
INSERT [dbo].[Phong] ([maPhong], [tenPhong], [giaPhong], [sucChua], [chieuRong], [chieuDai], [tivi], [ban], [tenSofa], [slSofa], [slLoa], [loaiPhong], [ttPhong], [soLanDatTruoc]) VALUES (N'V786', N'Phòng V420          ', 500000, 15, 25, 25, N'Smart Tivi Samsung 4K 55 inch UA55AU7002                                                                                                                                                                                                                       ', N'Karaoke QVB 04                                                                                                                                                                                                                                                 ', N'Blizz 948SS                                                                                                                                                                                                                                                    ', 7, 5, N'VIP                 ', N'TRONG               ', 0)
GO
INSERT [dbo].[Phong] ([maPhong], [tenPhong], [giaPhong], [sucChua], [chieuRong], [chieuDai], [tivi], [ban], [tenSofa], [slSofa], [slLoa], [loaiPhong], [ttPhong], [soLanDatTruoc]) VALUES (N'V908', N'Phòng V236          ', 500000, 15, 25, 25, N'Smart Tivi Samsung 4K 55 inch UA55AU7002                                                                                                                                                                                                                       ', N'Karaoke QVB 04                                                                                                                                                                                                                                                 ', N'Blizz 948SS                                                                                                                                                                                                                                                    ', 7, 5, N'VIP                 ', N'TRONG               ', 0)
GO
INSERT [dbo].[Phong] ([maPhong], [tenPhong], [giaPhong], [sucChua], [chieuRong], [chieuDai], [tivi], [ban], [tenSofa], [slSofa], [slLoa], [loaiPhong], [ttPhong], [soLanDatTruoc]) VALUES (N'V983', N'Phòng V104          ', 500000, 15, 25, 25, N'Smart Tivi Samsung 4K 55 inch UA55AU7002                                                                                                                                                                                                                       ', N'Karaoke QVB 04                                                                                                                                                                                                                                                 ', N'Blizz 948SS                                                                                                                                                                                                                                                    ', 7, 5, N'VIP                 ', N'TRONG               ', 0)
GO
INSERT [dbo].[DatPhong] ([maDP], [ngayDatPhong], [gioNhanPhong], [maNhanVien], [maKhDatPhong], [maPhong]) VALUES (N'DP335', CAST(N'2022-12-16T00:00:00.000' AS DateTime), CAST(N'2022-12-16T10:00:00.000' AS DateTime), N'NV02864', N'4940', N'T345')
GO
INSERT [dbo].[DatPhong] ([maDP], [ngayDatPhong], [gioNhanPhong], [maNhanVien], [maKhDatPhong], [maPhong]) VALUES (N'DP528', CAST(N'2022-12-16T00:00:00.000' AS DateTime), CAST(N'2022-12-16T10:00:00.000' AS DateTime), N'NV02864', N'9078', N'T234')
GO
INSERT [dbo].[DatPhong] ([maDP], [ngayDatPhong], [gioNhanPhong], [maNhanVien], [maKhDatPhong], [maPhong]) VALUES (N'DP824', CAST(N'2022-12-17T00:00:00.000' AS DateTime), CAST(N'2022-12-17T14:00:00.000' AS DateTime), N'NV02864', N'9078', N'T105')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'12T105NV02736872', N'V174')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'12T234NV02736631', N'V351')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'12T345NV02736207', N'T345')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'12T345NV02736935', N'T345')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'12T384NV02736652', N'T384')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'13T105NV02736580', N'T345')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'13T105NV02736594', N'T345')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'13T105NV02736835', N'T345')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'13T234NV02736879', N'V351')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'13T234NV02736989', N'T234')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (1, N'13T405NV02736281', N'V351')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'13T717NV02736579', N'T717')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (9, N'13V170NV02736396', N'V170')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'13V170NV02736898', N'V170')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (1, N'14T105NV02864267', N'T105')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'14T105NV02864302', N'T105')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (103, N'14T105NV02864328', N'T105')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (1, N'14T105NV02864586', N'T105')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'14T234NV02864280', N'T234')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'14T234NV02864325', N'T234')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (168, N'14T234NV02864376', N'T234')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'14T345NV02864902', N'T345')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'14T384NV02864207', N'T384')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (15, N'14T384NV02864467', N'T384')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (1, N'14T384NV02864473', N'T384')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'14T389NV02864237', N'T389')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'14T389NV02864240', N'T389')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'14T389NV02864622', N'T389')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (147, N'14T405NV02864855', N'T405')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'14T533NV02864921', N'T533')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'14V174NV02864585', N'V174')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T105NV02864109', N'T533')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T105NV02864139', N'T716')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T105NV02864172', N'T533')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T105NV02864175', N'T105')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T105NV02864232', N'V432')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T105NV02864234', N'T345')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T105NV02864247', N'T384')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T105NV02864277', N'V531')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T105NV02864396', N'V344')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T105NV02864485', N'V344')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T105NV02864515', N'T716')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T105NV02864547', N'T716')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T105NV02864578', N'T405')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T105NV02864595', N'T949')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T105NV02864601', N'T533')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T105NV02864603', N'V983')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T105NV02864606', N'T105')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T105NV02864614', N'V983')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T105NV02864624', N'T405')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T105NV02864631', N'V596')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T105NV02864644', N'T949')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T105NV02864722', N'T384')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T105NV02864744', N'T949')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T105NV02864769', N'V432')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T105NV02864800', N'V174')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T105NV02864809', N'T716')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T105NV02864825', N'T717')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T105NV02864829', N'T533')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T105NV02864841', N'T384')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T105NV02864853', N'T105')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T105NV02864930', N'T533')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T105NV02864935', N'T105')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T105NV02864938', N'T389')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (11, N'16T105NV02864957', N'T105')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T234NV02864179', N'V627')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T234NV02864186', N'V432')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T234NV02864259', N'V231')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T234NV02864266', N'V170')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T234NV02864269', N'T105')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T234NV02864316', N'T778')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T234NV02864342', N'V170')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T234NV02864374', N'V174')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T234NV02864393', N'T389')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T234NV02864497', N'T405')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T234NV02864546', N'T105')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T234NV02864707', N'T717')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T234NV02864722', N'V786')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T234NV02864777', N'T778')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T234NV02864793', N'V392')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T234NV02864919', N'T405')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T234NV02864952', N'T234')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T234NV02864974', N'V344')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T345NV02864129', N'T716')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T345NV02864138', N'T716')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T345NV02864203', N'V983')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T345NV02864222', N'V596')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T345NV02864252', N'V432')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T345NV02864255', N'T778')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T345NV02864260', N'V908')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T345NV02864367', N'V531')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T345NV02864399', N'V531')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T345NV02864493', N'V983')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T345NV02864495', N'T345')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T345NV02864589', N'V908')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T345NV02864628', N'V908')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T345NV02864668', N'V347')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T345NV02864714', N'V344')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T345NV02864886', N'V174')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T384NV02864164', N'V432')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T384NV02864324', N'T105')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T384NV02864367', N'T897')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T384NV02864454', N'T345')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T384NV02864476', N'V347')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T384NV02864499', N'V347')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T384NV02864558', N'V983')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T384NV02864584', N'V347')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T384NV02864612', N'T405')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T384NV02864657', N'T716')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T384NV02864784', N'V908')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T384NV02864846', N'T234')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T384NV02864870', N'V432')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T384NV02864880', N'T897')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T384NV02864999', N'V347')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T389NV02864124', N'V531')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T389NV02864326', N'V174')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T389NV02864462', N'V170')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T389NV02864469', N'V983')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T389NV02864482', N'T533')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T389NV02864575', N'T234')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T389NV02864664', N'T345')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T389NV02864686', N'T599')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T389NV02864801', N'T105')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T389NV02864888', N'V170')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T389NV02864894', N'V627')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T389NV02864901', N'T778')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T389NV02864918', N'V908')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T389NV02864922', N'T345')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T389NV02864982', N'V351')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T405NV02864166', N'V908')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T405NV02864168', N'V170')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T405NV02864187', N'V347')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T405NV02864257', N'V531')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T405NV02864261', N'T897')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T405NV02864302', N'V596')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T405NV02864307', N'V908')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T405NV02864328', N'T384')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T405NV02864334', N'T716')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T405NV02864343', N'T384')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T405NV02864395', N'V347')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T405NV02864521', N'V170')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T405NV02864582', N'T405')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T405NV02864604', N'T234')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T405NV02864628', N'V231')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T405NV02864658', N'V174')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T405NV02864696', N'T389')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T405NV02864859', N'V983')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T405NV02864903', N'V908')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T533NV02864205', N'T105')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T533NV02864208', N'T897')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T533NV02864244', N'T716')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T533NV02864330', N'T599')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T533NV02864339', N'V174')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T533NV02864381', N'T811')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T533NV02864495', N'V531')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T533NV02864506', N'V174')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T533NV02864671', N'T234')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T533NV02864681', N'V170')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T533NV02864717', N'V392')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T533NV02864719', N'T554')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T533NV02864743', N'T533')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T533NV02864746', N'T554')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T533NV02864784', N'T105')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T533NV02864788', N'T345')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T533NV02864805', N'T389')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T533NV02864880', N'V627')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T533NV02864922', N'T405')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T533NV02864936', N'T811')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T533NV02864947', N'T778')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T533NV02864974', N'T389')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T554NV02864299', N'T716')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T554NV02864305', N'V432')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T554NV02864377', N'V344')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T554NV02864403', N'T234')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T554NV02864500', N'T105')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T554NV02864558', N'V531')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T554NV02864679', N'V627')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T554NV02864682', N'V983')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T554NV02864703', N'V786')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T554NV02864736', N'T405')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T554NV02864743', N'T389')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T554NV02864777', N'V596')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T554NV02864781', N'V596')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T554NV02864787', N'V596')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T554NV02864842', N'V786')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T554NV02864956', N'V432')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T554NV02864962', N'V170')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T599NV02864176', N'V351')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T599NV02864271', N'T717')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T599NV02864358', N'T105')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T599NV02864376', N'V908')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T599NV02864424', N'T389')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T599NV02864496', N'T778')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T599NV02864514', N'T716')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T599NV02864669', N'T717')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T599NV02864677', N'V627')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T599NV02864706', N'V786')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T599NV02864784', N'T949')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T599NV02864789', N'T599')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T599NV02864796', N'T105')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T716NV02864171', N'T949')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T716NV02864180', N'T717')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T716NV02864264', N'V351')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T716NV02864284', N'V231')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T716NV02864397', N'T345')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T716NV02864486', N'T405')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T716NV02864525', N'V627')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T716NV02864537', N'T778')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T716NV02864612', N'T105')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T716NV02864646', N'T405')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T716NV02864788', N'V344')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T716NV02864837', N'V531')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T716NV02864871', N'T716')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T716NV02864920', N'V170')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T716NV02864926', N'V392')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T716NV02864952', N'V596')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T716NV02864965', N'V432')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T717NV02864188', N'V432')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T717NV02864255', N'V596')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T717NV02864326', N'V983')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T717NV02864333', N'V983')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T717NV02864390', N'V351')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T717NV02864400', N'V344')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T717NV02864430', N'T949')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T717NV02864443', N'T717')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T717NV02864480', N'V392')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T717NV02864665', N'T234')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T717NV02864713', N'T389')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T717NV02864734', N'T778')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T717NV02864743', N'T717')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T717NV02864851', N'T778')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T717NV02864995', N'T949')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T778NV02864136', N'V596')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T778NV02864144', N'V983')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T778NV02864146', N'V392')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T778NV02864217', N'T389')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T778NV02864242', N'V786')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T778NV02864279', N'T949')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T778NV02864307', N'T234')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T778NV02864434', N'T405')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T778NV02864595', N'T389')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T778NV02864651', N'V392')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T778NV02864697', N'T533')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T778NV02864781', N'T105')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T778NV02864945', N'V627')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T778NV02864999', N'T599')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T811NV02864154', N'T405')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T811NV02864289', N'T389')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T811NV02864304', N'T105')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T811NV02864392', N'T105')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T811NV02864409', N'T345')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T811NV02864426', N'T949')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T811NV02864470', N'T345')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T811NV02864581', N'V908')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T811NV02864589', N'T778')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T811NV02864685', N'V596')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T811NV02864690', N'T897')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T811NV02864711', N'T599')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T811NV02864803', N'T599')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T811NV02864823', N'V170')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T811NV02864939', N'V344')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T897NV02864110', N'V347')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T897NV02864235', N'V347')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T897NV02864297', N'V174')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T897NV02864453', N'T345')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T897NV02864459', N'V531')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T897NV02864472', N'T716')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T897NV02864510', N'T234')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T897NV02864654', N'T716')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T897NV02864655', N'V347')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T897NV02864762', N'V531')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T897NV02864812', N'V786')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T897NV02864820', N'V432')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T949NV02864101', N'V174')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T949NV02864204', N'T234')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T949NV02864248', N'T811')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T949NV02864313', N'T897')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T949NV02864315', N'V908')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T949NV02864369', N'T389')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T949NV02864379', N'V432')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T949NV02864437', N'T811')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T949NV02864466', N'T345')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T949NV02864470', N'T105')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T949NV02864479', N'V432')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T949NV02864484', N'V170')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T949NV02864627', N'T599')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T949NV02864634', N'T717')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T949NV02864724', N'T554')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T949NV02864776', N'V392')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T949NV02864858', N'T105')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16T949NV02864932', N'V786')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V170NV02864277', N'T345')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V170NV02864368', N'T405')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V170NV02864439', N'T384')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V170NV02864540', N'T949')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V170NV02864615', N'T384')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V170NV02864718', N'V347')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V170NV02864788', N'T345')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V170NV02864860', N'V392')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V170NV02864869', N'T105')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V170NV02864932', N'V786')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V170NV02864941', N'V344')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V170NV02864960', N'V531')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V170NV02864961', N'T389')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V174NV02864149', N'V432')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V174NV02864271', N'V174')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V174NV02864390', N'V432')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V174NV02864415', N'T105')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V174NV02864446', N'T389')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V174NV02864530', N'T554')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V174NV02864544', N'T717')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V174NV02864551', N'T717')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V174NV02864564', N'T533')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V174NV02864895', N'T811')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V174NV02864950', N'V347')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V231NV02864169', N'V983')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V231NV02864384', N'V786')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V231NV02864479', N'V531')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V231NV02864571', N'V627')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V231NV02864602', N'T405')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V231NV02864624', N'V786')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V231NV02864662', N'V170')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V231NV02864730', N'T897')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V231NV02864771', N'V983')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V231NV02864797', N'V432')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V231NV02864932', N'T384')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V231NV02864949', N'T778')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V231NV02864988', N'V596')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V344NV02864164', N'V347')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V344NV02864184', N'T716')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V344NV02864218', N'T105')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V344NV02864389', N'T105')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V344NV02864436', N'T778')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V344NV02864465', N'V170')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V344NV02864470', N'T778')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V344NV02864910', N'T811')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V344NV02864919', N'V351')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V344NV02864986', N'T345')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V344NV02864999', N'T234')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V347NV02864383', N'V392')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V347NV02864519', N'T384')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V347NV02864799', N'T599')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V347NV02864835', N'T533')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V347NV02864892', N'V392')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V347NV02864902', N'T105')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V347NV02864954', N'V983')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V351NV02864167', N'T105')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V351NV02864237', N'T554')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V351NV02864314', N'T716')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V351NV02864340', N'T811')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V351NV02864464', N'V231')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V351NV02864516', N'T811')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V351NV02864520', N'V983')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V351NV02864575', N'T105')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V351NV02864670', N'T778')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V351NV02864726', N'T533')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V351NV02864767', N'T811')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V351NV02864770', N'V983')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V351NV02864791', N'V347')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V351NV02864832', N'V983')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V351NV02864880', N'T554')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V351NV02864922', N'V627')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V351NV02864932', N'T105')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V351NV02864995', N'V432')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V392NV02864119', N'V908')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V392NV02864125', N'V347')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V392NV02864172', N'V786')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V392NV02864222', N'T105')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V392NV02864327', N'V596')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V392NV02864351', N'V627')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V392NV02864521', N'V596')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V392NV02864563', N'T599')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V392NV02864949', N'T389')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V392NV02864967', N'V786')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V432NV02864138', N'T234')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V432NV02864266', N'V170')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V432NV02864270', N'T389')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V432NV02864276', N'V432')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V432NV02864298', N'V344')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V432NV02864380', N'T811')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V432NV02864411', N'V231')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V432NV02864458', N'T949')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V432NV02864463', N'T554')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V432NV02864517', N'V351')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V432NV02864536', N'T717')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V432NV02864538', N'V392')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V432NV02864549', N'T533')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V432NV02864562', N'T405')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V432NV02864573', N'T897')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V432NV02864727', N'T778')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V432NV02864771', N'T599')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V432NV02864849', N'T405')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V432NV02864860', N'T105')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V432NV02864871', N'T717')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V432NV02864977', N'T949')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V531NV02864102', N'T105')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V531NV02864146', N'T811')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V531NV02864265', N'V170')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V531NV02864324', N'T405')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V531NV02864445', N'T599')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V531NV02864459', N'T345')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V531NV02864504', N'V983')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V531NV02864589', N'V908')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V531NV02864692', N'V347')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V531NV02864774', N'V432')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V531NV02864782', N'T384')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V531NV02864808', N'V351')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V531NV02864864', N'V983')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V531NV02864872', N'V596')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V531NV02864951', N'T897')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V531NV02864962', N'T811')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V596NV02864157', N'V392')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V596NV02864180', N'T533')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V596NV02864229', N'V908')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V596NV02864271', N'T389')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V596NV02864360', N'V231')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V596NV02864368', N'T717')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V596NV02864455', N'T554')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V596NV02864494', N'V432')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V596NV02864641', N'V908')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V596NV02864766', N'V627')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V596NV02864836', N'T389')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V596NV02864972', N'V786')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V596NV02864995', N'V596')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V627NV02864104', N'V908')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V627NV02864223', N'V786')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V627NV02864423', N'T533')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V627NV02864463', N'T717')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V627NV02864571', N'V908')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V627NV02864587', N'T778')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V627NV02864597', N'V344')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V627NV02864769', N'T384')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V627NV02864844', N'T405')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V627NV02864845', N'T384')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V786NV02864104', N'T949')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V786NV02864134', N'V531')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V786NV02864144', N'V627')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V786NV02864167', N'V596')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V786NV02864234', N'V351')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V786NV02864285', N'V347')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V786NV02864368', N'T533')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V786NV02864461', N'V170')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V786NV02864528', N'V344')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V786NV02864677', N'V174')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V786NV02864714', N'V531')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V786NV02864760', N'V596')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V786NV02864785', N'T234')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V786NV02864863', N'T716')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V786NV02864867', N'T778')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V908NV02864158', N'T105')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V908NV02864179', N'V170')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V908NV02864224', N'V432')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V908NV02864248', N'T405')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V908NV02864253', N'T811')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V908NV02864330', N'T533')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V908NV02864406', N'T897')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V908NV02864423', N'T949')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V908NV02864456', N'T389')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V908NV02864546', N'T811')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V908NV02864612', N'V908')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V908NV02864651', N'T105')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V908NV02864693', N'T234')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V908NV02864745', N'T778')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V908NV02864773', N'V392')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V908NV02864824', N'T778')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V908NV02864850', N'T811')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V908NV02864918', N'V908')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V908NV02864932', N'T949')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V983NV02864125', N'V908')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V983NV02864192', N'T533')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V983NV02864228', N'T234')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V983NV02864267', N'V786')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V983NV02864290', N'T345')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V983NV02864293', N'T105')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V983NV02864397', N'T105')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V983NV02864437', N'T811')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V983NV02864451', N'V786')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V983NV02864485', N'V231')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V983NV02864501', N'T105')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V983NV02864655', N'T599')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V983NV02864680', N'V596')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V983NV02864810', N'V432')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V983NV02864858', N'T389')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V983NV02864936', N'T717')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V983NV02864939', N'V174')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V983NV02864949', N'T778')
GO
INSERT [dbo].[ChiTietHoaDon] ([thoiGianSuDung], [maHD], [maPhong]) VALUES (0, N'16V983NV02864993', N'T811')
GO
INSERT [dbo].[LoaiThanhVien] ([maLoaiTV], [tenLoaiTV], [uuDai], [ngayDangKy], [ngayHetHan], [soDinhDanh], [maKH]) VALUES (N'03941222', N'Thân Thiết          ', 1, CAST(N'2022-12-10T00:00:00.000' AS DateTime), CAST(N'2023-12-10T00:00:00.000' AS DateTime), N'070202010394', N'9078')
GO
INSERT [dbo].[LoaiThanhVien] ([maLoaiTV], [tenLoaiTV], [uuDai], [ngayDangKy], [ngayHetHan], [soDinhDanh], [maKH]) VALUES (N'08041222', N'Bạc                 ', 2, CAST(N'2022-12-10T00:00:00.000' AS DateTime), CAST(N'2023-12-10T00:00:00.000' AS DateTime), N'020303320804', N'2293')
GO
INSERT [dbo].[LoaiThanhVien] ([maLoaiTV], [tenLoaiTV], [uuDai], [ngayDangKy], [ngayHetHan], [soDinhDanh], [maKH]) VALUES (N'12051222', N'Thân Thiết          ', 1, CAST(N'2022-12-10T00:00:00.000' AS DateTime), CAST(N'2023-12-10T00:00:00.000' AS DateTime), N'044202001205', N'4940')
GO
INSERT [dbo].[LoaiThanhVien] ([maLoaiTV], [tenLoaiTV], [uuDai], [ngayDangKy], [ngayHetHan], [soDinhDanh], [maKH]) VALUES (N'13071222', N'Thân Thiết          ', 1, CAST(N'2022-12-10T00:00:00.000' AS DateTime), CAST(N'2023-12-10T00:00:00.000' AS DateTime), N'079302031307', N'1439')
GO
INSERT [dbo].[LoaiThanhVien] ([maLoaiTV], [tenLoaiTV], [uuDai], [ngayDangKy], [ngayHetHan], [soDinhDanh], [maKH]) VALUES (N'1308    ', NULL, 0, CAST(N'2022-12-13T00:00:00.000' AS DateTime), CAST(N'2023-12-13T00:00:00.000' AS DateTime), NULL, N'2382')
GO
INSERT [dbo].[LoaiThanhVien] ([maLoaiTV], [tenLoaiTV], [uuDai], [ngayDangKy], [ngayHetHan], [soDinhDanh], [maKH]) VALUES (N'13841222', N'Thân Thiết          ', 1, CAST(N'2022-12-10T00:00:00.000' AS DateTime), CAST(N'2023-12-10T00:00:00.000' AS DateTime), N'087202011384', N'7464')
GO
INSERT [dbo].[LoaiThanhVien] ([maLoaiTV], [tenLoaiTV], [uuDai], [ngayDangKy], [ngayHetHan], [soDinhDanh], [maKH]) VALUES (N'14961222', N'Thân Thiết          ', 1, CAST(N'2022-12-10T00:00:00.000' AS DateTime), CAST(N'2023-12-10T00:00:00.000' AS DateTime), N'094202011496', N'7841')
GO
INSERT [dbo].[LoaiThanhVien] ([maLoaiTV], [tenLoaiTV], [uuDai], [ngayDangKy], [ngayHetHan], [soDinhDanh], [maKH]) VALUES (N'15101222', N'Thân Thiết          ', 1, CAST(N'2022-12-10T00:00:00.000' AS DateTime), CAST(N'2023-12-10T00:00:00.000' AS DateTime), N'038202001510', N'2839')
GO
INSERT [dbo].[LoaiThanhVien] ([maLoaiTV], [tenLoaiTV], [uuDai], [ngayDangKy], [ngayHetHan], [soDinhDanh], [maKH]) VALUES (N'17521222', N'Thân Thiết          ', 1, CAST(N'2022-12-10T00:00:00.000' AS DateTime), CAST(N'2023-12-10T00:00:00.000' AS DateTime), N'020501221752', N'7417')
GO
INSERT [dbo].[LoaiThanhVien] ([maLoaiTV], [tenLoaiTV], [uuDai], [ngayDangKy], [ngayHetHan], [soDinhDanh], [maKH]) VALUES (N'18061222', N'Thân Thiết          ', 1, CAST(N'2022-12-10T00:00:00.000' AS DateTime), CAST(N'2023-12-10T00:00:00.000' AS DateTime), N'030201071806', N'4905')
GO
INSERT [dbo].[LoaiThanhVien] ([maLoaiTV], [tenLoaiTV], [uuDai], [ngayDangKy], [ngayHetHan], [soDinhDanh], [maKH]) VALUES (N'2041    ', NULL, 0, CAST(N'2022-12-12T00:00:00.000' AS DateTime), CAST(N'2023-12-12T00:00:00.000' AS DateTime), NULL, N'6203')
GO
INSERT [dbo].[LoaiThanhVien] ([maLoaiTV], [tenLoaiTV], [uuDai], [ngayDangKy], [ngayHetHan], [soDinhDanh], [maKH]) VALUES (N'22441222', N'Thân Thiết          ', 1, CAST(N'2022-12-10T00:00:00.000' AS DateTime), CAST(N'2023-12-10T00:00:00.000' AS DateTime), N'052202012244', N'5215')
GO
INSERT [dbo].[LoaiThanhVien] ([maLoaiTV], [tenLoaiTV], [uuDai], [ngayDangKy], [ngayHetHan], [soDinhDanh], [maKH]) VALUES (N'23061222', N'Thân Thiết          ', 1, CAST(N'2022-12-10T00:00:00.000' AS DateTime), CAST(N'2023-12-10T00:00:00.000' AS DateTime), N'079302002306', N'4026')
GO
INSERT [dbo].[LoaiThanhVien] ([maLoaiTV], [tenLoaiTV], [uuDai], [ngayDangKy], [ngayHetHan], [soDinhDanh], [maKH]) VALUES (N'24091222', N'Thân Thiết          ', 1, CAST(N'2022-12-10T00:00:00.000' AS DateTime), CAST(N'2023-12-10T00:00:00.000' AS DateTime), N'080202012409', N'0789')
GO
INSERT [dbo].[LoaiThanhVien] ([maLoaiTV], [tenLoaiTV], [uuDai], [ngayDangKy], [ngayHetHan], [soDinhDanh], [maKH]) VALUES (N'24461222', N'Thân Thiết          ', 1, CAST(N'2022-12-10T00:00:00.000' AS DateTime), CAST(N'2023-12-10T00:00:00.000' AS DateTime), N'089202012446', N'2245')
GO
INSERT [dbo].[LoaiThanhVien] ([maLoaiTV], [tenLoaiTV], [uuDai], [ngayDangKy], [ngayHetHan], [soDinhDanh], [maKH]) VALUES (N'25571222', N'Thân Thiết          ', 1, CAST(N'2022-12-10T00:00:00.000' AS DateTime), CAST(N'2023-12-10T00:00:00.000' AS DateTime), N'068202012557', N'1860')
GO
INSERT [dbo].[LoaiThanhVien] ([maLoaiTV], [tenLoaiTV], [uuDai], [ngayDangKy], [ngayHetHan], [soDinhDanh], [maKH]) VALUES (N'28361222', N'Thân Thiết          ', 1, CAST(N'2022-12-10T00:00:00.000' AS DateTime), CAST(N'2023-12-10T00:00:00.000' AS DateTime), N'079202002836', N'1725')
GO
INSERT [dbo].[LoaiThanhVien] ([maLoaiTV], [tenLoaiTV], [uuDai], [ngayDangKy], [ngayHetHan], [soDinhDanh], [maKH]) VALUES (N'28901222', N'Thân Thiết          ', 1, CAST(N'2022-12-10T00:00:00.000' AS DateTime), CAST(N'2023-12-10T00:00:00.000' AS DateTime), N'082202012890', N'1421')
GO
INSERT [dbo].[LoaiThanhVien] ([maLoaiTV], [tenLoaiTV], [uuDai], [ngayDangKy], [ngayHetHan], [soDinhDanh], [maKH]) VALUES (N'29321222', N'Thân Thiết          ', 1, CAST(N'2022-12-10T00:00:00.000' AS DateTime), CAST(N'2023-12-10T00:00:00.000' AS DateTime), N'052302012932', N'5376')
GO
INSERT [dbo].[LoaiThanhVien] ([maLoaiTV], [tenLoaiTV], [uuDai], [ngayDangKy], [ngayHetHan], [soDinhDanh], [maKH]) VALUES (N'30001222', N'Thân Thiết          ', 1, CAST(N'2022-12-10T00:00:00.000' AS DateTime), CAST(N'2023-12-10T00:00:00.000' AS DateTime), N'049202003000', N'4881')
GO
INSERT [dbo].[LoaiThanhVien] ([maLoaiTV], [tenLoaiTV], [uuDai], [ngayDangKy], [ngayHetHan], [soDinhDanh], [maKH]) VALUES (N'30081222', N'Thân Thiết          ', 1, CAST(N'2022-12-10T00:00:00.000' AS DateTime), CAST(N'2023-12-10T00:00:00.000' AS DateTime), N'030606343008', N'8963')
GO
INSERT [dbo].[LoaiThanhVien] ([maLoaiTV], [tenLoaiTV], [uuDai], [ngayDangKy], [ngayHetHan], [soDinhDanh], [maKH]) VALUES (N'31581222', N'Thân Thiết          ', 1, CAST(N'2022-12-10T00:00:00.000' AS DateTime), CAST(N'2023-12-10T00:00:00.000' AS DateTime), N'080202013158', N'9112')
GO
INSERT [dbo].[LoaiThanhVien] ([maLoaiTV], [tenLoaiTV], [uuDai], [ngayDangKy], [ngayHetHan], [soDinhDanh], [maKH]) VALUES (N'3250    ', NULL, 0, CAST(N'2022-12-14T00:00:00.000' AS DateTime), CAST(N'2023-12-14T00:00:00.000' AS DateTime), NULL, N'6902')
GO
INSERT [dbo].[LoaiThanhVien] ([maLoaiTV], [tenLoaiTV], [uuDai], [ngayDangKy], [ngayHetHan], [soDinhDanh], [maKH]) VALUES (N'33391222', N'Thân Thiết          ', 1, CAST(N'2022-12-10T00:00:00.000' AS DateTime), CAST(N'2023-12-10T00:00:00.000' AS DateTime), N'080202013339', N'6101')
GO
INSERT [dbo].[LoaiThanhVien] ([maLoaiTV], [tenLoaiTV], [uuDai], [ngayDangKy], [ngayHetHan], [soDinhDanh], [maKH]) VALUES (N'35921222', N'Thân Thiết          ', 1, CAST(N'2022-12-10T00:00:00.000' AS DateTime), CAST(N'2023-12-10T00:00:00.000' AS DateTime), N'054202003592', N'1142')
GO
INSERT [dbo].[LoaiThanhVien] ([maLoaiTV], [tenLoaiTV], [uuDai], [ngayDangKy], [ngayHetHan], [soDinhDanh], [maKH]) VALUES (N'36201222', N'Thân Thiết          ', 1, CAST(N'2022-12-10T00:00:00.000' AS DateTime), CAST(N'2023-12-10T00:00:00.000' AS DateTime), N'079202033620', N'2320')
GO
INSERT [dbo].[LoaiThanhVien] ([maLoaiTV], [tenLoaiTV], [uuDai], [ngayDangKy], [ngayHetHan], [soDinhDanh], [maKH]) VALUES (N'37511222', N'Thân Thiết          ', 1, CAST(N'2022-12-10T00:00:00.000' AS DateTime), CAST(N'2023-12-10T00:00:00.000' AS DateTime), N'080202013751', N'7919')
GO
INSERT [dbo].[LoaiThanhVien] ([maLoaiTV], [tenLoaiTV], [uuDai], [ngayDangKy], [ngayHetHan], [soDinhDanh], [maKH]) VALUES (N'39421222', N'Bạc                 ', 2, CAST(N'2022-12-10T00:00:00.000' AS DateTime), CAST(N'2023-12-10T00:00:00.000' AS DateTime), N'058201003942', N'2423')
GO
INSERT [dbo].[LoaiThanhVien] ([maLoaiTV], [tenLoaiTV], [uuDai], [ngayDangKy], [ngayHetHan], [soDinhDanh], [maKH]) VALUES (N'40721222', N'Thân Thiết          ', 1, CAST(N'2022-12-10T00:00:00.000' AS DateTime), CAST(N'2023-12-10T00:00:00.000' AS DateTime), N'045302004072', N'3715')
GO
INSERT [dbo].[LoaiThanhVien] ([maLoaiTV], [tenLoaiTV], [uuDai], [ngayDangKy], [ngayHetHan], [soDinhDanh], [maKH]) VALUES (N'4161    ', NULL, 0, CAST(N'2022-12-14T00:00:00.000' AS DateTime), CAST(N'2023-12-14T00:00:00.000' AS DateTime), NULL, N'6873')
GO
INSERT [dbo].[LoaiThanhVien] ([maLoaiTV], [tenLoaiTV], [uuDai], [ngayDangKy], [ngayHetHan], [soDinhDanh], [maKH]) VALUES (N'42451222', N'Thân Thiết          ', 1, CAST(N'2022-12-10T00:00:00.000' AS DateTime), CAST(N'2023-12-10T00:00:00.000' AS DateTime), N'064202014245', N'3236')
GO
INSERT [dbo].[LoaiThanhVien] ([maLoaiTV], [tenLoaiTV], [uuDai], [ngayDangKy], [ngayHetHan], [soDinhDanh], [maKH]) VALUES (N'43721222', N'Thân Thiết          ', 1, CAST(N'2022-12-10T00:00:00.000' AS DateTime), CAST(N'2023-12-10T00:00:00.000' AS DateTime), N'074202004372', N'8049')
GO
INSERT [dbo].[LoaiThanhVien] ([maLoaiTV], [tenLoaiTV], [uuDai], [ngayDangKy], [ngayHetHan], [soDinhDanh], [maKH]) VALUES (N'4486    ', NULL, 0, CAST(N'2022-12-14T00:00:00.000' AS DateTime), CAST(N'2023-12-14T00:00:00.000' AS DateTime), NULL, N'6222')
GO
INSERT [dbo].[LoaiThanhVien] ([maLoaiTV], [tenLoaiTV], [uuDai], [ngayDangKy], [ngayHetHan], [soDinhDanh], [maKH]) VALUES (N'46201222', N'Thân Thiết          ', 1, CAST(N'2022-12-10T00:00:00.000' AS DateTime), CAST(N'2023-12-10T00:00:00.000' AS DateTime), N'066202004620', N'6747')
GO
INSERT [dbo].[LoaiThanhVien] ([maLoaiTV], [tenLoaiTV], [uuDai], [ngayDangKy], [ngayHetHan], [soDinhDanh], [maKH]) VALUES (N'46851222', N'Thân Thiết          ', 1, CAST(N'2022-12-10T00:00:00.000' AS DateTime), CAST(N'2023-12-10T00:00:00.000' AS DateTime), N'010807864685', N'6414')
GO
INSERT [dbo].[LoaiThanhVien] ([maLoaiTV], [tenLoaiTV], [uuDai], [ngayDangKy], [ngayHetHan], [soDinhDanh], [maKH]) VALUES (N'47481222', N'Thân Thiết          ', 1, CAST(N'2022-12-10T00:00:00.000' AS DateTime), CAST(N'2023-12-10T00:00:00.000' AS DateTime), N'034202014748', N'7552')
GO
INSERT [dbo].[LoaiThanhVien] ([maLoaiTV], [tenLoaiTV], [uuDai], [ngayDangKy], [ngayHetHan], [soDinhDanh], [maKH]) VALUES (N'50161222', N'Thân Thiết          ', 1, CAST(N'2022-12-10T00:00:00.000' AS DateTime), CAST(N'2023-12-10T00:00:00.000' AS DateTime), N'087302015016', N'7130')
GO
INSERT [dbo].[LoaiThanhVien] ([maLoaiTV], [tenLoaiTV], [uuDai], [ngayDangKy], [ngayHetHan], [soDinhDanh], [maKH]) VALUES (N'52071222', N'Thân Thiết          ', 1, CAST(N'2022-12-10T00:00:00.000' AS DateTime), CAST(N'2023-12-10T00:00:00.000' AS DateTime), N'064202005207', N'7269')
GO
INSERT [dbo].[LoaiThanhVien] ([maLoaiTV], [tenLoaiTV], [uuDai], [ngayDangKy], [ngayHetHan], [soDinhDanh], [maKH]) VALUES (N'54061222', N'Thân Thiết          ', 1, CAST(N'2022-12-10T00:00:00.000' AS DateTime), CAST(N'2023-12-10T00:00:00.000' AS DateTime), N'072202005406', N'8695')
GO
INSERT [dbo].[LoaiThanhVien] ([maLoaiTV], [tenLoaiTV], [uuDai], [ngayDangKy], [ngayHetHan], [soDinhDanh], [maKH]) VALUES (N'55081222', N'Thân Thiết          ', 1, CAST(N'2022-12-10T00:00:00.000' AS DateTime), CAST(N'2023-12-10T00:00:00.000' AS DateTime), N'067202005508', N'4204')
GO
INSERT [dbo].[LoaiThanhVien] ([maLoaiTV], [tenLoaiTV], [uuDai], [ngayDangKy], [ngayHetHan], [soDinhDanh], [maKH]) VALUES (N'55641222', N'Thân Thiết          ', 1, CAST(N'2022-12-10T00:00:00.000' AS DateTime), CAST(N'2023-12-10T00:00:00.000' AS DateTime), N'074302005564', N'3380')
GO
INSERT [dbo].[LoaiThanhVien] ([maLoaiTV], [tenLoaiTV], [uuDai], [ngayDangKy], [ngayHetHan], [soDinhDanh], [maKH]) VALUES (N'5740    ', NULL, 0, CAST(N'2022-12-14T00:00:00.000' AS DateTime), CAST(N'2023-12-14T00:00:00.000' AS DateTime), NULL, N'6229')
GO
INSERT [dbo].[LoaiThanhVien] ([maLoaiTV], [tenLoaiTV], [uuDai], [ngayDangKy], [ngayHetHan], [soDinhDanh], [maKH]) VALUES (N'58031222', N'Thân Thiết          ', 1, CAST(N'2022-12-10T00:00:00.000' AS DateTime), CAST(N'2023-12-10T00:00:00.000' AS DateTime), N'074202005803', N'5121')
GO
INSERT [dbo].[LoaiThanhVien] ([maLoaiTV], [tenLoaiTV], [uuDai], [ngayDangKy], [ngayHetHan], [soDinhDanh], [maKH]) VALUES (N'60091222', N'Thân Thiết          ', 1, CAST(N'2022-12-10T00:00:00.000' AS DateTime), CAST(N'2023-12-10T00:00:00.000' AS DateTime), N'066202006009', N'1497')
GO
INSERT [dbo].[LoaiThanhVien] ([maLoaiTV], [tenLoaiTV], [uuDai], [ngayDangKy], [ngayHetHan], [soDinhDanh], [maKH]) VALUES (N'60771222', N'Thân Thiết          ', 1, CAST(N'2022-12-10T00:00:00.000' AS DateTime), CAST(N'2023-12-10T00:00:00.000' AS DateTime), N'040202006077', N'1978')
GO
INSERT [dbo].[LoaiThanhVien] ([maLoaiTV], [tenLoaiTV], [uuDai], [ngayDangKy], [ngayHetHan], [soDinhDanh], [maKH]) VALUES (N'62421222', N'Thân Thiết          ', 1, CAST(N'2022-12-10T00:00:00.000' AS DateTime), CAST(N'2023-12-10T00:00:00.000' AS DateTime), N'020405476242', N'8819')
GO
INSERT [dbo].[LoaiThanhVien] ([maLoaiTV], [tenLoaiTV], [uuDai], [ngayDangKy], [ngayHetHan], [soDinhDanh], [maKH]) VALUES (N'63141222', N'Thân Thiết          ', 1, CAST(N'2022-12-10T00:00:00.000' AS DateTime), CAST(N'2023-12-10T00:00:00.000' AS DateTime), N'051202006314', N'3874')
GO
INSERT [dbo].[LoaiThanhVien] ([maLoaiTV], [tenLoaiTV], [uuDai], [ngayDangKy], [ngayHetHan], [soDinhDanh], [maKH]) VALUES (N'64911222', N'Thân Thiết          ', 1, CAST(N'2022-12-10T00:00:00.000' AS DateTime), CAST(N'2023-12-10T00:00:00.000' AS DateTime), N'038202006491', N'8702')
GO
INSERT [dbo].[LoaiThanhVien] ([maLoaiTV], [tenLoaiTV], [uuDai], [ngayDangKy], [ngayHetHan], [soDinhDanh], [maKH]) VALUES (N'65191222', N'Thân Thiết          ', 1, CAST(N'2022-12-10T00:00:00.000' AS DateTime), CAST(N'2023-12-10T00:00:00.000' AS DateTime), N'010807996519', N'3916')
GO
INSERT [dbo].[LoaiThanhVien] ([maLoaiTV], [tenLoaiTV], [uuDai], [ngayDangKy], [ngayHetHan], [soDinhDanh], [maKH]) VALUES (N'66831222', N'Thân Thiết          ', 1, CAST(N'2022-12-10T00:00:00.000' AS DateTime), CAST(N'2023-12-10T00:00:00.000' AS DateTime), N'020301356683', N'6144')
GO
INSERT [dbo].[LoaiThanhVien] ([maLoaiTV], [tenLoaiTV], [uuDai], [ngayDangKy], [ngayHetHan], [soDinhDanh], [maKH]) VALUES (N'6728    ', NULL, 0, CAST(N'2022-12-15T00:00:00.000' AS DateTime), CAST(N'2023-12-15T00:00:00.000' AS DateTime), NULL, N'6908')
GO
INSERT [dbo].[LoaiThanhVien] ([maLoaiTV], [tenLoaiTV], [uuDai], [ngayDangKy], [ngayHetHan], [soDinhDanh], [maKH]) VALUES (N'7152    ', NULL, 0, CAST(N'2022-12-14T00:00:00.000' AS DateTime), CAST(N'2023-12-14T00:00:00.000' AS DateTime), NULL, N'6228')
GO
INSERT [dbo].[LoaiThanhVien] ([maLoaiTV], [tenLoaiTV], [uuDai], [ngayDangKy], [ngayHetHan], [soDinhDanh], [maKH]) VALUES (N'74751222', N'Thân Thiết          ', 1, CAST(N'2022-12-10T00:00:00.000' AS DateTime), CAST(N'2023-12-10T00:00:00.000' AS DateTime), N'080302007475', N'8100')
GO
INSERT [dbo].[LoaiThanhVien] ([maLoaiTV], [tenLoaiTV], [uuDai], [ngayDangKy], [ngayHetHan], [soDinhDanh], [maKH]) VALUES (N'79701222', N'Thân Thiết          ', 1, CAST(N'2022-12-10T00:00:00.000' AS DateTime), CAST(N'2023-12-10T00:00:00.000' AS DateTime), N'020102537970', N'7292')
GO
INSERT [dbo].[LoaiThanhVien] ([maLoaiTV], [tenLoaiTV], [uuDai], [ngayDangKy], [ngayHetHan], [soDinhDanh], [maKH]) VALUES (N'8221    ', NULL, 0, CAST(N'2022-12-12T00:00:00.000' AS DateTime), CAST(N'2023-12-12T00:00:00.000' AS DateTime), NULL, N'8773')
GO
INSERT [dbo].[LoaiThanhVien] ([maLoaiTV], [tenLoaiTV], [uuDai], [ngayDangKy], [ngayHetHan], [soDinhDanh], [maKH]) VALUES (N'84861222', N'Thân Thiết          ', 1, CAST(N'2022-12-10T00:00:00.000' AS DateTime), CAST(N'2023-12-10T00:00:00.000' AS DateTime), N'030102488486', N'0136')
GO
INSERT [dbo].[LoaiThanhVien] ([maLoaiTV], [tenLoaiTV], [uuDai], [ngayDangKy], [ngayHetHan], [soDinhDanh], [maKH]) VALUES (N'92161222', N'Thân Thiết          ', 1, CAST(N'2022-12-10T00:00:00.000' AS DateTime), CAST(N'2023-12-10T00:00:00.000' AS DateTime), N'060202009216', N'1065')
GO
INSERT [dbo].[LoaiThanhVien] ([maLoaiTV], [tenLoaiTV], [uuDai], [ngayDangKy], [ngayHetHan], [soDinhDanh], [maKH]) VALUES (N'92801222', N'Thân Thiết          ', 1, CAST(N'2022-12-10T00:00:00.000' AS DateTime), CAST(N'2023-12-10T00:00:00.000' AS DateTime), N'075202009280', N'9953')
GO
INSERT [dbo].[LoaiThanhVien] ([maLoaiTV], [tenLoaiTV], [uuDai], [ngayDangKy], [ngayHetHan], [soDinhDanh], [maKH]) VALUES (N'95141222', N'Thân Thiết          ', 1, CAST(N'2022-12-10T00:00:00.000' AS DateTime), CAST(N'2023-12-10T00:00:00.000' AS DateTime), N'089302019514', N'9607')
GO
INSERT [dbo].[LoaiThanhVien] ([maLoaiTV], [tenLoaiTV], [uuDai], [ngayDangKy], [ngayHetHan], [soDinhDanh], [maKH]) VALUES (N'967     ', NULL, 0, CAST(N'2022-12-10T00:00:00.000' AS DateTime), CAST(N'2023-12-10T00:00:00.000' AS DateTime), NULL, N'8431')
GO
INSERT [dbo].[LoaiThanhVien] ([maLoaiTV], [tenLoaiTV], [uuDai], [ngayDangKy], [ngayHetHan], [soDinhDanh], [maKH]) VALUES (N'98821222', N'Thân Thiết          ', 1, CAST(N'2022-12-10T00:00:00.000' AS DateTime), CAST(N'2023-12-10T00:00:00.000' AS DateTime), N'020601659882', N'9259')
GO
INSERT [dbo].[LoaiThanhVien] ([maLoaiTV], [tenLoaiTV], [uuDai], [ngayDangKy], [ngayHetHan], [soDinhDanh], [maKH]) VALUES (N'99171222', N'Thân Thiết          ', 1, CAST(N'2022-12-10T00:00:00.000' AS DateTime), CAST(N'2023-12-10T00:00:00.000' AS DateTime), N'020405409917', N'5971')
GO
INSERT [dbo].[LoaiThanhVien] ([maLoaiTV], [tenLoaiTV], [uuDai], [ngayDangKy], [ngayHetHan], [soDinhDanh], [maKH]) VALUES (N'996     ', NULL, 0, CAST(N'2022-12-15T00:00:00.000' AS DateTime), CAST(N'2023-12-15T00:00:00.000' AS DateTime), NULL, N'9073')
GO
