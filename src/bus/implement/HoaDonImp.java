package bus.implement;

import java.time.LocalDate;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;

import bus.IHoaDonService;
import dao.HoaDonDao;
import dao.KhachHangDao;
import entities.ChiTietDichVu;
import entities.ChiTietHoaDon;
import entities.HoaDon;
import entities.KhachHang;

public class HoaDonImp implements IHoaDonService {
  List<HoaDon> dshoaDon = new LinkedList<HoaDon>();
  HoaDonDao hoaDonDao = new HoaDonDao();
  KhachHangDao khachHangDao = new KhachHangDao();

  @Override
  public List<HoaDon> dsHoaDonChiTietVangLai() {
    dshoaDon = hoaDonDao.dsHDChiTietVangLai();
    return dshoaDon;
  }

  @Override
  public List<HoaDon> dsHoaDon() {
    return hoaDonDao.dsHDChiTiet();
  }

  @Override
  public List<HoaDon> dsHD() {
    return hoaDonDao.getDsHoaDon();
  }

  @Override
  public boolean themHoaDon(HoaDon hoaDon) {
    return hoaDonDao.themHoaDon(hoaDon);
  }

  @Override
  public boolean themChiTietDV(ChiTietDichVu chiTietDichVu, String maHD) {
    return hoaDonDao.themHoaDonChiTietDV(chiTietDichVu, maHD);
  }

  @Override
  public boolean themChiTietHD(ChiTietHoaDon chiTietHoaDon, String maHD) {
    return hoaDonDao.themHoaDonChiTietHD(chiTietHoaDon, maHD);
  }

  @Override
  public String getMaHoaDonByPhong(String maPhong, String maNV) {
    return hoaDonDao.getMaHoaDonByPhong(maPhong, maNV);
  }

  @Override
  public void capNhatChiTietHoaDon(int thoiGian, String maHD) {
    hoaDonDao.capNhatChiTietHoaDon(thoiGian, maHD);
  }

  @Override
  public List<Map<String, Object>> dsThanhToan() {
    List<Map<String, Object>> list = new LinkedList<Map<String, Object>>();
    try {
      for (Map<String, Object> map : hoaDonDao.dsThanhToan()) {
        String[] time = map.get("ngayLapHD").toString().split(" ")[1].split("\\.")[0].split("\\:");
        LocalTime gioHienTai = LocalTime.now();
        int gio = Integer.parseInt(time[0]);
        int thoiGian = gioHienTai.getHour() - gio;
        LocalDate ngayHienTai = LocalDate.now();
        LocalDate ngay = LocalDate.parse(map.get("ngayLapHD").toString().split(" ")[0]);
        if (thoiGian < 3 && ngayHienTai.equals(ngay)) {
          list.add(map);
        }
      }

    } catch (Exception e) {
      e.printStackTrace();
    }
    return list;
  }

  @Override
  public List<HoaDon> dsHoaDonTheoSDT(String sdt) {
    if (sdt.length() == 10) {
      List<HoaDon> list = new LinkedList<HoaDon>();
      for (KhachHang kh : khachHangDao.dsKh()) {
        if (kh.getSdt().trim().equals(sdt)) {
          String maKH = kh.getMaKH().trim();
          for (HoaDon hoaDon : dsHD()) {
            if (hoaDon.getKhachHang() != null) {
              if (maKH.equals(hoaDon.getKhachHang().getMaKH().trim())) {
                list.add(hoaDon);
              }
            }
          }
        }
      }
      List<HoaDon> list2 = new LinkedList<HoaDon>();
      for (HoaDon hoaDon : list) {
        for (HoaDon hoaDon2 : dsHoaDon()) {
          if (hoaDon.getMaHD().trim().equals(hoaDon2.getMaHD().trim())) {
            list2.add(hoaDon2);
          }

        }
      }
      return list2;
    } else if (sdt.length() == 16) {
      List<HoaDon> list = new LinkedList<HoaDon>();
      for (HoaDon hoaDon : dsHD()) {
        if (hoaDon.getMaHD().trim().equals(sdt)) {
          list.add(hoaDon);
        }
      }
      List<HoaDon> list2 = new ArrayList<HoaDon>();
      List<HoaDon> list3 = new ArrayList<HoaDon>();
      for (HoaDon hoaDon : list) {
        for (HoaDon hd : dsHoaDon()) {
          if (hoaDon.getMaHD().trim().equals(hd.getMaHD().trim())) {
            list3.add(hd);
          }
        }

      }
      if (list3.size() <= 0) {
        for (HoaDon hoaDon : list) {
          for (HoaDon hoaDon2 : dsHoaDonChiTietVangLai()) {
            if (hoaDon.getMaHD().trim().equals(hoaDon2.getMaHD().trim())) {
              list2.add(hoaDon2);
            }
          }

        }
      }
      return list3.size() > 0 ? list3 : list2;

    }
    return null;
  }

}