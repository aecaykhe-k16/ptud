package util;

import java.text.Normalizer;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.util.Date;
import java.util.regex.Pattern;

import entities.LoaiPhongEnum;
import entities.TrangThaiPhongEnum;

public class Generator {
  public String tuTaoMaNV(String loaiNV, int namSinh) {
    String nam = String.valueOf(namSinh);
    String year = nam.substring(2);

    String maNV = "";
    maNV += loaiNV;
    maNV += year;
    maNV += random3SoNguyen();

    return maNV;
  }

  public String tuTaoMaPhong(String loaiPhong) {
    String maPhong = "";
    maPhong += loaiPhong.startsWith("V") ? "V" : "T";
    maPhong += random3SoNguyen();
    return maPhong;
  }

  public String tuTaoMaHoaDon(String maPhong, String maNV) {
    // 16 ký tự 10T932QL97001001
    Date date = new Date();
    SimpleDateFormat formatter = new SimpleDateFormat("dd/MM/yyyy");
    String ngayLap = formatter.format(date);
    String[] day = ngayLap.split("/");
    String ngay = day[0];
    String maHD = "";
    maHD += ngay;
    maHD += maPhong.trim();
    maHD += maNV;
    maHD += random3SoNguyen();// có thể thay đổi thành mã khách hàng
    return maHD;
  }

  public String tuTaoMaDichVu() {
    return "DV" + random3SoNguyen();
  }

  public String tuTaoMaCaTruc(LocalDate ngayLapPhanCong, int caLam) {
    // split ngayLapPhanCong
    String[] arrDate = ngayLapPhanCong.toString().split("-");
    String year = arrDate[0].substring(2);
    String month = arrDate[1];
    String day = arrDate[2];

    String thuTuCaLam = caLam == 0 ? "1" : caLam == 1 ? "2" : "3";

    String[] dayOfWeek = { "Monday", "Tuesday", "Wednesday", "Thursday",
        "Friday", "Saturday", "Sunday" };
    String thuTuNgay = "";

    for (int i = 0; i < dayOfWeek.length; i++) {
      if (ngayLapPhanCong.getDayOfWeek().name().equalsIgnoreCase(dayOfWeek[i])) {
        thuTuNgay = String.valueOf(i + 2);
      }
    }

    String maCaTruc = "";
    maCaTruc += day + month + year;
    maCaTruc += thuTuNgay;
    maCaTruc += thuTuCaLam;
    return maCaTruc;
  }

  public String taoMaDichVu() {
    String maDV = "";
    maDV += "DV";
    maDV += random3SoNguyen();
    return maDV;
  }

  public String tuTaoMaDC() {
    return "DC" + random4SoNguyen();
  }

  public String tuTaoMaLoaiTV(String soDinhDanh) {
    Date date = new Date();
    SimpleDateFormat formatter = new SimpleDateFormat("dd/MM/yyyy");
    String ngayDangKy = formatter.format(date);
    String[] arrDate = ngayDangKy.split("/");
    String month = arrDate[1];
    String year = arrDate[2].substring(2);

    String maLoaiTV = "";
    maLoaiTV += soDinhDanh.substring(8);
    maLoaiTV += month + year;
    return maLoaiTV;
  }

  public String tuTaoDatPhong() {
    return "DP" + random3SoNguyen();
  }

  public int random4SoNguyen() {
    return (int) (Math.random() * 9000 + 1000);
  }

  public int random3SoNguyen() {
    return (int) (Math.random() * 900 + 100);
  }

  public String parseLocaldateToDatetimepicker(String ngay) {
    String[] monthOfYear = { "January", "February", "March", "April", "May", "June", "July", "August", "September",
        "October", "November", "December" };
    String thuTuThang = "";

    String[] arrDate = ngay.split("/");
    String month = arrDate[1];
    String day = arrDate[0];
    String year = arrDate[2];
    if (day.startsWith("0")) {
      day = day.substring(1);
    }
    if (month.startsWith("0")) {
      month = month.substring(1);
    }

    for (int i = 0; i < monthOfYear.length; i++) {
      if (month.equalsIgnoreCase(String.valueOf(i + 1))) {
        thuTuThang = monthOfYear[i];
      }
    }

    return thuTuThang + " " + day + ", " + year;
  }

