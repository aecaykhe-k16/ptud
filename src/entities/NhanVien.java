package entities;

import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.util.Date;

public class NhanVien {
  /**
   * attributes
   */
  private String maNV;
  private String tenNV;
  private String sdt;
  private LocalDate ngaySinh;
  private Boolean gioiTinh;
  private LocalDate ngayTuyenDung;
  private String viTriCongViec;
  private String diaChi;
  private boolean trangThai;

  /**
   * relationship
   */
  private TaiKhoan taiKhoan;
  private NhanVien quanLy;

  public NhanVien() {
    super();
  }

  public NhanVien(String maNV, boolean trangThai) {
    this.maNV = maNV;
    this.trangThai = trangThai;
  }

  public NhanVien(String maNV, String tenNV, String sdt, LocalDate ngaySinh, Boolean gioiTinh, LocalDate ngayTuyenDung,
      String viTriCongViec, String diaChi, boolean trangThai) {
    super();
    this.maNV = maNV;
    this.tenNV = tenNV;
    this.sdt = sdt;
    this.ngaySinh = ngaySinh;
    this.gioiTinh = gioiTinh;
    this.ngayTuyenDung = ngayTuyenDung;
    this.viTriCongViec = viTriCongViec;
    this.diaChi = diaChi;
    this.trangThai = trangThai;
  }

  public NhanVien(String maNV, String tenNV, String sdt, LocalDate ngaySinh, Boolean gioiTinh, LocalDate ngayTuyenDung,
      String viTriCongViec, String diaChi) {
    super();
    this.maNV = maNV;
    this.tenNV = tenNV;
    this.sdt = sdt;
    this.ngaySinh = ngaySinh;
    this.gioiTinh = gioiTinh;
    this.ngayTuyenDung = ngayTuyenDung;
    this.viTriCongViec = viTriCongViec;
    this.diaChi = diaChi;

  }

  public String getMaNV() {
    return maNV;
  }

  public void setMaNV(String maNV) {
    this.maNV = maNV;
  }

  public String getTenNV() {
    return tenNV;
  }

  public void setTenNV(String tenNV) throws Exception {
    if (tenNV.isEmpty())
      throw new Exception("Tên nhân viên không được để trống");
    else
      this.tenNV = tenNV;
  }

  public String getSdt() {
    return sdt;
  }

  public void setSdt(String sdt) throws Exception {
    if (sdt.isEmpty())
      throw new Exception("Số điện thoại không được để trống");
    else if (sdt.matches("0[0-9]{9}") == false)
      throw new Exception("Số điện thoại không hợp lệ(gồm 10 số không chưa ký tự chữ) và phải bắt đầu bằng số 0");
    else
      this.sdt = sdt;
  }

  public LocalDate getNgaySinh() {
    return ngaySinh;
  }

  public void setNgaySinh(LocalDate ngaySinh) throws Exception {
    SimpleDateFormat dinhDangNgaySinh = new SimpleDateFormat("yyyy");
    String ns = dinhDangNgaySinh.format(ngaySinh);
    Date ngayHienTai = new Date();
    String nht = dinhDangNgaySinh.format(ngayHienTai);
    if (Integer.parseInt(ns) > Integer.parseInt(nht))
      throw new Exception("Ngày sinh không được lớn hơn ngày hiện tại");
    else if (Integer.parseInt(nht) - Integer.parseInt(ns) <= 18)
      throw new Exception("Nhân viên phải từ 18 tuổi trở lên");
    else
      this.ngaySinh = ngaySinh;
  }

  public Boolean getGioiTinh() {
    return gioiTinh;
  }

  public void setGioiTinh(Boolean gioiTinh) {
    this.gioiTinh = gioiTinh == true ? true : false;
  }

  public LocalDate getNgayTuyenDung() {
    return ngayTuyenDung;
  }

  public void setNgayTuyenDung(LocalDate ngayTuyenDung) throws Exception {
    SimpleDateFormat dinhDangNgaySinh = new SimpleDateFormat("dd/MM/yyyy");
    String ntd = dinhDangNgaySinh.format(ngayTuyenDung);
    LocalDate ngayHienTai = LocalDate.now();

    String nht = dinhDangNgaySinh.format(ngayHienTai);
    if (ngayTuyenDung.isBefore(ngayHienTai) || ntd.equals(nht))
      this.ngayTuyenDung = ngayTuyenDung;
    else
      throw new Exception("Ngày tuyển dụng không được lớn hơn ngày hiện tại");
  }

  public String getViTriCongViec() {
    return viTriCongViec;
  }

  public void setViTriCongViec(String viTriCongViec) {
    this.viTriCongViec = viTriCongViec;
  }

  public TaiKhoan getTaiKhoan() {
    return taiKhoan;
  }

  public void setTaiKhoan(TaiKhoan taiKhoan) {
    this.taiKhoan = taiKhoan;
  }

  public NhanVien getQuanLy() {
    return quanLy;
  }

  public void setQuanLy(NhanVien quanLy) {
    this.quanLy = quanLy;
  }

  public String getDiaChi() {
    return diaChi;
  }

  public void setDiaChi(String diaChi) {
    this.diaChi = diaChi;
  }

  public boolean getTrangThai() {
    return trangThai;
  }

  public void setTrangThai(boolean trangThai) {
    this.trangThai = trangThai;
  }

  @Override
  public String toString() {
    return "NhanVien [maNV=" + maNV + ", tenNV=" + tenNV + ", sdt=" + sdt + ", ngaySinh=" + ngaySinh + ", gioiTinh="
        + gioiTinh + ", ngayTuyenDung=" + ngayTuyenDung + ", viTriCongViec=" + viTriCongViec + ", diaChi=" + diaChi
        + ", taiKhoan=" + taiKhoan + ", quanLy=" + quanLy + "]";
  }

}
