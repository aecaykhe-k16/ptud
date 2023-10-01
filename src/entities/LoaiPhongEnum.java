package entities;

public enum LoaiPhongEnum {
  THUONG("Thường"), VIP("VIP");

  private String loaiPhong;

  private LoaiPhongEnum(String loaiPhong) {
    this.loaiPhong = loaiPhong;
  }

  public String getLoaiPhong() {
    return loaiPhong;
  }

}
