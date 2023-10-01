package dao;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.sql.Types;
import java.time.ZoneId;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import entities.ChiTietDichVu;
import entities.ChiTietHoaDon;
import entities.DichVu;
import entities.HoaDon;
import entities.KhachHang;
import entities.NhanVien;
import entities.Phong;
import util.ConnectDB;

public class HoaDonDao {

  public List<HoaDon> dsHDChiTietVangLai() {
    ConnectDB.getInstance();
    Connection con = ConnectDB.getConnection();
    PreparedStatement pst = null;
    List<HoaDon> dsHD = new ArrayList<HoaDon>();
    try {

      String sql = "select * from view_hoaDonVangLai";

      pst = con.prepareStatement(sql);
      ResultSet rs = pst.executeQuery();
      while (rs.next()) {
        List<ChiTietDichVu> dsCTDV = new ArrayList<ChiTietDichVu>();
        List<ChiTietHoaDon> dsCTHD = new ArrayList<ChiTietHoaDon>();
        NhanVien nv = new NhanVien();
        nv.setTenNV(rs.getString("tenNV"));
        DichVu dv = new DichVu(rs.getString("tenDichVu").trim(),
            rs.getDouble("giaDichVu"));
        ChiTietDichVu ctDV = new ChiTietDichVu(rs.getInt("soLuong"));
        ctDV.setDichVu(dv);
        Phong phong = new Phong(
            rs.getString("tenPhong").trim(),
            rs.getDouble("giaPhong"));
        ChiTietHoaDon ctHD = new ChiTietHoaDon(rs.getInt("thoiGianSuDung"));
        ctHD.setPhong(phong);
        HoaDon hd = new HoaDon(rs.getString("maHD").trim(), rs.getTimestamp("ngayLapHD").toLocalDateTime());
        dsCTDV.add(ctDV);
        dsCTHD.add(ctHD);
        hd.setCTDV(dsCTDV);
        hd.setCTHD(dsCTHD);
        hd.setNhanVien(nv);
        dsHD.add(hd);
      }

    } catch (Exception e) {
      e.printStackTrace();
    }
    return dsHD;
  }

  public List<HoaDon> dsHDChiTiet() {
    ConnectDB.getInstance();
    Connection con = ConnectDB.getConnection();
    PreparedStatement pst = null;
    List<HoaDon> dsHD = new ArrayList<HoaDon>();
    try {

      String sql = "select * from view_hoaDonChiTiet";

      pst = con.prepareStatement(sql);
      ResultSet rs = pst.executeQuery();
      while (rs.next()) {
        List<ChiTietDichVu> dsCTDV = new ArrayList<ChiTietDichVu>();
        List<ChiTietHoaDon> dsCTHD = new ArrayList<ChiTietHoaDon>();
        NhanVien nv = new NhanVien();
        nv.setTenNV(rs.getString("tenNV"));
        DichVu dv = new DichVu(rs.getString("tenDichVu").trim(),
            rs.getDouble("giaDichVu"));
        ChiTietDichVu ctDV = new ChiTietDichVu(rs.getInt("soLuong"));
        ctDV.setDichVu(dv);
        Phong phong = new Phong(
            rs.getString("tenPhong").trim(),
            rs.getDouble("giaPhong"));
        phong.setMaPhong(rs.getString("maPhong"));
        ChiTietHoaDon ctHD = new ChiTietHoaDon(rs.getInt("thoiGianSuDung"));
        ctHD.setPhong(phong);
        KhachHang kh = new KhachHang();
        kh.setTenKH(rs.getString("tenKH"));
        kh.setMaKH(rs.getString("maKH"));
        HoaDon hd = new HoaDon(rs.getString("maHD").trim(), rs.getTimestamp("ngayLapHD").toLocalDateTime());
        dsCTDV.add(ctDV);
        dsCTHD.add(ctHD);
        hd.setCTDV(dsCTDV);
        hd.setCTHD(dsCTHD);
        hd.setNhanVien(nv);
        hd.setKhachHang(kh);
        dsHD.add(hd);
      }

    } catch (Exception e) {
      e.printStackTrace();
    }
    return dsHD;
  }

  public List<HoaDon> dsChiTietTheoTen() {
    ConnectDB.getInstance();
    Connection con = ConnectDB.getConnection();
    PreparedStatement pst = null;
    List<HoaDon> dsHD = new ArrayList<HoaDon>();
    try {

      String sql = "select * from view_ChiTietDV";
      pst = con.prepareStatement(sql);
      ResultSet rs = pst.executeQuery();
      while (rs.next()) {
        List<ChiTietDichVu> dsCTDV = new ArrayList<ChiTietDichVu>();
        List<ChiTietHoaDon> dsCTHD = new ArrayList<ChiTietHoaDon>();
        DichVu dv = new DichVu(rs.getString("tenDichVu").trim(),
            rs.getDouble("giaDichVu"));
        dv.setMaDichVu(rs.getString("maDichVu"));
        ChiTietDichVu ctDV = new ChiTietDichVu(rs.getInt("soLuong"));
        ctDV.setDichVu(dv);
        Phong phong = new Phong(
            rs.getString("tenPhong").trim(),
            rs.getDouble("giaPhong"));
        phong.setMaPhong(rs.getString("maPhong"));
        ChiTietHoaDon ctHD = new ChiTietHoaDon(rs.getInt("thoiGianSuDung"));
        ctHD.setPhong(phong);
        HoaDon hd = new HoaDon(rs.getString("maHD").trim(), rs.getTimestamp("ngayLapHD").toLocalDateTime());
        dsCTDV.add(ctDV);
        dsCTHD.add(ctHD);
        hd.setCTDV(dsCTDV);
        hd.setCTHD(dsCTHD);
        dsHD.add(hd);
      }

    } catch (Exception e) {
      e.printStackTrace();
    }
    return dsHD;
  }

