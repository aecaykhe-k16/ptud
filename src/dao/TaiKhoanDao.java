package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;

import entities.TaiKhoan;
import util.ConnectDB;

public class TaiKhoanDao {

  public boolean themTaiKhoan(TaiKhoan tk) {

    ConnectDB.getInstance();
    Connection con = ConnectDB.getConnection();
    PreparedStatement pst = null;
    int n = 0;
    try {
      String sql = "Insert into TaiKhoan values (?, ?, ?)";
      pst = con.prepareStatement(sql);
      pst.setString(1, tk.getEmail());
      pst.setString(2, "123456");
      pst.setBoolean(3, true);

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

  public boolean xoaTaiKhoan(String email) {
    ConnectDB.getInstance();
    Connection con = ConnectDB.getConnection();
    PreparedStatement pst = null;
    int n = 0;
    try {
      String sql = "update  TaiKhoan set trangThai = 0 where email= ?";
      pst = con.prepareStatement(sql);
      pst.setString(1, email);
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

  public boolean suaMatKhau(TaiKhoan tk) {
    ConnectDB.getInstance();
    Connection con = ConnectDB.getConnection();
    PreparedStatement pst = null;
    int n = 0;
    try {
      String sql = "update TaiKhoan set matKhau=?  where email=?";

      pst = con.prepareStatement(sql);
      pst.setString(1, tk.getMatKhau());
      pst.setString(2, tk.getEmail());

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
}