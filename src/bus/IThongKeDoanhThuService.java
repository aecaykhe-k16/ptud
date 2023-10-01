package bus;

import java.util.Date;
import java.util.List;

import entities.HoaDon;

public interface IThongKeDoanhThuService {
  List<HoaDon> thongKeTheoNgay(Date start);

  List<HoaDon> thongKeTheoThang(int moth, int year);

  List<HoaDon> thongKeTheoNam(int year);
}