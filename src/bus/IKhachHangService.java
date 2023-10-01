package bus;

import java.util.List;

import entities.KhachHang;

public interface IKhachHangService {
  List<KhachHang> dsKH();

  boolean xoaKH(String makh);

  boolean themKhachHang(KhachHang kh);

  boolean kiemtra(KhachHang kh);

  boolean suaKh(KhachHang kh);

  int kiemtraKH(String txtsdt, String txtsoDinhDanh);

  KhachHang timKhachHang(String sdt);

  boolean capNhatLoaiTV(KhachHang kh);
}
