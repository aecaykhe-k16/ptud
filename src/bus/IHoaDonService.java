package bus;

import java.util.List;
import java.util.Map;

import entities.ChiTietDichVu;
import entities.ChiTietHoaDon;
import entities.HoaDon;

public interface IHoaDonService {
  List<HoaDon> dsHoaDonChiTietVangLai();

  List<HoaDon> dsHoaDon();

  List<HoaDon> dsHD();

  List<Map<String, Object>> dsThanhToan();

  boolean themHoaDon(HoaDon hoaDon);

  boolean themChiTietDV(ChiTietDichVu chiTietDichVu, String maHD);

  boolean themChiTietHD(ChiTietHoaDon chiTietHoaDon, String maHD);

  void capNhatChiTietHoaDon(int thoiGian, String maHD);

  String getMaHoaDonByPhong(String maPhong, String maNV);

  List<HoaDon> dsHoaDonTheoSDT(String sdt);
}