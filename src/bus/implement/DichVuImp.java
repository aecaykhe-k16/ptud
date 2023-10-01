package bus.implement;

import java.util.ArrayList;
import java.util.List;

import bus.IDichVuService;
import dao.DichVuDao;
import entities.DichVu;

public class DichVuImp implements IDichVuService {
  DichVuDao dichVuDAO = new DichVuDao();
  List<DichVu> dsDichVu = new ArrayList<DichVu>();

  @Override
  public List<DichVu> dsDichVu() {
    dsDichVu = dichVuDAO.getDichVu();
    for (DichVu dichVu : dsDichVu) {
      if (dichVu.getSlTon() == 0)
        dichVu.setSlTon(0);
    }
    return dsDichVu;
  }

  @Override
  public int kiemTraDuLieu(String gia, String soLuong) {
    if (gia.matches("[0-9]+") == false) {
      return 1;
    } else if (soLuong.matches("[0-9]+") == false) {
      return 2;
    } else {
      return 0;
    }
  }

  @Override
  public boolean themDichVu(DichVu dv) {
    if (dichVuDAO.themDichVu(dv)) {
      return true;
    } else {
      return false;
    }
  }

  @Override
  public boolean suaDichVu(DichVu dv) {
    if (dichVuDAO.suaDichVu(dv)) {
      return true;
    } else {
      return false;
    }
  }

  @Override
  public boolean xoaDichVu(String maDV) {
    if (dichVuDAO.xoaDichVu(maDV)) {
      return true;
    } else {
      return false;
    }
  }

}