  public List<HoaDon> getDsHoaDon() {
    ConnectDB.getInstance();
    Connection con = ConnectDB.getConnection();
    List<HoaDon> ds = new ArrayList<HoaDon>();

    String sql = "select * from HoaDon";

    try {
      PreparedStatement pst = con.prepareStatement(sql);
      ResultSet rs = pst.executeQuery();
      while (rs.next()) {

        HoaDon hoaDon = new HoaDon(rs.getString("maHD"), rs.getTimestamp("ngayLapHD").toLocalDateTime());

        NhanVien nhanVien = timNhanVien(rs.getString("maNhanVien"));
        hoaDon.setNhanVien(nhanVien);

        KhachHang khachHang = new KhachHang();
        if (rs.getString("maKH") == null) {
          khachHang = null;
        } else {
          khachHang.setMaKH(rs.getString("maKH"));
        }

        hoaDon.setKhachHang(khachHang);

        List<ChiTietHoaDon> dsCTHD = new ArrayList<ChiTietHoaDon>();
        ChiTietHoaDon chiTietHoaDon = timCTHD(rs.getString("maHD"));
        dsCTHD.add(chiTietHoaDon);
        hoaDon.setCTHD(dsCTHD);

        List<ChiTietDichVu> dsCTDV = new ArrayList<ChiTietDichVu>();
        dsCTDV = timCTDV(rs.getString("maHD"));
        hoaDon.setCTDV(dsCTDV);

        ds.add(hoaDon);
      }
    } catch (SQLException e) {
      e.printStackTrace();
    }

    return ds;
  }

  private List<ChiTietDichVu> timCTDV(String maHD) {
    ConnectDB.getInstance();
    Connection con = ConnectDB.getConnection();
    List<ChiTietDichVu> dsCTDV = new ArrayList<ChiTietDichVu>();

    String sql = "select * from ChiTietDichVu where maHD=?";
    try {
      PreparedStatement pst = con.prepareStatement(sql);
      pst.setString(1, maHD);

      ResultSet rs = pst.executeQuery();
      while (rs.next()) {
        DichVu dichVu = new DichVu(rs.getString("maDichVu"));
        ChiTietDichVu chiTietDichVu = new ChiTietDichVu(rs.getInt("soLuong"), dichVu);
        dsCTDV.add(chiTietDichVu);
      }
    } catch (SQLException e) {
      e.printStackTrace();
    }
    return dsCTDV;
  }

  public ChiTietHoaDon timCTHD(String maHD) {
    ConnectDB.getInstance();
    Connection con = ConnectDB.getConnection();
    ChiTietHoaDon chiTietHoaDon = new ChiTietHoaDon();
    try {

      String sql = "select * from ChiTietHoaDon where maHD=?";
      PreparedStatement pst = con.prepareStatement(sql);
      pst.setString(1, maHD);
      ResultSet rs = pst.executeQuery();
      if (rs.next()) {
        Phong phong = new Phong();
        phong.setMaPhong(rs.getString("maPhong"));
        chiTietHoaDon = new ChiTietHoaDon(rs.getInt("thoiGianSuDung"), phong);
        return chiTietHoaDon;
      }

    } catch (Exception e) {
      e.printStackTrace();
    }
    return null;
  }

  public NhanVien timNhanVien(String manv) {
    ConnectDB.getInstance();
    Connection con = ConnectDB.getConnection();
    NhanVien nhanVien = new NhanVien();
    String sql = "select * from NhanVien where maNV=?";
    try {
      PreparedStatement preparedStatement = con.prepareStatement(sql);
      preparedStatement.setString(1, manv);
      ResultSet rs = preparedStatement.executeQuery();

      if (rs.next()) {
        nhanVien = new NhanVien(rs.getString("maNv"), rs.getBoolean("trangThai"));
        return nhanVien;
      }
    } catch (SQLException e) {
      e.printStackTrace();
    }
    return null;
  }

