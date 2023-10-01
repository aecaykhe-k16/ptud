package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import entities.NhanVien;
import entities.TaiKhoan;
import util.ConnectDB;

public class DangNhapDao {

  public boolean login(TaiKhoan tk) {
    ConnectDB.getInstance();
    Connection con = ConnectDB.getConnection();
    PreparedStatement pst = null;
    try {
      String sql = "SELECT * FROM TaiKhoan WHERE email = ? AND matKhau = ?";
      pst = con.prepareStatement(sql);
      pst.setString(1, tk.getEmail());
      pst.setString(2, tk.getMatKhau());
      ResultSet rs = pst.executeQuery();
      while (rs.next()) {
        return true;
      }
    } catch (Exception e) {
      e.printStackTrace();
    }

    return false;
  }

  public boolean doiMK(TaiKhoan taiKhoan) {
    ConnectDB.getInstance();
    Connection con = ConnectDB.getConnection();
    PreparedStatement pst = null;
    try {
      String sql = "UPDATE TaiKhoan SET matKhau = ? WHERE email = ?";
      pst = con.prepareStatement(sql);
      pst.setString(1, taiKhoan.getMatKhau());
      pst.setString(2, taiKhoan.getEmail());
      int rs = pst.executeUpdate();
      if (rs > 0) {
        return true;
      }
    } catch (Exception e) {
      e.printStackTrace();
    }

    return false;
  }

  public NhanVien getNV(String email) {
    ConnectDB.getInstance();
    Connection con = ConnectDB.getConnection();
    PreparedStatement pst = null;
    try {
      String sql = "SELECT * FROM NhanVien WHERE emailDangNhap = ?";

      pst = con.prepareStatement(sql);
      pst.setString(1, email);
      ResultSet rs = pst.executeQuery();
      while (rs.next()) {
        NhanVien nv = new NhanVien(rs.getString("maNV"), rs.getString("tenNV"),
            rs.getString("sdt"), rs.getDate("ngaySinh").toLocalDate(), rs.getBoolean("gioiTinh"),
            rs.getDate("ngayTuyenDung").toLocalDate(),
            rs.getString("viTriCongViec"), rs.getString("diaChi"));
        if (rs.getString("quanLyNV") != null) {
          NhanVien quanLy = new NhanVien();
          nv.setQuanLy(quanLy);
        }
        return nv;
      }
    } catch (Exception e) {
      e.printStackTrace();
    }

    return null;
  }

}
