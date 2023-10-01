package entities;

public class DichVu {
  /**
   * attributes
   */
  private String maDichVu;
  private String tenDichVu;
  private double giaDichVu;
  private int slTon;
  private String hinhAnh;

  public DichVu() {
    super();
  }

  public DichVu(String maDV) {
    super();
    this.maDichVu = maDV;
  }

  public DichVu(String maDichVu, String tenDichVu, double giaDichVu, int slTon, String hinhAnh) {
    super();
    this.maDichVu = maDichVu;
    this.tenDichVu = tenDichVu;
    this.giaDichVu = giaDichVu;
    this.slTon = slTon;
    this.hinhAnh = hinhAnh;
  }

  public DichVu(String tenDichVu, double giaDichVu) {
    super();
    this.tenDichVu = tenDichVu;
    this.giaDichVu = giaDichVu;
  }

  public String getMaDichVu() {
    return maDichVu;
  }

  public void setMaDichVu(String maDichVu) {
    this.maDichVu = maDichVu;
  }

  public String getTenDichVu() {
    return tenDichVu;
  }

  public void setTenDichVu(String tenDichVu) {
    if (tenDichVu.isEmpty()) {
      try {
        throw new Exception("Tên dịch vụ không rỗng");
      } catch (Exception e) {
        e.printStackTrace();
      }
    } else
      this.tenDichVu = tenDichVu;
  }

  public double getGiaDichVu() {
    return giaDichVu;
  }

  public void setGiaDichVu(double giaDichVu) {
    if (giaDichVu < 0 && String.valueOf(giaDichVu).isEmpty()) {
      try {
        throw new Exception("Giá dịch vụ phải lớn hơn 0 và không rỗng");
      } catch (Exception e) {
        e.printStackTrace();
      }
    } else
      this.giaDichVu = giaDichVu;
  }

  public int getSlTon() {
    return slTon;
  }

  public void setSlTon(int slTon) {
    if (slTon < 0 && String.valueOf(slTon).isEmpty()) {
      try {
        throw new Exception("Số lượng tồn phải lớn hơn 0 và không rỗng");
      } catch (Exception e) {
        e.printStackTrace();
      }
    } else
      this.slTon = slTon;
    this.slTon = slTon;
  }

  public String getHinhAnh() {
    return hinhAnh;
  }

  public void setHinhAnh(String hinhAnh) {
    if (hinhAnh.isEmpty()) {
      try {
        throw new Exception("Hình ảnh không rỗng");
      } catch (Exception e) {
        e.printStackTrace();
      }
    } else
      this.hinhAnh = hinhAnh;
  }

  @Override
  public String toString() {
    return "DichVu [maDichVu=" + maDichVu + ", tenDichVu=" + tenDichVu + ", giaDichVu=" + giaDichVu + ", slTon=" + slTon
        + "]";
  }

}
