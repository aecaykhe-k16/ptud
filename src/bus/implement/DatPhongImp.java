package bus.implement;

import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.ArrayList;
import java.util.List;

import bus.IDatPhongService;
import bus.IKhachHangService;
import bus.IPhongService;
import dao.DatPhongDao;
import dao.HoaDonDao;
import entities.ChiTietDichVu;
import entities.ChiTietHoaDon;
import entities.DatPhong;
import entities.DichVu;
import entities.HoaDon;
import entities.KhachHang;
import entities.LoaiPhongEnum;
import entities.LoaiThanhVien;
import entities.Phong;
import entities.TrangThaiPhongEnum;

public class DatPhongImp implements IDatPhongService {
  private IPhongService phongService = new PhongImp();
  private DatPhongDao datPhongDao = new DatPhongDao();
  private HoaDonDao hoaDonDao = new HoaDonDao();
  private IKhachHangService khachHangService = new KhachHangImp();
  LocalDate date = LocalDate.now();

  @Override
  public List<Phong> dsPhongThuong() {
    List<Phong> dsPhongThuong = new ArrayList<Phong>();
    for (Phong p : phongService.dsPhong()) {
      for (DatPhong dp : dsPhongDatTruoc()) {
        if (dp.getngayDatPhong().toString().equals(date.toString())) {
          String gioDat = new SimpleDateFormat("HH").format(dp.getGioNhanPhong());
          LocalTime gioHienTai = LocalTime.now();
          String gio = String.valueOf(gioHienTai.getHour());
          if (dp.getPhong().getMaPhong().trim().equals(p.getMaPhong().trim())) {
            if (gioDat.equals(gio)) {
              p.setTtPhong(TrangThaiPhongEnum.DAT_TRUOC);
            }
          }
        }
      }
      if (p.getLoaiPhong() == LoaiPhongEnum.THUONG) {
        dsPhongThuong.add(p);
      }
    }
    return dsPhongThuong;
  }

  @Override
  public List<Phong> dsPhongVIP() {
    List<Phong> dsPhongVIP = new ArrayList<Phong>();
    for (Phong p : phongService.dsPhong()) {
      for (DatPhong dp : dsPhongDatTruoc()) {
        if (dp.getngayDatPhong().toString().equals(date.toString())) {
          String gioDat = new SimpleDateFormat("HH").format(dp.getGioNhanPhong());
          LocalTime gioHienTai = LocalTime.now();
          String gio = String.valueOf(gioHienTai.getHour());
          if (dp.getPhong().getMaPhong().trim().equals(p.getMaPhong().trim())) {
            if (gioDat.equals(gio)) {
              p.setTtPhong(TrangThaiPhongEnum.DAT_TRUOC);
            }
          }
        }
      }
      if (p.getLoaiPhong() == LoaiPhongEnum.VIP) {
        dsPhongVIP.add(p);
      }
    }
    return dsPhongVIP;
  }

  @Override
  public boolean datPhong(DatPhong datPhong) {
    for (Phong p : phongService.dsPhong()) {
      if (p.getMaPhong().equals(datPhong.getPhong().getMaPhong())) {
        if (datPhongDao.datPhong(datPhong)) {
          if (new SimpleDateFormat("yyyy-MM-dd").format(datPhong.getngayDatPhong()).toString()
              .equals(date.toString())) {
            phongService.updateStatus(datPhong.getPhong().getMaPhong(),
                TrangThaiPhongEnum.DAT_TRUOC.name());
          }
          return true;
        }
      }
    }
    return false;
  }

  @Override
  public boolean suaPhong(DatPhong datPhong) {
    for (Phong p : phongService.dsPhong()) {
      if (p.getMaPhong().equals(datPhong.getPhong().getMaPhong())) {
        if (datPhongDao.suaPhong(datPhong)) {
          phongService.updateStatus(datPhong.getPhong().getMaPhong(), TrangThaiPhongEnum.DAT_TRUOC.name());
          return true;
        }
      }
    }

    return false;
  }

