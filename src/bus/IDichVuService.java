package bus;

import java.util.List;

import entities.DichVu;

public interface IDichVuService {
  List<DichVu> dsDichVu();

  int kiemTraDuLieu(String gia, String soLuong);

  boolean themDichVu(DichVu dv);

  boolean suaDichVu(DichVu dv);

  boolean xoaDichVu(String maDV);
}