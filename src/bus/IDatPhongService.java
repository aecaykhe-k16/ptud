package bus;

import java.util.List;

import entities.ChiTietDichVu;
import entities.DatPhong;
import entities.DichVu;
import entities.KhachHang;
import entities.Phong;

public interface IDatPhongService {
  List<Phong> dsPhongThuong();

  List<Phong> dsPhongVIP();

  boolean datPhong(DatPhong datPhong);

  boolean suaPhong(DatPhong datPhong);

  KhachHang getKH(String maPhong);

  List<DatPhong> dsPhongDatTruoc();

  boolean xoaPhongDat(String maDP);

  List<ChiTietDichVu> dsDichVuTheoTen(String maPhong);

  List<DichVu> dsDichVu();

  List<DatPhong> dsNgayDat(String ngayDat);

}
