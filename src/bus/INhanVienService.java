package bus;

import java.util.List;

import entities.NhanVien;

public interface INhanVienService {
  List<NhanVien> dsNV();

  int kiemTraThongTin(NhanVien nv);

  Boolean themNV(NhanVien nv);

  Boolean suaNV(NhanVien nv);

  Boolean xoaNV(String maNV, String email);
}
