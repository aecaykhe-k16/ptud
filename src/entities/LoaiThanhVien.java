package entities;

import java.time.LocalDate;

public class LoaiThanhVien {
  /**
   * attributes
   */
  private String maLoaiTV;
  private String tenLoaiTV;
  private int uuDai;
  private LocalDate ngayDangKy;
  private LocalDate ngayHetHan;
  private String soDinhDanh;

  public LoaiThanhVien() {
    super();
  }

  public LoaiThanhVien(String tenLoaiTV, int uuDai) {
    this.tenLoaiTV = tenLoaiTV;
    this.uuDai = uuDai;
  }

  public LoaiThanhVien(String maLoaiTV, String tenLoaiTV, int uuDai, LocalDate ngayDangKy, LocalDate ngayHetHan,
      String soDinhDanh) {
    super();
    this.maLoaiTV = maLoaiTV;
    this.tenLoaiTV = tenLoaiTV;
    this.uuDai = uuDai;
    this.ngayDangKy = ngayDangKy;
    this.ngayHetHan = ngayHetHan;
    this.soDinhDanh = soDinhDanh;
  }

  public String getMaLoaiTV() {
    return maLoaiTV;
  }

  public void setMaLoaiTV(String maLoaiTV) {
    this.maLoaiTV = maLoaiTV;
  }

  public String getTenLoaiTV() {
    return tenLoaiTV;
  }

  public void setTenLoaiTV(String tenLoaiTV) throws Exception {
    if (!tenLoaiTV.isEmpty())
      this.tenLoaiTV = tenLoaiTV;
    else
      throw new Exception("Tên loại thành viên không được để trống");
  }

  public int getUuDai() {
    return uuDai;
  }

  public void setUuDai(int uuDai) {
    this.uuDai = uuDai;
  }

  public LocalDate getNgayDangKy() {
    return ngayDangKy;
  }

  public void setNgayDangKy(LocalDate ngayDangKy) throws Exception {
    this.ngayDangKy = ngayDangKy;
  }

  public LocalDate getNgayHetHan() {
    return ngayHetHan;
  }

  public void setNgayHetHan(LocalDate ngayHetHan) throws Exception {
    this.ngayHetHan = ngayHetHan;
  }

  public String getSoDinhDanh() {
    return soDinhDanh;
  }

  public void setSoDinhDanh(String soDinhDanh) throws Exception {
    if (!soDinhDanh.isEmpty())
      this.soDinhDanh = soDinhDanh;
    else if (soDinhDanh.length() != 12)
      throw new Exception("Số định danh phải gồm 12 ký tự");
    else
      throw new Exception("Số định danh không được để trống");
  }

  @Override
  public String toString() {
    return "LoaiThanhVien [maLoaiTV=" + maLoaiTV + ", ngayDangKy=" + ngayDangKy + ", ngayHetHan=" + ngayHetHan
        + ", soDinhDanh=" + soDinhDanh + ", tenLoaiTV=" + tenLoaiTV + ", uuDai=" + uuDai + "]";
  }

}
