package bus.implement;

import bus.IDangNhapService;
import dao.DangNhapDao;
import entities.NhanVien;
import entities.TaiKhoan;

public class DangNhapImp implements IDangNhapService {
  private DangNhapDao dangNhapDao = new DangNhapDao();

  @Override
  public boolean login(TaiKhoan tk) {
    if (tk.getMatKhau().isEmpty())
      return false;
    else if (!tk.getMatKhau().matches("^[a-zA-Z0-9]*$"))
      return false;
    else {
      boolean login = dangNhapDao.login(tk);
      if (login) {
        return true;
      } else {
        return false;
      }
    }
  }

  @Override
  public NhanVien getNV(String email) {
    return dangNhapDao.getNV(email);
  }

  @Override
  public boolean doiMK(TaiKhoan taiKhoan) {
    return dangNhapDao.doiMK(taiKhoan);
  }

}
