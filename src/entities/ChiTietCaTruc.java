package entities;

import java.time.LocalDate;

public class ChiTietCaTruc {
  /**
   * attributes
   */
  private LocalDate ngayPhanCa;
  private String trangThaiCaTruc;

  /**
   * relationship
   */
  private CaTruc caTruc;
  private NhanVien nv;

  public ChiTietCaTruc() {
  }

  public ChiTietCaTruc(LocalDate ngayPhanCa, String trangThaiCaTruc) {
    this.ngayPhanCa = ngayPhanCa;
    this.trangThaiCaTruc = trangThaiCaTruc;
  }

  public LocalDate getNgayPhanCa() {
    return ngayPhanCa;
  }

  public void setNgayPhanCa(LocalDate ngayPhanCa) throws Exception {
    if (ngayPhanCa.compareTo(LocalDate.now()) > 0)
      this.ngayPhanCa = ngayPhanCa;
    else
      throw new Exception("Ngày phân ca không hợp lệ");
  }

  public String getTrangThaiCaTruc() {
    return trangThaiCaTruc;
  }

  public void setTrangThaiCaTruc(String trangThaiCaTruc) {
    this.trangThaiCaTruc = trangThaiCaTruc;
  }

  public CaTruc getCaTruc() {
    return caTruc;
  }

  public void setCaTruc(CaTruc caTruc) {
    this.caTruc = caTruc;
  }

  public NhanVien getNv() {
    return nv;
  }

  public void setNv(NhanVien nv) {
    this.nv = nv;
  }

  @Override
  public String toString() {
    return "ChiTietCaTruc [ngayPhanCa=" + ngayPhanCa + ", trangThaiCaTruc=" + trangThaiCaTruc + "]";
  }

}
