package entities;

public class CaTruc {
  /**
   * attributes
   */
  private String maCaTruc;
  private String thoiGianCaTruc;

  public CaTruc() {
    super();
  }

  public CaTruc(String maCaTruc, String thoiGianCaTruc) {
    super();
    this.maCaTruc = maCaTruc;
    this.thoiGianCaTruc = thoiGianCaTruc;
  }

  public String getMaCaTruc() {
    return maCaTruc;
  }

  public void setMaCaTruc(String maCaTruc) {
    this.maCaTruc = maCaTruc;
  }

  public String getThoiGianCaTruc() {
    return thoiGianCaTruc;
  }

  public void setThoiGianCaTruc(String thoiGianCaTruc) {
    this.thoiGianCaTruc = thoiGianCaTruc;
  }

  @Override
  public String toString() {
    return "CaTruc [maCaTruc=" + maCaTruc + ", thoiGianCaTruc=" + thoiGianCaTruc + "]";
  }

}
