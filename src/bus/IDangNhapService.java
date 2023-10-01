package bus;

import entities.NhanVien;
import entities.TaiKhoan;

public interface IDangNhapService {
  boolean login(TaiKhoan tk);

  boolean doiMK(TaiKhoan taiKhoan);

  NhanVien getNV(String email);
}