  public String parseLocalDateToDate(String ngay) {
    String[] arrDate = ngay.split("-");
    String year = arrDate[0];
    String month = arrDate[1];
    String day = arrDate[2];
    if (day.startsWith("0")) {
      day = day.substring(1);
    }
    return day + "/" + month + "/" + year;
  }

  public String viToEn(String fullName) {
    String lastName = "";
    String[] arrName = fullName.split(" ");
    for (int i = 0; i < arrName.length;) {
      lastName += arrName[arrName.length - 1];
      break;
    }

    String nfdNormalizedString = Normalizer.normalize(lastName.toLowerCase(), Normalizer.Form.NFD);
    Pattern pattern = Pattern.compile("\\p{InCombiningDiacriticalMarks}+");
    return pattern.matcher(nfdNormalizedString).replaceAll("");
  }

  public String tachChuoi(String full) {
    String last = "";
    String[] arrName = full.split(" ");
    for (int i = 0; i < arrName.length;) {
      last += arrName[arrName.length - 1];
      break;
    }
    return last;
  }

  public String boDauTrongTu(String tu) {
    String nfdNormalizedString = Normalizer.normalize(tu, Normalizer.Form.NFD);
    Pattern pattern = Pattern.compile("\\p{InCombiningDiacriticalMarks}+");
    return pattern.matcher(nfdNormalizedString).replaceAll("");
  }

  public String boDauCuaTu(String full) {
    String last = tachChuoi(full);
    String nfdNormalizedString = Normalizer.normalize(last.toLowerCase(),
        Normalizer.Form.NFD);
    Pattern pattern = Pattern.compile("\\p{InCombiningDiacriticalMarks}+");
    return pattern.matcher(nfdNormalizedString).replaceAll("");
  }

  public String boDau(String full) {
    String nfdNormalizedString = Normalizer.normalize(full.toLowerCase(), Normalizer.Form.NFD);
    Pattern pattern = Pattern.compile("\\p{InCombiningDiacriticalMarks}+");
    return pattern.matcher(nfdNormalizedString).replaceAll("");
  }

  public String convertGia(String gia) {
    String b = gia.replaceAll("\\,", "");
    String c = b.replaceAll("\\VND", "");
    return c;
  }

  public String taoEmail(String name, String maNV) {
    String email = "";
    email += viToEn(name);
    email += maNV.substring(2);
    email += "@gmail.com";

    return email;
  }

  // convert Enum to String
  public String convertLoaiPhongToString(LoaiPhongEnum e) {
    String loaiPhong = "";
    for (LoaiPhongEnum lp : LoaiPhongEnum.values()) {
      if (lp.equals(e)) {
        loaiPhong = lp.getLoaiPhong();
      }
    }
    return loaiPhong;
  }

  public String convertTTToString(TrangThaiPhongEnum e) {
    String loaiPhong = "";
    for (TrangThaiPhongEnum tt : TrangThaiPhongEnum.values()) {
      if (tt.equals(e)) {
        loaiPhong = tt.getTtrangThai();
      }
    }
    return loaiPhong;
  }

  // convert String to enum
  public LoaiPhongEnum convertStringToLoaiPhong(String loaiPhong) {
    LoaiPhongEnum lp = null;
    for (LoaiPhongEnum l : LoaiPhongEnum.values()) {
      if (l.getLoaiPhong().equalsIgnoreCase(loaiPhong)) {
        lp = l;
      }
    }
    return lp;
  }

  public TrangThaiPhongEnum convertStringToTrangThaiPhong(String trangThai) {
    TrangThaiPhongEnum tt = null;
    for (TrangThaiPhongEnum t : TrangThaiPhongEnum.values()) {
      if (t.getTtrangThai().equalsIgnoreCase(trangThai)) {
        tt = t;
      }
    }
    return tt;
  }
}
