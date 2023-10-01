package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import entities.LoaiPhongEnum;
import entities.Phong;
import entities.TrangThaiPhongEnum;
import util.ConnectDB;

public class PhongDao {
  public List<Phong> dsPhong() {
    ConnectDB.getInstance();
    Connection con = ConnectDB.getConnection();
    PreparedStatement pst = null;
    List<Phong> dsPhong = new ArrayList<Phong>();
    try {
      String sql = "SELECT * FROM Phong";
      pst = con.prepareStatement(sql);
      ResultSet rs = pst.executeQuery();
      while (rs.next()) {
        Phong phong = new Phong(
            rs.getString("maPhong"),
            rs.getString("tenPhong"),
            rs.getDouble("giaPhong"),
            rs.getInt("sucChua"),
            rs.getDouble("chieuRong"),
            rs.getDouble("chieuDai"),
            rs.getString("tivi"),
            rs.getString("ban"),
            rs.getString("tenSofa"),
            rs.getInt("slSofa"),
            rs.getInt("slLoa"),
            rs.getString("ttPhong").trim().equals("TRONG") ? TrangThaiPhongEnum.TRONG
                : rs.getString("ttPhong").trim().equals("HOAT_DONG") ? TrangThaiPhongEnum.HOAT_DONG
                    : TrangThaiPhongEnum.DAT_TRUOC,
            rs.getString("loaiPhong").trim().equals("VIP") ? LoaiPhongEnum.VIP : LoaiPhongEnum.THUONG,
            rs.getInt("soLanDatTruoc"));
        dsPhong.add(phong);
      }
    } catch (Exception e) {
      e.printStackTrace();
    }
    return dsPhong;
  }

  public boolean themPhong(Phong phong) {
    ConnectDB.getInstance();
    Connection con = ConnectDB.getConnection();
    PreparedStatement pst = null;
    int n = 0;
    try {
      String sql = "INSERT INTO Phong VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?)";
      pst = con.prepareStatement(sql);
      pst.setString(1, phong.getMaPhong());
      pst.setString(2, phong.getTenPhong());
      pst.setDouble(3, phong.getgiaPhong());
      pst.setInt(4, phong.getSucChua());
      pst.setDouble(5, phong.getChieuRong());
      pst.setDouble(6, phong.getchieuDai());
      pst.setString(7, phong.getTenTV());
      pst.setString(8, phong.getTenBan());
      pst.setString(9, phong.getTenSofa());
      pst.setInt(10, phong.getSoLuongSofa());
      pst.setInt(11, phong.getSoLuongLoa());
      pst.setString(12, phong.getLoaiPhong().name());
      pst.setString(13, phong.getTtPhong().name());
      pst.setInt(14, 0);

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

  public boolean xoaPhong(String maPhong) {
    ConnectDB.getInstance();
    Connection con = ConnectDB.getConnection();
    PreparedStatement pst = null;
    int n = 0;
    try {
      String sql = "DELETE FROM Phong WHERE maPhong = ?";
      pst = con.prepareStatement(sql);
      pst.setString(1, maPhong);
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

  public boolean suaPhong(Phong phong) {
    ConnectDB.getInstance();
    Connection con = ConnectDB.getConnection();
    PreparedStatement pst = null;
    int n = 0;
    try {
      String sql = "UPDATE Phong SET tenPhong = ?, giaPhong = ?, sucChua = ?, chieuRong = ?, chieuDai = ?, tivi = ?, ban = ?, tenSofa = ?, slSofa = ?, slLoa = ?, loaiPhong = ?, ttPhong = ? WHERE maPhong = ?";
      pst = con.prepareStatement(sql);
      pst.setString(1, phong.getTenPhong());
      pst.setDouble(2, phong.getgiaPhong());
      pst.setInt(3, phong.getSucChua());
      pst.setDouble(4, phong.getChieuRong());
      pst.setDouble(5, phong.getchieuDai());
      pst.setString(6, phong.getTenTV());
      pst.setString(7, phong.getTenBan());
      pst.setString(8, phong.getTenSofa());
      pst.setInt(9, phong.getSoLuongSofa());
      pst.setInt(10, phong.getSoLuongLoa());
      pst.setString(11, phong.getLoaiPhong().name());
      pst.setString(12, phong.getTtPhong().name());
      pst.setString(13, phong.getMaPhong());
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

  public boolean updateStatus(String maPhong, String ttPhong) {
    ConnectDB.getInstance();
    Connection con = ConnectDB.getConnection();
    PreparedStatement pst = null;
    try {
      String sql = "UPDATE Phong SET ttPhong = ? WHERE maPhong = ?";

      pst = con.prepareStatement(sql);
      pst.setString(1, ttPhong);
      pst.setString(2, maPhong);
      pst.executeUpdate();
      return true;
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      try {
        pst.close();
      } catch (Exception e2) {
        e2.printStackTrace();
      }
    }
    return false;
  }

  public void updateSoLanDatTruoc(String maPhong) {
    ConnectDB.getInstance();
    Connection con = ConnectDB.getConnection();
    PreparedStatement pst = null;
    try {
      String sql = "UPDATE Phong SET soLanDatTruoc = soLanDatTruoc - 1  WHERE maPhong = ?";

      pst = con.prepareStatement(sql);
      pst.setString(1, maPhong);
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
}
