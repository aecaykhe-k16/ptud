package bus;

import java.time.LocalDate;
import java.util.List;

import entities.CaTruc;
import entities.ChiTietCaTruc;

public interface IPhanCongCaLamService {
  List<CaTruc> getDanhSachCaTruc();

  boolean capNhatChiTietCaTruc(ChiTietCaTruc chiTietCT, String maCT, String maNV);

  String getCaTucTheoNV(String email);

  boolean themCaTruc(CaTruc ca);

  boolean themChiTietCaTruc(ChiTietCaTruc ca);

  List<ChiTietCaTruc> getDanhSachCTCaTruc();

  List<ChiTietCaTruc> timDanhSaChiTietCaTrucs(int option, LocalDate dateNgayStart, String thoiGiangTruc, String tenNV);

  boolean xoaChiTietCaTruc(String maCaTruc, String maNV);
}