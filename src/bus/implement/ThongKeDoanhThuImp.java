package bus.implement;

import java.text.SimpleDateFormat;
import java.time.ZoneId;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import bus.IThongKeDoanhThuService;
import dao.DichVuDao;
import dao.HoaDonDao;
import dao.KhachHangDao;
import dao.PhongDao;
import entities.ChiTietDichVu;
import entities.ChiTietHoaDon;
import entities.DichVu;
import entities.HoaDon;
import entities.KhachHang;
import entities.Phong;

public class ThongKeDoanhThuImp implements IThongKeDoanhThuService {
  private HoaDonDao hdDao = new HoaDonDao();
  private PhongDao phongDao = new PhongDao();
  private DichVuDao dichVuDao = new DichVuDao();
  private KhachHangDao khachHangDao = new KhachHangDao();
  private SimpleDateFormat sf = new SimpleDateFormat("dd-MM-yyyy");

  @Override
  public List<HoaDon> thongKeTheoNgay(Date start) {
    List<HoaDon> ds = new ArrayList<>();
    for (HoaDon h : hdDao.getDsHoaDon()) {
      List<ChiTietHoaDon> dsCTHD = new ArrayList<ChiTietHoaDon>();
      for (ChiTietHoaDon cthd : h.getCTHD()) {
        for (Phong p : phongDao.dsPhong()) {
          if (cthd.getPhong().getMaPhong().equals(p.getMaPhong())) {
            cthd.setPhong(p);
            dsCTHD.add(cthd);
          }
        }
      }
      h.setCTHD(dsCTHD);

      List<ChiTietDichVu> dsCTDV = new ArrayList<ChiTietDichVu>();
      for (ChiTietDichVu ctdv : h.getCTDV()) {
        for (DichVu dv : dichVuDao.getDichVu()) {
          if (ctdv.getDichVu().getMaDichVu().equals(dv.getMaDichVu())) {
            ctdv.setDichVu(dv);
            dsCTDV.add(ctdv);
          }
        }
      }
      h.setCTDV(dsCTDV);

      for (KhachHang kh : khachHangDao.dsKh()) {
        if (h.getKhachHang() != null) {
          if (h.getKhachHang().getMaKH().equals(kh.getMaKH()))
            h.setKhachHang(kh);
        }
      }

      String[] arr = h.getNgayLapHD().toString().split("T")[0].split("-");
      String ngayLap = arr[2] + "-" + arr[1] + "-" + arr[0];

      if (ngayLap.equals(sf.format(start)))
        ds.add(h);
    }
    return ds;
  }

  @Override
  public List<HoaDon> thongKeTheoThang(int mm, int yyyy) {
    List<HoaDon> ds = new ArrayList<>();
    Calendar cal = Calendar.getInstance();
    for (HoaDon h : hdDao.getDsHoaDon()) {
      List<ChiTietHoaDon> dsCTHD = new ArrayList<ChiTietHoaDon>();
      for (ChiTietHoaDon cthd : h.getCTHD()) {
        for (Phong p : phongDao.dsPhong()) {
          if (cthd.getPhong().getMaPhong().equals(p.getMaPhong())) {
            cthd.setPhong(p);
            dsCTHD.add(cthd);
          }
        }
      }
      h.setCTHD(dsCTHD);

      List<ChiTietDichVu> dsCTDV = new ArrayList<ChiTietDichVu>();
      for (ChiTietDichVu ctdv : h.getCTDV()) {
        for (DichVu dv : dichVuDao.getDichVu()) {
          if (ctdv.getDichVu().getMaDichVu().equals(dv.getMaDichVu())) {
            ctdv.setDichVu(dv);
            dsCTDV.add(ctdv);
          }
        }
      }
      h.setCTDV(dsCTDV);

      for (KhachHang kh : khachHangDao.dsKh()) {
        if (h.getKhachHang() != null) {
          if (h.getKhachHang().getMaKH().equals(kh.getMaKH()))
            h.setKhachHang(kh);
        }
      }

      cal.setTime(Date
          .from(h.getNgayLapHD().atZone(ZoneId.systemDefault())
              .toInstant()));
      int moth = cal.get(Calendar.MONTH) + 1;
      int year = cal.get(Calendar.YEAR);
      if (moth == mm && year == yyyy) {
        ds.add(h);
      }
    }
    return ds;

  }

  @Override
  public List<HoaDon> thongKeTheoNam(int yyyy) {
    List<HoaDon> ds = new ArrayList<HoaDon>();
    Calendar cal = Calendar.getInstance();
    for (HoaDon h : hdDao.getDsHoaDon()) {
      List<ChiTietHoaDon> dsCTHD = new ArrayList<ChiTietHoaDon>();
      for (ChiTietHoaDon cthd : h.getCTHD()) {
        for (Phong p : phongDao.dsPhong()) {
          if (cthd.getPhong().getMaPhong().equals(p.getMaPhong())) {
            cthd.setPhong(p);
            dsCTHD.add(cthd);
          }
        }
      }
      h.setCTHD(dsCTHD);

      List<ChiTietDichVu> dsCTDV = new ArrayList<ChiTietDichVu>();
      for (ChiTietDichVu ctdv : h.getCTDV()) {
        for (DichVu dv : dichVuDao.getDichVu()) {
          if (ctdv.getDichVu().getMaDichVu().equals(dv.getMaDichVu())) {
            ctdv.setDichVu(dv);
            dsCTDV.add(ctdv);
          }
        }
      }
      h.setCTDV(dsCTDV);

      for (KhachHang kh : khachHangDao.dsKh()) {
        if (h.getKhachHang() != null) {
          if (h.getKhachHang().getMaKH().equals(kh.getMaKH()))
            h.setKhachHang(kh);
        }
      }

      cal.setTime(Date
          .from(h.getNgayLapHD().atZone(ZoneId.systemDefault())
              .toInstant()));
      int year = cal.get(Calendar.YEAR);
      if (year == yyyy) {
        ds.add(h);
      }
    }
    return ds;
  }
}