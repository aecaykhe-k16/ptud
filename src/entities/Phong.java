package entities;

public class Phong {
  /**
   * attributes
   */
  private String maPhong;
  private String tenPhong;
  private double giaPhong;
  private int sucChua;
  private double chieuRong;
  private double chieuDai;
  private String tenTV;
  private String tenBan;
  private String tenSofa;
  private int soLuongSofa;
  private int soLuongLoa;
  private int soLanDatTruoc;

  /**
   * relationship
   */

  private TrangThaiPhongEnum ttPhong;
  private LoaiPhongEnum loaiPhong;

  public Phong() {
    super();
  }

  public Phong(String maPhong, String tenPhong, double giaPhong, int sucChua, TrangThaiPhongEnum ttPhong,
      LoaiPhongEnum loaiPhong) {
    this.maPhong = maPhong;
    this.tenPhong = tenPhong;
    this.giaPhong = giaPhong;
    this.sucChua = sucChua;
    this.ttPhong = ttPhong;
    this.loaiPhong = loaiPhong;
  }

  public Phong(String maPhong, String tenPhong, double giaPhong, int sucChua, double chieuRong, double chieuDai,
      String tenTV, String tenBan, String tenSofa, int soLuongSofa, int soLuongLoa, TrangThaiPhongEnum ttPhong,
      LoaiPhongEnum loaiPhong) {
    this.maPhong = maPhong;
    this.tenPhong = tenPhong;
    this.giaPhong = giaPhong;
    this.sucChua = sucChua;
    this.chieuRong = chieuRong;
    this.chieuDai = chieuDai;
    this.tenTV = tenTV;
    this.tenBan = tenBan;
    this.tenSofa = tenSofa;
    this.soLuongSofa = soLuongSofa;
    this.soLuongLoa = soLuongLoa;
    this.ttPhong = ttPhong;
    this.loaiPhong = loaiPhong;
  }

  public Phong(String maPhong, String tenPhong, double giaPhong, int sucChua, double chieuRong, double chieuDai,
      String tenTV, String tenBan, String tenSofa, int soLuongSofa, int soLuongLoa, TrangThaiPhongEnum ttPhong,
      LoaiPhongEnum loaiPhong, int soLanDatTruoc) {
    this.maPhong = maPhong;
    this.tenPhong = tenPhong;
    this.giaPhong = giaPhong;
    this.sucChua = sucChua;
    this.chieuRong = chieuRong;
    this.chieuDai = chieuDai;
    this.tenTV = tenTV;
    this.tenBan = tenBan;
    this.tenSofa = tenSofa;
    this.soLuongSofa = soLuongSofa;
    this.soLuongLoa = soLuongLoa;
    this.ttPhong = ttPhong;
    this.loaiPhong = loaiPhong;
    this.soLanDatTruoc = soLanDatTruoc;
  }

  public Phong(String tenPhong, double giaPhong) {
    super();
    this.tenPhong = tenPhong;
    this.giaPhong = giaPhong;
  }

  public String getMaPhong() {
    return maPhong;
  }

  public void setMaPhong(String maPhong) {
    this.maPhong = maPhong;
  }

  public String getTenPhong() {
    return tenPhong;
  }

  public void setTenPhong(String tenPhong) {
    if (tenPhong.isEmpty()) {
      try {
        throw new Exception("Tên phòng không hợp lệ");
      } catch (Exception e) {
        e.printStackTrace();
      }
    } else
      this.tenPhong = tenPhong;
  }

  public double getgiaPhong() {
    return giaPhong;
  }

  public void setgiaPhong(double giaPhong) {
    if (giaPhong < 0) {
      try {
        throw new Exception("Giá phòng phải lớn hơn 0");
      } catch (Exception e) {
        e.printStackTrace();
      }
    } else
      this.giaPhong = giaPhong;
  }

  public int getSucChua() {
    return sucChua;
  }

  public void setSucChua(int sucChua) {
    if (sucChua < 0)
      try {
        throw new Exception("Sức chứa phải lớn hơn 0");
      } catch (Exception e) {
        e.printStackTrace();
      }
    else
      this.sucChua = sucChua;
  }