  @Override
  public KhachHang getKH(String maPhong) {
    KhachHang kh = null;
    for (DatPhong dp : dsPhongDatTruoc()) {
      if (maPhong.equals(dp.getPhong().getMaPhong())) {
        kh = dp.getKhachHang();
        return kh;
      }
    }
    return kh;
  }

  public List<DatPhong> dsPhongDatTruoc() {
    List<DatPhong> dsPhongDatTruoc = new ArrayList<DatPhong>();
    for (DatPhong datPhong : datPhongDao.dsPhongDat()) {
      for (KhachHang khachHang : khachHangService.dsKH()) {
        try {
          khachHang.setTenKH(datPhong.getKhachHang().getTenKH());
        } catch (Exception e1) {
          e1.printStackTrace();
        }
        if (khachHang.getLoaiTV().getMaLoaiTV().equals(datPhong.getKhachHang().getLoaiTV().getMaLoaiTV())) {
          datPhong.setKhachHang(khachHang);
        } else {
          if (datPhong.getKhachHang().getLoaiTV().getMaLoaiTV() == null) {
            LoaiThanhVien loaiThanhVien = new LoaiThanhVien();
            try {
              loaiThanhVien.setTenLoaiTV("Không có");
              khachHang.setLoaiTV(loaiThanhVien);
              datPhong.setKhachHang(khachHang);
            } catch (Exception e) {
              e.printStackTrace();
            }

          }
        }
      }
      dsPhongDatTruoc.add(datPhong);
    }
    return dsPhongDatTruoc;
  }

  @Override
  public boolean xoaPhongDat(String maDP) {
    if (datPhongDao.xoaPhongDat(maDP))
      return true;
    else
      return false;
  }

  @Override
  public List<ChiTietDichVu> dsDichVuTheoTen(String maPhong) {
    List<ChiTietDichVu> dsDichVuTheoTen = new ArrayList<ChiTietDichVu>();
    for (HoaDon hd : hoaDonDao.dsChiTietTheoTen()) {
      String[] time = hd.getNgayLapHD().toString().split("T")[1].split("\\.")[0].split("\\:");
      LocalTime gioHienTai = LocalTime.now();
      int gio = Integer.parseInt(time[0]);
      int thoiGian = gioHienTai.getHour() - gio;
      LocalDate ngayHienTai = LocalDate.now();
      LocalDate ngay = LocalDate.parse(hd.getNgayLapHD().toString().split("T")[0]);
      if (thoiGian < 3 && ngayHienTai.equals(ngay)) {
        for (ChiTietHoaDon cthd : hd.getCTHD()) {
          if (cthd.getPhong().getMaPhong().equals(maPhong)) {
            if (cthd.getThoiGianSuDung() == 0)
              dsDichVuTheoTen.add(hd.getCTDV().get(0));
          }
        }
      }
    }
    return dsDichVuTheoTen;
  }

  @Override
  public List<DichVu> dsDichVu() {
    return datPhongDao.dsDV();
  }

  @Override
  public List<DatPhong> dsNgayDat(String ngayDat) {
    List<DatPhong> dsNgayDat = new ArrayList<DatPhong>();
    for (DatPhong datPhong : datPhongDao.dsPhongDat()) {
      if (ngayDat.equals(datPhong.getngayDatPhong().toString())) {
        dsNgayDat.add(datPhong);
      }
    }

    return dsNgayDat;
  }

  public List<Phong> dsConPhong(String maPhong, String ngayDat) {
    int soLuotDat = 0;
    for (DatPhong dp : datPhongDao.dsPhongDat()) {
      if (maPhong.equals(dp.getPhong().getMaPhong())) {
        soLuotDat++;
      }
    }
    List<Phong> dsConPhong = new ArrayList<Phong>();
    for (Phong phong : phongService.dsPhong()) {
      if (phong.getSoLanDatTruoc() == soLuotDat) {
        dsConPhong.add(phong);
      }

    }
    return null;
  }

}
