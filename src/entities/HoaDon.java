package entities;

import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.util.Date;
import java.util.List;

public class HoaDon {
  /**
   * attributes
   */
  private String maHD;
  private LocalDateTime ngayLapHD;

  /**
   * relationship
   */
  private List<ChiTietDichVu> CTDV;
  private List<ChiTietHoaDon> CTHD;
  private KhachHang khachHang;
  private NhanVien nhanVien;

  public HoaDon() {
    super();
  }

  public HoaDon(String maHD, LocalDateTime ngayLapHD) {
    super();
    this.maHD = maHD;
    this.ngayLapHD = ngayLapHD;

  }

  public String getMaHD() {
    return maHD;
  }

  public void setMaHD(String maHD) {
    this.maHD = maHD;
  }

  public LocalDateTime getNgayLapHD() {
    return ngayLapHD;
  }

  public void setNgayLapHD(LocalDateTime ngayLapHD) throws Exception {
    SimpleDateFormat dinhDangNgaySinh = new SimpleDateFormat("dd/MM/yyyy");
    String ntd = dinhDangNgaySinh.format(ngayLapHD);
    Date ngayHienTai = new Date();
    String nht = dinhDangNgaySinh.format(ngayHienTai);
    if (ntd.equals(nht))
      this.ngayLapHD = ngayLapHD;
    else
      throw new Exception("Ngày lập hóa đơn phải là ngày hiện tại");
  }

  public List<ChiTietDichVu> getCTDV() {
    return CTDV;
  }

  public void setCTDV(List<ChiTietDichVu> cTDV) {
    CTDV = cTDV;
  }

  public List<ChiTietHoaDon> getCTHD() {
    return CTHD;
  }

  public void setCTHD(List<ChiTietHoaDon> cTHD) {
    CTHD = cTHD;
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

  @Override
  public String toString() {
    return "HoaDon [maHD=" + maHD + ", ngayLapHD=" + ngayLapHD + ", CTDV=" + CTDV + ", CTHD=" + CTHD + ", khachHang="
        + khachHang + ", nhanVien=" + nhanVien + "]";
  }

  public double tinhTongTien() {
    double tongTien = 0;
    for (ChiTietHoaDon cthd : CTHD) {
      tongTien += cthd.tinhTien();
    }
    for (ChiTietDichVu ctdv : CTDV) {
      tongTien += ctdv.tinhTien();
    }
    return tongTien;
  }

}
