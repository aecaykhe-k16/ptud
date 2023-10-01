package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import entities.ChiTietDichVu;
import entities.DichVu;
import util.ConnectDB;

public class DichVuDao {
  public List<DichVu> getDichVu() {
    ConnectDB.getInstance();
    Connection con = ConnectDB.getConnection();
    PreparedStatement pst = null;
    List<DichVu> dsDichVu = new ArrayList<DichVu>();
    try {
      String sql = "select * from DichVu";

      pst = con.prepareStatement(sql);
      ResultSet rs = pst.executeQuery();
      while (rs.next()) {
        DichVu dv = new DichVu(rs.getString("maDichVu"), rs.getString("tenDichVu"),
            rs.getFloat("giaDichVu"), rs.getInt("slTon"), rs.getString("hinhAnh"));
        dsDichVu.add(dv);
      }
    } catch (Exception e) {
      e.printStackTrace();
    }
    return dsDichVu;
  }

  public boolean themDichVu(DichVu dv) {
    ConnectDB.getInstance();
    Connection con = ConnectDB.getConnection();
    PreparedStatement pst = null;
    int n = 0;
    try {
      String sql = "insert into DichVu values (?,?,?,?,?)";
      pst = con.prepareStatement(sql);
      pst.setString(1, dv.getMaDichVu());
      pst.setString(2, dv.getTenDichVu());
      pst.setDouble(3, dv.getGiaDichVu());
      pst.setInt(4, dv.getSlTon());
      pst.setString(5, dv.getHinhAnh());
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

  public boolean xoaDichVu(String maDV) {
    ConnectDB.getInstance();
    Connection con = ConnectDB.getConnection();
    PreparedStatement pst = null;
    int n = 0;
    try {
      String sql = "delete from DichVu where maDichVu= ?";
      pst = con.prepareStatement(sql);
      pst.setString(1, maDV);
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

  public boolean suaDichVu(DichVu dv) {
    ConnectDB.getInstance();
    Connection con = ConnectDB.getConnection();
    PreparedStatement pst = null;
    int n = 0;
    try {
      String sql = "update DichVu set tenDichVu= ?, giaDichVu= ?, slTon= ?  where maDichVu= ?";

      pst = con.prepareStatement(sql);
      pst.setString(1, dv.getTenDichVu());
      pst.setDouble(2, dv.getGiaDichVu());
      pst.setInt(3, dv.getSlTon());
      pst.setString(4, dv.getMaDichVu());

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

  public List<ChiTietDichVu> getCTDichVu() {
    ConnectDB.getInstance();
    Connection con = ConnectDB.getConnection();
    List<ChiTietDichVu> dsCTDV = new ArrayList<ChiTietDichVu>();
    try {
      String sql = "select * from ChiTietDichVu";
      Statement st = con.createStatement();
      ResultSet rs = st.executeQuery(sql);
      while (rs.next()) {
        ChiTietDichVu chiTietDichVu = new ChiTietDichVu(rs.getInt("soLuong"));
        chiTietDichVu.setDichVu(new DichVu(rs.getString("maDichVu")));
        dsCTDV.add(chiTietDichVu);
      }
    } catch (Exception e) {
      e.printStackTrace();
    } finally {
      try {
        con.close();
      } catch (Exception e2) {
        e2.printStackTrace();
      }
    }
    return dsCTDV;
  }

}