  public boolean themHoaDon(HoaDon hoaDon) {
    ConnectDB.getInstance();
    Connection con = ConnectDB.getConnection();
    PreparedStatement pst = null;
    int n = 0;
    Timestamp ngay = new Timestamp(hoaDon.getNgayLapHD().atZone(ZoneId.systemDefault()).toInstant().toEpochMilli());

    try {
      String sql = "INSERT INTO hoaDon VALUES(?,?,?,?)";
      pst = con.prepareStatement(sql);
      pst.setString(1, hoaDon.getMaHD());
      pst.setTimestamp(2, ngay);
      pst.setString(3, hoaDon.getNhanVien().getMaNV());
      if (hoaDon.getKhachHang() != null) {
        pst.setString(4, hoaDon.getKhachHang().getMaKH());
      } else {
        pst.setNull(4, Types.VARCHAR);
      }
      n = pst.executeUpdate();
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      try {
        pst.close();
      } catch (Exception e2) {
        e2.printStackTrace();
      }
    }
    return n > 0;
  }

  public boolean themHoaDonChiTietDV(ChiTietDichVu chiTietDichVu, String maHD) {
    ConnectDB.getInstance();
    Connection con = ConnectDB.getConnection();
    PreparedStatement pst = null;
    int n = 0;
    try {
      String sql = "INSERT INTO ChiTietDichVu VALUES(?,?,?)";
      pst = con.prepareStatement(sql);
      pst.setInt(1, chiTietDichVu.getSoLuong());
      pst.setString(2, maHD);
      pst.setString(3, chiTietDichVu.getDichVu().getMaDichVu());
      n = pst.executeUpdate();
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      try {
        pst.close();
      } catch (Exception e2) {
        e2.printStackTrace();
      }
    }
    return n > 0;
  }

  public boolean themHoaDonChiTietHD(ChiTietHoaDon chiTietHoaDon, String maHD) {
    ConnectDB.getInstance();
    Connection con = ConnectDB.getConnection();
    PreparedStatement pst = null;
    int n = 0;
    try {
      String sql = "INSERT INTO ChiTietHoaDon VALUES(?,?,?)";
      pst = con.prepareStatement(sql);
      pst.setInt(1, 0);
      pst.setString(2, maHD);
      pst.setString(3, chiTietHoaDon.getPhong().getMaPhong());
      n = pst.executeUpdate();
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      try {
        pst.close();
      } catch (Exception e2) {
        e2.printStackTrace();
      }
    }
    return n > 0;
  }

  public void capNhatChiTietHoaDon(int thoiGian, String mahd) {
    ConnectDB.getInstance();
    Connection con = ConnectDB.getConnection();
    PreparedStatement pst = null;
    try {
      String sql = "UPDATE ChiTietHoaDon SET thoiGianSuDung = ? WHERE maHD = ? ";
      pst = con.prepareStatement(sql);
      pst.setInt(1, thoiGian);
      pst.setString(2, mahd);
      pst.executeUpdate();
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      try {
        pst.close();
      } catch (Exception e2) {
        e2.printStackTrace();
      }
    }

  }

  public String getMaHoaDonByPhong(String maPhong, String maNV) {
    ConnectDB.getInstance();
    Connection con = ConnectDB.getConnection();
    PreparedStatement pst = null;
    ResultSet rs = null;
    Date date = new Date(System.currentTimeMillis());
    String[] arr = date.toString().split("-");
    String ngay = arr[2];
    String thang = arr[1];
    String nam = arr[0];
    String maHD = null;
    try {
      String sql = "SELECT ma = HoaDon.maHD FROM ChiTietHoaDon INNER JOIN HoaDon ON ChiTietHoaDon.maHD = HoaDon.maHD where MONTH(ngayLapHD) = ? and DAY(ngayLapHD) = ? and YEAR(ngayLapHD) = ? and HoaDon.maNhanVien = ? and maPhong = ?";
      pst = con.prepareStatement(sql);
      pst.setString(1, thang);
      pst.setString(2, ngay);
      pst.setString(3, nam);
      pst.setString(4, maNV);
      pst.setString(5, maPhong);

      rs = pst.executeQuery();
      while (rs.next()) {
        maHD = rs.getString("ma");
      }
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      try {
        pst.close();
        rs.close();
      } catch (Exception e2) {
        e2.printStackTrace();
      }
    }
    return maHD;
  }

  public List<Map<String, Object>> dsThanhToan() {
    ConnectDB.getInstance();
    Connection con = ConnectDB.getConnection();
    PreparedStatement pst = null;
    ResultSet rs = null;
    List<Map<String, Object>> ds = new ArrayList<>();
    try {
      String sql = "SELECT * FROM view_thanhToan";
      pst = con.prepareStatement(sql);
      rs = pst.executeQuery();
      while (rs.next()) {
        Map<String, Object> map = new HashMap<>();
        map.put("maHD", rs.getString("maHD"));
        map.put("ngayLapHD", rs.getTimestamp("ngayLapHD"));
        map.put("tenPhong", rs.getString("tenPhong"));
        map.put("tenKH", rs.getString("tenKH"));
        map.put("tenNV", rs.getString("tenNV"));
        map.put("sdt", rs.getString("sdt"));
        map.put("giaPhong", rs.getDouble("giaPhong"));
        map.put("maloaiTV", rs.getString("maloaiTV"));
        map.put("maPhong", rs.getString("maPhong"));
        ds.add(map);
      }
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      try {
        pst.close();
        rs.close();
      } catch (Exception e2) {
        e2.printStackTrace();
      }
    }
    return ds;
  }
}