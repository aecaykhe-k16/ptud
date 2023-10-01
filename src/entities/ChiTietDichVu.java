package entities;

public class ChiTietDichVu {
  /**
   * attributes
   */
  private int soLuong;

  /**
   * relationship
   */
  private DichVu dichVu;

  public ChiTietDichVu() {
    super();
  }

  public ChiTietDichVu(int soLuong) {
    super();
    this.soLuong = soLuong;
  }

  public ChiTietDichVu(int soLuong, DichVu dichVu) {
    super();
    this.soLuong = soLuong;
    this.dichVu = dichVu;
  }

  public int getSoLuong() {
    return soLuong;
  }

  public void setSoLuong(int soLuong) throws Exception {
    if ((soLuong > 0))
      this.soLuong = soLuong;
    else
      throw new Exception("Số lượng phải hơn 0");
  }

  public DichVu getDichVu() {
    return dichVu;
  }

  public void setDichVu(DichVu dichVu) {
    this.dichVu = dichVu;
  }

  @Override
  public String toString() {
    return "ChiTietDichVu [dichVu=" + dichVu + ", soLuong=" + soLuong + "]";
  }

  public double tinhTien() {
    return soLuong * dichVu.getGiaDichVu();
  }

}
