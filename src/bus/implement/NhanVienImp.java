package bus.implement;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

import bus.INhanVienService;
import dao.NhanVienDao;
import dao.TaiKhoanDao;
import entities.NhanVien;

public class NhanVienImp implements INhanVienService {
  String format = LocalDate.now().format(DateTimeFormatter.ofPattern("dd/MM/yyyy"));
  LocalDate date = LocalDate.parse(format, DateTimeFormatter.ofPattern("dd/MM/yyyy"));
  private NhanVienDao nhanVienDAO = new NhanVienDao();
  private TaiKhoanDao taiKhoanDAO = new TaiKhoanDao();

  @Override
  public List<NhanVien> dsNV() {
    List<NhanVien> ds = new ArrayList<>();
    for (NhanVien nv : nhanVienDAO.dsNV()) {
      if (nv.getTrangThai()) {
        ds.add(nv);
      }
    }
    return ds;
  }

  @Override
  public int kiemTraThongTin(NhanVien nv) {
    LocalDate ngayHienTai = LocalDate.now();
    LocalDate ngaySinh = nv.getNgaySinh();
    LocalDate ngayTuyenDung = nv.getNgayTuyenDung();
    int namSinh = ngaySinh.getYear();
    int namHienTai = ngayHienTai.getYear();
    if (nv.getSdt().matches("0[0-9]{9}") == false) {
      return 1;
    } else if (ngayTuyenDung.isAfter(ngayHienTai)) {
      return 2;
    } else if (ngaySinh.isAfter(ngayHienTai)) {
      return 4;
    } else if (namHienTai - namSinh < 18) {
      return 5;
    }
    return 0;
  }

  public Boolean themNV(NhanVien nv) {
    if (taiKhoanDAO.themTaiKhoan(nv.getTaiKhoan()) &&
        nhanVienDAO.themNhanVien(nv)) {
      return true;
    } else {
      return false;
    }
  }

  public Boolean suaNV(NhanVien nv) {
    if (nhanVienDAO.suaNhanVien(nv)) {
      return true;
    } else {
      return false;
    }
  }

  public Boolean xoaNV(String maNV, String email) {
    if (nhanVienDAO.xoaNhanVien(maNV) && taiKhoanDAO.xoaTaiKhoan(email)) {
      return true;
    } else {
      return false;
    }
  }
}