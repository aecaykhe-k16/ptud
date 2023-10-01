package util;

import java.sql.SQLException;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import bus.IDichVuService;
import bus.IHoaDonService;
import bus.IKhachHangService;
import bus.INhanVienService;
import bus.IPhongService;
import entities.CaTruc;
import entities.ChiTietCaTruc;
import entities.ChiTietDichVu;
import entities.ChiTietHoaDon;
import entities.DichVu;
import entities.HoaDon;
import entities.KhachHang;
import entities.NhanVien;
import entities.Phong;

public class AddToData {
  public static void main(String[] args) {
    try {
      ConnectDB.getInstance().connect();
    } catch (SQLException e) {
      e.printStackTrace();
    }
    Generator generator = new Generator();
    INhanVienService nhanVienService = new bus.implement.NhanVienImp();
    IKhachHangService khachHangService = new bus.implement.KhachHangImp();
    IPhongService phongService = new bus.implement.PhongImp();
    IDichVuService dichVuService = new bus.implement.DichVuImp();
    IHoaDonService hoaDonService = new bus.implement.HoaDonImp();
    List<Phong> listPhong = new ArrayList<>();

    List<CaTruc> listCaTruc = new ArrayList<>();
    List<ChiTietCaTruc> listChiTietCaTruc = new ArrayList<>();
    List<HoaDon> listHoaDon = new ArrayList<>();
    int length = phongService.dsPhong().size();
    // Date date = new Date("10/11/2020");
    // listCTHD.add(new ChiTietHoaDon((int) (gio * 60 + phut), phong));

    // set date is tomorrow
    // date.setDate(10, 10, 2020);
    int numberOfServices = randomOther(11, 1);
    // use dichVuService.dsDichVu() to get list of services
    List<DichVu> listDichVu = dichVuService.dsDichVu();
    int lengthDichVu = listDichVu.size();
    List<ChiTietDichVu> listChiTietDichVu = new ArrayList<>();
    for (int i = 0; i < lengthDichVu; i++) {
      if (i <= numberOfServices) {
        DichVu dv = listDichVu.get(i);
        int sl = randomOther(dv.getSlTon(), 1);
        ChiTietDichVu ctdv;
        if (sl > 10)
          ctdv = new ChiTietDichVu(randomOther(10, 1), dv);
        else {
          ctdv = new ChiTietDichVu(sl, dv);
        }
        listChiTietDichVu.add(ctdv);
      }
    }

    for (int j = 0; j < length; j++) {
      Phong p = phongService.dsPhong().get(random(length, 0));
      String maphong = phongService.dsPhong().get(random(length, 0)).getMaPhong();
      NhanVien nv = new NhanVien();
      nv.setMaNV("NV02864");
      String mahd = generator.tuTaoMaHoaDon(maphong, nv.getMaNV());

      KhachHang kh = khachHangService.dsKH().get(random(length, 0));
      LocalDateTime date;
      date = LocalDateTime.of(2022, 12, 12, randomOther(23, 0), randomOther(59, 0));
      HoaDon hd = new HoaDon(mahd, date);
      hd.setNhanVien(nv);
      hd.setKhachHang(kh);
      if (hoaDonService.themHoaDon(hd)) {
        for (ChiTietDichVu ctdv : listChiTietDichVu) {
          hoaDonService.themChiTietDV(ctdv, mahd);
        }
        ChiTietHoaDon cthd = new ChiTietHoaDon((randomOther(4, 1) * 60 +
            randomOther(60, 0)), p);
        hoaDonService.themChiTietHD(cthd, mahd);
        System.out.println(true);
      }

    }

  }

  // create function random number 1-10
  public static int random(int max, int min) {
    return (int) (Math.random() * (max - min + 1) + min - 1);
  }

  public static int randomOther(int max, int min) {
    return (int) (Math.random() * (max - min + 1) + min);
  }
}
