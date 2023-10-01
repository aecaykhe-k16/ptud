package entities;

public enum TrangThaiPhongEnum {

  TRONG("Trống"),
  DAT_TRUOC("Đặt trước"),
  HOAT_DONG("Hoạt động");

  private String trangThai;

  private TrangThaiPhongEnum(String trangThai) {
    this.trangThai = trangThai;
  }

  public String getTtrangThai() {
    return trangThai;
  }

}