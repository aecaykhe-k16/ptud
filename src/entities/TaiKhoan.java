package entities;

public class TaiKhoan {
  private String email;
  private String matKhau;
  private boolean trangThai;

  public TaiKhoan() {
    super();
  }

  public TaiKhoan(String email) {
    super();
    this.email = email;
  }

  public TaiKhoan(String email, String matKhau, boolean trangThai) {
    super();
    this.email = email;
    this.matKhau = matKhau;
    this.trangThai = trangThai;
  }

  public TaiKhoan(String email, String matKhau) {
    super();
    this.email = email;
    this.matKhau = matKhau;
  }

  public String getEmail() {
    return email;
  }

  public String getMatKhau() {
    return matKhau;
  }

  public boolean getTrangThai() {
    return trangThai;
  }

  public void setEmail(String email) throws Exception {
    String regex = "^[A-Za-z0-9+_.-]+@(.+)$";
    if (email.isEmpty() || !email.matches(regex))
      throw new Exception("Email không hợp lệ");
    else
      this.email = email;
  }

  public void setMatKhau(String matKhau) throws Exception {
    if (matKhau.isEmpty())
      throw new Exception("Mật khẩu không được để trống");
    else
      this.matKhau = matKhau;
  }

  public void setTrangThai(boolean trangThai) {
    this.trangThai = trangThai;
  }

  @Override
  public String toString() {
    return "TaiKhoan [email=" + email + ", matKhau=" + matKhau + ", trangThai=" + trangThai + "]";
  }

}
