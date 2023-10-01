package entities;

public class ChiTietHoaDon {
  /**
   * attributes
   */
  private int thoiGianSuDung;

  /**
   * relationship
   */
  private Phong phong;

  public ChiTietHoaDon() {
    super();
  }

  public ChiTietHoaDon(int thoiGianSuDung) {
    super();
    this.thoiGianSuDung = thoiGianSuDung;
  }

  public ChiTietHoaDon(int thoiGianSuDung, Phong phong) {
    super();
    this.thoiGianSuDung = thoiGianSuDung;
    this.phong = phong;
  }

  public int getThoiGianSuDung() {
    return thoiGianSuDung;
  }

  public void setThoiGianSuDung(int thoiGianSuDung) {
    if (thoiGianSuDung < 0) {
      try {
        throw new Exception("Thời gian sử dụng phải lớn hơn 0");
      } catch (Exception e) {
        e.printStackTrace();
      }
    } else
      this.thoiGianSuDung = thoiGianSuDung;
  }

  public Phong getPhong() {
    return phong;
  }

  public void setPhong(Phong phong) {
    this.phong = phong;
  }

  @Override
  public String toString() {
    return "ChiTietHoaDon [thoiGianSuDung=" + thoiGianSuDung + ", phong=" + phong + "]";
  }

  public double tinhTien() {
    return getThoiGianSuDung() * phong.getgiaPhong();
  }

}
