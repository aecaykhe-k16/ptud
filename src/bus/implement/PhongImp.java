package bus.implement;

import java.util.List;

import bus.IPhongService;
import dao.DatPhongDao;
import dao.PhongDao;
import entities.DatPhong;
import entities.Phong;

public class PhongImp implements IPhongService {

  private PhongDao phongDao = new PhongDao();
  private DatPhongDao datPhongImp = new DatPhongDao();

  @Override
  public List<Phong> dsPhong() {
    return phongDao.dsPhong();
  }

  @Override
  public int validator(String chieuRong, String chieuDai, String tenTV, String tenBan, String tenPhong,
      String tenSofa) {
    if (chieuRong.isEmpty()) {
      return 1;
    } else if (chieuDai.isEmpty()) {
      return 2;
    } else if (tenTV.isEmpty()) {
      return 3;
    } else if (tenBan.isEmpty()) {
      return 4;
    } else if (tenPhong.isEmpty()) {
      return 5;
    } else if (tenSofa.isEmpty()) {
      return 6;
    } else if (!chieuRong.matches("^[0-9]+(.[0-9]+)?$")) {
      return 7;
    } else if (!chieuDai.matches("^[0-9]+(.[0-9]+)?$")) {
      return 8;
    } else if (Double.parseDouble(chieuRong) < 0) {
      return 9;
    } else if (Double.parseDouble(chieuDai) < 0) {
      return 10;
    } else if (tenTV.matches(".*[!@#$%^&*()_+|~=`{}\\[\\]:\";'<>?,.\\/].*")) {
      return 11;
    } else if (tenBan.matches(".*[!@#$%^&*()_+|~=`{}\\[\\]:\";'<>?,.\\/].*")) {
      return 12;
    } else if (tenPhong.matches(".*[!@#$%^&*()_+|~=`{}\\[\\]:\";'<>?,.\\/].*")) {
      return 13;
    } else if (tenSofa.matches(".*[!@#$%^&*()_+|~=`{}\\[\\]:\";'<>?,.\\/].*")) {
      return 14;
    }

    return 0;
  }

  @Override
  public boolean themPhong(Phong phong) {
    return phongDao.themPhong(phong) ? true : false;
  }

  @Override
  public boolean xoaPhong(String maPhong) {
    return phongDao.xoaPhong(maPhong) ? true : false;
  }

  @Override
  public boolean suaPhong(Phong phong) {
    return phongDao.suaPhong(phong) ? true : false;
  }

  @Override
  public List<Phong> updateStatus(String maPhong, String ttPhong) {
    phongDao.updateStatus(maPhong, ttPhong);
    return dsPhong();

  }

  @Override
  public void traPhong(String maPhong, String trangThai) {
    for (DatPhong dp : datPhongImp.dsPhongDat()) {
      if (dp.getPhong().getMaPhong().equals(maPhong))
        phongDao.updateSoLanDatTruoc(maPhong);
    }
    phongDao.updateStatus(maPhong, trangThai);
  }

}
