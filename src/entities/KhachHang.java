package entities;

public class KhachHang {
  /**
   * attributes
   */
  private String maKH;
  private String tenKH;
  private String sdt;
  private Boolean gioiTinh;
  private String diaChi;
  private boolean trangThai;

  /**
   * relationship
   */
  private LoaiThanhVien loaiTV;

  public KhachHang() {
    super();
  }

  public KhachHang(String maKH, String tenKH, String sdt, boolean trangThai) {
    super();
    this.maKH = maKH;
    this.tenKH = tenKH;
    this.sdt = sdt;
    this.trangThai = trangThai;
  }

  public KhachHang(String tenKH) {
    super();
    this.tenKH = tenKH;
  }

  public KhachHang(String maKH, String tenKH, String sdt, Boolean gioiTinh, String diaChi, boolean trangThai) {
    super();
    this.maKH = maKH;
    this.tenKH = tenKH;
    this.sdt = sdt;
    this.gioiTinh = gioiTinh;
    this.diaChi = diaChi;
    this.trangThai = trangThai;

  }

  public String getMaKH() {
    return maKH;
  }

  public void setMaKH(String maKH) {
    this.maKH = maKH;
  }

  public String getTenKH() {
    return tenKH;
  }

  public void setTenKH(String tenKH) throws Exception {
    if (tenKH.isEmpty())
      throw new Exception("Tên khách hàng không được để trống");
    else
      this.tenKH = tenKH;
  }

  public String getSdt() {
    return sdt;
  }

  public void setSdt(String sdt) throws Exception {
    if (sdt.matches(".*[!@#$%^&*()_+|~=`{}\\[\\]:\";'<>?,.\\/].*")
        || !sdt.matches("[0-9]{10}$") || !sdt.startsWith("0")) {
      throw new Exception("Số điện thoại không được chứa các ký tự đặc biệt, ký tự chữ và phải bắt đầu bằng số 0");
    } else
      this.sdt = sdt;
  }

  public Boolean getGioiTinh() {
    return gioiTinh;
  }

  public void setGioiTinh(Boolean gioiTinh) throws Exception {
    this.gioiTinh = gioiTinh;
  }

  public LoaiThanhVien getLoaiTV() {
    return loaiTV;
  }

  public void setLoaiTV(LoaiThanhVien loaiTV) {
    this.loaiTV = loaiTV;
  }

  public String getDiaChi() {
    return diaChi;
  }

  public void setDiaChi(String diaChi) {
    this.diaChi = diaChi;
  }

  @Override
  public String toString() {
    return "KhachHang [maKH=" + maKH + ", tenKH=" + tenKH + ", sdt=" + sdt + ", gioiTinh=" + gioiTinh + ", diaChi="
        + diaChi + ", trangThai=" + trangThai + "]";
  }

  public boolean isTrangThai() {
    return trangThai;
  }

  public void setTrangThai(boolean trangThai) {
    this.trangThai = trangThai;
  }

}
