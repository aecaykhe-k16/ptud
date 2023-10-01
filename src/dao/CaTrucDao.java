package dao;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

import entities.CaTruc;
import entities.ChiTietCaTruc;
import entities.NhanVien;
import util.ConnectDB;

public class CaTrucDao {

  public List<CaTruc> getCaTruc() {
    ConnectDB.getInstance();
    Connection con = ConnectDB.getConnection();
    List<CaTruc> dsCaTruc = new ArrayList<CaTruc>();
    try {
      String sql = "SELECT * from CaTruc";
      Statement st = con.createStatement();
      ResultSet rs = st.executeQuery(sql);
      while (rs.next()) {
        CaTruc caTruc = new CaTruc(rs.getString(1), rs.getString(2));
        dsCaTruc.add(caTruc);
      }
    } catch (Exception e) {
      e.printStackTrace();
    }
    return dsCaTruc;
  }

  public List<ChiTietCaTruc> getDsCTCaTruc() {
    ConnectDB.getInstance();
    Connection con = ConnectDB.getConnection();
    List<ChiTietCaTruc> dsCaTruc = new ArrayList<ChiTietCaTruc>();
    try {
      String sql = "SELECT *\n"
          + "FROM     CaTruc INNER JOIN\n"
          + "                  ChiTietCaTruc ON CaTruc.maCaTruc = ChiTietCaTruc.maCaTruc INNER JOIN\n"
          + "                  NhanVien ON ChiTietCaTruc.maNV = NhanVien.maNV";

      Statement st = con.createStatement();
      ResultSet rs = st.executeQuery(sql);
      while (rs.next()) {
        String ngayTrucString = rs.getDate("ngayPhanCa").toString();
        LocalDate localDate1 = LocalDate.parse(ngayTrucString, DateTimeFormatter.ofPattern("yyyy-MM-dd"));

        CaTruc caTruc = new CaTruc(rs.getString("maCaTruc"), rs.getString("thoiGianCaTruc"));

        ChiTietCaTruc chiTietCaTruc = new ChiTietCaTruc(localDate1, rs.getString("trangThaiCaTruc"));

        NhanVien nv = new NhanVien();
        nv.setMaNV(rs.getString("maNV"));
        nv.setTenNV(rs.getString("tenNV"));

        chiTietCaTruc.setNv(nv);
        chiTietCaTruc.setCaTruc(caTruc);

        dsCaTruc.add(chiTietCaTruc);
      }
    } catch (Exception e) {
      e.printStackTrace();
    }
    return dsCaTruc;
  }

  public List<ChiTietCaTruc> getDsCTCT() {
    ConnectDB.getInstance();
    Connection con = ConnectDB.getConnection();
    List<ChiTietCaTruc> dsCaTruc = new ArrayList<ChiTietCaTruc>();
    try {
      String sql = "select * from ChiTietCaTruc";

      Statement st = con.createStatement();
      ResultSet rs = st.executeQuery(sql);
      while (rs.next()) {
        String ngayTrucString = rs.getDate("ngayPhanCa").toString();
        LocalDate localDate1 = LocalDate.parse(ngayTrucString, DateTimeFormatter.ofPattern("yyyy-MM-dd"));

        CaTruc caTruc = new CaTruc();
        caTruc.setMaCaTruc(rs.getString("maCaTruc"));

        ChiTietCaTruc chiTietCaTruc = new ChiTietCaTruc(localDate1, rs.getString("trangThaiCaTruc"));

        NhanVien nv = new NhanVien();
        nv.setMaNV(rs.getString("maNV"));

        chiTietCaTruc.setNv(nv);
        chiTietCaTruc.setCaTruc(caTruc);

        dsCaTruc.add(chiTietCaTruc);
      }
    } catch (Exception e) {
      e.printStackTrace();
    }
    return dsCaTruc;
  }

