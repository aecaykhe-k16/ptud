package dao;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import entities.NhanVien;
import entities.TaiKhoan;
import util.ConnectDB;

public class NhanVienDao {
  public List<NhanVien> dsNV() {
    ConnectDB.getInstance();
    Connection con = ConnectDB.getConnection();
    PreparedStatement pst = null;
    List<NhanVien> dsNV = new ArrayList<NhanVien>();
    try {
      String sql = "SELECT * FROM NhanVien";

      pst = con.prepareStatement(sql);
      ResultSet rs = pst.executeQuery();
      while (rs.next()) {
        TaiKhoan tk = new TaiKhoan(rs.getString("emailDangNhap"));
        NhanVien nv = new NhanVien(rs.getString("maNV"), rs.getString("tenNV"),
            rs.getString("sdt"), rs.getDate("ngaySinh").toLocalDate(), rs.getBoolean("gioiTinh"),
            rs.getDate("ngayTuyenDung").toLocalDate(),
            rs.getString("viTriCongViec"), rs.getString("diaChi"), rs.getBoolean("trangThai"));
        nv.setTaiKhoan(tk);
        dsNV.add(nv);

      }
    } catch (Exception e) {
      e.printStackTrace();
    }
    return dsNV;
  }

  public boolean themNhanVien(NhanVien nv) {
    Date ngaySinh = Date.valueOf(nv.getNgaySinh());
    Date ngayTuyenDung = Date.valueOf(nv.getNgayTuyenDung());
    ConnectDB.getInstance();
    Connection con = ConnectDB.getConnection();
    PreparedStatement pst = null;
    int n = 0;
    try {
      String sql = "INSERT INTO NhanVien(maNV, tenNV, sdt, ngaySinh, gioiTinh, ngayTuyenDung, viTriCongViec, diaChi, emailDangNhap,trangThai) VALUES(?,?,?,?,?,?,?,?,?,?)";
      pst = con.prepareStatement(sql);
      pst.setString(1, nv.getMaNV());
      pst.setString(2, nv.getTenNV());
      pst.setString(3, nv.getSdt());
      pst.setDate(4, ngaySinh);
      pst.setBoolean(5, nv.getGioiTinh());
      pst.setDate(6, ngayTuyenDung);
      pst.setString(7, nv.getViTriCongViec());
      pst.setString(8, nv.getDiaChi());
      pst.setString(9, nv.getTaiKhoan().getEmail());
      pst.setBoolean(10, true);

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

  public boolean xoaNhanVien(String manv) {
    ConnectDB.getInstance();
    Connection con = ConnectDB.getConnection();
    PreparedStatement pst = null;
    int n = 0;
    try {
      String sql = "UPDATE NhanVien SET trangThai = 0 WHERE maNV = ?";
      pst = con.prepareStatement(sql);
      pst.setString(1, manv);
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

  public boolean suaNhanVien(NhanVien nv) {
    ConnectDB.getInstance();
    Connection con = ConnectDB.getConnection();
    PreparedStatement pst = null;
    int n = 0;
    try {
      String sql = "";
      if (nv.getViTriCongViec().startsWith("Q")) {
        sql = "UPDATE NhanVien SET tenNV = ?, sdt = ?, ngaySinh = ?, gioiTinh = ?, ngayTuyenDung = ?, viTriCongViec = ?, diaChi = ?, quanLyNV = ? WHERE maNV = ?";
      } else {
        sql = "UPDATE NhanVien SET tenNV = ?, sdt = ?, ngaySinh = ?, gioiTinh = ?, ngayTuyenDung = ?, viTriCongViec = ?, diaChi = ? WHERE maNV = ?";
      }

      pst = con.prepareStatement(sql);
      pst.setString(1, nv.getTenNV());
      pst.setString(2, nv.getSdt());
      pst.setDate(3, Date.valueOf(nv.getNgaySinh()));
      pst.setBoolean(4, nv.getGioiTinh());
      pst.setDate(5, Date.valueOf(nv.getNgayTuyenDung()));
      pst.setString(6, nv.getViTriCongViec());
      pst.setString(7, nv.getDiaChi());
      if (nv.getViTriCongViec().startsWith("Q")) {
        pst.setString(8, nv.getMaNV());
        pst.setString(9, nv.getMaNV());
      } else {
        pst.setString(8, nv.getMaNV());
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
}