  public double getChieuRong() {
    return chieuRong;
  }

  public void setChieuRong(double chieuRong) {
    if (chieuRong < 0)
      try {
        throw new Exception("Chiều rộng phải lớn hơn 0");
      } catch (Exception e) {
        e.printStackTrace();
      }
    else
      this.chieuRong = chieuRong;
  }

  public double getchieuDai() {
    return chieuDai;
  }

  public void setchieuDai(double chieuDai) {
    if (chieuDai < 0)
      try {
        throw new Exception("Chiều dài phải lớn hơn 0");
      } catch (Exception e) {
        e.printStackTrace();
      }
    else
      this.chieuDai = chieuDai;
  }

  public String getTenTV() {
    return tenTV;
  }

  public void setTenTV(String tenTV) {
    if (tenTV.isEmpty()) {
      try {
        throw new Exception("Tên TV không hợp lệ");
      } catch (Exception e) {
        e.printStackTrace();
      }
    } else
      this.tenTV = tenTV;
  }

  public String getTenBan() {
    return tenBan;
  }

  public void setTenBan(String tenBan) {
    if (tenBan.isEmpty()) {
      try {
        throw new Exception("Tên bàn không hợp lệ");
      } catch (Exception e) {
        e.printStackTrace();
      }
    } else
      this.tenBan = tenBan;
  }

  public String getTenSofa() {
    return tenSofa;
  }

  public void setTenSofa(String tenSofa) {
    if (tenSofa.isEmpty()) {
      try {
        throw new Exception("Tên sofa không hợp lệ");
      } catch (Exception e) {
        e.printStackTrace();
      }
    } else
      this.tenSofa = tenSofa;
  }

  public int getSoLuongSofa() {
    return soLuongSofa;
  }

  public void setSoLuongSofa(int soLuongSofa) {
    if (soLuongSofa < 0)
      try {
        throw new Exception("Số lượng sofa phải lớn hơn 0");
      } catch (Exception e) {
        e.printStackTrace();
      }
    else
      this.soLuongSofa = soLuongSofa;
  }

  public int getSoLuongLoa() {
    return soLuongLoa;
  }

  public void setSoLuongLoa(int soLuongLoa) {
    if (soLuongLoa < 0)
      try {
        throw new Exception("Số lượng loa phải lớn hơn 0");
      } catch (Exception e) {
        e.printStackTrace();
      }
    else
      this.soLuongLoa = soLuongLoa;
  }

  public TrangThaiPhongEnum getTtPhong() {
    return ttPhong;
  }

  public void setTtPhong(TrangThaiPhongEnum ttPhong) {
    this.ttPhong = ttPhong;
  }

  public LoaiPhongEnum getLoaiPhong() {
    return loaiPhong;
  }

  public void setLoaiPhong(LoaiPhongEnum loaiPhong) {
    this.loaiPhong = loaiPhong;
  }

  public double getGiaPhong() {
    return giaPhong;
  }

  public void setGiaPhong(double giaPhong) {
    this.giaPhong = giaPhong;
  }

  public int getSoLanDatTruoc() {
    return soLanDatTruoc;
  }

  public void setSoLanDatTruoc(int soLanDatTruoc) {
    this.soLanDatTruoc = soLanDatTruoc;
  }

  @Override
  public String toString() {
    return "Phong [maPhong=" + maPhong + ", tenPhong=" + tenPhong + ", giaPhong=" + giaPhong + ", sucChua=" + sucChua
        + ", chieuRong=" + chieuRong + ", chieuDai=" + chieuDai + ", tenTV=" + tenTV + ", tenBan=" + tenBan
        + ", tenSofa="
        + tenSofa + ", soLuongSofa=" + soLuongSofa + ", soLuongLoa=" + soLuongLoa + ", soLanDatTruoc=" + soLanDatTruoc
        + ", ttPhong=" + ttPhong + ", loaiPhong=" + loaiPhong + "]";
  }

}
