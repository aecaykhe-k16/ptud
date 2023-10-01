
package bus.implement;

import java.util.ArrayList;
import java.util.LinkedList;
import java.util.List;

import bus.IKhachHangService;
import dao.KhachHangDao;
import entities.KhachHang;

public class KhachHangImp implements IKhachHangService {
  private KhachHangDao khachhangDAO = new KhachHangDao();
  List<KhachHang> dsKH = new LinkedList<KhachHang>();

  @Override
  public List<KhachHang> dsKH() {
    List<KhachHang> ds = new ArrayList<>();
    for (KhachHang nv : khachhangDAO.dsKh()) {
      if (nv.isTrangThai()) {
        ds.add(nv);
      }
    }
    return ds;
  }

  public boolean kiemtra(KhachHang kh) {
    if (kh.getTenKH().equals("") || kh.getSdt().equals("")
        || kh.getLoaiTV().getSoDinhDanh().equals("") || kh.getDiaChi().equals("")) {

      return false;
    }
    return true;
  }

  public int kiemtraKH(String txtsdt, String txtsoDinhDanh) {
    if (txtsdt.length() != 10) {
      return 1;
    } else if (txtsoDinhDanh.length() != 12) {
      return 2;
    }
    return 0;

  }

  public boolean suaKh(KhachHang kh) {
    return khachhangDAO.suaKhachHang(kh) ? true : false;
  }

  @Override
  public boolean xoaKH(String makh) {
    try {
      khachhangDAO.xoaKH(makh);
      return true;
    } catch (Exception e) {
      return false;
    }
  }

  @Override
  public KhachHang timKhachHang(String sdt) {
    for (KhachHang kh : dsKH()) {
      if (sdt.length() == 10) {
        if (kh.getSdt().equals(sdt))
          return kh;
      } else {
        if (kh.getMaKH().equals(sdt))
          return kh;
      }
    }
    return null;
  }

  @Override
  public boolean themKhachHang(KhachHang kh) {
    if (khachhangDAO.themKH(kh)) {
      if (kh.getLoaiTV() != null)
        khachhangDAO.themLoaiThanhVien(kh);
      return true;
    }
    return false;
  }

  @Override
  public boolean capNhatLoaiTV(KhachHang kh) {
    return khachhangDAO.capNhatLoaiTV(kh);
  }
}