package dao;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

import entities.KhachHang;
import entities.LoaiThanhVien;
import util.ConnectDB;

public class KhachHangDao {
  public List<KhachHang> dsKh() {
    ConnectDB.getInstance();
    Connection con = ConnectDB.getConnection();
    PreparedStatement pst = null;
    List<KhachHang> dsKhachHang = new ArrayList<KhachHang>();
    try {
      String sql = "SELECT * FROM KhachHang INNER JOIN LoaiThanhVien ON KhachHang.maKH = LoaiThanhVien.maKH";

      pst = con.prepareStatement(sql);
      ResultSet rs = pst.executeQuery();
      while (rs.next()) {
        LoaiThanhVien loaiThanhVien = new LoaiThanhVien();
        if (rs.getString("tenLoaiTV") == null) {
          loaiThanhVien.setMaLoaiTV("");
          loaiThanhVien.setTenLoaiTV("Không có");
        } else {
          loaiThanhVien = new LoaiThanhVien(rs.getString("maLoaiTV"), rs.getString("tenLoaiTV"),
              rs.getInt("uuDai"), rs.getDate("ngayDangKy").toLocalDate(), rs.getDate("ngayHetHan").toLocalDate(),
              rs.getString("soDinhDanh"));
        }
        KhachHang khachHang = new KhachHang(rs.getString("maKH"), rs.getString("tenKH"),
            rs.getString("sdt"), rs.getBoolean("gioiTinh"), rs.getString("diaChi"), rs.getBoolean("trangThai"));
        khachHang.setLoaiTV(loaiThanhVien);
        dsKhachHang.add(khachHang);
      }
    } catch (Exception e) {
      e.printStackTrace();
    }
    return dsKhachHang;
  }

  public boolean themKH(KhachHang kh) {
    ConnectDB.getInstance();
    Connection con = ConnectDB.getConnection();
    PreparedStatement pst = null;
    int n = 0;
    try {
      String sql = "INSERT INTO KhachHang VALUES(?,?,?,?,?,?)";
      pst = con.prepareStatement(sql);
      pst.setString(1, kh.getMaKH());
      pst.setString(2, kh.getTenKH());
      pst.setString(3, kh.getSdt());
      if (kh.getGioiTinh() == null) {
        pst.setNull(4, java.sql.Types.BOOLEAN);
      } else {
        pst.setBoolean(4, kh.getGioiTinh());
      }
      if (kh.getDiaChi() == null) {
        pst.setNull(5, java.sql.Types.VARCHAR);
      } else {
        pst.setString(5, kh.getDiaChi());
      }
      pst.setBoolean(6, kh.isTrangThai());
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

  public boolean themLoaiThanhVien(KhachHang kh) {

    LocalDate ngaydangky = LocalDate.now();
    LocalDate ngayhethan = ngaydangky.plusYears(1);
    ConnectDB.getInstance();
    Connection con = ConnectDB.getConnection();
    PreparedStatement pst = null;
    int n = 0;
    try {
      String sql = "INSERT INTO dbo.LoaiThanhVien(maLoaiTV,tenLoaiTV,uuDai,ngayDangKy,ngayHetHan,\r\n"
          + "soDinhDanh, maKH)VALUES(?,?,?,?,?,?,?)";
      pst = con.prepareStatement(sql);
      if (kh.getLoaiTV().getMaLoaiTV().equals("")) {
        pst.setString(1, kh.getLoaiTV().getMaLoaiTV());
        pst.setNull(2, java.sql.Types.VARCHAR);
        pst.setNull(3, java.sql.Types.VARCHAR);
        pst.setNull(4, java.sql.Types.VARCHAR);
        pst.setNull(5, java.sql.Types.VARCHAR);
        pst.setNull(6, java.sql.Types.VARCHAR);
        pst.setString(7, kh.getMaKH());
      } else {
        pst.setString(1, kh.getLoaiTV().getMaLoaiTV());
        pst.setString(2, kh.getLoaiTV().getTenLoaiTV());
        pst.setInt(3, kh.getLoaiTV().getUuDai());
        pst.setDate(4, Date.valueOf(ngaydangky));
        pst.setDate(5, Date.valueOf(ngayhethan));
        pst.setString(6, kh.getLoaiTV().getSoDinhDanh());
        pst.setString(7, kh.getMaKH());

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

  public boolean capNhatLoaiTV(KhachHang kh) {
    ConnectDB.getInstance();
    Connection con = ConnectDB.getConnection();
    PreparedStatement pst = null;
    int n = 0;
    try {
      String sql = "UPDATE LoaiThanhVien SET tenLoaiTV = ?, uuDai = ? FROM KhachHang INNER JOIN LoaiThanhVien ON KhachHang.maKH = LoaiThanhVien.maKH where LoaiThanhVien.maKH = ?";

      pst = con.prepareStatement(sql);
      pst.setString(1, kh.getLoaiTV().getTenLoaiTV());
      pst.setInt(2, kh.getLoaiTV().getUuDai());
      pst.setString(3, kh.getMaKH());
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

  public boolean xoaKH(String maKH) {
    ConnectDB.getInstance();
    Connection con = ConnectDB.getConnection();
    PreparedStatement pst = null;
    int n = 0;
    try {
      String sql = "UPDATE dbo.KhachHang SET trangThai =0 WHERE maKH = ?";
      pst = con.prepareStatement(sql);
      pst.setString(1, maKH);
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

  public boolean suaKhachHang(KhachHang kh) {
    ConnectDB.getInstance();
    Connection con = ConnectDB.getConnection();
    PreparedStatement pst = null;
    int n = 0;
    try {
      String sql = "UPDATE KhachHang SET tenKH = ?, sdt = ?, gioiTinh = ?, diaChi = ? WHERE maKH = ?";
      pst = con.prepareStatement(sql);
      pst.setString(1, kh.getTenKH());
      pst.setString(2, kh.getSdt());
      pst.setBoolean(3, kh.getGioiTinh());
      pst.setString(4, kh.getDiaChi());
      pst.setString(5, kh.getMaKH());

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
