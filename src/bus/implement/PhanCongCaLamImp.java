package bus.implement;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

import bus.IPhanCongCaLamService;
import dao.CaTrucDao;
import entities.CaTruc;
import entities.ChiTietCaTruc;

public class PhanCongCaLamImp implements IPhanCongCaLamService {
  private CaTrucDao dao = new CaTrucDao();

  @Override
  public boolean themCaTruc(CaTruc ca) {
    return dao.themCaTruc(ca);
  }

  @Override
  public List<ChiTietCaTruc> getDanhSachCTCaTruc() {
    return dao.getDsCTCaTruc();
  }

  @Override
  public List<ChiTietCaTruc> timDanhSaChiTietCaTrucs(int option, LocalDate dateNgayStart, String thoiGianTruc,
      String tenNV) {
    List<ChiTietCaTruc> dsCaTruc = new ArrayList<ChiTietCaTruc>();
    for (ChiTietCaTruc chiTietCaTruc : dao.getDsCTCaTruc()) {
      if (option == 0) {
        if (dateNgayStart.toString().equals(chiTietCaTruc.getNgayPhanCa().toString())) {
          dsCaTruc.add(chiTietCaTruc);
        }
      } else if (option == 1) {
        if (thoiGianTruc.equals(chiTietCaTruc.getCaTruc().getThoiGianCaTruc().toString().trim())) {
          dsCaTruc.add(chiTietCaTruc);
        }
      } else if (option == 2) {
        if (tenNV.equals(chiTietCaTruc.getNv().getTenNV())) {
          dsCaTruc.add(chiTietCaTruc);
        }
      }
    }
    return dsCaTruc;
  }

  @Override
  public boolean themChiTietCaTruc(ChiTietCaTruc ca) {
    boolean kt = dao.themChiTietCaTruc(ca);
    if (kt == false)
      kt = false;
    else
      kt = true;
    return kt;
  }

  @Override
  public List<CaTruc> getDanhSachCaTruc() {
    return dao.getCaTruc();
  }

  @Override
  public String getCaTucTheoNV(String email) {
    List<CaTruc> ds = dao.timCaTrucTheoNhanVien(email);

    String caTruc = "";
    for (CaTruc ca : ds) {
      for (CaTruc ct : getDanhSachCaTruc()) {
        if (ca.getMaCaTruc().equals(ct.getMaCaTruc())) {
          String[] thoiGian = ca.getThoiGianCaTruc().split(" ");
          LocalDate ngay = LocalDate.parse(thoiGian[0]);
          if (ngay.isEqual(LocalDate.now())) {
            caTruc += "Ca: " + ct.getThoiGianCaTruc().trim() + "... ";
          }
        }
      }
    }
    if (caTruc.equals(""))
      return "Bạn không có ca trực trong ngày....";
    return caTruc;
  }

  @Override
  public boolean capNhatChiTietCaTruc(ChiTietCaTruc chiTietCT, String maCT, String maNV) {
    dao.capNhatChiTietCaTruc(chiTietCT, maCT, maNV);
    return true;
  }

  @Override
  public boolean xoaChiTietCaTruc(String maCaTruc, String maNV) {
    dao.xoaChiTietCaTruc(maCaTruc, maNV);
    return true;
  }

}