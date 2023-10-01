package entities;

import java.util.Date;

public class DatPhong {
  /**
   * attributes
   */
  private String maDP;
  private Date ngayDatPhong;
  private Date gioNhanPhong;

  /**
   * relationship
   */
  private KhachHang khachHang;
  private NhanVien nhanVien;
  private Phong phong;

  public DatPhong() {
    super();
  }

  public DatPhong(String maDP, Date ngayDatPhong, Date gioNhanPhong) {
    super();
    this.maDP = maDP;
    this.ngayDatPhong = ngayDatPhong;
    this.gioNhanPhong = gioNhanPhong;
  }

  public String getMaDP() {
    return maDP;
  }

  public void setMaDP(String maDP) {
    this.maDP = maDP;
  }

  public Date getngayDatPhong() {
    return ngayDatPhong;
  }

  public void setngayDatPhong(Date ngayDatPhong) {

    this.ngayDatPhong = ngayDatPhong;
  }

  public Date getGioNhanPhong() {
    return gioNhanPhong;
  }

  public void setGioNhanPhong(Date gioNhanPhong) throws Exception {
    this.gioNhanPhong = gioNhanPhong;
  }

  public KhachHang getKhachHang() {
    return khachHang;
  }

  public void setKhachHang(KhachHang khachHang) {
    this.khachHang = khachHang;
  }

  public NhanVien getNhanVien() {
    return nhanVien;
  }

  public void setNhanVien(NhanVien nhanVien) {
    this.nhanVien = nhanVien;
  }

  public Phong getPhong() {
    return phong;
  }

  public void setPhong(Phong phong) {
    this.phong = phong;
  }

  @Override
  public String toString() {
    return "DatPhong [ngayDatPhong=" + ngayDatPhong + ", gioNhanPhong=" + gioNhanPhong + ", khachHang=" + khachHang
        + ", maDP=" + maDP + ", nhanVien=" + nhanVien + ", phong=" + phong + "]";
  }

}