  public boolean themChiTietCaTruc(ChiTietCaTruc chiTietCT) {
    ConnectDB.getInstance();
    Connection con = ConnectDB.getConnection();
    PreparedStatement pst = null;
    int n = 0;

    try {

      String sql = "insert into ChiTietCaTruc values(?,?,?,?)";
      pst = con.prepareStatement(sql);

      pst.setString(1, chiTietCT.getTrangThaiCaTruc().trim());
      pst.setDate(2, Date.valueOf(chiTietCT.getNgayPhanCa()));
      pst.setString(3, chiTietCT.getNv().getMaNV().trim());
      pst.setString(4, chiTietCT.getCaTruc().getMaCaTruc().trim());

      n = pst.executeUpdate();
    } catch (SQLException e) {
      e.printStackTrace();
    }
    return n > 0;
  }

  public boolean capNhatChiTietCaTruc(ChiTietCaTruc chiTietCT, String maCT, String maNV) {
    ConnectDB.getInstance();
    Connection con = ConnectDB.getConnection();
    PreparedStatement pst = null;
    int n = 0;

    try {
      String sql = "update ChiTietCaTruc set ngayPhanCa=?,maNV=?,maCaTruc=? where maCaTruc=? and maNV=?";
      pst = con.prepareStatement(sql);

      pst.setDate(1, Date.valueOf(chiTietCT.getNgayPhanCa()));
      pst.setString(2, chiTietCT.getNv().getMaNV().trim());
      pst.setString(3, chiTietCT.getCaTruc().getMaCaTruc().trim());

      pst.setString(4, maCT);
      pst.setString(5, maNV);

      n = pst.executeUpdate();
    } catch (SQLException e) {
      e.printStackTrace();
    } finally {
      try {
        pst.close();
      } catch (SQLException e) {
        e.printStackTrace();
      }
    }
    return n > 0;
  }

  /**
   * theem moi ca truc
   *
   * @param chiTietCT
   * @return
   */
  public boolean themCaTruc(CaTruc caTruc) {
    ConnectDB.getInstance();
    Connection con = ConnectDB.getConnection();
    PreparedStatement pst = null;
    int n = 0;
    try {
      String sql = "insert into CaTruc values(?,?)";
      pst = con.prepareStatement(sql);

      pst.setString(1, caTruc.getMaCaTruc().trim());
      pst.setString(2, caTruc.getThoiGianCaTruc().trim());

      n = pst.executeUpdate();
    } catch (SQLException e) {

      e.printStackTrace();
    } finally {
      try {
        pst.close();
      } catch (SQLException e) {

        e.printStackTrace();
      }
    }
    return n > 0;
  }

  public List<CaTruc> timCaTrucTheoNhanVien(String email) {
    List<CaTruc> dsCaTruc = new ArrayList<CaTruc>();
    ConnectDB.getInstance();
    Connection con = ConnectDB.getConnection();
    String sql = "SELECT    ChiTietCaTruc.maCaTruc, ChiTietCaTruc.ngayPhanCa " +
        "FROM    ChiTietCaTruc JOIN " +
        "NhanVien ON ChiTietCaTruc.maNV = NhanVien.maNV JOIN " +
        "TaiKhoan ON NhanVien.emailDangNhap = TaiKhoan.email " +
        "Where  TaiKhoan.email = ?";
    try {
      PreparedStatement pst = con.prepareStatement(sql);
      pst.setString(1, email);
      ResultSet rs = pst.executeQuery();
      while (rs.next()) {
        CaTruc caTruc = new CaTruc(rs.getString("maCaTruc"), rs.getString("ngayPhanCa"));
        dsCaTruc.add(caTruc);

      }
    } catch (SQLException e) {
      e.printStackTrace();
    }
    return dsCaTruc;
  }

  /**
   * xóa ca trực
   *
   * @param tenNV
   * @param ca
   */
  public void xoaChiTietCaTruc(String maCaTruc, String maNV) {
    ConnectDB.getInstance();
    PreparedStatement pst = null;
    Connection con = ConnectDB.getConnection();

    String sql = "delete ChiTietCaTruc where maCaTruc=? and maNV=?";
    try {
      pst = con.prepareStatement(sql);
      pst.setString(1, maCaTruc);
      pst.setString(2, maNV);
      pst.executeUpdate();
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      close(pst);
    }
  }

  /**
   * close sql
   *
   * @param pst
   */
  private void close(PreparedStatement pst) {
    if (pst != null) {
      try {
        pst.close();
      } catch (Exception e) {
        e.printStackTrace();
      }
    }
  }
}